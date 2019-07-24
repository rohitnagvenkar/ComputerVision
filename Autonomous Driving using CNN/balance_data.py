# -*- coding: utf-8 -*-
"""
Created on Mon Apr 29 02:56:33 2019

@author: Rohit
"""

import numpy as np
import pandas as pd
from collections import Counter
from random import shuffle
import cv2

train_data = np.load('training_data.npy')
print(len(train_data))
df = pd.DataFrame(train_data)
print(df.head())
print(Counter(df[1].apply(str)))

left = []
right = []
forward = []
down = []

shuffle(train_data)

for data in train_data:
    img = data[0]
    choice = data[1]
    
    if choice ==[1,0,0,0]:
        left.append([img,choice])
    elif choice == [0,1,0,0]:
        forward.append([img, choice])
    elif choice ==[0,0,1,0]:
        right.append([img,choice])
    elif choice == [0,0,0,1]:
        down.append([img, choice])
    else:
        print('no matches!!!!!!!!!!!!!!')
        
forward = forward[:len(left)][:len(right)]
left = left[:len(forward)]
right = right[:len(forward)]
down = down[:len(forward)]

final_data = forward + left + right + down
shuffle(final_data)
print(len(final_data))
df = pd.DataFrame(final_data)
print(df.head())
print(Counter(df[1].apply(str)))
np.save('training_data_v2.npy',final_data)
        

#for data in train_data:
#    img = data[0]
#    choice = data[1]
#    cv2.imshow('test',img)
#    print(choice)
#    if cv2.waitKey(25) & 0xFF == ord('q'):
#       cv2.destroyAllWindows()
#        break