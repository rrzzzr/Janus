# Use official PyTorch image with CUDA support
FROM nvidia/cuda:12.6.3-cudnn-runtime-ubuntu22.04

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

# Embed the start_demo script into the Dockerfile with default value
RUN echo '#!/bin/bash\n\
# Set default value for DEMO if not provided\n\
DEMO=${DEMO:-Janus-Pro-1B}\n\
\n\
case "$DEMO" in\n\
  "Janus-Pro-1B")\n\
    echo "Running Janus-Pro-1B..."\n\
    exec python demo/app_januspro_1b.py\n\
    ;;\n\
  "Janus-Pro-7B")\n\
    echo "Running Janus-Pro-7B..."\n\
    exec python demo/app_januspro_7b.py\n\
    ;;\n\
  "JanusFlow-1.3B")\n\
    echo "Running JanusFlow-1.3B..."\n\
    exec python demo/app_janusflow_1_3b.py\n\
    ;;\n\
  "Janus-1.3B")\n\
    echo "Running Janus-1.3B..."\n\
    exec python demo/app_janus_1_3b.py\n\
    ;;\n\
  *)\n\
    echo "Unknown DEMO environment variable: $DEMO"\n\
    echo "Please set DEMO to one of: Janus-Pro-1B, Janus-Pro-7B, JanusFlow-1.3B, Janus-1.3B"\n\
    exit 1\n\
    ;;\n\
esac' > /app/start_demo.sh && chmod +x /app/start_demo.sh

# Use the embedded script as the entrypoint
ENTRYPOINT ["/app/start_demo.sh"]

