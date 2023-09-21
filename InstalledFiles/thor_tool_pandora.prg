* Description: Pandora *

Lparameters lxParam1

#Define ccContainerClassName  'clsPandoraSettings'
#Define ccXToolName        'Pandora'
#Define ccPandoraText      'Pandora default file'
#Define ccPandoraHelp 'https://github.com/tbleken/Pandora'
#Define ccPandoraFile 'Pandora.pan'
#Define ccRun 'exe'
#Define ccPipe "|"
#Define ccAmp  [&] + [&]
#Define ccVersion '1.00.00'
#Define ccUnknownCommand 'Illegal command'
#Define ccWaitTimeout 3
#Define ccDescriptionMask1 '* Description:'
#Define ccDescriptionMask2 '*'
#Define ccCursorfiles 'curFiles'
#Define ccCR Chr(13)
#Define ccWantGrid .T.
#Define ccVFPFilesToList [dbf], [scx], [vcx], [prg], [h], [dbc], [frx], [lbx], [mnx], [txt], [pan]
#Define ccVFPTablesExtended [dbf], [dbc], [frx], [lbx], [mnx], [pjx], [scx], [vcx]

****************************************************************
****************************************************************
* Standard prefix for all tools for Thor, allowing this tool to
*   tell Thor about itself.

If Pcount() = 1              ;
    And [O] = Vartype (m.lxParam1)  ;
    And [thorinfo] == Lower (m.lxParam1.Class)

  With m.lxParam1

    * Required
    .Prompt       = [Pandora] && used in menus

    * Optional
    Text To .Description Noshow && a description for the tool
A tool with many features    
    Endtext
    .StatusBarText = []
    .CanRunAtStartUp = .T.

    * These are used to group and sort tools when they are displayed in menus or the Thor form
    .Source       = [TB] && where did this tool come from?  Your own initials, for instance
    .Category      = [] && creates categorization of tools; defaults to .Source if empty
    .Sort       = 0 && the sort order for all items from the same Category

    * For public tools, such as PEM Editor, etc.
    .Version     = [1.00] && e.g., 'Version 7, May 18, 2011'
    .Author        = [TB]
    .Link          = ccPandoraHelp && link to a page for this tool
    .VideoLink     = [] && link to a video for this tool
    .OptionClasses = [clsSetPandoraFile]
    .OptionTool     = [Pandora]


  Endwith

  Return m.lxParam1
Endif
If Pcount() = 0
  Do ToolCode
Else
  Do ToolCode With m.lxParam1
Endif

Return

****************************************************************
****************************************************************
* Normal processing for this tool begins here.                  
Procedure ToolCode
  Lparameters tcCommand
  m.loThor = Execscript (_Screen.cThorDispatcher, [Thor Engine=])
  m.lcFile =  m.loThor.GetOption( ccPandoraText, ccXToolName )
  If Isnull(m.lcFile) Or Empty(m.lcFile)
    m.lcFile = ccPandoraFile
  Endif
  _Screen.AddProperty([cPandoraFile], Alltrim(m.lcFile))
  _Screen.AddProperty([cClip], _Cliptext)
  m.loThor.SetOption(ccPandoraText, ccXToolName, m.lcFile)
  If Empty(m.tcCommand)
    m.loEditor = Execscript(_Screen.cThorDispatcher, [class= HighlightedText from Thor_Proc_HighlightedText.PRG], [Statement], .T.)

    m.lcParsedText = m.loEditor.cHighlightedText
    m.lcParsedText = Evl(m.lcParsedText, [ed])
  Else
    m.lcParsedText = m.tcCommand
  Endif
  Do ProcessText With m.lcParsedText

Endproc

