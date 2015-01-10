<%@LANGUAGE="VBSCRIPT"%> 
<!--#include file="Connections/affiliate.asp" -->

<%
' *** Set Session Var To Value Of Form Element
' *** MagicBeat Server Behavior - 2007 - by Jag S. Sidhu - www.magicbeat.com
If Request.Form("Password") <> "" Then
Session("Password") = cStr(Request.Form("Password"))
END IF
%>
<%
' *** Edit Operations: declare variables

MM_editAction = CStr(Request("URL"))
If (Request.QueryString <> "") Then
  MM_editAction = MM_editAction & "?" & Request.QueryString
End If

' boolean to abort record edit
MM_abortEdit = false

' query string to execute
MM_editQuery = ""
%>
<%
' *** Delete Record: declare variables

if (CStr(Request("MM_delete")) <> "" And CStr(Request("MM_recordId")) <> "") Then

  MM_editConnection = MM_affiliate_STRING
  MM_editTable = "affiliates"
  MM_editColumn = "AffID"
  MM_recordId = "" + Request.Form("MM_recordId") + ""
  MM_editRedirectUrl = ""

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
' *** Update Record: set variables

If (CStr(Request("MM_update")) <> "" And CStr(Request("MM_recordId")) <> "") Then

  MM_editConnection = MM_affiliate_STRING
  MM_editTable = "affiliates"
  MM_editColumn = "AffID"
  MM_recordId = "" + Request.Form("MM_recordId") + ""
  MM_editRedirectUrl = ""
  MM_fieldsStr  = "Earned|value"
  MM_columnsStr = "Earned|',none,''"

  ' create the MM_fields and MM_columns arrays
  MM_fields = Split(MM_fieldsStr, "|")
  MM_columns = Split(MM_columnsStr, "|")
  
  ' set the form values
  For i = LBound(MM_fields) To UBound(MM_fields) Step 2
    MM_fields(i+1) = CStr(Request.Form(MM_fields(i)))
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
' *** Delete Record: construct a sql delete statement and execute it

If (CStr(Request("MM_delete")) <> "" And CStr(Request("MM_recordId")) <> "") Then

  ' create the sql delete statement
  MM_editQuery = "delete from " & MM_editTable & " where " & MM_editColumn & " = " & MM_recordId

  If (Not MM_abortEdit) Then
    ' execute the delete
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
' *** Update Record: construct a sql update statement and execute it

If (CStr(Request("MM_update")) <> "" And CStr(Request("MM_recordId")) <> "") Then

  ' create the sql update statement
  MM_editQuery = "update " & MM_editTable & " set "
  For i = LBound(MM_fields) To UBound(MM_fields) Step 2
    FormVal = MM_fields(i+1)
    MM_typeArray = Split(MM_columns(i+1),",")
    Delim = MM_typeArray(0)
    If (Delim = "none") Then Delim = ""
    AltVal = MM_typeArray(1)
    If (AltVal = "none") Then AltVal = ""
    EmptyVal = MM_typeArray(2)
    If (EmptyVal = "none") Then EmptyVal = ""
    If (FormVal = "") Then
      FormVal = EmptyVal
    Else
      If (AltVal <> "") Then
        FormVal = AltVal
      ElseIf (Delim = "'") Then  ' escape quotes
        FormVal = "'" & Replace(FormVal,"'","''") & "'"
      Else
        FormVal = Delim + FormVal + Delim
      End If
    End If
    If (i <> LBound(MM_fields)) Then
      MM_editQuery = MM_editQuery & ","
    End If
    MM_editQuery = MM_editQuery & MM_columns(i) & " = " & FormVal
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
set rsAffiliates = Server.CreateObject("ADODB.Recordset")
rsAffiliates.ActiveConnection = MM_affiliate_STRING
rsAffiliates.Source = "SELECT *  FROM affiliates  ORDER BY AffID DESC"
rsAffiliates.CursorType = 0
rsAffiliates.CursorLocation = 2
rsAffiliates.LockType = 3
rsAffiliates.Open()
rsAffiliates_numRows = 0
%>
<%
set rsTotalsum = Server.CreateObject("ADODB.Recordset")
rsTotalsum.ActiveConnection = MM_affiliate_STRING
rsTotalsum.Source = "SELECT Sum(affiliates.Earned) AS SumOfEarned  FROM affiliates;"
rsTotalsum.CursorType = 0
rsTotalsum.CursorLocation = 2
rsTotalsum.LockType = 3
rsTotalsum.Open()
rsTotalsum_numRows = 0
%>
<%

