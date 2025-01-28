# Use official PyTorch image with CUDA support
FROM nvidia/cuda:12.8.0-cudnn-runtime-ubuntu22.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1

# Install system dependencies
RUN apt-get update && apt-get install -y \
    python3-pip \
    python3-dev \
    git \
    && rm -rf /var/lib/apt/lists/*

# Set Python alias
RUN ln -s /usr/bin/python3 /usr/bin/python

# Set working directory
WORKDIR /app

# Clone Janus repository
RUN pip install --upgrade pip
RUN git clone https://github.com/rrzzzr/Janus.git

WORKDIR /app/Janus

RUN pip install -e .[gradio]

# Expose Gradio port
EXPOSE 7860

# Start Gradio demo
CMD ["python", "demo/app_januspro.py"]
