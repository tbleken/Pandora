[![Pandora](Images/pandora2.png)](../README.md)
## Insert the result from functions

If you want to insert the `result` of a function into your file, **Pandora** makes this extremely easy.

| You type:  | After pressing `F8`:|
|:----------|:----------------------|
| = xxx()  | The **result** of function xxx is inserted |
| = xxx | Same as above |
| =xxx | Same as above |
| eval xxx  |  Same as above |

`xxx` can be **any** VFP function or UDF. Only functions which return a value, are accepted. 

Example:  

| You type:  | After pressing `F8`:| 
|:----------|:----------------------| 
| =date() | Today's date is inserted| 
| =date | Same as above, parentheses (brackets) are automatically added | 
| =myfunc() | myfunc is called and returned value is inserted|  
| =sqrt(10) | 3.16 is inserted (or 3.1623 if Set Decimals is 4)|

One common use for this feature, is to add misc. comments with important "dynamic" information into the source code.

***Note 1:*** If the function requires parameter(s) with spaces, you must include a space after `=`.  
***Note 2:*** This function only works in a VFP editor 