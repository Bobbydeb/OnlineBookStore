<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="myCollectionPage.aspx.cs" Inherits="OnlineBookStore.myCollectionPage" %>

<!DOCTYPE html>
<html lang="th">
<head runat="server">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Bookstore - คอลเลกชันของฉัน</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 0; background-color: #f0f2f5; color: #333; }
        a { text-decoration: none; color: inherit; }
        .container { width: 90%; max-width: 1200px; margin: 0 auto; }

        /* Header */
        .top-header { background-color: #fff; padding: 10px 0; border-bottom: 1px solid #ddd; }
        .top-header .container { display: flex; justify-content: space-between; align-items: center; }
        .logo { font-size: 1.5rem; font-weight: bold; color: #d90000; }
        .header-icons { display: flex; gap: 15px; font-size: 0.95rem; align-items: center; }
        .cart-count { display: inline; color: white; background-color: #d90000; border-radius: 50%; padding: 2px 6px; font-size: 0.8rem; vertical-align: top; margin-left: 2px; }
        .cart-count.empty { display: none; }

        /* Nav */
        .main-nav { background-color: #333; color: #fff; padding: 6px 0; position: relative; z-index: 10; }
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

        /* Content */
        main { padding: 20px 0; }
        .section-title { font-size: 1.8rem; font-weight: bold; margin: 20px 0; color: #111; }
        .content-layout { display: grid; grid-template-columns: 1fr; gap: 24px; }
        @media (min-width: 1024px) { .content-layout { grid-template-columns: 2fr 1fr; } } /* 2 columns on large screens */
        .section-title-2 { font-size: 1.5rem; font-weight: 600; margin-bottom: 1rem; }

        /* Order History */
        .order-item { border: 1px solid #e2e8f0; border-radius: 0.5rem; padding: 1rem; margin-bottom: 1rem; background-color: #ffffff; box-shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.1), 0 1px 2px 0 rgba(0, 0, 0, 0.06); }
        .order-item-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 0.5rem; flex-wrap: wrap; gap: 0.5rem; }
        .order-item-details { display: flex; justify-content: space-between; align-items: center; margin-bottom: 1rem; flex-wrap: wrap; gap: 0.5rem; }
        .order-item-header h3 { font-size: 1.125rem; font-weight: 600; margin: 0; }
        .order-item-header span { font-size: 0.875rem; color: #4a5568; }
        .order-item-details .total { font-weight: 500; }
        .order-item-details .status-container { display: flex; align-items: center; gap: 1rem; flex-wrap: wrap; /* [เพิ่ม] wrap เผื่อปุ่มเยอะ */ }
        .order-item-details .status { font-weight: 600; padding: 0.25rem 0.75rem; border-radius: 9999px; font-size: 0.875rem; }
        .status-yellow { background-color: #fefcbf; color: #92400e; }
        .status-blue { background-color: #dbeafe; color: #1e40af; }
        .status-green { background-color: #d1fae5; color: #065f46; }
        .status-red { background-color: #fee2e2; color: #991b1b; } /* สีสำหรับ ยกเลิก */
        .status-gray { background-color: #e5e7eb; color: #374151; }
        .order-book-list { padding-left: 0.5rem; color: #4a5568; margin-top: 0.5rem; }
        .order-book-list h4 { font-size: 1rem; font-weight: 600; margin-bottom: 0.5rem; margin-top: 0.5rem; }
        .order-book-list ul { list-style: disc; list-style-position: inside; margin: 0; padding-left: 0.5rem; }

        /* Buttons */
        .btn-pay { background-color: #2563eb; color: white; border: none; padding: 0.5rem 1rem; font-size: 0.9rem; font-weight: 600; border-radius: 5px; cursor: pointer; transition: background-color 0.2s; }
        .btn-pay:hover { background-color: #1d4ed8; }
        .btn-received { background-color: #10b981; color: white; border: none; padding: 0.5rem 1rem; font-size: 0.9rem; font-weight: 600; border-radius: 5px; cursor: pointer; transition: background-color 0.2s; }
        .btn-received:hover { background-color: #059669; }

        /* --- [ <<< เพิ่ม CSS ปุ่มยกเลิก >>> ] --- */
        .btn-cancel-order {
            background-color: #ef4444; /* สีแดง */
            color: white; border: none; padding: 0.5rem 1rem;
            font-size: 0.9rem; font-weight: 600; border-radius: 5px; cursor: pointer;
            transition: background-color 0.2s;
        }
        .btn-cancel-order:hover { background-color: #dc2626; }

        /* My Books Layout */
        .my-books-grid { display: grid; grid-template-columns: repeat(2, 1fr); gap: 1rem; }
        @media (max-width: 767px) { .my-books-grid { grid-template-columns: 1fr; } }
        @media (min-width: 768px) and (max-width: 1023px) { .my-books-grid { grid-template-columns: repeat(2, 1fr); } }

        .book-card-my-collection { background-color: #fff; border: 1px solid #e0e0e0; border-radius: 8px; overflow: hidden; box-shadow: 0 2px 5px rgba(0,0,0,0.05); display: flex; flex-direction: column; height: 100%; }
        .book-card-my-collection img { width: 100%; aspect-ratio: 2 / 3; object-fit: cover; background: linear-gradient(135deg,#eee,#ccc); }
        .book-card-content-my-collection { padding: 1rem; flex-grow: 1; display: flex; flex-direction: column; justify-content: space-between; }
        .book-card-content-my-collection h3 { font-size: 1.125rem; font-weight: 600; margin-bottom: 0.5rem; margin-top: 0; line-height: 1.4; }
        .book-card-details-my-collection { font-size: 0.875rem; color: #4a5568; margin-bottom: 1rem; }
        .book-card-details-my-collection p { margin: 0.25rem 0; }
        .book-card-details-my-collection strong { color: #111; }
        .review-button { display: inline-block; width: 100%; text-align: center; background-color: #10b981; color: white !important; font-weight: 700; padding: 0.5rem 1rem; border-radius: 0.25rem; transition: background-color 0.3s; box-sizing: border-box; }
        .review-button:hover { background-color: #059669; }
        .review-status { display: block; width: 100%; text-align: center; color: #6b7280; margin-top: 0.5rem; }
        .no-items-panel { border: 1px dashed #e2e8f0; border-radius: 0.5rem; padding: 1.5rem; text-align: center; color: #6b7280; background-color: #fafafa; grid-column: 1 / -1; }

    </style>
</head>
<body>
    <form id="form1" runat="server">

        <!-- Header -->
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
            <h1 class="section-title">คอลเลกชันของฉัน</h1>

            <div class="content-layout">

                <!-- Order History -->
                <div>
                    <h2 class="section-title-2">ประวัติการสั่งซื้อ</h2>
                    <asp:Repeater ID="rptOrders" runat="server"
                        OnItemDataBound="rptOrders_ItemDataBound"
                        OnItemCommand="rptOrders_ItemCommand">
                        <ItemTemplate>
                            <div class="order-item">
                                <div class="order-item-header">
                                    <h3>คำสั่งซื้อที่ #<%# Eval("OrderID") %></h3>
                                    <span>วันที่: <%# Eval("OrderDate", "{0:dd/MM/yyyy}") %></span>
                                </div>
                                <div class="order-item-details">
                                    <span class="total">ยอดรวม: <%# Eval("TotalAmount", "{0:N2}") %> บาท</span>
                                    <div class="status-container">
                                        <span class="status <%# GetStatusClass(Eval("Status").ToString()) %>">
                                            <%# Eval("Status") %>
                                        </span>
                                        <asp:Button ID="btnPay" runat="server"
                                            Text="ชำระเงิน"
                                            CssClass="btn-pay"
                                            CommandName="Pay"
                                            CommandArgument='<%# Eval("OrderID") %>'
                                            Visible='<%# Eval("Status").ToString() == "รอการชำระเงิน" %>'
                                            OnClientClick="return confirm('ยืนยันการชำระเงินสำหรับคำสั่งซื้อนี้?');"
                                            />
                                        <%-- [ <<< แก้ไข: Group ปุ่ม Received และ Cancel ด้วย Panel >>> ] --%>
                                        <asp:Panel runat="server" Visible='<%# Eval("Status").ToString() == "กำลังจัดส่ง" %>' style="display:inline-flex; gap: 0.5rem;">
                                            <asp:Button ID="btnReceived" runat="server"
                                                Text="ได้รับสินค้าแล้ว"
                                                CssClass="btn-received"
                                                CommandName="Received"
                                                CommandArgument='<%# Eval("OrderID") %>'
                                                OnClientClick="return confirm('ยืนยันว่าได้รับสินค้าสำหรับคำสั่งซื้อนี้แล้ว?');"
                                                />
                                            <asp:Button ID="btnCancelOrder" runat="server"
                                                Text="ยกเลิกสินค้า"
                                                CssClass="btn-cancel-order"
                                                CommandName="CancelOrder"
                                                CommandArgument='<%# Eval("OrderID") %>'
                                                OnClientClick="return confirm('คุณต้องการยกเลิกคำสั่งซื้อนี้ใช่หรือไม่?');"
                                                />
                                        </asp:Panel>
                                    </div>
                                </div>

                                <div class="order-book-list">
                                    <h4>รายการหนังสือ:</h4>
                                    <ul>
                                        <asp:Repeater ID="rptOrderBooks" runat="server">
                                            <ItemTemplate>
                                                <li><%# Eval("Title") %> (จำนวน: <%# Eval("Quantity") %>)</li>
                                            </ItemTemplate>
                                        </asp:Repeater>
                                    </ul>
                                    <asp:Panel runat="server" Visible='<%# ((Repeater)Container.FindControl("rptOrderBooks")).Items.Count == 0 %>'>
                                        <p style="margin-left: 0.5rem;"><em>(ไม่มีรายการหนังสือในคำสั่งซื้อนี้)</em></p>
                                    </asp:Panel>
                                </div>
                            </div>
                        </ItemTemplate>
                        <FooterTemplate>
                            <asp:Panel runat="server" ID="pnlNoOrders" Visible='<%# rptOrders.Items.Count == 0 %>'>
                                <div class="no-items-panel">
                                    คุณยังไม่มีประวัติการสั่งซื้อ
                                </div>
                            </asp:Panel>
                        </FooterTemplate>
                    </asp:Repeater>
                </div>

                <!-- My Books for Review -->
                <div>
                    <h2 class="section-title-2">หนังสือของฉัน</h2>
                    <div class="my-books-grid">
                        <asp:Repeater ID="rptMyBooks" runat="server" OnItemDataBound="rptMyBooks_ItemDataBound">
                            <ItemTemplate>
                                <div class="book-card-my-collection">
                                    <asp:Image ID="imgBookCover" runat="server" />
                                    <div class="book-card-content-my-collection">
                                        <div>
                                            <h3>
                                                <asp:Label ID="lblBookTitle" runat="server" Text='<%# Eval("Title") %>'></asp:Label>
                                            </h3>
                                            <div class="book-card-details-my-collection">
                                                <p><strong>ผู้แต่ง:</strong> <asp:Label ID="lblAuthors" runat="server"></asp:Label></p>
                                                <p><strong>หมวดหมู่:</strong> <asp:Label ID="lblCategory" runat="server"></asp:Label></p>
                                                <p><strong>Edition:</strong> <asp:Label ID="lblEdition" runat="server"></asp:Label></p>
                                            </div>
                                        </div>
                                        <div>
                                            <asp:HyperLink ID="hlReview" runat="server"
                                                CssClass="review-button">
                                                เขียนรีวิว
                                            </asp:HyperLink>
                                            <asp:Label ID="lblReviewStatus" runat="server"
                                                CssClass="review-status"
                                                Visible="false">
                                            </asp:Label>
                                        </div>
                                    </div>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                        <asp:Panel runat="server" ID="pnlNoBooks" Visible='<%# rptMyBooks.Items.Count == 0 %>' CssClass="no-items-panel">
                             คุณยังไม่มีหนังสือที่จัดส่งแล้ว
                         </asp:Panel>
                    </div>
                </div>
            </div>
        </main>

    </form>
</body>
</html>

