#!/bin/bash
# Generate the .env file from using the Key API
# https://platform.deepseek.com/
# or
# https://huggingface.co/
echo "DEESEEK_API_KEY=" > .env
echo "HUGGINGFACE_API_KEY=" >> .env
echo "USE_KEY=HUGGINGFACE_API_KEY" >> .env