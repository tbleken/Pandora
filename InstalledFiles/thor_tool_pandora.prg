* Description: Pandora *

Lparameters lxParam1


#Define ccXToolName        'Pandora'
#Define ccPandoraText      'Pandora default project:'
#Define ccPandoraHelp 'https://github.com/tbleken/Pandora'
#Define ccPandoraFile 'Pandora.pan'
#Define ccPandoraDef 'Pandora.txt'
#Define ccRun 'exe'
#Define ccPipe "|"
#Define ccAmp  [&] + [&]
#Define ccVersion '1.04'
#Define ccUnknownCommand 'Illegal command'
#Define ccWaitTimeout 3
#Define ccDescriptionMask1 '* Description:'
#Define ccDescriptionMask2 '*'
#Define ccCursorfiles 'curFiles'
#Define ccCR Chr(13)
#Define ccMaxDescriptLine 15
#Define ccVFPFilesToList [dbf], [scx], [vcx], [prg], [h], [dbc], [frx], [lbx], [mnx], [txt], [pan]
#Define ccVFPTablesExtended [dbf], [dbc], [frx], [lbx], [mnx], [pjx], [scx], [vcx]

*********************************************************************************
*********************************************************************************
*********************************************************************************
* Standard prefix for all tools for Thor, allowing this tool to
*   tell Thor about itself.

If Pcount() = 1              ;
    And [O] = Vartype (m.lxParam1)  ;
    And [thorinfo] == Lower (m.lxParam1.Class)

  With m.lxParam1

    * Required
    .Prompt       = [Pandora] && used in menus
    .AppID        = [Pandora] 

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
    .Version     = [1.01] && e.g., 'Version 7, May 18, 2011'
    .Author        = [TB]
    .Link          = ccPandoraHelp && link to a page for this tool
    .VideoLink     = [] && link to a video for this tool

  Endwith

  Return m.lxParam1
Endif
If Pcount() = 0
  Do ToolCode
Else
  Do ToolCode With m.lxParam1
Endif

Return
*********************************************************************************
* Normal processing for this tool begins here.                  
Procedure ToolCode
  Lparameters tcCommand
  Local lcFile, lcParsedText, loEditor
  FixOldValues()
  m.lcFile = GetPandoraFile()
  If Isnull(m.lcFile) Or Empty(m.lcFile)
    m.lcFile = ccPandoraFile
  Endif
  _Screen.AddProperty([cPandoraFile], Alltrim(m.lcFile))
  _Screen.AddProperty([cClip], _Cliptext)
*!*    SetPandoraFile(m.lcFile)
  If Empty(m.tcCommand)
    m.loEditor = Execscript(_Screen.cThorDispatcher, [class= HighlightedText from Thor_Proc_HighlightedText.PRG], [Statement], .T.)
    m.lcParsedText = m.loEditor.cHighlightedText
    If Empty(m.lcParsedText)
      m.loEditor = Execscript(_Screen.cThorDispatcher, [class= HighlightedText from Thor_Proc_HighlightedText.PRG], [Statement], .T.)
      Wait Window timeout 0.001
      m.lcParsedText = m.loEditor.cHighlightedText
    Endif
    m.lcParsedText = Evl(m.lcParsedText, [ed])
  Else
    m.lcParsedText = m.tcCommand
  Endif
  Do ProcessText With m.lcParsedText

Endproc
*********************************************************************************

Function ProcessText
  Lparameters tcLine

  Local lcAlias, lcCommand, lcFormFileName, lcParam1, lcReturn, lcText, lcdata, lnWindowType
  Local loEditorWin

  If !Pemstatus(_Screen, [lTest], 5)
    _Screen.AddProperty([lTest], .F.)
  Endif
  _Screen.AddProperty([cPandoraLine], m.tcLine)
  _Screen.AddProperty([lPanComment],.F.)
  m.loEditorWin = Execscript(_Screen.cThorDispatcher, [Thor_Proc_EditorWin])

  m.lnWindowType = m.loEditorWin.FindWindow()
  lcLine = Getwordnum(m.tcLine, 1)