set rsAdmin = Server.CreateObject("ADODB.Recordset")
rsAdmin.ActiveConnection = MM_affiliate_STRING
rsAdmin.Source = "SELECT TOP 1 *  FROM Admin  ORDER BY ID DESC"
rsAdmin.CursorType = 0
rsAdmin.CursorLocation = 2
rsAdmin.LockType = 3
rsAdmin.Open()
rsAdmin_numRows = 0

%>
<%
Dim Repeat1__numRows
Repeat1__numRows = 20
Dim Repeat1__index
Repeat1__index = 0
rsAffiliates_numRows = rsAffiliates_numRows + Repeat1__numRows
%>
<%
'  *** Recordset Stats, Move To Record, and Go To Record: declare stats variables

' set the record count
rsAffiliates_total = rsAffiliates.RecordCount

' set the number of rows displayed on this page
If (rsAffiliates_numRows < 0) Then
  rsAffiliates_numRows = rsAffiliates_total
Elseif (rsAffiliates_numRows = 0) Then
  rsAffiliates_numRows = 1
End If

' set the first and last displayed record
rsAffiliates_first = 1
rsAffiliates_last  = rsAffiliates_first + rsAffiliates_numRows - 1

' if we have the correct record count, check the other stats
If (rsAffiliates_total <> -1) Then
  If (rsAffiliates_first > rsAffiliates_total) Then rsAffiliates_first = rsAffiliates_total
  If (rsAffiliates_last > rsAffiliates_total) Then rsAffiliates_last = rsAffiliates_total
  If (rsAffiliates_numRows > rsAffiliates_total) Then rsAffiliates_numRows = rsAffiliates_total
End If
%>
<%
' *** Recordset Stats: if we don't know the record count, manually count them

If (rsAffiliates_total = -1) Then

  ' count the total records by iterating through the recordset
  rsAffiliates_total=0
  While (Not rsAffiliates.EOF)
    rsAffiliates_total = rsAffiliates_total + 1
    rsAffiliates.MoveNext
  Wend

  ' reset the cursor to the beginning
  If (rsAffiliates.CursorType > 0) Then
    rsAffiliates.MoveFirst
  Else
    rsAffiliates.Requery
  End If

  ' set the number of rows displayed on this page
  If (rsAffiliates_numRows < 0 Or rsAffiliates_numRows > rsAffiliates_total) Then
    rsAffiliates_numRows = rsAffiliates_total
  End If

  ' set the first and last displayed record
  rsAffiliates_first = 1
  rsAffiliates_last = rsAffiliates_first + rsAffiliates_numRows - 1
  If (rsAffiliates_first > rsAffiliates_total) Then rsAffiliates_first = rsAffiliates_total
  If (rsAffiliates_last > rsAffiliates_total) Then rsAffiliates_last = rsAffiliates_total

End If
%>
<%
' *** Move To Record and Go To Record: declare variables

Set MM_rs    = rsAffiliates
MM_rsCount   = rsAffiliates_total
MM_size      = rsAffiliates_numRows
MM_uniqueCol = ""
MM_paramName = ""
MM_offset = 0
MM_atTotal = false
MM_paramIsDefined = false
If (MM_paramName <> "") Then
  MM_paramIsDefined = (Request.QueryString(MM_paramName) <> "")
End If
%>
<%
' *** Move To Record: handle 'index' or 'offset' parameter

if (Not MM_paramIsDefined And MM_rsCount <> 0) then

  ' use index parameter if defined, otherwise use offset parameter
  r = Request.QueryString("index")
  If r = "" Then r = Request.QueryString("offset")
  If r <> "" Then MM_offset = Int(r)

  ' if we have a record count, check if we are past the end of the recordset
  If (MM_rsCount <> -1) Then
    If (MM_offset >= MM_rsCount Or MM_offset = -1) Then  ' past end or move last
      If ((MM_rsCount Mod MM_size) > 0) Then         ' last page not a full repeat region
        MM_offset = MM_rsCount - (MM_rsCount Mod MM_size)
      Else
        MM_offset = MM_rsCount - MM_size
      End If
    End If
  End If

  ' move the cursor to the selected record
  i = 0
  While ((Not MM_rs.EOF) And (i < MM_offset Or MM_offset = -1))
    MM_rs.MoveNext
    i = i + 1
  Wend
  If (MM_rs.EOF) Then MM_offset = i  ' set MM_offset to the last possible record

