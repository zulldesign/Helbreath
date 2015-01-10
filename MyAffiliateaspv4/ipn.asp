<%@LANGUAGE="VBScript"%>

<!--#include file="connections/affiliate.asp" -->

<%
IF Request.Form("custom") <> ""  THEN 

'Declare our variables we will be receiving
Dim str, OrderID, payment_status, Txn_id, payer_email, amount_paid 
Dim objHttp
Dim AFFID 


'Request the variables we declare above from PayPal
str = Request.Form
OrderID = Request.Form("item_number")
payment_status = Request.Form("payment_status")
Txn_id = Request.Form("txn_id")
payer_email = Request.Form("payer_email")
amount_paid = Request.Form("mc_gross")
AFFID = Request.Form("custom")


' Post back to PayPal system to validate
str = str & "&cmd=_notify-validate"
set objHttp = Server.CreateObject("Msxml2.XMLHTTP")
objHttp.open "POST", "https://www.paypal.com/cgi-bin/webscr", false
objHttp.Send str

' Check notification validation
if (objHttp.status <> 200 ) then
' HTTP error handling
'Now we see if the payment is pending, verified, or denied 
elseif (objHttp.responseText =  "VERIFIED"  OR objHttp.responseText = "PENDING") AND payment_status = "Completed" THEN


set rsAdmin = Server.CreateObject("ADODB.Recordset")
rsAdmin.ActiveConnection = MM_affiliate_STRING
rsAdmin.Source = "SELECT TOP 1 *  FROM Admin"
rsAdmin.CursorType = 0
rsAdmin.CursorLocation = 2
rsAdmin.LockType = 3
rsAdmin.Open()
rsAdmin_numRows = 0

Dim Earnedamount

If rsAdmin.Fields.Item("Percentage").Value = "True" Then
'For percentage use this:
'Example below is for 25% commission
Earnedamount = amount_paid * rsAdmin.Fields.Item("percentrate").Value

Else
'For fixed commission use this:
Earnedamount = rsAdmin.Fields.Item("Fixedrate").Value

End IF

set cmAffiliate = Server.CreateObject("ADODB.Command")
cmAffiliate.ActiveConnection = MM_affiliate_STRING
cmAffiliate.CommandText = "UPDATE affiliates SET Earned = Earned + "& Earnedamount &"  WHERE AffID = " + AFFID + ""
cmAffiliate.CommandType = 1
cmAffiliate.CommandTimeout = 0
cmAffiliate.Prepared = true
cmAffiliate.Execute()

set Command1 = Server.CreateObject("ADODB.Command")
Command1.ActiveConnection = MM_affiliate_STRING
Command1.CommandText = "INSERT INTO Commission (AffID, Earned)  VALUES (" + AFFID + "," & Earnedamount & ") "
Command1.CommandType = 1
Command1.CommandTimeout = 0
Command1.Prepared = true
Command1.Execute()

set rsaffiliates = Server.CreateObject("ADODB.Recordset")
rsaffiliates.ActiveConnection = MM_affiliate_STRING
rsaffiliates.Source = "SELECT *  FROM Affiliates WHERE AffID = " + AFFID
rsaffiliates.CursorType = 0
rsaffiliates.CursorLocation = 2
rsaffiliates.LockType = 3
rsaffiliates.Open()
rsaffiliates_numRows = 0

Dim objCDO

Set objCDO = Server.CreateObject("CDONTS.NewMail")
objCDO.From = rsAdmin.Fields.Item("Email").Value
objCDO.To = rsaffiliates.Fields.Item("Email").Value
objCDO.Subject = "You have made a sale!"
objCDO.BodyFormat = 0 
objCDO.MailFormat = 0 
objCDO.Body = HTML
objCDO.Body = "<html>" & vbCrLf & "<head>" & vbCrLf & "<title>Untitled Document</title>" & vbCrLf & "<meta http-equiv=" & Chr(34) & "Content-Type" & Chr(34) & " content=" & Chr(34) & "text/html; charset=iso-8859-1" & Chr(34) & ">" & vbCrLf & "</head>" & vbCrLf & vbCrLf & "<body>" & vbCrLf & "<p>Congratulations " & rsaffiliates.Fields.Item("Name").Value & ",</p>" & vbCrLf & "<p>You have made a sale! </p>" & vbCrLf & "<p>This sale has earned you: $" & Earnedamount & "</p>" & vbCrLf & "<p>Thank you for promoting our products. </p>" & vbCrLf & "<p>Regards, </p>" & vbCrLf & "<p>/Webmaster </p>" & vbCrLf & "<p>" & rsadmin.Fields.Item("url").Value & "</p>" & vbCrLf & "<p> </p>" & vbCrLf & "</body>" & vbCrLf & "</html>" & vbCrLf
objCDO.Send()
Set objCDO = Nothing

rsAdmin.Close()
Set rsAdmin = Nothing
rsaffiliates.Close()
Set rsaffiliates = Nothing


END IF
END IF
%>


<html>
<head>
<title>IPN Verification</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>

<body bgcolor="#FFFFFF" text="#000000">
This page does some very 
complex stuff. 

</body>
</html>

