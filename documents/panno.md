[![Pandora](Images/pandora2.png)](../README.md)

## NO (NewObject builder)</a>  
`NO` is short for NewObject, and is a helper to create the correct syntax. Also the corresponding Local declaration is added where it's appropriate.  
The syntax is best shown by samples. Pressing `F8` will present a dropdown of matching candidates. The entered text will be replaced by new code.

This is what happens in a prg or a method code window:  

| You type:  | After pressing `F8`                                                                  |
|:----------|:--------------------------------------------------------------------------------------|
| no lo zip | Local lo as zipfiles of utilities.vcx<br>lo = NewObject('zipfiles', 'utilities.vcx')  |
| no lo=zip | Same as above  |
| no lo=zip!| Same as above, ! forces a refresh of the option list                                  |
| no lo=\*ut| Shows a list where `ut` is somewhere in a class name                                  |
| no lo=+ut    | Shows list where `ut` is in a class name or a classlib name                     |

The last sample shows the syntax to call an object's NewObject method.  
As you can see, you must either separate the variable name and the class name (or part of it) with a space or an equal sign (=).

If you don't specify the name of the variable, `lo` in these samples, the name is constructed as `lo + Classname`, for instance `loZipfiles`:

| You type:  | After pressing `F8`                                                                  |
|:----------|:--------------------------------------------------------------------------------------|
| no zip    | Local loZipfiles as zipfiles of utilities.vcx  </br>loZipfiles = NewObject('zipfiles', 'utilities.vcx')) |

You can also use this tool to add classes to an object, as shown below. If yo

| You type:  | After pressing `F8`                                                                  |
|:----------|:--------------------------------------------------------------------------------------|
| no myObj.Lo=zip | myObj.NewObject('Lo','zipfiles', 'utilities.vcx')                               |
| no myobj. zip|myobj.NewObject('loZipfiles','zipfiles', 'utilities.vcx')|
| no myObj.ozip zip| myObj.NewObject('ozip','zipfiles', 'utilities.vcx')|


**Note:** In the Command window, no Local declaration is added.  


![no](Images/panno.png)