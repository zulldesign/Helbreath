<!--'My ASP Affiliate Program' is a product of Kattouf Internet Services.
Url: http://www.kattouf.com
Email: johnny@kattouf.com
 -->
<%@LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<!--#include file="Connections/affiliate.asp" -->

<% if Request.FORM("Email") <> "" THEN
Session("Email") = Request.FORM("Email")
End IF %>

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
' *** Insert Record: set variables

If (CStr(Request("MM_insert")) <> "") Then

  MM_editConnection = MM_affiliate_STRING
  MM_editTable = "affiliates"
  MM_editRedirectUrl = ""
  MM_fieldsStr  = "Name|value|Email|value"
  MM_columnsStr = "Name|',none,''|Email|',none,''"

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
' *** Insert Record: construct a sql insert statement and execute it

If (CStr(Request("MM_insert")) <> "") Then

  ' create the sql insert statement
  MM_tableValues = ""
  MM_dbValues = ""
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
      MM_tableValues = MM_tableValues & ","
      MM_dbValues = MM_dbValues & ","
    End if
    MM_tableValues = MM_tableValues & MM_columns(i)
    MM_dbValues = MM_dbValues & FormVal
  Next
  MM_editQuery = "insert into " & MM_editTable & " (" & MM_tableValues & ") values (" & MM_dbValues & ")"

  If (Not MM_abortEdit) Then
    ' execute the insert
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
Dim rsaffiliate__MMColParam
rsaffiliate__MMColParam = "1"
If (Session("Email")  <> "") Then 
  rsaffiliate__MMColParam = Session("Email") 
End If
%>
<%
if Session("Email") <> "" THEN
set rsaffiliate = Server.CreateObject("ADODB.Recordset")
rsaffiliate.ActiveConnection = MM_affiliate_STRING
rsaffiliate.Source = "SELECT *  FROM affiliates  WHERE Email = '" + Replace(rsaffiliate__MMColParam, "'", "''") + "'"
rsaffiliate.CursorType = 0
rsaffiliate.CursorLocation = 2
rsaffiliate.LockType = 3
rsaffiliate.Open()
rsaffiliate_numRows = 0
If rsaffiliate.EOF Then
response.write "I tired but could not find your email on file, please try again.."
Response.END
End IF 
END IF
%>
<%
Dim Query__MMColParam
Query__MMColParam = "1"
If (Session("Email") <> "") Then 
  Query__MMColParam = Session("Email")
End If
%>
<%
Dim Query
Dim Query_numRows

Set Query = Server.CreateObject("ADODB.Recordset")
Query.ActiveConnection = MM_affiliate_STRING
Query.Source = "SELECT * FROM Querycommission WHERE Email = '" + Replace(Query__MMColParam, "'", "''") + "' ORDER BY Date DESC"
Query.CursorType = 0
Query.CursorLocation = 2
Query.LockType = 1
Query.Open()

Query_numRows = 0
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
<%
Dim Repeat1__numRows
Dim Repeat1__index

Repeat1__numRows = 20
Repeat1__index = 0
Query_numRows = Query_numRows + Repeat1__numRows
%>
<%
'  *** Recordset Stats, Move To Record, and Go To Record: declare stats variables

Dim Query_total
Dim Query_first
Dim Query_last

' set the record count
Query_total = Query.RecordCount

' set the number of rows displayed on this page
If (Query_numRows < 0) Then
  Query_numRows = Query_total
Elseif (Query_numRows = 0) Then
  Query_numRows = 1
End If

' set the first and last displayed record
Query_first = 1
Query_last  = Query_first + Query_numRows - 1

' if we have the correct record count, check the other stats
If (Query_total <> -1) Then
  If (Query_first > Query_total) Then
    Query_first = Query_total
  End If
  If (Query_last > Query_total) Then
    Query_last = Query_total
  End If
  If (Query_numRows > Query_total) Then
    Query_numRows = Query_total
  End If