End If
%>
<%
' *** Move To Record: if we dont know the record count, check the display range

If (MM_rsCount = -1) Then

  ' walk to the end of the display range for this page
  i = MM_offset
  While (Not MM_rs.EOF And (MM_size < 0 Or i < MM_offset + MM_size))
    MM_rs.MoveNext
    i = i + 1
  Wend

  ' if we walked off the end of the recordset, set MM_rsCount and MM_size
  If (MM_rs.EOF) Then
    MM_rsCount = i
    If (MM_size < 0 Or MM_size > MM_rsCount) Then MM_size = MM_rsCount
  End If

  ' if we walked off the end, set the offset based on page size
  If (MM_rs.EOF And Not MM_paramIsDefined) Then
    If (MM_offset > MM_rsCount - MM_size Or MM_offset = -1) Then
      If ((MM_rsCount Mod MM_size) > 0) Then
        MM_offset = MM_rsCount - (MM_rsCount Mod MM_size)
      Else
        MM_offset = MM_rsCount - MM_size
      End If
    End If
  End If

  ' reset the cursor to the beginning
  If (MM_rs.CursorType > 0) Then
    MM_rs.MoveFirst
  Else
    MM_rs.Requery
  End If

  ' move the cursor to the selected record
  i = 0
  While (Not MM_rs.EOF And i < MM_offset)
    MM_rs.MoveNext
    i = i + 1
  Wend
End If
%>
<%
' *** Move To Record: update recordset stats

' set the first and last displayed record
rsAffiliates_first = MM_offset + 1
rsAffiliates_last  = MM_offset + MM_size
If (MM_rsCount <> -1) Then
  If (rsAffiliates_first > MM_rsCount) Then rsAffiliates_first = MM_rsCount
  If (rsAffiliates_last > MM_rsCount) Then rsAffiliates_last = MM_rsCount
End If

' set the boolean used by hide region to check if we are on the last record
MM_atTotal = (MM_rsCount <> -1 And MM_offset + MM_size >= MM_rsCount)
%>
<%
' *** Go To Record and Move To Record: create strings for maintaining URL and Form parameters

' create the list of parameters which should not be maintained
MM_removeList = "&index="
If (MM_paramName <> "") Then MM_removeList = MM_removeList & "&" & MM_paramName & "="
MM_keepURL="":MM_keepForm="":MM_keepBoth="":MM_keepNone=""

' add the URL parameters to the MM_keepURL string
For Each Item In Request.QueryString
  NextItem = "&" & Item & "="
  If (InStr(1,MM_removeList,NextItem,1) = 0) Then
    MM_keepURL = MM_keepURL & NextItem & Server.URLencode(Request.QueryString(Item))
  End If
Next

' add the Form variables to the MM_keepForm string
For Each Item In Request.Form
  NextItem = "&" & Item & "="
  If (InStr(1,MM_removeList,NextItem,1) = 0) Then
    MM_keepForm = MM_keepForm & NextItem & Server.URLencode(Request.Form(Item))
  End If
Next

' create the Form + URL string and remove the intial '&' from each of the strings
MM_keepBoth = MM_keepURL & MM_keepForm
if (MM_keepBoth <> "") Then MM_keepBoth = Right(MM_keepBoth, Len(MM_keepBoth) - 1)
if (MM_keepURL <> "")  Then MM_keepURL  = Right(MM_keepURL, Len(MM_keepURL) - 1)
if (MM_keepForm <> "") Then MM_keepForm = Right(MM_keepForm, Len(MM_keepForm) - 1)

' a utility function used for adding additional parameters to these strings
Function MM_joinChar(firstItem)
  If (firstItem <> "") Then
    MM_joinChar = "&"
  Else
    MM_joinChar = ""
  End If
