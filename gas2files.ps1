
[CmdletBinding()]
Param(
  [Parameter(Mandatory=$True,Position=1)]
   [string]$in,
  [Parameter(Mandatory=$False,Position=2)]
   [string]$destDir
)

function Get-Script-Directory
{
    $scriptInvocation = (Get-Variable MyInvocation -Scope 1).Value
    return Split-Path $scriptInvocation.MyCommand.Path
}


if ($destDir.Length -gt 0 -and !(Test-Path $destDir)) {
  Write-Output ('Error: Destination folder not accessible : ' + $destDir)
  Exit
}


if (!(Test-Path $in)) {
  Write-Output ('Error: Input file does not exit: ' + $in)
  Exit
}

$j = Get-Content $in | ConvertFrom-Json

Foreach ($f in $j.files) {

  $name = $f.name 
  if ($f.type -eq "server_js") {
    $name += ".js"
  } 
  elseif ($f.type -eq "html") { 
    $name += ".html"
  } 
  else {name += ".unknown"}

  if ($destDir.Length -gt 0) {$name = "$destDir\$name"}

  Write-Output "Saving: $name"
  $f.source | Out-File $name


}
