<%@ Page Language="vb" Debug=true %>
<%@ import Namespace="System.Data.OLEDB" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Page List</title>
<style>
	.myfont {
		background-color : White;
		font-family : Arial, Helvetica, sans-serif;
	}
</style>
<!-- #INCLUDE FILE="include.aspx" -->
<!-- #INCLUDE FILE="menu.aspx" -->
<script runat="server" language="vb">
	Sub btnHelp_OnClick(Src As Object, E As EventArgs)
		lblhelp.visible = true
	End Sub

    Sub Page_Load(sender As Object, e As EventArgs)
	lblhelp.Visible = False
	if session("loggedin") = "" then
		response.redirect("login.aspx")
	end if

	dim homepage as integer = request.querystring("homepage")
	dim homepageid as integer = request.querystring("id")
	if homepage = 1 then
		  'set all to 0 '
	  	  Dim strSQL As String = "UPDATE tblPages SET homepage = 0;"
	  	  Dim iConn As New OleDbConnection("PROVIDER=Microsoft.Jet.OLEDB.4.0;DATA SOURCE=" & dbsource)
    	  Dim iCmd As New OleDbCommand(strSQL, iconn)
       	  iConn.Open()
          iCmd.ExecuteReader()
          iConn.Close()
		 'set homepage '
	  	  Dim strSQL2 As String = "UPDATE tblPages SET homepage = 1 where ID = " & homepageid & ";"
	  	  Dim iConn2 As New OleDbConnection("PROVIDER=Microsoft.Jet.OLEDB.4.0;DATA SOURCE=" & dbsource)
    	  Dim iCmd2 As New OleDbCommand(strSQL2, iconn2)
       	  iConn2.Open()
          iCmd2.ExecuteReader()
          iConn2.Close()
	end if
	

	dim newpage as integer = request.querystring("newpage")
	if newpage = 1 then
	  	  Dim strSQL As String = "INSERT INTO tblPages(pagename, pagedata, homepage) VALUES('*new page description*', '<html>" & vbcrlf & "<head>" & vbcrlf & "<title>Untitled</title>" & vbcrlf & vbcrlf & "</head>" & vbcrlf & "<body>" & vbcrlf & vbcrlf & vbcrlf & "</body>" & vbcrlf & "</html>', 0);"
	  	  Dim iConn As New OleDbConnection("PROVIDER=Microsoft.Jet.OLEDB.4.0;DATA SOURCE=" & dbsource)
    	  Dim iCmd As New OleDbCommand(strSQL, iconn)
       	  iConn.Open()
          iCmd.ExecuteReader()
          iConn.Close()
	end if
	
	dim deleteid as integer = request.querystring("deleteid")
	if deleteid > 0 then
	      Dim queryvalue = Request.QueryString("deleteid")
	  	  Dim strSQL As String = "DELETE FROM tblPages WHERE ID = " & queryvalue & ";"
	  	  Dim dconn As New OleDbConnection("PROVIDER=Microsoft.Jet.OLEDB.4.0;DATA SOURCE=" & dbsource)
    	  Dim iCmd As New OleDbCommand(strSQL, dconn)
       	  dconn.Open()
          iCmd.ExecuteReader()
          dconn.Close()
	end if

        Dim query As String = "Select pagename,id,homepage FROM tblpages order by pagename;"
        Dim myConn As New OleDbConnection("PROVIDER=Microsoft.Jet.OLEDB.4.0;DATA SOURCE=" & dbsource & "")
        Dim Cmd as New OLEDBCommand(query,myConn)
        MyConn.Open()
        dim dbread
		dbread=Cmd.ExecuteReader()
		tblpages.DataSource=dbread
		tblpages.DataBind()
		dbread.Close()
		myconn.Close()
		dim numberofresults as string = tblpages.Items.Count
		lblrcount.text = numberofresults & " pages found"
		dim idvalue as string = id

	End Sub

</script>
<body style="font-family: Arial, Helvetica, sans-serif;">
<h3 class="myfont" title="visit www.basic-cms.com for updates">Basic CMS - Page Management</h3>
<p><a href="list.aspx?newpage=1" title="click here to create a new page">Create New Page</a></p>
<asp:Repeater id="tblpages" runat="server">
<HeaderTemplate>
<table border="1" cellspacing="0" cellpadding="4" bordercolor="#000000" class="myfont">
<tr bgcolor="#b0c4de">
	<th>ID</th>
	<th>Page Description</th>
	<th>Default</th>
	<th>URL</th>
	<th>Edit</th>
	<th>Delete</th>
</tr>
</HeaderTemplate>

<AlternatingItemTemplate>
<tr bgcolor="#FFFFFF">
	<td><%#Container.DataItem("id")%>&nbsp;</td>
	<td><%#Container.DataItem("pagename")%>&nbsp;</td>
	<td><a href="list.aspx?id=<%#Container.DataItem("id")%>&homepage=1" title="Click to set as home page"><%#Container.DataItem("homepage")%></a>&nbsp;</td>
	<td><a href="default.aspx?id=<%#Container.DataItem("id")%>" title="default.aspx?id=<%#Container.DataItem("id")%>" target="_blank">default.aspx?id=<%#Container.DataItem("id")%></td>
	<td><a href="edit.aspx?id=<%#Container.DataItem("id")%>" title="Click to Edit">Edit</a>&nbsp;</td>
	<td><a href="list.aspx?deleteid=<%#Container.DataItem("id")%>" title="Delete!">Delete</a></td>
</tr>
</AlternatingItemTemplate>

<ItemTemplate>
<tr bgcolor="#f0f0f0">
	<td><%#Container.DataItem("id")%>&nbsp;</td>
	<td><%#Container.DataItem("pagename")%>&nbsp;</td>
	<td><a href="list.aspx?id=<%#Container.DataItem("id")%>&homepage=1" title="Click to set as home page"><%#Container.DataItem("homepage")%></a>&nbsp;</td>
	<td><a href="default.aspx?id=<%#Container.DataItem("id")%>" title="default.aspx?id=<%#Container.DataItem("id")%>" target="_blank">default.aspx?id=<%#Container.DataItem("id")%></td>
	<td><a href="edit.aspx?id=<%#Container.DataItem("id")%>" title="Click to Edit">Edit</a>&nbsp;</td>
	<td><a href="list.aspx?deleteid=<%#Container.DataItem("id")%>" title="Delete!" onclick="return confirm('Are you sure you want to delete?')">Delete</a></td>
</tr>
</ItemTemplate>

<FooterTemplate>
</table>
</FooterTemplate>
</asp:Repeater>
&nbsp;<asp:Label Id="lblrcount" RunAt="server" CssClass="myfont" ForeColor="#000000" font-size="12" />

<form runat="server">
	<asp:Button Id="btnShowHelp" RunAt="server" Text="Help" OnClick="btnHelp_OnClick" class="myfont" title="click for basic help" />
</form>

<asp:Label Id="lblhelp" RunAt="server" class="myfont" Text="<p><strong>Page Name:</strong> The page description</p><p><strong>Default:</strong> 1=default, or start page. Click to set.</p><p><strong>URL:</strong> To link to this page, use this location.</p><p><strong>Edit:</strong> Click Edit to edit the page.</p><p><strong>Delete:</strong> Click Delete to delete the page.</p>" />

<p><small><a href="http://www.basic-cms.com" title="basic content management" target="_blank">powered by basic-cms</a></small></p>

</body>
</html>
