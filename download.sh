#!/bin/bash
git clone https://github.com/automatic1111/stable-diffusion-webui

wget -nc -P stable-diffusion-webui/models/Stable-diffusion \
https://huggingface.co/CompVis/stable-diffusion-v-1-4-original/resolve/main/sd-v1-4.ckpt

git -C stable-diffusion-webui/extensions \
clone https://github.com/yfszzx/stable-diffusion-webui-images-browser
