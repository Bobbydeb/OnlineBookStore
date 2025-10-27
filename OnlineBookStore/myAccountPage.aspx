<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="myAccountPage.aspx.cs" Inherits="OnlineBookStore.myAccountPage" %>

<!DOCTYPE html>
<html lang="th">
<head runat="server">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Bookstore</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 0; background-color: #f0f2f5; color: #333; }
        a { text-decoration: none; color: inherit; }
        .container { width: 90%; max-width: 1200px; margin: 0 auto; }
        .top-header { background-color: #fff; padding: 10px 0; border-bottom: 1px solid #ddd; }
        .top-header .container { display: flex; justify-content: space-between; align-items: center; }
        .logo { font-size: 1.5rem; font-weight: bold; color: #d90000; }
        .search-bar { flex-grow: 1; margin: 0 20px; }
        .search-bar input { width: 100%; max-width: 400px; padding: 8px 40px 8px 12px; border: 1px solid #ccc; border-radius: 20px; }
        .header-icons { display: flex; gap: 15px; font-size: 0.95rem; }
        .main-nav { background-color: #333; color: #fff; padding: 6px 0; }
        .main-nav .container { display: flex; justify-content: center; align-items: center; }
        .main-nav ul { list-style: none; margin: 0; padding: 0; display: flex; gap: 10px; flex-wrap: wrap; justify-content: center; }
        .main-nav li a { padding: 6px 10px; font-size: 0.9rem; display: block; border-radius: 5px; transition: background-color 0.2s; color: #fff; }
        .main-nav li a:hover { background-color: #555; }
        .dropdown-content { display: none; position: absolute; top: 100%; left: 0; background-color: #444; min-width: 200px; border-radius: 6px; padding: 8px 0; box-shadow: 0 6px 16px rgba(0,0,0,0.2); }
        .dropdown-content a { padding: 8px 14px; font-size: 0.9rem; display: block; color: #fff; }
        .dropdown-content a:hover { background-color: #555; }
        .dropdown:hover .dropdown-content { display: block; }
        main { padding: 20px 0; }
        .section-title { font-size: 1.8rem; font-weight: bold; margin: 20px 0; color: #111; }
    </style>
</head>
<body>
    <form id="form1" runat="server">

        <header class="top-header">
            <div class="container">
                <div class="logo">MyBookstore</div>
                <div class="search-bar">
                    <input type="text" placeholder="ค้นหาหนังสือ...">
                </div>
                <div class="header-icons">
 

                    <asp:LinkButton ID="btnLogin" runat="server" PostBackUrl="~/loginPage.aspx">
                        👤 Login
                    </asp:LinkButton>

                    <asp:LinkButton ID="btnLogout" runat="server" OnClick="btnLogout_Click" ForeColor="Red" Visible="false">
                        ⏻ Logout
                    </asp:LinkButton>
                </div>

            </div>
        </header>

        <nav class="main-nav">
            <div class="container">
                <ul>
                    <li><a href="mainpage.aspx">หน้าแรก</a></li>
                    <li><a href="topSalePage.aspx">หนังสือขายดี</a></li>
                    <li class="dropdown">
                        <a href="#">หมวดหมู่ ▼</a>
                        <div class="dropdown-content">
                            <a href="#">Fiction</a>
                            <a href="#">Non-fiction</a>
                            <a href="#">Children’s Books</a>
                            <a href="#">Education / Academic</a>
                            <a href="#">Comics / Graphic Novels / Manga</a>
                            <a href="#">Art / Design / Photography</a>
                            <a href="#">Religion / Spirituality</a>
                            <a href="#">Science / Technology</a>
                            <a href="#">Business / Economics</a>
                            <a href="#">Cookbooks / Lifestyle</a>
                            <a href="#">Poetry / Drama</a>
                        </div>
                    </li>
                    <li><a href="myAccountPage.aspx">บัญชีของฉัน</a></li>
                    <li><a href="#">ตะกร้าสินค้า</a></li>
                </ul>
            </div>
        </nav>

        <main class="container">
            <h2 class="section-title">บัญชีของฉัน</h2>
            <p><asp:Label ID="lblUserInfo" runat="server" /></p>
        </main>

    </form>
</body>
</html>
