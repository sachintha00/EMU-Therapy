from __future__ import division, print_function

from flask import Flask

import tensorflow as tf
import sys
import os
import glob
import re
import numpy as np


from keras.models import load_model
from keras.preprocessing import image

from flask import Flask, redirect, url_for, request, render_template, jsonify
from werkzeug.utils import secure_filename
#from gevent.pywsgi import WSGIServer

app = Flask(__name__)

MODEL_PATH = 'D:/FYP/FYP_EMuTheraphy_app/ML_DeepLearningModel.h5'


model = load_model(MODEL_PATH)


categories = ['Surprise', 'Fear', 'Disgust', 'Happiness', 'Sadness', 'Anger']

# print('Model loaded. Check http://127.0.0.1:4000/')
print('Model loaded. Check http://127.0.0.1:4000/')


def model_predict(img_path, model):
    img = tf.keras.utils.load_img(img_path, target_size=(100, 100))
    x = tf.keras.utils.img_to_array(img)
    x = np.expand_dims(x, axis=0)
    preds = model.predict(x)
    return preds


@app.route('/predict', methods=['GET', 'POST'])
def upload():
    if request.method == 'POST':
        f = request.files['file']
        basepath = os.path.dirname(__file__)
        file_path = os.path.join(
            basepath, 'uploads', secure_filename(f.filename))
        f.save(file_path)
        pred = model_predict(file_path, model)
        
        threshold = 0.5
        labels = []
        for i, prob in enumerate(pred[0]):
            if prob > threshold:
                labels.append(categories[i])

        # check if at least one label was assigned
        if len(labels) > 0:
            result = ', '.join(labels)
        else:
            result = "Invalid image"
            
        print('prediction' , result )
        return jsonify({'prediction' : result})
    
    return jsonify({'prediction' : "No file was uploaded."})

if __name__ == '__main__':
    app.run(debug=True, port=4000)

