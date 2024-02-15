$target = $args[0]
$keywords = $args[1..($args.Length - 1)]

$searchTerm = ($keywords | ForEach-Object { "/C:$_" }) -join " "

$build_path = ".\Assembly_Knowledge_Sharing\Examples\$target\$target.dir\Debug"
Get-ChildItem -Path $build_path -Filter *.obj -Recurse -File -Name | ForEach-Object {
    $obj_file = $_.replace("src\", "")
    Write-Output "======= $obj_file ======="
    $command = "dumpbin /symbols $build_path\$obj_file | findstr /i $searchTerm | findstr /i /v unwind"
    Invoke-Expression $command
    Write-Output ""
}