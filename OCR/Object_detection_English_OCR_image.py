import os
import cv2
import numpy as np
import tensorflow as tf
import sys
import matplotlib
from matplotlib import pyplot as plt
import pytesseract
import imutils
import argparse

# This is needed since the notebook is stored in the object_detection folder in my pc
sys.path.append("..")

# Import utilites
from utils import label_map_util
from utils import visualization_utils as vis_util
import crop_morphology as c_m
import correct_skew as c_s
import readtext as readtext

# Name of the directory containing the object detection module we're using
MODEL_NAME = 'inference_graph'
IMAGE_NAME = 'test9.jpg'              # a single image is used now as an example
pics = list()
ch = 0;
pytesseract.pytesseract.tesseract_cmd = r'C:\Program Files\Tesseract-OCR\tesseract.exe'

# Grab path to current working directory
CWD_PATH = os.getcwd()

# Path to frozen detection graph .pb file, which contains the model that is used
# for object detection.
PATH_TO_CKPT = os.path.join(CWD_PATH,MODEL_NAME,'frozen_inference_graph.pb')

# Path to label map file
PATH_TO_LABELS = os.path.join(CWD_PATH,'training','labelmap.pbtxt')


        

# Define input and output tensors 

PATH_TO_IMAGE = os.path.join(CWD_PATH,IMAGE_NAME)

# Number of classes the object detector can identify
NUM_CLASSES = 2

# Load the label map.

# Here we use internal utility functions, but anything that returns a
label_map = label_map_util.load_labelmap(PATH_TO_LABELS)
categories = label_map_util.convert_label_map_to_categories(label_map, max_num_classes=NUM_CLASSES, use_display_name=True)
category_index = label_map_util.create_category_index(categories)


# Loading Tensorflow model into memory.
detection_graph = tf.Graph()
with detection_graph.as_default():
    od_graph_def = tf.GraphDef()
    with tf.gfile.GFile(PATH_TO_CKPT, 'rb') as fid:
        serialized_graph = fid.read()
        od_graph_def.ParseFromString(serialized_graph)
        tf.import_graph_def(od_graph_def, name='')

    sess = tf.Session(graph=detection_graph)

# Define input and output tensors (i.e. data) for the object detection classifier

# Input tensor is the image
image_tensor = detection_graph.get_tensor_by_name('image_tensor:0')

# Output tensors are the detection boxes, scores, and classes
# Each box represents a part of the image where a particular object was detected
detection_boxes = detection_graph.get_tensor_by_name('detection_boxes:0')

# Each score represents level of confidence for each of the objects.
detection_scores = detection_graph.get_tensor_by_name('detection_scores:0')
detection_classes = detection_graph.get_tensor_by_name('detection_classes:0')

# Number of objects detected
num_detections = detection_graph.get_tensor_by_name('num_detections:0')

# Load image using OpenCV and
# expand image dimensions to have shape
image = cv2.imread(PATH_TO_IMAGE)
image_expanded = np.expand_dims(image, axis=0)

# Perform the actual detection by running the model with the image as input
(boxes, scores, classes, num) = sess.run(
    [detection_boxes, detection_scores, detection_classes, num_detections],
    feed_dict={image_tensor: image_expanded})
printcount=0;
it=0;# Number of objects detected
num_detections = detection_graph.get_tensor_by_name('num_detections:0')

# Load image using OpenCV and
# expand image dimensions to have shape
image = cv2.imread(PATH_TO_IMAGE)
image_expanded = np.expand_dims(image, axis=0)

# Perform the actual detection by running the model with the image as input
(boxes, scores, classes, num) = sess.run(
    [detection_boxes, detection_scores, detection_classes, num_detections],
    feed_dict={image_tensor: image_expanded})
printcount=0;
it=0;
boxesFiltered=[]
final_score = np.squeeze(scores)    
count = 0
for i in range(100):
    if scores is None or final_score[i] > 0.5:
            count = count + 1





printcount = printcount +1

checkingSerial=True
coordinates = vis_util.return_coordinates(
image,
np.squeeze(boxes),
np.squeeze(classes).astype(np.int32),
np.squeeze(scores),
category_index,
use_normalized_coordinates=True,
line_thickness=8,
min_score_thresh=0.5)
print(coordinates)

if(coordinates!=None):
    print(coordinates)
    print(i)
    it += 1

    x= int(coordinates[2])
    y= int(coordinates[0])
    w= int(coordinates[3])
    h= int(coordinates[1])
    roi = image[y:y+h, x:x+w]

    roi = cv2.resize(roi, None, fx=4, fy=4, interpolation=cv2.INTER_CUBIC)
    cv2.fastNlMeansDenoisingColored(roi,None,15,15,7,21)
    roi = cv2.cvtColor(roi, cv2.COLOR_BGR2GRAY)
    kernel = np.zeros((3, 3), np.uint8)
    roi = cv2.erode(roi, kernel, iterations=3)
    roi = cv2.medianBlur(roi, 3)
    roi = cv2.adaptiveThreshold(roi, 245, cv2.ADAPTIVE_THRESH_GAUSSIAN_C, cv2.THRESH_BINARY_INV, 115, 1)

    roi = cv2.medianBlur(roi, 3)


    r=0
    text = readtext.readtext(roi,r)


    print("{}\n".format(text))
    print("hello")
    if(text==None):
        text=str('')
        print("No text found")
    else:
        img2 = np.zeros((512,512,3), np.uint8)
        font = cv2.FONT_HERSHEY_SIMPLEX
        cv2.putText(img2,text,(10,500), font, 1,(255,255,255),2,cv2.LINE_AA)
        cv2.imshow("Results",img2)
        checkingSerial=False

           
#Draw the results of the detection (aka 'visulaize the results')
config = ("-l eng --oem 2 --psm 12")
text = pytesseract.image_to_string(image, config=config)
vis_util.visualize_boxes_and_labels_on_image_array(
image,
np.squeeze(boxes),
np.squeeze(classes).astype(np.int32),
np.squeeze(scores),
category_index,
use_normalized_coordinates=True,
line_thickness=8,
min_score_thresh=0.80)

# All the results have been drawn on image. Now display the image.
cv2.imshow('Object detector', image)


print("{}\n".format(text))
print(text)
# Press any key to close the image

cv2.waitKey(0)

# Clean the memory
cv2.destroyAllWindows()
