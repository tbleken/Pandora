* Description: Pandora *

Lparameters lxParam1

#Define ccXToolName        'Pandora'
#Define ccPandoraHelp 'https://github.com/tbleken/Pandora'
#Define ccPipe "|"
#Define ccAmp  [&] + [&]
#Define ccUnknownCommand 'Illegal command'
#Define ccDescriptionMask1 '* Description:'
#Define ccDescriptionMask2 '*'
#Define ccCursorfiles 'curFiles'
#Define ccCR Chr(13)
**** #Define ccPandoraText      'Pandora default project:'

#include pandora.h

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
    .Version     = [1.11] && e.g., 'Version 7, May 18, 2011'
    .Version     = ccVersion
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
  lcFile = GetPandoraFile()
  If Isnull(m.lcFile) Or Empty(m.lcFile)
    lcFile = ccPandoraFile
  Endif
  _Screen.AddProperty([cPandoraFile], Alltrim(m.lcFile))
  _Screen.AddProperty([cClip], _Cliptext)
  If File(ccPandoraComments) and !Upper(JustStem(ccPandoraComments))$Set("Procedure")
    Set Procedure To JustStem(ccPandoraComments) additive
  Endif

  If Empty(m.tcCommand)
    loEditor = Execscript(_Screen.cThorDispatcher, [class= HighlightedText from Thor_Proc_HighlightedText.PRG], [Statement], .T.)
    lcParsedText = m.loEditor.cHighlightedText
    If Empty(m.lcParsedText)
      loEditor = Execscript(_Screen.cThorDispatcher, [class= HighlightedText from Thor_Proc_HighlightedText.PRG], [Statement], .T.)
      Wait Window Timeout 0.001
      lcParsedText = m.loEditor.cHighlightedText
    Endif
    lcParsedText = Evl(m.lcParsedText, [ed])
  Else
    lcParsedText = m.tcCommand
  EndIf

  Do ProcessText With m.lcParsedText

Endproc
*********************************************************************************
Function ProcessText
  Lparameters tcLine

  Local lcAlias, lcCommand, lcFormFileName, lcParam1, lcReturn, lcText, lcdata, lnWindowType, lcWord1, lcWord2
  Local loEditorWin
  Local lcLine


  If !Pemstatus(_Screen, [lTest], 5)
    _Screen.AddProperty([lTest], .F.)
  Endif
  _Screen.AddProperty([cPandoraLine], m.tcLine)
  _Screen.AddProperty([lPanComment],.F.)
  loEditorWin = Execscript(_Screen.cThorDispatcher, [Thor_Proc_EditorWin])

  lnWindowType = m.loEditorWin.FindWindow()
  lcLine = Getwordnum(m.tcLine, 1)
  lnVal = findValueInString(m.tcLine)
  If _Screen.lTest And .F.
    Set Step On
  EndIf
