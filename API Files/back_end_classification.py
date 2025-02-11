from __future__ import division, print_function
from flask import Flask, request, jsonify
from werkzeug.utils import secure_filename
import tensorflow as tf
from tensorflow.keras.applications import imagenet_utils
import os
import numpy as np
import logging

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

app = Flask(__name__)

# Configure constants from environment variables
PORT = int(os.environ.get('PORT', 4000))
DEBUG = os.environ.get('DEBUG', 'True').lower() == 'true'
MODEL_PATH = os.environ.get('MODEL_PATH', './Model/Ensemble_Average.h5')
THRESHOLD = float(os.environ.get('THRESHOLD', 0.5))
UPLOAD_FOLDER = 'uploads'
ALLOWED_EXTENSIONS = {'png', 'jpg', 'jpeg'}

app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER

# Ensure upload directory exists
os.makedirs(UPLOAD_FOLDER, exist_ok=True)

# Categories for classification
categories = ['Surprise', 'Fear', 'Disgust', 'Happiness', 'Sadness', 'Anger']

# Define the custom Lambda layer function
def preprocess_input(x):
    return imagenet_utils.preprocess_input(x, mode='tf')

try:
    # Custom optimizer to handle weight decay
    class CustomOptimizer(tf.keras.optimizers.Adam):
        def __init__(self, weight_decay=0.01, *args, **kwargs):
            super().__init__(*args, **kwargs)
            self.weight_decay = weight_decay

    # Register the custom objects
    custom_objects = {
        'e_m_2_lambda_1': lambda x: preprocess_input(x),
        'CustomOptimizer': CustomOptimizer
    }
    
    # Load model with custom optimizer
    model = tf.keras.models.load_model(MODEL_PATH, custom_objects=custom_objects, compile=False)
    
    # Recompile the model with the custom optimizer
    model.compile(
        optimizer=CustomOptimizer(),
        loss='categorical_crossentropy',
        metrics=['accuracy']
    )
    
    logger.info(f'Model loaded successfully from {MODEL_PATH}')
except Exception as e:
    logger.error(f'Failed to load model from {MODEL_PATH}: {str(e)}')
    model = None

def allowed_file(filename):
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS

def model_predict(img_path, model):
    try:
        img = tf.keras.utils.load_img(img_path, target_size=(100, 100))
        x = tf.keras.utils.img_to_array(img)
        x = np.expand_dims(x, axis=0)
        
        # Make prediction
        preds = model.predict([x,x])
        return preds, None
            
    except Exception as e:
        return None, str(e)

@app.route('/predict', methods=['GET', 'POST'])
def upload():
    if request.method == 'POST':
        if model is None:
            return jsonify({'error': 'Model not loaded. Please check server logs.'})

        if 'file' not in request.files:
            return jsonify({'error': 'No file uploaded'})
        
        file = request.files['file']
        
        if file.filename == '':
            return jsonify({'error': 'No file selected'})

        if not allowed_file(file.filename):
            return jsonify({'error': 'Invalid file type. Allowed types: png, jpg, jpeg'})

        try:
            filename = secure_filename(file.filename)
            file_path = os.path.join(app.config['UPLOAD_FOLDER'], filename)
            file.save(file_path)

            pred, error = model_predict(file_path, model)
            
            if error:
                return jsonify({'error': f'Prediction failed: {error}'})

            labels = [categories[i] for i, prob in enumerate(pred[0]) if prob > THRESHOLD]
            result = ', '.join(labels) if labels else "No emotions detected"
            
            # Clean up uploaded file
            try:
                os.remove(file_path)
            except Exception as e:
                logger.warning(f'Failed to remove uploaded file {file_path}: {str(e)}')
            
            logger.info(f'Prediction for {filename}: {result}')
            return jsonify({'prediction': result})

        except Exception as e:
            logger.error(f'Error processing request: {str(e)}')
            return jsonify({'error': 'Server error while processing the request'})

    return jsonify({'message': 'Please send a POST request with an image file'})

if __name__ == '__main__':
    app.run(debug=DEBUG, port=PORT, host='0.0.0.0')