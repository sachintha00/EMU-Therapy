FROM python:3.10-slim

WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libgl1-mesa-glx \
    libglib2.0-0 \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements first to leverage Docker cache
COPY requirements.txt .

# Install Python packages with specific protobuf version
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application
COPY . .

# Create uploads directory
RUN mkdir -p uploads

# Set environment variable for TensorFlow CPU usage
ENV CUDA_VISIBLE_DEVICES="-1"

# Expose the port the app runs on
EXPOSE 4000

# Command to run the application
CMD ["python", "back_end_classification.py"]