****************************************************************
Function ProcessText
  Lparameters tcLine

  Local lcAlias, lcCommand, lcFormFileName, lcOption, lcParam1, lcReturn, lcText, lcdata, lnWindowType
  Local loEditorWin

  If !Pemstatus(_Screen, [lTest], 5)
    _Screen.AddProperty([lTest], .F.)
  Endif
  _Screen.AddProperty([cPandoraLine], m.tcLine)
  _Screen.AddProperty([lPanComment],.F.)
  m.loEditorWin = Execscript(_Screen.cThorDispatcher, [Thor_Proc_EditorWin])

  m.lnWindowType = m.loEditorWin.FindWindow()
  If m.lnWindowType = 0 && Command window
    Do Case
      Case Left(m.tcLine, 2) = [//] && Command window
        m.tcLine = [dir ] + Substr(m.tcLine, 3)
      Case Left(m.tcLine, 1) = [/] && Command window
        m.tcLine = [dir ] + Substr(m.tcLine, 2)
      Case Left(m.tcLine, 1) = [*]
        m.tcLine = [dir ] + Substr(m.tcLine, 2)
    Endcase
    If m.tcLine = [dir] And Left(Getwordnum(m.tcLine, 2), 1) = [:]
      m.tcLine = Strtran(m.tcLine, [dir ], [dir], 1, 1)
    Endif
  Else
    If Left(m.tcLine, 1) = [*]
      _Screen.lPanComment = .T.
    Endif
  Endif
  m.lcCommand = Lower(Getwordnum(m.tcLine, 1))
  m.lcParam1 = Ltrim(Strextract(m.tcLine, m.lcCommand, [], 1, 1))
  m.lcOption = Getwordnum(Strextract(m.tcLine, [:], []), 1)
  If At([&] + [&], m.lcParam1) > 0
    m.lcParam1 = Trim(Strextract(m.lcParam1, [], [&] + [&]))
  Endif
  If Left(m.lcParam1, 1) = [(]
    m.lcParam1 = Lower(FindFile(Evaluate(m.lcParam1)))
  Endif
  m.lcCommand = Ltrim(m.lcCommand, [*])
  m.lcCommand = Trim(m.lcCommand, 0, Chr(13), Chr(10))
  m.lcParam1 = Trim(m.lcParam1, 0, Chr(13), Chr(10))
  If _Screen.lTest
    Wait Window At 1, 1 Textmerge([Command: <<m.lcCommand >> | Parameter: <<m.lcParam1 >> | Wintype: <<m.lnWindowType >>])
    *!*      Set Step On 
  Endif
  Do Case
    Case m.lcCommand == [help]
      RunEd(ccPandoraHelp )
    Case Inlist(m.lcCommand, [desc], [description])
      Do Case
        Case m.lnWindowType = 0 && Command window
          ListDescript(m.lcParam1, m.lcCommand )
        Case Inlist(m.lnWindowType, 1, 2) && Program or text file
          If m.loEditorWin.GetLineNumber() < 10
            If Empty(m.lcParam1)
              m.lcText = ccDescriptionMask1 + Space(3) + ccDescriptionMask2 + ccCR
            Else
              m.lcText = ccDescriptionMask1 + [ ] + m.lcParam1 + [ ] + ccDescriptionMask2
            Endif
            m.loEditorWin.Delete()
            m.loEditorWin.Insert(m.lcText)
            If Empty(m.lcParam1)
              m.loEditorWin.SetInsertionPoint(m.loEditorWin.GetSelStart() - 4)
            Endif
          Else
            Wait Window [Current line number is outside the Description range (1 to 10)!]
          Endif
      Endcase
    Case m.lnWindowType = 0 And Inlist(m.lcCommand, [pr], [proj], [project])
      ListProjects()
    Case Inlist(m.lcCommand, [menu], [?]) Or (m.lnWindowType > 0 And m.lcCommand = [ed] And Empty(m.lcParam1 ))
      CreatePandoraCursor(m.lnWindowType )
    Case Inlist(m.lcCommand, [ver], [version])
      Messagebox( [Version # ] + ccVersion, 64, [Pandora])
    Case m.lnWindowType > 0 And (Inlist(m.lcCommand, [insert], [ins]) Or m.lcCommand = [+])
      If m.lcCommand = [+] And Empty(m.lcParam1) And Len(m.lcCommand) > 2
        m.lcParam1 = Substr(m.lcCommand, 2)
      Endif
      InsertMethod(m.lcParam1)
    Case Inlist(m.lcCommand, [=], [eval])
      If m.lcCommand = [=] And Empty(m.lcParam1) And Len(m.lcCommand) > 1
        m.lcParam1 = Substr(m.lcCommand, 2)
      Endif
      InsertResult(m.lcParam1 )
    Case Inlist(m.lcCommand, [hotkeys], [hk])
      BrowseHotKeys()
    Case Inlist(m.lcCommand, [th], [thor], [tool], [tools])
      BrowseAllTools()
    Case Left(m.lcCommand, 2) = [!!]
      EditCustomTool(m.lcCommand)
    Case m.lcCommand == [paned]
      EditCustomTool([**] + m.lcParam1 )
    Case Left(m.lcCommand, 1) = [!]
      ListAllCustomTools(Substr(m.lcCommand, 2) )
    Case m.lcCommand == [pan]
      ListAllCustomTools(m.lcParam1 )
    Case Inlist(m.lcCommand, [.], [,])
      RunEd([Pandora.prg])
    Case Isdigit(m.lcCommand ) And m.lcCommand = Transform(Val(m.lcCommand)) And Empty(m.lcParam1) And m.lcCommand = [0] && and m.lnWindowType = 0
      CutCurrentLine()
      Modify File (_Screen.cPandorafile)
    Case Isdigit(m.lcCommand ) And m.lcCommand = Transform(Val(m.lcCommand)) And m.lcCommand = [0] And m.lcParam1 = [?]
      ReportPandoraFile()
    Case Isdigit(m.lcCommand ) And m.lcCommand = Transform(Val(m.lcCommand)) And m.lcCommand = [0] And !Empty(m.lcParam1)
      ChangePandoraFile(m.lcParam1)
    Case Isdigit(m.lcCommand ) And m.lcCommand = Transform(Val(m.lcCommand)) And Empty(m.lcParam1) And m.lnWindowType = 0 && and m.lnWindowType = 0
      getlinestoprocess(Val(m.lcCommand))
    Case Isdigit(m.lcCommand ) And m.lcCommand = Transform(Val(m.lcCommand)) And !Empty(m.lcParam1) And Inlist(Getwordnum(m.lcParam1, 1), [do], ccRun ) And  Inlist(m.lnWindowType, 1, 2)
      If Getwordnum(m.lcParam1, 1) = ccRun
        m.lcParam1 = Strextract(m.lcParam1, ccRun, [])
      Endif
      TryExecute(m.lcParam1)
    Case Isdigit(m.lcCommand ) And m.lcCommand = Transform(Val(m.lcCommand)) And !Empty(m.lcParam1) And Inlist(m.lnWindowType, 1, 2)
      RunEd(m.lcParam1 )
    Case Isdigit(m.lcCommand ) And m.lcCommand = Transform(Val(m.lcCommand))
      ReturnUnknownCommand(1)
    Case m.lcCommand = [ed] And m.lcParam1 = Transform(Val(m.lcParam1 )) && And m.lnWindowType = 0
      If m.lcParam1 = [0]
        Modify File (_Screen.cPandorafile)
      Else
        getlinestoprocess(Val(m.lcParam1 ))
      Endif
    Case m.lnWindowType > 0 And (Left(m.lcCommand, 4) = [#inc] Or Left(m.lcCommand, 3) = [inc])
      GetHeader(m.lcCommand, m.lcParam1  )
    Case Inlist(m.lcCommand, [br], [browse])
      m.lcdata = GetDataFromGrid(Dbf(), [])
    Case m.lcCommand == [no]
      m.lcParam1 = Trim(m.lcParam1, 0, Chr(13), Chr(10), Chr(9))
      Execscript(_Screen.cThorDispatcher, [peme_snippet_no], m.lcParam1 )
    Case m.lcCommand == [op]
      Execscript(_Screen.cThorDispatcher, [peme_snippet_op], m.lcParam1 )
    Case m.lcCommand == [fp]
      m.lcAlias = m.lcParam1
      Execscript(_Screen.cThorDispatcher, [PEME_OpenTable], m.lcAlias)
      m.lcFormFileName = Execscript(_Screen.cThorDispatcher, [Full Path=PEME_Snippet_FP.SCX])
      Do Form (m.lcFormFileName) With m.lcAlias, [], [] To m.lcReturn
      CutCurrentLine()
      WriteCurrentLine(m.lcReturn)
    Case m.lcCommand == [ed] And Empty(m.lcParam1) And Inlist(m.lnWindowType, 0)
      If !CheckOrCreatePandoraFile()
        Return
      Endif
      m.lcParam1 = GetLineNo(_Screen.cPandorafile, 1)
      If Lower(Getwordnum(m.lcParam1, 1)) = [default]
        m.lcParam1 = Getwordnum(m.lcParam1, Getwordcount(m.lcParam1 ))
      Else
        Messagebox( [No Default group defined in ] + _Screen.cPandorafile, 0)
        Return
      Endif
      If Val(m.lcParam1) > 0
        getlinestoprocess(Val(m.lcParam1))
      Else
        RunEd(m.lcParam1)
      Endif
    Case m.lcCommand = [dir!]
      ListFiles(m.lcParam1, m.lcCommand,.T.)
    Case m.lcCommand = [dd] And Inlist(m.lnWindowType, 10)
      MakeDD()
    Case Inlist(m.lcCommand, [dir] ) And m.lcParam1 = [*]
      If Substr(m.lcParam1, 2, 1) = [/]
        m.lcParam1 = Stuff(m.lcParam1, 2, 1, [\])
      Endif
      ListFiles(Substr(m.lcParam1, 2), m.lcCommand )
    Case Inlist(m.lcCommand, [dir], [\], [/], [*] )
      Do Case
        Case Empty(m.lcParam1) And Inlist(m.lcCommand, [\], [/])
          m.lcParam1 = Substr(m.lcCommand, 2)
        Case Empty(m.lcParam1) And Inlist(m.lcCommand, [\\], [//])
          m.lcParam1 = Substr(m.lcCommand, 3)
      Endcase
      If Inlist(Left(m.lcParam1, 1), [!])
        ** Syntax to find Thor files: dir !xx where xx is a part of the filename
        m.lcParam1 = Substr(m.lcParam1, 2)
        ListFiles(m.lcParam1, m.lcCommand,.T.)
      Else
        If Left(m.lcParam1, 2) = [/]
          m.lcParam1 = [\] + Substr(m.lcParam1, 2)
        Endif
        ListFiles(m.lcParam1, m.lcCommand )
      Endif
    Case m.lcCommand == [ed]
      RunEd(m.lcParam1)
    Otherwise
      m.lcParam1 = Evl(m.lcParam1, m.lcCommand)
      Try
        Execscript(_Screen.cThorDispatcher, [thor_tool_repository_executehighlighted])
      Catch
        Try
          Execscript(_Screen.cThorDispatcher, [thor_tool_repository_gotofp])
        Catch
          ReturnUnknownCommand()
        Endtry
      Endtry
  Endcase
  _Cliptext = _Screen.cClip
Endfunc
**********************************************************************
Procedure ChangePandoraFile
  Lparameters tcFile
  Local laFiles[1], lcFile, lnFiles, lnX, loThor

  m.loThor = Execscript (_Screen.cThorDispatcher, [Thor Engine=])
  m.lcFile =  Lower(Trim(m.loThor.GetOption( ccPandoraText, ccXToolName )))
  If Inlist(m.tcFile, [*], [-], [+], [/])
    m.lnFiles = Adir(laFiles, [*.pan])
    Do Case
      Case m.lnFiles = 0
        m.lcFile = [pandora.pan]
      Case m.lnFiles = 1
        m.lcFile = m.laFiles(1, 1)
      Otherwise
        Create Cursor curPanFiles (Filename c(25), Date T)
        For m.lnX = 1 To m.lnFiles
          Insert Into curPanFiles (Filename, Date) Values (Lower(m.laFiles(m.lnX, 1)), dir2dt(m.laFiles(m.lnX, 4), m.laFiles(m.lnX, 3)))
        Endfor
        Index On Filename Tag Filename
        Index On Date Tag Date
        Set Order To Date Descending
        m.lcFile = GetDataFromGrid([Select a file ddd:], [filename])
    Endcase
  Else
    m.lcFile = Forceext(Trim(m.tcFile), [pan])
  Endif
  m.loThor.SetOption(ccPandoraText, ccXToolName, m.lcFile)
  ReportPandoraFile()
Endproc

**********************************************************************

Procedure ReportPandoraFile
  Local lcFile, loThor

  m.loThor = Execscript (_Screen.cThorDispatcher, [Thor Engine=])
  m.lcFile =  Trim(m.loThor.GetOption( ccPandoraText, ccXToolName ))
  CutCurrentLine()
  Messagebox( [Active "Pandora" file is ] + m.lcFile, 64, [Pandora])
Endproc

**********************************************************************

Procedure ListDescript

  Lparameters tcText, tcCommand
  Local laDummy[1], lcContents, lcDescript, lcFile, lcText, lnFiles, lnHandle, lnX1, loContextMenu
  Local loEditorWin As EditorWin Of Home(0) + [Tools\Thor\Thor\Tools\procs\thor_proc_editorwin.prg]
  m.tcText = Evl(m.tcText, [])
  Local laFiles[1], lnX
  Dimension m.laFiles(1)
  m.lnFiles = GetAllFiles(,@m.laFiles)
  If m.lnFiles = 0
    Return
  Endif
  Create Cursor (ccCursorfiles) (Filename c(200), FullName c(200), Descript c(100), Datetime D, Size i, LineS i, Text m, uDescript c(100))
  For m.lnX = 1 To m.lnFiles
    If Lower(Justext(m.laFiles(m.lnX))) =  [prg]
      m.lcDescript = GetDescript(m.laFiles(m.lnX))
      If !Empty(m.lcDescript)
        m.lcFile = Alltrim(m.laFiles(m.lnX))
        Adir(laDummy, m.lcFile)
        Insert Into (ccCursorfiles);
          (Filename, FullName, Descript, uDescript, Datetime, Size) Values;
          (Justfname(m.lcFile),;
            m.lcFile,;
            m.lcDescript,;
            Upper(m.lcDescript),;
            dir2dt(m.laDummy(1, 4), m.laDummy(1, 3)),;
            m.laDummy(1, 2))
      Endif
    Endif
  Endfor
  AddLinesAndText()
  Index On Upper(Filename) Tag Filename
  Index On Upper(FullName) Tag FullName
  Index On Datetime Tag Datetime
  Index On Size Tag Size
  Index On Upper(Descript) Tag Descript
  If !Empty(m.tcText)
    For m.lnX = 1 To Getwordcount(m.tcText)
      m.lcText = Lower(Getwordnum(m.tcText, m.lnX))
      Select * From (ccCursorfiles) Where m.lcText $ Lower(Filename) Or m.lcText $ Lower(Descript) Order By uDescript Into Cursor (ccCursorfiles) Readwrite
    Endfor
  Endif
  If ccWantGrid And File([pg.vcx])
    Go Top
    m.lcSelected = GetDataFromGrid([Fields with description], [Filename], 1)
    If !Empty(m.lcSelected)
      refreshCommandWindow([ed ] + m.lcSelected, m.tcCommand + [ ] + m.tcText )
    Endif
  Else
    m.loContextMenu = Execscript (_Screen.cThorDispatcher, [class= contextmenu])
    Scan
      m.loContextMenu.AddMenuItem(Trim(Descript) + [ - ] + Trim(Filename), , Filename, , Trim(Filename)  )
    Endscan
    m.lcPrefix = [ed ]
    If m.loContextMenu.Activate()
      If !Empty(m.loContextMenu.KeyWord)
        If Empty(m.lcPrefix)
          m.lcText =  Ltrim(m.loContextMenu.KeyWord )
        Else
          m.lcText = m.lcPrefix + [ ] + Ltrim(m.loContextMenu.KeyWord )
        Endif
        refreshCommandWindow(m.lcText, m.tcCommand + [ ] + m.tcText )
      Else
        Wait Window [nothing to do]
      Endif
    Endif
  Endif

Endproc
**********************************************************************

Function dir2dt
  Lparameters tcTime, ttDate
  Local lnSec, lnMin, lnHour, lnDay, lnMonth, lnYear
  m.lnSec = Val(Strextract(m.tcTime, [:], [], 2))
  m.lnMin = Val(Strextract(m.tcTime, [:], [:], 1))
  m.lnHour = Val(Strextract(m.tcTime, [], [:]))
  m.lnDay = Day(m.ttDate)
  m.lnMonth = Month(m.ttDate)
  m.lnYear = Year(m.ttDate)
  Return Datetime(m.lnYear, m.lnMonth, m.lnDay, m.lnHour, m.lnMin, m.lnSec)
Endfunc
**********************************************************************
Procedure ListFiles
  Lparameters tcFilter, tcPrefix, tlThor

  Local laDummy[1], lcOption, lcText, lcWord, llRecords, lnFiles, lnX, loContextMenu
  Local lcFilename
  Local lnMemo



  m.lcOption = Getwordnum(Strextract(m.tcPrefix, [:], []), 1)
  m.tcFilter = Evl(m.tcFilter, [*])
  m.tcFilter = Lower(m.tcFilter)
  If Empty(m.tlThor)
    m.tcPrefix = m.tcPrefix + [ *]
    m.lnFiles = GetFilesInPath([*], ccCursorfiles)
  Else
    m.tcPrefix = m.tcPrefix + [ *!]
    m.lnFiles = GetThorFiles([*], ccCursorfiles)
  Endif
  If m.lnFiles = 0
    Return
  Endif
  Update (ccCursorfiles) Set Fname = [ ] + Fname Where Empty(Justpath(Fname))
  If m.tcFilter = [*]
    Select Fname, Cast(Justfname(Fname) As c(50)) As f1, Filedate, FileSize From (ccCursorfiles) ;
      Into Cursor (ccCursorfiles) Readwrite Where Inlist(Lower(Justext(Fname)), ccVFPFilesToList)
  Else
    For m.lnX = 1 To Getwordcount(m.tcFilter)
      m.lcWord = Getwordnum(m.tcFilter, m.lnX)
      If [.] $ m.tcFilter
        Select Fname, Cast(Justfname(Fname) As c(50)) As f1, Filedate, FileSize From (ccCursorfiles) ;
          Into Cursor (ccCursorfiles) Readwrite Where m.lcWord $ Lower(Fname)
      Else
        Select Fname, Cast(Justfname(Fname) As c(50)) As f1, Filedate, FileSize From (ccCursorfiles) ;
          Into Cursor (ccCursorfiles) Readwrite Where m.lcWord $ Lower(Fname);
          And Inlist(Lower(Justext(Fname)), ccVFPFilesToList)
      Endif
    Endfor
  Endif
  If Reccount(ccCursorfiles) = 0
    Wait Window [No files found !!!!!]
    Return
  Endif
  Select f1 As Filename, Alltrim(Fname) As FullName, Filedate, FileSize From (ccCursorfiles) Into Cursor (ccCursorfiles) Readwrite Order By 1
  m.llRecords = .F.
  If [r] $ m.lcOption
    Select Count(*) From (ccCursorfiles) Where Inlist(Lower(Justext(Filename)), ccVFPTablesExtended) Into Array laDummy
  Else
    Select Count(*) From (ccCursorfiles) Where Inlist(Lower(Justext(Filename)), [dbf]) Into Array laDummy
  Endif
  m.llRecords = m.laDummy  > 0
  If m.llRecords And Empty(Field([records]))
    Alter Table (ccCursorfiles) Add Column RecordS i
  Endif
  If [r] $ m.lcOption
    Set Filter To Inlist(Lower(Justext(Filename)), ccVFPTablesExtended)
  Else
    Set Filter To Inlist(Lower(Justext(Filename)), [dbf])
  Endif
  Scan For RecordS = 0
    Replace RecordS With GetRecordsInDBF(FullName)
  Endscan
  Set Filter To
  If [c] $ m.lcOption
    Alter Table (ccCursorfiles) Add Column LineS i
    Alter Table (ccCursorfiles) Add Column Text m
    AddLinesAndText()
  Endif
  If !Empty(Field([records]))
    Index On RecordS Tag RecordS
  Endif
  Index On Upper(FullName) Tag FullName
  Index On Upper(Filename) Tag Filename
  Index On Filedate Tag Filedate
  Index On FileSize Tag FileSize
  Set Order To
  If ccWantGrid
    m.lcText = GetDataFromGrid([Select a file:], [fullname], 0)
    Do Case
      Case Lower(Justext(m.lcText)) = [pan]
        Modify File (m.lcText)
      Case !Empty(m.lcText)
        RunEd(m.lcText)
    Endcase
  Else
    m.loContextMenu = Execscript (_Screen.cThorDispatcher, [class= contextmenu])
    Scan
      m.loContextMenu.AddMenuItem(Trim(FullName), , FullName, , Trim(FullName)  )
    Endscan
    If m.loContextMenu.Activate()
      If !Empty(m.loContextMenu.KeyWord)
        m.lcText = Ltrim(m.loContextMenu.KeyWord )
        refreshCommandWindow([ed ] + m.lcText, m.tcPrefix + m.tcFilter )
      Else
        Wait Window [nothing to do]
      Endif
    Endif
  Endif


Endproc

**********************************************************************
Procedure refreshCommandWindow
  Lparameters tcText, tcOriginal
  Local loEditorWin

  m.loEditorWin = Execscript(_Screen.cThorDispatcher, [Thor_Proc_EditorWin])
  m.loEditorWin.Delete()
  m.loEditorWin.Insert(m.tcOriginal)
  If !Empty(m.tcText)
    ProcessText(m.tcText)
  Endif
Endproc

**********************************************************************
Function GetRecordsInDBF
  Lparameters tcFileName
  Local lcContents, lcLen, lnHandle
  Local lnRec
  If Empty(m.tcFileName)
    Return - 1
  Endif
  If Empty(Justext(m.tcFileName))
    m.tcFileName = Forceext(m.tcFileName, [dbf])
  Endif
  Try
    m.lnHandle = Fopen(m.tcFileName )
    m.lcContents = Fread(m.lnHandle, 20)
    m.lcLen = Substr(m.lcContents, 5, 4)
    Fclose(m.lnHandle )
    m.lnRec = CToBin(m.lcLen, [4RS])
  Catch
    Try
      Use (m.tcFileName) Again In 0 Alias GetRecords
      m.lnRec = Reccount([GetRecords])
      Use In GetRecords
    Catch
      m.lnRec = -2
    Endtry
  Endtry
  Return m.lnRec

  **********************************************************************
Function GetThorFiles
  Lparameters tcMask, tcCursor
  Local laDummy[1], laFolders[1], lcFileSkel, lnFiles, lnFolders, lnX, lnX2
  m.tcCursor = Evl(m.tcCursor, [curFiles])
  Create Cursor (m.tcCursor) (Fname c(200), Filedate D, FileSize i)
  m.tcMask = Evl(m.tcMask, [prg])
  Dimension m.laFolders(3)
  m.laFolders(1) = _Screen.Cthorfolder + [Tools]
  m.laFolders(2) = _Screen.Cthorfolder + [Tools\My tools]
  m.laFolders(3) = _Screen.Cthorfolder + [procs]

  m.lnFolders = Alen(m.laFolders)
  For m.lnX = 1 To m.lnFolders
    If m.lnX = 0
      m.lcFileSkel = [*.] + m.tcMask
    Else
      m.lcFileSkel = Alltrim(m.laFolders(m.lnX)) + [\*.] + m.tcMask
    Endif
    m.lnFiles = Adir(laDummy, m.lcFileSkel)
    If m.lnFiles > 0
      For m.lnX2 = 1 To m.lnFiles
        m.ldDate = m.laDummy(m.lnX2, 3)
        m.lnSize = m.laDummy(m.lnX2, 2)
        If m.lnX = 0
          Insert Into (m.tcCursor) (Fname, Filedate, FileSize) Values (m.laDummy(m.lnX2, 1), m.ldDate, m.lnSize )
        Else
          Insert Into (m.tcCursor) (Fname, Filedate, FileSize) Values (Trim(m.laFolders(m.lnX)) + [\] + m.laDummy(m.lnX2, 1), m.ldDate, m.lnSize )
        Endif
      Endfor
    Endif
  Endfor
  Return Reccount()
Endfunc
**********************************************************************
Function ListProjects
  Local lcClip, lcTable, lcText, loEditorWin
  Local lcSelected


  m.lcTable = _Screen.cPandorafile
  Local loContextMenu As ContextMenu Of [C:\VFP9\Tools\Thor\Source\thor_menu.vcx]
  m.lcClip = _Cliptext
  m.loEditorWin = Execscript(_Screen.cThorDispatcher, [Thor_Proc_EditorWin])
  If m.loEditorWin.FindWindow() = 0
    Create Cursor curProjects (text1 c(200), Projnotxt c(3), Project c(50), projno i)
    Append From (m.lcTable) Sdf
    Replace All Projnotxt With Ltrim(Strextract(text1, [#], [ ], 1)),;
      projno With Val(Strextract(text1, [#], [ ], 1))
    Replace All Project With Strextract(text1, [ ], [], 1) For projno > 0
    Select Projnotxt, Project  From curProjects x;
      Where x.projno > 0 Order By projno;
      Into Cursor curProjects Readwrite
    If _Tally > 0
      If ccWantGrid And File([pg.vcx])
        Select Projnotxt As ProjectNo, Project  From curProjects Into Cursor curProjects Readwrite
        Go Top
        m.lcText = GetDataFromGrid([Select project], [projectno])
        If !Empty(m.lcText)
          ProcessText(m.lcText)
        Endif
      Else

        m.loContextMenu = Execscript (_Screen.cThorDispatcher, [class= contextmenu])
        Scan
          m.loContextMenu.AddMenuItem(Ltrim(curProjects.Projnotxt) + curProjects.Project, , , , curProjects.Projnotxt)
        Endscan
        If m.loContextMenu.Activate()
          m.lcText = Trim(m.loContextMenu.KeyWord)
        Else
          m.lcText = []
        Endif
      Endif
      If !Empty(m.lcText)
        ProcessText(m.lcText)
      Endif
    Endif
    m.loEditorWin.Delete()
  Endif
Endfunc

**********************************************************************
Function ReturnUnknownCommand
  Lparameters tnText
  _Cliptext = _Screen.cClip
  Do Case
    Case Empty(m.tnText)
      m.lcText = ccUnknownCommand + [!]
    Case m.tnText = 1
      m.lcText = ccUnknownCommand + [ in this window!]
  Endcase
  Wait Window m.lcText Timeout ccWaitTimeout
Endfunc

**********************************************************************
Function GetHeader
  Lparameters tcOriginalLine, tcParameter
  Local laHeaders[1], lcNewText, loEditorWin
  Local laList[1], lcClip, lcTextOriginal
  Local lnPos
  m.lcClip = _Cliptext
  If GetFilesInPath([H], ccCursorfiles) = 0
    _Cliptext = _Screen.cClip
    Return
  Endif
  m.loEditorWin = Execscript(_Screen.cThorDispatcher, [Thor_Proc_EditorWin])
  m.lnPos = m.loEditorWin.GetSelend() - 1
  m.loEditorWin.Select(m.lnPos, m.lnPos )
  m.lcTextOriginal = Trim(CutCurrentLine(), 0, Chr(13), Chr(10))
  Select Fname, Justfname(Fname) From (ccCursorfiles) Into Array laList
  WriteCurrentLine(m.lcTextOriginal)
  Execscript (_Screen.cThorDispatcher, [Thor_Proc_DropDown], @m.laList)
  If Lastkey() = 27
    ReturnUnknownCommand()
  Endif
  HighlightCurrentLine()
  m.loEditorWin = Execscript(_Screen.cThorDispatcher, [Thor_Proc_EditorWin])
  m.loEditorWin.Cut()
  m.loEditorWin.Insert([#Include ] + Getwordnum(_Cliptext, Getwordcount(_Cliptext)))

Endfunc
**********************************************************************
Function TryExecute(tcParameter)
  Try
    Execscript(m.tcParameter )
  Catch
    Wait Window ccUnknownCommand
  Endtry
Endfunc

**********************************************************************
Function WriteCurrentLine
  Lparameters tcText
  Local lcClip, loEditorWin

  If Vartype(m.tcText) # [C]
    Return
  Endif
  m.loEditorWin = Execscript(_Screen.cThorDispatcher, [Thor_Proc_EditorWin])
  m.loEditorWin.Insert(m.tcText)

Endfunc
**********************************************************************
Function CutCurrentLine
  Local loEditorWin
  m.lcClip = _Cliptext
  HighlightCurrentLine()
  m.loEditorWin = Execscript(_Screen.cThorDispatcher, [Thor_Proc_EditorWin])
  m.loEditorWin.Copy()
  m.lcText = _Cliptext
  _Cliptext = m.lcClip
  m.loEditorWin.Cut()
  Return m.lcText
Endfunc
****************************************************************
Function HighlightCurrentLine
  Local lnEndPos, loEditorWin

  m.loEditorWin  = Execscript(_Screen.cThorDispatcher, [Thor_Proc_EditorWin])
  m.lnEndPos = m.loEditorWin.GetLineStart(m.loEditorWin.GetSelStart(), 1)
  If m.loEditorWin.GetLineNumber(m.lnEndPos) < m.loEditorWin.GetLineNumber(1e8)
    m.lnEndPos = m.lnEndPos - 1
  Endif
  m.loEditorWin.Select(m.loEditorWin.GetLineStart(m.loEditorWin.GetSelStart(), 0), m.lnEndPos )
Endfunc
**********************************************************************
Function getlinestoprocess
  Lparameters tnGroup
  Local laLines[1], lcCommand, lnCounter, lnLine, lnLines
  Local llFound

  If !CheckOrCreatePandoraFile()
    Return
  Endif
  m.llFound = .F.
  m.lnLines = Alines(laLines, Filetostr(_Screen.cPandorafile))
  For m.lnCounter = 1 To m.lnLines
    m.lnLine = Val(Getwordnum(m.laLines(m.lnCounter), 1))
    If m.lnLine = m.tnGroup Or (m.lnLine = 0 And Getwordnum(m.laLines(m.lnCounter), 1) = [0])
      m.llFound = .T.
      m.lcCommand = Strextract(m.laLines(m.lnCounter), [ ])
      If ccAmp $ m.lcCommand
        m.lcCommand = Strextract(m.laLines(m.lnCounter), [ ], ccAmp, 1)
      Endif
      If Lower(Getwordnum(m.lcCommand, 1)) = [do]
        Execscript(m.lcCommand)
      Else
        RunEd(m.lcCommand)
      Endif
    Endif
  Endfor
  If !m.llFound
    Messagebox( [Group number ] + Transform(m.tnGroup) + [ doesn't exist in ] + _Screen.cPandorafile, 0, [Nothing to do!])
  Endif
Endfunc

**********************************************************************
Function CheckOrCreatePandoraFile
  If File(_Screen.cPandorafile)
    Return .T.
  Else
    If Messagebox( [Specified file "] + _Screen.cPandorafile + [" doesn't exist, create empty file?], 4, [File not found!]) = 6
      Strtofile([], _Screen.cPandorafile)
      Modify File (_Screen.cPandorafile)
    Endif
    Return .F.
  Endif
Endfunc
**********************************************************************
Function InsertIndents
  Lparameters tcText, tcIndent
  Local laDummy[1], lcReturn, lcText

  m.tcText = Evl(m.tcText, _Cliptext)
  If Vartype(m.tcIndent) # [C]
    m.tcIndent = Evl(m.tcIndent, Space(0))
  Endif
  Alines(laDummy, m.tcText )
  m.lcReturn = []
  For Each m.lcText In m.laDummy
    m.lcReturn = m.lcReturn + m.tcIndent + m.lcText  + ccCR
  Endfor
  Return m.lcReturn
Endfunc
*************************************************************************

Function RunEd(tcPar)
  m.lcParOrg = m.tcPar
  m.lcParam1 = m.tcPar
  If Empty(m.tcPar) Or (Val(m.tcPar) > 0 And m.tcPar = Transform(Val(m.tcPar)))
    Messagebox( [Illegal command!])
    m.lnLine = Val(m.tcPar)
    m.lnLine = Evl(m.lnLine, 1)
    If File(_Screen.cPandorafile )
      m.lcParam1 = GetNumberedline(_Screen.cPandorafile, m.lnLine )
    Else
      Return
    Endif
  Endif
  If m.lcParam1 = [0]
    m.lcParam1 = _Screen.cPandorafile
  Endif
  m.lcParam1 = Chrtran(m.lcParam1, ccPipe, [])
  m.lcParam1 = Alltrim(m.lcParam1, 0, [!], Chr(13))
  If ccAmp $ m.lcParam1
    m.lcParam1 = Left(m.lcParam1, At(ccAmp, m.lcParam1))
  Endif
  If [(] $ m.lcParam1 And Getwordnum(m.lcParam1, 1) # ccRun
    m.lcParam1 = Evaluate(m.lcParam1)
    If Vartype(m.lcParam1) = [L] && Function was called
      Return
    Endif
  Endif
  m.lcFolder = [classes\]
  m.lnLineNo = Int(Val(Strextract(m.lcParam1, [:], [])))
  Do Case
    Case [.scx] $ m.lcParam1
      m.lcExt = [scx]
    Case [.vcx] $ m.lcParam1
      m.lcExt = [vcx]
    Case [.prg] $ m.lcParam1
      m.lcExt = [prg]
    Case Occurs([.], m.lcParam1) = 1
      m.lcExt = Justext(m.lcParam1)
    Case [.txt] $ m.lcParam1
      m.lcExt = [txt]
    Case [.pan] $ m.lcParam1
      m.lcExt = [pan]
    Otherwise
      m.lcExt = []
  Endcase
  m.lcFile = Strextract(m.lcParam1, [], m.lcExt, 1, 4)
  Do Case
    Case Inlist(Lower(Strextract(m.lcParam1, [], [:], 1, 4)), [http:], [https:])
      shellX(m.lcParam1)
    Case m.lcExt = [pan]
      Modify File (m.tcPar)
    Case m.lcExt = [vcx] Or m.lcExt = [scx]
      If [:] $ m.lcParam1
        m.lcParameters = Strextract(m.lcParam1, m.lcExt + [.], [:])
      Else
        m.lcParameters = Strextract(m.lcParam1, m.lcExt + [.])
      Endif
      m.lcObject = Getwordnum(m.lcParameters, 1, [.])
      m.lcMethod = Substr(m.lcParameters, Len(m.lcObject) + 2)
      m.loTools = Execscript (_Screen.cThorDispatcher, [Class= tools from pemeditor])
      m.loTools.Editsourcex(m.lcFile, m.lcObject, m.lcMethod, m.lnLineNo)
    Case Getwordnum(m.lcParam1, 1) = ccRun
      Try
        Execscript(Strextract(m.lcParam1, ccRun, []))
      Catch
        Wait Window ccUnknownCommand
      Endtry
      TryExecute(Strextract(m.lcParam1, ccRun, []))
    Case m.lcExt = [prg]
      If m.lnLineNo > 0
        m.lcParam1 = Strextract(m.lcParam1, [], [:])
        Editsource(m.lcParam1, m.lnLineNo)
      Else
        m.loTools = Execscript (_Screen.cThorDispatcher, [Class= tools from pemeditor])
        m.loTools.Editsourcex(m.lcParam1 )
      Endif
    Otherwise
      m.loTools = Execscript (_Screen.cThorDispatcher, [Class= tools from pemeditor])
      m.loTools.Editsourcex(m.lcParam1 )
  Endcase
Endfunc
*************************************************

Function GetAllFiles(tcDirectory, laFiles)
  Local laTemp[1, 5], ;
    lcFile As String, ;
    lcOldDir As String, ;
    lnCount As Number, ;
    lnLen As Number, ;
    lnMax As Number
  m.lcOldDir = Fullpath(Curdir())
  If Empty(m.tcDirectory)
    m.tcDirectory = m.lcOldDir
  Endif
  Set Default To (m.tcDirectory)
  = Adir(laTemp, [*.*], [AHRSD], 1)
  m.lnMax = Alen(m.laTemp, 1)
  For m.lnCount = 1 To m.lnMax
    m.lcFile = Alltrim(m.laTemp(m.lnCount, 1))
    If !(m.lcFile == [.]) And !(m.lcFile == [..])
      If [D] $ m.laTemp(m.lnCount, 5)
        = GetAllFiles(Addbs(m.tcDirectory + m.lcFile), @m.laFiles)
      Else
        m.lnLen = Alen(m.laFiles)
        If !Empty(m.laFiles(m.lnLen))
          Dimension m.laFiles(m.lnLen + 1)
          m.lnLen = m.lnLen + 1
        Endif
        m.laFiles(m.lnLen) = m.tcDirectory + m.lcFile
      Endif
    Endif
  Endfor
  Set Default To (m.lcOldDir)
  Return Alen(m.laFiles, 1)
  *****************************************************************
Function GetNumberedline
  Lparameters tcFile, tnLine
  m.lnLines = Alines(laDummy, Filetostr(m.tcFile))
  m.lcReturn = []
  If m.lnLines > 0
    For m.lnX = 1 To m.lnLines
      m.lnLine = Val(Getwordnum(m.laDummy(m.lnX), 1))
      If m.lnLine = m.tnLine
        m.lcReturn = Strextract(m.laDummy(m.lnX), [ ])
        If ccAmp $ m.lcReturn
          m.lcReturn = Strextract(m.laDummy(m.lnX), [ ], ccAmp, 1)
        Endif
        Exit
      Endif
    Endfor
  Endif
  Return m.lcReturn
Endfunc
**************************************************
Function GetLineNo
  Lparameters tcFile, tnLine
  m.lnLines = Alines(laDummy, Filetostr(m.tcFile))
  m.lcReturn = []
  If m.tnLine <= m.lnLines
    m.lcReturn = m.laDummy(m.tnLine)
  Endif
  Return m.lcReturn
Endfunc
**************************************************
Function shellX
  Lparameters tcURL, tcParameter
  If Empty(m.tcParameter)
    m.tcParameter = []
  Endif
  #Define SW_HIDE 0
  #Define SW_SHOWNORMAL 1
  #Define SW_SHOWMINIMIZED 2
  #Define SW_SHOWMAXIMIZED 3
  *!*   Legal verbs: open, edit, print, find, explore, NULL
  Declare Integer ShellExecute In shell32.Dll ;
    Integer hndWin, String cAction, String cFileName, ;
    String cParams, String cDir, Integer nShowWin
  ShellExecute( 0, [open], m.tcURL, m.tcParameter, [], SW_SHOWNORMAL )
Endfunc
**************************************************  

Function clipIsText
  #Define CF_TEXT           1
  Declare short IsClipboardFormatAvailable In win32api Integer cbformat
  Return IsClipboardFormatAvailable(CF_TEXT) # 0
  **************************************************  

Function FindFile
  Lparameters tcFile, tcFilter
  If Empty(m.tcFilter)
    m.tcFilter = ['dbf','vcx','scx','prg','txt']
  Endif
  m.lcPath = Justpath(m.tcFile)
  m.lcFile = []
  m.lcReturn = []
  Do Case
    Case Adir(laFiles, m.tcFile) = 1
      m.lcFile = m.tcFile
    Case !Empty(m.lcPath)
      If Empty(Justext(m.tcFile))
        m.lnFiles = Adir(laFiles, Forceext(m.tcFile, [*]))
        If m.lnFiles > 1
          For m.lnX = 1 To m.lnFiles
            If Inlist(Lower(Justext(m.laFiles(m.lnX, 1))),&tcFilter)
              m.lcFile = m.laFiles(m.lnX, 1)
              Exit
            Endif
          Endfor
        Endif
      Else
      Endif
    Otherwise
      Wait Window [some other case... Must be handled]
  Endcase
  If !Empty(m.lcFile)
    m.lcReturn = Fullpath(Forcepath(m.lcFile, m.lcPath))
  Endif
  Return m.lcReturn
Endfunc

****************************************************************
Procedure BrowseHotKeys
  #Define ccTool         'Browse all Thor Tools'
  m.llExcludeNotUsed = Execscript(_Screen.cThorDispatcher, [Get Option=], ccTool, ccTool)
  m.lcDestAlias = [curHotKeys]
  m.lnSelect = Select()
  Execscript(_Screen.cThorDispatcher, [Thor_Proc_GetHotKeyDefs], m.lcDestAlias, m.llExcludeNotUsed )
  Select Distinct Cast(Descript As c(100)) As Descript, Chrtran(HotKey, [-], [+]) As HotKey, Cast([] As c(10)) As sortkey, Favorite, PRGName, StatusBar From (m.lcDestAlias);
    Where !Empty(HotKey ) And Substr(Descript, 3, 1) # [-] Into Cursor (m.lcDestAlias ) ;
    Readwrite
  Scan
    m.lcHotkey = HotKey
    Select Recno() From (_Screen.Cthorfolder + [\source\hotkeys])  hotkeys Where hotkeys.Key = Substr(m.lcHotkey, 1 + Rat([+], m.lcHotkey ), 10) Into Array laDummy
    Replace sortkey With Padl(laDummy, 2, [ ]) + m.lcHotkey
  Endscan
  Select HotKey, Descript, Favorite, PRGName From (m.lcDestAlias) Into Cursor (m.lcDestAlias) Order By sortkey Readwrite
  Index On Lower(HotKey) Tag HotKey
  Index On Lower(Descript) Tag Descript
  Index On Favorite Tag Favorite
  Set Order To
  m.lcProg = GetDataFromGrid([Thor tools], [prgname], 1)
  Use
  Select (m.lnSelect)
  If !Empty(m.lcProg)
    Execscript(_Screen.cThorDispatcher, m.lcProg)
  Endif
  If !_Screen.lPanComment
    CutCurrentLine()
  Endif

Endproc
****************************************************************
Procedure BrowseAllTools
  #Define ccTool         'Browse all Thor Tools'
  Local laDummy[1], lcDesc, lcDestAlias, lcHotkey, lcProg, llExcludeNotUsed, lnSelect

  m.llExcludeNotUsed = Execscript(_Screen.cThorDispatcher, [Get Option=], ccTool, ccTool)
  m.lcDestAlias = [curHotKeys]
  m.lnSelect = Select()
  Execscript(_Screen.cThorDispatcher, [Thor_Proc_GetHotKeyDefs], m.lcDestAlias, m.llExcludeNotUsed )
  Select Distinct Cast(Ltrim(Descript) As c(100)) As Descript, Chrtran(HotKey, [-], [+]) As HotKey, Cast([] As c(10)) As sortkey, Favorite, PRGName, StatusBar From (m.lcDestAlias);
    Into Cursor (m.lcDestAlias ) Where Left(Descript, 1) # [ ] And Substr(Descript, 3, 1) # [-];
    Readwrite
  Scan
    m.lcHotkey = HotKey
    Select Recno() From (_Screen.Cthorfolder + [\source\hotkeys])  hotkeys Where hotkeys.Key = Substr(m.lcHotkey, 1 + Rat([+], m.lcHotkey ), 10) Into Array laDummy
    If _Tally > 0
      Replace sortkey With Padl(m.laDummy, 2, [ ]) + m.lcHotkey
    Endif
  Endscan
  Select HotKey, Descript, Favorite, PRGName From (m.lcDestAlias) Into Cursor (m.lcDestAlias) Readwrite
  m.lcDesc = []
  m.lcHotkey = []
  Scan
    If Lower(Descript) == m.lcDesc And Lower(HotKey) = m.lcHotkey
      Delete
    Endif
    m.lcDesc = Lower(Descript)
    m.lcHotkey = Lower(HotKey)
  Endscan
  Select * From (m.lcDestAlias ) Into Cursor (m.lcDestAlias ) Readwrite Where !Deleted()
  Index On Favorite Tag Favorite
  Index On HotKey Tag HotKey
  Index On Descript Tag Descript
  Locate
  m.lcProg = GetDataFromGrid([Thor tools], [prgname], 1)
  Use
  Select (m.lnSelect)
  If !Empty(m.lcProg)
    Execscript(_Screen.cThorDispatcher, m.lcProg)
  Endif
  If !_Screen.lPanComment
    CutCurrentLine()
  Endif
Endproc
****************************************************************
Function GetDataFromGrid
  Lparameters tcCaption, tcReturnField, tnHideColumns, tnWidth
  Local lcHideColumns, lcParameter, lcReturn, lcVCXFile

  m.lcReturn = []
  If !Empty(Dbf())
    m.lcVCXFile = Execscript(_Screen.cThorDispatcher, [Full Path=] + [thor_proc_pandora.VCX])
    m.lcHideColumns = Replicate([L], Evl(m.tnHideColumns, 0))
    m.lcParameter = [1U] + m.lcHideColumns
    m.loPg = Newobject([pg], m.lcVCXFile, [], m.lcParameter )
    m.loPg.Caption = Alltrim(m.tcCaption)
    m.loPg.nIncStart = 0
    m.loPg.lShowZero = .F.
    If !Empty(m.tnWidth) And Vartype(m.tnWidth) = [N]
      m.loPg.Width = m.tnWidth
    Endif
    m.loPg.Show(1)
    If !Inlist(Lastkey(), 97, 33) And !Empty(m.tcReturnField)
      m.lcReturn = Alltrim(Evaluate(m.tcReturnField))
    EndIf
  Else
    messagebox( "No table or cursor is selected",0+48, 'Pandora grid')
  Endif
  Return m.lcReturn
Endfunc
****************************************************************
Procedure ListAllCustomTools
  Lparameters tcFileName
  Local lnSelect
  Local lcDescript, lcPath

  If Empty(m.tcFileName)
    Local lcCursor, lcProg, lnTools
    m.lnSelect = Select()
    m.lcCursor = [curCustom]
    m.lnTools = GetFilesInPath([prg], m.lcCursor )
    Select Cast(Lower(Substr(Juststem(Fname), 5)) As c(30)) As Program, FileSize, Filedate, Cast([] As c(100)) As Descript, Fname From (m.lcCursor) Into Cursor (m.lcCursor) Readwrite Where Lower(Left(Juststem(Fname), 4)) = [pan_]
    If _Tally = 0
      Messagebox( [No tool matching pan_ *.prg found], 0 + 48, [No custom tool defined])
    Else
      Scan
        m.lcFile = Alltrim(Fname)
        m.lcDescript = GetDescript(m.lcFile )
        If !Empty( m.lcDescript )
          Replace Descript With m.lcDescript
        Endif
      Endscan
      Go Top
      m.lcProg = GetDataFromGrid([My "Pandora" extensions (R/O):], [fname], 1)
      Use
      Select (m.lnSelect)
      If !Empty(m.lcProg)
        Do (m.lcProg)
      Endif
      If !_Screen.lPanComment
        CutCurrentLine()
      Endif

    Endif
  Else
    m.lcProg = Forceext([pan_] + m.tcFileName, [prg])
    If File(m.lcProg )
      Do (m.lcProg )
    Else
      If Messagebox( [File ] + m.lcProg + [ is not found], 4 + 48, [Create it?]) = 6
        Do Case
          Case Directory([prog])
            m.lcPath = [prog]
          Case Directory([prg])
            m.lcPath = [prg]
          Otherwise
            m.lcPath = []
        Endcase
        _Screen.lPanComment = .F.
        Modify Command (Forcepath(m.lcProg, m.lcPath))
      Endif
    Endif
  Endif
  If !_Screen.lPanComment
    CutCurrentLine()
  Endif
Endproc
****************************************************************
Procedure EditCustomTool
  Lparameters tcCommand
  m.lcProg = Substr(m.tcCommand, 3)
  m.lcProgFile = Forceext([pan_] + m.lcProg, [prg])
  If !Empty(m.lcProg)
    If File(m.lcProgFile)
      Modify Command (m.lcProgFile)
    Else
      Messagebox( [File ] + m.lcProgFile + [ is not found!], 0 + 48, [Nothing to do])
    Endif
  Else
    m.lnSelect = Select()
    m.lcCursor = [curCustom]
    m.lnTools = GetFilesInPath([prg], m.lcCursor )
    *!*  Browse Normal   
    Select Cast(Lower(Substr(Juststem(Fname), 5)) As c(30)) As Program, FileSize, Filedate, Cast([] As c(100)) As Descript, Fname From (m.lcCursor) Into Cursor (m.lcCursor) Readwrite Where Lower(Left(Juststem(Fname), 4)) = [pan_]
    If _Tally = 0
      Messagebox( [No tool matching pan_ *.prg found], 0 + 48, [No custom tool defined])
    Else
      Scan
        m.lcFile = Alltrim(Fname)
        m.lcDescript = GetDescript(m.lcFile )
        If !Empty( m.lcDescript )
          Replace Descript With m.lcDescript
        Endif
      Endscan
      Go Top
      m.lcProg = GetDataFromGrid([My "Pandora" extensions:], [fname], 1)
      Use
      Select (m.lnSelect)
      If !Empty(m.lcProg)
        Modify Command (m.lcProg)
      Endif
      If !_Screen.lPanComment
        CutCurrentLine()
      Endif

    Endif

  Endif
Endproc
****************************************************************
Function GetFilesInPath
  Lparameters tcMask, tcCursor
  Local laDummy[1], laFolders[1], lcFileSkel, lnFiles, lnFolders, lnX, lnX2

  m.tcCursor = Evl(m.tcCursor, [curFiles])
  Create Cursor (m.tcCursor) (Fname c(200), Filedate D, FileSize i)
  m.tcMask = Evl(m.tcMask, [prg])
  m.lnFolders = Alines(laFolders, Set([Path]), 1 + 4, [;], [,])
  For m.lnX = 0 To m.lnFolders
    If m.lnX = 0
      m.lcFileSkel = [*.] + m.tcMask
    Else
      m.lcFileSkel = Alltrim(m.laFolders(m.lnX)) + [\*.] + m.tcMask
    Endif
    m.lnFiles = Adir(laDummy, m.lcFileSkel)
    If m.lnFiles > 0
      For m.lnX2 = 1 To m.lnFiles
        m.lnSize = m.laDummy(m.lnX2, 2)
        m.ldDate = m.laDummy(m.lnX2, 3)
        If m.lnX = 0
          Insert Into (m.tcCursor) (Fname, Filedate, FileSize) Values (m.laDummy(m.lnX2, 1), m.ldDate, m.lnSize )
        Else
          Insert Into (m.tcCursor) (Fname, Filedate, FileSize) Values (Trim(m.laFolders(m.lnX)) + [\] + m.laDummy(m.lnX2, 1), m.ldDate, m.lnSize )
        Endif
      Endfor
    Endif
  Endfor
  Return Reccount()
Endfunc
****************************************************************
Function GetDescript
  Lparameters tcFile
  Local lcContents, lcDescript, lnHandle, lnX1

  m.lnHandle = Fopen(m.tcFile )
  m.lcDescript = []
  For m.lnX1 = 1 To 10
    m.lcContents = Fgets(m.lnHandle)
    If Occurs(ccDescriptionMask1, m.lcContents) > 0
      m.lcDescript = Alltrim(Strextract(m.lcContents, ccDescriptionMask1, ccDescriptionMask2 ))
      Exit
    Endif
  Endfor
  Fclose(m.lnHandle)
  Return m.lcDescript
Endfunc
****************************************************************
Procedure InsertMethod
  Lparameters tcMethod

  Local lcText

  m.lcText = []
  If Empty(Justext(m.tcMethod))
    Do Case
      Case File(Forceext(m.tcMethod, [prg]))
        m.tcMethod  = Forceext(m.tcMethod, [prg])
      Case File(Forceext(m.tcMethod, [h]))
        m.tcMethod  = Forceext(m.tcMethod, [h])
      Otherwise
        *
    Endcase
  Endif
  If File(m.tcMethod)
    m.lcText = Filetostr(m.tcMethod)
  Endif
  If !Empty(m.lcText)
    WriteCurrentLine(m.lcText + ccCR )
    CutCurrentLine()
  Else
    Messagebox( [No text is inserted], 0 + 48, m.tcMethod)
  Endif

Endproc
****************************************************************
Procedure AddLinesAndText
  Local lnMemo

  m.lnMemo = Set([Memowidth])
  Set Memowidth To 8192
  Scan For Inlist(Lower(Justext(Filename)), [prg], [txt], [h])
    Replace Text With Filetostr(Alltrim(Filename))
    Replace LineS With Memlines(Text)
  Endscan
  Set Memowidth To m.lnMemo
  Index On LineS Tag LineS
Endproc
****************************************************************
Procedure InsertResult
  Lparameters tcMethod
  m.lcText = []
  If !Right(m.tcMethod, 1) = [)]
    m.tcMethod = m.tcMethod + [()]
  Endif
  Try
    m.lcText = Transform(Evaluate(m.tcMethod))
  Catch
    Messagebox( [No or invalid result!], 0 + 48, m.tcMethod)
  Endtry
  If !Empty(m.lcText)
    WriteCurrentLine(m.lcText + ccCR)
    CutCurrentLine()
  Endif

Endproc

****************************************************************
Procedure MakeDD && Creates DoDefault call
  Local lcResult

  m.lcResult = [DoDefault(] + _oPEMEditor.oUtils.oBeautifyX.FetchParametersList() + [)] + ccCR
  CutCurrentLine()
  WriteCurrentLine(m.lcResult)
Endproc
****************************************************************
Function CreatePandoraCursor
  Lparameters tnWindowType

  Local lcProg, lcWindow, lnSelect

  m.tnWindowType = Evl(m.tnWindowType, 0)
  Local laPandoraChoices[1], lcPandoraOptions, lnLines, lnX
  m.lnSelect = Select()
  Text To m.lcPandoraOptions Noshow Textmerge Pretext 7
      Dir    |    | Picklist of all VFP files in the path              | ce |    |
      *      |    | Picklist of all VFP files in the path              | c |    |
      Dir:r  |    | Picklist of VFP files with reccount for all tables | ce |    |
      *:r    |    | Picklist of VFP files with reccount for all tables | c  |    |
      Dir:c  |    | Picklist of VFP files fields with the contents     | ce |    |
      *:c    |    | Picklist of VFP files fields with the contents     | c  |    |
      Desc   |    | Picklist of prg files with a description           | c  |    |
      Desc   |    | Adds "* Description *" template to the active file | e  |    |
      <blank>|    | Opens default files listed in "ccPandoraFile"      | c  |    |
      <blank>|    | Menu                                               | e  |    |
      0      |    | Opens "ccPandoraFile" for editing                  | c  |    |
      Menu   | ?  | Menu                                               | e  |    |
      Project|pr  | Picklist of projects in active .pan file           | c  |    |
      Help   |    | Opens Pandora page in the default Browser          | ce |    |
      Inc    |    | Picklist of header files                           | e  |    |
      Ins    | +  | Inserts contents from prg                          | e  |    |
      Eval   | =  | Inserts return value from function                 | e  |    |
      No     |    | NewObject syntax builder                           | ce |    |
      Dd     |    | DoDefault() syntax builder                         | f  |    |
      Pan    | !  | Run or create custom made Pandora extensions       | ce | !  |
      Paned  | !! | Edit custom made Pandora extensions                | ce | !! |
      Thor   | th | Picklist of registered Thor tools                  | ce | th |
      Hotkeys| hk | Picklist of registered Thor tools                  | ce | hk |
  Endtext
  Create Cursor curPandora (Trigger c(10), Short c(5), Descript c(50),  Window c(2))
  m.lnLines = Alines(laPandoraChoices, m.lcPandoraOptions)
  For m.lnX = 1 To m.lnLines
    m.lcWindow = Alltrim(Getwordnum( m.laPandoraChoices(m.lnX), 4, [|]))
    Do Case
      Case m.tnWindowType = 0 And [c] $ m.lcWindow
      Case m.tnWindowType > 0 And [e] $ m.lcWindow
      Case m.tnWindowType >= 10 And [f] $ m.lcWindow
      Otherwise
        Loop
    Endcase
    Insert Into curPandora (Trigger, Short, Descript) Values (;
        Alltrim(Getwordnum( m.laPandoraChoices(m.lnX), 1, [|])),;
        Alltrim(Getwordnum( m.laPandoraChoices(m.lnX), 2, [|])),;
        Alltrim(Getwordnum( m.laPandoraChoices(m.lnX), 3, [|]));
        )
  Endfor
  Index On Lower(Descript) Tag Descript
  Index On Lower(Short) Tag Short
  Index On Trigger Tag Trigger
  m.lcProg = GetDataFromGrid([Pandora "commands" aaa], [trigger], 1)
  Use
  Select (m.lnSelect)
  If !Empty(m.lcProg)
    Do Case
      Case m.lcProg = [<blank>]
        m.lcProg = [ed]
      Case Inlist(Lower(m.lcProg), [pan], [paned])
        m.lcProg = m.lcProg + [ ] + Inputbox([Name of file:], [Empty gives picklist])
    Endcase
    If _Screen.lPanComment
      m.lcProg = [*] + m.lcProg
    Endif
    Execscript(_Screen.cThorDispatcher, [thor_tool_pandora], m.lcProg )
  Endif
  If !_Screen.lPanComment
    CutCurrentLine()
  Endif

Endfunc


****************************************************************

Define Class clsSetPandoraFile As Custom

  Tool      = ccXToolName
  Key        = ccPandoraText
  Value      = ccPandoraFile
  EditClassName = ccContainerClassName && clsPandoraSettings

Enddefine
****************************************************************
Define Class clsPandoraSettings As Container
  Procedure Init
    m.loRenderEngine = Execscript(_Screen.cThorDispatcher, [Class= OptionRenderEngine])
    m.lcPandorafile = ccPandoraFile

    Text To m.loRenderEngine.cBodyMarkup Noshow Textmerge
    
      .Class     = 'Label'
      .Caption   = 'Name of file where Pandora looks for group of files to open:' 
      .Left     = 25
      .Width    = 300
      .WordWrap = .F.
      .FontBold = .T.
      |
      .Class  = 'Label'
      .Caption = '(If left empty, filename <<lcPandoraFile>> is used.)'
      .Width  = 400
      .Left    =25
      .WordWrap = .T.
      |  
      .Class     = 'TextBox'
      .Width     = 200
      .Left     = 25
      .InputMask = 'ANNNNNNNNNNN'
      .cTool     = ccXToolName 
      .cKey     = ccPandoraText 
    Endtext

    m.loRenderEngine.Render(This, ccXToolName)

  Endproc

Enddefine