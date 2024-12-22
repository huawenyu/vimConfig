% %CAMELCLASS%(1) | %CAMELCLASS% Manual
% %USER%  %MAIL%
% %DATE%

# NAME
**%CLASS%** - A man page written in Markdown

# SYNOPSIS
`%CLASS%` [*options*] [*arguments*]

# DESCRIPTION
This is an %CLASS% of a man page written in Markdown.

You can include **bold text**, *italic text*, or `code snippets`.

# OPTIONS
**-h**, **--help**
:   Display help information.

**-v**, **--version**
:   Show the version number.

**-o**, **--output** *file*
:   Specify the output file.

# EXIT STATUS
The **command** returns the following exit status codes:

0
:   Success.

1
:   General error.

# EXAMPLES
To do something useful:
```bash
#!/bin/bash
### - Please note that the `man` only recognize the file-name, 
### - Please build/reload man-database by  `mandb` after `pandoc` transfered
pandoc -t man -s %CLASS% -t %CLASS%.1
```

# SEE ALSO

**ls(1)**, **cp(1)**

For more information, see the **GNU Coreutils documentation**:
<https://www.gnu.org/software/coreutils/>.

