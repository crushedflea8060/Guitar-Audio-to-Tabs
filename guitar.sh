#!/bin/bash
pyenv -s install 3.11.14 
export PATH="$HOME/.pyenv/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv virtualenv-init -)"

# --- BasicPitch environment - yes I was assisted by a little chatgpt for this >
pyenv virtualenv -f 3.11.14 basicpitchrunner
PYENV_VERSION=basicpitchrunner pip install -q --upgrade pip setuptools wheel
PYENV_VERSION=basicpitchrunner pip install -q basic-pitch
pyenv uninstall -f basicpitchrunner

# --- Tuttut environment - in my defense working with pyenv is hell---
pyenv virtualenv -f 3.11.14 myenv311
PYENV_VERSION=myenv311 pip install -q --upgrade pip setuptools wheel
PYENV_VERSION=myenv311 pip install -q tuttut
pyenv uninstall -f myenv311



