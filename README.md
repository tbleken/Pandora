## Thor tool Pandora

**Thor Pandora** is a ***Swiss Army Knife&#8482;*** like tool for VFP programmers. In other word, a tool that contains several tools in one. More new features are planned for release later.  

To use it efficiently, assign a Hot Key to it, for instance `F8`. `F8` is used in this document. 

To really take advantage of **Pandora**, create a file named `Pandora.txt` in your working folder. This filename can be changed using `Alt-F12`, select `Options->Pandora`. In this document this file is consistently called `Pandora.txt`.

If the file `Pandora.txt` doesn't exist, it can be created in three ways:
1. In the Command window, press `F8` in a blank line, and confirm.
2. In the Command window or any VFP editor window, type 0 (zero) on a blank line, press `F8` and confirm.
3. Create the file using any editor, e.g. Modify File or Notepad.

Here is the content of a typical `Pandora.txt`:

> Default project: 5
> ****************************************
> 0 exe do my setup.prg && Sets up the environment  
> 0 startup.prg  && Needed in every project  
> 0 myheader.h  && Needed in every project  
>
> #1 My new tool  
> 1 MyNewTool.prg && This may become a cool program  
> 1 https://github.com/VFPX/Thor  
>
> #2 My new Thor tool  
> 2 (_screen.cthorfolder + 'Tools\My Tools\Thor_Tool_MyNewTool.prg')  
> 2 pandora.txt && This file  
> 2 mynotes.prg  
> 2 testing.prg  
> 2 SetDate()  
> 2 Do Mystart with 'SomeValue'  
> *2 (Home(0) + 'foxpro.h') && Header file, don't need it for now 
> 
> #3 My next project, not started yet  
> 3 Some.prg  
> 3 https://github.com/VFPX/Thor  
> 3 (Home(0) + 'foxpro.h') && Header file  
> 3 test.prg  
> 3 exe On Key Label ALT+2 do test
>  
> #4 My test environment  
> 4 test2.prg && Needs testing  
> 4 D:\Projects\common\prog\PROCESSTEXT.PRG  
>
> #5 Zip utility, needs more classes, and must be tested  
> 5 utilities.vcx.zipfiles.zipfile:2  

Most of the "command lines" listed above, can be used both in the Command window and in a "Modify Command" editor window. In those cases, instead of the number, use the word `ed`, for instance `ed myprog.prg` or `ed 0`. The latter will open `Pandora.txt` for editing.

**Pandora** has many features, as seen in the sample above, and listed below in no particular order. Most of these features take a whole line, and "interprets" it.  You enter some text, press `F8`, and the "magic" happens. Or the text is already stored in a "library" file, typically a .prg. 

If no text is marked and the cursor is "inside" a word, **Pandora** will Select the table with that name. If that alias is not in use, **Pandora** calls PEME_OpenTable.PRG, if it exists, to try to open the table. 

Before checking for keywords, the tool tries to execute the current line, or all the marked lines, if more than one is marked. This gives a very easy way to execute a line of code, or a part of some code. Note that in line comments (&&) are properly ignored. *See also* ***Execute Selected Text***  

An initial \* is respected as a commented line for single executable lines. **However**, if the first word following the \* is a **Pandora** keyword, the \* is ignored. This makes it possible to hide "secret" expandable **Pandora** lines in your code.  

# Keywords
## In the Command Window:
#### Most of these commands also work in the editors (Modify Command and Modify File)

