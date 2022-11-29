FROM pytorch/pytorch

ARG DEBIAN_FRONTEND=noninteractive

WORKDIR /workspace
RUN apt update && apt install -y git wget libgl1 libopencv-dev
RUN git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui 

WORKDIR /workspace/stable-diffusion-webui
RUN COMMANDLINE_ARGS="--skip-torch-cuda-test --exit" REQS_FILE="requirements.txt" python launch.py
RUN pip install -U jinja2

ENV COMMANDLINE_ARGS="--listen"
ENV REQS_FILE="requirements.txt"
CMD python launch.py
