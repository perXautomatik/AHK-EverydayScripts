# ahk_config

This repo contains config files for Auto Hot Key on my windows distribution.

## An additional hurdle:
My AHK config file points to some personal data on my machine. I don't want these directories to show on the public repo. A bash pre-processor will examine any files with a `*.ahk` extension and remove lines containing a tag. (@TODO define tag) Processed files will be moved to the `pushable` directory. Original files containing personal data will be ignored.