End Function
%>
<%
' *** Move To Record: set the strings for the first, last, next, and previous links

MM_keepMove = MM_keepBoth
MM_moveParam = "index"

' if the page has a repeated region, remove 'offset' from the maintained parameters
If (MM_size > 0) Then
  MM_moveParam = "offset"
  If (MM_keepMove <> "") Then
    params = Split(MM_keepMove, "&")
    MM_keepMove = ""
    For i = 0 To UBound(params)
      nextItem = Left(params(i), InStr(params(i),"=") - 1)
      If (StrComp(nextItem,MM_moveParam,1) <> 0) Then
        MM_keepMove = MM_keepMove & "&" & params(i)
      End If
    Next
    If (MM_keepMove <> "") Then
      MM_keepMove = Right(MM_keepMove, Len(MM_keepMove) - 1)
    End If
  End If
End If

' set the strings for the move to links
If (MM_keepMove <> "") Then MM_keepMove = MM_keepMove & "&"
urlStr = Request.ServerVariables("URL") & "?" & MM_keepMove & MM_moveParam & "="
MM_moveFirst = urlStr & "0"
MM_moveLast  = urlStr & "-1"
MM_moveNext  = urlStr & Cstr(MM_offset + MM_size)
prev = MM_offset - MM_size
If (prev < 0) Then prev = 0
MM_movePrev  = urlStr & Cstr(prev)
%>
<html>
<head>
<title>Affiliates Admin Page</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<style type="text/css">
<!--

a:hover {  color: #FFFFFF; text-decoration: none}
-->


</style>
<script language="JavaScript">
<!--
function GP_popupConfirmMsg(msg) { //v1.0
  document.MM_returnValue = confirm(msg);
}

function MM_openBrWindow(theURL,winName,features) { //v2.0
  window.open(theURL,winName,features);
}
//-->
</script>
<style type="text/css">
<!--
-->
</style>
</head>
<body bgcolor="#66CC99" text="#000000">
<center>
  <p><img src="logo.gif" width="355" height="50" alt="Your Logo"> </p>
  <% If rsAdmin.Fields.Item("Password").Value <> (Session("Password")) Then %>
  <form name="form3" method="post" action="">
	<b><font face="Verdana, Arial, Helvetica, sans-serif" size="1">Enter Password:</font></b> 
	<input type="password" name="Password">
	<input type="submit" name="Submit3" value="Login">
  </form>
  <% End If ' end If rsAdmin.Fields.Item("Password").Value <> (Session("Password")) %>
  <p>&nbsp;</p>
  <% If rsAdmin.Fields.Item("Password").Value = (Session("Password")) Then %>
  <table width="500" border="0" cellspacing="5" cellpadding="5">
	<tr> 
	  <td width="495" valign="top"> 
		<p><font face="Verdana, Arial, Helvetica, sans-serif" size="2">Total commissions 
		  due : $<%=(rsTotalsum.Fields.Item("SumOfEarned").Value)%></font> </p>
		<p><font face="Verdana, Arial, Helvetica, sans-serif" size="2">Total number 
		  of affiliates: <%=(rsAffiliates_total)%></font></p>
		<table width="100%" border="0" cellspacing="1" cellpadding="1" bgcolor="#000000">
          <tr> 
            <td bgcolor="#6699CC" height="20" colspan="5"><font face="Verdana, Arial, Helvetica, sans-serif" size="2"><b>Affiliates</b></font></td>
          </tr>
          <% 
While ((Repeat1__numRows <> 0) AND (NOT rsAffiliates.EOF)) 
%>
          <tr> 
            <td nowrap bgcolor="#0099CC"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><%=(rsAffiliates.Fields.Item("AffID").Value)%></font></td>
            <td nowrap bgcolor="#0099CC" width="51%"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><a href="mailto:<%=(rsAffiliates.Fields.Item("Email").Value)%>" ><%=(rsAffiliates.Fields.Item("Name").Value)%></a></font><font face="Verdana, Arial, Helvetica, sans-serif" size="1"> 
              ($<%= Csng(rsAffiliates.Fields.Item("Earned").Value) %>)</font></td>
           <% If  Csng(rsAffiliates.Fields.Item("Earned").Value)  >= Csng(rsAdmin.Fields.Item("Minimum").Value)  Then %>
<form name="Paypal" action="https://www.paypal.com/cgi-bin/webscr" method="post" >
              <td nowrap bgcolor="#0099CC" width="31%" align="center">
               	<input type="hidden" name="amount" value= <%= formatnumber((rsAffiliates.Fields.Item("Earned").Value))%> >
                <input type="hidden" name="cmd" value="_xclick">
                <input type="hidden" name="business" value= "<%=(rsAffiliates.Fields.Item("Email").Value)%>">
                <input type="hidden" name="item_name" value="Commission Due">
                <input type="hidden" name="undefined_quantity" value="0">
                <input type="hidden" name="no_shipping" value="1">
                <input type="hidden" name="no_note" value="1">
                <input name="Submit" type="submit"  id="Submit" value="Pay Now">
              </td></form> 
<% Else %>
<td nowrap bgcolor="#0099CC" width="31%" align="center">
</td> 
<%END IF%>

            <form name="form2" method="POST" action="<%=MM_editAction%>">
              <td nowrap bgcolor="#0099CC" width="31%" align="center"> 
                <input type="submit" name="Submit2" value="Reset to 0" class="button" onClick="GP_popupConfirmMsg('Are you sure you want to reset this affiliate?');return document.MM_returnValue"> 
                <input type="hidden" name="Earned" value="0"> </td>
              <input type="hidden" name="MM_update" value="form2">
              <input type="hidden" name="MM_recordId" value="<%= rsAffiliates.Fields.Item("AffID").Value %>">
            </form>
            <form name="form1" method="POST" action="<%=MM_editAction%>">
              <td nowrap bgcolor="#0099CC" width="18%" align="center"> 
                <input type="submit" name="Submit" value="Delete" class="button" onClick="GP_popupConfirmMsg('Are you sure you want to delete this account?');return document.MM_returnValue"> 
              </td>
              <input type="hidden" name="MM_delete" value="true">
              <input type="hidden" name="MM_recordId" value="<%= rsAffiliates.Fields.Item("AffID").Value %>">
            </form>
          </tr>
          <% 
  Repeat1__index=Repeat1__index+1
  Repeat1__numRows=Repeat1__numRows-1
  rsAffiliates.MoveNext()
Wend
%>
        </table>
		<p align="center"><font face="Verdana, Arial, Helvetica, sans-serif" size="1">*Be 
		  carefull not to reset or delete the wrong account! :-) </font></p>
		<p align="center">&nbsp; <font face="Verdana, Arial, Helvetica, sans-serif"> 
		  <font size="1"> 
		  <%
