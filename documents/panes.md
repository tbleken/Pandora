[![Pandora](Images/pandora2.png)](../README.md)

## ES (EdisSource builder)

This command will create the correct EditSource() command necessary to open the active form(s) and/or program file(s), and place the cursor on the current line. 


| You type:                |        Result after pressing `F8`                                |
|:-------------------------|:----------------------------------------------------------|
| es       | Pandora will show the built syntax to open the active window, and ask if you want to copy it to the clipboard |
| es all   | Same as above, all the open windows are included, except the active one |

The default syntax will include the full path to the file(s).  
If you prefer relative path to be the default value, run this command. 
```foxpro
_screen.AddProperty('lRelativePath',.T.)
```
In order to force relative path , add a `r` as parameter. In other words:

| You type:                |        Result after pressing `F8`                                |
|:-------------------------|:----------------------------------------------------------|
| `es r`       | The EditSource() syntax with path relative to the current folder|
| `es allr`    | Same as above, except all the open windows are included |

Likewise, if you have set relative path as default as described above, you can force full path by adding a `f`.

| You type:                |        Result after pressing `F8`                                |
|:-------------------------|:----------------------------------------------------------|
| `es f`       | The EditSource() syntax full path|
| `es allf`    | Same as above, all the open windows are included, except the active one |

## Pandora project file [`pandora.pan`](panorg.md)
 
If you have a [`Pandora`](panorg.md) "project" file open, this command behaves differently.

| You type:                |        Result after pressing `F8`                                |
|:-------------------------|:----------------------------------------------------------|
| `es x`      | Pandora will show the syntax to open all the active windows, and ask if you want to paste it a the current position|
| `es +`   | Same as above, except the first available group number will be used, and you will be asked to enter a name for this group |
| `es SomeName`   | Same as above, except the first available group number will be used, and the specified name for this group will be suggested |

`x` must be an integer. Every line in the created code will be prepended with this number, and will form a group, either a new one, or added to an already existing group. See the [documentation](panorg.md) for details. 

If no group number is entered, 0 will be used, meaning the group of files that will always be opened if any group is opened. This is done by typing the group number in the command windows, and press `F8`.

As specified in the second line, if you type `+` as a parameter, the lowest unused group number will be located. This makes it very easy to create a new `Pandora` "project", and give it a name.

**Note:** For this documentation `F8` is used as hotkey for `Pandora`. Feel free to use whatever key or key combination you want.
