<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="mainpage.aspx.cs" Inherits="OnlineBookStore.mainpage" %>

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

        /* Header */
        .top-header { background-color: #fff; padding: 10px 0; border-bottom: 1px solid #ddd; }
        .top-header .container { display: flex; justify-content: space-between; align-items: center; }
        .logo { font-size: 1.5rem; font-weight: bold; color: #d90000; }
        
        /* [แก้ไข] CSS สำหรับ Search Bar */
        .search-bar { flex-grow: 1; margin: 0 20px; display: flex; }
        .search-input { /* ใช้แทน input เดิม */
            width: 100%; 
            max-width: 400px; 
            padding: 8px 12px; 
            border: 1px solid #ccc; 
            border-radius: 20px 0 0 20px; /* ด้านซ้ายโค้ง */
            border-right: none;
            /* ทำให้ font-size และ family ตรงกับปุ่ม */
            font-size: 1rem; 
            font-family: Arial, sans-serif;
        }
        .search-button { /* ปุ่มค้นหา */
            padding: 8px 12px;
            border: 1px solid #ccc;
            border-radius: 0 20px 20px 0; /* ด้านขวาโค้ง */
            background-color: #f0f0f0;
            cursor: pointer;
            font-size: 0.9rem;
        }
        .search-button:hover { background-color: #e0e0e0; }

        .header-icons { display: flex; gap: 15px; font-size: 0.95rem; }

        /* Nav */
        .main-nav {
            background-color: #333;
            color: #fff;
            padding: 6px 0;
            position: relative;   /* จุดอ้างอิงของ dropdown */
            z-index: 10;
        }
        .main-nav .container { display: flex; justify-content: center; align-items: center; }
        .main-nav ul { list-style: none; margin: 0; padding: 0; display: flex; gap: 10px; flex-wrap: wrap; justify-content: center; }
        .main-nav li { position: relative; }
        .main-nav li a { padding: 6px 10px; font-size: 0.9rem; display: block; border-radius: 5px; transition: background-color 0.2s; color: #fff; }
        .main-nav li a:hover { background-color: #555; }

        /* Dropdown (CSS ที่ถูกต้องชุดเดียว) */
        .main-nav li.dropdown { position: relative; } /* ทำให้เจาะจงมากขึ้น */
        .main-nav .dropdown-content {
            display: none;
            position: absolute;
            top: 100%;               
            left: 0;
            background-color: #444;
            min-width: 200px;
            border-radius: 6px;
            padding: 8px 0;
            box-shadow: 0 6px 16px rgba(0,0,0,0.2);
            z-index: 999;
        }
        .main-nav .dropdown-content li a {
            padding: 8px 14px;
            font-size: 0.9rem;
            display: block;
            color: #fff;
        }
        .main-nav .dropdown-content li a:hover { background-color: #555; }
        .main-nav li.dropdown:hover .dropdown-content { display: block; } /* ทำให้เจาะจงมากขึ้น */

        /* Content */
        main { padding: 20px 0; }
        .section-title { font-size: 1.8rem; 
                         font-weight: bold; 
                         margin: 20px 0; 
                         color: #111; 
        }
        .book-grid { 
            display: grid; 
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); 
            gap: 20px; 
        }
        .book-card { 
            background-color: #fff; 
            border: 1px solid #e0e0e0; 
            border-radius: 8px; 
            overflow: hidden; 
            box-shadow: 0 2px 5px rgba(0,0,0,0.05); 
            transition: transform 0.3s, box-shadow 0.3s; 
            display: flex; 
            flex-direction: column;
        }
        .book-card:hover { 
            transform: translateY(-4px);             
            box-shadow: 0 4px 12px rgba(0,0,0,0.1); 
        }
        .book-card img{
            width: 100%;
            aspect-ratio: 2 / 3;  /* 2:3 */
            height: auto;         /* ให้สูงตามอัตราส่วน */
            object-fit: cover;
            background: linear-gradient(135deg,#eee,#ccc);
        }
        .book-card-content { 
            padding: 15px; 
            flex-grow: 1; 
            display: flex; 
            flex-direction: column; 
            justify-content: space-between; 
        }
        .book-card-content div { margin-bottom: 10px; }
        .book-title {
            font-size: 1rem;
            font-weight: 600;
            margin: 0 0 6px 0;     /* ห่างด้านล่าง 6px */
        }

        .book-edition,
        .book-category {
            font-size: 0.9rem;
            color: #666;
            margin: 6px 0;         /* ห่างบน–ล่างเท่ากัน */
        }

        .book-price {
            font-size: 1.1rem;
            font-weight: bold;
            color: #d90000;
            margin-top: 6px;       /* ระยะห่างเท่ากันกับส่วนบน */
        }


        /* Responsive */
        @media (max-width: 768px) {
            .main-nav ul { gap: 8px; }
        }
        @media (max-width: 480px) {
            .header-icons { font-size: 0.85rem; }
            .book-title { font-size: 0.9rem; }
        }

        /* [ลบ] CSS Dropdown ที่ซ้ำซ้อนทั้งชุดที่อยู่ตรงนี้ออกไป */

    </style>
</head>
<body>
    <form id="form1" runat="server">

        <header class="top-header">
            <div class="container">
                <div class="logo">MyBookstore</div>
                <div class="search-bar">
                    <asp:TextBox ID="txtSearch" runat="server" placeholder="ค้นหาหนังสือ..." CssClass="search-input"></asp:TextBox>
                    <asp:Button ID="btnSearch" runat="server" Text="ค้นหา" OnClick="btnSearch_Click" CssClass="search-button" />
                </div>
                <div class="header-icons">
                    <asp:LinkButton ID="btnLogin" runat="server" PostBackUrl="~/loginPage.aspx">
                        Login  
                    </asp:LinkButton>
                    <asp:LinkButton ID="btnLogout" runat="server" OnClick="btnLogout_Click" ForeColor="Red" Visible="false">
                        Logout  
                    </asp:LinkButton>
                    <a href="cartPage.aspx" class="cart-icon" title="ตะกร้าสินค้า" runat="server" id="cartLink">
                        🛒
                        <span runat="server" id="cartCount" class="cart-count">0</span>
                    </a>
                </div>
            </div>
        </header>

        <!-- Navigation bar ใหม่ -->
        <nav class="main-nav">
            <div class="container">
                <ul>
                    <li><a href="mainpage.aspx">หน้าแรก</a></li>
                    <li><a href="topSalePage.aspx">หนังสือขายดี</a></li>

                    <li class="dropdown">
                        <a href="#">หมวดหมู่ ▼</a>
                        <ul class="dropdown-content">
                            <li><a href="categoryPage.aspx?id=1">Fiction</a></li>
                            <li><a href="categoryPage.aspx?id=2">Non-fiction</a></li>
                            <li><a href="categoryPage.aspx?id=3">Children’s Books</a></li>
                            <li><a href="categoryPage.aspx?id=4">Education / Academic</a></li>
                            <li><a href="categoryPage.aspx?id=5">Comics / Graphic Novels / Manga</a></li>
                            <li><a href="categoryPage.aspx?id=6">Art / Design / Photography</a></li>
                            <li><a href="categoryPage.aspx?id=7">Religion / Spirituality</a></li>
                            <li><a href="categoryPage.aspx?id=8">Science / Technology</a></li>
                            <li><a href="categoryPage.aspx?id=9">Business / Economics</a></li>
                            <li><a href="categoryPage.aspx?id=10">Cookbooks / Lifestyle</a></li>
                            <li><a href="categoryPage.aspx?id=11">Poetry / Drama</a></li>
                        </ul>
                    </li>

 
                    <li><a href="myAccountPage.aspx">บัญชีของฉัน</a></li>
                    <li><a href="myCollectionPage.aspx">คอลเลคชั่นของฉัน</a></li>
                    <li><a href="reviewHistoryPage.aspx">ประวัติการรีวิวของฉัน</a></li>
                </ul>
            </div>
        </nav>

        <main class="container">

            <h2 class="section-title">หนังสือแนะนำ</h2>
            <section class="book-grid">
                <asp:Repeater ID="RepeaterBooks" runat="server">
                    <ItemTemplate>
                        <div class="book-card">
                            <img src='<%# Eval("CoverUrl") %>' alt='<%# Eval("Title") %>' />
                            <div class="book-card-content">
                                <div>
                                    <h3 class="book-title"><%# Eval("Title") %></h3>
                                    <p class="book-edition"><%# Eval("Edition") %> Edition</p>
                                    <p class="book-category"><%# Eval("CategoryName") %></p>
                                </div>
                                <p class="book-price">฿<%# Eval("Price", "{0:F2}") %></p>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </section>

            <h2 class="section-title">Top 10 หนังสือขายดี</h2>
            <section class="book-grid">
                <asp:Repeater ID="RepeaterTopBooks" runat="server">
                    <ItemTemplate>
                        <div class="book-card">
                            <img src='<%# Eval("CoverUrl") %>' alt='<%# Eval("Title") %>' />
                            <div class="book-card-content">
                                <div>
                                    <h3 class="book-title"><%# Eval("Title") %></h3>
                                    <p class="book-edition"><%# Eval("Edition") %> Edition</p>
                                    <p class="book-category"><%# Eval("CategoryName") %></p>
                                </div>
                                <p class="book-price">฿<%# Eval("Price", "{0:F2}") %></p>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </section>
        </main>

    </form>
</body>
</html>