End If
%>
<%
Dim MM_paramName 
%>
<%
' *** Move To Record and Go To Record: declare variables

Dim MM_rs
Dim MM_rsCount
Dim MM_size
Dim MM_uniqueCol
Dim MM_offset
Dim MM_atTotal
Dim MM_paramIsDefined

Dim MM_param
Dim MM_index

Set MM_rs    = Query
MM_rsCount   = Query_total
MM_size      = Query_numRows
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
  MM_param = Request.QueryString("index")
  If (MM_param = "") Then
    MM_param = Request.QueryString("offset")
  End If
  If (MM_param <> "") Then
    MM_offset = Int(MM_param)
  End If

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
  MM_index = 0
  While ((Not MM_rs.EOF) And (MM_index < MM_offset Or MM_offset = -1))
    MM_rs.MoveNext
    MM_index = MM_index + 1
  Wend
  If (MM_rs.EOF) Then 
    MM_offset = MM_index  ' set MM_offset to the last possible record
  End If

End If
%>
<%
' *** Move To Record: if we dont know the record count, check the display range

If (MM_rsCount = -1) Then

  ' walk to the end of the display range for this page
  MM_index = MM_offset
  While (Not MM_rs.EOF And (MM_size < 0 Or MM_index < MM_offset + MM_size))
    MM_rs.MoveNext
    MM_index = MM_index + 1
  Wend

  ' if we walked off the end of the recordset, set MM_rsCount and MM_size
  If (MM_rs.EOF) Then
    MM_rsCount = MM_index
    If (MM_size < 0 Or MM_size > MM_rsCount) Then
      MM_size = MM_rsCount
    End If
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
  MM_index = 0
  While (Not MM_rs.EOF And MM_index < MM_offset)
    MM_rs.MoveNext
    MM_index = MM_index + 1
  Wend
End If
%>
<%
' *** Move To Record: update recordset stats

' set the first and last displayed record
Query_first = MM_offset + 1
Query_last  = MM_offset + MM_size

If (MM_rsCount <> -1) Then
  If (Query_first > MM_rsCount) Then
    Query_first = MM_rsCount
  End If
  If (Query_last > MM_rsCount) Then
    Query_last = MM_rsCount
  End If
End If

' set the boolean used by hide region to check if we are on the last record
MM_atTotal = (MM_rsCount <> -1 And MM_offset + MM_size >= MM_rsCount)
%>
<%
' *** Go To Record and Move To Record: create strings for maintaining URL and Form parameters

Dim MM_keepNone
Dim MM_keepURL
Dim MM_keepForm
Dim MM_keepBoth

Dim MM_removeList
Dim MM_item
Dim MM_nextItem

' create the list of parameters which should not be maintained
MM_removeList = "&index="
If (MM_paramName <> "") Then
  MM_removeList = MM_removeList & "&" & MM_paramName & "="
End If

MM_keepURL=""
MM_keepForm=""
MM_keepBoth=""
MM_keepNone=""

' add the URL parameters to the MM_keepURL string
For Each MM_item In Request.QueryString
  MM_nextItem = "&" & MM_item & "="
  If (InStr(1,MM_removeList,MM_nextItem,1) = 0) Then
    MM_keepURL = MM_keepURL & MM_nextItem & Server.URLencode(Request.QueryString(MM_item))
  End If
Next

' add the Form variables to the MM_keepForm string
For Each MM_item In Request.Form
  MM_nextItem = "&" & MM_item & "="
  If (InStr(1,MM_removeList,MM_nextItem,1) = 0) Then
    MM_keepForm = MM_keepForm & MM_nextItem & Server.URLencode(Request.Form(MM_item))
  End If
Next

' create the Form + URL string and remove the intial '&' from each of the strings
MM_keepBoth = MM_keepURL & MM_keepForm
If (MM_keepBoth <> "") Then 
  MM_keepBoth = Right(MM_keepBoth, Len(MM_keepBoth) - 1)
