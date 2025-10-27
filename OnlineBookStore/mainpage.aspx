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
        .search-bar { flex-grow: 1; margin: 0 20px; }
        .search-bar input { width: 100%; max-width: 400px; padding: 8px 40px 8px 12px; border: 1px solid #ccc; border-radius: 20px; }
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

        /* Dropdown */
        .dropdown { position: relative; }
        .dropdown-content {
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
        .dropdown-content li a {
            padding: 8px 14px;
            font-size: 0.9rem;
            display: block;
            color: #fff;
        }
        .dropdown-content li a:hover { background-color: #555; }
        .dropdown:hover .dropdown-content { display: block; }

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
        /* แทนบรรทัดเดิม: .book-card img { width:100%; height:250px; ... } */
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
        .book-title { font-size: 1rem; 
                      font-weight: 600; 
                      margin: 0; 
                      display: -webkit-box; 
                      -webkit-line-clamp: 2; 
                      -webkit-box-orient: vertical; 
                      overflow: hidden; 
                      height: 40px; 
                      line-height: 1.25; 
        }
        .book-category { font-size: 0.85rem; color: #777; margin-top: 5px; }
        .book-price { font-size: 1.1rem; font-weight: bold; color: #d90000; margin-top: auto; }

        /* Responsive */
        @media (max-width: 768px) {
            .main-nav ul { gap: 8px; }
            .book-card img { height: 200px; }
        }
        @media (max-width: 480px) {
            .header-icons { font-size: 0.85rem; }
            .book-title { font-size: 0.9rem; }
        }
            .dropdown {
            position: relative;
            display: inline-block;
        }

        .dropdown-content {
            display: none;
            position: absolute;
            background-color: #333;
            min-width: 200px;
            z-index: 1;
            border-radius: 5px;
        }

        .dropdown-content a {
            color: white;
            padding: 10px 12px;
            display: block;
            text-align: left;
        }

        .dropdown:hover .dropdown-content {
            display: block;
        }

        .dropdown-content a:hover {
            background-color: #555;
        }

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
                    <span>🛒 Cart</span>
                    <a href="loginpage.aspx"><span>👤 Login</span></a>
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



                    <li><a href="#">ผู้แต่ง</a></li>
                    <li><a href="#">สำนักพิมพ์</a></li>
 
                    <li><a href="#">บัญชีของฉัน</a></li>
                    <li><a href="#">ตะกร้าสินค้า</a></li>
                </ul>
            </div>
        </nav>

        <main class="container">

            <h2 class="section-title">หนังสือแนะนำ</h2>
            <section class="book-grid">
                <asp:Repeater ID="RepeaterBooks" runat="server">
                    <ItemTemplate>
                        <div class="book-card">
                            <img src="https://raw.githubusercontent.com/Bobbydeb/OnlineBookStore/refs/heads/master/OnlineBookStore/wwwroot/images/03_AcrossFire.jpg" alt="Test Image" />

                            <div class="book-card-content">
                                <div>
                                    <h3 class="book-title"><%# Eval("Title") %></h3>
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
