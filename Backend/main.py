from flask import Flask, jsonify
from flask_restful import Api,Resource
import os
import translator
import pickle
from translator import Lang
import cv2
import numpy as np
import pytesseract
from flask import url_for, send_from_directory, request
import logging, os
from werkzeug import secure_filename
from yolov3 import detect as yolo




app = Flask(__name__)
api=Api(app)
file_handler = logging.FileHandler('server.log')
app.logger.addHandler(file_handler)
app.logger.setLevel(logging.INFO)


PROJECT_HOME = os.path.dirname(os.path.realpath(__file__))
UPLOAD_FOLDER = '{}/uploads/'.format(PROJECT_HOME)
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER

def create_new_folder(local_dir):
    newpath = local_dir
    if not os.path.exists(newpath):
        os.makedirs(newpath)
    return newpath

@app.route('/upload', methods = ['POST'])
class Upload(Resource):
    def ocr(self,path,inp_lang):
        pytesseract.pytesseract.tesseract_cmd = r"C:\Program Files\Tesseract-OCR\tesseract.exe"
        img = cv2.imread(path)
        img = cv2.resize(img, None, fx=0.5, fy=0.5)
        gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
        adaptive_threshold = cv2.adaptiveThreshold(gray, 255, cv2.ADAPTIVE_THRESH_GAUSSIAN_C, cv2.THRESH_BINARY, 85, 11)
        config = "--psm 3"
        text = pytesseract.image_to_string(adaptive_threshold, config=config, lang=inp_lang)
        return text

    def post(self,mode,lang):
        app.logger.info(PROJECT_HOME)
        if request.method == 'POST' and request.files['image']:
            app.logger.info(app.config['UPLOAD_FOLDER'])
            img = request.files['image']
            img_name = secure_filename(img.filename)
            create_new_folder(app.config['UPLOAD_FOLDER'])
            saved_path = os.path.join(app.config['UPLOAD_FOLDER'], img_name)
            app.logger.info("saving {}".format(saved_path))
            img.save(saved_path)
            if mode=="ocr":
                extracted_text=self.ocr(saved_path,lang)
                print(extracted_text)
                return (extracted_text)
            elif mode=="detect":
                class_name, indx=yolo.load_data(saved_path)
                print(class_name, indx)
            return send_from_directory(app.config['UPLOAD_FOLDER'],img_name, as_attachment=True)
        else:
            return "Image not found"

 
@app.route('/translate')
class Translate(Resource):
    def unicode_to_ascii(self,s):
        return ''.join(c for c in unicodedata.normalize('NFD', s)
      if unicodedata.category(c) != 'Mn')
    def get(self,mode,lang,name):
        if mode=="language":
            if lang=="hi":
                with open("langs.txt",'rb') as f:
                    input_lang=pickle.load(f)
                    output_lang=pickle.load(f)
                print(name)
                output= translator.transform(u"{s}".format(s=name),input_lang,output_lang,"hi")
                print(output)
                return {"translated":output}
            elif lang=="nep":
                with open("langs_nep.pkl",'rb') as f:
                    input_lang=pickle.load(f)
                    output_lang=pickle.load(f)
                output= translator.transform(u"{s}".format(s=name),input_lang,output_lang,"nep")
                return {"translated":output}
                
            elif lang=="pun":
                with open("langs_pun.pkl",'rb') as f:
                    input_lang=pickle.load(f)
                    output_lang=pickle.load(f)
                output= translator.transform(u"{s}".format(s=name),input_lang,output_lang,"pun")
                return {"translated":output}
                
            else:
                return  "Sorry there seems to be an error"

        elif mode=="object":
            name = name.split("@")
            with open("diff_langs.pkl",'rb') as f:
                eng2hin=pickle.load(f)
                eng2nep=pickle.load(f)
                eng2pun=pickle.load(f)
            
            if lang=="hi":
                fin=[]
                for i in name:
                    fin.append(eng2hin[i])
                #fin=",".join(fin)
                #output = "Input Text is: "+",".join(name)+" and Output prediction is :"+fin
                return {"input":name,"output":fin}

            elif lang=="pun":
                # ind =[]
                
                fin=[]
                # for i in indx:
                #     ind.append(obj_list[i])n
                for i in name:
                    fin.append(eng2pun[i]) 
                #output = "Input Text is: "+",".join(name)+" and Output prediction is :"+",".join(fin)""
                return {"input":name,"output":fin}


            elif lang=="nep":
                fin =[]
    
                # for i in indx:
                #     ind.append(obj_list[i])
                for i in name:
                    fin.append(end2nep[i])
                """fin = ",".join(fin)
                output = "Input Text is: "+",".join(name)+" and Output prediction is :"+fin"""
                return {"input":name,"output":fin}
            else:
                return "Sorry there seems to be an error please try again"


api.add_resource(Translate,"/translate/<string:mode>/<string:lang>/<string:name>")
api.add_resource(Upload,"/upload/<string:mode>/<string:lang>")


if __name__ == '__main__':
    print("Initiated program")
    # with open("langs.txt",'rb') as f:
    #     global inp_lang,output_lang
    #     input_lang=pickle.load(f)
    #     output_lang=pickle.load(f)
    app.run(debug=True)
