*** Don't make any changes in this file since it will be overwritten with version updates!
*** To change any values, create a separate file called pandora_override.h in the same folder.
*** For changes in pandora_override.h, create two entries. The first must first #undefine and
*** then make a new #define. 
*** Se the bottom of this file for samples.

#DEFINE VERSION_NUMBER "Pandora V 1.10 : 2024-12-18"

*** Timeout in seconds for Wait Windows
#Define ccWaitTimeout 3

*** Maximum lineno where the description will be in a prg. Higher number means slower progress
#Define ccMaxDescriptLine 15

*** Defines if the editsource() builder will create full or relative path
#Define ccRelativePath .F.

*** Defines the name of the file to read "comment snippets" from
#Define ccPandoraComments 'PanComments.prg' 

*** Defines the name of the default "Pandora project definition" file
#Define ccPandoraFile 'Pandora.pan'

*** Defines the name of the file which contains the name of the current "Pandora project definition" file 
#Define ccPandoraDef 'Pandora.txt'

*** Defines the "command" to tell Pandora to execute/run a file instead of opening in Pandora projects
#Define ccRun 'exe'

*** List of file types to read as VFP and Pandora files
#Define ccVFPFilesToList [dbf], [scx], [vcx], [prg], [h], [dbc], [frx], [lbx], [mnx], [txt], [pan]

*** List of file extensions to read extended data from
#Define ccVFPTablesExtended [dbf], [dbc], [frx], [lbx], [mnx], [pjx], [scx], [vcx]

#IF FILE("pandora_override.h")
	#INCLUDE pandora_override.h
#ENDIF
*!* pandora_override.h would contain (for example):
*!* #undefine ccWaitTimeout
*!* #Define ccWaitTimeout 1
*!* #Undefine ccRelativePath 
*!* #Define ccRelativePath .T.