For i = 1 to rsAffiliates_total Step MM_size
TM_endCount = i + MM_size - 1
if TM_endCount > rsAffiliates_total Then TM_endCount = rsAffiliates_total
if i <> MM_offset + 1 Then
Response.Write("<a href=""" & Request.ServerVariables("URL") & "?" & MM_keepMove & "offset=" & i-1 & """>")
Response.Write(i & "-" & TM_endCount & "</a>")
else
Response.Write("<b>" & i & "-" & TM_endCount & "</b>")
End if
if(TM_endCount <> rsAffiliates_total) then Response.Write(" - ")
next
 %>
		  </font> </font> </p>
	  </td>
	</tr>
  </table>
  
  <p><a href="#" onClick="MM_openBrWindow('settings.asp','Settings','status=yes,scrollbars=yes,width=400,height=550')">Settings</a></p>
  <p>&nbsp;</p>
  <center>
    <img src="horizontalBar.gif" width="650" height="1"> 
  </center>
  <p align="center"><font face="Verdana, Arial, Helvetica, sans-serif" size="1">'My 
    ASP Affiliate Program' is a product of <a href="http://www.kattouf.com/">Kattouf 
    Internet Services</a> <br>
    Made in Sweden<br>
    | <a href="mailto:johnny@kattouf.com">Contact me</a> |</font></p>
  <p>&nbsp;</p>
  <p> 
    <% End If ' end If rsAdmin.Fields.Item("Password").Value = (Session("Password")) %>
  </p>
  <p>&nbsp;</p>
</center>
</body>
</html>
<%
rsAffiliates.Close()
%>
<%
rsTotalsum.Close()
%>
<%
rsAdmin.Close()
%>
