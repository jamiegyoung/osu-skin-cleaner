# osu-skin-cleaner

A simple script to copy osu! skins to the current directory, remove the psd files, and then put them in an osk format

Order of operations:

1. Copy
2. Remove PSD files
3. Convert to osk

Note: _passing parameters into the script in a different order will not affect the order of operations_

## Example Usage

`skincleaner.ps1 -dir "**Dir containing osu skins**"`

`skincleaner.ps1 -q -osk`

`skincleaner.ps1 -q -copy -dir "**Dir containing osu skins**" `

## Parameters

_All parameters are optional_
|Name|Description|Notes|
|----|-----------|-----|
|-dir |the directory to copy the skins from|requires a path to be passed `-dir 'C:\Skins'`|
|-copy|copies the folders||
|-rpsd|removes all psd files from all folders in the current directory||
|-osk |makes osks from folders in the current directory||
|-q |quiet mode, removes all prompts|`-dir` is required if `-q` and `-copy` are used|

Note: _if `-copy` or `-osk` is not paired with `-q` the user will be prompted for the other option._
