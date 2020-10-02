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
    $filecount = (Get-ChildItem "$dir" -Directory | Measure-Object).count
    $counter = 0
    Write-Progress -Activity "Copying Folders" -Status "$p% Complete: " -PercentComplete ($counter / $filecount * 100)
    Get-ChildItem "$dir" -Directory | Foreach-Object {
      $fullpath = $_.FullName
      if (!(Test-Path -path "./$_/")) {New-Item "./$_/" -Type Directory | Out-Null}
      Copy-Item -Path "$fullpath\*" -Destination "./$_/" -Recurse
      $counter++
      $percent = [math]::Ceiling($counter / $filecount * 100)
      Write-Progress -Activity "Copying Folders" -Status "$percent% Complete: " -PercentComplete $percent
    }
  }
  else {
    Write-Error 'Path does not exist'
  }
}

function Remove-Psd {
  Get-ChildItem "*.psd" -Recurse | ForEach-Object {
    Remove-Item -Path "$_"
  }
}

function Main {
  param(
    $programArgs
  )
  $quiet = $programArgs.Contains('-q')
  if ($programArgs -contains '-copy') {
    Copy-Skins $quiet
  }
  elseif (-not $quiet) {
    $copyanswer = Read-Host 'Copy the skin folders? [Y/N]'
    if ($copyanswer.ToLower() -eq 'y') {
      Copy-Skins $dir
    } 
  }

  if ($programArgs -contains '-rpsd') {
    Remove-Psd
  } elseif (-not $quiet) {
    $psdanswer = Read-Host 'Remove all psd files from all folders in the current directory and any folders inside? [Y/N]'
    if ($psdanswer.ToLower() -eq 'y') {
      Remove-Psd
    }
  }

  if ($programArgs -contains '-osk') {
    Convert-Osk
  }
  elseif (-not $quiet) {
    $oskanswer = Read-Host 'Make osk files out of folders in the current directory? [Y/N]'
    if ($oskanswer.ToLower() -eq 'y') {
      Convert-Osk
    }
  }
}

Main $args