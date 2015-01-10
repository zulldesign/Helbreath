<%@ Page Language="vb" Debug=true ValidateRequest=false %>
<%@ import Namespace="System.Data.OLEDB" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<!-- #INCLUDE FILE="include.aspx" -->
<!-- #INCLUDE FILE="menu.aspx" -->
<html>
<head>
<title>Edit Page</title>
<script runat="server" language="vb">
dim iframedata as string
Sub Page_Load(sender As Object, e As EventArgs)

	if session("loggedin") = "" then
		response.redirect("login.aspx")
	end if

Dim queryvalue = Request.QueryString("id")

if Page.IsPostBack then
	If (IsNumeric(queryvalue)) then
	  dim pagenameupdate as string = request.form("pagename")
	  	pagenameupdate = replace(pagenameupdate,"'", "''")
	  dim pagedataupdate as string = request.form("pagedata")
	  	pagedataupdate = replace(pagedataupdate,"'", "''")
	  
      Dim strSQL As String = "UPDATE tblPages SET pagedata = '" & pagedataupdate & "', pagename = '" & pagenameupdate & "' where ID = " & queryvalue & ";"
	  Dim myConn As New OleDbConnection("PROVIDER=Microsoft.Jet.OLEDB.4.0;DATA SOURCE=" & dbsource & "")
      Dim Cmd As New OleDbCommand(strSQL, Myconn)
        MyConn.Open()
        Cmd.ExecuteReader()
        MyConn.Close()
	end if
end if

If (IsNumeric(queryvalue)) then
      Dim query As String = "Select pagedata, pagename FROM tblpages WHERE id = " & queryvalue & ";"
      Dim myConn As New OleDbConnection("PROVIDER=Microsoft.Jet.OLEDB.4.0;DATA SOURCE=" & dbsource & "")
      Dim myCmd As OleDbCommand = New OleDbCommand(query, myConn)
      myConn.Open()
      Dim myReader As OleDbDataReader = myCmd.ExecuteReader()

      While myReader.Read()
		pagename.text = (myReader("pagename").tostring)
		pagedata.text = (myReader("pagedata").tostring)
      End While

       'close connections'
      myReader.Close()
      myConn.Close()
      MyConn = Nothing
	  iframedata = "<br>page preview<br><iframe src='default.aspx?id=" & queryvalue & "' width='660' height='300'></iframe>"
Else
	
End if
		
End Sub

</script>
<head>
<body style="font-family: Arial, Helvetica, sans-serif;">
<form RunAt="server">
<input type="submit" value="Save"><br>
page description<br>
<asp:TextBox Id="pagename" RunAt="server" ReadOnly="false" AutoPostBack="false" />
<br>
page contents
<br>
<asp:TextBox Id="pagedata" RunAt="server" Rows="15" Columns="80" ReadOnly="false" TextMode="MultiLine" AutoPostBack="false" />
<%=(iframedata)%>
</form>
</body>
</html>
