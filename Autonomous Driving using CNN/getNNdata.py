# -*- coding: utf-8 -*-
"""
Created on Thu Mar  7 15:08:05 2019

@author: Rohit
"""

import numpy as np
from PIL import ImageGrab
import cv2
import time
from getkeys import key_check
import os

def keys_to_output(keys):
    #[LEFT,UP,RIGHT]
    output = [0,0,0,0]
    
    if 'A' in keys:
        output[0] = 1
    elif 'D' in keys:
        output[2] = 1
    elif 'S' in keys:
        output[3] = 1
    else:
        output[1] = 1
    
    return output

file_name = 'training_data.npy'
if os.path.isfile(file_name):
    print('File exists')
    training_data = list(np.load(file_name))
else:
    print('File doesnt exist')
    training_data = []

def main():
    for i in list(range(4))[::-1]:
        print(i+1)
        time.sleep(1)

    last_time = time.time()
    
    while (True):
        original_img = np.array(ImageGrab.grab(bbox=(4,27,645,510)))
        original_img = cv2.cvtColor(original_img,cv2.COLOR_BGR2GRAY)
        original_img = cv2.resize(original_img, (80,60))
        print(np.shape(original_img))
        cv2.imshow('window', original_img)
        keys = key_check()
        print('{}'.format(keys))
        output = keys_to_output(keys)
        training_data.append([original_img,output])
        print('FPS: {}'.format(round(1/(time.time() - last_time))))
        
        last_time = time.time()
        
        if len(training_data) % 500 == 0:
            print(len(training_data))
            np.save(file_name, training_data)
            
        if cv2.waitKey(25) & 0xFF == ord('q'):
            cv2.destoyAllWindows()
            break    
main()
            