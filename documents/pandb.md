[![Pandora](Images/pandora2.png)](../README.md)

## ? and Db 

These commands behaves similarly. Both creates code to list variable names and their value.  

`?` will give the output on the screen  
`db` will give the output on the Debug Output, if it's open


| You type:                |        Result after pressing `F8`                                |
|:-------------------------|:----------------------------------------------------------|
| `?lnVar`                    | ?'lnVar', lnVar |
| `?m.lnMax `                    | ?'lnMax', m.lnMax |
| `db m.lcString `| DebugOut 'lcString ', m.lcString |

These "commands" takes advantage of IntellisenseX, if you use the m. version. This means that you only need to type a few letters, select the wanted variable name and press `F8`.

No rocket science, but a real time saver. :grin: