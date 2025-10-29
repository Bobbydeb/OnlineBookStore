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
        /* [เพิ่ม] CSS สำหรับ Cart Count */
        .cart-count {
            display: inline;
            color: white;
            background-color: #d90000;
            border-radius: 50%;
            padding: 2px 6px;
            font-size: 0.8rem;
        }
        .cart-count.empty {
            display: none;
        }


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
        
        /* [เพิ่ม] CSS สำหรับ Author */
        .book-author {
            font-size: 0.85rem;
            color: #555;
            margin: 6px 0;
            /* กรณีชื่อยาวมาก */
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
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

        /* --- [แก้ไข] Modal Styles (ปรับปรุงใหม่) --- */
        .modal-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.6);
            display: flex;
            align-items: center;
            justify-content: center;
            z-index: 1000;
            opacity: 0;
            visibility: hidden;
            transition: opacity 0.3s, visibility 0s 0.3s;
        }
        .modal-overlay.show {
            opacity: 1;
            visibility: visible;
            transition: opacity 0.3s;
        }
        .modal-content {
            background: #fff;
            padding: 25px;
            border-radius: 8px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.3);
            z-index: 1001;
            width: 90%;
            max-width: 600px; /* [ขยาย] ขยายความกว้างเพื่อรองรับข้อมูล */
            transform: translateY(-50px);
            transition: transform 0.3s ease-out;
            position: relative; /* สำหรับปุ่ม close */
        }
        .modal-overlay.show .modal-content {
            transform: translateY(0);
        }
        .modal-close {
            position: absolute;
            top: 10px;
            right: 15px;
            font-size: 28px;
            font-weight: bold;
            color: #aaa;
            cursor: pointer;
            line-height: 1;
        }
        .modal-close:hover { color: #333; }
        
        /* [แก้ไข] modal-body */
        .modal-body {
            display: flex;
            flex-direction: column; /* [เปลี่ยน] เป็นแนวตั้งสำหรับจอเล็ก */
            gap: 20px; 
            margin-top: 15px;
        }

        @media (min-width: 500px) { /* [เพิ่ม] เมื่อจอใหญ่ขึ้น ให้กลับเป็นแนวนอน */
             .modal-body {
                flex-direction: row;
             }
        }

        .modal-book-cover {
            width: 100%; /* [เปลี่ยน] */
            max-width: 200px; /* [เพิ่ม] */
            height: auto; /* [เปลี่ยน] */
            aspect-ratio: 2 / 3;
            object-fit: cover;
            border-radius: 4px;
            border: 1px solid #eee;
            flex-shrink: 0; 
            margin: 0 auto; /* [เพิ่ม] จัดกลางในจอเล็ก */
        }

        @media (min-width: 500px) {
             .modal-book-cover {
                width: 200px;
                height: 300px;
                margin: 0;
             }
        }


        .modal-details {
            flex-grow: 1; 
        }

        /* [เพิ่ม] CSS สำหรับรายละเอียด (ผู้แต่ง, edition, etc.) */
        .modal-details h3 { /* Title */
            margin-top: 0;
            font-size: 1.6rem;
        }
        .modal-details p {
            margin: 6px 0;
        }
        .modal-book-price {
            font-size: 1.4rem; 
            font-weight: bold; 
            color: #d90000;
            margin-top: 10px;
        }
        .modal-book-meta {
             font-size: 0.9rem;
             color: #555;
             margin: 10px 0;
             border-top: 1px solid #f0f0f0;
             padding-top: 10px;
        }
        .modal-book-meta span {
            display: block; /* [เปลี่ยน] ให้แสดงคนละบรรทัด */
            margin-bottom: 4px; /* [เพิ่ม] */
        }

        /* [เพิ่ม] CSS สำหรับ Review */
        .modal-review-summary {
            margin-top: 10px;
            padding-top: 10px;
            border-top: 1px solid #f0f0f0;
        }
        .modal-review-summary .stars {
            font-size: 1.2rem;
            color: #f59e0b; /* สีเหลือง */
        }
        .modal-review-summary .stars .no-rating {
            color: #ccc;
        }
        .modal-review-summary .review-count {
            font-size: 0.9rem;
            color: #666;
            margin-left: 8px;
        }


        .modal-quantity-section {
             margin-top: 20px;
             padding-top: 20px;
             border-top: 1px solid #f0f0f0;
        }

        .modal-quantity {
            width: 70px; 
            padding: 8px; 
            font-size: 1rem; 
            border-radius: 4px; 
            border: 1px solid #ccc; 
            margin-left: 10px; /* [เพิ่ม] */
            box-sizing: border-box; 
        }

        .modal-footer {
            text-align: right;
            padding-top: 20px; 
            margin-top: 20px; /* [เพิ่ม] */
            border-top: 1px solid #eee;
        }
        
        /* [เพิ่ม] CSS สำหรับ Modal Message */
        #modalMessage {
            font-size: 0.9rem;
            padding: 10px;
            border-radius: 5px;
            display: none; /* ซ่อนไว้ก่อน */
            margin-top: 10px;
            text-align: left;
        }
        #modalMessage.success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        #modalMessage.error {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }


        .modal-btn-add {
            background-color: #d90000;
            color: white;
            border: none;
            padding: 10px 20px;
            font-size: 1rem;
            font-weight: bold;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.2s;
        }
        .modal-btn-add:hover { background-color: #b00000; }
        .modal-btn-add:disabled {
            background-color: #ccc;
            cursor: not-allowed;
        }


        .modal-btn-cancel {
            background-color: #f0f0f0;
            color: #333;
            border: 1px solid #ccc;
            padding: 10px 20px;
            font-size: 1rem;
            border-radius: 5px;
            cursor: pointer;
            margin-right: 10px;
            transition: background-color 0.2s;
        }
        .modal-btn-cancel:hover { background-color: #e0e0e0; }

        /* ทำให้การ์ดหนังสือมี cursor pointer */
        .js-book-card {
            cursor: pointer;
        }
        /* --- [จบ] Modal Styles --- */


    </style>
</head>
<body>
    <form id="form1" runat="server">
        <!-- [เพิ่ม] ScriptManager จำเป็นสำหรับการเรียก WebMethod (AJAX) -->
        <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true"></asp:ScriptManager>

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
                        <!-- [แก้ไข] cartCount จะถูกเติมค่าจาก C# code-behind -->
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
                         <!-- [แก้ไข] เพิ่ม class 'js-book-card' และ data attributes ทั้งหมด -->
                        <div class="book-card js-book-card"
                             data-bookid="<%# Eval("BookID") %>"
                             data-title="<%# Eval("Title") %>"
                             data-price="<%# Eval("Price", "{0:F2}") %>"
                             data-cover="<%# Eval("CoverUrl") %>"
                             data-authors="<%# Eval("Authors") %>"
                             data-edition="<%# Eval("Edition") %>"
                             data-category="<%# Eval("CategoryName") %>"
                             data-avg-rating="<%# Eval("AvgRating", "{0:F1}") %>"
                             data-review-count="<%# Eval("ReviewCount") %>"
                             >
                            <img src='<%# Eval("CoverUrl") %>' alt='<%# Eval("Title") %>' />
                            <div class="book-card-content">
                                <div>
                                    <h3 class="book-title"><%# Eval("Title") %></h3>
                                    <!-- [เพิ่ม] แสดง Author บนการ์ด -->
                                    <p class="book-author"><%# Eval("Authors") %></p>
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
                         <!-- [แก้ไข] เพิ่ม class 'js-book-card' และ data attributes ทั้งหมด -->
                        <div class="book-card js-book-card"
                             data-bookid="<%# Eval("BookID") %>"
                             data-title="<%# Eval("Title") %>"
                             data-price="<%# Eval("Price", "{0:F2}") %>"
                             data-cover="<%# Eval("CoverUrl") %>"
                             data-authors="<%# Eval("Authors") %>"
                             data-edition="<%# Eval("Edition") %>"
                             data-category="<%# Eval("CategoryName") %>"
                             data-avg-rating="<%# Eval("AvgRating", "{0:F1}") %>"
                             data-review-count="<%# Eval("ReviewCount") %>"
                             >
                            <img src='<%# Eval("CoverUrl") %>' alt='<%# Eval("Title") %>' />
                            <div class="book-card-content">
                                <div>
                                    <h3 class="book-title"><%# Eval("Title") %></h3>
                                    <!-- [เพิ่ม] แสดง Author บนการ์ด -->
                                    <p class="book-author"><%# Eval("Authors") %></p>
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

         <!-- [แก้ไข] Add to Cart Modal HTML (ปรับปรุงใหม่ทั้งหมด) -->
        <div id="addToCartModal" class="modal-overlay">
            <div class="modal-content">
                <span class="modal-close" onclick="closeAddToCartModal()">&times;</span>
                <h2 style="margin-top:0;">เพิ่มสินค้าลงในตะกร้า</h2>
                
                <div class="modal-body">
                    <img id="modalBookCover" src="" alt="Book Cover" class="modal-book-cover" />
                    <div class="modal-details">
                        <h3 id="modalBookTitle">Book Title</h3>
                        
                        <div class="modal-book-meta">
                            <span id="modalBookAuthors"></span>
                            <span id="modalBookEdition"></span>
                            <span id="modalBookCategory"></span>
                        </div>

                        <div id="modalBookReviews" class="modal-review-summary">
                            <!-- JS will populate this -->
                        </div>

                        <p id="modalBookPrice" class="modal-book-price">฿0.00</p>
                        
                        <div class="modal-quantity-section">
                            <label for="modalQuantity" style="font-weight: bold;">จำนวน:</label>
                            <input id="modalQuantity" type="number" value="1" min="1" class="modal-quantity" />
                        </div>
                    </div>
                </div>
                
                <!-- [เพิ่ม] Modal Message container -->
                <div id="modalMessage"></div>

                <div class="modal-footer">
                    <button type="button" class="modal-btn-cancel" onclick="closeAddToCartModal()">ยกเลิก</button>
                    <button type="button" id="btnModalAddToCart" class="modal-btn-add">เพิ่มลงตะกร้า</button>
                </div>
            </div>
        </div>
        <!-- [จบ] Modal -->


    </form>
    
    <!-- [แก้ไข] JavaScript สำหรับ Modal (ปรับปรุงใหม่) -->
    <script type="text/javascript">
        // Get modal elements
        const modal = document.getElementById('addToCartModal');
        const modalBookCover = document.getElementById('modalBookCover');
        const modalBookTitle = document.getElementById('modalBookTitle');
        const modalBookPrice = document.getElementById('modalBookPrice');
        const modalQuantity = document.getElementById('modalQuantity');
        const btnModalAddToCart = document.getElementById('btnModalAddToCart');

        // [เพิ่ม] Get new modal elements
        const modalBookAuthors = document.getElementById('modalBookAuthors');
        const modalBookEdition = document.getElementById('modalBookEdition');
        const modalBookCategory = document.getElementById('modalBookCategory');
        const modalBookReviews = document.getElementById('modalBookReviews');
        const modalMessage = document.getElementById('modalMessage'); // [เพิ่ม]
            
        // Store current book ID
        let currentBookId = null;

        // [เพิ่ม] Function to generate star rating
        function generateStarRating(rating) {
            rating = Math.round(rating * 2) / 2; // Round to nearest 0.5
            let stars = '';
            for (let i = 1; i <= 5; i++) {
                if (rating >= i) {
                    stars += '★'; // Full star
                } else if (rating >= (i - 0.5)) {
                    stars += '★'; // (ใช้ดาวเต็มดวงแทนครึ่งดวงเพื่อความง่าย)
                } else {
                    stars += '☆'; // Empty star
                }
            }
            return stars;
        }

        // [แก้ไข] Function to open the modal
        function openAddToCartModal(cardElement) {
            // Get data from data-* attributes
            currentBookId = cardElement.getAttribute('data-bookid');
            const title = cardElement.getAttribute('data-title');
            const price = cardElement.getAttribute('data-price');
            const cover = cardElement.getAttribute('data-cover');
            
            // [เพิ่ม] Get new data
            const authors = cardElement.getAttribute('data-authors');
            const edition = cardElement.getAttribute('data-edition');
            const category = cardElement.getAttribute('data-category');
            const avgRating = parseFloat(cardElement.getAttribute('data-avg-rating'));
            const reviewCount = parseInt(cardElement.getAttribute('data-review-count'), 10);


            // Populate modal
            modalBookCover.src = cover;
            modalBookCover.alt = title; 
            modalBookTitle.textContent = title;
            modalBookPrice.textContent = '฿' + price;
            modalQuantity.value = 1; // Reset quantity to 1
            
            // [เพิ่ม] Reset modal message
            modalMessage.style.display = 'none';
            modalMessage.className = '';
            btnModalAddToCart.disabled = false;


            // [เพิ่ม] Populate new elements
            modalBookAuthors.textContent = 'โดย: ' + (authors && authors !== 'N/A' ? authors : 'ไม่ระบุผู้แต่ง');
            modalBookEdition.textContent = 'Edition: ' + (edition ? edition : 'N/A');
            modalBookCategory.textContent = 'หมวดหมู่: ' + (category ? category : 'N/A');

            // [เพิ่ม] Populate reviews
            if (reviewCount > 0) {
                const stars = generateStarRating(avgRating);
                modalBookReviews.innerHTML = 
                    `<span class="stars">${stars}</span>` +
                    `<span class="review-count">(${avgRating.toFixed(1)} จาก ${reviewCount} รีวิว)</span>`;
            } else {
                modalBookReviews.innerHTML = 
                    `<span class="stars no-rating">☆☆☆☆☆</span>` +
                    `<span class="review-count">(ยังไม่มีรีวิว)</span>`;
            }

            // Show modal
            modal.classList.add('show');
        }

        // Function to close the modal
        function closeAddToCartModal() {
            modal.classList.remove('show');
        }

        // [เพิ่ม] Function to show modal message
        function showModalMessage(message, isError = false) {
            modalMessage.textContent = message;
            modalMessage.className = isError ? 'error' : 'success';
            modalMessage.style.display = 'block';
        }

        // [เพิ่ม] Function to update the cart count on the header
        function updateCartHeader(count) {
            const cartCountElement = document.getElementById('<%= cartCount.ClientID %>');
            if (cartCountElement) {
                if (count > 0) {
                    cartCountElement.textContent = count;
                    cartCountElement.className = 'cart-count'; // Ensure it's visible
                } else {
                    cartCountElement.textContent = '0';
                    cartCountElement.className = 'cart-count empty'; // Hide if empty
                }
            }
        }


        // Add click event listeners to all book cards
        document.addEventListener('DOMContentLoaded', function () {
            document.querySelectorAll('.js-book-card').forEach(card => {
                card.addEventListener('click', function () {
                    openAddToCartModal(this);
                });
            });
        });

        // [แก้ไข] Handle "Add to Cart" button click inside the modal (AJAX call)
        btnModalAddToCart.addEventListener('click', function () {
            const quantity = parseInt(modalQuantity.value, 10);

            if (quantity > 0 && currentBookId) {
                console.log(`Sending to server: BookID ${currentBookId}, Quantity: ${quantity}`);

                // Disable button
                btnModalAddToCart.disabled = true;
                showModalMessage('กำลังเพิ่มสินค้า...', false);

                // --- นี่คือการเรียก WebMethod (AJAX) ---
                fetch('mainpage.aspx/AddToCart', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json; charset=utf-8'
                    },
                    body: JSON.stringify({
                        bookId: parseInt(currentBookId, 10),
                        quantity: quantity
                    })
                })
                    .then(response => {
                        if (!response.ok) {
                            throw new Error('Network response was not ok');
                        }
                        return response.json();
                    })
                    .then(data => {
                        const result = data.d; // ASP.NET WebMethods wrap response in ".d"

                        if (result.success) {
                            // 1. Update header count
                            updateCartHeader(result.newCount);

                            // 2. Show success message
                            showModalMessage('เพิ่มสินค้าลงตะกร้าเรียบร้อย!', false);

                            // 3. Close modal after a short delay
                            setTimeout(() => {
                                closeAddToCartModal();
                            }, 1000);

                        } else {
                            // Show error message (e.g., "Please log in")
                            showModalMessage('เกิดข้อผิดพลาด: ' + result.message, true);
                            btnModalAddToCart.disabled = false; // Re-enable button
                        }
                    })
                    .catch(error => {
                        console.error('Error adding to cart:', error);
                        showModalMessage('เกิดข้อผิดพลาดในการเชื่อมต่อ', true);
                        btnModalAddToCart.disabled = false; // Re-enable button
                    });
            }
        });

        // Close modal if overlay (backdrop) is clicked
        modal.addEventListener('click', function (e) {
            // ถ้าคลิกที่ .modal-overlay (พื้นหลังสีเทา) ให้ปิด
            if (e.target === modal) {
                closeAddToCartModal();
            }
        });

    </script>

</body>
</html>
