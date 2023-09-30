[![Pandora](Images/pandora2.png)](https://github.com/tbleken/Pandora)

## INC #Include helper

This keyword is a helper to include a header file, .h, into your program. Type `inc` or `#inc` and press `F8`, and you get a dropdown list of all the .h files in your path.

| You type:  | After pressing `F8`                                                                  |
|:----------|:--------------------------------------------------------------------------------------|
| inc w | Picklist of files matching \*w\*.h in your path |
| #inc w | Same as above, \# is optional |
| inc\<space\> | Picklist of all .h files in your path |

Note the space character in the last sample, it's *not* optional.

![inc](Images/paninc.png)

The result after pressing **Enter** is `#include yourfile.h`


