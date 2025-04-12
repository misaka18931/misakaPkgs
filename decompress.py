#!/usr/bin/env python

import argparse
import subprocess
from pathlib import Path
from zipfile import ZipFile

class TarFile:
    def __init__(self, file_path):
        self.file_path = file_path
    # too slow
    def namelist(self):
        # run "tar tf {filepath}" and get output
        tarproc = subprocess.run(["tar", "tf", str(self.file_path)], capture_output=True, text=True)
        if tarproc.returncode != 0:
            raise Exception("Failed to list tar file contents")
        return [line.strip() for line in tarproc.stdout.splitlines()]
    def extractall(self, path):
        # run "tar xf {filepath} -C {path}"
        subprocess.run(["tar", "xf", str(self.file_path), "-C", str(path)], check=True)

def fatal(msg):
    print("\033[1;31merror:\033[0m "+msg)
    exit(1)

ap = argparse.ArgumentParser()
ap.add_argument("file", help="Archive Path")
ap.add_argument("action", help="Actions to perform on the archive")
args = ap.parse_args()

if args.action not in "tx":
    fatal(f"Invalid action '{args.action}'. Must be 't' or 'x'.")

archivePath = Path(args.file)
if not archivePath.is_file():
    fatal(f"file not found: {archivePath.resolve()}")

fmt = archivePath.suffix[1:]
if fmt == "zip":
    archive = ZipFile(archivePath, 'r')
else:
    archive = TarFile(archivePath)

# names = archive.namelist()

if args.action == 't':
    for name in archive.namelist():
        print(name)

if args.action == 'x':
    stem = archivePath.stem
    if stem[-4:] == '.tar':
        stem = stem[:-4]
    extract_path = Path(stem)
    extract_path.mkdir(mode=0o755, exist_ok=False)
    print(f"Extracting to {extract_path.resolve()}...")
    archive.extractall(path=extract_path)

    # fixing directories
    print("Fixing directory tree...")
    p = extract_path
    children = list(p.iterdir())
    while len(children) == 1:
        p = children[0]
        if p.is_dir():
            children = list(p.iterdir())
        else:
            break
    if p != extract_path:
        final_name = p.name
        rmTarget = p.parent
        tmp = p.rename('decompress_extracted')
        for parent in p.parents:
            try:
                parent.rmdir()
            except:
                pass
        tmp.rename(final_name)
        