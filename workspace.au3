$Cores = 16
$AllCores = 0

For $i = 0 To $Cores - 1
	$AllCores += 2^$i
Next

ConsoleWrite($AllCores & @CRLF)