import os
import re
from __main__ import * 
import Object_detection_image as odi


CWD_PATH = os.getcwd()
print("worked")
for file in os.listdir("."):
    if file.endswith(".png"):
        print
        #print(os.path.join("..", file))
        #IMAGE_NAME = str(file);
        #print(str(file))
        pics.insert(ch,file)
        ch+=1;
        odi.loopimg(str(file))
    else:
        print("poop")
        break
