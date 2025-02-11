# Application Setup Documentation

## Client Application Setup

### Prerequisites
- Flutter SDK installed
- Android Studio or VS Code with Flutter extensions

### Setup Steps

1. Navigate to the client application folder:
   ```bash
   cd FYP_EMuTheraphy_app
   ```

2. Clean the Flutter project to ensure a fresh start:
   ```bash
   flutter clean
   ```

3. Get all required dependencies:
   ```bash
   flutter pub get
   ```

## API Server Setup

### Prerequisites
- Python 3.9 or 3.10 installed
- pip (Python package manager)

### Environment Setup

1. Navigate to the api application folder:
   ```bash
   cd "API Files"
   ```

2. Create a Python virtual environment:

   **Windows:**
   ```bash
   # Create virtual environment
   python -m venv venv

   # Activate virtual environment
   venv\Scripts\activate
   ```

   **Linux/macOS:**
   ```bash
   # Create virtual environment
   python3 -m venv venv

   # Activate virtual environment
   source venv/bin/activate
   ```

3. Install required packages:
   ```bash
   pip install -r requirements.txt
   ```

### Configuration

1. Create a `.env` file in the API root directory with the following variables:
   ```env
   PORT=4000
   DEBUG=True
   MODEL_PATH=./Model/Ensemble_Average.h5
   THRESHOLD=0.5
   ```

2. Ensure the following directory structure exists:
   ```
   API Files/
   ├── Model/
   │   └── Ensemble_Average.h5
   ├── uploads/
   ├── requirements.txt
   └── back_end_classification.py
   ```

### Running the API Server

1. Start the Flask server:
   ```bash
   python back_end_classification.py
   ```

2. The server will start on `http://localhost:4000`

### Verifying the Setup

1. The API server should show a startup message indicating it's running on port 4000
2. You can test the API endpoint using curl or Postman:
   ```bash
   curl -X POST -F "file=@path/to/image.jpg" http://localhost:4000/predict
   ```

## API Endpoints

### POST /predict
- **Purpose**: Analyze an image for emotion detection
- **Input**: Form data with a file field containing the image
- **Supported formats**: PNG, JPG, JPEG
- **Response**: JSON with either prediction results or error message
- **Example successful response**:
  ```json
  {
    "prediction": "Happiness, Surprise"
  }
  ```
- **Example error response**:
  ```json
  {
    "error": "No file uploaded"
  }
  ```