| You type                             | Result after pressing `F8`                                   |
|:-------------------------------------|:-------------------------------------------------------------|
| ed                                  | Group of files defined in line 1 of `pandora.txt` are opened |
| \<blank\>                           | Same as above                                                |
| ed x (x=numeric,>0)                 | Group of matching files in `pandora.txt` are opened          |
| x (x=numeric)                                          | Same as above                           |
| ed 0 (zero)                                            | File `pandora.txt` is opened in editor   |
| 0                                                      | Same as above                             |
| ed test.txt                                            | File `test.txt` is opened in editor        |
| ed prog\pro1.prg                                       | `pro1.prg` is opened in editor              |
| ed (_screen.cthorfolder + 'Tools\peme_snippet_no.prg') | variable is resolved and file opened in editor               |
| ed myprog.prg && My notes                              | `myprog.prg` opened, comments ignored       |
| ed pg.vcx                                              | `pg.vcx` is opened in the Class Browser  |
| ed pg.scx.form.txtfind.keypress      | `pg.scx` is opened and editor presents the keypress method   |
| ed pg.scx.form.txtfind.keypress:10                     | Same as above, cursor is on line 10         |
| ed https:\/\/github.com/VFPX/Thor                      | Thor homepage opens in default browser      |
| ed C:\Somefolder\Somefile.xlsx                         | `Somefile.xlsx` is opened in Excel        |
| ed C:\Somefolder\Somemovie.mp4          | `Somemovie.mp4` is opened in default application        |
| ed *file                    | Picklist of all VFP files in the path having `file` in its name |
| ed \*my .prg                | As above, shows files matching `\*my\*.prg`            |
| ed \*my pr .                | As above, both `my` and `pr`in the name or extension |
| ed /my pr .                | Same as above, `/` and `*` are interchangeable |
| ?                                         | Pandora Help (this document)                      |
| #                                    | Picklist of projects in `Pandora.txt`                  |
| -                                                      | Same as above                       |
| menu                                                   | Same as above                        |
| . (dot)                                                | Opens `Pandora.prg`  |
| , (comma)                                              | Same as above                              |


# In the file `Pandora.txt`:

| You type                             | Result after pressing `F8`  |  
|:-------------------------------------|:-------------------------------------------------------------| 
| ed (in Command Window)               | Group of files defined in line 1 of `pandora.txt` are opened |
| \<blank\> (in Command Window)        | Same as above                                                |
| ed x (x=numeric,>0)                  | Group of matching files in `pandora.txt` are opened          |
| x (x=numeric)                        | Same as above                                                |
| ed 0 (zero)                          | File `pandora.txt` is opened in editor                       |
| 0                                    | Same as above                                                |
| ed test.txt                          | File `test.txt` is opened in editor                          |
| ed prog\pro1.prg                     | `pro1.prg` is opened in editor                               |
| ed (_screen.cthorfolder + 'Tools\peme_snippet_no.prg') | variable is resolved and file opened in the editor               |
| ed myprog.prg && My notes            | `myprog.prg` opened, comments are ignored                    |
| ed pg.vcx                            | `pg.vcx` is opened in the Class Browser                      |
| ed pg.scx.form.txtfind.keypress      | `pg.scx` is opened and editor presents the keypress method   |
| ed pg.scx.form.txtfind.keypress:10   | Same as above, cursor is on line 10                          |
| ed https:\/\/github.com/VFPX/Thor    | Thor homepage is opened in default browser                   |
| ed C:\Somefolder\Somefile.xlsx       | `Somefile.xlsx` is opened in Excel                           |
| ed C:\Somefolder\Somemovie.mp4       | `Somemovie.mp4` is opened in default application             |
| ?                                    | Pandora Help (this document)                                 |

*Note:* To distinguish "real" VFP commands from **Pandora** keywords, it's necessary to add the the keyword `ed`, as the first word in a line in `Pandora.txt`. This is **not** necessary in the Command window. 

The same is true if you want to use **Pandora** keywords in a .prg. This is really handy, since you can have a special file with all your **Pandora** code snippets. Tip: Use `Pandora.prg` for this, available directly from the Command window by typing . (dot) and pressing `F8`.

To open **all** the files prefixed with a number, type that number in the Command window and press `F8`. This may be any kind of file as seen in the previous paragraphs. Typically these will be the files you work with in a VFP project, also non VFP files.

