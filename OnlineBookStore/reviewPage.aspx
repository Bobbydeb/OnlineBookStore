<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="reviewPage.aspx.cs" Inherits="OnlineBookStore.reviewPage" %>

<!DOCTYPE html>
<html lang="th">
<head runat="server">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>เขียนรีวิว</title>
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
        
        /* --- CSS เฉพาะสำหรับหน้า Review --- */
        .review-layout {
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        .review-form-container {
            background-color: #fff;
            border: 1px solid #e0e0e0;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
            padding: 2rem;
            width: 100%;
            max-width: 600px;
            box-sizing: border-box;
        }

        /* [แก้ไข] Layout หนังสือแนวตั้ง */
        .review-book-info {
            display: flex;
            flex-direction: column; /* แนวตั้ง */
            align-items: center;   /* จัดกลาง */
            gap: 1rem;             /* ช่องว่างระหว่างรูปกับข้อความ */
            margin-bottom: 2rem;
            border-bottom: 1px solid #eee;
            padding-bottom: 1.5rem;
        }
        .review-book-info img {
            width: 100%;
            max-width: 300px;
            height: 450px;         /* [แก้ไข] เปลี่ยนเป็น 450px เพื่อสัดส่วน 2:3 */
            object-fit: cover;
            border-radius: 8px;    /* ทำให้ขอบมน */
            background-color: #f4f4f4;
        }
        /* [เพิ่ม] Container สำหรับรายละเอียดหนังสือ */
        .review-book-details {
            text-align: center;
            width: 100%;
        }
        .review-book-details h2 { /* Title */
            font-size: 1.5rem;
            font-weight: 600;
            margin: 0.5rem 0;
        }
        /* [เพิ่ม] สไตล์สำหรับรายละเอียด (Author, Category, Edition) */
        .review-book-details p {
            font-size: 0.9rem;
            color: #444;
            margin: 0.25rem 0;
        }
        .review-book-details p strong {
            color: #111;
        }
        /* [สิ้นสุด] */


        .form-group {
            margin-bottom: 1.5rem;
        }
        .form-group label {
            display: block;
            font-size: 1rem;
            font-weight: 600;
            margin-bottom: 0.5rem;
        }
        .form-group select,
        .form-group textarea {
            width: 100%;
            padding: 0.75rem;
            font-size: 1rem;
            border: 1px solid #ccc;
            border-radius: 6px;
            box-sizing: border-box; 
            font-family: Arial, sans-serif;
        }
        .form-group textarea {
            min-height: 150px;
            resize: vertical;
        }

        .form-actions {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 1rem;
        }
        
        .btn-submit {
            background-color: #10b981; /* สีเขียว */
            color: white;
            font-weight: 700;
            padding: 0.75rem 1.5rem;
            border: none;
            border-radius: 6px;
            font-size: 1rem;
            cursor: pointer;
            transition: background-color 0.3s;
        }
        .btn-submit:hover {
            background-color: #059669;
        }

        .btn-back {
            color: #4a5568;
            font-size: 0.95rem;
            transition: color 0.3s;
        }
        .btn-back:hover {
            color: #111;
        }

        .error-message {
            color: #d90000;
            margin-bottom: 1rem;
            font-weight: 600;
        }
        
        .review-done-message {
             text-align: center;
             font-size: 1.1rem;
             color: #333;
        }

    </style>
</head>
<body>
    <form id="form1" runat="server">

        <!-- Header (เหมือนเดิม) -->
        <header class="top-header">
            <div class="container">
                <div class="logo">MyBookstore</div>
                <<div class="header-icons">
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

        <!-- Navigation bar (เหมือนเดิม) -->
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
                    <li><a href="reviewHistoryPage.aspx">ประวัติการรีวิว</a></li>
                </ul>
            </div>
        </nav>

        <!-- Main Content -->
        <main class="container">
            <div class="review-layout">
                
                <div class="review-form-container">
                    <h1 class="section-title" style="margin-top: 0;">เขียนรีวิว</h1>
                    
                    <!-- [แก้ไข] HTML Layout หนังสือแนวตั้ง -->
                    <div class="review-book-info">
                        <asp:Image ID="imgBookCover" runat="server" />
                        <div class="review-book-details">
                            <!-- [แก้ไข] เพิ่ม font-weight: bold; -->
                            <span style="font-size: 0.9rem; color: #555; font-weight: bold;">คุณกำลังรีวิว:</span>
                            <asp:Label ID="lblBookTitle" runat="server" TagName="h2" Text="กำลังโหลด..."></asp:Label>
                            
                            <!-- [เพิ่ม] แสดงรายละเอียด -->
                            <p><strong>ผู้แต่ง:</strong> <asp:Label ID="lblAuthors" runat="server"></asp:Label></p>
                            <p><strong>หมวดหมู่:</strong> <asp:Label ID="lblCategory" runat="server"></asp:Label></p>
                            <p><strong>Edition:</strong> <asp:Label ID="lblEdition" runat="server"></asp:Label></p>
                        </div>
                    </div>
                    <!-- [สิ้นสุด] -->


                    <!-- Panel สำหรับฟอร์มรีวิว -->
                    <asp:Panel ID="pnlReviewForm" runat="server">
                        <asp:Label ID="lblErrorMessage" runat="server" CssClass="error-message" Visible="false"></asp:Label>
                        
                        <div class="form-group">
                            <label for="ddlRating">คะแนน (Rating)</label>
                            <asp:DropDownList ID="ddlRating" runat="server" CssClass="form-control"></asp:DropDownList>
                        </div>
                        
                        <div class="form-group">
                            <label for="txtComment">ความคิดเห็น (Comment)</label>
                            <asp:TextBox ID="txtComment" runat="server" TextMode="MultiLine" CssClass="form-control" Rows="6"></asp:TextBox>
                        </div>

                        <div class="form-actions">
                             <asp:Button ID="btnSubmitReview" runat="server" Text="ส่งรีวิว" CssClass="btn-submit" OnClick="btnSubmitReview_Click" />
                             <asp:HyperLink ID="hlBack" runat="server" NavigateUrl="~/myCollectionPage.aspx" CssClass="btn-back">กลับไปหน้าคอลเลกชัน</asp:HyperLink>
                        </div>
                    </asp:Panel>
                    
                    <!-- Panel สำหรับแสดงผลเมื่อรีวิวแล้ว -->
                     <asp:Panel ID="pnlReviewDone" runat="server" Visible="false" CssClass="review-done-message">
                        <p>คุณได้รีวิวหนังสือเล่มนี้ไปแล้ว</p>
                        <asp:HyperLink ID="hlBack2" runat="server" NavigateUrl="~/myCollectionPage.aspx" CssClass="btn-back" Font-Bold="true">กลับไปหน้าคอลเลกชัน</asp:HyperLink>
                    </asp:Panel>

                </div>

            </div>
        </main>

    </form>
</body>
</html>

