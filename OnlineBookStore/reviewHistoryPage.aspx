<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="reviewHistoryPage.aspx.cs" Inherits="OnlineBookStore.reviewHistoryPage" %>

<!DOCTYPE html>
<html lang="th">
<head runat="server">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ประวัติการรีวิว</title>
    <style>
        /* --- ใช้ CSS ส่วนใหญ่จาก myCollectionPage.aspx --- */
        body { font-family: Arial, sans-serif; margin: 0; background-color: #f0f2f5; color: #333; }
        a { text-decoration: none; color: inherit; }
        .container { width: 90%; max-width: 1200px; margin: 0 auto; }
        .top-header { background-color: #fff; padding: 10px 0; border-bottom: 1px solid #ddd; }
        .top-header .container { display: flex; justify-content: space-between; align-items: center; }
        .logo { font-size: 1.5rem; font-weight: bold; color: #d90000; }
        .search-bar { flex-grow: 1; margin: 0 20px; }
        .search-bar input { width: 100%; max-width: 400px; padding: 8px 40px 8px 12px; border: 1px solid #ccc; border-radius: 20px; }
        .header-icons { display: flex; gap: 15px; font-size: 0.95rem; }
        .main-nav { background-color: #333; color: #fff; padding: 6px 0; z-index: 10; }
        .main-nav .container { display: flex; justify-content: center; align-items: center; }
        .main-nav ul { list-style: none; margin: 0; padding: 0; display: flex; gap: 10px; flex-wrap: wrap; justify-content: center; }
        .main-nav li { position: relative; }
        .main-nav li a { padding: 6px 10px; font-size: 0.9rem; display: block; border-radius: 5px; transition: background-color 0.2s; color: #fff; }
        .main-nav li a:hover { background-color: #555; }
        .main-nav li.dropdown { position: relative; }
        .main-nav li.dropdown .dropdown-content { display: none; position: absolute; top: 100%; left: 0; background-color: #444; min-width: 200px; border-radius: 6px; padding: 8px 0; box-shadow: 0 6px 16px rgba(0,0,0,0.2); z-index: 999; }
        .main-nav .dropdown-content li a { padding: 8px 14px; font-size: 0.9rem; display: block; color: #fff; }
        .main-nav .dropdown-content li a:hover { background-color: #555; }
        .main-nav li.dropdown:hover .dropdown-content { display: block; }
        main { padding: 20px 0; }
        .section-title { font-size: 1.8rem; font-weight: bold; margin: 20px 0; color: #111; }

        /* --- CSS เฉพาะสำหรับหน้า Review History --- */
        .review-history-list {
            display: grid;
            grid-template-columns: 1fr;
            gap: 1.5rem;
        }

        .review-card {
            background-color: #fff;
            border: 1px solid #e0e0e0;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.06);
            display: flex;
            gap: 1.5rem;
            padding: 1.5rem;
        }
        .review-card-cover img {
            width: 100px;
            height: 150px;
            object-fit: cover;
            border-radius: 4px;
            background-color: #f4f4f4;
        }
        .review-card-content {
            flex: 1;
        }
        .review-card-content h3 {
            font-size: 1.25rem;
            font-weight: 600;
            margin-top: 0;
            margin-bottom: 0.5rem;
        }

        /* [เพิ่ม] CSS สำหรับรายละเอียดหนังสือ */
        .review-book-details {
            font-size: 0.85rem;
            color: #444;
            margin-bottom: 1rem;
            display: flex;
            flex-wrap: wrap;
            gap: 0.5rem 1.5rem; /* row-gap column-gap */
        }
        .review-book-details strong {
            color: #111;
        }
        /* [สิ้นสุด] */

        .review-card-meta {
            font-size: 0.9rem;
            color: #555;
            margin-bottom: 1rem;
        }
        .review-card-meta .rating {
            font-weight: bold;
            color: #eab308; /* สีเหลืองทอง */
        }
        .review-card-comment {
            font-size: 1rem;
            color: #333;
            line-height: 1.6;
            white-space: pre-wrap; 
        }
        
        .no-items-panel {
            border: 1px dashed #e2e8f0;
            border-radius: 0.5rem;
            padding: 1.5rem;
            text-align: center;
            color: #6b7280;
            background-color: #fafafa;
        }
        
        @media (max-width: 600px) {
            .review-card {
                flex-direction: column;
                align-items: center;
                text-align: center;
            }
            .review-book-details {
                 justify-content: center;
            }
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">

        <!-- Header (เหมือนเดิม) -->
        <header class="top-header">
            <div class="container">
                <div class="logo">MyBookstore</div>
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

        <!-- Navigation bar (เหมือนเดิม + เพิ่มลิงก์) -->
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
            <h1 class="section-title">ประวัติการรีวิวของฉัน</h1>

            <div class="review-history-list">
                <asp:Repeater ID="rptMyReviews" runat="server" OnItemDataBound="rptMyReviews_ItemDataBound">
                    <ItemTemplate>
                        <div class="review-card">
                            <div class="review-card-cover">
                                <asp:Image ID="imgBookCover" runat="server" />
                            </div>
                            <div class="review-card-content">
                                <h3><%# Eval("Title") %></h3>

                                <!-- [เพิ่ม] แสดงรายละเอียด Edition, Category, Author -->
                                <div class="review-book-details">
                                    <span><strong>ผู้แต่ง:</strong> <%# (Eval("Authors") == DBNull.Value || string.IsNullOrEmpty(Eval("Authors").ToString())) ? "ไม่ระบุ" : Eval("Authors") %></span>
                                    <span><strong>หมวดหมู่:</strong> <%# Eval("CategoryName") == DBNull.Value ? "ไม่ระบุ" : Eval("CategoryName") %></span>
                                    <span><strong>Edition:</strong> <%# Eval("Edition") == DBNull.Value ? "N/A" : Eval("Edition") %></span>
                                </div>
                                <!-- [สิ้นสุด] -->
                                
                                <div class="review-card-meta">
                                    <span class="rating">★ <%# Eval("Rating") %> ดาว</span>
                                    <span class="date" style="margin-left: 1rem;">
                                        - <%# Eval("ReviewDate", "{0:dd MMMM yyyy}") %>
                                    </span>
                                </div>
                                <p class="review-card-comment">
                                    <%# Eval("Comment") %>
                                </p>
                            </div>
                        </div>
                    </ItemTemplate>
                    <FooterTemplate>
                        <asp:Panel runat="server" ID="pnlNoReviews" Visible='<%# rptMyReviews.Items.Count == 0 %>'>
                            <div class="no-items-panel">
                                คุณยังไม่เคยรีวิวหนังสือ
                            </div>
                        </asp:Panel>
                    </FooterTemplate>
                </asp:Repeater>
            </div>
        </main>

    </form>
</body>
</html>

