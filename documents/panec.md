[![Pandora](Images/pandora2.png)](../README.md)

## EC (Execute clipboard)

If the clipboard (_cliptext) contains text, this command will make Pandora try to execute it.


| You type:                |        Result after pressing `F8`                                |
|:-------------------------|:----------------------------------------------------------|
| ec                       | If the clipboard contains a VFP command, it will be executed |
 
Pandora will try to execute the content of the clipboard inside a Try-Catch-Endtry block, no error trapping is performed.
