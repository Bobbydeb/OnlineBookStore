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
        .search-bar { flex-grow: 1; margin: 0 20px; }
        .search-bar input { width: 100%; max-width: 400px; padding: 8px 40px 8px 12px; border: 1px solid #ccc; border-radius: 20px; }
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
        .main-nav li a { padding: 6px 10px; font-size: 0.9rem; display: block; border-radius: 5px; transition: background-color 0.2s; color: #fff; }
        .main-nav li a:hover { background-color: #555; }

        /* Dropdown */
        .dropdown { position: relative; display: inline-block; }
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
        .dropdown-content a {
            color: #fff;
            padding: 8px 14px;
            display: block;
            font-size: 0.9rem;
        }
        .dropdown-content a:hover { background-color: #555; }
        .dropdown:hover .dropdown-content { display: block; }

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
            .book-card img { height: 200px; }
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
                    <input type="text" placeholder="ค้นหาหนังสือ...">
                </div>
                <div class="header-icons">
 
                    <a href="loginpage.aspx"><span>👤 Login</span></a>
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
                    <li><a href="myCartPage.aspx">ตะกร้าสินค้า</a></li>
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
                                     <div class="book-title"><%# Eval("Title") %></div>
                                     <div class="book-sold">ขายแล้ว <%# Eval("TotalSold") %> เล่ม</div>
                                 </div>
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
                                     <div class="book-title"><%# Eval("Title") %></div>
                                     <div class="book-sold">ขายแล้ว <%# Eval("TotalSold") %> เล่ม</div>
                                 </div>
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
                                     <div class="book-title"><%# Eval("Title") %></div>
                                     <div class="book-sold">ขายแล้ว <%# Eval("TotalSold") %> เล่ม</div>
                                 </div>
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
                                     <div class="book-title"><%# Eval("Title") %></div>
                                     <div class="book-sold">ขายแล้ว <%# Eval("TotalSold") %> เล่ม</div>
                                 </div>
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
                                     <div class="book-title"><%# Eval("Title") %></div>
                                     <div class="book-sold">ขายแล้ว <%# Eval("TotalSold") %> เล่ม</div>
                                 </div>
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
                                     <div class="book-title"><%# Eval("Title") %></div>
                                     <div class="book-sold">ขายแล้ว <%# Eval("TotalSold") %> เล่ม</div>
                                 </div>
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
                                     <div class="book-title"><%# Eval("Title") %></div>
                                     <div class="book-sold">ขายแล้ว <%# Eval("TotalSold") %> เล่ม</div>
                                 </div>
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
                                     <div class="book-title"><%# Eval("Title") %></div>
                                     <div class="book-sold">ขายแล้ว <%# Eval("TotalSold") %> เล่ม</div>
                                 </div>
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
                                     <div class="book-title"><%# Eval("Title") %></div>
                                     <div class="book-sold">ขายแล้ว <%# Eval("TotalSold") %> เล่ม</div>
                                 </div>
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
                                     <div class="book-title"><%# Eval("Title") %></div>
                                     <div class="book-sold">ขายแล้ว <%# Eval("TotalSold") %> เล่ม</div>
                                 </div>

                             </div>
                         </div>
                     </ItemTemplate>
                 </asp:Repeater>
             </div>
        </main>
    </form>
</body>
</html>