*!*      Set Step On 
  If m.lnWindowType = 0 && Command window
    Do Case
      Case Left(m.tcLine, 2) = [//] && Command window
        m.tcLine = [dir ] + Substr(m.tcLine, 3)
      Case Left(m.tcLine, 1) = [/] && Command window
        m.tcLine = [dir ] + Substr(m.tcLine, 2)
      Case Left(m.tcLine, 3) = [**:]
        m.tcLine = [dirall ] + Substr(m.tcLine, 4)
      Case Left(m.tcLine, 4) = [***:]
        m.tcLine = [direxe ] + Substr(m.tcLine, 5)
      Case Left(m.tcLine, 2) = [*:]
        m.tcLine = [dir ] + Substr(m.tcLine, 3)
      Case Left(m.tcLine, 3) = [***]
        m.tcLine = [direxe ] + Substr(m.tcLine, 4)
      Case Left(m.tcLine, 2) = [**]
        m.tcLine = [dirall ] + Substr(m.tcLine, 3)
      Case Left(m.tcLine, 1) = [*]
        m.tcLine = [dir ] + Substr(m.tcLine, 2)
      Case Left(m.tcLine, 2) = '0*'
        m.tcLine = [0 * ] + Substr(m.tcLine, 3)
    EndCase
    If m.tcLine = [dir] And Left(Getwordnum(m.tcLine, 2), 1) = [:]
      m.tcLine = Strtran(m.tcLine, [dir ], [dir], 1, 1)
    Endif
  Else
    If Left(m.tcLine, 1) = [*] and !':'$GetWordNum(m.tcLine,1)
      _Screen.lPanComment = .T.
    Else
      Do case
        Case m.lcLine = '***:'
          m.tcLine = [dirrun ] + Substr(m.tcLine, 5)
        Case m.lcLine = '*:'
          m.tcLine = [dir ] + Substr(m.tcLine, 3)
        Case m.lcLine = '**:'
          m.tcLine = [dirall ] + Substr(m.tcLine, 4)
  
      Endcase
    EndIf
    
  EndIf
*!*  Set Step On 
  m.lcLine = GetWordNum(m.tcLine,1)
  Do case
    Case InList(m.lcLine , 'dirall','dirx')
       m.tcLine = Stuff(m.tcLine, 0, Len(m.lcLine), [dir:a])   
    Case InList(m.lcLine , 'dirrun','direxe')
       m.tcLine = Stuff(m.tcLine, 0, Len(m.lcLine), [dir:r])   
  Endcase 
  m.lcCommand = Lower(Getwordnum(m.tcLine, 1))
  m.lcParam1 = Ltrim(Strextract(m.tcLine, m.lcCommand, [], 1, 1))
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
          If m.loEditorWin.GetLineNumber() < ccMaxDescriptLine
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
            Wait Window Textmerge([Current line number is outside the Description range (1 to <<ccMaxDescriptLine>>)!])
          Endif
      EndCase
      
    Case m.lnWindowType = 0 And Inlist(m.lcCommand,[-], [pr], [proj], [project])
      ListProjects()
    Case Inlist(m.lcCommand, [menu]) Or (m.lnWindowType > 0 And m.lcCommand = [ed] And Empty(m.lcParam1 )) Or (m.lcCommand == [?] And Empty(m.lcParam1))
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
    Case Inlist(m.lcCommand, [.], [,], [ta],[test])
      pantest(m.lcCommand, m.lcParam1)
*!*        RunEd([Pandora.prg])
    Case Isdigit(m.lcCommand ) And m.lcCommand = Transform(Val(m.lcCommand)) And Empty(m.lcParam1) And m.lcCommand = [0] && and m.lnWindowType = 0
      CutCurrentLine()
      Modify Command (_Screen.cPandorafile) nowait
    Case Isdigit(m.lcCommand ) And m.lcCommand = Transform(Val(m.lcCommand)) And m.lcCommand = [0] And m.lcParam1 = [?]
      ReportPandoraFile()
      CutCurrentLine()  
    Case Isdigit(m.lcCommand ) And m.lcCommand = Transform(Val(m.lcCommand)) And m.lcCommand = [0] And !Empty(m.lcParam1)
      ChangePandoraFile(m.lcParam1)
      CutCurrentLine()  
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
        Modify Command (_Screen.cPandorafile) nowait
      Else
        getlinestoprocess(Val(m.lcParam1 ))
      Endif
    Case m.lnWindowType > 0 And (Left(m.lcCommand, 4) = [#inc] Or Left(m.lcCommand, 3) = [inc] or m.lcCommand == [#])
      GetHeader(m.lcCommand, m.lcParam1  )
    Case Inlist(m.lcCommand, [br], [browse])
      m.lcdata = GetDataFromGrid(Dbf(), [], ,.T.)
    Case m.lcCommand == [no]
      m.lcParam1 = Trim(m.lcParam1, 0, Chr(13), Chr(10), Chr(9))
      Execscript(_Screen.cThorDispatcher, [peme_snippet_no], m.lcParam1 )
    Case m.lcCommand == [op]
      Execscript(_Screen.cThorDispatcher, [peme_snippet_op], m.lcParam1 )
    Case m.lcCommand == 'rt'
      lcText = GetRandomText(Val(GetWordNum( m.lcParam1,1,',')), Val(GetWordNum( m.lcParam1,2,',')))
      CutCurrentLine()
      WriteCurrentLine(m.lcText + ccCR )
    Case m.lcCommand == 'lorem'
      lcText = GetLoremText(Val(GetWordNum( m.lcParam1,1,',')), Val(GetWordNum( m.lcParam1,2,',')))
      CutCurrentLine()
      WriteCurrentLine(m.lcText)
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
EndFunc
*********************************************************************************

Function CheckOrCreatePandoraFile
  If File(_Screen.cPandorafile)
*!*      Wait Window at 1,1 _screen.cPandorafile + ' exists' time ccWaitTimeout
    Return .T.
  Else
    If Messagebox( [Specified file "] + _Screen.cPandorafile + [" doesn't exist, create empty file?], 4, [File not found!]) = 6
      TEXT TO lcText NOSHOW TEXTMERGE pretext 7
        Default project: 0
        ************************* 
      EndText
      Strtofile(m.lcText , _Screen.cPandorafile)
      Modify Command (_Screen.cPandorafile) nowait
    Endif
    Return .F.
  Endif
EndFunc
*********************************************************************************
Procedure ChangePandoraFile
  Lparameters tcFile

  Local laDummy[1], laFiles[1], lcFile, lnFiles, lnLines, lnX, loThor

  m.lcFile =  GetPandoraFile()
  If Inlist(m.tcFile, [*], [-], [+], [/])
    m.lnFiles = Adir(laFiles, [*.pan])
    Do Case
      Case m.lnFiles = 0
        m.lcFile = [pandora.pan]
      Case m.lnFiles = 1
        m.lcFile = m.laFiles(1, 1)
      Otherwise
        Create Cursor curPanFiles (Filename c(25), Date T, Size i, LineS i)
        For m.lnX = 1 To m.lnFiles
          m.lnLines = Alines(laDummy, Filetostr(m.laFiles(m.lnX, 1)))
          Insert Into curPanFiles (Filename, Date, Size, LineS) Values (Lower(m.laFiles(m.lnX, 1)), dir2dt(m.laFiles(m.lnX, 4), m.laFiles(m.lnX, 3)), m.laFiles(m.lnX, 2), m.lnLines)
        Endfor
        Index On Filename Tag Filename
        Index On Date Tag Date
        Set Order To Date Descending
        m.lcFile = GetDataFromGrid([Select a file ddd:], [filename])
    Endcase
  Else
    m.lcFile = Forceext(Trim(m.tcFile), [pan])
    If !File(m.lcFile)
      If Messagebox( [Specified file "] + m.lcFile + [" doesn't exist, create empty file?], 4, [File not found!]) = 6
        TEXT TO lcText NOSHOW TEXTMERGE pretext 7
          Default project: 0
          ************************* 
        EndText
        Strtofile(m.lcText , _Screen.cPandorafile)
        Modify Command (_Screen.cPandorafile) nowait
      Else
        m.lcFile = []
      Endif
    Endif
  EndIf
  If !Empty(m.lcFile)
      SetPandoraFile(m.lcFile)
  EndIf
  ReportPandoraFile()
Endproc
*********************************************************************************
Function GetPandoraFile
  Local lcDef, lcFile
  m.lcDef = ccPandoraDef

  If File(m.lcDef )
    m.lcFile = Mline(Filetostr(m.lcDef), 1)
    If !Empty(m.lcFile)
      m.lcFile = GetLastWord(m.lcFile)
      m.lcFile = Forceext(m.lcFile, [pan])
    Endif
  EndIf
  If Empty(m.lcFile)
    m.lcFile = ccPandoraFile
  Endif
  Return m.lcFile
Endfunc
*********************************************************************************
Procedure SetPandoraFile
  Lparameters tcFile
  StrToFile( m.tcFile, ccPandoraDef,0)   
Endproc
*********************************************************************************
Procedure ReportPandoraFile
  Local lcFile
  m.lcFile = GetPandoraFile()
  Messagebox( [Active "Pandora" file is ] + m.lcFile, 64, [Pandora])
Endproc

*********************************************************************************
Procedure FixOldValues
  Local lcNewFile

  Try
    Update Thor Set Tool = [Thor] From  (_Screen.Cthorfolder + [tables\thor]) As Thor Where Tool = [Pandora]
    Use In Select([thor])
  Catch
  Endtry
  If File([Pandora.def])
    try
      Rename [Pandora.def] To ccPandoraDef 
    Catch
    Endtry
  Endif
Endproc
*********************************************************************************
Procedure ListDescript

  Lparameters tcText, tcCommand
  Local laDummy[1], lcContents, lcDescript, lcFile, lcText, lnFiles, lnHandle, lnX1, loContextMenu
  Local loEditorWin As EditorWin Of Home(0) + [Tools\Thor\Thor\Tools\procs\thor_proc_editorwin.prg]
  Local lcSelected

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
  Go Top
  m.lcSelected = GetDataFromGrid([Prg files with description], [Filename], 1)
  If !Empty(m.lcSelected)
    refreshCommandWindow([ed ] + m.lcSelected, m.tcCommand + [ ] + m.tcText )
  Endif

Endproc
*********************************************************************************

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
*********************************************************************************
Procedure ListFiles
  Lparameters tcFilter, tcPrefix, tlThor

  Local laDummy[1], lcOption, lcText, lcWord, llRecords, lnFiles, lnX, loContextMenu
  Local lcFilename
  Local lnMemo
  Local lcDescript, lcFile, lcShow

  m.lcOption = Getwordnum(Strextract(m.tcPrefix, [:], []), 1)
  If _Screen.lTest
    Text To m.lcShow Noshow Textmerge
      tcFilter : <<m.tcFilter >> tcPrefix : <<m.tcPrefix >> Option <<m.lcOption >>
    Endtext
    Wait Window At 1, 1 m.lcShow
  Endif
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
  If [r] $ m.lcOption
    Select * From (ccCursorfiles) Into Cursor (ccCursorfiles) Readwrite Where Inlist(Lower(Justext(Fname)), [prg], [scx])
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
    Wait Window [No files found !!!!!] Time ccWaitTimeout
    Return
  Endif
  Select f1 As Filename, Alltrim(Fname) As FullName, Filedate, FileSize From (ccCursorfiles) Into Cursor (ccCursorfiles) Readwrite Order By 1
  m.llRecords = .F.
  If [a] $ m.lcOption Or [r] $ m.lcOption
    Select Count(*) From (ccCursorfiles) Where Inlist(Lower(Justext(Filename)), ccVFPTablesExtended) Into Array laDummy
  Else
    Select Count(*) From (ccCursorfiles) Where Inlist(Lower(Justext(Filename)), [dbf]) Into Array laDummy
  Endif
  m.llRecords = m.laDummy  > 0
  If m.llRecords And Empty(Field([records]))
    Alter Table (ccCursorfiles) Add Column RecordS i
    Alter Table (ccCursorfiles) Add Column MemoSize i
  Endif
  Do Case
    Case [a] $ m.lcOption Or [r] $ m.lcOption
      Set Filter To Inlist(Lower(Justext(Filename)), ccVFPTablesExtended)
    Otherwise
      Set Filter To Inlist(Lower(Justext(Filename)), [dbf])
  Endcase
  Scan For RecordS = 0
    Replace RecordS With GetRecordsInDBF(FullName)
    Replace MemoSize With GetMemoSize(Fullpath(FullName))
  Endscan
  Set Filter To
  If [a] $ m.lcOption Or [r] $ m.lcOption
    Alter Table (ccCursorfiles) Add Column LineS i
    Alter Table (ccCursorfiles) Add Column Text m
    AddLinesAndText()
    Alter Table (ccCursorfiles) Add Column Descript c(100)
    Scan
      m.lcFile = Alltrim(FullName)
      m.lcDescript = GetDescript(m.lcFile )
      If !Empty( m.lcDescript )
        Replace Descript With m.lcDescript
      Endif
    Endscan
    Index On Upper(Descript) Tag Descript
    Go Top
  Endif
  If !Empty(Field([records]))
    Index On RecordS Tag RecordS
    Index On MemoSize Tag MemoSize
  Endif
  Index On Upper(FullName) Tag FullName
  Index On Upper(Filename) Tag Filename
  Index On Filedate Tag Filedate
  Index On FileSize Tag FileSize
  Set Order To
  m.lcText = GetDataFromGrid([Select a file:], [fullname], 0)
  Do Case
    Case [r] $ m.lcOption And Inlist(Lower(Justext(m.lcText)), [prg], [scx])
      RunProgram(m.lcText)
    Case [x] $ m.lcOption
      ConfirmDelete(m.lcText)
    Case Lower(Justext(m.lcText)) = [pan]
      Modify Command (m.lcText) Nowait
    Case !Empty(m.lcText)
      RunEd(Fullpath(m.lcText))
  Endcase


Endproc
*********************************************************************************
Procedure RunProgram
  Lparameters tcFile
  lcExt = Lower(JustExt(m.tcFile))
  Do case
    Case m.lcExt = 'prg'
      lcCommand = Textmerge('do <<m.tcFile>>')
    Case m.lcExt = 'scx'
      lcCommand = Textmerge('do form <<m.tcFile>>')
  EndCase
  Try 
    ExecScript(m.lcCommand)
  Catch
    messagebox( "Can not run file!",48,m.tcFile)
  Endtry
Endproc
*********************************************************************************
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

*********************************************************************************
Function ConfirmDelete
Lparameters tcFile
  If Lower(JustExt(m.tcFile)) = 'prg' 
    lcReply = 'PANX'
    If Lower( InputBox('Confirm deletion by typing ' + m.lcReply +':','Delete '+m.tcFile,'') ) = Lower(m.lcReply)
      Dimension laExtensions(3)
      m.laExtensions(1) = 'prg'
      m.laExtensions(2) = 'bak'
      m.laExtensions(3) = 'fxp'
      For lnX = 1 to 3
        Try
          Delete File (ForceExt(m.tcFile,m.laExtensions(m.lnX)))
        Catch
        Endtry
      EndFor
    Else 
      messagebox( "No deletion done!",64,m.tcFile)
    Endif
  Endif
Endfunc
*********************************************************************************
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
EndFunc 
*********************************************************************************
Function GetMemoSize
  Lparameters tcFileDBF
  Local laDummy[1], lcFileMemo, lnFiles, lnReturn
  m.lnReturn = 0
  Do Case
    Case Lower(Justext(m.tcFileDBF)) = [dbf]
      m.lcFileMemo = Forceext(m.tcFileDBF, [fpt])
    Case Lower(Justext(m.tcFileDBF)) = [dbc]
      m.lcFileMemo = Forceext(m.tcFileDBF, [dct])
    Case Inlist(Lower(Justext(m.tcFileDBF)), [vcx], [scx], [frx], [lbx], [mnx], [pjx])
      m.lcFileMemo = Forceext(m.tcFileDBF, Left(Lower(Justext(m.tcFileDBF)), 2) + [t])
    Otherwise 
      m.lcFileMemo = ''
  EndCase
  If !Empty(m.lcFileMemo)
    m.lnFiles = Adir(laDummy, m.lcFileMemo)
    If m.lnFiles = 1
      m.lnReturn = m.laDummy(1, 2)
    Endif
  Endif
  Return m.lnReturn
Endfunc
*********************************************************************************
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
*********************************************************************************
Function ListProjects
  Local lcClip, lcTable, lcText, loEditorWin
  Local lcSelected


  m.lcTable = _Screen.cPandorafile
  Local loContextMenu As ContextMenu Of [C:\VFP9\Tools\Thor\Source\thor_menu.vcx]
  m.lcClip = _Cliptext
  m.loEditorWin = Execscript(_Screen.cThorDispatcher, [Thor_Proc_EditorWin])
  If m.loEditorWin.FindWindow() = 0
    Create Cursor curProjects (text1 C(200), Projnotxt C(3), Project C(50), projno i)
    Append From (m.lcTable) Sdf
    Replace All Projnotxt With Ltrim(Strextract(text1, [#], [ ], 1)),;
      projno With Val(Strextract(text1, [#], [ ], 1))
    Replace All Project With Strextract(text1, [ ], [], 1) For projno > 0
    Select Projnotxt, Project  From curProjects x;
      Where x.projno > 0 Order By projno;
      Into Cursor curProjects Readwrite
    If _Tally > 0
      Select Projnotxt As ProjectNo, Project  From curProjects Into Cursor curProjects Readwrite
      Go Top
      m.lcText = GetDataFromGrid([Select project], [projectno])
      If !Empty(m.lcText)
        ProcessText(m.lcText)
      Endif
    Endif
    m.loEditorWin.Delete()
  Endif
Endfunc

*********************************************************************************
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

*********************************************************************************
Function GetHeader
  Lparameters tcOriginalLine, tcParameter
  Local laHeaders[1], lcNewText, loEditorWin
  Local laList[1], lcClip, lcTextOriginal
  Local lnPos
  m.lcClip = _Cliptext
  If GetFilesInPath([H], ccCursorfiles) = 0
    _Cliptext = _Screen.cClip
    Return
  EndIf
  If !Empty(m.tcParameter)
    Select * from (ccCursorfiles) into cursor (ccCursorfiles) readwrite where Alltrim(Lower(m.tcParameter))$Lower(fname)
  Endif
  lcText = GetDataFromGrid('Select file',ccCursorfiles+ '.fname') 
  If !Empty(m.lcText)
    WriteCurrentLine('#Include ' + m.lcText + ccCR)
    CutCurrentLine()
  Endif
Endfunc
*********************************************************************************
Function TryExecute(tcParameter)
  Try
    Execscript(m.tcParameter )
  Catch
    Wait Window ccUnknownCommand
  Endtry
Endfunc

*********************************************************************************
Function WriteCurrentLine
  Lparameters tcText
  Local lcClip, loEditorWin

  If Vartype(m.tcText) # [C]
    Return
  Endif
  m.loEditorWin = Execscript(_Screen.cThorDispatcher, [Thor_Proc_EditorWin])
  m.loEditorWin.Insert(m.tcText)

Endfunc
*********************************************************************************
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
*********************************************************************************

Function HighlightCurrentLine
  Local lnEndPos, loEditorWin

  m.loEditorWin  = Execscript(_Screen.cThorDispatcher, [Thor_Proc_EditorWin])
  m.lnEndPos = m.loEditorWin.GetLineStart(m.loEditorWin.GetSelStart(), 1)
  If m.loEditorWin.GetLineNumber(m.lnEndPos) < m.loEditorWin.GetLineNumber(1e8)
    m.lnEndPos = m.lnEndPos - 1
  Endif
  m.loEditorWin.Select(m.loEditorWin.GetLineStart(m.loEditorWin.GetSelStart(), 0), m.lnEndPos )
Endfunc
*********************************************************************************
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


*********************************************************************************

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
    Case Empty(JustExt(m.lcParam1)) and Right(m.lcParam1,1)#')' and !InList(Left(m.lcParam1,4),'http','mail')
      m.lcExt = 'prg'
      m.lcParam1 = ForceExt(m.lcParam1,m.lcExt)
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
      Modify Command (m.tcPar) nowait
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
*********************************************************************************

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
Endfunc
*********************************************************************************
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
*********************************************************************************
Function GetLineNo
  Lparameters tcFile, tnLine
  m.lnLines = Alines(laDummy, Filetostr(m.tcFile))
  m.lcReturn = []
  If m.tnLine <= m.lnLines
    m.lcReturn = m.laDummy(m.tnLine)
  Endif
  Return m.lcReturn
Endfunc
*********************************************************************************
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
*********************************************************************************

Function clipIsText
  #Define CF_TEXT           1
  Declare short IsClipboardFormatAvailable In win32api Integer cbformat
  Return IsClipboardFormatAvailable(CF_TEXT) # 0
Endfunc
*********************************************************************************

Function FindFile
  Lparameters tcFile, tcFilter
  If Empty(m.tcFilter)
    m.tcFilter = ['dbf','vcx','scx','prg','txt','pan']
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

*********************************************************************************
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
*********************************************************************************
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
*!*    If !_Screen.lPanComment
*!*      CutCurrentLine()
*!*    Endif
Endproc
*********************************************************************************
Function GetDataFromGrid
  Lparameters tcCaption, tcReturnField, tnHideColumns, tlModeless
  Local lcHideColumns, lcParameter, lcReturn, lcVCXFile
  Local loPg As pg Of (_Screen.Cthorfolder) + [tools\procs\thor_proc_pandora.vcx]
  Local lnModeless
  m.tnHideColumns = Evl(m.tnHideColumns, 0)
  m.lnModeless = Iif(Empty(m.tlModeless), 1, 2)
  *!*    Wait Window at 1,1 m.lnModeless 
  m.lcReturn = []
  If !Empty(Dbf())
    m.lcVCXFile = Execscript(_Screen.cThorDispatcher, [Full Path=] + [thor_proc_pandora.VCX])
    m.lcHideColumns = Replicate([L], Evl(m.tnHideColumns, 0))
    m.lcParameter = [1U] + m.lcHideColumns
    m.loPg = Newobject([pg], m.lcVCXFile, [], m.lcParameter )
    m.loPg.Caption = Alltrim(m.tcCaption)
    m.loPg.nIncStart = 0
    m.loPg.lShowZero = .F.
    *!*      If !Empty(m.tnWidth) And Vartype(m.tnWidth) = [N]
    *!*        m.loPg.Width = m.tnWidth
    *!*      Endif
    m.loPg.Show(m.lnModeless )
    If m.lnModeless = 2
      Read Events
    EndIf
    If !Inlist(Lastkey(), 97, 33) And !Empty(m.tcReturnField)
      m.lcReturn = Alltrim(Evaluate(m.tcReturnField))
    Endif
  Else
    Messagebox( [No table or cursor is selected], 0 + 48, [Pandora grid])
  Endif
  Return m.lcReturn
Endfunc
*********************************************************************************
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
        Modify Command (Forcepath(m.lcProg, m.lcPath)) nowait
      Endif
    Endif
  Endif
  If !_Screen.lPanComment
    CutCurrentLine()
  Endif
Endproc
*********************************************************************************
Procedure EditCustomTool
  Lparameters tcCommand
  m.lcProg = Substr(m.tcCommand, 3)
  m.lcProgFile = Forceext([pan_] + m.lcProg, [prg])
  If !Empty(m.lcProg)
    If File(m.lcProgFile)
      Modify Command (m.lcProgFile) nowait
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
        Modify Command (m.lcProg) nowait
      Endif
      If !_Screen.lPanComment
        CutCurrentLine()
      Endif

    Endif

  Endif
Endproc
*********************************************************************************
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
*********************************************************************************
Function GetDescript
  Lparameters tcFile
  Local lcContents, lcDescript, lnHandle, lnX1

  m.lnHandle = Fopen(m.tcFile )
  m.lcDescript = []
  For m.lnX1 = 1 To ccMaxDescriptLine 
    m.lcContents = Fgets(m.lnHandle)
    If Occurs(ccDescriptionMask1, m.lcContents) > 0
      m.lcDescript = Alltrim(Strextract(m.lcContents, ccDescriptionMask1, ccDescriptionMask2 ))
      Exit
    Endif
  Endfor
  Fclose(m.lnHandle)
  Return m.lcDescript
Endfunc
*********************************************************************************
Function InsertMethod
  Lparameters tcMethod
  Local laProc[1], lcCode, lcMethod, lcProc, lcSource, lcText, lnProcs, lnSelect, lnX

  m.lcCode = []
  If Inlist(Lower(Justext(m.tcMethod)), [prg], [h])
    If File(m.tcMethod)
      m.lcCode = Filetostr(m.tcMethod)
    Else
      Messagebox( [File not found!], 48, Alltrim(m.tcMethod))
    Endif
  Else
    m.lcMethod = Alltrim(Lower(m.tcMethod))
    m.lcText = []
    m.lnSelect = Select()
    Create Cursor CurMethods (Method c(200), Source c(200), Code m)
    GetFilesInPath([prg], [curPrgs])
    Scan
      m.lcSource = curprgs.Fname
      m.lnProcs = Aprocinfo(laProc, curprgs.Fname, 0)
      For m.lnX = 1 To m.lnProcs
        If m.laProc(m.lnX, 3) = [Procedure] And ![.] $ m.laProc(m.lnX, 1) And (m.lcMethod $ Lower(m.laProc(m.lnX, 1)) Or Empty(m.lcMethod))
          m.lcProc = m.laProc(m.lnX, 1)
          m.lcCode = methodfromprg(m.lcProc, m.lcSource)
          Insert Into CurMethods (Source, Method, Code) Values (m.lcSource, m.lcProc, m.lcCode )
        Endif
      Endfor
    Endscan
    Select CurMethods
    Index On Lower(Method) Tag Method
    Locate
    If Reccount()>0
      m.lcCode = GetDataFromGrid([Select method to insert], [curmethods.code])
    Else 
      messagebox( 'No match found!',48,m.tcMethod)
    Endif
    Select (m.lnSelect)
    m.lcMethod = Trim(CurMethods.Method)
    m.lcSource = Trim(CurMethods.Source )
    Use In Select([curmethods])
    Use In Select([curprgs])
  Endif
  If !Empty(m.lcCode)
    WriteCurrentLine(m.lcCode + ccCR )
    CutCurrentLine()
  Endif

Endfunc

*********************************************************************************
Function methodfromprg
  Lparameters tcProcedure, tcFile
  Local laDummy[1], lcFile, lcProc, lcReturn, lnEnd, lnStart, lnX
  Local lnSelect
  m.lnSelect = Select()
  m.lcProc = Lower(Padr(m.tcProcedure, 100))
  m.lcFile = Forceext(m.tcFile, [prg])
  m.lnX = Aprocinfo(laDummy, m.lcFile, 0)
  m.lcReturn = []
  If m.lnX > 0.
    Create Cursor curDummy (Name c(100), Line i, Type c(25), ind i)
    Append From Array m.laDummy
    Select Name, Line From curDummy Into Cursor curDummy Readwrite Where Type = [Procedure]
    Locate For Lower(Name) == m.lcProc
    If Found()
      m.lnStart = Line
      Skip
      m.lnX = Alines(laDummy, Filetostr(m.lcFile ))
      If !Eof([curdummy])
        m.lnEnd = Line - 1
      Else
        m.lnEnd = m.lnX
      Endif
      If m.lnX > 0
        m.lcReturn = []
        For m.lnX = m.lnStart To m.lnEnd
          m.lcReturn  = m.lcReturn + Trim(m.laDummy(m.lnX )) + Chr(13)
        Endfor
      Endif
    Endif
    Use In Select([curdummy])
  Endif
  Select (m.lnSelect)
  Return m.lcReturn
Endfunc

*********************************************************************************
Procedure AddLinesAndText
  Local lnMemo

  m.lnMemo = Set([Memowidth])
  Set Memowidth To 8192
  Scan For Inlist(Lower(Justext(Filename)), [prg], [txt], [h],'pan')
    try
      Replace Text With Filetostr(Alltrim(Filename))
      Replace LineS With Memlines(Text)
    catch
    Endtry
  Endscan
  Set Memowidth To m.lnMemo
  Index On LineS Tag LineS
Endproc
*********************************************************************************
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

*********************************************************************************
Function GetLastWord
Lparameters tcText, tcDelimiter
If Pcount() < 2 Or Vartype(m.tcDelimiter) # [C]
   m.tcDelimiter = [ ]
Endif
Return Trim(Getwordnum(m.tcText, Getwordcount(m.tcText, m.tcDelimiter), m.tcDelimiter))
*********************************************************************************
Procedure MakeDD && Creates DoDefault call
  Local lcResult

  m.lcResult = [DoDefault(] + _oPEMEditor.oUtils.oBeautifyX.FetchParametersList() + [)] + ccCR
  CutCurrentLine()
  WriteCurrentLine(m.lcResult)
Endproc
*********************************************************************************
Function GetRandomText
  Lparameters tnSentences, tnParagraphs
  m.tnParagraphs = Evl(m.tnParagraphs, 1)
  m.tnSentences = Evl(m.tnSentences, 1)
  Return getDataFromUrl(Textmerge([http://metaphorpsum.com/paragraphs/<<Int(m.tnParagraphs)>>/<<Int(m.tnSentences)>>]))
Endfunc
*********************************************************************************
Function GetLoremText
  Lparameters tnLength, tnParagraphs
  Local lcLength, lcURL

  m.tnParagraphs = Evl(m.tnParagraphs, 1)
  m.tnLength = Evl(m.tnLength, 0)
  Do Case
    Case Empty(m.tnLength)
      m.lcLength = [short]
    Case M.tnLength = 1
      m.lcLength = [medium]
    Case M.tnLength = 2
      m.lcLength = [long]
    Otherwise
      m.lcLength = [verylong]
  Endcase
  m.lcURL = Textmerge([https://loripsum.net/api/<<Int(m.tnParagraphs)>>/plaintext/<<m.lcLength>>])
  Return GetDataFromURL(m.lcURL )
Endfunc
*********************************************************************************

Function GetDataFromURL
  Lparameters tcUrlName
  Local lsReadBuffer

  Declare Integer InternetOpen In wininet.Dll String sAgent, ;
    Integer lAccessType, String sProxyName, ;
    String sProxyBypass, Integer lFlags

  Declare Integer InternetOpenUrl In wininet.Dll ;
    Integer hInternetSession, String sUrl, String sHeaders,;
    Integer lHeadersLength, Integer lFlags, Integer lContext

  Declare Integer InternetReadFile In wininet.Dll Integer hfile, ;
    String @sBuffer, Integer lNumberofBytesToRead, Integer @lBytesRead

  Declare short InternetCloseHandle In wininet.Dll Integer hInst

  #Define INTERNET_OPEN_TYPE_PRECONFIG 0
  #Define INTERNET_OPEN_TYPE_DIRECT 1
  #Define INTERNET_OPEN_TYPE_PROXY 3
  #Define SYNCHRONOUS 0
  #Define INTERNET_FLAG_RELOAD 2147483648
  #Define CR Chr(13)

  Local lsAgent, lhInternetSession, lhUrlFile, llOk, lnOK, lcRetVal, lcReadBuffer, lnBytesRead

  * what application is using Internet services?
  m.lsAgent = [VPF 5.0]

  m.lhInternetSession = InternetOpen( m.lsAgent, INTERNET_OPEN_TYPE_PRECONFIG, ;
      [], [], SYNCHRONOUS)

  * debugging line - uncomment to see session handle
  * WAIT WINDOW "Internet session handle: " + LTRIM(STR(hInternetSession))

  If m.lhInternetSession = 0
    Wait Window [Internet session cannot be established] Time 2
    Return .Null.
  Endif

  m.lhUrlFile = InternetOpenUrl( m.lhInternetSession, m.tcUrlName, [], 0, ;
      INTERNET_FLAG_RELOAD, 0)

  * debugging line - uncomment to see URL handle
  * WAIT WINDOW "URL Handle: " + LTRIM(STR(hUrlFile))

  If m.lhUrlFile = 0
    Wait Window [URL cannot be opened] Timeout 5
    Return .Null.
  Endif

  m.lcRetVal = []
  m.llOk = .T.

  Do While m.llOk
    * set aside a big buffer
    m.lsReadBuffer = Space(32767)
    m.lnBytesRead = 0
    m.lnOK = InternetReadFile( m.lhUrlFile, @m.lsReadBuffer, Len(m.lsReadBuffer), @m.lnBytesRead)

    If ( m.lnBytesRead > 0 )
      m.lcRetVal = m.lcRetVal + Left( m.lsReadBuffer, m.lnBytesRead )
    Endif

    * error trap - either a read failure or read past eof()
    m.llOk = ( m.lnOK = 1 ) And ( m.lnBytesRead > 0 )
  Enddo

  * close all the handles we opened
  InternetCloseHandle( m.lhUrlFile )
  InternetCloseHandle( m.lhInternetSession )

  * return the URL contents
  Return m.lcRetVal
Endfunc

*********************************************************************************

Function CreatePandoraCursor
  Lparameters tnWindowType

  Local lcProg, lcWindow, lnSelect
  Local lcAsk, lcDesc, lcShort, lcTrigger


  m.tnWindowType = Evl(m.tnWindowType, 0)
  Local laPandoraChoices[1], lcPandoraOptions, lnLines, lnX
  m.lnSelect = Select()
  Text To m.lcPandoraOptions Noshow Textmerge Pretext 7
      Dir    | *: | Picklist of all VFP files in the path, edit        | ef  |    |
      Dir    | *  | Picklist of all VFP files in the path, edit        | c   |    |
      DirX   | **:| Picklist of VFP files with more information, edit  |  ef |    |
      DirX   | ** | Picklist of VFP files with more information, edit  |  c  |    |
      DirRun |***:| Picklist of VFP files with more information, run   |  ef |    |
      DirRun |*** | Picklist of VFP files with more information, run   | c   |    |
      Desc   |    | Picklist of prg files with a description           | c   |    |
      Desc   |    | Adds "* Description *" template to the active file | ef  |    |
      <blank>|    | Opens default files listed in active .pan file     |  c  |    |
      <blank>|    | Menu                                               | ef  |    |
      0      |    | Opens active .pan file for editing                 | c   |    |
      Lorem  |    | Random "Lorem Ipsum" text generator                | cef |    |
      Menu   | ?  | Menu                                               | ef  |    |
      Project|pr  | Picklist of projects in active .pan file           | c   |    |
      Help   |    | Opens Pandora page in the default Browser          | cef |    |
      Inc    | #  | Insert #Include statement from Picklist of .h files| ef  |    |
      Ins    | +  | Inserts contents from prg                          | ef  | Name of file to include:   |
      Eval   | =  | Inserts return value from function                 | ef  | Function name to evaluate: |
      No     |    | NewObject syntax builder                           | cef | Class name:   |
      DD     |    | DoDefault() syntax builder                         | f   |    |
      Pan    | !  | Run or create custom made Pandora extensions       | cef |    |
      Paned  | !! | Edit custom made Pandora extensions                | cef |    |
      Rt     |    | Random readable text generator                     | cef |    |
      Ta     | .  | Test area "pandora.prg"                            | cef |    |
      Thor   | th | Picklist of registered Thor tools                  | cef |    |
      Hotkeys| hk | Picklist of all assigned hot keys                  | cef |    |
      Ed     |    | Easy way to open most files                        | cef | Filename or URL: |
  Endtext
  Create Cursor curPandora (Trigger c(10), Short c(5), Descript c(50),  Window c(2), ask c(25))
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
    m.lcTrigger = Alltrim(Getwordnum( m.laPandoraChoices(m.lnX), 1, [|]))
    m.lcShort = Alltrim(Getwordnum( m.laPandoraChoices(m.lnX), 2, [|]))
    m.lcDesc = Alltrim(Getwordnum( m.laPandoraChoices(m.lnX), 3, [|]))
    m.lcAsk = Alltrim(Getwordnum( m.laPandoraChoices(m.lnX), 5, [|]))
    Insert Into curPandora (Trigger, Short, Descript, ask) Values (m.lcTrigger, m.lcShort, m.lcDesc, m.lcAsk)
  EndFor
  Select Trigger, Short, Descript, Ask from curPandora into cursor curPandora readwrite
  Index On Lower(Descript) Tag Descript
  Index On Lower(Short) Tag Short
  Index On Trigger Tag Trigger
  m.lcProg = GetDataFromGrid([Pandora "commands"], [trigger], 1)
  lcAsk = ''
  If !Empty(m.lcProg)
    Select ask from curPandora where Alltrim(m.lcProg) = Alltrim(trigger) into cursor CurPandora
    m.lcAsk = ask
  Endif
  Use
  Select (m.lnSelect)
  If !Empty(m.lcProg)
    Do Case
      Case m.lcProg = [<blank>]
        m.lcProg = [ed]
      Case !Empty(m.lcAsk)
        m.lcProg = m.lcProg + [ ] + Inputbox(m.lcAsk , [Value is required!])
      Case Inlist(Lower(m.lcProg), [pan], [paned],'eval')
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


*********************************************************************************
Function panTestArea
  Lparameters tcCommand, tcParameter
  If Empty(m.tcParameter)
    If Inlist(m.tcCommand, [,], [.])
      m.tcParameter = Substr(m.tcCommand, 2)
    Endif
  Endif
  If !Empty(m.tcParameter)
    m.tcParameter = [_] + m.tcParameter
  Endif
  Modify Command Forceext([pandora] + m.tcParameter, [prg])
Endfunc
