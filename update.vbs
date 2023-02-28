Set objShell = CreateObject("WScript.Shell")

' Set up log file
Set objFSO = CreateObject("Scripting.FileSystemObject")
Set objLogFile = objFSO.OpenTextFile("log.txt", 8, True)
objLogFile.WriteLine "Script launched on " & Now()

' Read configuration information from config file
If objFSO.FileExists("config.txt") Then
    Set objFile = objFSO.OpenTextFile("config.txt", 1)
    numFolders = objFile.ReadLine()
    ReDim folderLocations(numFolders - 1)
    For i = 0 To numFolders - 1
        folderLocations(i) = objFile.ReadLine()
    Next
    objFile.Close
Else
    ' If config file does not exist, prompt user for input and save to file
    numFolders = InputBox("How many master GitHub folders do you want to update?")
    ReDim folderLocations(numFolders - 1)
    For i = 0 To numFolders - 1
        folderLocations(i) = InputBox("Enter the location of master GitHub folder #" & (i + 1))
    Next
    Set objFile = objFSO.CreateTextFile("config.txt", True)
    objFile.WriteLine(numFolders)
    For i = 0 To numFolders - 1
        objFile.WriteLine(folderLocations(i))
    Next
    objFile.Close
End If

' Check for command line argument to update config file
Set objArgs = WScript.Arguments
If objArgs.Named.Exists("c") Or objArgs.Named.Exists("config") Then
    numFolders = InputBox("How many master GitHub folders do you want to update?")
    ReDim folderLocations(numFolders - 1)
    For i = 0 To numFolders - 1
        folderLocations(i) = InputBox("Enter the location of master GitHub folder #" & (i + 1))
    Next
    Set objFile = objFSO.CreateTextFile("config.txt", False)
    objFile.WriteLine(numFolders)
    For i = 0 To numFolders - 1
        objFile.WriteLine(folderLocations(i))
    Next
    objFile.Close
End If

' Loop through all directories under the specified master GitHub folders
For Each folderLocation in folderLocations
    Set objFolder = objFSO.GetFolder(objShell.ExpandEnvironmentStrings(folderLocation))
    For Each subFolder in objFolder.SubFolders
        ' Change current directory to the subfolder
        objShell.CurrentDirectory = subFolder.Path

        ' Run "git pull" and record output to log file
        objShell.Run "cmd /c git pull", 0, True
        objLogFile.WriteLine(Now() & " - Updated repository " & subFolder.Path)

    Next
Next


' Close log file
objLogFile.Close

' Notify user that the script has completed
MsgBox "All repositories have been updated.", vbInformation, "GitHub Update Script"
