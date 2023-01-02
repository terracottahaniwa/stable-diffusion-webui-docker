#!/bin/bash
docker run -it --rm --name stable-diffusion-webui --gpus all -p 7860:7860 \
-e COMMANDLINE_ARGS="--api --listen --xformers --gradio-debug --gradio-auth me:qwerty" \
-v $(pwd)/stable-diffusion-webui:/stable-diffusion-webui \
stable-diffusion-webui-docker