End If
If (MM_keepURL <> "")  Then
  MM_keepURL  = Right(MM_keepURL, Len(MM_keepURL) - 1)
End If
If (MM_keepForm <> "") Then
  MM_keepForm = Right(MM_keepForm, Len(MM_keepForm) - 1)
End If

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

Dim MM_keepMove
Dim MM_moveParam
Dim MM_moveFirst
Dim MM_moveLast
Dim MM_moveNext
Dim MM_movePrev

Dim MM_urlStr
Dim MM_paramList
Dim MM_paramIndex
Dim MM_nextParam

MM_keepMove = MM_keepBoth
MM_moveParam = "index"

' if the page has a repeated region, remove 'offset' from the maintained parameters
If (MM_size > 1) Then
  MM_moveParam = "offset"
  If (MM_keepMove <> "") Then
    MM_paramList = Split(MM_keepMove, "&")
    MM_keepMove = ""
    For MM_paramIndex = 0 To UBound(MM_paramList)
      MM_nextParam = Left(MM_paramList(MM_paramIndex), InStr(MM_paramList(MM_paramIndex),"=") - 1)
      If (StrComp(MM_nextParam,MM_moveParam,1) <> 0) Then
        MM_keepMove = MM_keepMove & "&" & MM_paramList(MM_paramIndex)
      End If
    Next
    If (MM_keepMove <> "") Then
      MM_keepMove = Right(MM_keepMove, Len(MM_keepMove) - 1)
    End If
  End If
End If

' set the strings for the move to links
If (MM_keepMove <> "") Then 
  MM_keepMove = MM_keepMove & "&"
End If

MM_urlStr = Request.ServerVariables("URL") & "?" & MM_keepMove & MM_moveParam & "="

MM_moveFirst = MM_urlStr & "0"
MM_moveLast  = MM_urlStr & "-1"
MM_moveNext  = MM_urlStr & CStr(MM_offset + MM_size)
If (MM_offset - MM_size < 0) Then
  MM_movePrev = MM_urlStr & "0"
Else
  MM_movePrev = MM_urlStr & CStr(MM_offset - MM_size)
End If
%>

<html>
<head>
<title>Affiliate page</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<script language="JavaScript">
<!--

function MM_findObj(n, d) { //v4.01
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && d.getElementById) x=d.getElementById(n); return x;
}

