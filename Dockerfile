FROM nvidia/cuda:11.8.0-devel-ubuntu22.04 AS builder
ARG DEBIAN_FRONTEND=noninteractive
RUN apt update && apt install -y git python3-venv python3-dev
RUN python3 -m venv venv
RUN git clone https://github.com/automatic1111/stable-diffusion-webui
WORKDIR /stable-diffusion-webui
ARG REQ_FILES="requirements.txt"
ARG COMMANDLINE_ARGS="--skip-torch-cuda-test --exit"
RUN . /venv/bin/activate && python launch.py
# You have to configure docker default-runtime to nvidia in daemon.json for build xformers
RUN . /venv/bin/activate && pip install ninja triton && \
pip install -v -U git+https://github.com/facebookresearch/xformers.git@main#egg=xformers

FROM ubuntu:22.04 AS base
ARG DEBIAN_FRONTEND=noninteractive
RUN apt update && apt install -y git python3-venv libgl1-mesa-glx libglib2.0-0
COPY --from=builder /venv /venv
WORKDIR /stable-diffusion-webui
ENV REQ_FILES="requirements.txt"
ENV HF_HOME=/stable-diffusion-webui/models/huggingface
CMD . /venv/bin/activate && python launch.py
