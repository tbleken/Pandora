### 2023-11-06, Version 1.04

Added two new commands, both have similar behavior but with different parameters and results.

**RT:** Generates random, readable but meaningless text. For creating "dummy" values.  
**Lorem:** Generates random and meaningless text. Also for creating "dummy" text.

### 2023-11-03, Version 1.03

Changed how `Pandora` stores the name of the currently selected `.pan` project file. The name of this file is now stored in `Pandora.txt` in the current folder. If no `Pandora.txt` file exists, the default `Pandora.pan` is used. This makes it possible to have separate active `Pandora` projects for different folders.

Added options for TA command: It now allows a parameter which will be added to the name of the test area. See [Your easy accessible testing area Pandora.prg](documents/panta.md) for details.

### 2023-10-14, Version 1.02 ###

Added new command `Dirrun` and the shorter version, `***` and `***:`  
This command will limit the listed files to .prg and .scx, and **run** the selected file.  

Changed the short command for `Inc` to `#`.

Several minor changes to the documentation.

### 2023-10-5, Version 1.01 ###

Changed the syntax for the Dir commands, and in which window the different syntax versions can be used.
Most important is the new DirX command and the command's shorter versions,
`**` and `**:`. The latter, and `\*:` which is short for `Dir`,  can now also be used in all of VFP's editors.  

The addition of `DirX` and the shorter versions, means fewer commands to remember. A side effect is that some earlier `Dir` options can't be called anymore. Instead all the options are now combined into the new `DirX` command, and its shorter versions.

Documentation updated accordingly.

Corrected the documentation for Pandora's command `Ins`.

### 2023-10-2, Version 1.00 ###

#### First release of `Pandora` to go public

![Picture](./documents/Images/vfpxpoweredby_alternative.gif)
