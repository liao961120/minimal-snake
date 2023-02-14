from pathlib import Path
from glob import glob as glob_ori

def glob_stem(glob_path):
    return glob(glob_path, tp="stem")

def glob_name(glob_path):
    return glob(glob_path, tp="name")

def glob(glob_path, tp="stem"):
    if tp is not None:
        return [ getattr(Path(x), tp) for x in glob_ori(glob_path) ]
    return [ Path(x) for x in glob_ori(glob_path) ]
