from flask import Flask, jsonify
from flask_restful import Api,Resource
from model import Encoder,Decoder
import tensorflow as tf
import os
import translator
import pickle

app = Flask(__name__)
api=Api(app)
 



@app.route('/translate')
class Translate(Resource):
    def get(self,name):
        BATCH_SIZE = 64
        units = 512
        embedding_dim = 256

        output= translator.transform("बहुत बढ़िया",input_lang,output_lang)
        print(output)
        return {"translated":output}

api.add_resource(Translate,"/translate/<string:name>")


if __name__ == '__main__':
    from translator import Lang
    with open("langs.txt",'rb') as f:
        input_lang=pickle.load(f)
        output_lang=pickle.load(f)
    app.run(debug=True)
