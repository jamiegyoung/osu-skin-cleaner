param($dir)

function Convert-Osk {
  Get-ChildItem -Directory | Foreach-Object {
    $skinPath = $_.FullName
    Compress-Archive -Path "$skinPath\*" -DestinationPath "$skinPath.zip"
    Rename-Item -Path "$skinPath.zip" -NewName "$skinPath.osk"
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
    $fileCount = (Get-ChildItem "$dir" -Directory | Measure-Object).count
    $counter = 0
    Write-Progress -Activity "Copying Folders" -Status "$p% Complete: " -PercentComplete ($counter / $fileCount * 100)
    Get-ChildItem "$dir" -Directory | Foreach-Object {
      $fullpath = $_.FullName
      if (!(Test-Path -path "./$_/")) {New-Item "./$_/" -Type Directory | Out-Null}
      Copy-Item -Path "$fullpath\*" -Destination "./$_/" -Recurse
      $counter++
      $percent = [math]::Ceiling($counter / $fileCount * 100)
      Write-Progress -Activity "Copying Folders" -Status "$percent% Complete: " -PercentComplete $percent
    }
    Write-Progress -Activity "Copying Folders" -Completed
  }
  else {
    Write-Error 'Path does not exist'
  }
}

function Remove-Psd {
  $totalPsds = (Get-ChildItem "*.psd" -Recurse | Measure-Object).Count
  $counter = 0
  Get-ChildItem "*.psd" -Recurse | ForEach-Object {
    Remove-Item -Path $_.FullName
    $counter++
    $percent = [math]::Ceiling($counter / $totalPsds * 100)
    Write-Progress -Activity "Deleting PSD files" -Status "$percent% Complete: " -PercentComplete $percent
  }
  Write-Progress -Activity "Deleting PSD files" -Completed
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
    $copyAnswer = Read-Host 'Copy the skin folders? [Y/N]'
    if ($copyAnswer.ToLower() -eq 'y') {
      Copy-Skins $dir
    } 
  }

  if ($programArgs -contains '-rpsd') {
    Remove-Psd
  } elseif (-not $quiet) {
    $psdAnswer = Read-Host 'Remove all psd files from all folders in the current directory and any folders inside? [Y/N]'
    if ($psdAnswer.ToLower() -eq 'y') {
      Remove-Psd
    }
  }

  if ($programArgs -contains '-osk') {
    Convert-Osk
  }
  elseif (-not $quiet) {
    $oskAnswer = Read-Host 'Make osk files out of folders in the current directory? [Y/N]'
    if ($oskAnswer.ToLower() -eq 'y') {
      Convert-Osk
    }
  }
}

Main $args