*!*  Set Step On 
  If m.lnWindowType = 0 && Command window
    Do Case
      Case Left(m.tcLine, 3) = [///] && Command window
        tcLine = [dir ] + Substr(m.tcLine, 3)
      Case Left(m.tcLine, 2) = [//]
        tcLine = [dir ] + Substr(m.tcLine, 3)
      Case Left(m.tcLine, 1) = [/]
        tcLine = [dir ] + Substr(m.tcLine, 2)
      Case Left(m.tcLine, 3) = [**:]
        tcLine = [dirall ] + Substr(m.tcLine, 4)
      Case Left(m.tcLine, 2) = [++]
        tcLine = [direxe ] + Substr(m.tcLine, 3)
      Case Left(m.tcLine, 1) = [+]
        tcLine = [dirall ] + Substr(m.tcLine, 2)
      Case Left(m.tcLine, 4) = [***:]
        tcLine = [direxe ] + Substr(m.tcLine, 5)
      Case Left(m.tcLine, 2) = [*:] And m.lnVal = 0
        tcLine = [dir ] + Substr(m.tcLine, 3)
      Case Left(m.tcLine, 3) = [***]
        tcLine = [direxe ] + Substr(m.tcLine, 4)
      Case Left(m.tcLine, 2) = [**]
        tcLine = [dirall ] + Substr(m.tcLine, 3)
      Case Left(m.tcLine, 1) = [*]
        tcLine = [dir ] + Substr(m.tcLine, 2)
      Case Left(m.tcLine, 2) = [0*]
        tcLine = [0 * ] + Substr(m.tcLine, 3)
    Endcase
    If m.tcLine = [dir] And Left(Getwordnum(m.tcLine, 2), 1) = [:]
      tcLine = Strtran(m.tcLine, [dir ], [dir], 1, 1)
    Endif
  Else
    If Left(m.tcLine, 1) = [*] And ![:] $ Getwordnum(m.tcLine, 1)
      _Screen.lPanComment = .T.
    Else
      Do Case
        Case m.lcLine = [***:]
          tcLine = [dirrun ] + Substr(m.tcLine, 5)
        Case m.lcLine = [*:] And m.lnVal = 0
          tcLine = [dir ] + Substr(m.tcLine, 3)
        Case m.lcLine = [**:]
          tcLine = [dirall ] + Substr(m.tcLine, 4)

      Endcase
    Endif

  Endif
  lcLine = Getwordnum(m.tcLine, 1)
  Do Case
    Case Inlist(m.lcLine, [dirall], [dirx])
      tcLine = Stuff(m.tcLine, 0, Len(m.lcLine), [dir:a])
    Case Inlist(m.lcLine, [dirrun], [direxe])
      tcLine = Stuff(m.tcLine, 0, Len(m.lcLine), [dir:r])
  Endcase
  lcCommand = Getwordnum(m.tcLine, 1)
  lcParam1 = Ltrim(Strextract(m.tcLine, m.lcCommand, [], 1, 1))
  If At([&] + [&], m.lcParam1) > 0
    lcParam1 = Trim(Strextract(m.lcParam1, [], [&] + [&]))
  Endif
  If Left(m.lcParam1, 1) = [(]
    lcParam1 = Lower(FindFile(Evaluate(m.lcParam1)))
  Endif
  If m.lnVal = 0
    lcCommand = Ltrim(m.lcCommand, [*])
  Endif
  lcCommand = Trim(m.lcCommand, 0, Chr(13), Chr(10))
  lcParam1 = Trim(m.lcParam1, 0, Chr(13), Chr(10))
  If _Screen.lTest&& And .F.
    Clear
    ?[lcCommand], m.lcCommand
    ?[lcParam1], m.lcParam1
    ?[lnWindowType], m.lnWindowType
    Set Step On
  Endif
  Do Case
    Case Lower(m.lcCommand) == [help]
      RunEd(ccPandoraHelp )
    Case Lower(m.lcCommand) == [no]
      CreateNo(m.lcParam1)
    Case Left(m.lcCommand, 1) = [*] And m.lnVal > 0 and Empty(m.lcParam1) 
      CreateCommentLine(m.lcCommand)
    Case Lower(m.lcCommand) == [ec] && and Varype(_cliptext) = 'C'
      Try
        Execscript(_Cliptext)
      Catch
        Messagebox( [Can't execute the clipboard], 48, [], 3000)
      Endtry
    Case Left(m.lcCommand, 1) == [?] And (Len(m.lcCommand) > 1 Or !Empty(m.lcParam1))
      CreateQmark(m.lcCommand, m.lcParam1)
    Case Left(m.lcCommand, 3) == [db] And (Len(m.lcCommand) > 2 Or !Empty(m.lcParam1))
      CreateQmark(m.lcCommand, m.lcParam1, .T.)
    Case Lower(m.lcCommand) == [es]
      CreateES(m.lcParam1)
      *!*        Execscript(_Screen.cThorDispatcher, [Thor_Tool_EditSourceBuilder],m.lcParam1 )
    Case Inlist(Lower(m.lcCommand), [desc], [description], [de])
      Do Case
        Case m.lnWindowType = 0 && Command window
          ListDescript(m.lcParam1, m.lcCommand )
        Case Inlist(m.lnWindowType, 1, 2) && Program or text file
          If m.loEditorWin.GetLineNumber() < ccMaxDescriptLine
            If Empty(m.lcParam1)
              lcText = ccDescriptionMask1 + Space(3) + ccDescriptionMask2 + ccCR
            Else
              lcText = ccDescriptionMask1 + [ ] + m.lcParam1 + [ ] + ccDescriptionMask2
            Endif
            m.loEditorWin.Delete()
            m.loEditorWin.Insert(m.lcText)
            If Empty(m.lcParam1)
              m.loEditorWin.SetInsertionPoint(m.loEditorWin.GetSelStart() - 4)
            Endif
          Else
            Wait Window Textmerge([Current line number is outside the Description range (1 to <<ccMaxDescriptLine>>)!])
          Endif
      Endcase

    Case m.lnWindowType = 0 And Inlist(m.lcCommand, [-], [#], [pr], [proj], [project])
      ListProjects()
    Case Inlist(Lower(m.lcCommand), [menu]) Or (m.lnWindowType > 0 And Lower(m.lcCommand) == [ed] And Empty(m.lcParam1 )) Or (m.lcCommand == [?] And Empty(m.lcParam1))
      CreatePandoraCursor(m.lnWindowType )
    Case Inlist(Lower(m.lcCommand), [ver], [version])
      Messagebox( [Version # ] + ccVersion, 64, [Pandora])
    Case m.lnWindowType > 0 And (Inlist(Lower(m.lcCommand), [insert], [ins]) Or m.lcCommand = [+])
      If m.lcCommand = [+] And Empty(m.lcParam1) And Len(m.lcCommand) > 2
        lcParam1 = Substr(m.lcCommand, 2)
      EndIf
      InsertMethod(m.lcParam1)
    Case Inlist(Lower(m.lcCommand), [=], [eval])
      If m.lcCommand = [=] And Empty(m.lcParam1) And Len(m.lcCommand) > 1
        lcParam1 = Substr(m.lcCommand, 2)
      Endif
      InsertResult(m.lcParam1 )
    Case Inlist(Lower(m.lcCommand), [hotkeys], [hk])
      BrowseHotKeys()
    Case Inlist(Lower(m.lcCommand), [th], [thor], [tool], [tools])
      BrowseAllTools()
    Case Left(m.lcCommand, 2) = [!!]
      EditCustomTool(m.lcCommand)
    Case Lower(m.lcCommand) == [paned]
      EditCustomTool([**] + m.lcParam1 )
    Case Left(m.lcCommand, 1) = [!]
      ListAllCustomTools(Substr(m.lcCommand, 2)  + [ ] + m.lcParam1 )
    Case Lower(m.lcCommand) == [pan]
      ListAllCustomTools(m.lcParam1 )
    Case Inlist(Lower(m.lcCommand), [.], [,], [ta], [test])
      panTestArea(m.lcCommand, m.lcParam1)
    Case Isdigit(m.lcCommand ) And m.lcCommand = Transform(Val(m.lcCommand)) And Empty(m.lcParam1) And m.lcCommand = [0] && and m.lnWindowType = 0
      CutCurrentLine()
      Modify Command (_Screen.cPandorafile) Nowait
    Case Isdigit(m.lcCommand ) And m.lcCommand = Transform(Val(m.lcCommand)) And m.lcCommand = [0] And m.lcParam1 = [?]
      ReportPandoraFile()
      CutCurrentLine()
    Case Isdigit(m.lcCommand ) And m.lcCommand = Transform(Val(m.lcCommand)) And m.lcCommand = [0] And !Empty(m.lcParam1) and Lower(GetWordNum(m.lcParam1,1))#'exe'
      ChangePandoraFile(m.lcParam1)
      CutCurrentLine()
    Case Isdigit(m.lcCommand ) And m.lcCommand = Transform(Val(m.lcCommand)) And Empty(m.lcParam1) And m.lnWindowType = 0 && and m.lnWindowType = 0
      getlinestoprocess(Val(m.lcCommand))
    Case Isdigit(m.lcCommand ) And m.lcCommand = Transform(Val(m.lcCommand)) And !Empty(m.lcParam1) And Inlist(Getwordnum(m.lcParam1, 1), [do], ccRun ) And  Inlist(m.lnWindowType, 1, 2)
      If Getwordnum(m.lcParam1, 1) = ccRun
        lcParam1 = Strextract(m.lcParam1, ccRun, [])
      Endif
      If TryExecute(m.lcParam1)
        Return
      Endif
    Case Isdigit(m.lcCommand ) And m.lcCommand = Transform(Val(m.lcCommand)) And !Empty(m.lcParam1) And Inlist(m.lnWindowType, 1, 2)
      RunEd(m.lcParam1)
    Case Isdigit(m.lcCommand ) And m.lcCommand = Transform(Val(m.lcCommand))
      ReturnUnknownCommand(1)
    Case Lower(m.lcCommand) == [ed] And m.lcParam1 = Transform(Val(m.lcParam1 )) && And m.lnWindowType = 0
      If m.lcParam1 = [0]
        Modify Command (_Screen.cPandorafile) Nowait
      Else
        getlinestoprocess(Val(m.lcParam1 ))
      Endif
    Case m.lnWindowType > 0 And (Left(Lower(m.lcCommand), 4) = [#inc] Or Left(Lower(m.lcCommand), 3) = [inc] Or m.lcCommand == [#])
      GetHeader(m.lcCommand, m.lcParam1  )
    Case Inlist(Lower(m.lcCommand), [br], [browse])
      lcdata = GetDataFromGrid(Dbf(), [], ,.T.)
    Case Lower(m.lcCommand) == [nu]
      lcParam1 = Trim(m.lcParam1, 0, Chr(13), Chr(10), Chr(9))
      Execscript(_Screen.cThorDispatcher, [peme_snippet_no], m.lcParam1 )
    Case Lower(m.lcCommand) == [be]
      lcWord1 = Getwordnum(m.lcParam1, 1, [, ])
      lcWord2 = Getwordnum(m.lcParam1, 2, [, ])
      If Empty(m.lcWord1) Or Empty(m.lcWord2) Or ![.] $ m.lcWord1 Or ![.] $ m.lcWord2
        Messagebox([syntax: BE object1.event1,object2.event2], 0 + 64, [Invalid Parameters(s)], 5000)
      Else
        lcText = Textmerge([Bindevent(<<Juststem(lcWord1)>>, "<<Justext(lcWord1)>>", <<Juststem(lcWord2)>>, "<<Justext(lcWord2)>>")])
        ReplaceCurrentLine(m.lcText + ccCR)
      Endif
    Case Lower(m.lcCommand) == [op]
      Execscript(_Screen.cThorDispatcher, [peme_snippet_op], m.lcParam1 )
    Case Lower(m.lcCommand) == [rt]
      lcText = GetRandomText(Val(Getwordnum( m.lcParam1, 1, [,])), Val(Getwordnum( m.lcParam1, 2, [,])))
      ReplaceCurrentLine(m.lcText + ccCR)
    Case Inlist(Lower(m.lcCommand), [lorem], [lor])
      lcText = GetLoremText(Val(Getwordnum( m.lcParam1, 1, [,])), Val(Getwordnum( m.lcParam1, 2, [,])))
      ReplaceCurrentLine(m.lcText)
    Case Lower(m.lcCommand) == [fp]
      lcAlias = m.lcParam1
      Execscript(_Screen.cThorDispatcher, [PEME_OpenTable], m.lcAlias)
      lcFormFileName = Execscript(_Screen.cThorDispatcher, [Full Path=PEME_Snippet_FP.SCX])
      Do Form (m.lcFormFileName) With m.lcAlias, [], [] To m.lcReturn
      ReplaceCurrentLine(m.lcReturn)
    Case Lower(m.lcCommand) == [ed] And Empty(m.lcParam1) And Inlist(m.lnWindowType, 0)
      If !CheckOrCreatePandoraFile()
        Return
      Endif
      lcParam1 = GetLineNo(_Screen.cPandorafile, 1)
      If Lower(Getwordnum(m.lcParam1, 1)) = [default]
        lcParam1 = Getwordnum(m.lcParam1, Getwordcount(m.lcParam1 ))
      Else
        Messagebox( [No Default group defined in ] + _Screen.cPandorafile, 0)
        Return
      Endif
      If Val(m.lcParam1) > 0
        getlinestoprocess(Val(m.lcParam1))
      Else
        RunEd(m.lcParam1)
      Endif
    Case Lower(m.lcCommand) = [dir!]
      ListFiles(m.lcParam1, m.lcCommand,.T.)
    Case Lower(m.lcCommand) = [dd] And Inlist(m.lnWindowType, 10)
      MakeDD()
    Case Inlist(Lower(m.lcCommand), [dir] ) And m.lcParam1 = [*]
      If Substr(m.lcParam1, 2, 1) = [/]
        lcParam1 = Stuff(m.lcParam1, 2, 1, [\])
      Endif
      ListFiles(Substr(m.lcParam1, 2), m.lcCommand )
    Case Inlist(Lower(m.lcCommand), [dir], [\], [/], [*] ) and !IsDigit(Substr(m.lcCommand,2,1))
      Do Case
        Case Empty(m.lcParam1) And Inlist(m.lcCommand, [\], [/])
          lcParam1 = Substr(m.lcCommand, 2)
        Case Empty(m.lcParam1) And Inlist(m.lcCommand, [\\], [//])
          lcParam1 = Substr(m.lcCommand, 3)
      Endcase
      If Inlist(Left(m.lcParam1, 1), [!])
        ** Syntax to find Thor files: dir !xx where xx is a part of the filename
        lcParam1 = Substr(m.lcParam1, 2)
        ListFiles(m.lcParam1, m.lcCommand,.T.)
      Else
        If Left(m.lcParam1, 2) = [/]
          lcParam1 = [\] + Substr(m.lcParam1, 2)
        Endif
        ListFiles(m.lcParam1, m.lcCommand )
      Endif
    Case Lower(m.lcCommand) == [ed]
      RunEd(m.lcParam1)
    Case Left(m.lcCommand,1) = [*] and IsDigit(Substr(m.lcCommand,2,1)) and Lower(GetWordNum(m.lcParam1,1)) = 'exe'
      Try 
        ExecScript(Substr(m.lcParam1,4))
      Catch 
        ReturnUnknownCommand()
      Endtry
    Otherwise
      lcParam1 = Evl(m.lcParam1, m.lcCommand)
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
*********************************************************************************

Function CreateQmark
  Lparameters tcCommand, tcParam1, tldbo
  Local lcReturn

  If Empty(m.tcParam1)
    tcParam1 = Substr(m.tcCommand, 2)
  Endif
  If Empty(m.tcParam1) Or Getwordcount(m.tcParam1) > 1
    Return
  EndIf
  If m.tldbo 
    lcReturn = Textmerge([DebugOut '<<Strtran( m.tcParam1,'m.','') >>', <<m.tcParam1 >>])
  Else
    lcReturn = Textmerge([?'<<Strtran( m.tcParam1,'m.','') >>', <<m.tcParam1 >>])
  Endif
  ReplaceCurrentLine(m.lcReturn)
Endfunc

*********************************************************************************

Function CheckOrCreatePandoraFile
  If File(_Screen.cPandorafile)
    *!*      Wait Window at 1,1 _screen.cPandorafile + ' exists' time ccWaitTimeout
    Return .T.
  Else
    If Messagebox( [Specified file "] + _Screen.cPandorafile + [" doesn't exist, create empty file?], 4, [File not found!]) = 6
      Text To m.lcText Noshow Textmerge Pretext 7
        Default project: 0
        ************************* 
      Endtext
      Strtofile(m.lcText, _Screen.cPandorafile)
      Modify Command (_Screen.cPandorafile) Nowait
    Endif
    Return .F.
  Endif
Endfunc
*********************************************************************************
Procedure ChangePandoraFile
  Lparameters tcFile

  Local laDummy[1], laFiles[1], lcFile, lnFiles, lnLines, lnX, loThor

  lcFile =  GetPandoraFile()
  If Inlist(m.tcFile, [*], [-], [+], [/])
    lnFiles = Adir(laFiles, [*.pan])
    Do Case
      Case m.lnFiles = 0
        lcFile = [pandora.pan]
      Case m.lnFiles = 1
        lcFile = m.laFiles(1, 1)
      Otherwise
        Create Cursor curPanFiles (Filename c(25), Date T, Size i, LineS i)
        For lnX = 1 To m.lnFiles
          lnLines = Alines(laDummy, Filetostr(m.laFiles(m.lnX, 1)))
          Insert Into curPanFiles (Filename, Date, Size, LineS) Values (Lower(m.laFiles(m.lnX, 1)), dir2dt(m.laFiles(m.lnX, 4), m.laFiles(m.lnX, 3)), m.laFiles(m.lnX, 2), m.lnLines)
        Endfor
        Index On Filename Tag Filename
        Index On Date Tag Date
        Set Order To Date Descending
        lcFile = GetDataFromGrid([Select a file ddd:], [filename])
    Endcase
  Else
    lcFile = Forceext(Trim(m.tcFile), [pan])
    If !File(m.lcFile)
      If Messagebox( [Specified file "] + m.lcFile + [" doesn't exist, create empty file?], 4, [File not found!]) = 6
        Text To m.lcText Noshow Textmerge Pretext 7
          Default project: 0
          ************************* 
        Endtext
        Strtofile(m.lcText, _Screen.cPandorafile)
        Modify Command (_Screen.cPandorafile) Nowait
      Else
        lcFile = []
      Endif
    Endif
  Endif
  If !Empty(m.lcFile)
    SetPandoraFile(m.lcFile)
  Endif
  ReportPandoraFile()
Endproc
*********************************************************************************
Function GetPandoraFile
  Local lcDef, lcFile
  lcDef = ccPandoraDef

  If File(m.lcDef )
    lcFile = Mline(Filetostr(m.lcDef), 1)
    If !Empty(m.lcFile)
      lcFile = GetLastWord(m.lcFile)
      lcFile = Forceext(m.lcFile, [pan])
    Endif
  Endif
  If Empty(m.lcFile)
    lcFile = ccPandoraFile
  Endif
  Return m.lcFile
Endfunc
*********************************************************************************
Procedure SetPandoraFile
  Lparameters tcFile
  Strtofile( m.tcFile, ccPandoraDef, 0)

Endproc
*********************************************************************************
Procedure ReportPandoraFile
  Local lcFile
  lcFile = GetPandoraFile()
  _Screen.cPandorafile = m.lcFile
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
    Try
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

  tcText = Evl(m.tcText, [])
  Local laFiles[1], lnX
  Dimension m.laFiles(1)
  lnFiles = GetAllFiles(,@m.laFiles)
  If m.lnFiles = 0
    Return
  Endif
  Create Cursor (ccCursorfiles) (Filename c(240), FullName c(240), Descript c(100), Datetime D, Size i, LineS i, Text m, uDescript c(100))
  For lnX = 1 To m.lnFiles
    If Lower(Justext(m.laFiles(m.lnX))) =  [prg]
      lcDescript = GetDescript(m.laFiles(m.lnX))
      If !Empty(m.lcDescript)
        lcFile = Alltrim(m.laFiles(m.lnX))
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
    For lnX = 1 To Getwordcount(m.tcText)
      lcText = Lower(Getwordnum(m.tcText, m.lnX))
      Select * From (ccCursorfiles) Where m.lcText $ Lower(Filename) Or m.lcText $ Lower(Descript) Order By uDescript Into Cursor (ccCursorfiles) Readwrite
    Endfor
  Endif
  Go Top
  lcSelected = GetDataFromGrid([Prg files with description], [Fullname], 1)
  If !Empty(m.lcSelected)
    refreshCommandWindow([ed ] + m.lcSelected, m.tcCommand + [ ] + m.tcText )
  Endif

Endproc
*********************************************************************************

Function dir2dt
  Lparameters tcTime, ttDate
  Local lnSec, lnMin, lnHour, lnDay, lnMonth, lnYear
  lnSec = Val(Strextract(m.tcTime, [:], [], 2))
  lnMin = Val(Strextract(m.tcTime, [:], [:], 1))
  lnHour = Val(Strextract(m.tcTime, [], [:]))
  lnDay = Day(m.ttDate)
  lnMonth = Month(m.ttDate)
  lnYear = Year(m.ttDate)
  Return Datetime(m.lnYear, m.lnMonth, m.lnDay, m.lnHour, m.lnMin, m.lnSec)
Endfunc
*********************************************************************************
Procedure ListFiles
  Lparameters tcFilter, tcPrefix, tlThor

  Local laDummy[1], lcOption, lcText, lcWord, llRecords, lnFiles, lnX, loContextMenu
  Local lcFilename
  Local lnMemo
  Local lcDescript, lcFile, lcShow

  lcOption = Getwordnum(Strextract(m.tcPrefix, [:], []), 1)
  lcOption = Getwordnum(Strextract(m.tcPrefix, [:], []), 1)
  tcFilter = Evl(m.tcFilter, [*])
  tcFilter = Lower(m.tcFilter)
  If Empty(m.tlThor)
    tcPrefix = m.tcPrefix + [ *]
    lnFiles = GetFilesInPath([*], ccCursorfiles)
  Else
    tcPrefix = m.tcPrefix + [ *!]
    lnFiles = GetThorFiles([*], ccCursorfiles)
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
    For lnX = 1 To Getwordcount(m.tcFilter)
      lcWord = Getwordnum(m.tcFilter, m.lnX)
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
  llRecords = .F.
  If [a] $ m.lcOption Or [r] $ m.lcOption
    Select Count(*) From (ccCursorfiles) Where Inlist(Lower(Justext(Filename)), ccVFPTablesExtended) Into Array laDummy
  Else
    Select Count(*) From (ccCursorfiles) Where Inlist(Lower(Justext(Filename)), [dbf]) Into Array laDummy
  Endif
  llRecords = m.laDummy  > 0
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
      lcFile = Alltrim(FullName)
      lcDescript = GetDescript(m.lcFile )
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
  lcText = GetDataFromGrid([Select a file:], [fullname], 0)
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

Function CreateES
  Lparameters tcCommand

  #Define crlf Chr(13)+Chr(10)

  Local lcCallerName, lcCommand, lcFullName, lcProject, lcText, llClip, llNewProject, llRelativePath
  Local llTest, lnCallerHandle, lnCallerType, lnEdType, lnEnd, lnLength, lnProject, lnStart, loE
  Local loWindows
  Clear
  ?[tcCommand], m.tcCommand
  lcText = Lower(Trim(m.tcCommand))

  loE = Execscript(_Screen.cThorDispatcher, [Thor_Proc_EditorWin])
  lnCallerType = m.loE.FindWindow()
  If m.lnCallerType > 0
    lcCallerName = Lower(m.loE.GetTitle())
    lcFullName = Fullpath(m.lcCallerName)
  Endif
  lnCallerHandle = m.loE.GetWindowHandle()
  If m.lnCallerType < 0 Or (m.lnCallerType = 0 And Empty(m.tcCommand))
    Wait Window [Not legal from this window] At 10, 25 Timeo 5
    Return
  Endif
  lnProject = 0

  loWindows = m.loE.GetOpenWindows()
  llTest = Pemstatus(_Screen, [lTest], 5) And _Screen.lTest
  llClip = .T.
  lnEdType = 1
  llNewProject = .F.
  llRelativePath = ccRelativePath
  If [r] $ Lower(m.lcText)
    llRelativePath = .T.
    lcText = Chrtran(m.lcText, [r], [])
  Endif
  If [f] $ Lower(m.lcText)
    llRelativePath = .F.
    lcText = Chrtran(m.lcText, [f], [])
  Endif

  Do Case
    Case Inlist( m.lnCallerType, 1, 2) And Pemstatus(_Screen, [cPandorafile], 5) And m.lcCallerName = Lower(_Screen.cPandorafile)
      lnEdType = 4 && Only number, Ed syntax
      Do Case
        Case Left(m.lcText, 1) = [+] && find next project
          lnProject = GetNextProject()
          lcText = Substr(m.lcText, 2)
          If Empty(Left(m.lcText, 1))
            lcProject = Getwordnum(m.lcText, 1)
            lcText = []
          Else
            lcProject = Getwordnum(m.lcText, 2)
            lcText = Getwordnum(m.lcText, 1)
          Endif
          llNewProject = .T.
        Case Val(m.lcText) > 0
          lnProject = Int(Val(m.lcText))
          lnLength = Len(Transform(m.lnProject))
          lcText = Substr(m.lcText, m.lnLength + 1 )
        Otherwise
          lnProject = -1
      Endcase
      Do Case
        Case Inlist(Lower(m.lcText), [x], [editsourcex], [edx], [ex])
          lnEdType = 3
        Case Inlist(Lower(m.lcText), [s], [editsource], [eds], [es])
          lnEdType = 1
        Case Inlist(Lower(m.lcText), [e], [ed])
          lnEdType = 2
      Endcase
      lcCommand  = ScanAllWIndows(m.loWindows, m.lnCallerHandle, m.lnProject, m.lnEdType, m.llRelativePath )
      m.loE.SelectWindow(m.lnCallerHandle)
      CutCurrentLine()
      If m.llNewProject
        lcProject = Evl(m.lcProject, [New project])
        lcProject = Inputbox([Type new project name: ], [], m.lcProject)
        lcProject = Evl(m.lcProject, [New project])
        lcCommand = [#] + Transform(m.lnProject) + [ ] + m.lcProject + crlf + crlf + m.lcCommand
      Endif
      If Messagebox([Paste the following code:] + crlf + m.lcCommand, 4 + 64, [Current file is ] + _Screen.cPandorafile ) = 6
        WriteCurrentLine(m.lcCommand)
      Else
        Wait Window At 10, 25 [Operation cancelled!] Timeout 2
      Endif
    Case m.lnCallerType >= 0
      Do Case
        Case [s] $ Lower(m.lcText)
          lnEdType = 1
        Case [e] $ Lower(m.lcText)
          lnEdType = 2
        Case [x] $ Lower(m.lcText)
          lnEdType = 3
        Case [n] $ Lower(m.lcText)
          lnEdType = 4
      Endcase
      If Left(Lower(m.lcText), 3) = [all]
        lcCommand  = ScanAllWIndows(m.loWindows, m.lnCallerHandle, m.lnProject, m.lnEdType, m.llRelativePath )
        m.loE.SelectWindow(m.lnCallerHandle)
        CutCurrentLine()
        If Messagebox([Paste the following code:] + crlf + m.lcCommand, 4 + 64, [Current file is ] + _Screen.cPandorafile ) = 6
          WriteCurrentLine(m.lcCommand)
        Else
          Wait Window At 10, 25 [Operation cancelled!] Timeout 2
        Endif
      Else
        If m.lnCallerType > 0
          lcCommand = GetEditSourceCode(m.lnCallerHandle, m.lnEdType, [], m.llRelativePath )
          CutCurrentLine()
          If !Empty(m.lcCommand)
            If Messagebox( [Copy this code to the clipboard?] + crlf + m.lcCommand, 4 + 32, [Generated code!]) = 6
              _Cliptext = m.lcCommand
            Else
              Wait Window At 10, 25 [Operation cancelled!] Timeout 2
            Endif
          Endif
        Endif
      Endif
    Case Empty(m.lcCallerName)
      Messagebox( [Select a program or text file, or a method, first!], 0 + 48, [Not applicable from here!], 3000)
    Otherwise
      Messagebox( ccCanNotUse, 0 + 48, [This function only works in code windows!], 3000)
  Endcase
  m.loE.SelectWindow(m.lnCallerHandle)
Endfunc
********************************************************************************

Function GetEditSourceCode

  Lparameters tnHandle, tnEdType, tcPrefix, tlRelativePath
  Local lcClassName, lcFilename, lcMethod, lcName, lcObject, lcObjectPath, lcReturn, llTest, lnHandle
  Local lnLineNo, lnWindowType, loE, loFile, loObject, loTools
  tcPrefix = Evl(m.tcPrefix, [])
  tnHandle = Evl(m.tnHandle, Val(_Cliptext))
  Store [] To m.lcMethod, m.lcObjectPath, m.lcClassName
  Store 0 To m.lnLineNo, m.lnHandle
  llTest = Pemstatus(_Screen, [lTest], 5) And _Screen.lTest
  loE = Execscript(_Screen.cThorDispatcher, [Thor_Proc_EditorWin])
  *!*    m.loE.SetHandle(m.tnHandle)
  m.loE.SelectWindow(m.tnHandle)
  lnWindowType = m.loE.FindWindow()
  *!*    If m.lnWindowType >= 0 And m.llTest
  *!*      Wait Window At 1, 1 [Type ] + Transform(m.lnWindowType ) + [ - ] + m.loE.GetTitle()
  *!*    Endif
  loTools = Execscript (_Screen.cThorDispatcher, [class= tools from pemeditor])
  *!*  Return 
  loObject = m.loTools.GetCurrentObject(.F.)
  If m.lnWindowType > 0
    lnLineNo = m.loE.GetLineNumber() + 1
  Endif
  loFile = m.loTools.GetCurrentFileName()
  If Vartype(m.loFile) = [L] And .F. && Now, what was this for? :-)
    Wait Window At 10, 25 [warning]
    Return []
  Endif
  lnHandle = m.loE.nHandle
  Do Case
    Case m.lnWindowType = 0
      Wait Window ccCanNotUse Timeout 2
      Return
    Case Inlist(m.lnWindowType, 1, 2) && Program or file
      lcFilename = Fullpath(m.loE.GetTitle())
      If  Left(m.lcFilename, 7) = [PROGRAM] And Empty(Justext(m.lcFilename)) && Modi Comm, not saved
        Return
      Endif
      If m.tlRelativePath
        lcFilename = Sys(2014, m.lcFilename)
      Endif
    Otherwise && Method
      loObject = m.loTools.GetThis()
      lcObject = [loObject]
      If m.tlRelativePath
        lcFilename = Sys(2014, m.loFile.Filename)
      Else
        lcFilename = Fullpath(m.loFile.Filename)
      Endif
      If m.lnHandle > 0
        lcMethod = m.loE.GetTitle()
      Endif
      Do While .T.
        If Inlist(Type(m.lcObject), [U], [L])
          Exit
        Endif

        lcName = Evaluate(m.lcObject + [.name])
        If Empty(m.lcMethod)
          lcMethod = m.lcName
        Endif
        If Empty(m.lcObjectPath)
          lcObjectPath = m.lcName
        Else
          lcObjectPath = m.lcName + [.] + m.lcObjectPath
        Endif
        lcObject = m.lcObject + [.parent]
        If Type(m.lcObject + [.parent]) = [U]
          Exit
        Endif
      Enddo

      lcClassName = Strextract(m.lcObjectPath, [], [.])
      lcObjectPath = Strextract(m.lcObjectPath, [.]) && remove first element which is the classname
  Endcase
  *!*  If Pemstatus(_Screen, [lTest], 5) And _Screen.lTest
  *!*  ?'lcFilename', m.lcFilename

  *!*  Endif
  Do Case
    Case Inlist(m.tnEdType, 2, 4) && Ed or no Ed
      If m.tnEdType = 4
        lcType = []
        If [ ] $ m.lcFilename
          lcFilename = ['] + m.lcFilename + [']
        Endif

      Else
        lcType = [Ed ]
      Endif
      If Occurs([.], m.lcObjectPath) = 0 && Object directly on form
        lcObjectPath = Juststem(m.lcObjectPath)
      Endif

      If !Empty(m.lcObjectPath)
        Text To m.lcReturn Noshow Textmerge Pretext 1 + 2 + 4
      <<m.tcPrefix>><<m.lcType >><<m.lcFilename >>.<<m.lcClassName >>.<<m.lcObjectPath >>.<<JustExt(m.lcMethod)>>
        Endtext
      Else
        lcReturn = m.tcPrefix + m.lcType + m.lcFilename
      Endif
      If m.lnLineNo > 0
        lcReturn = m.lcReturn + [:] + Transform(m.lnLineNo)
      Endif

    Case m.tnEdType = 1 && EditSource
      If !Empty(m.lcMethod) And !Empty(m.lcObjectPath )
        lcMethod = m.lcObjectPath + [.] + Justext(m.lcMethod )
      Endif
      Text To m.lcReturn Noshow Textmerge Pretext 1 + 2 + 4
    EditSource('<<m.lcFilename>>', <<m.lnLineNo >>,'<<m.lcClassName>>','<<m.lcMethod>>')
      Endtext
    Otherwise && EditSourceX
      If !Empty(m.lcMethod) And !Empty(m.lcObjectPath )
        lcMethod = m.lcObjectPath + [.] + Justext(m.lcMethod )
      Endif
      Text To m.lcReturn Noshow Textmerge Pretext 1 + 2 + 4
    EditSourceX('<<m.lcFilename>>', '<<m.lcClassName>>','<<m.lcMethod>>',<<m.lnLineNo >>)
      Endtext

  Endcase
  Return m.lcReturn
Endfunc
*********************************************************************************

Function GetNextProject

  lcFileToRead = _Screen.cPandorafile
  lnLines = Alines(laDummy, Filetostr(m.lcFileToRead ))
  Dimension m.laProject(1)

  For lnX = 1 To m.lnLines
    lcText = Getwordnum(m.laDummy(m.lnX ), 1)
    If Val(m.lcText) > 0
      lnLength = Alen(m.laProject)
      If m.lnLength > 1 Or !Empty(m.laProject(1))
        lnLength = m.lnLength + 1
        Dimension m.laProject(m.lnLength)
      Endif
      laProject(m.lnLength) = Val(m.lcText)
    Endif
  Endfor

  If Alen(m.laProject ) = 1 And Empty(m.laProject(1))
    lnNewProject = 1
  Else
    lnNewProject = 1
    Do While .T.
      If Ascan(m.laProject, m.lnNewProject ) > 0
        lnNewProject = m.lnNewProject + 1
      Else
        Exit
      Endif
    Enddo
  Endif

  Return m.lnNewProject
Endfunc

*********************************************************************************

Function ScanAllWIndows
  Lparameters toWindows, tnCallerHandler, tnPrefix, tnEdType, tlRelativePath

  Local lcCode, lcPrefix, lcReturn, lnHandle, loWindow
  #Define crlf Chr(13)+Chr(10)
  Do Case
    Case Empty(m.tnPrefix )
      lcPrefix = []
    Case m.tnPrefix = -1
      lcPrefix = [0 ]
    Otherwise
      lcPrefix = Transform(m.tnPrefix) + [ ]
  Endcase
  lcReturn = []
  For Each m.loWindow In m.toWindows FoxObj
    lnHandle = m.loWindow.nWHAndle
    If m.lnHandle = m.tnCallerHandler
      Loop
    Endif
    lcCode = GetEditSourceCode(m.lnHandle, m.tnEdType, m.lcPrefix, m.tlRelativePath )
    If Empty(m.lcReturn )
      lcReturn = m.lcCode
    Else
      lcReturn = m.lcReturn + crlf + m.lcCode
    Endif
    *!*    Do test3 With m.lnHandle
  Endfor
  Return m.lcReturn
Endfunc

*********************************************************************************

Procedure RunProgram
  Lparameters tcFile
  lcExt = Lower(Justext(m.tcFile))
  Do Case
    Case m.lcExt = [prg]
      lcCommand = Textmerge([do <<m.tcFile>>])
    Case m.lcExt = [scx]
      lcCommand = Textmerge([do form <<m.tcFile>>])
  Endcase
  Try
    Execscript(m.lcCommand)
  Catch
    Messagebox( [Can not run file!], 48, m.tcFile)
  Endtry
Endproc
*********************************************************************************
Procedure refreshCommandWindow
  Lparameters tcText, tcOriginal
  Local loEditorWin

  loEditorWin = Execscript(_Screen.cThorDispatcher, [Thor_Proc_EditorWin])
  m.loEditorWin.Delete()
  m.loEditorWin.Insert(m.tcOriginal)
  If !Empty(m.tcText)
    ProcessText(m.tcText)
  Endif
Endproc

*********************************************************************************
Function ConfirmDelete
  Lparameters tcFile
  If Lower(Justext(m.tcFile)) = [prg]
    lcReply = [PANX]
    If Lower( Inputbox([Confirm deletion by typing ] + m.lcReply + [:], [Delete ] + m.tcFile, []) ) = Lower(m.lcReply)
      Dimension m.laExtensions(3)
      laExtensions(1) = [prg]
      laExtensions(2) = [bak]
      laExtensions(3) = [fxp]
      For lnX = 1 To 3
        Try
          Delete File (Forceext(m.tcFile, m.laExtensions(m.lnX)))
        Catch
        Endtry
      Endfor
    Else
      Messagebox( [No deletion done!], 64, m.tcFile)
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
    tcFileName = Forceext(m.tcFileName, [dbf])
  Endif
  Try
    lnHandle = Fopen(m.tcFileName )
    lcContents = Fread(m.lnHandle, 20)
    lcLen = Substr(m.lcContents, 5, 4)
    Fclose(m.lnHandle )
    lnRec = CToBin(m.lcLen, [4RS])
  Catch
    Try
      Use (m.tcFileName) Again In 0 Alias GetRecords
      lnRec = Reccount([GetRecords])
      Use In GetRecords
    Catch
      lnRec = -2
    Endtry
  Endtry
  Return m.lnRec
Endfunc
*********************************************************************************
Function GetMemoSize
  Lparameters tcFileDBF
  Local laDummy[1], lcFileMemo, lnFiles, lnReturn
  lnReturn = 0
  Do Case
    Case Lower(Justext(m.tcFileDBF)) = [dbf]
      lcFileMemo = Forceext(m.tcFileDBF, [fpt])
    Case Lower(Justext(m.tcFileDBF)) = [dbc]
      lcFileMemo = Forceext(m.tcFileDBF, [dct])
    Case Inlist(Lower(Justext(m.tcFileDBF)), [vcx], [scx], [frx], [lbx], [mnx], [pjx])
      lcFileMemo = Forceext(m.tcFileDBF, Left(Lower(Justext(m.tcFileDBF)), 2) + [t])
    Otherwise
      lcFileMemo = []
  Endcase
  If !Empty(m.lcFileMemo)
    lnFiles = Adir(laDummy, m.lcFileMemo)
    If m.lnFiles = 1
      lnReturn = m.laDummy(1, 2)
    Endif
  Endif
  Return m.lnReturn
Endfunc
*********************************************************************************
Function GetThorFiles
  Lparameters tcMask, tcCursor
  Local laDummy[1], laFolders[1], lcFileSkel, lnFiles, lnFolders, lnX, lnX2
  tcCursor = Evl(m.tcCursor, [curFiles])
  Create Cursor (m.tcCursor) (Fname c(240), Filedate D, FileSize i)
  tcMask = Evl(m.tcMask, [prg])
  Dimension m.laFolders(3)
  laFolders(1) = _Screen.Cthorfolder + [Tools]
  laFolders(2) = _Screen.Cthorfolder + [Tools\My tools]
  laFolders(3) = _Screen.Cthorfolder + [procs]

  lnFolders = Alen(m.laFolders)
  For lnX = 1 To m.lnFolders
    If m.lnX = 0
      lcFileSkel = [*.] + m.tcMask
    Else
      lcFileSkel = Alltrim(m.laFolders(m.lnX)) + [\*.] + m.tcMask
    Endif
    lnFiles = Adir(laDummy, m.lcFileSkel)
    If m.lnFiles > 0
      For lnX2 = 1 To m.lnFiles
        ldDate = m.laDummy(m.lnX2, 3)
        lnSize = m.laDummy(m.lnX2, 2)
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


  lcTable = _Screen.cPandorafile
  Local loContextMenu As ContextMenu Of [C:\VFP9\Tools\Thor\Source\thor_menu.vcx]
  lcClip = _Cliptext
  loEditorWin = Execscript(_Screen.cThorDispatcher, [Thor_Proc_EditorWin])
  If m.loEditorWin.FindWindow() = 0
    Create Cursor curProjects (text1 c(240), Projnotxt c(3), Project c(50), projno i)
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
      lcText = GetDataFromGrid([Select project], [projectno])
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
      lcText = ccUnknownCommand + [!]
    Case m.tnText = 1
      lcText = ccUnknownCommand + [ in this window!]
  Endcase
  Wait Window m.lcText Timeout ccWaitTimeout
Endfunc

*********************************************************************************
Function GetHeader
  Lparameters tcOriginalLine, tcParameter
  Local laHeaders[1], lcNewText, loEditorWin
  Local laList[1], lcClip, lcTextOriginal
  Local lnPos
  lcClip = _Cliptext
  If GetFilesInPath([H], ccCursorfiles) = 0
    _Cliptext = _Screen.cClip
    Return
  Endif
  If !Empty(m.tcParameter)
    Select * From (ccCursorfiles) Into Cursor (ccCursorfiles) Readwrite Where Alltrim(Lower(m.tcParameter)) $ Lower(Fname)
  Endif
  lcText = GetDataFromGrid([Select file], ccCursorfiles + [.fname])
  If !Empty(m.lcText)
    ReplaceCurrentLine([#Include ] + m.lcText + ccCR)
  Endif
Endfunc
*********************************************************************************
Function TryExecute(tcParameter)
  Local llOk
  Try
    Execscript(m.tcParameter )
    llOk = .T.
  Catch
    Wait Window ccUnknownCommand
  Endtry
  Return m.llOk
Endfunc
*********************************************************************************
Function ReplaceCurrentLine(tcText)
  CutCurrentLine()
  WriteCurrentLine(m.tcText)
Endfunc
*********************************************************************************
Function WriteCurrentLine
  Lparameters tcText
  Local lcClip, loEditorWin

  If Vartype(m.tcText) # [C]
    Return
  Endif
  loEditorWin = Execscript(_Screen.cThorDispatcher, [Thor_Proc_EditorWin])
  m.loEditorWin.Insert(m.tcText)

Endfunc
*********************************************************************************
Function CutCurrentLine
  Local loEditorWin
  lcClip = _Cliptext
  HighlightCurrentLine()
  loEditorWin = Execscript(_Screen.cThorDispatcher, [Thor_Proc_EditorWin])
  If m.loEditorWin.FindWindow() < 0
    Return []
  Endif
  m.loEditorWin.Copy()
  lcText = _Cliptext
  _Cliptext = m.lcClip
  m.loEditorWin.Cut()
  Return m.lcText
Endfunc
*********************************************************************************

Function HighlightCurrentLine
  Local lnEndPos, loEditorWin

  loEditorWin  = Execscript(_Screen.cThorDispatcher, [Thor_Proc_EditorWin])
  If m.loEditorWin.FindWindow() < 0
    Return
  Endif
  lnEndPos = m.loEditorWin.GetLineStart(m.loEditorWin.GetSelStart(), 1)
  If m.loEditorWin.GetLineNumber(m.lnEndPos) < m.loEditorWin.GetLineNumber(1e8)
    lnEndPos = m.lnEndPos - 1
  Endif
  m.loEditorWin.Select(m.loEditorWin.GetLineStart(m.loEditorWin.GetSelStart(), 0), m.lnEndPos )
Endfunc
*********************************************************************************
Function getlinestoprocess
  Lparameters tnGroup
  Local laLines[1], lcCommand, lnCounter, lnLine, lnLines
  Local llFound
  If _Screen.lTest And .T.
    Set Step On
  Endif

  If !CheckOrCreatePandoraFile()
    Return
  Endif
  llFound = .F.
  lnLines = Alines(laLines, Filetostr(_Screen.cPandorafile))
  For lnCounter = 1 To m.lnLines
    lnLine = Val(Getwordnum(m.laLines(m.lnCounter), 1))
    If m.lnLine = m.tnGroup Or (m.lnLine = 0 And Getwordnum(m.laLines(m.lnCounter), 1) = [0])
      llFound = .T.
      lcCommand = Strextract(m.laLines(m.lnCounter), [ ])
      If ccAmp $ m.lcCommand
        lcCommand = Strextract(m.laLines(m.lnCounter), [ ], ccAmp, 1)
      Endif
      Do Case
        Case Lower(Getwordnum(m.lcCommand, 1)) = [do]
          Execscript(m.lcCommand)
        Case Lower(Getwordnum(m.lcCommand, 1)) = [exe]
        *tbtbtbtb
        
          lcCommand = Strextract(m.lcCommand, ccRun, [])
          Execscript(m.lcCommand)
        Otherwise
          RunEd(m.lcCommand)
      Endcase
    Endif
  Endfor
  If !m.llFound
    Messagebox( [Group number ] + Transform(m.tnGroup) + [ doesn't exist in ] + _Screen.cPandorafile, 0, [Nothing to do!])
  Endif
Endfunc

*********************************************************************************

Function RunEd(tcPar)
  Local lcCommand, lcExt, lcFile, lcFolder, lcMethod, lcObject, lcParOrg, lcParam1, lcParameters
  Local lnLine, lnLineNo, loTools
*!*  If Pemstatus(_Screen, [lTest], 5) And _Screen.lTest
*!*    Set Step On 
*!*  Endif
  lcParOrg = m.tcPar
  lcParam1 = m.tcPar
  If Empty(m.tcPar) Or (Val(m.tcPar) > 0 And m.tcPar = Transform(Val(m.tcPar)))
    Messagebox( [Illegal command!])
    lnLine = Val(m.tcPar)
    lnLine = Evl(m.lnLine, 1)
    If File(_Screen.cPandorafile )
      lcParam1 = GetNumberedline(_Screen.cPandorafile, m.lnLine )
    Else
      Return
    Endif
  Endif

  If m.lcParam1 = [0]
    lcParam1 = _Screen.cPandorafile
  Endif
  lcParam1 = Chrtran(m.lcParam1, ccPipe, [])
  lcParam1 = Alltrim(m.lcParam1, 0, [!], Chr(13))
  If ccAmp $ m.lcParam1
    lcParam1 = Left(m.lcParam1, At(ccAmp, m.lcParam1))
  Endif
  If [(] $ m.lcParam1 And Getwordnum(m.lcParam1, 1) # ccRun
    lcParam1 = Evaluate(m.lcParam1)
    If Vartype(m.lcParam1) = [L] && Function was called
      Return
    Endif
  Endif
  lcFolder = [classes\]
  lnLineNo = Int(Val(Strextract(m.lcParam1, [:], [], Occurs([:], m.lcParam1))))
  Do Case
    Case Empty(Justext(m.lcParam1)) And Right(m.lcParam1, 1) # [)] And !Inlist(Lower(Left(m.lcParam1, 4)), [http], [mail])
      lcExt = [prg]
      lcParam1 = Forceext(m.lcParam1, m.lcExt)
    Case [.scx] $ Lower(m.lcParam1)
      lcExt = [scx]
    Case [.vcx] $ Lower(m.lcParam1)
      lcExt = [vcx]
    Case [.prg] $ Lower(m.lcParam1)
      lcExt = [prg]
    Case Occurs([.], m.lcParam1) = 1
      lcExt = Justext(m.lcParam1)
    Case [.txt] $ Lower(m.lcParam1)
      lcExt = [txt]
    Case [.pan] $ Lower(m.lcParam1)
      lcExt = [pan]
    Otherwise
      lcExt = []
  Endcase
  lcFile = Strextract(m.lcParam1, [], m.lcExt, 1, 1 + 4)
  lcFile = Chrtran(m.lcFile, ['], [])
  Do Case
    Case Inlist(Lower(Strextract(m.lcParam1, [], [:], 1, 4)), [http:], [https:])
      shellX(m.lcParam1)
    Case m.lcExt = [pan]
      Modify Command (m.tcPar) Nowait
    Case m.lcExt = [vcx] Or m.lcExt = [scx]
      lcParam1 = Lower(m.lcParam1)
      If [:] $ m.lcParam1
        lcParameters = Strextract(m.lcParam1, m.lcExt + [.], [:])
      Else
        lcParameters = Strextract(m.lcParam1, m.lcExt + [.])
      Endif
      lcObject = Getwordnum(m.lcParameters, 1, [.])
      lcMethod = Substr(m.lcParameters, Len(m.lcObject) + 2)
      loTools = Execscript (_Screen.cThorDispatcher, [Class= tools from pemeditor])
      m.loTools.EditSourceX(m.lcFile, m.lcObject, m.lcMethod, m.lnLineNo)
    Case Getwordnum(m.lcParam1, 1) = ccRun
      lcCommand = Strextract(m.lcParam1, ccRun, [])
      Try
        Execscript(Strextract(m.lcParam1, ccRun, []))
      Catch
        Wait Window m.lcCommand + ccCR + ccUnknownCommand
      Endtry
      TryExecute(Strextract(m.lcParam1, ccRun, []))
    Case m.lcExt = [prg]
      If m.lnLineNo > 0
        If Occurs([:], m.lcParam1) > 1 And At([:], m.lcParam1, 2) > 2
          lcParam1 = Left(m.lcParam1, At([:], m.lcParam1, Occurs([:], m.lcParam1)) - 1)
        EndIf

        *!*          m.lcParam1 = Strextract(m.lcParam1, [], [:])
        *!*          Editsource(m.lcParam1, m.lnLineNo)
        Editsource(m.lcFile, m.lnLineNo)
      Else
        If Lower(GetWordNum(m.lcParam1,1)) = 'ed'
          m.lcParam1 = Substr(m.lcParam1,3)
        Endif
      
        loTools = Execscript (_Screen.cThorDispatcher, [Class= tools from pemeditor])
        m.loTools.EditSourceX(m.lcParam1 )
      Endif
    Otherwise
      loTools = Execscript (_Screen.cThorDispatcher, [Class= tools from pemeditor])
      m.loTools.EditSourceX(m.lcParam1 )
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
  lcOldDir = Fullpath(Curdir())
  If Empty(m.tcDirectory)
    tcDirectory = m.lcOldDir
  Endif
  Set Default To (m.tcDirectory)
  = Adir(laTemp, [*.*], [AHRSD], 1)
  lnMax = Alen(m.laTemp, 1)
  For lnCount = 1 To m.lnMax
    lcFile = Alltrim(m.laTemp(m.lnCount, 1))
    If !(m.lcFile == [.]) And !(m.lcFile == [..])
      If [D] $ m.laTemp(m.lnCount, 5)
        = GetAllFiles(Addbs(m.tcDirectory + m.lcFile), @m.laFiles)
      Else
        lnLen = Alen(m.laFiles)
        If !Empty(m.laFiles(m.lnLen))
          Dimension m.laFiles(m.lnLen + 1)
          lnLen = m.lnLen + 1
        Endif
        laFiles(m.lnLen) = m.tcDirectory + m.lcFile
      Endif
    Endif
  Endfor
  Set Default To (m.lcOldDir)
  Return Alen(m.laFiles, 1)
Endfunc
*********************************************************************************
Function GetNumberedline
  Lparameters tcFile, tnLine
  lnLines = Alines(laDummy, Filetostr(m.tcFile))
  lcReturn = []
  If m.lnLines > 0
    For lnX = 1 To m.lnLines
      lnLine = Val(Getwordnum(m.laDummy(m.lnX), 1))
      If m.lnLine = m.tnLine
        lcReturn = Strextract(m.laDummy(m.lnX), [ ])
        If ccAmp $ m.lcReturn
          lcReturn = Strextract(m.laDummy(m.lnX), [ ], ccAmp, 1)
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
  lnLines = Alines(laDummy, Filetostr(m.tcFile))
  lcReturn = []
  If m.tnLine <= m.lnLines
    lcReturn = m.laDummy(m.tnLine)
  Endif
  Return m.lcReturn
Endfunc
*********************************************************************************
Function shellX
  Lparameters tcURL, tcCommand, tcParameter
  tcCommand = Evl(m.tcCommand, [open])
  tcParameter = Evl(m.tcParameter, [])
  #Define SW_HIDE 0
  #Define SW_SHOWNORMAL 1
  #Define SW_SHOWMINIMIZED 2
  #Define SW_SHOWMAXIMIZED 3
  *!*   Legal verbs: open, edit, print, find, explore, NULL
  Declare Integer ShellExecute In shell32.Dll ;
    Integer hndWin, String cAction, String cFileName, ;
    String cParams, String cDir, Integer nShowWin
  ShellExecute( 0, m.tcCommand, m.tcURL, m.tcParameter, [], SW_SHOWNORMAL )
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
    tcFilter = ['dbf','vcx','scx','prg','txt','pan']
  Endif
  lcPath = Justpath(m.tcFile)
  lcFile = []
  lcReturn = []
  Do Case
    Case Adir(laFiles, m.tcFile) = 1
      lcFile = m.tcFile
    Case !Empty(m.lcPath)
      If Empty(Justext(m.tcFile))
        lnFiles = Adir(laFiles, Forceext(m.tcFile, [*]))
        If m.lnFiles > 1
          For lnX = 1 To m.lnFiles
            If Inlist(Lower(Justext(m.laFiles(m.lnX, 1))),&tcFilter)
              lcFile = m.laFiles(m.lnX, 1)
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
    lcReturn = Fullpath(Forcepath(m.lcFile, m.lcPath))
  Endif
  Return m.lcReturn
Endfunc

*********************************************************************************
Procedure BrowseHotKeys
  #Define ccTool         'Browse all Thor Tools'
  llExcludeNotUsed = Execscript(_Screen.cThorDispatcher, [Get Option=], ccTool, ccTool)
  lcDestAlias = [curHotKeys]
  lnSelect = Select()
  Execscript(_Screen.cThorDispatcher, [Thor_Proc_GetHotKeyDefs], m.lcDestAlias, m.llExcludeNotUsed )
  Select Distinct Cast(Descript As c(100)) As Descript, Chrtran(HotKey, [-], [+]) As HotKey, Cast([] As c(10)) As sortkey, Favorite, PRGName, StatusBar From (m.lcDestAlias);
    Where !Empty(HotKey ) And Substr(Descript, 3, 1) # [-] Into Cursor (m.lcDestAlias ) ;
    Readwrite
  Scan
    lcHotkey = HotKey
    Select Recno() From (_Screen.Cthorfolder + [\source\hotkeys])  Hotkeys Where Hotkeys.Key = Substr(m.lcHotkey, 1 + Rat([+], m.lcHotkey ), 10) Into Array laDummy
    Replace sortkey With Padl(laDummy, 2, [ ]) + m.lcHotkey
  Endscan
  Select Distinct HotKey, Descript, Favorite, PRGName, sortkey From (m.lcDestAlias) Into Cursor (m.lcDestAlias) Order By sortkey Readwrite
  Select HotKey, Descript, Favorite, PRGName From (m.lcDestAlias) Into Cursor (m.lcDestAlias) Readwrite
  Index On Lower(HotKey) Tag HotKey
  Index On Lower(Descript) Tag Descript
  Index On Favorite Tag Favorite
  Set Order To
  lcProg = GetDataFromGrid([Thor tools], [prgname], 1)
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

  llExcludeNotUsed = Execscript(_Screen.cThorDispatcher, [Get Option=], ccTool, ccTool)
  lcDestAlias = [curHotKeys]
  lnSelect = Select()
  Execscript(_Screen.cThorDispatcher, [Thor_Proc_GetHotKeyDefs], m.lcDestAlias, m.llExcludeNotUsed )
  Select Distinct Cast(Ltrim(Descript) As c(100)) As Descript, Chrtran(HotKey, [-], [+]) As HotKey, Cast([] As c(10)) As sortkey, Favorite, PRGName, StatusBar From (m.lcDestAlias);
    Into Cursor (m.lcDestAlias ) Where Left(Descript, 1) # [ ] And Substr(Descript, 3, 1) # [-];
    Readwrite
  Scan
    lcHotkey = HotKey
    Select Recno() From (_Screen.Cthorfolder + [\source\hotkeys])  Hotkeys Where Hotkeys.Key = Substr(m.lcHotkey, 1 + Rat([+], m.lcHotkey ), 10) Into Array laDummy
    If _Tally > 0
      Replace sortkey With Padl(m.laDummy, 2, [ ]) + m.lcHotkey
    Endif
  Endscan
  Select HotKey, Descript, Favorite, PRGName From (m.lcDestAlias) Into Cursor (m.lcDestAlias) Readwrite
  lcDesc = []
  lcHotkey = []
  Scan
    If Lower(Descript) == m.lcDesc And Lower(HotKey) = m.lcHotkey
      Delete
    Endif
    lcDesc = Lower(Descript)
    lcHotkey = Lower(HotKey)
  Endscan
  Select * From (m.lcDestAlias ) Into Cursor (m.lcDestAlias ) Readwrite Where !Deleted()
  Index On Favorite Tag Favorite
  Index On HotKey Tag HotKey
  Index On Descript Tag Descript
  Locate
  lcProg = GetDataFromGrid([Thor tools], [prgname], 1)
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
  tnHideColumns = Evl(m.tnHideColumns, 0)
  lnModeless = Iif(Empty(m.tlModeless), 1, 2)
  *!*    Wait Window at 1,1 m.lnModeless 
  lcReturn = []
  If !Empty(Dbf())
    lcVCXFile = Execscript(_Screen.cThorDispatcher, [Full Path=] + [thor_proc_pandora.VCX])
    lcHideColumns = Replicate([L], Evl(m.tnHideColumns, 0))
    lcParameter = [1U] + m.lcHideColumns
    loPg = Newobject([pg], m.lcVCXFile, [], m.lcParameter )
    loPg.Caption = Alltrim(m.tcCaption)
    loPg.nIncStart = 0
    loPg.lShowZero = .F.
    *!*      If !Empty(m.tnWidth) And Vartype(m.tnWidth) = [N]
    *!*        m.loPg.Width = m.tnWidth
    *!*      Endif
    m.loPg.Show(m.lnModeless )
    If m.lnModeless = 2
      Read Events
    Endif
    If !Inlist(Lastkey(), 97, 33) And !Empty(m.tcReturnField)
      lcReturn = Alltrim(Evaluate(m.tcReturnField))
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
    lnSelect = Select()
    lcCursor = [curCustom]
    lnTools = GetFilesInPath([prg], m.lcCursor )
    Select Cast(Lower(Substr(Juststem(Fname), 5)) As c(30)) As Program, FileSize, Filedate, Cast([] As c(100)) As Descript, Fname From (m.lcCursor) Into Cursor (m.lcCursor) Readwrite Where Lower(Left(Juststem(Fname), 4)) = [pan_]
    If _Tally = 0
      Messagebox( [No tool matching pan_ *.prg found], 0 + 48, [No custom tool defined])
    Else
      Scan
        lcFile = Alltrim(Fname)
        lcDescript = GetDescript(m.lcFile )
        If !Empty( m.lcDescript )
          Replace Descript With m.lcDescript
        Endif
      Endscan
      Go Top
      lcProg = GetDataFromGrid([My "Pandora" extensions (R/O):], [fname], 1)
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
    lcFilename = Getwordnum(m.tcFileName, 1)
    lcPar = Getwordnum(m.tcFileName, 2)
    lcProg = Forceext([pan_] + m.lcFilename, [prg])
    If File(m.lcProg )
      If !Empty(m.lcPar)
        Do (m.lcProg ) With m.lcPar
      Else
        Do (m.lcProg )
      Endif
    Else
      If Messagebox( [File ] + m.lcProg + [ is not found], 4 + 48, [Create it?]) = 6
        Do Case
          Case Directory([prog])
            lcPath = [prog]
          Case Directory([prg])
            lcPath = [prg]
          Otherwise
            lcPath = []
        Endcase
        _Screen.lPanComment = .F.
        Modify Command (Forcepath(m.lcProg, m.lcPath)) Nowait
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
  lcProg = Substr(m.tcCommand, 3)
  lcProgFile = Forceext([pan_] + m.lcProg, [prg])
  If !Empty(m.lcProg)
    If File(m.lcProgFile)
      Modify Command (m.lcProgFile) Nowait
    Else
      Messagebox( [File ] + m.lcProgFile + [ is not found!], 0 + 48, [Nothing to do])
    Endif
  Else
    lnSelect = Select()
    lcCursor = [curCustom]
    lnTools = GetFilesInPath([prg], m.lcCursor )
    *!*  Browse Normal   
    Select Cast(Lower(Substr(Juststem(Fname), 5)) As c(30)) As Program, FileSize, Filedate, Cast([] As c(100)) As Descript, Fname From (m.lcCursor) Into Cursor (m.lcCursor) Readwrite Where Lower(Left(Juststem(Fname), 4)) = [pan_]
    If _Tally = 0
      Messagebox( [No tool matching pan_ *.prg found], 0 + 48, [No custom tool defined])
    Else
      Scan
        lcFile = Alltrim(Fname)
        lcDescript = GetDescript(m.lcFile )
        If !Empty( m.lcDescript )
          Replace Descript With m.lcDescript
        Endif
      Endscan
      Go Top
      lcProg = GetDataFromGrid([My "Pandora" extensions:], [fname], 1)
      Use
      Select (m.lnSelect)
      If !Empty(m.lcProg)
        Modify Command (m.lcProg) Nowait
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

  tcCursor = Evl(m.tcCursor, [curFiles])
  Create Cursor (m.tcCursor) (Fname c(240), Filedate D, FileSize i)
  tcMask = Evl(m.tcMask, [prg])
  lnFolders = Alines(laFolders, Set([Path]), 1 + 4, [;], [,])
  For lnX = 0 To m.lnFolders
    If m.lnX = 0
      lcFileSkel = [*.] + m.tcMask
    Else
      lcFileSkel = Alltrim(m.laFolders(m.lnX)) + [\*.] + m.tcMask
    Endif
    lnFiles = Adir(laDummy, m.lcFileSkel)
    If m.lnFiles > 0
      For lnX2 = 1 To m.lnFiles
        lnSize = m.laDummy(m.lnX2, 2)
        ldDate = m.laDummy(m.lnX2, 3)
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

  lnHandle = Fopen(m.tcFile )
  lcDescript = []
  For lnX1 = 1 To ccMaxDescriptLine
    lcContents = Fgets(m.lnHandle)
    If Occurs(ccDescriptionMask1, m.lcContents) > 0
      lcDescript = Alltrim(Strextract(m.lcContents, ccDescriptionMask1, ccDescriptionMask2 ))
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

  lcCode = []
  If Inlist(Lower(Justext(m.tcMethod)), [prg], [h])
    If File(m.tcMethod)
      lcCode = Filetostr(m.tcMethod)
    Else
      Messagebox( [File not found!], 48, Alltrim(m.tcMethod))
    Endif
  Else
    lcMethod = Alltrim(Lower(m.tcMethod))
    lcText = []
    lnSelect = Select()
    Create Cursor CurMethods (Method c(240), Source c(240), Code m)
    GetFilesInPath([prg], [curPrgs])
    Scan
      lcSource = curprgs.Fname
      lnProcs = Aprocinfo(laProc, curprgs.Fname, 0)
      For lnX = 1 To m.lnProcs
        If m.laProc(m.lnX, 3) = [Procedure] And ![.] $ m.laProc(m.lnX, 1) And (m.lcMethod $ Lower(m.laProc(m.lnX, 1)) Or Empty(m.lcMethod))
          lcProc = m.laProc(m.lnX, 1)
          lcCode = methodfromprg(m.lcProc, m.lcSource)
          Insert Into CurMethods (Source, Method, Code) Values (m.lcSource, m.lcProc, m.lcCode )
        Endif
      Endfor
    Endscan
    Select CurMethods
    Index On Lower(Method) Tag Method
    Locate
    If Reccount() > 0
      lcCode = GetDataFromGrid([Select method to insert], [curmethods.code])
    Else
      Messagebox( [No match found!], 48, m.tcMethod)
    Endif
    Select (m.lnSelect)
    lcMethod = Trim(CurMethods.Method)
    lcSource = Trim(CurMethods.Source )
    Use In Select([curmethods])
    Use In Select([curprgs])
  Endif
  If !Empty(m.lcCode)
    ReplaceCurrentLine(m.lcCode + ccCR )
  Endif

Endfunc

*********************************************************************************
Function methodfromprg
  Lparameters tcProcedure, tcFile
  Local laDummy[1], lcFile, lcProc, lcReturn, lnEnd, lnStart, lnX
  Local lnSelect
  lnSelect = Select()
  lcProc = Lower(Padr(m.tcProcedure, 100))
  lcFile = Forceext(m.tcFile, [prg])
  lnX = Aprocinfo(laDummy, m.lcFile, 0)
  lcReturn = []
  If m.lnX > 0.
    Create Cursor curDummy (Name c(100), Line i, Type c(25), ind i)
    Append From Array m.laDummy
    Select Name, Line From curDummy Into Cursor curDummy Readwrite Where Type = [Procedure]
    Locate For Lower(Name) == m.lcProc
    If Found()
      lnStart = Line
      Skip
      lnX = Alines(laDummy, Filetostr(m.lcFile ))
      If !Eof([curdummy])
        lnEnd = Line - 1
      Else
        lnEnd = m.lnX
      Endif
      If m.lnX > 0
        lcReturn = []
        For lnX = m.lnStart To m.lnEnd
          lcReturn  = m.lcReturn + Trim(m.laDummy(m.lnX )) + crlf
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

  lnMemo = Set([Memowidth])
  Set Memowidth To 8192
  Scan For Inlist(Lower(Justext(Filename)), [prg], [txt], [h], [pan])
    Try
      Replace Text With Filetostr(Alltrim(FullName))
      Replace LineS With Memlines(Text)
    Catch
    Endtry
  Endscan
  Set Memowidth To m.lnMemo
  Index On LineS Tag LineS
Endproc
*********************************************************************************
Procedure InsertResult
  Lparameters tcMethod
  lcText = []
  If !Right(m.tcMethod, 1) = [)]
    tcMethod = m.tcMethod + [()]
  Endif
  Try
    lcText = Transform(Evaluate(m.tcMethod))
  Catch
    Messagebox( [No or invalid result!], 0 + 48, m.tcMethod)
  Endtry
  If !Empty(m.lcText)
    ReplaceCurrentLine(m.lcText + ccCR)
  Endif

Endproc

*********************************************************************************
Function GetLastWord
  Lparameters tcText, tcDelimiter
  If Pcount() < 2 Or Vartype(m.tcDelimiter) # [C]
    tcDelimiter = [ ]
  Endif
  Return Trim(Getwordnum(m.tcText, Getwordcount(m.tcText, m.tcDelimiter), m.tcDelimiter))
  *********************************************************************************
Procedure MakeDD && Creates DoDefault call
  Local lcResult

  lcResult = [DoDefault(] + _oPEMEditor.oUtils.oBeautifyX.FetchParametersList() + [)] + ccCR
  ReplaceCurrentLine(m.lcResult)
Endproc
*********************************************************************************
Function GetRandomText
  Lparameters tnSentences, tnParagraphs
  tnParagraphs = Evl(m.tnParagraphs, 1)
  tnSentences = Evl(m.tnSentences, 1)
  Return GetDataFromURL(Textmerge([http://metaphorpsum.com/paragraphs/<<Int(m.tnParagraphs)>>/<<Int(m.tnSentences)>>]))
Endfunc
*********************************************************************************
Function GetLoremText
  Lparameters tnLength, tnParagraphs
  Local lcLength, lcURL

  tnParagraphs = Evl(m.tnParagraphs, 1)
  tnLength = Evl(m.tnLength, 0)
  Do Case
    Case Empty(m.tnLength)
      lcLength = [short]
    Case M.tnLength = 1
      lcLength = [medium]
    Case M.tnLength = 2
      lcLength = [long]
    Otherwise
      lcLength = [verylong]
  Endcase
  lcURL = Textmerge([https://loripsum.net/api/<<Int(m.tnParagraphs)>>/plaintext/<<m.lcLength>>])
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
  lsAgent = [VPF 5.0]

  lhInternetSession = InternetOpen( m.lsAgent, INTERNET_OPEN_TYPE_PRECONFIG, ;
      [], [], SYNCHRONOUS)

  * debugging line - uncomment to see session handle
  * WAIT WINDOW "Internet session handle: " + LTRIM(STR(hInternetSession))

  If m.lhInternetSession = 0
    Wait Window [Internet session cannot be established] Time 2
    Return .Null.
  Endif

  lhUrlFile = InternetOpenUrl( m.lhInternetSession, m.tcUrlName, [], 0, ;
      INTERNET_FLAG_RELOAD, 0)

  * debugging line - uncomment to see URL handle
  * WAIT WINDOW "URL Handle: " + LTRIM(STR(hUrlFile))

  If m.lhUrlFile = 0
    Wait Window [URL cannot be opened] Timeout 5
    Return .Null.
  Endif

  lcRetVal = []
  llOk = .T.

  Do While m.llOk
    * set aside a big buffer
    lsReadBuffer = Space(32767)
    lnBytesRead = 0
    lnOK = InternetReadFile( m.lhUrlFile, @m.lsReadBuffer, Len(m.lsReadBuffer), @m.lnBytesRead)

    If ( m.lnBytesRead > 0 )
      lcRetVal = m.lcRetVal + Left( m.lsReadBuffer, m.lnBytesRead )
    Endif

    * error trap - either a read failure or read past eof()
    llOk = ( m.lnOK = 1 ) And ( m.lnBytesRead > 0 )
  Enddo

  * close all the handles we opened
  InternetCloseHandle( m.lhUrlFile )
  InternetCloseHandle( m.lhInternetSession )

  * return the URL contents
  Return m.lcRetVal
Endfunc

*********************************************************************************
Function CreateNo
  Lparameters tcVariable, tcClassFilter
  #Define crlf Chr(13) + Chr(10)
  #Define DisplayCase && Lower && Legal values: lower, upper, proper or leave blank
  #Define Stripextension 'BIZ,$$$'
  #Define ccCursor 'CurObjects'
  Local lcText, lnX
  tcVariable = Evl(m.tcVariable, [*])
  tcClassFilter = Evl(m.tcClassFilter, [f*])
  Local lcClass As String, ;
    lcClassFilter As String, ;
    lcClassInfo As String, ;
    lcClassLib As String, ;
    lcExact As String, ;
    lcNewText As String, ;
    lcPasteText As String, ;
    lcPrefix As String, ;
    lcVariable As String, ;
    llClipboard As Boolean, ;
    llCommandWindow As Boolean, ;
    llFullpath As Boolean, ;
    llMethod As Boolean, ;
    llPartOfClass As Boolean, ;
    llPartOfClasslib As Boolean, ;
    llRefresh As Boolean, ;
    lnClasses As Number, ;
    lnHits As Number, ;
    lnI As Number, ;
    loContextMenu As Object, ;
    loEditorWin As Object
  If Pcount() = 1
    tcClassFilter = Getwordnum(m.tcVariable, 2, [= ])
    tcVariable = Getwordnum(m.tcVariable, 1, [= ] )
  Endif
  If Empty(m.tcClassFilter)
    tcClassFilter = m.tcVariable
    tcVariable = []
  Endif
  Private llNoProject
  llFullpath = .F. && .T. will include the full path to the classlib also if a project is active
  llPartOfClass = [*] $ m.tcClassFilter
  llRefresh = [!] $ m.tcClassFilter
  llPartOfClasslib = [+] $ m.tcClassFilter
  llClipboard = [-] $ m.tcClassFilter
  lcClassFilter = Chrtran(m.tcClassFilter, [*!+-], [])
  llMethod = [.] $ m.tcVariable
  If m.llMethod
    lcPrefix = Getwordnum(m.tcVariable, 1, [.])
    lcVariable = Getwordnum(m.tcVariable, 2, [.])
  Else
    lcPrefix = []
    lcVariable = m.tcVariable
  Endif
  loEditorWin = Execscript (_Screen.cThorDispatcher, [class= editorwin from pemeditor])
  llCommandWindow = m.loEditorWin.FindWindow() = 0
  Do Case
    Case m.llMethod And Len(m.lcClassFilter) = 0
      Messagebox([Illegal input!], 0, [], 5000)
      Return
  Endcase
  lcExact = Set([Exact])
  Set Exact Off
  llNoProject = Type([_vfp.activeproject.name]) = [U] Or Empty(_vfp.ActiveProject.Name)
  lcNewText = []
  Do Case
    Case m.llNoProject
      readClassLibs()
    Case m.llRefresh Or !Pemstatus(_vfp, [noClasses], 5) Or Empty(_vfp.noClasses);
        Or !Pemstatus(_vfp, [noLenClasses], 5) Or _vfp.noLenClasses = 1
      lnClasses = readClassLibs()
    Otherwise
      lnClasses = _vfp.noLenClasses
  Endcase
  lcClassFilter = Lower(m.lcClassFilter)
  Do Case
    Case Type([_vfp.activeproject.name]) = [U] And !Pemstatus(_vfp, [noProject], 5)
      AddProperty(_vfp, [noProject], [])
    Case !Pemstatus(_vfp, [noProject], 5)
      AddProperty(_vfp, [noProject], _vfp.ActiveProject.Name)
  Endcase
  Do Case
    Case m.llNoProject
      _vfp.Noproject = []
      lnClasses = readClassLibs()
    Case m.llRefresh
      If Type([_vfp.activeproject.name]) = [C]
        _vfp.Noproject = _vfp.ActiveProject.Name
      Endif
      Do readClassLibs
    Case Type([_vfp.activeproject.name]) # [U] And !_vfp.Noproject == _vfp.ActiveProject.Name
      _vfp.Noproject = _vfp.ActiveProject.Name
      Do readClassLibs
  Endcase
  If m.lnClasses > 1
    Create Cursor (ccCursor) (Classname c(50), LibName c(240), Classinfo c(254) )
    Index On LibName Tag LibName
    Index On Classname Tag Classname
    lnHits = 0
    For lnI = 1 To _vfp.noLenClasses
      lcClassLib  = _vfp.noClasses(m.lnI, 2)
      lcClass     = _vfp.noClasses(m.lnI, 1)
      Do Case
        Case m.llPartOfClass And Len(m.lcClassFilter) > 0 And m.lcClassFilter $ Lower(m.lcClass)
        Case m.llPartOfClasslib And Len(m.lcClassFilter) > 0 And;
            (m.lcClassFilter $ Lower(m.lcClass) Or m.lcClassFilter $ Lower(m.lcClassLib))
        Case Len(m.lcClassFilter) > 0 And m.lcClass = Lower(m.lcClassFilter)
        Case m.tcClassFilter == [*]
        Otherwise
          Loop
      Endcase
      lnHits = m.lnHits + 1
      If m.llFullpath
        lcClassInfo = ShowCase(m.lcClass) + [|] + ShowCase(Sys(2014, m.lcClassLib, Curdir()))
      Else
        lcClassInfo = ShowCase(m.lcClass) + [|] + ShowCase(m.lcClassLib)
      Endif
      Insert Into (ccCursor) (Classname, LibName, Classinfo) Values (ShowCase(m.lcClass), ShowCase(Sys(2014, m.lcClassLib)), m.lcClassInfo )
    Endfor
    Go Top
    If Reccount() = 0
      Wait Window [No match found] At 10, 25 Timeout 2
      Return
    Endif
    lcClassInfo =  GetDataFromGrid([Pick a class], [Classinfo], 1)
    *      Lparameters tcCaption, tcReturnField, tnHideColumns, tlModeless
    If Empty(m.lcClassInfo)
      Return
    Endif
    *!*      messagebox( m.lcClassInfo)
    *!*      Return 
    *!*      Browse Normal
    If m.lnHits > 0
      lcClassInfo = Alltrim(Evaluate(ccCursor + [.ClassInfo]))
      *!*        lcClass  = Alltrim(Evaluate(ccCursor + [.Classname]))
      *!*        lcClassLib = Alltrim(Evaluate(ccCursor + [.Libname]))
      lcClass  = Getwordnum (m.lcClassInfo, 1, [|])
      lcClassLib     = Getwordnum (m.lcClassInfo, 2, [|])

      loEditorWin = Execscript (_Screen.cThorDispatcher, [Class= editorwin from pemeditor])
      lcPasteText = []
      If Empty(m.lcVariable)
        lcVariable = [lo] + Proper(Juststem(m.lcClass))
        For lnX = 1 To Getwordcount(Stripextension, [,])
          lcText = Getwordnum(Stripextension, m.lnX, [,])
          If Lower(Right(m.lcVariable, Len(m.lcText))) == Lower(m.lcText)
            lcVariable = Left(m.lcVariable, Len(m.lcVariable) - Len(m.lcText))
            Exit
          Endif
        Endfor

      Endif
      If m.llMethod
        If m.llFullpath &&Or llNoProject
          lcPasteText = m.lcPrefix + [.NewObject('] + m.lcVariable + [','] + Juststem(m.lcClass) + [', '] + Alltrim(m.lcClassLib) + [')]
        Else
          lcPasteText = m.lcPrefix + [.NewObject('] + m.lcVariable + [','] + Juststem(m.lcClass) + [', '] + Justfname (m.lcClassLib) + [')]
        Endif
      Else
        If m.llFullpath &&Or llNoProject
          If !m.llCommandWindow
            lcPasteText = [Local ] + m.lcVariable + [ as ] + m.lcClass + [ of ] + Alltrim(m.lcClassLib) + crlf
          Endif
          lcPasteText = m.lcPasteText + m.lcVariable + [ = NewObject('] + Juststem(m.lcClass) + [', '] + Alltrim(m.lcClassLib) + [')]
        Else
          If m.llCommandWindow
            lcPasteText = m.lcPasteText + m.lcVariable + [ = NewObject('] + Juststem(m.lcClass) + [', '] + m.lcClassLib + [')]
          Else
            lcPasteText = [Local ] + m.lcVariable + [ as ] + m.lcClass + [ of ] + Justfname (m.lcClassLib) + crlf
            lcPasteText = m.lcPasteText + m.lcVariable + [ = NewObject('] + Juststem(m.lcClass) + [', '] + Justfname (m.lcClassLib) + [')]
          Endif
        Endif
      Endif
      If m.llClipboard
        _Cliptext = Iif(Empty(m.lcPrefix), m.lcVariable, m.lcPrefix + [.] + m.lcVariable)
      Endif
      If !m.llCommandWindow
        lcPasteText = m.lcPasteText + crlf
      Endif
      m.loEditorWin.Paste (m.lcPasteText)

    Else
      Messagebox([No match found!], 0 + 48, [], 5000)
    Endif
  Else
  Endif
  If m.lcExact = [ON]
    Set Exact On
  Endif
  Return
Endfunc
***************************************************************************************************
Function readClassLibs



  Local laClasses[1], laDummy[1], lcClass, lcFile, lnClasses, lnI, lnReturn, lnSelect, lnX, loList
  Local loTools, lx

  lnReturn = 0
  If llNoProject && No active project, use MRU
    loTools = Execscript (_Screen.cThorDispatcher, [Class= tools from pemeditor])
    loList = m.loTools.GetMRUList([VCX])
    lnSelect = Select()
    Select 0
    Create Cursor curClassLib (Class c(50), Classlib c(100))
    Index On Upper(Classlib) Tag Classlib
    Index On Upper(Class) Tag Class
    For Each m.lcClass In m.loList
      Try
        lcFile = Getwordnum(m.lcClass, 1, [|])
        If Adir(laDummy, m.lcFile) > 0
          lnClasses = Avcxclasses(laClasses, M.lcFile)
          For lnI = 1 To M.lnClasses
            Insert Into curClassLib (Class, Classlib);
              Values (m.laClasses[m.lni, 1], Lower(M.lcFile))
          Endfor
        Endif

      Catch
      Endtry
    Endfor
    Select Distinct Class, Classlib From curClassLib Order By 2, 1 Into Cursor curClassLib Readwrite
    If _Tally > 0
      AddProperty(_vfp, [noClasses(] + Transform(_Tally) + [,2)], .F.)
      AddProperty(_vfp, [noLenClasses], _Tally)
      lnReturn = _Tally
      lnX = 1
      Scan
        Store ShowCase(Trim(curClassLib.Class)) To ([_vfp.noClasses(] + Transform(m.lnX) + [,1)])
        Store ShowCase(curClassLib.Classlib) To ([_vfp.noClasses(] + Transform(m.lnX) + [,2)])
        lnX = m.lnX + 1
      Endscan
    Endif


  Else
    loTools = Execscript (_Screen.cThorDispatcher, [class= tools from pemeditor])
    lx = m.loTools.GetClasslist(, , .T., .F., .T., .F.)
    If Alen(m.lx.List) > 1
      AddProperty(_vfp, [noClasses(] + Transform(Alen(m.lx.List, 1)) + [,2)], .F.)
      AddProperty(_vfp, [noLenClasses], Alen(m.lx.List, 1))
      For lnX = 1 To Alen(m.lx.List, 1)
        Store ShowCase(m.lx.List(m.lnX, 1)) To ([_vfp.noClasses(] + Transform(m.lnX) + [,1)])
        Store ShowCase(Justfname(m.lx.List(m.lnX, 2))) To ([_vfp.noClasses(] + Transform(m.lnX) + [,2)])
      Endfor
      lnReturn = Alen(m.lx.List, 1)
    Endif Alen(m.lx.List) > 1
  Endif

  Return m.lnReturn
Endfunc
***************************************************************************************************
Function ShowCase
  Lparameters lcText
  Return Trim(DisplayCase(m.lcText))
Endfunc

***************************************************************************************************

Function findValueInString
  Lparameters tcText
  Local lnReturn, lnX

  lnReturn = 0
  For lnX = 1 To Len(Trim(m.tcText))
    If Val(Substr(m.tcText, m.lnX, 1)) > 0
      lnReturn = Val(Substr(m.tcText, m.lnX))
      Exit
    Endif
  Endfor
  Return Int(m.lnReturn)
Endfunc
*********************************************************************************

Function CreateCommentLine

  Lparameters tcCommand

  Local lcReturn, lcString, lcX, lnMax, lnX
  lnX = findValueInString(m.tcCommand)
  lnMax = 250
  lcX = Transform(m.lnX)
  lcString = Left(m.tcCommand, At(Transform(m.lnX), m.tcCommand) - 1)
  lnX = Min(m.lnX, m.lnMax )
  Do Case
    Case Len(m.lcString) > 2 And Right(m.lcString, 1) = [*]
      lcString = Substr(m.tcCommand, 2, Len(m.lcString) - 2)
      lcReturn = [*] + Replicate(m.lcString, Int( (m.lnX - 2) / Len(m.lcString))) + [*]
    Case Len(m.lcString) = 2 And [:] $ m.lcString
      lcReturn = Replicate([her], m.lnX)
    Otherwise
      lcReturn = Replicate(m.lcString, Min(m.lnX / Len(m.lcString), m.lnMax ))
  Endcase
  ReplaceCurrentLine(m.lcReturn)

Endfunc

*********************************************************************************

Function CreatePandoraCursor
  Lparameters tnWindowType

  Local lcProg, lcWindow, lnSelect
  Local lcAsk, lcDesc, lcShort, lcTrigger


  tnWindowType = Evl(m.tnWindowType, 0)
  Local laPandoraChoices[1], lcPandoraOptions, lnLines, lnX
  lnSelect = Select()
  Text To m.lcPandoraOptions Noshow Textmerge Pretext 7
      Dir    | *: | Picklist of all VFP files in the path, edit        | ef  |    |
      Dir    | *  | Picklist of all VFP files in the path, edit        | c   |    |
      *x     |    | Repeats * x times                                  | ef  |    |
      DirX   | **:| Picklist of VFP files with more information, edit  |  ef |    |
      DirX   | +, ** | Picklist of VFP files with more information, edit  |  c  |    |
      DirRun |***:| Picklist of VFP files with more information, run   |  ef |    |
      DirRun | ++, *** | Picklist of VFP files with more information, run   | c   |    |
      Desc   | De | Picklist of prg files with a description           | c   |    |
      Desc   | De | Adds "* Description *" template to the active file | ef  |    |
      <blank>|    | Default items in active .pan file opened or run    |  c  |    |
      <blank>|    | Menu                                               | ef  |    |
      0      |    | Opens active .pan file for editing                 | c   |    |
      0 *    |    | Picklist of Pandora files in the path              | c   |    |
      0 filename|    | Makes filename.pan the active Pandora file          | c   |    | 
      x (x=number)|    | Items in group x are opened or run                 | c   |    |           
      Lorem  | Lor| Random "Lorem Ipsum" text generator                | cef |    |
      Menu   | ?  | Menu                                               | ef  |    |
      Project|pr, -| Picklist of projects in active .pan file           | c   |    |
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
      Version| ver| Shows Pandora version number                       | cef |    |
      Hotkeys| hk | Picklist of all assigned hot keys                  | cef |    |
      Ed     |    | Easy way to open most files                        | cef | Filename or URL: |
      Ec     |    | The content of the clipboard is executed           | cef |    |
      ? memvar |    | Returns ?'memvar',mvar                               | cef |    |
      Db memvar|    | Returns DebugOut 'memvar',mvar                     | cef |    |

  Endtext
  Create Cursor curPandora (Trigger c(12), Short c(10), Descript c(50),  Window c(2), ask c(25))
  lnLines = Alines(laPandoraChoices, m.lcPandoraOptions)
  For lnX = 1 To m.lnLines
    lcWindow = Alltrim(Getwordnum( m.laPandoraChoices(m.lnX), 4, [|]))
    Do Case
      Case m.tnWindowType = 0 And [c] $ m.lcWindow && Command window
      Case m.tnWindowType > 0 And [e] $ m.lcWindow && Modify window/file
      Case m.tnWindowType >= 10 And [f] $ m.lcWindow && Form or class window
      Otherwise
        Loop
    Endcase
    lcTrigger = Alltrim(Getwordnum( m.laPandoraChoices(m.lnX), 1, [|]))
    lcShort = Alltrim(Getwordnum( m.laPandoraChoices(m.lnX), 2, [|]))
    lcDesc = Alltrim(Getwordnum( m.laPandoraChoices(m.lnX), 3, [|]))
    lcAsk = Alltrim(Getwordnum( m.laPandoraChoices(m.lnX), 5, [|]))
    Insert Into curPandora (Trigger, Short, Descript, ask) Values (m.lcTrigger, m.lcShort, m.lcDesc, m.lcAsk)
  Endfor
  Select Trigger, Short, Descript, ask From curPandora Into Cursor curPandora Readwrite
  Index On Lower(Descript) Tag Descript
  Index On Lower(Short) Tag Short
  Index On Trigger Tag Trigger
  lcProg = GetDataFromGrid([Pandora "commands"], [trigger], 1)
  lcAsk = []
  If !Empty(m.lcProg)
    Select ask From curPandora Where Alltrim(m.lcProg) = Alltrim(Trigger) Into Cursor curPandora
    lcAsk = ask
  Endif
  Use
  Select (m.lnSelect)
  If !Empty(m.lcProg)
    Do Case
      Case m.lcProg = [<blank>]
        lcProg = [ed]
      Case !Empty(m.lcAsk)
        lcProg = m.lcProg + [ ] + Inputbox(m.lcAsk, [Value is required!])
      Case Inlist(Lower(m.lcProg), [pan], [paned], [eval])
        lcProg = m.lcProg + [ ] + Inputbox([Name of file:], [Empty gives picklist])
    Endcase
    If _Screen.lPanComment
      lcProg = [*] + m.lcProg
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
      tcParameter = Substr(m.tcCommand, 2)
    Endif
  Endif
  If !Empty(m.tcParameter)
    tcParameter = [_] + m.tcParameter
  Endif
  Modify Command Forceext([pandoratestarea] + m.tcParameter, [prg]) Nowait
Endfunc
