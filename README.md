
[![How Pandora works](documents/Images/pandora2.png)](documents/panhow.md)

Version 1.05 Released 2024-09-18

[What's new in this release](Change%20Log.md)

***
![Pandora](documents/Images/pandora2.png) is a collection of powerful VFP add-on tools that are launched via command line syntax followed by pressing a hotkey.

In this documentation `F8` is used as this hotkey, for consistency. It can easily be changed by using one of [Thor's](https://github.com/VFPX/Thor) tools.

Some of these programmers' tools are unique to `Pandora`, while others provide access to existing Thor tools.  
This is a list of all the "commands" that `Pandora` supports, along with a short description. Click the text for details.

**Note:** Some "commands" also have a shorter version, you can see them in the second column. And all `Pandora` commands are case insensitive.

These "commands" work in **all** of VFP's code editors, including the command window:

|Command |Short version| Result after pressing `Pandora` hotkey, e.g. `F8`|
|:--|:--  |:-------------|
|[. (dot)](documents/panta.md)|[, (comma)](documents/panta.md)| [Easily accessible "test area"](documents/panta.md)|
|[Description](documents/pandesc.md)|[Desc](documents/pandesc.md)| [List of all prg's which have a description](documents/pandesc.md)|
|[Dir](documents/pandir.md)  |\*:| [List all VFP files in the path](documents/pandir.md)|
|[DirX](documents/pandir.md#dirc)  |[\*\*:](documents/pandir.md#dirc)| [Same as above, more info in the table](documents/pandir.md#dirc)|
|[Ed](documents/paned.md)|| [An easy way to open most files](documents/paned.md)|
|[Fp](documents/panfp.md)|| [Field picker to create SQL statements](documents/panfp.md)|
|[Hotkeys](documents/panhk.md) |[Hk](documents/panhk.md) |[List of all assigned hot keys](documents/panhk.md)|
|[Lorem](documents/panrt.md) || [Generate random "Lorem Ipsum" text](documents/panrt.md)|
|[NO <sub>Note 1</sub>](documents/panno.md)     || [NewObject() syntax builder](documents/panno.md)|
|[Pan](documents/panext.md) |[!](documents/panext.md)| [Create and run your own `Pandora` extensions](documents/panext.md)|
|[Paned](documents/panext.md#paned) |[!!](documents/panext.md#paned)| [Edit your own `Pandora` extensions](documents/panext.md#paned)|
|[Project](documents/panorg.md#proj) |[Pr, Proj](documents/panorg.md#proj)| [List of projects in active .pan file](documents/panorg.md#proj)|
|[RT](documents/panrt.md) || [Generate random readable text](documents/panrt.md)|
|[Test](documents/panta.md)|[ta](documents/panta.md)| [Easily accessible "test area"](documents/panta.md)|
|[Thor](documents/panth.md) |[Th, Tools](documents/panth.md)| [Picklist of registered **Thor** tools](documents/panth.md)|
|Version |Ver| Shows `Pandora` version number|

**Note 1:** `NO` behaves somewhat differently in the Command Window than in VFP's editors.

In addition to the "commands" listed above, these work **only** in the **Command Window:**

|Command |Short| Result after pressing `Pandora` hotkey, e.g. `F8`|
|:--|:--  |:-------------|
|[-blank-](documents/panorg.md)  || [Opens default files listed in active .pan file](documents/panorg.md)|
|[0 (zero)](documents/panorg.md) || [Opens active .pan file for editing](documents/panorg.md)|
|[Dir](documents/pandir.md)  |[*](documents/pandir.md)| [List all VFP files in the path](documents/pandir.md)|
|[DirX](documents/pandir.md#dirc)  |[**](documents/pandir.md#dirc)| [Same as above, more info in the table](documents/pandir.md#dirc)|
|Help ||This document|

Likewise, these "commands" **only** work in VFP's code editors (**Modify Command, Form or Class designer**):

|Command |Short| Result after pressing `Pandora` hotkey, e.g. `F8`|
|:--|:--  |:-------------|
|[-na-](documents/panrc.md)  || [Run the code where your cursor is](documents/panrc.md)|
|[-blank-](documents/panmnu.md)  || [Menu of relevant Pandora options](documents/panmnu.md)|
|[DD <sub>Note 2</sub>](documents/pandd.md)     || [DoDefault() syntax builder](documents/pandd.md)|
|[Eval](documents/paneval.md)|[=](documents/paneval.md)| [Insert returned value from a function](documents/paneval.md)|
|[Inc](documents/paninc.md)|| [Insert #Include statement](documents/paninc.md)|
|[Insert](documents/panins.md) |[+, Ins](documents/panins.md)| [Insert contents from a prg](documents/panins.md)|
|[Menu](documents/panmnu.md)  |[?](documents/panmnu.md)| [Menu of relevant `Pandora` options](documents/panmnu.md)|

**Note 2:** `DD` only works in VFP's **Form or Class Designer**, and **not** in *Modify Command*.

**-na-** means special handling, see [documentation](documents/panrc.md) for details.

-----------------------

## `Pandora` "Project Organizer"

In addition to the features mentioned above, `Pandora` comes with an advanced "project organizer", [click here for details](documents/panorg.md).

----------------------  

## Installation
  
The easiest and only supported way to install `Pandora`, is to use Thor's Check For Update.

---------------------

#### [How does `Pandora` work? And an introduction to some of its features.](documents/panhow.md)

--------------

# More "extras" to follow, suggestions are welcomed
