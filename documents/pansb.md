[![Pandora](Images/pandora2.png)](https://github.com/tbleken/Pandora)
## SuperBrowse 
**Pandora** can call [SuperBrowse](https://github.com/VFPX/Thor/blob/master/Docs/Thor_superbrowse.md) directly.  

Place the cursor "inside" a table name and press `F8`. **Pandora** will use several tools to try to locate the table, and open it in `SuperBrowse`.  

Note that there are cases where you need to highlight the table name before you press `F8`. The reason is that although **Pandora** is smart, it can't read your mind. :-) It doesn't know whether you want to use the tool `Execute Selected Text` or `SuperBrowse.` So if the line/statement starts with a keyword like `Select`, `Use` or other words that makes the line/statement executable, it will be executed.

![](Images/Thor_Super_Browse_SNAGHTML8410e4d.png?raw=true)
