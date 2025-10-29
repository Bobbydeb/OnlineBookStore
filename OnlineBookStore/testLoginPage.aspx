<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="testLoginPage.aspx.cs" Inherits="OnlineBookStore.testLoginPage" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Test Login</title>
    <style>
        body { font-family: Arial, sans-serif; display: grid; place-items: center; min-height: 100vh; background-color: #f0f2f5; }
        div { background: #fff; padding: 2rem; border-radius: 8px; box-shadow: 0 4px 12px rgba(0,0,0,0.1); text-align: center; }
        h2 { margin-top: 0; }
        span { display: block; margin-bottom: 1rem; }
        input[type="text"] { padding: 0.5rem; border-radius: 4px; border: 1px solid #ccc; margin-right: 0.5rem; }
        input[type="submit"] { padding: 0.5rem 1rem; background-color: #007bff; color: white; border: none; border-radius: 4px; cursor: pointer; }
        input[type="submit"]:hover { background-color: #0056b3; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <h2>Developer Test Login</h2>
            <span>Enter a MemberID from your database (e.g., 1) to log in.</span>
            <asp:TextBox ID="txtMemberId" runat="server" Text="1" type="number"></asp:TextBox>
            <asp:Button ID="btnTestLogin" runat="server" Text="Log In as Member" OnClick="btnTestLogin_Click" />
        </div>
    </form>
</body>
</html>
