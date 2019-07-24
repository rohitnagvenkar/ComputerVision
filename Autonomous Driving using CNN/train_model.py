# -*- coding: utf-8 -*-
"""
Created on Mon Apr 29 08:28:23 2019

@author: Rohit
"""

import numpy as np
from alexnet import alexnet

WIDTH = 80
HEIGHT = 60
LR = 1e-3
EPOCH = 8
MODEL_NAME = 'selfdriving_epochs.model'

model = alexnet(WIDTH, HEIGHT, LR)

hm_data = 22
for i in range(EPOCH):
    for i in range(1,hm_data+1):
        train_data = np.load('training_data_v2.npy')

        train = train_data[:-10]
        test = train_data[-10:]

        X = np.array([i[0] for i in train]).reshape(-1,WIDTH,HEIGHT,1)
        Y = [i[1] for i in train]
        Y = np.reshape(Y, (-1, 3))

        test_x = np.array([i[0] for i in test]).reshape(-1,WIDTH,HEIGHT,1)
        test_y = [i[1] for i in test]
        #test_y = np.reshape(test_y, (-1, 3))

        model.fit({'input': X}, {'targets': Y}, n_epoch=1, validation_set=({'input': test_x}, {'targets': test_y}), 
            snapshot_step=500, show_metric=True, run_id=MODEL_NAME)

        model.save(MODEL_NAME)

# tensorboard --logdir=foo:F:\6367 Final Project\Neural Networks\log