[![Pandora](Images/pandora2.png)](../readme.md)
## Insert the result from functions

If you want to insert the `result` of a function into your file, **Pandora** makes this extremely easy.

| You type:  | After pressing `F8`:|
|:----------|:----------------------|
| =xxx  | The **result** of function xxx is inserted |
| = xxx  | Same as above |
| eval xxx  |  Same as above |

`xxx` can be **any** VFP function or UDF. Only functions which return a value, are accepted. 

Example: 
```foxpro
=date() && When F8 is pressed, today's date is inserted
=myfunc() && F8 will call the UDF myfunc and insert the returned value
```

One common use for this feature, is to add misc. comments with important "dynamic" information into the source code.

***Note 1:*** If the function requires parameter(s) with spaces, you must include a space after `=`.  
***Note 2:*** This function only works in a VFP editor 