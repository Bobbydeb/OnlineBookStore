<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="loginPage.aspx.cs" Inherits="OnlineBookStore.loginPage" %>

<!DOCTYPE html>
<html lang="th">
<head runat="server">
    <meta charset="UTF-8" />
    <title>Online Bookstore Login</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #fef2f2;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }

        .login-container {
            background-color: #fff;
            padding: 2.5rem;
            border-radius: 1rem;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            width: 380px;
            border: 1px solid #fecaca;
        }

        .icon {
            display: flex;
            justify-content: center;
            color: #dc2626;
            font-size: 40px;
            margin-bottom: 10px;
        }

        h1 {
            text-align: center;
            color: #b91c1c;
            margin-bottom: 30px;
            font-size: 1.6rem;
        }

        label {
            display: block;
            margin-bottom: 6px;
            color: #374151;
            font-weight: 600;
            font-size: 0.9rem;
        }

        .input-group {
            display: flex;
            align-items: center;
            border: 1px solid #d1d5db;
            border-radius: 10px;
            padding: 6px 10px;
            margin-bottom: 15px;
            transition: box-shadow 0.2s;
        }

        .input-group:focus-within {
            box-shadow: 0 0 0 2px #ef4444;
        }

        .input-group span {
            color: #9ca3af;
            margin-right: 6px;
            font-size: 16px;
        }

        input[type="text"], input[type="password"] {
            border: none;
            outline: none;
            width: 100%;
            padding: 8px;
            font-size: 0.95rem;
        }

        .btn-login {
            width: 100%;
            background-color: #dc2626;
            color: white;
            border: none;
            padding: 10px;
            font-size: 1rem;
            border-radius: 10px;
            cursor: pointer;
            transition: background-color 0.2s;
        }

        .btn-login:hover {
            background-color: #b91c1c;
        }

        .msg {
            text-align: center;
            color: red;
            margin-top: 15px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="login-container">
            <div class="icon">📖</div>
            <h1>Online Bookstore Login</h1>

            <label for="txtEmail">Email</label>
            <div class="input-group">
                <span>👤</span>
                <asp:TextBox ID="txtEmail" runat="server" placeholder="Enter your email" />
            </div>

            <label for="txtPassword">Password</label>
            <div class="input-group">
                <span>🔒</span>
                <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" placeholder="Enter your password" />
            </div>

            <asp:Button ID="btnLogin" runat="server" Text="Login" CssClass="btn-login" OnClick="btnLogin_Click" />
            <asp:Label ID="lblMessage" runat="server" CssClass="msg" />
        </div>
    </form>
</body>
</html>
