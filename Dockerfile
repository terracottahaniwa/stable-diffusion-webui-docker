# docker build --target sd-v1-4 -t stable-diffusion-webui-docker:sd-v1-4 .

FROM nvidia/cuda:11.8.0-devel-ubuntu22.04 AS builder
ARG DEBIAN_FRONTEND=noninteractive
RUN apt update && apt install -y git python3-venv python3-dev libgl1-mesa-glx libglib2.0-0
RUN git -C / clone https://github.com/automatic1111/stable-diffusion-webui
WORKDIR /stable-diffusion-webui
RUN python3 -m venv venv && . venv/bin/activate && \
COMMANDLINE_ARGS="--skip-torch-cuda-test --exit" REQ_FILES="requirements.txt" python launch.py && \
HF_HOME="/stable-diffusion-webui/.cache/huggingface" \
python -c "import sys; sys.path.append('repositories/stable-diffusion-stability-ai'); \
from ldm.modules.encoders.modules import FrozenCLIPEmbedder; FrozenCLIPEmbedder()"
# You have to configure docker default-runtime to nvidia in daemon.json for build xformers
RUN . venv/bin/activate && pip install ninja triton && pip install -v -U \
git+https://github.com/facebookresearch/xformers.git@main#egg=xformers

FROM ubuntu:22.04 AS base
ARG DEBIAN_FRONTEND=noninteractive
RUN apt update && apt install -y git python3-venv libgl1-mesa-glx libglib2.0-0
COPY --from=builder /stable-diffusion-webui /stable-diffusion-webui
WORKDIR /stable-diffusion-webui
ENV HF_HOME=/stable-diffusion-webui/.cache/huggingface
ENV COMMANDLINE_ARGS="--gradio-debug --gradio-auth me:qwerty"
CMD . venv/bin/activate && REQ_FILES="requirements.txt" python launch.py

FROM base AS sd-v1-4
ADD https://huggingface.co/CompVis/stable-diffusion-v-1-4-original/resolve/main/sd-v1-4.ckpt model.ckpt
RUN git -C extensions clone https://github.com/yfszzx/stable-diffusion-webui-images-browser

#FROM base AS wd-v1-3
#ADD https://huggingface.co/hakurei/waifu-diffusion-v1-3/resolve/main/wd-v1-3-float16.ckpt model.ckpt
#RUN git -C extensions clone https://github.com/yfszzx/stable-diffusion-webui-images-browser

#FROM base AS custom
#ADD customize.tar /stable-diffusion-webui
