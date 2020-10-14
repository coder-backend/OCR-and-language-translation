# Optical Character Recognition

# What code contains (This works on English ,punjabi,hindi using tessdata of tesseract)

1.Used Object detection first with openCV , capture frames with openCV

2.Perform Detection with TensorFlow

3.Extracts Region of interest using box coordinates and enhnacing the image with OpenCV

4.Passing the ROI image to tesseract and receive a string containing text

![](https://github.com/ashish807/OCR-and-language-translation/blob/master/Images/detecting.png)

![](https://github.com/ashish807/OCR-and-language-translation/blob/master/Images/Detected_text.png)

Program Execution :
1. Execute the program from Object_Detection_OCR_image.py file
2. The punjabi text containg image is present named as Texti.py will be seen as test file.
3. A object Detector window will be opened after the execution.
3. Text will be extracted from the image and will be shown as output on the shell as in the image.
