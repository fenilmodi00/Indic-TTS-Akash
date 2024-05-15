FROM python:3.9-slim

# Create environment
RUN sudo apt-get update && sudo apt-get install -y libsndfile1-dev ffmpeg enchant
RUN conda create -n tts-env
RUN conda activate tts-env

# Install Python packages
RUN pip3 install -U torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu113
RUN pip3 install -e https://github.com/gokulkarthik/Trainer.git --no-deps
RUN pip3 install -e https://github.com/gokulkarthik/TTS.git --no-deps

# Clone Trainer and TTS repositories
RUN git clone https://github.com/gokulkarthik/Trainer
RUN git clone https://github.com/gokulkarthik/TTS

# Copy fixed files from Trainer repository
COPY Trainer/trainer/logging/wandb_logger.py /workspace/Trainer/trainer/logging/
COPY Trainer/trainer/trainer.py /workspace/Trainer/trainer/

# Copy fixed file from TTS repository
COPY TTS/TTS/bin/synthesize.py /workspace/TTS/bin/

# Install other requirements
RUN pip3 install -r /workspace/Trainer/requirements.txt

# Set working directory to /workspace
WORKDIR /workspace

# Run main.py
CMD ["python", "main.py"]