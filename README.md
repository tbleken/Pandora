![Pandora](https://user-images.githubusercontent.com/3491804/228252833-243894a4-77b2-41df-9e95-cd4b60aad444.png)

**Question:** How many tools and commands do you need to use, and how many keys do you have to press to do all of the following:  
* List all the Fox files in your path, pick the right one and open it for editing or browsing?  
* Open all the files you want in a project, including helper files?  
* Browse a table or cursor which is named in your code?  
* Run the code (line or block) where your cursor is?  
* Add a description to all your program file, and quickly search them later  
* Even more?

Still curious? You need only ***One*** tool!  

--------------------------

Introducing: ![Pandora](https://user-images.githubusercontent.com/3491804/228252833-243894a4-77b2-41df-9e95-cd4b60aad444.png), the ***Swiss Army Knife&#8482;*** like tool for VFP programmers.

-------------------------

**Thor Pandora** is a ***Swiss Army Knife&#8482;*** like tool for VFP programmers. In other word, a tool that contains several tools in one. More new features are planned for release later. 

***Note:*** To use it efficiently, assign a Hot Key to it, for instance `F8`. `F8` is used in this document.   

--------------------------------
# ![Pandora](https://user-images.githubusercontent.com/3491804/228252833-243894a4-77b2-41df-9e95-cd4b60aad444.png) Overview:

**Pandora** has many features, as seen in the list above, listed in no particular order. Most of these features take a whole line, and "interprets" it.  You enter some text, press `F8`, and the "magic" happens. Or the text is already stored in a "library" file, typically a .prg. 

If no text is marked and the cursor is "inside" a word, **Pandora** will Select the table with that name. If that alias is not in use, **Pandora** calls PEME_OpenTable.PRG, if it exists, to try to open the table. 

Before checking for keywords, the tool tries to execute the current line, or all the marked lines, if more than one is marked. This gives a very easy way to execute a line of code, or a part of some code. Note that in line comments (&&) are properly ignored. *See also* ***Execute Selected Text***  

An initial \* is respected as a commented line for single executable lines. **However**, if the first word following the \* is a **Pandora** keyword, the \* is ignored by **Pandora**. This makes it possible to hide "secret" expandable **Pandora** "code" in your programs. This code will only be available during your development, since it will be ignored in the working program.

*Note:* To distinguish "real" VFP commands from **Pandora** keywords, it's necessary to add the the keyword `ed`, as the first word in a line in a prg. This is **not** necessary in the Command window. 

This is really handy, since you can have a special file with all your **Pandora** code snippets. Tip: Use `Pandora.prg` for this, available directly from the Command window by typing . (dot) and pressing `F8`.

## 1: The file *Pandora.txt*:

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

To open **all** the files prefixed with a number, type that number in the Command window and press `F8`. This may be any kind of file as seen in the previous paragraphs. Typically these will be the files you work with in a VFP project, also non VFP files.

A special case in many aspects is `0 (zero)`: 
1. 0 in the Command window will open `Pandora.txt` for editing, if it exists.
2. 0 as the group number in `Pandora.txt` will include the file(s) mentioned for every group.

Notice the first line, `Default project: 5`. To open all the files in the specified group, `5` in this example, you don't have to specify the number. Just press `F8` in an empty line in the Command window, and all the #5 files will be opened, plus all the #0 files. Notice that this number must be the very last "word" in the first line.

Tip: If you store this file in your applications' root folder, you can have different versions in each folder.

## Note on the *Pandora* keyword `exe:`  

If you want to **run** a prg or execute a VFP command from `Pandora.txt` or any other .prg, use the keyword `exe`.  
You can see this "in action" above with the line `3 exe On Key Label ALT+2 do test`. The result is that when you type `3` in the command window and press `F8`, this line will be executed while the other files starting with `3` are opened.  

### *Pandora.txt* reference: 

|C/E| You type:                |        Result after pressing `F8`                                |
|--|:-------------------------|:----------------------------------------------------------|
| C| ed                           | Group of files defined in line 1 of `pandora.txt` are opened |
| C| \<blank\>                    | Same as above                                             |
| C| ed x (x=numeric,>0)          | Group of matching files in `pandora.txt` are opened       |
| C| x (x=numeric)                | Same as above                           |
|CE| ed 0 (zero)                  | File `pandora.txt` is opened in editor   |
|CE| 0                            | Same as above                             |
| C| #                            | Picklist of projects in `Pandora.txt`                  |
| C| -                            | Same as above                       |
| C| menu                         | Same as above                        |

#### The C/E column describes where the "command" (keyword) works: 
**C:** Command Window **E:** program editor (Modify Command) and the text editor (Modify File) 


## 2: Opening "normal" VFP files:  

| You type:                |        Result after pressing `F8`                                |
|:-------------------------|:----------------------------------------------------------|
| ed test.txt                  | File `test.txt` is opened in editor        |
| ed prog\pro1.prg             | `pro1.prg` is opened in editor              |
| ed (_screen.cthorfolder + 'Tools\peme_snippet_no.prg') | variable is resolved and file opened in editor |
| ed myprog.prg && My notes    | `myprog.prg` is opened, comments ignored       |
| ed mytable.dbf               | `mytable.dbf` is opened in SuperBrowse        |   
| ed pg.vcx                    | `pg.vcx` is opened in the Class Browser  |

#### This feature works in the Command Window and in the editors (Modify Command and Modify File) 

`ed` followed by a the name of a file, will open that file.  
* prg: Editor  
* txt: Editor  
* dbf: SuperBrowse  
* scx: Form Designer
* vcx: Class Browser
* frx: Report Designer
* lbx: Label Designer  

### 2a Opening Forms and Class Libraries: 

For a scx or vcx where the name of the method is specified, with or without the optional line number, the class is opened, and the specified method is opened in the editor.  
Likewise, for a vcx the class browser is opened, in addition to the method editor.

| You type:                |        Result after pressing `F8`                                |
|:-------------------------|:----------------------------------------------------------|
| ed pg.vcx.pg1      | Class `pg1` in `pg.vcx` is opened, last method appears in the editor|
| ed pg.vcx.pg1.init | Class `pg1` in `pg.vcx` is opened, `init` method appears in the editor|
| ed pg.scx.form.txtfind.keypress  | Form `pg.scx` is opened and editor shows `form.txtfind.keypress`|
| ed pg.scx.form.txtfind.keypress:10| Same as above, cursor is on line 10         |

#### This feature works in the Command Window and in the editors (Modify Command and Modify File) 


## 3: Opening external files:  

For registered file types, the file will be opened in the corresponding application.  
Likewise, a URL will be opened in the default Browser.

| You type:                |        Result after pressing `F8`                                |
|:-------------------------|:----------------------------------------------------------|
| ed https:\/\/github.com/VFPX/Thor | Thor homepage opens in default browser      |
| ed C:\Somefolder\Somefile.xlsx    | `Somefile.xlsx` is opened in Excel        |
| ed C:\Somefolder\Somemovie.mp4    | `Somemovie.mp4` is opened in default application        |

#### This feature works in the Command Window and in the editors (Modify Command and Modify File) 


## 4: File Picklists  
**Pandora** comes with a nice "file finder" with several options.  
The simplest syntax is `ed *` which finds all the VFP related files in your path. Pick one with the arrow keys or the mouse, or start typing, and press Enter.  
To start with a more limited selection of files, you can specify one or more "words" from the file name. If the "word list" contains a . (dot), you can also specify the extension. In that case also non VFP files are included in the search.  

|C/E| You type:                |        Result after pressing `F8`                                |
|--|:-------------------------|:----------------------------------------------------------|
|CE| ed *                     | Picklist of all VFP files in the path |  
|CE| ed *db                   | As above, shows only files having `db` in its name or extension|
|CE| ed /my .prg              | As above, shows files having `\*my`in name and `prg`as extension|
|CE| ed /my pr .              | As above, both `my` and `pr`in the name or extension |
|CE| ed \*my pr .             | Same as above, `/` and `*` are interchangeable |
| C| / my pr .                | Same as above, a single `/` is short for `ed /`|  
| C| *                        | Same as `ed *`                                 |
| C| *db                      | Same as `ed *db`                               |

#### The C/E column describes where the "command" (keyword) works: 
**C:** Command Window **E:** program editor (Modify Command) and the text editor (Modify File) 


**Note**: In the Command Window you don't need to type `ed`, a single `*` is enough. Additional characters are allowed to narrow the result set. For instance `*my` will list all the VFP files that contains `my` in its name.

## 5: Pandora.prg  
`Pandora.prg` is initially an empty file. The purpose is to have *one* file to use during your development and testing. If the first line is `Return`, no harm is done if you accidentally run it.  

| You type:                |        Result after pressing `F8`                                |
|:-------------------------|:----------------------------------------------------------|
| . (dot)                  | Opens `Pandora.prg`  |
| , (comma)                | Same as above                              |

#### This feature only works in the Command Window

Tip: Use `pandora.prg` to call other test files by adding `ed` **pandora** keywords.

## 6: Help  
No explanation necessary, will bring up this file.

| You type:                |        Result after pressing `F8`                                |
|:-------------------------|:----------------------------------------------------------|
| ?                        | **Pandora** Help (this document)                      |

#### *Note:* This feature only works in the Command Window


# *Pandora* Extras  
## NO:
*NO* is short for New Object, and is a helper to create the correct syntax. Also the corresponding Local declaration is added where it's appropriate.  
The syntax is best shown by samples. Pressing `F8` will present a dropdown of matching candidates. The entered text will be replaced by new code.

This is what happens in a prg or a method code window:  

| You type:  | After pressing `F8`                                                                  |
|:----------|:--------------------------------------------------------------------------------------|
| no lo zip | Local lo as zipfiles of utilities.vcx<br>lo = NewObject('zipfiles', 'utilities.vcx')  |
| no lo=zip | Same as above, = is optional                                                          |
| no lo zip!| Same as above, ! forces a refresh of the option list                                  |
| no zip    | Local loZip as zipfiles of utilities.vcx<br>loZip = NewObject('zipfiles', 'utilities.vcx') |
| no lo \*ut| Shows a list where `ut` is somewhere in a class name                                  |
| no loVar +ut    | Shows list where `ut` is in a class name or a classlib name                     |
| no myObj.Lo zip | myobj.NewObject('lo','zipfiles', 'utilities.vcx')                               |


The last sample shows the syntax to call an object's NewObject method.  

**Note:** In the Command window, no Local declaration is added.

## Execute Selected Text: 

`Pandora` will call Thor tool [Execute Selected Text](https://github.com/VFPX/Thor/blob/master/Docs/NewsItems/Item_46.md). From its documentation:  
*This tool is an extension of the familiar option in the context menu when editing code:*  

![](https://github.com/VFPX/Thor/blob/master/Docs/NewsItems/Images/Item_46_ExecuteSelection.png?raw=true)  

The tool provides three new features:

1. If **NO** text is selected, the entire (possibly multiple line) statement is highlighted and executed. The cursor can be anywhere in any line of the statement. In other words, click somewhere in the statement and run the tool to execute the statement.

2. All defined constants will work (instead of failing as they do when using the context menu). That means all defined constants from #Define or #Include directives as well as the include files from VCXs and SCXs. Note, for example, the use of CR in the image above.

3. A plug-in is provided for you to handle the selected text; you might save it in the clipboard or some history file.

**Note:** This also works for single lines.

The old way: Mark everything, right-click and select Execute Selection. 
The new way: Place the cursor anywhere inside the line/statement, and press `F8`! 

## SuperBrowse: 
**Pandora** can also call [SuperBrowse.](https://github.com/VFPX/Thor/blob/master/Docs/Thor_superbrowse.md)  

Place the cursor "inside" a table name and press `F8`. **Pandora** will use several tools to try to locate the table, and open it in `SuperBrowse`.  

Note that there are cases where you need to highlight the table name before you press `F8`. The reason is that although **Pandora** is smart, it can't read your mind. :-) It doesn't know whether you want to use the tool `Execute Selected Text` or `SuperBrowse.` So if the line/statement starts with a keyword like `Select`, `Use` or other words that makes the line/statement executable, it will be executed.

![](https://github.com/VFPX/Thor/blob/master/Docs/Images/Thor_Super_Browse_SNAGHTML8410e4d.png?raw=true)

## INC:

This keyword is a helper to include a header file, .h, into your program. Type `inc` or `#inc` and press `F8`, and you get a dropdown list of all the .h files in your path.

## Descriptions in your prgs:

**Pandora** Keyword `/:`

If your program files contains a description in one of the ten first lines, **Pandora** has tools to make your life easier. The description must match this format:  
`* Description: Some text *`

#### Syntax samples: 

| Window | You type:  | After pressing `F8`:|
|-------|:----------|:----------------------|
| C | `/:`           | You get a list of all prgs in your path which have a description|
| C | `/: aaa` | List of files where the descriptions contains `aaa`|
| E | `/:` | A `* Description *` template is added in the current line (line 10 or less)|

`C`: Command Window  
`E`: Modify Command or Modify File Editor  


### More "extras" to follow, suggestions are welcomed. 

