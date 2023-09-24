# ahk_config

This repo contains config files for Auto Hot Key on my windows distribution.

## Adding scripts to startup

1. `shell:startup` in the Run dialog box (`Win + R`) will launch the startup applications folder
2. Add a link to the AHK script to run

## An additional hurdle:
My AHK config file points to some personal data on my machine. I don't want these directories to show on the public repo. A bash pre-processor will examine any files with a `*.ahk` extension and remove lines containing a tag. Processed files will be moved to the "pushable" directory. Original files containing personal data will be ignored.

To use the preprocessor, issue: `./preprocess.sh`

Defined tags:
* `; no-commit`
* `; no-commit-end`

### Idiosyncratic note:
Git operations are done through *Nix or Cygwin machines, but modifications to the AHK scripts are done on a Windows machine. For the preprocess script to work, line terminations must be dealt with using the `lineterm.sh` script. (Foregoing using `d2u` for purposes of availability.)
