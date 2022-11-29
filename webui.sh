#!/bin/bash
docker run -it --rm --name stable-diffusion-webui --gpus all -p 7860:7860 \
-e COMMANDLINE_ARGS="--listen --enable-insecure-extension-access" \
-v stable-diffusion-webui-cache:/root/.cache \
-v stable-diffuison-webui:/workspace/stable-diffusion-webui \
-v $(pwd)/outputs:/workspace/stable-diffusion-webui\outputs \
--mount type=bind,source=$(pwd)/model.ckpt,\
target=/workspace/stable-diffusion-webui/model.ckpt \
stable-diffusion-webui
