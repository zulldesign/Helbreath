<%@LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<% If Session("password") <> "" Then %>
<!--#include file="Connections/affiliate.asp" -->
<%
' *** Edit Operations: declare variables

Dim MM_editAction
Dim MM_abortEdit
Dim MM_editQuery
Dim MM_editCmd

Dim MM_editConnection
Dim MM_editTable
Dim MM_editRedirectUrl
Dim MM_editColumn
Dim MM_recordId

Dim MM_fieldsStr
Dim MM_columnsStr
Dim MM_fields
Dim MM_columns
Dim MM_typeArray
Dim MM_formVal
Dim MM_delim
Dim MM_altVal
Dim MM_emptyVal
Dim MM_i

MM_editAction = CStr(Request.ServerVariables("SCRIPT_NAME"))
If (Request.QueryString <> "") Then
  MM_editAction = MM_editAction & "?" & Request.QueryString
End If

' boolean to abort record edit
MM_abortEdit = false

' query string to execute
MM_editQuery = ""
%>
<%
' *** Update Record: set variables

If (CStr(Request("MM_update")) = "form1" And CStr(Request("MM_recordId")) <> "") Then

  MM_editConnection = MM_affiliate_STRING
  MM_editTable = "Admin"
  MM_editColumn = "ID"
  MM_recordId = "" + Request.Form("MM_recordId") + ""
  MM_editRedirectUrl = "saved.asp"
  MM_fieldsStr  = "textfield|value|textfield2|value|textfield3|value|textfield4|value|textfield5|value|textfield6|value|checkbox|value"
  MM_columnsStr = "Password|',none,''|URL|',none,''|Email|',none,''|Fixedrate|',none,''|Minimum|',none,''|Percentrate|',none,''|Percentage|none,Yes,No"

  ' create the MM_fields and MM_columns arrays
  MM_fields = Split(MM_fieldsStr, "|")
  MM_columns = Split(MM_columnsStr, "|")
  
  ' set the form values
  For MM_i = LBound(MM_fields) To UBound(MM_fields) Step 2
    MM_fields(MM_i+1) = CStr(Request.Form(MM_fields(MM_i)))
  Next

  ' append the query string to the redirect URL
  If (MM_editRedirectUrl <> "" And Request.QueryString <> "") Then
    If (InStr(1, MM_editRedirectUrl, "?", vbTextCompare) = 0 And Request.QueryString <> "") Then
      MM_editRedirectUrl = MM_editRedirectUrl & "?" & Request.QueryString
    Else
      MM_editRedirectUrl = MM_editRedirectUrl & "&" & Request.QueryString
    End If
  End If

End If
%>
<%
' *** Update Record: construct a sql update statement and execute it

If (CStr(Request("MM_update")) <> "" And CStr(Request("MM_recordId")) <> "") Then

  ' create the sql update statement
  MM_editQuery = "update " & MM_editTable & " set "
  For MM_i = LBound(MM_fields) To UBound(MM_fields) Step 2
    MM_formVal = MM_fields(MM_i+1)
    MM_typeArray = Split(MM_columns(MM_i+1),",")
    MM_delim = MM_typeArray(0)
    If (MM_delim = "none") Then MM_delim = ""
    MM_altVal = MM_typeArray(1)
    If (MM_altVal = "none") Then MM_altVal = ""
    MM_emptyVal = MM_typeArray(2)
    If (MM_emptyVal = "none") Then MM_emptyVal = ""
    If (MM_formVal = "") Then
      MM_formVal = MM_emptyVal
    Else
      If (MM_altVal <> "") Then
        MM_formVal = MM_altVal
      ElseIf (MM_delim = "'") Then  ' escape quotes
        MM_formVal = "'" & Replace(MM_formVal,"'","''") & "'"
      Else
        MM_formVal = MM_delim + MM_formVal + MM_delim
      End If
    End If
    If (MM_i <> LBound(MM_fields)) Then
      MM_editQuery = MM_editQuery & ","
    End If
    MM_editQuery = MM_editQuery & MM_columns(MM_i) & " = " & MM_formVal
  Next
  MM_editQuery = MM_editQuery & " where " & MM_editColumn & " = " & MM_recordId

  If (Not MM_abortEdit) Then
    ' execute the update
    Set MM_editCmd = Server.CreateObject("ADODB.Command")
    MM_editCmd.ActiveConnection = MM_editConnection
    MM_editCmd.CommandText = MM_editQuery
    MM_editCmd.Execute
    MM_editCmd.ActiveConnection.Close

    If (MM_editRedirectUrl <> "") Then
      Response.Redirect(MM_editRedirectUrl)
    End If
  End If

End If
%>
<%
Dim Admin
Dim Admin_numRows

Set Admin = Server.CreateObject("ADODB.Recordset")
Admin.ActiveConnection = MM_affiliate_STRING
Admin.Source = "SELECT * FROM Admin"
Admin.CursorType = 0
Admin.CursorLocation = 2
Admin.LockType = 1
Admin.Open()

Admin_numRows = 0
%>



<html>
<head>
<title>Settings</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>

