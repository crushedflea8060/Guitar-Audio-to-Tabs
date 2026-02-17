#!/bin/bash
pyenv -s install 3.11.14 
export PATH="$HOME/.pyenv/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv virtualenv-init -)"
file=$1
out=$2
newext=".mid"
noext="${file%.*}"
midioutput="${noext}${newext}"



# --- BasicPitch environment - yes I was assisted by a little chatgpt for this >
pyenv virtualenv -f 3.11.14 basicpitchrunner
PYENV_VERSION=basicpitchrunner pip install -q --upgrade pip setuptools wheel
PYENV_VERSION=basicpitchrunner pip install -q basic-pitch
PYENV_VERSION=basicpitchrunner basic-pitch . $file

pyenv uninstall -f basicpitchrunner

# --- Tuttut environment - in my defense working with pyenv is hell---
pyenv virtualenv -f 3.11.14 myenv311
PYENV_VERSION=myenv311 pip install -q --upgrade pip setuptools wheel
PYENV_VERSION=myenv311 pip install -q tuttut
PYENV_VERSION=myenv311 pip install uv
PYENV_VERSION=myenv311 mkdir ./midis
PYENV_VERSION=myenv311 mkdir ./tabs
PYENV_VERSION=myenv311 mv $midioutput ./midis
PYENV_VERSION=myenv311 uv run --with pretty_midi --with tuttut -- python -m tuttut.midi_tabs_cli $noext 

pyenv uninstall -f myenv311

echo "Finished."
ls