A special case in many aspects is `0 (zero)`: 
1. 0 in the Command window will open `Pandora.txt` for editing, if it exists.
2. 0 as the group number in `Pandora.txt` will include the file(s) mentioned for every group.

Notice the first line, `Default project: 5`. To open all the files in the specified group, `5` in this example, you don't have to specify the number. Just press `F8` in an empty line in the Command window, and all the #5 files will be opened, plus all the #0 files. Notice that this number must be the very last "word" in the first line.

Tip: If you store this file in your applications' root folder, you can have different versions in each folder.

## EXE
If you want to **run** a prg or a VFP command from `Pandora.txt` or any other .prg, use the keyword `exe`.

# Pandora Extras  
## NO
*NO* is short for New Object, and is a helper to create the correct syntax. Also the corresponding Local declaration is added where it's appropriate.  
The syntax is best shown by samples. Pressing `F8` will present a dropdown of matching candidates. The entered text will be replaced by new code.

This is what happens in a prg or a method code window:  

| You type  | After pressing Enter                                                                  |
|:----------|:--------------------------------------------------------------------------------------|
| no lo zip | Local lo as zipfiles of utilities.vcx<br>lo = NewObject('zipfiles', 'utilities.vcx')  |
| no lo=zip | Same as above, = is optional                                                          |
| no lo zip!| Same as above, ! forces a refresh of the option list                                  |
| no zip    | Local loZip as zipfiles of utilities.vcx<br>loZip = NewObject('zipfiles', 'utilities.vcx') |
| no lo \*ut| Shows a list where `ut` is somewhere in a class name                                  |
| no loVar +ut    | Shows list where `ut` is in a class name or a classlib name                     |
| no myObj.Lo zip | myobj.NewObject('lo','zipfiles', 'utilities.vcx')                               |


The last sample shows the syntax to call an object's NewObject method.  

*Note:* In the Command window there won't be any Local declaration.

## Execute Selected Text 

`Pandora` will call Thor tool [Execute Selected Text](https://github.com/VFPX/Thor/blob/master/Docs/NewsItems/Item_46.md). From its documentation:  
*This tool is an extension of the familiar option in the context menu when editing code:*  

![](https://github.com/VFPX/Thor/blob/master/Docs/NewsItems/Images/Item_46_ExecuteSelection.png?raw=true)  

The tool provides three new features:

1. If **NO** text is selected, the entire (possibly multiple line) statement is highlighted and executed. The cursor can be anywhere in any line of the statement. In other words, click somewhere in the statement and run the tool to execute the statement.

2. All defined constants will work (instead of failing as they do when using the context menu). That means all defined constants from #Define or #Include directives as well as the include files from VCXs and SCXs. Note, for example, the use of CR in the image above.

3. A plug-in is provided for you to handle the selected text; you might save it in the clipboard or some history file.

**Note that this also works for single lines.**  

The old way: Mark everything, right-click and select Execute Selection. 
The new way: Place the cursor anywhere inside the line/statement, and press `F8`! 

## SuperBrowse 
**Pandora** can also call [SuperBrowse.](https://github.com/VFPX/Thor/blob/master/Docs/Thor_superbrowse.md)  

Place the cursor "inside" a table name and press `F8`. **Pandora** will use several tools to try to locate the table, and open it in `SuperBrowse`.  

Note that there are cases where you need to highlight the table name before you press `F8`. The reason is that although **Pandora** is smart, it can't read your mind. :-) It doesn't know whether you want to use the tool `Execute Selected Text` or `SuperBrowse.` So if the line/statement starts with a keyword like `Select`, `Use` or other words that makes the line/statement executable, it will be executed.

![](https://github.com/VFPX/Thor/blob/master/Docs/Images/Thor_Super_Browse_SNAGHTML8410e4d.png?raw=true)

## INC

This keyword is a helper to include a header file, .h, into your program. Type `inc` or `#inc` and press `F8`, and you get a dropdown list of all the .h files in your path.



### More "extras" to follow, suggestions are welcomed. 