<body bgcolor="#66CC99">
<div align="left">
  <p><b><font size="2" face="Verdana, Arial, Helvetica, sans-serif">Settings:</font></b></p>
  <form name="form1" method="POST" action="<%=MM_editAction%>">
    <table width="281" border="0" cellpadding="2" cellspacing="1" bgcolor="#000000">
      <tr> 
        <td width="15" bgcolor="#6699CC"><b><font size="1" face="Verdana, Arial, Helvetica, sans-serif">1.</font></b></td>
        <td width="65" nowrap bgcolor="#6699CC"><b><font size="1" face="Verdana, Arial, Helvetica, sans-serif">Password</font></b></td>
        <td width="185" bgcolor="#66CC99"><input name="textfield" type="password" value="<%=(Admin.Fields.Item("Password").Value)%>" size="20"></td>
      </tr>
      <tr> 
        <td width="15" bgcolor="#6699CC"><b><font size="1" face="Verdana, Arial, Helvetica, sans-serif">2.</font></b></td>
        <td width="65" nowrap bgcolor="#6699CC"><b><font size="1" face="Verdana, Arial, Helvetica, sans-serif">Site 
          Url</font></b></td>
        <td bgcolor="#66CC99"><input name="textfield2" type="text" value="<%=(Admin.Fields.Item("URL").Value)%>" size="20"></td>
      </tr>
      <tr> 
        <td width="15" bgcolor="#6699CC"><b><font size="1" face="Verdana, Arial, Helvetica, sans-serif">3.</font></b></td>
        <td width="65" nowrap bgcolor="#6699CC"><b><font size="1" face="Verdana, Arial, Helvetica, sans-serif">Your 
          Email</font></b></td>
        <td bgcolor="#66CC99"><input name="textfield3" type="text" value="<%=(Admin.Fields.Item("Email").Value)%>" size="20"></td>
      </tr>
      <tr> 
        <td width="15" bgcolor="#6699CC"><b><font size="1" face="Verdana, Arial, Helvetica, sans-serif">4.</font></b></td>
        <td width="65" nowrap bgcolor="#6699CC"><b><font size="1" face="Verdana, Arial, Helvetica, sans-serif">Commission</font></b></td>
        <td bgcolor="#66CC99"><input name="textfield4" type="text" value="<%=(Admin.Fields.Item("Fixedrate").Value)%>" size="4" maxlength="4"></td>
      </tr>
      <tr> 
        <td width="15" bgcolor="#6699CC"><b><font size="1" face="Verdana, Arial, Helvetica, sans-serif">5.</font></b></td>
        <td width="65" nowrap bgcolor="#6699CC"><b><font size="1" face="Verdana, Arial, Helvetica, sans-serif">Minimum</font></b></td>
        <td bgcolor="#66CC99"><input name="textfield5" type="text" value="<%=(Admin.Fields.Item("Minimum").Value)%>" size="4" maxlength="4"></td>
      </tr>
    </table>
    <p><b>For PayPal carts / buttons only!<br>
      Enable IPN first!</b></p>
    <table width="281" border="0" cellpadding="2" cellspacing="1" bgcolor="#000000">
      <tr> 
        <td width="17" bgcolor="#CC3300"><b><font size="1" face="Verdana, Arial, Helvetica, sans-serif">6.</font></b></td>
        <td nowrap bgcolor="#CC3300"><b><font size="1" face="Verdana, Arial, Helvetica, sans-serif">Percent 
          Rate</font></b></td>
        <td width="215" bgcolor="#66CC99"><input name="textfield6" type="text" value="<%=(Admin.Fields.Item("Percentrate").Value)%>" size="5"> 
          <font size="1" face="Verdana, Arial, Helvetica, sans-serif">(eg 0.25)</font></td>
      </tr>
      <tr> 
        <td width="17" bgcolor="#CC3300"><b><font size="1" face="Verdana, Arial, Helvetica, sans-serif">7.</font></b></td>
        <td nowrap bgcolor="#CC3300"><b><font size="1" face="Verdana, Arial, Helvetica, sans-serif">Enable</font></b></td>
        <td bgcolor="#66CC99"> <input name="checkbox" type="checkbox" id="checkbox" value="1" <%If (CStr((Admin.Fields.Item("Percentage").Value)) = CStr("True")) Then Response.Write("checked") : Response.Write("")%>> 
        </td>
      </tr>
    </table>
    <p> 
      <input type="submit" name="Submit" value="Submit">
    </p>
    <input type="hidden" name="MM_update" value="form1">
    <input type="hidden" name="MM_recordId" value="<%= Admin.Fields.Item("ID").Value %>">
  </form>
</div>
<p align="left"><font size="1" face="Verdana, Arial, Helvetica, sans-serif">1. 
  Changes your password.<br>
  2. Enter the address to your shopping site ( include filename if not index.asp 
  or default.asp)<br>
  Eg: http://www.mydomain.com/shop.asp (must end with &quot;/&quot; or filename)<br>
  3. Enter your email address<br>
  4. Enter the amount to pay per sale<br>
  5. Enter the minimum required for payout<br>
  6. For 20% type 0.2, for 15% type 0.15 etc.. (very important)<br>
  7. Choose whether to enable percent rate commission. (Fixed also works fine 
  with IPN)</font></p>
</body>


</html>
<%
Admin.Close()
Set Admin = Nothing
%>
<%Else

Response.Write ("Access denied!")

End IF

%>
