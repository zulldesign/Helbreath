<%@LANGUAGE="VBSCRIPT"%>
<!--#include file="Connections/affiliate.asp" -->
<%
' *** Set A Cookie Before Page Loads
' *** MagicBeat Server Behavior - 2010 - by Jag S. Sidhu - www.magicbeat.com
IF Request.Querystring("Affid") <> "" THEN
Response.Cookies("Affidcookie") = Request.Querystring("Affid")
Response.Cookies("Affidcookie").Expires = Date + 30
END IF
%>

<%
If(Request.Querystring("Affid") <> "") then 

cmAffiliate__MMAffid = Request.Querystring("Affid") 


set hits = Server.CreateObject("ADODB.Recordset")
hits.ActiveConnection = MM_affiliate_STRING
hits.Source = "SELECT * FROM Hits WHERE HitIP='" & Request.ServerVariables("REMOTE_ADDR") & "' AND HitDate=#" & DATE() & "#" 
hits.CursorType = 0
hits.CursorLocation = 2
hits.LockType = 3
hits.Open()
rshits_numRows = 0

IF hits.EOF AND hits.BOF THEN 



set Command1 = Server.CreateObject("ADODB.Command")
Command1.ActiveConnection = MM_affiliate_STRING
Command1.CommandText = "INSERT INTO Hits (HitIP, HitDate)  VALUES ('" + Request.ServerVariables("Remote_Addr") + "',#" & Date() & "#) "
Command1.CommandType = 1
Command1.CommandTimeout = 0
Command1.Prepared = true
Command1.Execute()


set cmAffiliate = Server.CreateObject("ADODB.Command")
cmAffiliate.ActiveConnection = MM_affiliate_STRING
cmAffiliate.CommandText = "UPDATE affiliates  SET Hits = Hits + 1  WHERE AffID = " + Replace(cmAffiliate__MMAffid, "'", "''") + ""
cmAffiliate.CommandType = 1
cmAffiliate.CommandTimeout = 0
cmAffiliate.Prepared = true
cmAffiliate.Execute()


hits.Close()

END IF
END IF

%>
<!--'My ASP Affiliate Program' is a product of Kattouf Internet Services.
Url: http://www.kattouf.com
Email: johnny@kattouf.com
 -->