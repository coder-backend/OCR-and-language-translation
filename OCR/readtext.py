import re
from __main__ import * 

def readtext(roi,r):
    wordlist = []
    wordlist.append('340Q8O89663')
    wordlist.append('341Q8O93220')
    wordlist.append('349Q8O20238')
    wordlist.append('348Q8O26843')
    wordlist.append('340Q8O89661')
    wordlist.append('340Q8O89660')
    wordlist.append('348Q8O26842')
    wordlist.append('340Q8O89662')
    wordlist.append('349Q8O20240')
    wordlist.append('341Q8O93216')
    wordlist.append('341Q8O93218')
    wordlist.append('349Q8O20237')
    wordlist.append('349Q8O20236')
    wordlist.append('341Q8O93217')
    wordlist.append('348Q8O26841')
    wordlist.append('340Q8O89664')
    config = ("-l eng --oem 0 --psm 3 --user-words C:\Program Files\Tesseract-OCR\tessdata\eng.user-words -c tessedit_char_whitelist=OQ0123456789 tessedit_unrej_any_wd=0 tessedit_use_reject_spaces=1  textord_noise_rejrows=1 textord_heavy_nr=0 tessedit_parallelize=1 tosp_sanity_method=1  load_system_dawg=1 load_freq_dawg=0 load_unambig_dawg=0 load_punc_dawg=0 load_number_dawg=1 wordrec_enable_assoc=0 tessedit_reject_bad_qual_wds=0  textord_noise_rejwords=1 hocr bazaar")
    text = pytesseract.image_to_string(roi, config=config)
    if(text.count(' ')>0):
        textlist = list(text)
        chars = set(' ')
        if any((c in chars) for c in text):
            text=text.replace(" ","")
    if(len(text)>11):
        print('more than 11 chars')
        print(text)
        chars = str('89663')
        if re.search(chars, text):
            text=str('340Q8O89663')
            return text
        chars = str('93220')
        if re.search(chars, text):
            text=str('341Q8O93220')
            return text
        chars = str('20238')
        if re.search(chars, text):
            text=str('349Q8O20238')
            return text
        chars = str('26843')
        if re.search(chars, text):
            text=str('348Q8O26843')
            return text
        chars = str('89661')
        if re.search(chars, text):
            text=str('340Q8O89661')
            return text
        chars = str('26842')
        if re.search(chars, text):
            text=str('348Q8O26842')
            return text
        chars = str('89662')
        if re.search(chars, text):
            text=str('340Q8O89662')
            return text
        chars = str('20240')
        if re.search(chars, text):
            text=str('349Q8O20240')
            return text
        chars = str('93216')
        if re.search(chars, text):
            text=str('341Q8O93216')
            return text
        chars = str('93218')
        if re.search(chars, text):
            text=str('341Q8O93218')
            return text
        chars = str('20237')
        if re.search(chars, text):
            text=str('349Q8O20237')
            return text
        chars = str('20236')
        if re.search(chars, text):
            text=str('349Q8O20236')
            return text
        chars = str('93217')
        if re.search(chars, text):
            text=str('341Q8O93217')
            return text
        chars = str('26841')
        if re.search(chars, text):
            text=str('348Q8O26841')
            return text
        chars = str('89664')
        if re.search(chars, text):
            text=str('340Q8O89664')
            return text

        if(text.count('1')>2):
            print('more than 2 1s')
            textlist = list(text)
            for numb in textlist:
                if(numb==textlist[3]):
                    break
                if(numb==textlist[11]):
                    break
                if(numb==textlist[10]):
                    break
            chars = set('1')
            if any((c in chars) for c in text):
                text=text.replace("1","")
                print("fixed numbers")
            if(len(text)==11):
                

                firstone = next((x for x in wordlist if x in text), None)
                if any(x in text for x in wordlist):
                    print("Full Pass")
                    return text
                else:
                    
                    return text
            if(len(text)<11):
                r=+1
                chars = str('89663')
                if re.search(chars, text):
                    text=str('340Q8O89663')
                    return text
                chars = str('93220')
                if re.search(chars, text):
                    text=str('341Q8O93220')
                    return text
                chars = str('20238')
                if re.search(chars, text):
                    text=str('349Q8O20238')
                    return text
                chars = str('26843')
                if re.search(chars, text):
                    text=str('348Q8O26843')
                    return text
                chars = str('89661')
                if re.search(chars, text):
                    text=str('340Q8O89661')
                    return text
                chars = str('26842')
                if re.search(chars, text):
                    text=str('348Q8O26842')
                    return text
                chars = str('89662')
                if re.search(chars, text):
                    text=str('340Q8O89662')
                    return text
                chars = str('20240')
                if re.search(chars, text):
                    text=str('349Q8O20240')
                    return text
                chars = str('93216')
                if re.search(chars, text):
                    text=str('341Q8O93216')
                    return text
                chars = str('93218')
                if re.search(chars, text):
                    text=str('341Q8O93218')
                    return text
                chars = str('20237')
                if re.search(chars, text):
                    text=str('349Q8O20237')
                    return text
                chars = str('20236')
                if re.search(chars, text):
                    text=str('349Q8O20236')
                    return text
                chars = str('93217')
                if re.search(chars, text):
                    text=str('341Q8O93217')
                    return text
                chars = str('26841')
                if re.search(chars, text):
                    text=str('348Q8O26841')
                    return text
                chars = str('89664')
                if re.search(chars, text):
                    text=str('340Q8O89664')
                    return text
                
                if(r>2):
                    kernel = np.zeros((1, 1), np.uint8)
                    gaussian_3 = cv2.GaussianBlur(roi, (9,9), 10.0)
                    unsharp_image = cv2.addWeighted(roi, 1.5, gaussian_3, -0.5, 0, roi)
                    roi = cv2.erode(roi, kernel, iterations=2)
                    roi = cv2.dilate(roi, kernel, iterations=1)
                    ret,roi = cv2.threshold(roi,127,255,cv2.THRESH_BINARY_INV)
                    readtext(roi,r)
                else:
                    return text
                
    return text