function YY_checkform() { //v4.07
//copyright (c)1998,2001 Yaromat.com
  var args = YY_checkform.arguments,myDot=true,myV='',myErr='',addErr=false,myReq,rx,myObj1,myMa,myAt;
  for (var i=1; i<args.length;i=i+4){
    if (args[i+1].charAt(0)=='#'){myReq=true; args[i+1]=args[i+1].substring(1);}else{myReq=false}
    var myObj = MM_findObj(args[i].replace(/\[\d+\]/ig,""));myV=myObj.value;
    if (myObj.type=='text'||myObj.type=='password'){
      if (myReq&&myObj.value.length==0)addErr=true;
      if ((myV.length>0)&&(args[i+2]==1)){ //fromto
        if (!(myV/1)||myV<args[i+1].split('_')[0]/1||myV > args[i+1].split('_')[1]/1){addErr=true}
      }
      if ((myV.length>0)&&(args[i+2]==2)){ // email
            rx=new RegExp("^[\\w\.=-]+@[\\w\\.-]+\\.[a-z]{2,4}$");if(!rx.test(myV))addErr=true;
          }
      if ((myV.length>0)&&(args[i+2]==3)){ // date
        myMa=args[i+1].split("#");myAt=myV.match(myMa[0]);
        if(myAt){
          var myD=(myAt[myMa[1]])?myAt[myMa[1]]:1; var myM=myAt[myMa[2]]-1; var myY=myAt[myMa[3]];
          var myDate=new Date(myY,myM,myD);
          if(myDate.getFullYear()!=myY||myDate.getDate()!=myD||myDate.getMonth()!=myM){addErr=true};
        }else{addErr=true}
      }
      if ((myV.length>0)&&(args[i+2]==4)){myMa=args[i+1].split("#");myAt=myV.match(myMa[0]);if(!myAt)addErr=true}// time
      if (myV.length>0&&args[i+2]==5){ // check this 2
        var myObj1 = MM_findObj(args[i+1].replace(/\[\d+\]/ig,""));
        if(myObj1.length)myObj1=myObj1[args[i+1].replace(/(.*\[)|(\].*)/ig,"")];
        if(!myObj1.checked)addErr=true;
      }
      if (myV.length>0&&args[i+2]==6){myObj1=MM_findObj(args[i+1]);if(myV!=myObj1.value)addErr=true;}// the same
    }else
    if (!myObj.type&&myObj.length>0&&myObj[0].type=='radio'){
          var myTest = args[i].match(/(.*)\[(\d+)\].*/i);
          var myObj1=(myObj.length>1)?myObj[myTest[2]]:myObj;
      if (args[i+2]==1&&myObj1&&myObj1.checked&&MM_findObj(args[i+1]).value.length/1==0){addErr=true}
      if (args[i+2]==2){
        var myDot=false;
        for(var j=0;j<myObj.length;j++){myDot=myDot||myObj[j].checked}
        if(!myDot){myErr+='* ' +args[i+3]+'\n'}
      }
    }else
    if (myObj.type=='checkbox'){
      if(args[i+2]==1&&myObj.checked==false){addErr=true}
      if(args[i+2]==2&&myObj.checked&&MM_findObj(args[i+1]).value.length/1==0){addErr=true}
    }else
    if (myObj.type=='select-one'||myObj.type=='select-multiple'){
      if(args[i+2]==1&&myObj.selectedIndex/1==0){addErr=true}
    }else
    if (myObj.type=='textarea'){
      if(myV.length<args[i+1]){addErr=true}
    }
    if (addErr){myErr+='* '+args[i+3]+'\n'; addErr=false}
  }
  if (myErr!=''){alert('The required information is incomplete or contains errors:\t\t\t\t\t\n\n'+myErr)}
  document.MM_returnValue = (myErr=='');
}
//-->
</script>
<style type="text/css">
<!--
a:hover {
	color: #FFFFFF;
}
-->
</style>
</head>
<body bgcolor="#66CC99" text="#000000">
<center>
</center>
<div align="center"> 
  <p><img src="logo.gif" width="355" height="50"> </p>
  <p>
    <% If (Session("Email")) = ("") Then 'script %>
  </p>
