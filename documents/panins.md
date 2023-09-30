[![Pandora](Images/pandora2.png)](https://github.com/tbleken/Pandora)
## Insert the code from another prg 

Often you want to insert the code from another prg into the active file. Typically this is a small code snippet or a function. Or it can be a header file. With **Pandora** this is extremely simple:

| You type:  | Result after pressing `F8`|
|:----------|:----------------------|
| +xxx  | The complete contents of xxx.prg or xxx.h is inserted |
| + xxx | Same as above|
| ins xxx | Same as above|
| insert xxx | Same as above|  
| +xxx.prg  | The complete contents of xxx.prg is inserted |
| +xxx.h  | The complete contents of xxx.h is inserted |

You don't have to add any file extension, in which case **Pandora** will locate the file by adding `.prg` or `.h` to the given file name. If both exist, the first will be used. You can specify the file extension to avoid confusion.

***Note:*** This function only works in a VFP editor
