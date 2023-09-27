[![Pandora](Images/pandora2.png)]([../readme.md](https://github.com/tbleken/Pandora))

## Descriptions in your prgs

**Pandora** keyword: `Desc`

If your program files contains a description in one of the ten first lines, **Pandora** has tools to make your life easier. The description must match this format:  

`* Description: Some text *`

#### Syntax samples: 

| Window | You type:  | Resukt after pressing `F8`|
|-------|:----------|:----------------------|
| C | `Desc`           | You get a list of all prgs in your path which have a description|
| C | `Desc aaa` | List of files where the descriptions contains `aaa`|
| E | `Desc` | A `* Description *` template is added in the current line (line 10 or less)|


`C`: Command Window  
`E`: Any VFP editor, normally Modify Command 