</div>
<table width="600" border="0" cellspacing="20" cellpadding="0" align="center">
  <tr valign="top"> 
	<td width="50%"> 
	  <p><font face="Verdana, Arial, Helvetica, sans-serif" size="1">*********Replace 
		with your text***********</font></p>
	  <p>&nbsp;</p>
	  <p align="center">************************</p>
	  <table width="100%" border="0" cellspacing="0" cellpadding="0" bgcolor="#CCCCCC">
		<tr> 
		  <td><b><font face="Verdana, Arial, Helvetica, sans-serif" size="1">Sign 
			up today.....it won't cost you anything.</font></b></td>
		</tr>
	  </table>
	  <form name="form1" method="POST" action="<%=MM_editAction%>" onSubmit="YY_checkform('form1','register1','#q','0','Please enter a vaild name.','register2','#','2','Please enter a valid email address.');return document.MM_returnValue">
        <table border="0" cellspacing="1" cellpadding="2" width="80%" align="center" bgcolor="#000000">
          <tr> 
            <td nowrap width="50" align="right" bgcolor="#6699CC"><font face="Verdana, Arial, Helvetica, sans-serif" size="1">Name:</font></td>
            <td bgcolor="#0099CC"> <input type="text" name="Name" id="register1"> 
            </td>
          </tr>
          <tr> 
            <td nowrap width="50" align="right" bgcolor="#6699CC"><font face="Verdana, Arial, Helvetica, sans-serif" size="1">Email:</font></td>
            <td bgcolor="#0099CC"> <input type="text" name="Email" id="register2"> 
            </td>
          </tr>
          <tr> 
            <td width="50" nowrap align="right" bgcolor="#6699CC"><b><font face="Verdana, Arial, Helvetica, sans-serif" size="1"></font></b></td>
            <td bgcolor="#0099CC"> <input type="submit" name="Submit" value="Register"> 
            </td>
          </tr>
        </table>
        <input type="hidden" name="MM_insert" value="form1">
      </form>
	  <p>&nbsp;</p>
	  <table width="100%" border="0" cellspacing="0" cellpadding="0" bgcolor="#CCCCCC">
		<tr> 
		  <td><b><font face="Verdana, Arial, Helvetica, sans-serif" size="1">Affiliate 
			area:</font></b></td>
		</tr>
	  </table>
	  <p><font face="Verdana, Arial, Helvetica, sans-serif" size="1">Log in below 
		to check your current commission due and retrieve your affiliate links.</font></p>
	  <form name="form2" method="post" action="" onSubmit="YY_checkform('form2','login','#','2','Please enter a valid email address.');return document.MM_returnValue">
		<table width="80%" border="0" cellspacing="1" cellpadding="2" align="center" bgcolor="#000000">
		  <tr> 
			<td width="50" align="right" bgcolor="#6699CC"><font face="Verdana, Arial, Helvetica, sans-serif" size="1">Email:</font></td>
			<td bgcolor="#0099CC"> 
			  <input type="text" name="Email" id="login">
			</td>
		  </tr>
		  <tr> 
			<td width="50" bgcolor="#6699CC">&nbsp;</td>
			<td bgcolor="#0099CC"> 
			  <input type="submit" name="Submit2" value="Login">
			</td>
		  </tr>
		</table>
	  </form>
	  <p>&nbsp;</p>
	</td>
	<td width="50%"> 
	  <p align="center"><img src="oldman.gif" width="215" height="305"></p>
	  
	</td>
  </tr>
</table>
<% End If ' end If (Request("Email")) = ("") script %>
<% If (Session("Email")) <> ("") Then 'script %>
<table width="600" border="0" cellspacing="20" cellpadding="0" align="center">
  <tr> 
	<td width="50%" valign="top"> 
	  <p><font face="Verdana, Arial, Helvetica, sans-serif" size="1">Welcome <%=(rsaffiliate.Fields.Item("Name").Value)%>,</font></p>
	  <p><font face="Verdana, Arial, Helvetica, sans-serif" size="1">Total clickthroughs: 
		</font><font face="Verdana, Arial, Helvetica, sans-serif" size="2"><b><%=(rsaffiliate.Fields.Item("Hits").Value)%></b></font></p>
	  <p><font face="Verdana, Arial, Helvetica, sans-serif" size="1">Your commissions 
		due are= <font size="2"><b>$<%=(rsaffiliate.Fields.Item("Earned").Value)%></b></font></font></p>
	  <div align="left"><font size="1" face="Verdana, Arial, Helvetica, sans-serif">Sales 
        history</font> </div>
      <table width="150" border="0" align="center" cellpadding="1" cellspacing="0">
        <tr> 
          <td><div align="center"><b><font size="1" face="Verdana, Arial, Helvetica, sans-serif">Totals</font></b></div></td>
          <td><div align="center"><b><font size="1" face="Verdana, Arial, Helvetica, sans-serif">Date</font></b></div></td>
        </tr>
        <% 
