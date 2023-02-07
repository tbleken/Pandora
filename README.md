## Thor tool Pandora

**Thor Pandora** is a "Leatherman&#8482;" tool for VFP programmers. Or a Pandora's Box of tools, if you like. Several features are planned for release later.  

To use it efficiently, assign a Hot Key to it, for instance `F8`. `F8` is used in this domument. 

***Pandora*** has many features, listed here in no particular order. Most of these features takes a whole line, and "interprets" it.  You enter some text, press `F8`, and the "magic" happens. Or the text is already stored in a "library" file, typically a .prg. 

If no text is marked and the cursor is "inside" a word, **Pandora** will Select the table with that name. If that alias is not in use, calls PEME_OpenTable.PRG, if it exists, to open the table. 

Before checking for keywords, the tool tries to execute the current line, or all the marked lines if any. This gives a very easy way to execute a line of code, or a part of some code. Note that in line comments (&&) are properly ignored. 

An initial \* is respected as a commented line for single executable lines. **However**, if the first word following the \* is a **Pandora** keyword, the \* is ignored. This makes it possible to hide "secret" expandable lines in your code.  

One smart tip is to store a list of **Pandora** "commands" in a prg, and have its name as line # 1 in *default.txt*. When you start VFP, you press `F8` and voila, all your day-to.day files will only be a few keystrokes away. And, with proper grouping and comments, it will soon be your favorite "work place".

## Keywords  
## ED 

You type|Result after pressing `F8`  
--------|---------------------|---  
ed (in Command Window)|Group of files defined in line 1 of *default.txt* are opened 


\<blank\> (in Command Window)|Same as above
ed x (x=numeric,>0)|Group of matching files in *default.txt* are opened
x (x=numeric)|Same as above
ed 0 (zero)|File *default.txt* is opened in editor
0|Same as above
ed test.txt|File *test.txt* is opened in editor
ed prog\pro1.prg|*pro1.prg* is opened in editor
ed (_screen.cthorfolder + 'Tools\peme_snippet_no.prg')|variable is resolved and file opened in editor
ed myprog.prg && My notes|myprog.prg opened, comments ignored
ed pg.vcx|pg.vcx is opened in the Class Browser
ed pg.scx.form.txtfind.keypress|*pg.scx* is opened and editor presents the keypress method
ed pg.scx.form.txtfind.keypress:10|Same as above, cursor is on line 10
ed https:\/\/github.com/VFPX/Thor|Thor homepage opens in default browser
ed C:\Somefolder\Somefile.xlsx|Somefile.xlsx opens in Excel
ed C:\Somefolder\Somemovie.mp4|Somemovie.mp4 opens in default application
?|Pandora Help

*Note:* For this keyword `ED`, no deletion happens in the "source" file or in the command window.

## Pandora's "hidden" treasure 
Pandura looks for a specific file in the path, default is `Pandora.txt`. This filename can be changed using Alt-F12, Options->Pandora. In this document this file is consistently called `Pandora.txt`.

If the file `Pandora.txt` doesn't exist, it can be created in three ways:
1. In the command window, press `F8` in a blank line, and confirm.
2. In the command window or any editor window, type 0 (zero), press `F8` and confirm.
3. Create the file using any editor, e.g. Modify File or Notepad.

Here's a realistic sample:

![Pandora](https://user-images.githubusercontent.com/3491804/217336826-37c4507e-1dfc-47c5-ab40-5c87d092ea21.png)

To open **all** the files prefixed with a number, type the number in the Command window and press `F8`. This may be any kind of file as mentioned in the previous paragraph. Typically these will be the files you work with in a VFP project, also non VFP files.

A special case in many aspects is `0 (zero)`: 
1. 0 in the command window will open `Pandora.txt` for editing if it exists
2. 0 as the group number in `Pandora.txt` will "treat" the file mentioned for every group.

Notice the first line, `Default project: 2`. To open all the files in the specified group, 2 in this example, you don't have to specify the number. Just press `F8` in an empty line in the Command window. Notice that the number must be the very last "word" in the first line.

Tip: If you store this file in your applications' root folder, you can have different versions in each folder.

## NO
*NO* is short for New Object, and is a helper to create the correct syntax. Also the corresponding Local declaration is added where it's appropriate.  
The syntax is best shown by samples. Pressing `F8` will present a dropdown of matching candidates. The entered text will be replaced by new code.

This is what happens in a prg or a method code window:  

You type|After pressing Enter
-------|-------
no lo zip|Local lo as zipfiles of utilities.vcx<br>lo = NewObject('zipfiles', 'utilities.vcx')
no lo=zip|Same as above, = is optional
no lo zip!|Same as above, ! forces a refresh of the option list
no zip|Local loZip as zipfiles of utilities.vcx<br>loZip = NewObject('zipfiles', 'utilities.vcx')
no lo \*ut|Shows a list where *ut* is somewhere in a class name
no loVar +ut|Shows list where *ut* is in a class name or a classlib name
no myObj.Lo zip|myobj.NewObject('lo','zipfiles', 'utilities.vcx')

The last sample shows the syntax to call an object's NewObject method.  

*Note:* In the command window there won't be any Local declaration.






