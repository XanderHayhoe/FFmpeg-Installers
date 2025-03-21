#!/bin/bash
sudo apt update
sudo apt install -y ffmpeg

# verify installation
ffmpeg -version