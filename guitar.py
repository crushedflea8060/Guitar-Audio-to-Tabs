import os
import sys
import subprocess
import shutil
from pathlib import Path
import venv


PYTHON_VERSION_WARNING = """
This script works best on Python 3.9–3.12.
If you get installation errors, use Python 3.11.
"""


def run(cmd, cwd=None):
    print(">>", " ".join(cmd))
    subprocess.check_call(cmd, cwd=cwd)


def create_venv(path):
    if not path.exists():
        print(f"Creating virtual environment at {path}")
        venv.create(path, with_pip=True)


def get_venv_python(venv_path):
    if os.name == "nt":
        return venv_path / "Scripts" / "python.exe"
    else:
        return venv_path / "bin" / "python"


def ensure_packages(python_exec):
    run([str(python_exec), "-m", "pip", "install", "--upgrade", "pip"])
    run([
        str(python_exec), "-m", "pip", "install",
        "basic-pitch",
        "tuttut",
        "pretty_midi"
    ])


def run_basic_pitch(python_exec, audio_file, output_dir):
    run([
        str(python_exec),
        "-m",
        "basic_pitch",
        output_dir,
        str(audio_file)
    ])


def run_tuttut(python_exec, midi_file):
    run([
        str(python_exec),
        "-m",
        "tuttut.midi_tabs_cli",
        str(midi_file)
    ])


def find_generated_midi(output_dir, original_name):
    base = Path(original_name).stem
    for file in Path(output_dir).glob("*.mid"):
        if base in file.name:
            return file
    return None


def main():
    if len(sys.argv) < 2:
        print("Usage: python transcribe.py <audiofile>")
        print(PYTHON_VERSION_WARNING)
        sys.exit(1)

    audio_file = Path(sys.argv[1]).resolve()

    if not audio_file.exists():
        print("File not found:", audio_file)
        sys.exit(1)

    root = Path.cwd()
    venv_dir = root / "transcriber_env"
    midis_dir = root / "midis"
    tabs_dir = root / "tabs"

    midis_dir.mkdir(exist_ok=True)
    tabs_dir.mkdir(exist_ok=True)

    create_venv(venv_dir)
    python_exec = get_venv_python(venv_dir)

    ensure_packages(python_exec)

    print("\n=== Running Basic Pitch ===\n")
    run_basic_pitch(python_exec, audio_file, str(midis_dir))

    midi_file = find_generated_midi(midis_dir, audio_file.name)

    if not midi_file:
        print("Could not find generated MIDI file.")
        sys.exit(1)

    print("\n=== Running Tuttut ===\n")
    run_tuttut(python_exec, midi_file)

    print("\nFinished successfully.")
    print("MIDI saved in:", midis_dir)
    print("Tabs saved in:", tabs_dir)


if __name__ == "__main__":
    main()
