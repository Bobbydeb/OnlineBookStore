<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="categoryPage.aspx.cs" Inherits="OnlineBookStore.categoryPage" %>

<!DOCTYPE html>
<html lang="th">
<head runat="server">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>หมวดหมู่หนังสือ</title>
    <!-- ใช้ CSS ชุดเดียวกับ mainpage.aspx -->
    <style>
        body { font-family: Arial, sans-serif; margin: 0; background-color: #f0f2f5; color: #333; }
        a { text-decoration: none; color: inherit; }
        .container { width: 90%; max-width: 1200px; margin: 0 auto; }

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
        .header-icons { display: flex; gap: 15px; font-size: 0.95rem; }

        /* Nav */
        .main-nav { background-color: #333; color: #fff; padding: 6px 0; position: relative; z-index: 10; }
        .main-nav .container { display: flex; justify-content: center; align-items: center; }
        .main-nav ul { list-style: none; margin: 0; padding: 0; display: flex; gap: 10px; flex-wrap: wrap; justify-content: center; }
        .main-nav li { position: relative; }
        .main-nav li a { padding: 6px 10px; font-size: 0.9rem; display: block; border-radius: 5px; transition: background-color 0.2s; color: #fff; }
        .main-nav li a:hover { background-color: #555; }

        /* Dropdown */
        .main-nav li.dropdown { position: relative; } 
        .main-nav .dropdown-content { display: none; position: absolute; top: 100%; left: 0; background-color: #444; min-width: 200px; border-radius: 6px; padding: 8px 0; box-shadow: 0 6px 16px rgba(0,0,0,0.2); z-index: 999; }
        .main-nav .dropdown-content li a { padding: 8px 14px; font-size: 0.9rem; display: block; color: #fff; }
        .main-nav .dropdown-content li a:hover { background-color: #555; }
        .main-nav li.dropdown:hover .dropdown-content { display: block; }

        /* Content */
        main { padding: 20px 0; }
        .section-title { font-size: 1.8rem; font-weight: bold; margin: 20px 0; color: #111; }
        
        .book-grid { 
            display: grid; 
            grid-template-columns: repeat(auto-fill, minmax(200px, 1fr)); 
            gap: 20px; 
        }

        .book-card { 
            background-color: #fff; 
            border: 1px solid #e0e0e0; 
            border-radius: 8px; 
            overflow: hidden; 
            box-shadow: 0 2px 5px rgba(0,0,0,0.05); 
            display: flex; 
            flex-direction: column;
            transition: transform 0.3s, box-shadow 0.3s;
        }
        .book-card:hover { 
            transform: translateY(-4px);             
            box-shadow: 0 4px 12px rgba(0,0,0,0.1); 
        }

        .book-card img{ width: 100%; aspect-ratio: 2 / 3; height: auto; object-fit: cover; background: linear-gradient(135deg,#eee,#ccc); }
        .book-card-content { padding: 15px; flex-grow: 1; display: flex; flex-direction: column; justify-content: space-between; }
        .book-card-content div { margin-bottom: 10px; }
        .book-title { font-size: 1rem; font-weight: 600; margin: 0 0 6px 0; }
        
        /* [เพิ่ม] book-author (เหมือน topSalePage) */
        .book-author {
            font-size: 0.85rem;
            color: #555;
            margin: 6px 0;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }
        .book-edition, .book-category { font-size: 0.9rem; color: #666; margin: 6px 0; }
        .book-price { font-size: 1.1rem; font-weight: bold; color: #d90000; margin-top: 6px; }
        
        .no-items-panel {
            border: 1px dashed #e2e8f0;
            border-radius: 0.5rem;
            padding: 1.5rem;
            text-align: center;
            color: #6b7280;
            background-color: #fafafa;
        }

        /* CSS สำหรับ Pagination */
        .pagination-container { display: flex; justify-content: center; margin-top: 2rem; }
        .pagination { list-style: none; display: flex; padding: 0; margin: 0; border-radius: 0.375rem; box-shadow: 0 1px 3px rgba(0,0,0,0.1); overflow: hidden; }
        .page-item { } 
        .page-link { display: block; padding: 0.75rem 1rem; color: #d90000; text-decoration: none; background-color: #fff; border: 1px solid #ddd; transition: background-color 0.2s; font-weight: 600; }
        .page-item:not(:first-child) .page-link { border-left: 0; }
        .page-item.active .page-link { z-index: 2; color: #fff; background-color: #d90000; border-color: #d90000; }
        .page-link:hover { background-color: #f7f7f7; }
        .page-item.active .page-link:hover { background-color: #d90000; }
        .page-link:disabled, .page-item.active .page-link { pointer-events: none; }

        
        /* --- [เพิ่ม] Modal Styles (คัดลอกจาก topSalePage) --- */
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
            padding: 30px; 
            border-radius: 8px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.3);
            z-index: 1001;
            width: 90%;
            max-width: 550px; 
            transform: translateY(-50px);
            transition: transform 0.3s ease-out;
            position: relative;
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

        .modal-body {
            display: flex;
            flex-direction: column;
            gap: 20px;
            margin-top: 15px;
        }
        @media (min-width: 500px) { .modal-body { flex-direction: row; } }

        .modal-book-cover {
            width: 100%;
            max-width: 200px;
            height: auto;
            aspect-ratio: 2 / 3;
            object-fit: cover;
            border-radius: 4px;
            border: 1px solid #eee;
            flex-shrink: 0;
            margin: 0 auto;
        }
        @media (min-width: 500px) { .modal-book-cover { width: 200px; height: 300px; margin: 0; } }

        .modal-details { flex-grow: 1; }
        .modal-details h3 { margin-top: 0; font-size: 1.8rem; }
        .modal-details p { margin: 6px 0; }
        .modal-book-price { font-size: 1.5rem; font-weight: bold; color: #d90000; margin-top: 12px; }
        
        .modal-book-meta { font-size: 0.95rem; color: #333; margin: 12px 0; border-top: none; padding-top: 0; }
        .modal-book-meta span { display: block; margin-bottom: 6px; }
        
        .modal-review-summary { margin-top: 12px; padding-top: 0; border-top: none; }
        .modal-review-summary .stars { font-size: 1.2rem; color: #f59e0b; }
        .modal-review-summary .stars .no-rating { color: #ccc; }
        .modal-review-summary .review-count { font-size: 0.9rem; color: #666; margin-left: 8px; }

        .modal-quantity-section { margin-top: 20px; padding-top: 0; border-top: none; }
        .modal-quantity { width: 70px; padding: 8px; font-size: 1rem; border-radius: 4px; border: 1px solid #ccc; margin-left: 10px; box-sizing: border-box; }

        #modalStockWarning { color: #d90000; margin-left: 10px; font-size: 0.9rem; display: none; }
        #modalOutOfStock { display: none; color: #d90000; font-weight: bold; margin-top: 20px; font-size: 1.1rem; }

        .modal-footer { text-align: right; padding-top: 20px; margin-top: 20px; border-top: 1px solid #eee; }

        .modal-btn-add { background-color: #e11d48; color: white; border: none; padding: 10px 20px; font-size: 1rem; font-weight: 600; border-radius: 5px; cursor: pointer; transition: background-color 0.2s; }
        .modal-btn-add:hover { background-color: #be123c; } 
        .modal-btn-add:disabled { background-color: #ccc; cursor: not-allowed; }

        .modal-btn-cancel { background-color: #e5e7eb; color: #374151; border: none; padding: 10px 20px; font-size: 1rem; font-weight: 600; border-radius: 5px; cursor: pointer; margin-right: 10px; transition: background-color 0.2s; }
        .modal-btn-cancel:hover { background-color: #d1d5db; } 

        .js-book-card { cursor: pointer; }
        /* --- [จบ] Modal Styles --- */

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
            <h1 class="section-title">
                หมวดหมู่: <asp:Literal ID="litCategoryName" runat="server" Text="กำลังโหลด..." />
            </h1>
            
             <%-- [เพิ่ม] Helper Function (เหมือน topSalePage แต่ตัด TotalSold) --%>
            <script runat="server">
                protected string GetBookCardTemplate(object dataItem)
                {
                    // ดึงค่าทั้งหมด
                    string bookID = DataBinder.Eval(dataItem, "BookID").ToString();
                    string title = DataBinder.Eval(dataItem, "Title").ToString();
                    string price = DataBinder.Eval(dataItem, "Price", "{0:F2}");
                    string coverUrl = DataBinder.Eval(dataItem, "CoverUrl").ToString();
                    string authors = DataBinder.Eval(dataItem, "Authors").ToString();
                    string edition = DataBinder.Eval(dataItem, "Edition").ToString();
                    string category = DataBinder.Eval(dataItem, "CategoryName").ToString();
                    string avgRating = DataBinder.Eval(dataItem, "AvgRating", "{0:F1}");
                    string reviewCount = DataBinder.Eval(dataItem, "ReviewCount").ToString();
                    string stock = DataBinder.Eval(dataItem, "Stock").ToString();

                    // สร้าง data attributes
                    string dataAttributes = $@"
                        data-bookid=""{bookID}""
                        data-title=""{Server.HtmlEncode(title)}""
                        data-price=""{price}""
                        data-cover=""{coverUrl}""
                        data-authors=""{Server.HtmlEncode(authors)}""
                        data-edition=""{Server.HtmlEncode(edition)}""
                        data-category=""{Server.HtmlEncode(category)}""
                        data-avg-rating=""{avgRating}""
                        data-review-count=""{reviewCount}""
                        data-stock=""{stock}"" ";

                    // สร้าง HTML Card
                    return $@"
                        <div class=""book-card js-book-card"" {dataAttributes}>
                            <img src='{coverUrl}' alt='{Server.HtmlEncode(title)}' />
                            <div class=""book-card-content"">
                                <div>
                                    <h3 class=""book-title"">{Server.HtmlEncode(title)}</h3>
                                    <p class=""book-author"">{Server.HtmlEncode(authors)}</p>
                                    <p class=""book-edition"">{Server.HtmlEncode(edition)} Edition</p>
                                    <p class=""book-category"">{Server.HtmlEncode(category)}</p>
                                </div>
                                <p class=""book-price"">฿{price}</p>
                            </div>
                        </div>";
                }
            </script>


            <section class="book-grid">
                <asp:Repeater ID="rptCategoryBooks" runat="server">
                    <ItemTemplate>
                        <%-- [แก้ไข] เรียกใช้ Helper Function --%>
                        <%# GetBookCardTemplate(Container.DataItem) %>
                    </ItemTemplate>
                </asp:Repeater>
            </section>
            
            <!-- Pagination Controls -->
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

            <asp:Panel runat="server" ID="pnlNoBooks" Visible="false" CssClass="no-items-panel" Style="margin-top: 20px;">
                ไม่พบหนังสือในหมวดหมู่นี้
            </asp:Panel>

        </main>

        <!-- [เพิ่ม] Add to Cart Modal HTML (คัดลอกจาก topSalePage) -->
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

                        <div id="modalQuantitySection" class="modal-quantity-section">
                            <label for="modalQuantity" style="font-weight: bold;">จำนวน:</label>
                            <input id="modalQuantity" type="number" value="1" min="1" class="modal-quantity" />
                            <span id="modalStockWarning"></span> 
                        </div>
                        <div id="modalOutOfStock"> 
                            สินค้าหมด
                        </div>
                    </div>
                </div>

                <div class="modal-footer">
                    <button type="button" class="modal-btn-cancel" onclick="closeAddToCartModal()">ยกเลิก</button>
                    <button type="button" id="btnModalAddToCart" class="modal-btn-add">เพิ่มลงตะกร้า</button>
                </div>
            </div>
        </div>
        <!-- [จบ] Modal -->


    </form>

     <!-- [เพิ่ม] JavaScript สำหรับ Modal (คัดลอกจาก topSalePage) -->
    <script type="text/javascript">
        // Get modal elements
        const modal = document.getElementById('addToCartModal');
        const modalBookCover = document.getElementById('modalBookCover');
        const modalBookTitle = document.getElementById('modalBookTitle');
        const modalBookPrice = document.getElementById('modalBookPrice');
        let modalQuantity = document.getElementById('modalQuantity');
        const btnModalAddToCart = document.getElementById('btnModalAddToCart');

        // Get details elements
        const modalBookAuthors = document.getElementById('modalBookAuthors');
        const modalBookEdition = document.getElementById('modalBookEdition');
        const modalBookCategory = document.getElementById('modalBookCategory');
        const modalBookReviews = document.getElementById('modalBookReviews');

        // Get stock-related elements
        const modalQuantitySection = document.getElementById('modalQuantitySection');
        const modalOutOfStock = document.getElementById('modalOutOfStock');
        const modalStockWarning = document.getElementById('modalStockWarning');

        // Store current book ID and max stock
        let currentBookId = null;
        let currentMaxStock = 0;

        // Function to generate star rating
        function generateStarRating(rating) {
            rating = Math.round(rating * 2) / 2; // Round to nearest 0.5
            let stars = '';
            for (let i = 1; i <= 5; i++) {
                if (rating >= i) {
                    stars += '★'; // Full star
                } else {
                    stars += '☆'; // Empty star (ง่ายกว่า)
                }
            }
            return stars;
        }


        // Function to open the modal
        function openAddToCartModal(cardElement) {
            // Get data from data-* attributes
            currentBookId = cardElement.getAttribute('data-bookid');
            const title = cardElement.getAttribute('data-title');
            const price = cardElement.getAttribute('data-price');
            const cover = cardElement.getAttribute('data-cover');
            
            // Get details
            const authors = cardElement.getAttribute('data-authors');
            const edition = cardElement.getAttribute('data-edition');
            const category = cardElement.getAttribute('data-category');
            const avgRating = parseFloat(cardElement.getAttribute('data-avg-rating'));
            const reviewCount = parseInt(cardElement.getAttribute('data-review-count'), 10);

            // Get stock
            const stock = parseInt(cardElement.getAttribute('data-stock'), 10) || 0;
            currentMaxStock = stock; 

            // Populate modal (Basic info)
            modalBookCover.src = cover;
            modalBookCover.alt = title;
            modalBookTitle.textContent = title;
            modalBookPrice.textContent = '฿' + price;

            // Populate details
            modalBookAuthors.textContent = 'โดย: ' + (authors && authors !== 'N/A' ? authors : 'ไม่ระบุผู้แต่ง');
            modalBookEdition.textContent = 'Edition: ' + (edition ? edition : 'N/A');
            modalBookCategory.textContent = 'หมวดหมู่: ' + (category ? category : 'N/A');

            // Populate reviews
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


            // Stock Logic
            if (stock <= 0) {
                modalQuantitySection.style.display = 'none'; 
                modalOutOfStock.style.display = 'block'; 
                btnModalAddToCart.disabled = true; 
            } else {
                modalQuantitySection.style.display = 'block'; 
                modalOutOfStock.style.display = 'none'; 
                
                modalQuantity.value = 1; 
                modalQuantity.max = stock; 
                
                modalStockWarning.style.display = 'none'; 
                btnModalAddToCart.disabled = false; 
            }

            // Show modal
            modal.classList.add('show');
        }

        // Function to close the modal
        function closeAddToCartModal() {
            modal.classList.remove('show');
        }

        // Function ตรวจสอบจำนวนขณะพิมพ์
        function checkQuantity() {
            modalQuantity = document.getElementById('modalQuantity');
            const quantity = parseInt(modalQuantity.value, 10);

            if (quantity > currentMaxStock) {
                modalQuantity.value = currentMaxStock; // บังคับค่าสูงสุด
                modalStockWarning.textContent = `ไม่สามารถสั่งเกิน ${currentMaxStock} ชิ้น`;
                modalStockWarning.style.display = 'inline';
            } else if (quantity < 1) {
                modalQuantity.value = 1; // บังคับค่าต่ำสุด
                modalStockWarning.style.display = 'none';
            } else {
                modalStockWarning.style.display = 'none';
            }
        }


        // Add click event listeners to all book cards
        document.addEventListener('DOMContentLoaded', function () {
            document.querySelectorAll('.js-book-card').forEach(card => {
                card.addEventListener('click', function() {
                    openAddToCartModal(this);
                });
            });

            // ผูก event listener กับ modalQuantity
            const qtyInput = document.getElementById('modalQuantity');
            if(qtyInput) {
                qtyInput.addEventListener('input', checkQuantity);
            }
        });

        // Handle "Add to Cart" button click inside the modal
        btnModalAddToCart.addEventListener('click', function() {
            const quantity = parseInt(modalQuantity.value, 10);

            // ตรวจสอบกับ currentMaxStock ด้วย
            if (quantity > 0 && currentBookId && quantity <= currentMaxStock) {
                console.log(`Adding to cart: BookID ${currentBookId}, Quantity: ${quantity}`);

                // --- นี่คือการจำลองการเพิ่มของลงตะกร้า ---
                const cartCountElement = document.getElementById('<%= cartCount.ClientID %>');
                let currentCount = parseInt(cartCountElement.textContent, 10) || 0;
                currentCount += quantity;
                cartCountElement.textContent = currentCount;

                if (currentCount > 0) {
                    cartCountElement.style.display = 'inline';
                    cartCountElement.style.color = 'white';
                    cartCountElement.style.backgroundColor = '#d90000';
                    cartCountElement.style.borderRadius = '50%';
                    cartCountElement.style.padding = '2px 6px';
                    cartCountElement.style.fontSize = '0.8rem';
                }
                
                closeAddToCartModal();
            } else if (quantity > currentMaxStock) {
                 modalStockWarning.textContent = `มีสินค้าไม่พอ (สูงสุด ${currentMaxStock} ชิ้น)`;
                 modalStockWarning.style.display = 'inline';
            }
        });

        // Close modal if overlay (backdrop) is clicked
        modal.addEventListener('click', function(e) {
            if (e.target === modal) {
                closeAddToCartModal();
            }
        });

    </script>

</body>
</html>
