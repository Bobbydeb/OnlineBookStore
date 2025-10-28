<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="topSalePage.aspx.cs" Inherits="OnlineBookStore.topSalePage" %>

<!DOCTYPE html>
<html lang="th">
<head runat="server">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>หนังสือขายดี | MyBookstore</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 0; background-color: #f0f2f5; color: #333; }
        a { text-decoration: none; color: inherit; }
        .container { width: 90%; max-width: 1200px; margin: 0 auto; }

        /* Header */
        .top-header { background-color: #fff; padding: 10px 0; border-bottom: 1px solid #ddd; }
        .top-header .container { display: flex; justify-content: space-between; align-items: center; }
        .logo { font-size: 1.5rem; font-weight: bold; color: #d90000; }
        
        /* [แก้ไข] CSS สำหรับ Search Bar (เหมือน mainpage) */
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

        /* Navbar */
        .main-nav {
            background-color: #333;
            color: #fff;
            padding: 6px 0;
            position: relative;
            z-index: 10;
        }
        .main-nav .container { display: flex; justify-content: center; align-items: center; }
        .main-nav ul { list-style: none; margin: 0; padding: 0; display: flex; gap: 10px; flex-wrap: wrap; justify-content: center; }
        /* [แก้ไข] เพิ่ม li เข้าไป */
        .main-nav li { position: relative; }
        .main-nav li a { padding: 6px 10px; font-size: 0.9rem; display: block; border-radius: 5px; transition: background-color 0.2s; color: #fff; }
        .main-nav li a:hover { background-color: #555; }

        /* [แก้ไข] Dropdown (CSS ที่ถูกต้อง) */
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
        /* [แก้ไข] เพิ่ม li เข้าไป */
        .main-nav .dropdown-content li a {
            color: #fff;
            padding: 8px 14px;
            display: block;
            font-size: 0.9rem;
        }
        .main-nav .dropdown-content li a:hover { background-color: #555; }
        .main-nav li.dropdown:hover .dropdown-content { display: block; } /* ทำให้เจาะจงมากขึ้น */

        /* Content */
        main { padding: 20px 0; }
        h2 { text-align: center; font-size: 1.8rem; font-weight: bold; margin: 30px 0 20px; }
        .category-title { text-align: left; font-size: 1.25rem; font-weight: 600; margin: 40px 0 25px 5px; }

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

        .book-card img {
            width: 100%;
            aspect-ratio: 2 / 3; /* same as mainpage */
            height: auto;
            object-fit: cover;
            background: linear-gradient(135deg, #eee, #ccc);
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
        
        /* [เพิ่ม] .book-edition */
        .book-edition {
            font-size: 0.9rem;
            color: #666;
            margin: 6px 0;
        }

        .book-sold {
            font-size: 0.85rem;
            color: #777;
            margin-top: 5px;
        }

        .book-price {
            font-size: 1.1rem;
            font-weight: bold;
            color: #d90000;
            margin-top: auto;
        }

        /* Responsive */
        @media (max-width: 768px) {
            .main-nav ul { gap: 8px; }
        }
        @media (max-width: 480px) {
            .header-icons { font-size: 0.85rem; }
            .book-title { font-size: 0.9rem; }
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
                    <!-- [แก้ไข] เปลี่ยนเป็น ASP Control -->
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
            <h2>หนังสือขายดี 5 อันดับแรกของแต่ละหมวดหมู่</h2>

            <asp:Literal ID="LiteralCate1" runat="server"></asp:Literal>
            <div class="book-grid">
                <asp:Repeater ID="RepeaterLoadTopCate1" runat="server">
                    <ItemTemplate>
                        <div class="book-card">
                            <img src='<%# Eval("CoverUrl") %>' alt='<%# Eval("Title") %>' />
                            <div class="book-card-content">
                                <div>
                                    <h3 class="book-title"><%# Eval("Title") %></h3>
                                    <p class="book-edition"><%# Eval("Edition") %> Edition</p>
                                    <p class="book-sold">ขายแล้ว <%# Eval("TotalSold") %> เล่ม</p>
                                </div>
                                <p class="book-price">฿<%# Eval("Price", "{0:F2}") %></p>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>

             <asp:Literal ID="LiteralCate2" runat="server"></asp:Literal>
             <div class="book-grid">
                 <asp:Repeater ID="RepeaterLoadTopCate2" runat="server">
                     <ItemTemplate>
                         <div class="book-card">
                             <img src='<%# Eval("CoverUrl") %>' alt='<%# Eval("Title") %>' />
                             <div class="book-card-content">
                                 <div>
                                     <!-- [แก้ไข] ใช้ h3 -->
                                     <h3 class="book-title"><%# Eval("Title") %></h3>
                                     <p class="book-edition"><%# Eval("Edition") %> Edition</p>
                                     <div class="book-sold">ขายแล้ว <%# Eval("TotalSold") %> เล่ม</div>
                                 </div>
                                 <p class="book-price">฿<%# Eval("Price", "{0:F2}") %></p>
                             </div>
                         </div>
                     </ItemTemplate>
                 </asp:Repeater>
             </div>

             <asp:Literal ID="LiteralCate3" runat="server"></asp:Literal>
             <div class="book-grid">
                 <asp:Repeater ID="RepeaterLoadTopCate3" runat="server">
                     <ItemTemplate>
                         <div class="book-card">
                             <img src='<%# Eval("CoverUrl") %>' alt='<%# Eval("Title") %>' />
                             <div class="book-card-content">
                                 <div>
                                     <h3 class="book-title"><%# Eval("Title") %></h3>
                                     <p class="book-edition"><%# Eval("Edition") %> Edition</p>
                                     <div class="book-sold">ขายแล้ว <%# Eval("TotalSold") %> เล่ม</div>
                                 </div>
                                 <p class="book-price">฿<%# Eval("Price", "{0:F2}") %></p>
                             </div>
                         </div>
                     </ItemTemplate>
                 </asp:Repeater>
             </div>

             <asp:Literal ID="LiteralCate4" runat="server"></asp:Literal>
             <div class="book-grid">
                 <asp:Repeater ID="RepeaterLoadTopCate4" runat="server">
                     <ItemTemplate>
                         <div class="book-card">
                             <img src='<%# Eval("CoverUrl") %>' alt='<%# Eval("Title") %>' />
                             <div class="book-card-content">
                                 <div>
                                     <h3 class="book-title"><%# Eval("Title") %></h3>
                                     <p class="book-edition"><%# Eval("Edition") %> Edition</p>
                                     <div class="book-sold">ขายแล้ว <%# Eval("TotalSold") %> เล่ม</div>
                                 </div>
                                 <p class="book-price">฿<%# Eval("Price", "{0:F2}") %></p>
                             </div>
                         </div>
                     </ItemTemplate>
                 </asp:Repeater>
             </div>
             <asp:Literal ID="LiteralCate5" runat="server"></asp:Literal>
             <div class="book-grid">
                 <asp:Repeater ID="RepeaterLoadTopCate5" runat="server">
                     <ItemTemplate>
                         <div class="book-card">
                             <img src='<%# Eval("CoverUrl") %>' alt='<%# Eval("Title") %>' />
                             <div class="book-card-content">
                                 <div>
                                     <h3 class="book-title"><%# Eval("Title") %></h3>
                                     <p class="book-edition"><%# Eval("Edition") %> Edition</p>
                                     <div class="book-sold">ขายแล้ว <%# Eval("TotalSold") %> เล่ม</div>
                                 </div>
                                 <p class="book-price">฿<%# Eval("Price", "{0:F2}") %></p>
                             </div>
                         </div>
                     </ItemTemplate>
                 </asp:Repeater>
             </div>
             <asp:Literal ID="LiteralCate6" runat="server"></asp:Literal>
             <div class="book-grid">
                 <asp:Repeater ID="RepeaterLoadTopCate6" runat="server">
                     <ItemTemplate>
                         <div class="book-card">
                             <img src='<%# Eval("CoverUrl") %>' alt='<%# Eval("Title") %>' />
                             <div class="book-card-content">
                                 <div>
                                     <h3 class="book-title"><%# Eval("Title") %></h3>
                                     <p class="book-edition"><%# Eval("Edition") %> Edition</p>
                                     <div class="book-sold">ขายแล้ว <%# Eval("TotalSold") %> เล่ม</div>
                                 </div>
                                 <p class="book-price">฿<%# Eval("Price", "{0:F2}") %></p>
                             </div>
                         </div>
                     </ItemTemplate>
                 </asp:Repeater>
             </div>
             <asp:Literal ID="LiteralCate7" runat="server"></asp:Literal>
             <div class="book-grid">
                 <asp:Repeater ID="RepeaterLoadTopCate7" runat="server">
                     <ItemTemplate>
                         <div class="book-card">
                             <img src='<%# Eval("CoverUrl") %>' alt='<%# Eval("Title") %>' />
                             <div class="book-card-content">
                                 <div>
                                     <h3 class="book-title"><%# Eval("Title") %></h3>
                                     <p class="book-edition"><%# Eval("Edition") %> Edition</p>
                                     <div class="book-sold">ขายแล้ว <%# Eval("TotalSold") %> เล่ม</div>
                                 </div>
                                 <p class="book-price">฿<%# Eval("Price", "{0:F2}") %></p>
                             </div>
                         </div>
                     </ItemTemplate>
                 </asp:Repeater>
             </div>
             <asp:Literal ID="LiteralCate8" runat="server"></asp:Literal>
             <div class="book-grid">
                 <asp:Repeater ID="RepeaterLoadTopCate8" runat="server">
                     <ItemTemplate>
                         <div class="book-card">
                             <img src='<%# Eval("CoverUrl") %>' alt='<%# Eval("Title") %>' />
                             <div class="book-card-content">
                                 <div>
                                     <h3 class="book-title"><%# Eval("Title") %></h3>
                                     <p class="book-edition"><%# Eval("Edition") %> Edition</p>
                                     <div class="book-sold">ขายแล้ว <%# Eval("TotalSold") %> เล่ม</div>
                                 </div>
                                 <p class="book-price">฿<%# Eval("Price", "{0:F2}") %></p>
                             </div>
                         </div>
                     </ItemTemplate>
                 </asp:Repeater>
             </div>
             <asp:Literal ID="LiteralCate9" runat="server"></asp:Literal>
             <div class="book-grid">
                 <asp:Repeater ID="RepeaterLoadTopCate9" runat="server">
                     <ItemTemplate>
                         <div class="book-card">
                             <img src='<%# Eval("CoverUrl") %>' alt='<%# Eval("Title") %>' />
                             <div class="book-card-content">
                                 <div>
                                     <h3 class="book-title"><%# Eval("Title") %></h3>
                                     <p class="book-edition"><%# Eval("Edition") %> Edition</p>
                                     <div class="book-sold">ขายแล้ว <%# Eval("TotalSold") %> เล่ม</div>
                                 </div>
                                 <p class="book-price">฿<%# Eval("Price", "{0:F2}") %></p>
                             </div>
                         </div>
                     </ItemTemplate>
                 </asp:Repeater>
             </div>
             <asp:Literal ID="LiteralCate10" runat="server"></asp:Literal>
             <div class="book-grid">
                 <asp:Repeater ID="RepeaterLoadTopCate10" runat="server">
                     <ItemTemplate>
                         <div class="book-card">
                             <img src='<%# Eval("CoverUrl") %>' alt='<%# Eval("Title") %>' />
                             <div class="book-card-content">
                                 <div>
                                     <h3 class="book-title"><%# Eval("Title") %></h3>
                                     <p class="book-edition"><%# Eval("Edition") %> Edition</p>
                                     <div class="book-sold">ขายแล้ว <%# Eval("TotalSold") %> เล่ม</div>
                                 </div>
                                 <p class="book-price">฿<%# Eval("Price", "{0:F2}") %></p>
                             </div>
                         </div>
                     </ItemTemplate>
                 </asp:Repeater>
             </div>
             <asp:Literal ID="LiteralCate11" runat="server"></asp:Literal>
             <div class="book-grid">
                 <asp:Repeater ID="RepeaterLoadTopCate11" runat="server">
                     <ItemTemplate>
                         <div class="book-card">
                             <img src='<%# Eval("CoverUrl") %>' alt='<%# Eval("Title") %>' />
                             <div class="book-card-content">
                                 <div>
                                     <h3 class="book-title"><%# Eval("Title") %></h3>
                                     <p class="book-edition"><%# Eval("Edition") %> Edition</p>
                                     <div class="book-sold">ขายแล้ว <%# Eval("TotalSold") %> เล่ม</div>
                                 </div>
                                 <p class="book-price">฿<%# Eval("Price", "{0:F2}") %></p>
                             </div>
                         </div>
                     </ItemTemplate>
                 </asp:Repeater>
             </div>
        </main>
    </form>
</body>
</html>
