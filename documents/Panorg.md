![Pandora](https://github.com/tbleken/Pandora/blob/main/documents/Images/pandora2.png)

 Pandora provides a wide range of programmer tools, accessible either from a code window or the command window.  These tools are accessed by entering a few characters (commands) and then using the hotkey. Some of these programmer tools are unique to Pandora, others provide access to existing Thor tools.  
 
 For this documentation `F8` is used as hotkey, feel free to use any key combination that is supported by [Thor](https://github.com/VFPX/Thor).

|Note|Cmd | Result after pressing hotkey, `F8` used in this documentation|
|:--|:--  |:-------------|
||<a href="#rc">-na-</a>  | <a href="#sb">Run the code where your cursor </a>|
||<a href="#sb">-na-</a>  | <a href="#sb">Browse a table or cursor </a>|
|F|<a href="#dd">DD </a>   | <a href="#dd">DoDefault() syntax builder </a>|
| |<a href="#desc">Desc</a>| <a href="#desc">List of all prg's which have a description</a>|
| |<a href="#dir">Dir</a>  | <a href="#dir">List all VFP files in the path</a>|
| |<a href="#dirc">Dirc</a> | <a href="#dir">List all VFP files in the path with the contents</a>|
| |<a href="#dirr">Dirr</a> | <a href="#dir">List  all VFP files in the path including the record count for all "tables" </a>|
|E|<a href="#eval">Eval</a>| <a href="#eval">Insert return value from a function</a>|
| |<a href="#hk">HK </a>   | <a href="#eval">List of all assigned hot keys</a>|
|E|<a href="#inc">Inc </a> | <a href="#inc">Insert #Include statement</a>|
|E|<a href="#ins">Ins </a> | <a href="#ins">Insert contents from a prg</a>|
| |<a href="#no">No </a>   | <a href="#no">NewObject() syntax builder </a>|
| |<a href="#pane">Pan </a>   | <a href="#no">Create and run your own `Pandora` extensions </a>|
| |<a href="#th">Th  </a>  | <a href="#th">Picklist of registered **Thor** tools</a>|

<!--
| |<a href="#pan">Pan </a> | <a href="#pan">Run or create custom Pandora extensions </a>|
|C|<a href="#pr">Pr  </a>  | <a href="#pr">List of "projects" in active **Pandora** file</a>| -->

**-na-** means that this feature is "automatic" doesn't need any "command".   

**Note:** These commands works in all of VFP's editors, with these exceptions:  
**C:** Works only in the Command window   
**E:** Works only in a VFP code editor (Modi Comm, Class or Form Designer)  
**F:** Works only in the Class or Form Designer  

--------------------------

Introducing: ![Pandora](pandora2.png)


**`Pandora` is a utility that helps VFP developers manage, use, and execute files, classes, objects, code, as well as offering additional development productivity features more.**

***Note:*** To use it efficiently, assign a Hot Key to it, for instance `F8`. For consistency, `F8` is used in this document.  

--------------------------------



# ![Pandora](pandora2.png)  Overview:

**Pandora** has many features, as seen above, listed in no particular order. Most of these features take a whole line, and "interprets" it. You enter some text, press `F8`, and the "magic" happens. Or the text is already stored in a "library" file, typically a .prg. 

If no text is marked and the cursor is "inside" a word, **Pandora** will Select the table with that name. If that alias is not in use, **Pandora** calls PEME_OpenTable.PRG, if it exists, to try to open the table. This is <a href="#superbrowse">"SuperBrowse mode"</a>.

Before checking for keywords, the tool tries to execute the current line, or all the marked lines, if more than one is marked. This gives a very easy way to execute a line of code, or a part of some code. Note that in line comments (&&) are properly ignored. *See also* ***Execute Selected Text***  

An initial \* is respected as a commented line for single executable lines. **However**, if the first word following the \* is a **Pandora** keyword, the \* is ignored! This makes it easy to hide "secret" expandable **Pandora** "code" in your programs. This code will only be available during your development, since it will be ignored in the working program.

*Note:* To distinguish "real" VFP commands from **Pandora** keywords, it's necessary to add the the keyword `ed`, as the first word in a line in a prg. This is **not** necessary in the Command window. 

This is really handy, since you can have a special file with all your **Pandora** code snippets. Tip: Use `Pandora.prg` for this, available directly from the Command window by typing . (dot) and pressing `F8`.
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
| C| menu                         | Picklist of projects in active `.pan` file (default = `pandora.pan`)                        |
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
<a id="dir">  

## 4. File Picklists (advanced Dir)</a>  

**Pandora** comes with a nice "file finder" with several options.  
The simplest syntax is `*` which finds all the VFP related files in your path. Pick one with the arrow keys or the mouse, or start typing, and press **Enter**.  

To start with a more limited selection of files, you can specify one or more "words" from the file name. If the "words list" contains a `.` (dot), you can also specify the extension. In that case also non VFP files are included in the search.  

|C/E| You type:                |        Result after pressing `F8`                                |
|--|:-------------------------|:----------------------------------------------------------|
|CE| dir                      | Picklist of all VFP files in the path |  
|CE| dir db                   | As above, shows only files having `db` in its name *or* extension|
|CE| dir db cust               | Shows all files with names containing  `db` *and* `cust` |  
|CE| dir my .prg              | Shows all files with `my` in the name *and* `prg`as extension|
|CE| dir .ini              | Shows all files `.ini` files |
| C| / my .prg                | Same as above, a single `/` is short for `dir`|  
| C| *                        | Same as `dir`                                 |
| C| * db                      | Same as `dir db`                               |

#### The C/E column describes where the "command" (keyword) works: 
**C:** Command Window   
**E:** program editor (Modify Command) and the text editor (Modify File) 

<a id="dirc">  </a>

**Option 1:**  `dirc:` two more columns are added, `lines` and `text`. The contents of **all** .prg, .txt and .h files, and the corresponding number of lines, are read into the `text` and `lines` columns.  

This gives two big advantages:  
1. The incremental search also includes the contents of the files.
2. Hover the mouse over the field `text`, and you will see the file contents as a tooltip.

Sample:  

| You type:                |        Result after pressing `F8`                                |
|:-------------------------|:----------------------------------------------------------|
| dirc        | The content of all VFP text files is read into the field *text*|
| dirc my        | Same as above, only files matching *my* are shown|

**Comment:** This feature is *not* default since it will in many cases show "unwanted" files when incremental search is used.

<a id="dirr">  </a>
**Option 2:** `dirr:` the record count for **all** VFP tables will be added, including dbc, frx, lbx, scx, vcx, pjx and mnx. This is very handy for evaluating the complexity of unknown projects.  

Sample:  

| You type:                |        Result after pressing `F8`                                |
|:-------------------------|:----------------------------------------------------------|
| dirr        | Will also show the number of records in all VFP "tables"|
| dirr my        | Number of records in all VFP "tables" with `my` in the name|
| dirr reports\        | Number of records in all VFP "tables" in the reports folder |
| dirr .scx       | Number of records in all scx files|

**Comment:** This feature is *not* default since it slows down the process considerably, and the extra information is only needed in special cases. Also note that it does include deleted records, in other words it does *not* respect *Set Deleted*.


**Option 3:** You can combine option 1 and option 2:

| You type:                |        Result after pressing `F8`                                |
|:-------------------------|:----------------------------------------------------------|
| dirrc        | Number of records as described above, *and* program code is added|
| dircr      | Same as above |

**Shortcut in the Command Window:**  
In the Command Window you can type a single `*` instead of `dir`. Additional characters are allowed to narrow the result set. 

| In the Command Window, you type:                |        Result after pressing `F8`                                |
|:-------------------------|:----------------------------------------------------------|
| \*        | Picklist of all VFP files in the path|
| \* abc        | Same as above, only files with `abc` in the name|
| \*:c      | The content of the prg, txt and h files is read into the field *text* |
| \*:r        | Will also show the number of records in all VFP "tables"|
| \*:rc        | Combination of all the above|
| \*:cr        | Same as above|

**Comment:** Note the colon, `:`, to enable the options.

## 5. Your easy accessible testing area `Pandora.prg`  
`Pandora.prg` is initially an empty file. The purpose is to have *one* file to use during your development and testing. If the first line is `Return`, no harm is done if you accidentally run it.  

This file is also a perfect place to store `Pandora` "commands" to 


| You type:                |        Result after pressing `F8`                                |
|:-------------------------|:----------------------------------------------------------|
| . (dot)                  | Opens `Pandora.prg`  |
| , (comma)                | Same as above                              |

#### Note: This feature only works in the Command Window  

<a id="th" >  

## 6. Select the right Thor tool from a picklist, with incremental search </a>

| You type:                |        Result after pressing `F8`                                |
|:-------------------------|:----------------------------------------------------------|
| thor | Lists all Thor tools unstalled on your machine|
| th | Same as above |
| tools | Same as above |

The list has incremental search to narrow the selection. Pick the wanted tool, and press **Enter** to run it. 

Note that some tools may not be relevant from where you are in the IDE, in which case the tool won't start, or you will get a warning or an error.

<a id="hk" >

## 6a. List all your assigned hotkeys (also with incremental search) </a>

| You type:                |        Result after pressing `F8`                                |
|:-------------------------|:----------------------------------------------------------|
| hotkeys | A picklist of all your assigned hotkeys |
| hk    | Same as above|  

Press **Enter** to run the selected tool



## 7. Help  
No explanation necessary, will bring up this file.

| You type:                |        Result after pressing `F8`                                |
|:-------------------------|:----------------------------------------------------------|
| Help                     | **Pandora** Help (this document)                      |

#### *Note:* This feature only works in the Command Window

# Pandora Extras:  
<a id="dd">  

## DD (DoDefault builder)</a>  

In a method in the Form Designer or the Class Editor, a Dodefault() call must include the same parameters as the method accepts. This "helper" will add these parameters automatically! Just type `dd` and press `F8`, and you're done!  

**Note:** This tool only works in the Class or Form Designer.

<a id="no">  

## NO (NewObject builder)</a>  
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

**Note 1:** In the Command window, no Local declaration is added.  
**Note 2:** `No` calls an external "dynamic snippet", which is why the results show in a popup instead of a grid.
<a id="rc">
## Execute Selected Text </a>

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



<a id="superbrowse">

## Call SuperBrowse </a>
**Pandora** can call [SuperBrowse](https://github.com/VFPX/Thor/blob/master/Docs/Thor_superbrowse.md) directly.  

Place the cursor "inside" a table name and press `F8`. **Pandora** will use several tools to try to locate the table, and open it in `SuperBrowse`.  

Note that there are cases where you need to highlight the table name before you press `F8`. The reason is that although **Pandora** is smart, it can't read your mind. :-) It doesn't know whether you want to use the tool `Execute Selected Text` or `SuperBrowse.` So if the line/statement starts with a keyword like `Select`, `Use` or other words that makes the line/statement executable, it will be executed.

![](https://github.com/VFPX/Thor/blob/master/Docs/Images/Thor_Super_Browse_SNAGHTML8410e4d.png?raw=true)
<a id="inc">
## INC #Include helper </a>

This keyword is a helper to include a header file, .h, into your program. Type `inc` or `#inc` and press `F8`, and you get a dropdown list of all the .h files in your path.

| You type:  | After pressing `F8`                                                                  |
|:----------|:--------------------------------------------------------------------------------------|
| inc w | Picklist of files matching \*w\*.h in your path |
| #inc w | Same as above, \# is optional |
| inc\<space\> | Picklist of all .h files in your path |

Note the space character in the last sample, it's *not* optional.

The result after pressing **Enter** is `#include yourfile.h`
<a id="descript">
## Descriptions in your prgs </a>

**Pandora** Keyword `Desc`

If your program files contains a description in one of the ten first lines, **Pandora** has tools to make your life easier. The description must match this format:  
`* Description: Some text *`

#### Syntax samples: 

| Window | You type:  | After pressing `F8`:|
|-------|:----------|:----------------------|
| C | `Desc`           | You get a list of all prgs in your path which have a description|
| C | `Desc aaa` | List of files where the descriptions contains `aaa`|
| E | `Desc` | A `* Description *` template is added in the current line (line 10 or less)|

`C`: Command Window  
`E`: Any VFP editor, normally Modify Command 

<a id="ins">    

## Insert the code from another prg </a>  

Often you want to insert the code from another prg into the active file. Typically this is a small code snippet or a function. Or it can be a header file. With **Pandora** this is extremely simple:

| You type:  | After pressing `F8`:|
|:----------|:----------------------|
| +xxx  | The complete contents of xxx.prg or xxx.h is inserted |
| + xxx | Same as above|
| ins xxx | Same as above|
| insert xxx | Same as above|  
| +xxx.prg  | The complete contents of xxx.prg is inserted |
| +xxx.h  | The complete contents of xxx.h is inserted |

You don't have to add any file extension, in which case **Pandora** will locate the file by adding `.prg` or `.h` to the given file name. If both exist, the first will be used. You can specify the file extension to avoid confusion.

***Note:*** This function only works in a VFP editor

<a id="eval">    

## Insert the result from functions </a> 

If you want to insert the result of a function into your file, **Pandora** makes this extremely easy.

| You type:  | After pressing `F8`:|
|:----------|:----------------------|
| =xxx  | The **result** of function xxx is inserted |
| = xxx  | Same as above |
| eval xxx  |  Same as above |

`xxx` can be **any** VFP function or UDF. Only functions which return a value, are accepted. 

One common use for this feature, is to add misc. comments with important "dynamic" information into the source code.

***Note 1:*** If the function requires parameter(s) with spaces, you must include a space after `=`.  
***Note 2:*** This function only works in a VFP editor 

<a id="pane">    

## Create your own *Pandora* extensions </a>  

The key to using your own **Pandora** extensions, is to remember the `!` symbol. Think "VFP uses ! as shortcut for **run**".  

All **Pandora** extensions must be named `pan_xxx.prg` where `xxx` is the name of the tool.  

To create a tool, type `!xxx` and press `F8`. You are told that the file doesn't exist, and asked if you want to create it. If you confirm, the file is created in one of the following folders:
1. prog (if it exists)
1. prg (if it exists)
1. the default folder  

Write the code you want, and save it.

#### To run a `Pandora` extension:  
Type the same as mentioned above, `!xxx`, and press `F8`. **Pandora** will locate the file and run it.  

#### To see a list of all your **Pandora** extensions:

| You type:                |        Result after pressing `F8`                                |
|:-------------------------|:----------------------------------------------------------|
| ! | Lists all your **Pandora** extensions|
|pan| Same as above|   

Select the one you want, and press **Enter** to run it.

#### To modify a **Pandora** extension:  

| You type:                |        Result after pressing `F8`                                |
|:-------------------------|:----------------------------------------------------------|
| !!    | Lists all **Pandora** extensions|
| paned | Same as above|  
| !!xxx | Same as above, name contains `xxx` |
| !! xxx| Same as above|
| paned xxx| Same as above (note the space after `paned` |

Select the one you want to edit, and press **Enter**.


<a id="suggest">  

# More "extras" to follow, suggestions are welcomed! </a>