While ((Repeat1__numRows <> 0) AND (NOT Query.EOF)) 
%>
        <tr> 
          <td width="0"><div align="center"><font size="1" face="Arial, Helvetica, sans-serif">$<%=(Query.Fields.Item("SumOfEarned").Value)%></font></div></td>
          <td width="0"><div align="center"><font size="1" face="Arial, Helvetica, sans-serif"><%=(Query.Fields.Item("Date").Value)%></font></div></td>
        </tr>
        <% 
  Repeat1__index=Repeat1__index+1
  Repeat1__numRows=Repeat1__numRows-1
  Query.MoveNext()
Wend
%>
      </table>
      <br>
      <table border="0" width="50%" align="center">
        <tr> 
          <td width="23%" align="center"> <font size="1" face="Verdana, Arial, Helvetica, sans-serif"> 
            <% If MM_offset <> 0 Then %>
            <a href="<%=MM_moveFirst%>">First</a> 
            <% End If ' end MM_offset <> 0 %>
            </font></td>
          <td width="31%" align="center"> <font size="1" face="Verdana, Arial, Helvetica, sans-serif"> 
            <% If MM_offset <> 0 Then %>
            <a href="<%=MM_movePrev%>">Previous</a> 
            <% End If ' end MM_offset <> 0 %>
            </font></td>
          <td width="23%" align="center"> <font size="1" face="Verdana, Arial, Helvetica, sans-serif"> 
            <% If Not MM_atTotal Then %>
            <a href="<%=MM_moveNext%>">Next</a> 
            <% End If ' end Not MM_atTotal %>
            </font></td>
          <td width="23%" align="center"> <font size="1" face="Verdana, Arial, Helvetica, sans-serif"> 
            <% If Not MM_atTotal Then %>
            <a href="<%=MM_moveLast%>">Last</a> 
            <% End If ' end Not MM_atTotal %>
            </font></td>
        </tr>
      </table>
      <p align="center">&nbsp;</p>
	  <table width="100%" border="0" cellspacing="0" cellpadding="1" bgcolor="#CCCCCC">
		<tr> 
		  <td><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><b>Your 
			linking codes:</b></font></td>
		</tr>
	  </table>
	  <p><font face="Verdana, Arial, Helvetica, sans-serif" size="1">Use the following 
        Url to promote our products.</font></p>
	  <p><font face="Verdana, Arial, Helvetica, sans-serif" size="1" color="#FFFFFF"><%=(Admin.Fields.Item("URL").Value)%>?Affid=<%=(rsaffiliate.Fields.Item("AffID").Value)%></font></p>
	  <p align="center">&nbsp;</p>
	  <p><font face="Verdana, Arial, Helvetica, sans-serif" size="1">Enjoy, and 
		good luck!</font></p>
	  <p align="left"><font face="Verdana, Arial, Helvetica, sans-serif" size="1">//Webmaster</font></p>
	  <p align="center">&nbsp;</p>
	  </td>
	<td width="50%" valign="top">
	  <center>
		<img src="oldman.gif" width="215" height="305">
	  </center>
	</td>
  </tr>
</table>
<% End If ' end If (Request("Email")) <> ("") script %>
<center>
  <center>
    <img src="horizontalBar.gif" width="650" height="1"> 
  </center>
  <p align="center"><font face="Verdana, Arial, Helvetica, sans-serif" size="1">'My 
    ASP Affiliate Program' is a product of <a href="http://www.kattouf.com/">Kattouf 
    Internet Services</a> <br>
    Made in Sweden<br>
    | <a href="mailto:johnny@kattouf.com">Contact me</a> |</font></p>
</center>
<p>&nbsp;</p>
</body>
</html>
<%
IF Session("email") <> "" Then
rsaffiliate.Close()
Query.Close()
Set Query = Nothing
END IF
%>
<%
Admin.Close()
Set Admin = Nothing
%>
<%

%>

