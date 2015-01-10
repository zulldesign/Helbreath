<%@ Page Language="vb" Debug=true ValidateRequest=false %>
<%@ Import Namespace="System" %>
<%@ Import Namespace="System.IO" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<!-- #INCLUDE FILE="include.aspx" -->
<!-- #INCLUDE FILE="menu.aspx" -->
<html>
<head>
<title>File Manager</title>
<script runat="server" language="vb">
Sub Page_Load(sender As Object, e As EventArgs)
	if session("loggedin") = "" then
		response.redirect("login.aspx")
	end if
	show_files()
End Sub

Sub Show_files
	Dim file As String
    Me.ListBox1.Items.Clear()
    Dim files() As String = Directory.GetFiles(uploadpath)
    For Each file In files
        Me.ListBox1.Items.Add(FileNameWithoutExtension(file))
    Next
End Sub

sub updatelist_Click(Sender as Object, e as EventArgs)
	show_files()
end sub

sub del_Click(Sender as Object, e as EventArgs)
	uploaddetails.visible = false
	dim deletefile as string = request.form("listbox1")
	if deletefile <> "" then
		deletefile = uploadpath & deletefile
		File.Delete(deletefile)
	else
		nofile.visible = true
		nofile.InnerHtml = "No file was selected to delete."
    	Span1.visible = false
	end if
	show_files
end sub

Sub Upload_Click(Sender as Object, e as EventArgs)

  FileName.InnerHtml = MyFile.PostedFile.FileName
  FileContent.InnerHtml = MyFile.PostedFile.ContentType 
  FileSize.InnerHtml = MyFile.PostedFile.ContentLength
  UploadDetails.visible = True

  Dim strFileName as string = MyFile.PostedFile.FileName
  Dim c as string = System.IO.Path.GetFileName(strFileName)
  c = REPLACE(c," ","_")
  
	if strFileName <> "" then
    	MyFile.PostedFile.SaveAs(uploadpath + c)
	else
		nofile.visible = false
		Span1.visible = true
		Span1.InnerHtml = "No file was selected to upload."
	end if
  	show_files()
End Sub

Public Function FileNameWithoutExtension(ByVal FullPath As String) As String
	Return System.IO.Path.GetFileName(FullPath)
End Function
</script>
<head>
<body style="font-family: Arial, Helvetica, sans-serif;">
<h3>Basic CMS - File Management</h3>
<hr width="50%" style="text-align: left;">
<Form Method="Post" EncType="Multipart/Form-Data" RunAt="Server">
<h3>File Upload </h3>
  <Input ID="MyFile" Type="File" RunAt="Server" Size="40">
<p>Click browse, choose file, then click upload</p>
  <Input Type="Submit" Value="Upload" OnServerclick="Upload_Click" RunAt="Server">
  <P><Div ID="UploadDetails" Visible="False" RunAt="Server">
  File Name: <Span ID="FileName" RunAt="Server"/>
  <BR>File Content: <Span ID="FileContent" RunAt="Server"/>
  <BR>File Size: <Span ID="FileSize" RunAt="Server"/> bytes
  <BR></Div> <Span ID="Span1" Style="Color:Red" RunAt="Server"/>
</p>
<hr width="50%" style="text-align: left;">
<h3>File Listing</h3>

<p><asp:ListBox Id="listbox1" RunAt="server" Width="250" Rows="5" /></p>

<p>Select file and click delete to remove</p>
<input type="submit" name="del" value="Delete" OnServerclick="del_Click" RunAt="Server">
<input type="submit" name="refresh" value="refresh list" OnServerclick="updatelist_Click" RunAt="Server">
</Form>
<Span ID="nofile" Style="Color:Red" RunAt="Server"/>
<hr width="50%" style="text-align: left;">

<p><a href="upload.aspx">Refresh Page</a></p>

</Body> </html>