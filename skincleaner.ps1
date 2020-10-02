param ($dir)

Copy-Item -Path "$dir\*" -Destination "./" -Recurse
Get-ChildItem "*.psd" -Recurse | ForEach-Object {
  Remove-Item -Path "$_"
}

Get-ChildItem -Directory | Foreach-Object {
  $skinpath = $_.FullName
  Compress-Archive -Path "$skinpath\*" -DestinationPath "$skinpath.zip"
  Rename-Item -Path "$skinpath.zip" -NewName "$skinpath.osk"
}
