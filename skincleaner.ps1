
param($dir)

function Convert-Osk {
  Get-ChildItem -Directory | Foreach-Object {
    $skinpath = $_.FullName
    Compress-Archive -Path "$skinpath\*" -DestinationPath "$skinpath.zip"
    Rename-Item -Path "$skinpath.zip" -NewName "$skinpath.osk"
  }
}

function Copy-Skins {
  param(
    $quiet
  )
  if ($null -eq $dir) {
    if ($quiet) {
      Write-Error 'Path not passed: hint: -dir "path"'
      Return
    }
    else {
      $dir = Read-Host 'Enter the path you wish to copy'
    }
  }
  if (Test-Path $dir) {
    Copy-Item -Path "$dir\*" -Destination "./" -Recurse
    Get-ChildItem "*.psd" -Recurse | ForEach-Object {
      Remove-Item -Path "$_"
    }
  }
  else {
    Write-Error 'Path does not exist'
  }
}

$quiet = $args.Contains('-q')
if ($args -contains '-copy') {
  Copy-Skins $quiet
}
elseif (-not $quiet) {
  $copyanswer = Read-Host 'Copy the skin folders? [Y/N]'
  if ($copyanswer.ToLower() -eq 'y') {
    Copy-Skins $dir
  } 
}

if ($args -contains '-osk') {
  Convert-Osk
}
elseif (-not $quiet) {
  $oskanswer = Read-Host 'Make osk files out of folders in the current directory? [Y/N]'
  if ($oskanswer.ToLower() -eq 'y') {
    Convert-Osk
  }
}
