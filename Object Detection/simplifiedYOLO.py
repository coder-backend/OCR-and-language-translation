from numpy import expand_dims
from keras.models import load_model
from keras.preprocessing.image import load_img
from keras.preprocessing.image import img_to_array
import numpy as np

class BoundBox:
    def __init__(self, xmin, ymin, xmax, ymax, objness = None, classes = None):
        self.classes = classes
        self.label = -1
        self.score =-1
    def get_label(self):
        if self.label ==-1:
            self.label= np.argmax(self.classess)
        return self.label
    def get_score(self):
        if self.score ==-1:
            self.score = self.classes[self.get_label()]
        return self.score
    


def load_image_pixels(filename, shape):

    image = load_img(filename)
    width, height = image.size

    image = load_img(filename, target_size=shape)

    image = img_to_array(image)

    image = image.astype('float32')
    image /= 255.0

    image = expand_dims(image, 0)
    return image, width, height

def _sigmoid(x):
    	return 1. / (1. + np.exp(-x))

def decode_netout(netout, anchors, obj_thresh, net_h, net_w):
                grid_h, grid_w = netout.shape[:2]
                nb_box = 3
                netout = netout.reshape((grid_h, grid_w, nb_box, -1))
                nb_class = netout.shape[-1] - 5
                boxes = []
                netout[..., :2]  = _sigmoid(netout[..., :2])
                netout[..., 4:]  = _sigmoid(netout[..., 4:])
                netout[..., 5:]  = netout[..., 4][..., np.newaxis] * netout[..., 5:]
                netout[..., 5:] *= netout[..., 5:] > obj_thresh
            
                for i in range(grid_h*grid_w):
                    row = i / grid_w
                    col = i % grid_w
                    for b in range(nb_box):
                        objectness = netout[int(row)][int(col)][b][4]
                        if(objectness.all() <= obj_thresh): continue
                        x, y, w, h = netout[int(row)][int(col)][b][:4]
                        x = (col + x) / grid_w 
                        y = (row + y) / grid_h 
                        w = anchors[2 * b + 0] * np.exp(w) / net_w 
                        h = anchors[2 * b + 1] * np.exp(h) / net_h 
                        classes = netout[int(row)][col][b][5:]
                        box = BoundBox(x-w/2, y-h/2, x+w/2, y+h/2, objectness, classes)
                        boxes.append(box)
                return boxes



def get_boxes(boxes, labels, thresh):
    v_boxes, v_labels, v_scores = list(), list(), list()
    for box in boxes:
        for i in range(len(labels)):
            if box.classes[i] > thresh:
                v_boxes.append(box)
                v_labels.append(labels[i])
                v_scores.append(box.classes[i]*100)
    return v_boxes, v_labels, v_scores
 

def load_data(img_name):
    model = load_model('yolov3/yolo.h5')

    input_w, input_h = 416, 416

    photo_filename = img_name

    image, image_w, image_h = load_image_pixels(photo_filename, (input_w, input_h))

    yhat = model.predict(image)
    anchors = [[116,90, 156,198, 373,326], [30,61, 62,45, 59,119], [10,13, 16,30, 33,23]]
    class_threshold = 0.6
    boxes = list()
    for i in range(len(yhat)):
        boxes += decode_netout(yhat[i][0], anchors[i], class_threshold, input_h, input_w)

    
    labels = ["person", "bicycle", "car", "motorbike", "aeroplane", "bus", "train", "truck",
        "boat", "traffic light", "fire hydrant", "stop sign", "parking meter", "bench",
        "bird", "cat", "dog", "horse", "sheep", "cow", "elephant", "bear", "zebra", "giraffe",
        "backpack", "umbrella", "handbag", "tie", "suitcase", "frisbee", "skis", "snowboard",
        "sports ball", "kite", "baseball bat", "baseball glove", "skateboard", "surfboard",
        "tennis racket", "bottle", "wine glass", "cup", "fork", "knife", "spoon", "bowl", "banana",
        "apple", "sandwich", "orange", "broccoli", "carrot", "hot dog", "pizza", "donut", "cake",
        "chair", "sofa", "pottedplant", "bed", "diningtable", "toilet", "tvmonitor", "laptop", "mouse",
        "remote", "keyboard", "cell phone", "microwave", "oven", "toaster", "sink", "refrigerator",
        "book", "clock", "vase", "scissors", "teddy bear", "hair drier", "toothbrush"]
    
    v_boxes, v_labels, v_scores = get_boxes(boxes, labels, class_threshold)

    ind =[]
    for i in v_labels:
        inx = labels.index(i)
        ind.append(inx)
    v_labels = list(set(v_labels))
    lab = "@".join(v_labels)

    #indx = "@".join(ind)
    return lab#, indx


