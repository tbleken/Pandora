[![Pandora](Images/pandora2.png)](../readme.md)

Introducing `Pandora` "project organizer"



**`Pandora` is a utility that helps VFP developers manage, use, and execute files, classes, objects, code, as well as offering additional development productivity features more.**

***Note:*** To use it efficiently, assign a Hot Key to it, for instance `F8`. For consistency, `F8` is used in this document.  

--------------------------------




<a id="pandora_pan" > 

## 1. Your "busy files" list `Pandora.pan` </a>

To really take advantage of **Pandora**, create a file named `Pandora.pan` in your working folder. This filename can be changed using `Alt-F12`, select `Options->Pandora`. In this document this file is consistently called `Pandora.pan`.

If the file `Pandora.pan` doesn't exist, it can be created in three ways:
1. In the Command window, press `F8` in a blank line, and confirm.
2. In the Command window or any VFP editor window, type 0 (zero) on a blank line, press `F8` and confirm.
3. Create the file using any editor, e.g. Modify File or Notepad.

Here is the content of a typical `Pandora.pan`:

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
> 2 pandora.pan && This file  
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
1. `0` in the Command window will open `pandora.pan` for editing, if it exists.
2. `0` as the group number in `pandora.pan` will include the file(s) mentioned for every group.

Notice the first line above, `Default project: 5`. To open all the files in the specified group, `5` in this example, you don't have to specify the number. Just press `F8` in an empty line in the Command window, and all the #5 files will be opened, plus all the #0 files. Notice that this number must be the very last "word" in the first line.

Tip: If you store this file in your applications' root folder, you can have different versions in each of them.

## Note on the ***Pandora*** keyword `exe:`  

If you want to **run** a prg or execute a VFP command from `pandora.pan` or any other .prg file, use the keyword `exe`.  
You can see this "in action" above with the line `3 exe On Key Label ALT+2 do test`. The result is that when you type `3` in the command window and press `F8`, this line will be executed while the other files starting with `3` are opened.  

### Using `pandora.pan`: 

|C/E| You type:                |        Result after pressing `F8`                                |
|--|:-------------------------|:----------------------------------------------------------|
| C| ed                           | Group of files defined in line 1 of `pandora.pan` are opened |
| C| \<blank\>                    | Same as above                                             |
| C| ed x (x=numeric,>0)          | Group of matching files in `pandora.pan` are opened       |
| C| x (x=numeric)                | Same as above                           |
|CE| ed 0 (zero)                  | File `pandora.pan` is opened in editor   |
|CE| 0                            | Same as above                             |
| C| pr                           | Picklist of projects in active `.pan` file (default = `pandora.pan`)                        |
| C| 0 `somefilename`             | Active `Pandora` file is changed to `somefilename.pan`       |
| C| 0 \*                 | Picklist of `Pandora` files in the path  |
| C| 0 ?                 | Active `Pandora` file is reported  |

#### The C/E column describes where the "command" (keyword) works: 
**C:** Command Window  
**E:** program editor (Modify Command) and the text editor (Modify File) 

## 2. Easy opening (or running) VFP files  

| You type:                |        Result after pressing `F8`                                |
|:-------------------------|:----------------------------------------------------------|
| ed test.txt                  | File `test.txt` is opened in editor        |
| ed prog\pro1.prg             | `prog\pro1.prg` is opened in editor              |
| ed (_screen.cthorfolder + 'Tools\peme_snippet_no.prg') | variable is resolved and file opened in editor |
| ed myprog.prg && My notes    | `myprog.prg` is opened, comments ignored       |
| ed mytable.dbf               | `mytable.dbf` is opened in SuperBrowse        |   
| ed pg.vcx                    | `pg.vcx` is opened in the Class Browser  |

#### This feature works in the Command Window and in the editors (Modify Command and Modify File): 

`ed` followed by a the name of a file, will open that file. 

| File extension | Files will open in: |  
|:-------------------------|:----------------------------------------------------------|
| prg| Editor  |  
| txt|Editor  |
| pan| Editor |
| dbf| SuperBrowse  |
| scx| Form Designer|
| vcx| Class Browser|
| frx| Report Designer|
| lbx| Label Designer  |

### 2a. Opening Forms and Class Libraries: 

For a scx or vcx where the name of the method is specified, with or without the optional line number, the class is opened, and the specified method is opened in the editor.  
Likewise, for a vcx the class browser is opened, in addition to the method editor.

| You type:                |        Result after pressing `F8`                                |
|:-------------------------|:----------------------------------------------------------|
| ed pg.vcx.pg1      | Class `pg1` in `pg.vcx` is opened, last method appears in the editor|
| ed pg.vcx.pg1.init | Class `pg1` in `pg.vcx` is opened, `init` method appears in the editor|
| ed pg.scx.form.txtfind.keypress  | Form `pg.scx` is opened and editor shows `form.txtfind.keypress`|
| ed pg.scx.form.txtfind.keypress:10| Same as above, cursor is on line 10         |

#### This feature works in the Command Window and in the editors (Modify Command and Modify File) 

***Tip:*** You can store your frequently used commands in `Pandora.prg`!


## 3. Opening external files:  

For registered file types, the file will be opened in the corresponding application.  
Likewise, a URL will be opened in the default Browser.

| You type:                |        Result after pressing `F8`                                |
|:-------------------------|:----------------------------------------------------------|
| ed https:\/\/github.com/VFPX/Thor | Thor homepage opens in default browser      |
| ed C:\Somefolder\Somefile.xlsx    | `Somefile.xlsx` is opened in Excel        |
| ed C:\Somefolder\Somemovie.mp4    | `Somemovie.mp4` is opened in default application        |

#### This feature works in the Command Window and in the editors (Modify Command and Modify File) 

<a id="suggest">  

# More "extras" to follow, suggestions are welcomed! </a>

