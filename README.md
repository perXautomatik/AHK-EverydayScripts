# ahk_config

This repo contains config files for Auto Hot Key on my windows distribution.

## An additional hurdle:
My AHK config file points to some personal data on my machine. I don't want these directories to show on the public repo. A bash pre-processor will examine any files with a `*.ahk` extension and remove lines containing a tag. Processed files will be moved to the "pushable" directory. Original files containing personal data will be ignored.

To use the preprocessor, issue: `./preprocess.sh`

Defined tag:
<table>
  <tr>
    <td>`; no-commit`</td>
    <td>Start ignoring</td>
  </tr>
  <tr>
    <td>`; no-commit-end`</td>
    <td>Stop ignoring</td>
  </tr>
</table>
