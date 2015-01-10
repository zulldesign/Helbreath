<%@ Page Language="VB" %>
<!-- #INCLUDE FILE="include.aspx" -->
<style>
	.myfont {
		background-color : White;
		font-family : Arial, Helvetica, sans-serif;
	}
</style>
<script language="VB" runat="server">
    Sub Page_Load(sender As Object, e As EventArgs)
	if request.querystring("logout") = 1 then
		session.abandon
		response.redirect("login.aspx")
	end if
	End Sub
	
	Sub btnLogin_OnClick(Src As Object, E As EventArgs)
		If txtUsername.Text = user And txtPassword.Text = pass
			''FormsAuthentication.RedirectFromLoginPage(txtUsername.Text, True)
			session("loggedin") = "true"
			response.redirect("list.aspx")
		Else
			lblInvalid.Text = "Login Failed"
		End If
	End Sub
</script>

<html>
<head>
<title>Login</title>
</head>
<body class="myfont">

<h2>Please Login</h2>

<p>
<asp:Label Id="lblInvalid" RunAt="server" Style="color: Red;" />
</p>

<form runat="server">
<table>
	<tr>
		<td>Username:</td>
		<td><asp:TextBox id="txtUsername" runat="server" size="11" class="myfont" /></td>
	</tr>
	<tr>
		<td>Password:</td>
		<td><asp:TextBox id="txtPassword" TextMode="password" runat="server" size="12" class="myfont" /></td>
	</tr>
</table>
	<asp:Button id="btnLogin" runat="server" text="Login" OnClick="btnLogin_OnClick" class="myfont" />
</form>

</body>
</html>


