<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="cartPage.aspx.cs" Inherits="OnlineBookStore.cartPage" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>ตะกร้าสินค้า</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        /* --- CSS จาก mainpage.aspx --- */
        body { font-family: Arial, sans-serif; margin: 0; background-color: #f0f2f5; color: #333; }
        a { text-decoration: none; color: inherit; }
        .container {
            width: 90%;
            margin: 0 auto;
            max-width: 1200px;
        }

        /* Header */
        .top-header { background-color: #fff; padding: 10px 0; border-bottom: 1px solid #ddd; }
        .top-header .container { display: flex; justify-content: space-between; align-items: center; }
        .logo { font-size: 1.5rem; font-weight: bold; color: #d90000; }

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

        .header-icons { display: flex; gap: 15px; font-size: 0.95rem; align-items: center; }
        .header-icons a { text-decoration: none; color: inherit; }
        .header-icons .asp-link-button { text-decoration: none; color: inherit; font-size: 0.95rem; } /* Style LinkButton */
        .header-icons .asp-link-button:hover { text-decoration: underline; }

        .cart-count {
            display: inline;
            color: white;
            background-color: #d90000;
            border-radius: 50%;
            padding: 2px 6px;
            font-size: 0.8rem;
            vertical-align: top;
            margin-left: 2px;
        }
        .cart-count.empty {
            display: none;
        }


        /* Nav */
        .main-nav {
            background-color: #333;
            color: #fff;
            padding: 6px 0;
            position: relative;
            z-index: 10;
        }
        .main-nav .container { display: flex; justify-content: center; align-items: center; }
        .main-nav ul { list-style: none; margin: 0; padding: 0; display: flex; gap: 10px; flex-wrap: wrap; justify-content: center; }
        .main-nav li { position: relative; }
        .main-nav li a { padding: 6px 10px; font-size: 0.9rem; display: block; border-radius: 5px; transition: background-color 0.2s; color: #fff; }
        .main-nav li a:hover { background-color: #555; }

        /* Dropdown */
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
        /* --- [จบ] CSS จาก mainpage.aspx --- */


        /* --- CSS ของ cartPage.aspx --- */
        .cart-container {
            width: 90%;
            max-width: 960px; /* ใช้ max-width ที่เหมาะสมสำหรับหน้าตะกร้า */
            margin: 20px auto;
            background-color: #fff;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        h1 { margin-top: 0; }
        .cart-container a { text-decoration: none; color: #d90000; font-weight: bold; }

        /* ตารางสินค้า */
        .cart-grid { border-collapse: collapse; width: 100%; margin-top: 20px; }
        .cart-grid th, .cart-grid td { padding: 15px; text-align: left; border-bottom: 1px solid #eee; }
        .cart-grid th { background-color: #f9f9f9; font-size: 0.9rem; text-transform: uppercase; color: #555; }
        .cart-grid td { vertical-align: middle; }

        .cart-item-image { width: 80px; height: 120px; object-fit: cover; border-radius: 4px; margin-right: 15px; }
        .cart-item-info { display: flex; align-items: center; }
        .cart-item-details { flex-grow: 1; }
        .cart-item-details .title { font-weight: bold; font-size: 1.1rem; display: block; margin-bottom: 5px; color: #333; }
        .cart-item-details .meta { font-size: 0.9rem; color: #777; }

        .cart-quantity input { width: 60px; padding: 8px; text-align: center; border: 1px solid #ccc; border-radius: 4px; }
        .cart-price { font-size: 1.1rem; color: #333; }
        .cart-remove a, .cart-remove .asp-link-button { color: #d90000; font-size: 0.9rem; font-weight: bold; }

        /* สรุปราคา */
        .cart-summary { margin-top: 30px; padding-top: 20px; border-top: 2px solid #ddd; width: 100%; max-width: 400px; margin-left: auto; }
        .summary-row { display: flex; justify-content: space-between; padding: 10px 0; font-size: 1.1rem; }
        .summary-row.total { font-size: 1.4rem; font-weight: bold; border-top: 1px solid #ccc; padding-top: 15px; margin-top: 10px; }

        /* ปุ่มดำเนินการ */
        .cart-actions { margin-top: 30px; text-align: right; }
        .btn { padding: 12px 25px; border: none; border-radius: 5px; font-size: 1rem; font-weight: bold; cursor: pointer; text-decoration: none; display: inline-block; }
        .btn-primary { background-color: #d90000; color: white; }
        .btn-primary:hover { background-color: #b00000; }
        .btn-secondary { background-color: #f0f0f0; color: #333; border: 1px solid #ccc; margin-right: 10px; font-weight: normal; }
        .btn-secondary:hover { background-color: #e0e0e0; }

        /* ข้อความตะกร้าว่าง */
        .empty-cart-message {
            text-align: center;
            padding: 50px;
            font-size: 1.2rem;
            color: #777;
        }
        .empty-cart-message a.btn-primary {
            margin-top: 20px;
            font-weight: bold;
        }

    </style>
</head>
<body>
    <form id="form1" runat="server">

        <!-- Header (เหมือน mainpage.aspx) -->
        <header class="top-header">
            <div class="container">
                <div class="logo"><a href="mainpage.aspx">MyBookstore</a></div>
                <div class="search-bar">
                    <asp:TextBox ID="txtSearch" runat="server" placeholder="ค้นหาหนังสือ..." CssClass="search-input"></asp:TextBox>
                    <asp:Button ID="btnSearch" runat="server" Text="ค้นหา" OnClick="btnSearch_Click" CssClass="search-button" />
                </div>
                <div class="header-icons">
                    <asp:LinkButton ID="btnLogin" runat="server" PostBackUrl="~/loginPage.aspx" CssClass="asp-link-button">
                        Login
                    </asp:LinkButton>
                    <asp:LinkButton ID="btnLogout" runat="server" OnClick="btnLogout_Click" ForeColor="Red" Visible="false" CssClass="asp-link-button">
                        Logout
                    </asp:LinkButton>
                    <a href="cartPage.aspx" class="cart-icon" title="ตะกร้าสินค้า" runat="server" id="cartLink">
                        🛒
                        <span runat="server" id="cartCount" class="cart-count empty">0</span>
                    </a>
                </div>
            </div>
        </header>

        <!-- Navigation bar (เหมือน mainpage.aspx) -->
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

        <!-- เนื้อหาหน้าตะกร้า -->
        <div class="cart-container">
            <h1>ตะกร้าสินค้า</h1>

            <!-- Panel สำหรับแสดงตะกร้าสินค้าเมื่อมีสินค้า -->
            <asp:Panel ID="pnlCart" runat="server" Visible="false">
                <table class="cart-grid">
                    <thead>
                        <tr>
                            <th colspan="2">สินค้า</th>
                            <th>ราคา</th>
                            <th>จำนวน</th>
                            <th>ราคารวม</th>
                            <th>&nbsp;</th>
                        </tr>
                    </thead>
                    <tbody>
                        <asp:Repeater ID="RepeaterCart" runat="server" OnItemCommand="RepeaterCart_ItemCommand">
                            <ItemTemplate>
                                <tr>
                                    <td style="width: 80px;">
                                        <img src='<%# Eval("CoverUrl") %>' alt='<%# Eval("Title") %>' class="cart-item-image" />
                                    </td>
                                    <td>
                                        <div class="cart-item-details">
                                            <a href='bookDetailPage.aspx?id=<%# Eval("BookID") %>' class="title"><%# Eval("Title") %></a>
                                            <span class="meta">BookID: <%# Eval("BookID") %></span>
                                        </div>
                                    </td>
                                    <td class="cart-price">฿<%# Eval("Price", "{0:N2}") %></td>
                                    <td class="cart-quantity">
                                        <%-- TextBox สำหรับอัปเดตจำนวน --%>
                                        <asp:TextBox ID="txtQuantity" runat="server" TextMode="Number" Text='<%# Eval("Quantity") %>' style="width: 60px; text-align:center; padding: 8px; border: 1px solid #ccc; border-radius: 4px;"></asp:TextBox>
                                        <asp:Button ID="btnUpdate" runat="server" Text="อัปเดต" CommandName="Update" CommandArgument='<%# Eval("BookID") %>' CssClass="btn-secondary" style="font-size: 0.8rem; padding: 6px 10px; margin-left: 5px; font-weight: normal;" />
                                    </td>
                                    <td class="cart-price"><strong>฿<%# Eval("TotalPrice", "{0:N2}") %></strong></td>
                                    <td class="cart-remove">
                                        <%-- LinkButton สำหรับลบ --%>
                                        <asp:LinkButton ID="btnRemove" runat="server" CommandName="Remove" CommandArgument='<%# Eval("BookID") %>' OnClientClick="return confirm('คุณต้องการลบสินค้านี้ใช่หรือไม่?');" CssClass="asp-link-button">ลบ</asp:LinkButton>
                                    </td>
                                </tr>
                            </ItemTemplate>
                        </asp:Repeater>
                    </tbody>
                </table>

                <div class="cart-summary">
                    <div class="summary-row">
                        <span>ราคารวม (ยังไม่รวมค่าส่ง)</span>
                        <span><asp:Literal ID="ltlSubtotal" runat="server" Text="฿0.00"></asp:Literal></span>
                    </div>
                    <div class="summary-row">
                        <span>ค่าจัดส่ง</span>
                        <span><asp:Literal ID="ltlShipping" runat="server" Text="฿50.00"></asp:Literal></span>
                    </div>
                    <div class="summary-row total">
                        <span>ยอดรวมทั้งสิ้น</span>
                        <span><asp:Literal ID="ltlTotal" runat="server" Text="฿0.00"></asp:Literal></span>
                    </div>
                </div>

                <div class="cart-actions">
                    <a href="mainpage.aspx" class="btn btn-secondary">เลือกซื้อสินค้าต่อ</a>
                     <%-- [ << แก้ไข >> ] เปลี่ยน Text ปุ่ม --%>
                    <asp:Button ID="btnCheckout" runat="server" Text="ยืนยันคำสั่งซื้อ" CssClass="btn btn-primary" OnClick="btnCheckout_Click" />
                </div>
            </asp:Panel>

             <!-- Panel สำหรับแสดงข้อความ "ตะกร้าว่าง" -->
            <asp:Panel ID="pnlEmptyCart" runat="server" Visible="true" CssClass="empty-cart-message">
                <p>ตะกร้าสินค้าของคุณว่างเปล่า</p>
                <a href="mainpage.aspx" class="btn btn-primary">กลับไปเลือกซื้อสินค้า</a>
            </asp:Panel>

             <%-- [เพิ่ม] อาจจะเพิ่ม Label สำหรับแสดงข้อความ Error --%>
            <%-- <asp:Label ID="lblErrorMessage" runat="server" ForeColor="Red" Visible="false"></asp:Label> --%>

        </div>
    </form>
</body>
</html>
