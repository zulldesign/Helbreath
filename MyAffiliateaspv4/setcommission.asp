<%@LANGUAGE="VBSCRIPT"%>
<!--#include file="Connections/affiliate.asp" -->

<% IF Session("Affidsession") = "" THEN



Session("Affidsession") = (Request.Cookies("Affidcookie"))



if(Session("Affidsession") <> "") then cmAffiliate__MMAffid = Session("Affidsession") 



IF NOT Session("Affidsession") = "" THEN

set rsAdmin = Server.CreateObject("ADODB.Recordset")
rsAdmin.ActiveConnection = MM_affiliate_STRING
rsAdmin.Source = "SELECT TOP 1 *  FROM Admin"
rsAdmin.CursorType = 0
rsAdmin.CursorLocation = 2
rsAdmin.LockType = 3
rsAdmin.Open()
rsAdmin_numRows = 0

set rsaffiliates = Server.CreateObject("ADODB.Recordset")
rsaffiliates.ActiveConnection = MM_affiliate_STRING
rsaffiliates.Source = "SELECT *  FROM Affiliates WHERE AffID = " + cmAffiliate__MMAffid
rsaffiliates.CursorType = 0
rsaffiliates.CursorLocation = 2
rsaffiliates.LockType = 3
rsaffiliates.Open()
rsaffiliates_numRows = 0

Dim Earnedamount
Earnedamount = rsAdmin.Fields.Item("Fixedrate").Value

set cmAffiliate = Server.CreateObject("ADODB.Command")
cmAffiliate.ActiveConnection = MM_affiliate_STRING
cmAffiliate.CommandText = "UPDATE affiliates SET Earned = Earned + "&Earnedamount&"  WHERE AffID = " + Replace(cmAffiliate__MMAffid, "'", "''") + ""
cmAffiliate.CommandType = 1
cmAffiliate.CommandTimeout = 0
cmAffiliate.Prepared = true
cmAffiliate.Execute()

set Command1 = Server.CreateObject("ADODB.Command")
Command1.ActiveConnection = MM_affiliate_STRING
Command1.CommandText = "INSERT INTO Commission (AffID, Earned)  VALUES (" + cmAffiliate__MMAffid + "," & Earnedamount & ") "
Command1.CommandType = 1
Command1.CommandTimeout = 0
Command1.Prepared = true
Command1.Execute()

Dim objCDO

Set objCDO = Server.CreateObject("CDONTS.NewMail")
objCDO.From = rsAdmin.Fields.Item("Email").Value
objCDO.To = rsaffiliates.Fields.Item("Email").Value
objCDO.Subject = "You have made a sale!"
objCDO.BodyFormat = 0 
objCDO.MailFormat = 0 
objCDO.Body = HTML
objCDO.Body = "<html>" & vbCrLf & "<head>" & vbCrLf & "<title>Untitled Document</title>" & vbCrLf & "<meta http-equiv=" & Chr(34) & "Content-Type" & Chr(34) & " content=" & Chr(34) & "text/html; charset=iso-8859-1" & Chr(34) & ">" & vbCrLf & "</head>" & vbCrLf & vbCrLf & "<body>" & vbCrLf & "<p>Congratulations " & rsaffiliates.Fields.Item("Name").Value & ",</p>" & vbCrLf & "<p>You have made a sale! </p>" & vbCrLf & "<p>This sale has earned you: $" & rsadmin.Fields.Item("fixedrate").Value & "</p>" & vbCrLf & "<p>Thank you for promoting our products. </p>" & vbCrLf & "<p>Regards, </p>" & vbCrLf & "<p>/Webmaster </p>" & vbCrLf & "<p>" & rsadmin.Fields.Item("url").Value & "</p>" & vbCrLf & "<p> </p>" & vbCrLf & "</body>" & vbCrLf & "</html>" & vbCrLf
objCDO.Send()
Set objCDO = Nothing


rsAdmin.Close()
Set rsAdmin = Nothing
rsaffiliates.Close()
Set rsaffiliates = Nothing

END IF


END IF %>
