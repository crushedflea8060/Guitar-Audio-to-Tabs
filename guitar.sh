#!/bin/bash

set -e

if [ -z "$1" ]; then
    echo "Usage: $0 <audiofile>"
    exit 1
fi

file="$1"
noext="${file%.*}"

export PATH="$HOME/.pyenv/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv virtualenv-init -)"

pyenv install -s 3.11.14

# --- BasicPitch ---
if ! pyenv versions | grep -q basicpitchrunner; then
    pyenv virtualenv 3.11.14 basicpitchrunner
    PYENV_VERSION=basicpitchrunner pip install -q pip setuptools wheel
    PYENV_VERSION=basicpitchrunner pip install -q basic-pitch
fi

PYENV_VERSION=basicpitchrunner basic-pitch . "$file"

midioutput="${noext}.mid"

# --- Tuttut ---
if ! pyenv versions | grep -q myenv311; then
    pyenv virtualenv 3.11.14 myenv311
    PYENV_VERSION=myenv311 pip install -q pip setuptools wheel
    PYENV_VERSION=myenv311 pip install -q tuttut pretty_midi
fi

mkdir -p ./midis
mkdir -p ./tabs

mv "$midioutput" ./midis

PYENV_VERSION=myenv311 python -m tuttut.midi_tabs_cli "$noext"

echo "Finished."
ls
