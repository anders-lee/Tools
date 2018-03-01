function Split-LargeFile([string] $sourceFilePath, [int] $batchSize)
{
    $reader = new-object System.IO.StreamReader($sourceFilePath)
    $fileIndex = 1
    $rootName = [System.IO.Path]::GetFileNameWithoutExtension($sourceFilePath)
    $ext = [System.IO.Path]::GetExtension($sourceFilePath)
    $fileName = "{0}{1}{2}" -f ($rootName, $fileIndex, $ext)

    $lineCount = 0
    while(($line = $reader.ReadLine()) -ne $null)
    {
        Add-Content -path $fileName -value $line
        ++$lineCount
        if($lineCount -ge $batchSize)
        {
            ++$fileIndex
            $fileName = "{0}{1}{2}" -f ($rootName, $fileIndex, $ext)
            $lineCount = 0
        }
    }

    $reader.Close()
}

Split-LargeFile -sourceFilePath $args[0] -batchSize $args[1]
