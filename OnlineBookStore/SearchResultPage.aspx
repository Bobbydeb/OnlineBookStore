<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="searchResultPage.aspx.cs" Inherits="OnlineBookStore.searchResultPage" %>

<!DOCTYPE html>
<html lang="th">
<head runat="server">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ผลการค้นหา</title>
    <!-- คัดลอก CSS จาก mainpage.aspx มาใช้เพื่อให้หน้าตาเหมือนกัน -->
    <style>
        body { font-family: Arial, sans-serif; margin: 0; background-color: #f0f2f5; color: #333; }
        a { text-decoration: none; color: inherit; }
        .container { width: 90%; max-width: 1200px; margin: 0 auto; }

        /* Header */
        .top-header { background-color: #fff; padding: 10px 0; border-bottom: 1px solid #ddd; }
        .top-header .container { display: flex; justify-content: space-between; align-items: center; }
        .logo { font-size: 1.5rem; font-weight: bold; color: #d90000; }
        
        /* CSS สำหรับ Search Bar */
        .search-bar { flex-grow: 1; margin: 0 20px; display: flex; }
        .search-input { 
            width: 100%; 
            max-width: 400px; 
            padding: 8px 12px; 
            border: 1px solid #ccc; 
            border-radius: 20px 0 0 20px; 
            border-right: none;
            font-size: 1rem; 
            font-family: Arial, sans-serif;
        }
        .search-button { 
            padding: 8px 12px;
            border: 1px solid #ccc;
            border-radius: 0 20px 20px 0; 
            background-color: #f0f0f0;
            cursor: pointer;
            font-size: 0.9rem;
        }
        .search-button:hover { background-color: #e0e0e0; }
        
        .header-icons { display: flex; gap: 15px; font-size: 0.95rem; }

        /* Nav */
        .main-nav { background-color: #333; color: #fff; padding: 6px 0; position: relative; z-index: 10; }
        .main-nav .container { display: flex; justify-content: center; align-items: center; }
        .main-nav ul { list-style: none; margin: 0; padding: 0; display: flex; gap: 10px; flex-wrap: wrap; justify-content: center; }
        .main-nav li { position: relative; }
        .main-nav li a { padding: 6px 10px; font-size: 0.9rem; display: block; border-radius: 5px; transition: background-color 0.2s; color: #fff; }
        .main-nav li a:hover { background-color: #555; }

        /* Dropdown (CSS ที่ถูกต้องชุดเดียว) */
        .main-nav li.dropdown { position: relative; } 
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
        .main-nav li.dropdown:hover .dropdown-content { display: block; } 

        /* Content */
        main { padding: 20px 0; }
        .section-title { font-size: 1.8rem; font-weight: bold; margin: 20px 0; color: #111; }
        .search-title { font-size: 1.5rem; font-weight: 600; margin-bottom: 20px; }
        .search-title span { color: #d90000; font-style: italic; }
        
        /* Book Grid (auto-fill) */
        .book-grid { 
            display: grid; 
            grid-template-columns: repeat(auto-fill, minmax(200px, 1fr)); 
            gap: 20px; 
        }

        /* [แก้ไข] เพิ่ม transition และ :hover effect */
        .book-card { 
            background-color: #fff; 
            border: 1px solid #e0e0e0; 
            border-radius: 8px; 
            overflow: hidden; 
            box-shadow: 0 2px 5px rgba(0,0,0,0.05); 
            display: flex; 
            flex-direction: column;
            /* [เพิ่ม] เพิ่ม transition properties */
            transition: transform 0.3s, box-shadow 0.3s;
        }
        .book-card:hover { 
            /* [เพิ่ม] เพิ่ม hover effect */
            transform: translateY(-4px);             
            box-shadow: 0 4px 12px rgba(0,0,0,0.1); 
        }

        .book-card img{ width: 100%; aspect-ratio: 2 / 3; height: auto; object-fit: cover; background: linear-gradient(135deg,#eee,#ccc); }
        .book-card-content { padding: 15px; flex-grow: 1; display: flex; flex-direction: column; justify-content: space-between; }
        .book-card-content div { margin-bottom: 10px; }
        .book-title { font-size: 1rem; font-weight: 600; margin: 0 0 6px 0; }
        .book-edition, .book-category { font-size: 0.9rem; color: #666; margin: 6px 0; }
        .book-price { font-size: 1.1rem; font-weight: bold; color: #d90000; margin-top: 6px; }
        
        /* No results panel */
        .no-items-panel {
            border: 1px dashed #e2e8f0;
            border-radius: 0.5rem;
            padding: 1.5rem;
            text-align: center;
            color: #6b7280;
            background-color: #fafafa;
        }

        /* CSS สำหรับ Pagination (เหมือน categoryPage) */
        .pagination-container { 
            display: flex; 
            justify-content: center; 
            margin-top: 2rem; 
        }
        .pagination { 
            list-style: none; 
            display: flex; 
            padding: 0; 
            margin: 0; 
            border-radius: 0.375rem; /* 6px */
            box-shadow: 0 1px 3px rgba(0,0,0,0.1); 
            overflow: hidden; /* ทำให้ขอบมนสวยงาม */
        }
        .page-item { } /* <li> */
        .page-link { /* <a> */
            display: block; 
            padding: 0.75rem 1rem; /* 12px 16px */
            color: #d90000; /* สีแดงหลัก */
            text-decoration: none; 
            background-color: #fff;
            border: 1px solid #ddd;
            transition: background-color 0.2s;
            font-weight: 600;
        }
        .page-item:not(:first-child) .page-link { 
            border-left: 0; 
        }
        .page-item.active .page-link {
            z-index: 2;
            color: #fff;
            background-color: #d90000;
            border-color: #d90000;
        }
        .page-link:hover {
             background-color: #f7f7f7;
        }
        .page-item.active .page-link:hover {
             background-color: #d90000;
        }
        .page-link:disabled,
        .page-item.active .page-link {
            pointer-events: none; /* ปิดการคลิกหน้าปัจจุบัน */
        }

    </style>
</head>
<body>
    <form id="form1" runat="server">

        <!-- Header -->
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

        <!-- Navigation bar -->
        <nav class="main-nav">
            <div class="container">
                <ul>
                    <li><a href="mainpage.aspx">หน้าแรก</a></li>
                    <li><a href="topSalePage.aspx">หนังสือขายดี</a></li>
                     <li class="dropdown">
                        <a href="#">หมวดหมู่ ▼</a>
                        <ul class="dropdown-content">
                            <!-- [แก้ไข] อัปเดตลิงก์ที่นี่ด้วย (เหมือน mainpage) -->
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

        <!-- Main Content -->
        <main class="container">
            <h1 class="search-title">ผลการค้นหาสำหรับ: 
                <span><asp:Literal ID="litSearchQuery" runat="server" /></span>
            </h1>
            
            <asp:Panel runat="server" ID="pnlNoResults" Visible="false" CssClass="no-items-panel" Style="margin-bottom: 20px;">
                ไม่พบหนังสือที่ตรงกับคำค้นหาของคุณ
            </asp:Panel>

            <section class="book-grid">
                <asp:Repeater ID="rptSearchResults" runat="server">
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

            <!-- Pagination Controls (จากครั้งก่อน) -->
            <asp:Panel runat="server" ID="pnlPager" Visible="false">
                <nav aria-label="Page navigation" class="pagination-container">
                    <ul class="pagination">
                        <asp:Repeater ID="rptPager" runat="server" OnItemDataBound="rptPager_ItemDataBound">
                            <ItemTemplate>
                                <li runat="server" id="liPageItem" class="page-item">
                                    <asp:HyperLink ID="hlPageLink" runat="server" CssClass="page-link"></asp:HyperLink>
                                </li>
                            </ItemTemplate>
                        </asp:Repeater>
                    </ul>
                </nav>
            </asp:Panel>
            <!-- [สิ้นสุด] Pagination Controls -->

        </main>

    </form>
</body>
</html>

