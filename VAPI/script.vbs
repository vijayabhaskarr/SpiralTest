Sub Test_Main(Debug, CurrentTestSet, CurrentTSTest, CurrentRun)
  On Error Resume Next
  TDOutput.Clear
  dim classpath
  dim testname,ProjectName, testsetname
  dim RootDir ,resultpath,strAutoEnv
  ProjectName="VarProjectName"
  ResultDir="F:\Resources\Results\" & ProjectName
  RootDir= "C:\SpiralTest\"
  testname=CurrentTSTest.TestName
  testsetname=CurrentTestSet.Name
  crntid=CurrentRun.Name
  testname=Replace(testname, "[1]", "")
  strAutoEnv = CurrentTestSet.Field("CY_USER_05")
  TDOutput.Print "Starting the Test Execution of " & testname
  mycommand = RootDir & "SpiralSlientRunner.exe " & ProjectName & " " & testname & " "& testsetname & " "& strAutoEnv & " "
  TDOutput.Print "Starting " & mycommand
  result=XTools.run(mycommand,0,true)
  TDOutput.Print "Test ended with " & result
  Dim strTestStatus
  strTestStatus = "Passed"
  Set objFso = CreateObject("Scripting.FileSystemObject")
  Set objFile= objFSO.OpenTextFile("C:\SpiralResults.html", 1)
   Do While Not objFile.AtEndOfStream
     strLine = objFile.readline
     if (Instr(strLine,"<td>Failed</td>")>0)Then
     strTestStatus = "Failed"
     Else
     End if
   Loop
   If strTestStatus = "Passed" Then
       CurrentRun.Status = "Passed"
       CurrentTSTest.Status = "Passed"
   Else
       CurrentRun.Status = "Failed"
       CurrentTSTest.Status = "Failed"
   End If

   AttachFileToResults CurrentRun,"C:\SpiralResults.html"

  If Not Debug Then
  End If
  ' handle run-time errors
  If Err.Number <> 0 Then
    TDOutput.Print "Run-time error [" & Err.Number & "] : " & Err.Description
    ' update execution status in "Test" mode
    If Not Debug Then
      CurrentRun.Status = "Failed"
      CurrentTSTest.Status = "Failed"
    End If
  End If
   TDOutput.Print "Test ended with " & result
  End Sub


'This will upload the file to the test run attachments
function AttachFileToResults(objCurrentRun, strFilePath)
    Dim objAttachFactory, objAttachment
    Set objAttachFactory = objCurrentRun.Attachments
    Set objAttachment = objAttachFactory.AddItem(null)

    objAttachment.FileName = strFilePath
    objAttachment.Type = 1
    objAttachment.Post
    Set objAttachment = Nothing
    Set objAttachFactory = Nothing
End function

'Create the folder structure if not available
Function CreateResultDir(ResultDir)
     Dim objFSO
     Set objFSO = CreateObject("Scripting.FileSystemObject")
     if(not(objFSO.FolderExists(ResultDir)))then
                Set objShell = CreateObject("Wscript.Shell")
                objShell.Run "cmd /c mkdir " & ResultDir
         end if
     Set objFSO = nothing
End Function