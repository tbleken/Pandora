[![Pandora](Images/pandora2.png)](../README.md)

## Create your own *Pandora* extensions

The key to using your own **Pandora** extensions, is to remember the `!` symbol. Think "VFP uses ! as shortcut for **run**".  

All **Pandora** extensions must be named `pan_xxx.prg` where `xxx` is the name of the tool.  

To create a tool, type `!xxx` and press `F8`. You are told that the file doesn't exist, and asked if you want to create it. If you confirm, the file is created in one of the following folders:
1. prog (if it exists)
1. prg (if it exists)
1. the default folder  

Write the code you want, and save it.

#### To "run" a `Pandora` extension:  
Type the same as mentioned above, `!xxx`, and press `F8`. **Pandora** will locate the file and run it.  

#### To see a list of all your **Pandora** extensions:

| Command| Short                |        Result after pressing `F8`                                |
|:---|:----------------------|:----------------------------------------------------------|
| pan | ! | Lists all your **Pandora** extensions|
|pan xxx| List of all **Pandora** extensions, name contains `xxx` |   

Select the one you want, and press **Enter** to run it.

![ext](Images/panext.png)

<a id="paned">

#### To modify a **Pandora** extension:  </a>

| Command | Short                |        Result after pressing `F8`                                |
|:-------|:------------------|:----------------------------------------------------------|
|<sub>Note 1</sub> paned | !!    | Lists all **Pandora** extensions|
|<sub>Note 2</sub> paned xxx | !! xxx |File `pan_xxx.prg` is opened in the editor |

Note 1: Select the one you want to edit, and press **Enter**.

Note 2: If the named **Pandora** extension means a non existent file, you get an error.

![exted](Images/panexted.png)  

### Sample Pandora Extension:

This program, pan_use.prg, will ease the work of opening a table. It works differently in the command window and in a code window.  

In the command window, type
```!Use yourtable``` and press F8. Now the table is used and selected.

In a code windows, do the same as above. The line is replaced with this:

```foxpro
Select (Select(JustStem("yourtable")))
Use ("yourtable")
```
This is the contents of pan_use.prg:   

```foxpro
* Description: Pandora tool to open a table *
* Pan_use.prg 

Lparameters tcTable
Local lcCommand, llThor, lnWindowType, loEditorWin
m.llThor = Vartype(_Screen.cThorDispatcher) = [C]
If m.llThor
  m.loEditorWin = Execscript(_Screen.cThorDispatcher, [Thor_Proc_EditorWin])
  m.lnWindowType = m.loEditorWin.FindWindow()
  m.loEditorWin.Delete()
  If m.lnWindowType = 0 && Command window
    If !Empty(m.tcTable)
      Text To m.lcCommand Textmerge Noshow Pretext 3
        lnWorkArea = Select(JustStem("<<m.tcTable>>"))
        If m.lnWorkArea > 0
          Select (m.lnWorkArea)
        Else
          Select 0
          try
            Use ("<<m.tcTable>>")
          Catch
            messagebox( Textmerge('No table <<m.tcTable>> found'),48,'Warning!',5000)
          EndTry
        Endif
        If Upper(Alias()) = Upper(JustStem("<<m.tcTable>>"))
          Wait Window at 1,1 Textmerge('Table <<m.tcTable >> is opened') Timeout 3
        Endif
      Endtext
    Else
      m.lcCommand = 'Use'
    EndIf
    Execscript(m.lcCommand)
  Else
    If !Empty(m.tcTable)
      Text To m.lcCommand Textmerge Noshow Pretext 3
        Select (Select(JustStem("<<m.tcTable>>")))
        Use ("<<m.tcTable>>")
      Endtext
    Else
      m.lcCommand = 'Use'
    Endif

    m.loEditorWin.Insert(m.lcCommand + Chr(13))
  Endif
Endif
```


