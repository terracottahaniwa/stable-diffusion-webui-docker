#!/bin/bash
docker build --target builder -t stable-diffusion-webui-docker:builder .
docker build --target base -t stable-diffusion-webui-docker:latest .
