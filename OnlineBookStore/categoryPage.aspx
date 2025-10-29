<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="categoryPage.aspx.cs" Inherits="OnlineBookStore.categoryPage" %>

<!DOCTYPE html>
<html lang="th">
<head runat="server">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Category | The Red Bookmark</title>
    <!-- Minimalist Font -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    
    <!-- Feather Icons for UI -->
    <script src="https://unpkg.com/feather-icons"></script>
    <style>
        /* --- [NEW] Modern Red/Black Theme --- */
        
        :root {
            --color-red-deep: #b30000;
            --color-red-vibrant: #e60000;
            --color-black: #1a1a1a;
            --color-white: #ffffff;
            --color-gray-light: #f7f7f7;
            --color-gray-medium: #e0e0e0;
            --color-gray-dark: #555;
            --font-primary: 'Inter', sans-serif;
            --shadow-soft: 0 4px 12px rgba(0,0,0,0.05);
            --shadow-medium: 0 8px 20px rgba(0,0,0,0.1);
            --border-radius-main: 8px;
            --border-radius-large: 12px;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body { 
            font-family: var(--font-primary); 
            margin: 0; 
            background-color: var(--color-white); 
            color: var(--color-black);
            line-height: 1.6;
        }

        a { 
            text-decoration: none; 
            color: var(--color-red-vibrant);
            transition: color 0.3s;
        }
        a:hover {
            color: var(--color-red-deep);
        }

        .container { 
            width: 90%; 
            max-width: 1200px; 
            margin: 0 auto; 
        }

        /* --- Header --- */
        .top-header { 
            background-color: var(--color-white); 
            padding: 1.5rem 0; 
            border-bottom: 1px solid var(--color-gray-medium); 
            position: sticky;
            top: 0;
            background: var(--color-white);
            z-index: 900;
        }
        .top-header .container { 
            display: flex; 
            justify-content: space-between; 
            align-items: center; 
            gap: 1.5rem;
        }
        .logo { 
            font-size: 2rem; 
            font-weight: 700; 
            color: var(--color-red-vibrant); 
            flex-shrink: 0;
        }
        
        .search-bar { 
            flex-grow: 1; 
            display: flex; 
            max-width: 500px;
            position: relative;
        }
        .search-input { 
            width: 100%; 
            padding: 12px 20px; 
            padding-right: 50px; /* Space for button */
            border: 1px solid var(--color-gray-medium); 
            border-radius: 25px;
            font-size: 1rem; 
            font-family: var(--font-primary);
            transition: border-color 0.3s, box-shadow 0.3s;
        }
        .search-input:focus {
            outline: none;
            border-color: var(--color-red-vibrant);
            box-shadow: 0 0 0 3px rgba(230, 0, 0, 0.1);
        }
        
        /* Updated Button Style */
        .search-button {
            position: absolute;
            right: 6px;
            top: 6px;
            height: 38px;
            width: 38px;
            border: none;
            border-radius: 50%;
            background-color: var(--color-red-vibrant);
            color: var(--color-white);
            cursor: pointer;
            font-size: 1rem;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: background-color 0.3s;
        }
        .search-button:hover { 
            background-color: var(--color-red-deep); 
        }
        .search-button i {
            width: 18px;
            height: 18px;
        }

        .header-icons { 
            display: flex; 
            gap: 1.5rem; 
            font-size: 0.95rem; 
            align-items: center;
            flex-shrink: 0;
        }
        .header-icons .asp-link {
            font-weight: 500;
            color: var(--color-black);
            padding: 8px 16px;
            border-radius: 20px;
            border: 1px solid var(--color-gray-medium);
            transition: all 0.3s;
        }
        .header-icons .asp-link:hover {
            background: var(--color-gray-light);
            border-color: var(--color-gray-dark);
        }
        .header-icons .asp-link-logout {
            border-color: var(--color-red-vibrant);
            color: var(--color-red-vibrant);
        }
        .header-icons .asp-link-logout:hover {
            background: var(--color-red-vibrant);
            color: var(--color-white);
        }

        .cart-link {
            position: relative;
            color: var(--color-black);
        }
        .cart-link i {
            width: 28px;
            height: 28px;
        }
        
        .cart-count {
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            background-color: var(--color-red-vibrant);
            border-radius: 50%;
            padding: 2px;
            font-size: 0.75rem;
            font-weight: 600;
            position: absolute;
            top: -8px;
            right: -10px;
            min-width: 20px;
            height: 20px;
            line-height: 1;
            border: 2px solid var(--color-white);
        }
        .cart-count.empty {
            display: none;
        }

        /* --- Main Nav --- */
        .main-nav {
            background-color: var(--color-black);
            color: var(--color-white);
            padding: 0;
            position: relative;
            z-index: 10;
        }
        .main-nav .container { 
            display: flex; 
            justify-content: center; 
            align-items: center; 
        }
        .main-nav ul { 
            list-style: none; 
            margin: 0; 
            padding: 0; 
            display: flex; 
            gap: 0; 
            flex-wrap: wrap; 
            justify-content: center; 
        }
        .main-nav li { 
            position: relative; 
        }
        .main-nav li a { 
            padding: 1rem 1.5rem; 
            font-size: 0.9rem; 
            display: block; 
            transition: background-color 0.3s, color 0.3s; 
            color: var(--color-white);
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        .main-nav li a:hover,
        .main-nav li.dropdown:hover > a { 
            background-color: var(--color-red-vibrant); 
            color: var(--color-white);
        }

        /* Dropdown */
        .main-nav li.dropdown { position: relative; }
        .main-nav .dropdown-content {
            display: none;
            position: absolute;
            top: 100%;               
            left: 0;
            background-color: var(--color-black);
            min-width: 250px;
            border-radius: 0 0 var(--border-radius-main) var(--border-radius-main);
            padding: 0.5rem 0;
            box-shadow: 0 8px 16px rgba(0,0,0,0.3);
            z-index: 999;
            border-top: 2px solid var(--color-red-vibrant);
        }
        .main-nav .dropdown-content li a {
            padding: 0.75rem 1.5rem;
            font-size: 0.9rem;
            font-weight: 500;
            text-transform: none;
            letter-spacing: normal;
            display: block;
            color: var(--color-white);
        }
        .main-nav .dropdown-content li a:hover { 
            background-color: var(--color-red-vibrant); 
        }
        .main-nav li.dropdown:hover .dropdown-content { 
            display: block; 
        }

        /* --- Content --- */
        main { 
            padding: 3rem 0; 
            background-color: var(--color-white);
        }
        /* Style for main page title */
        .page-title { 
            font-size: 2rem; 
            font-weight: 700; 
            margin-bottom: 2.5rem; 
            color: var(--color-black); 
            text-align: center;
            position: relative;
        }
        .page-title::after {
            content: '';
            display: block;
            width: 60px;
            height: 3px;
            background-color: var(--color-red-vibrant);
            margin: 0.5rem auto 0;
        }
        
        /* [NEW] 5-column grid */
        .book-grid { 
            display: grid; 
            grid-template-columns: repeat(auto-fill, minmax(200px, 1fr)); 
            gap: 1.5rem; 
        }
        .book-card { 
            background-color: var(--color-white); 
            border: 1px solid var(--color-gray-medium);
            border-radius: var(--border-radius-main); 
            overflow: hidden; 
            box-shadow: var(--shadow-soft); 
            transition: transform 0.3s, box-shadow 0.3s; 
            display: flex; 
            flex-direction: column;
        }
        .book-card:hover { 
            transform: translateY(-5px);             
            box-shadow: var(--shadow-medium); 
        }
        .book-cover-link {
            display: block;
            position: relative;
            background: var(--color-gray-light);
        }
        .book-card img {
            width: 100%;
            aspect-ratio: 2 / 3;
            height: auto;
            object-fit: cover;
            border-bottom: 1px solid var(--color-gray-medium);
        }
        .book-card-content { 
            padding: 1rem; 
            flex-grow: 1; 
            display: flex; 
            flex-direction: column; 
            justify-content: space-between;
        }
        .book-card-content div:first-child {
             margin-bottom: 1rem;
        }
        .book-title {
            font-size: 1.05rem;
            font-weight: 600;
            margin: 0 0 6px 0;
            color: var(--color-black);
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
            text-overflow: ellipsis;
            min-height: 2.2em; 
        }
        .book-title.js-open-modal:hover {
            color: var(--color-red-vibrant);
            text-decoration: none;
        }
        .book-author {
            font-size: 0.9rem;
            color: var(--color-gray-dark);
            margin: 4px 0;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }
        .book-edition,
        .book-category {
            font-size: 0.85rem;
            color: #777;
            margin: 4px 0;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }
        .book-category {
            color: var(--color-red-vibrant);
            font-weight: 500;
        }
        .book-price {
            font-size: 1.25rem;
            font-weight: 700;
            color: var(--color-red-vibrant);
            margin-top: 0.5rem;
        }

        /* [NEW] Add to Cart Button */
        .btn-add-cart {
            background-color: var(--color-red-vibrant);
            color: var(--color-white);
            border: none;
            padding: 12px 20px;
            font-size: 0.95rem;
            font-weight: 600;
            border-radius: var(--border-radius-main);
            cursor: pointer;
            transition: background-color 0.3s, transform 0.2s;
            width: 100%;
            margin-top: 10px;
        }
        .btn-add-cart:hover { 
            background-color: var(--color-red-deep); 
            transform: translateY(-2px);
        }
        .btn-add-cart:disabled {
            background-color: #ccc;
            cursor: not-allowed;
        }
        
        /* [NEW] No Items Panel */
        .no-items-panel { 
            border: 2px dashed var(--color-gray-medium); 
            border-radius: var(--border-radius-main); 
            padding: 2rem; 
            text-align: center; 
            color: var(--color-gray-dark); 
            background-color: var(--color-gray-light);
            margin-top: 2rem;
        }

        /* [NEW] Pagination */
        .pagination-container { 
            display: flex; 
            justify-content: center; 
            margin-top: 3rem; 
        }
        .pagination { 
            list-style: none; 
            display: flex; 
            padding: 0; 
            margin: 0; 
            border-radius: var(--border-radius-main); 
            box-shadow: var(--shadow-soft); 
            overflow: hidden; 
            border: 1px solid var(--color-gray-medium);
        }
        .page-item { } 
        .page-link { 
            display: block; 
            padding: 0.75rem 1rem; 
            color: var(--color-red-vibrant); 
            text-decoration: none; 
            background-color: var(--color-white); 
            border-left: 1px solid var(--color-gray-medium); 
            transition: background-color 0.3s, color 0.3s; 
            font-weight: 600; 
        }
        .page-item:first-child .page-link {
            border-left: 0;
        }
        .page-item.active .page-link { 
            z-index: 2; 
            color: var(--color-white); 
            background-color: var(--color-red-vibrant); 
            border-color: var(--color-red-vibrant); 
        }
        .page-link:hover { 
            background-color: var(--color-gray-light); 
        }
        .page-item.active .page-link:hover { 
            background-color: var(--color-red-deep); 
        }
        .page-link:disabled, .page-item.active .page-link { 
            pointer-events: none; 
        }

        
        /* --- [NEW] Modal Styles --- */
        .modal-overlay { position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0, 0, 0, 0.7); display: flex; align-items: center; justify-content: center; z-index: 1000; opacity: 0; visibility: hidden; transition: opacity 0.3s, visibility 0s 0.3s; }
        .modal-overlay.show { opacity: 1; visibility: visible; transition: opacity 0.3s; }
        .modal-content { background: var(--color-white); padding: 2rem; border-radius: var(--border-radius-large); box-shadow: 0 10px 30px rgba(0,0,0,0.2); z-index: 1001; width: 90%; max-width: 800px; transform: scale(0.95); transition: transform 0.3s ease-out; position: relative; }
        .modal-overlay.show .modal-content { transform: scale(1); }
        .modal-close { position: absolute; top: 15px; right: 20px; font-size: 32px; font-weight: 300; color: var(--color-gray-dark); cursor: pointer; line-height: 1; }
        .modal-close:hover { color: var(--color-black); }
        .modal-body { display: flex; flex-direction: column; gap: 2rem; margin-top: 1.5rem; }
        @media (min-width: 600px) { .modal-body { flex-direction: row; } }
        .modal-book-cover { width: 100%; max-width: 250px; height: auto; aspect-ratio: 2 / 3; object-fit: cover; border-radius: var(--border-radius-main); border: 1px solid var(--color-gray-medium); flex-shrink: 0; margin: 0 auto; box-shadow: var(--shadow-medium); }
        @media (min-width: 600px) { .modal-book-cover { width: 250px; margin: 0; } }
        .modal-details { flex-grow: 1; }
        .modal-details h3 { margin-top: 0; font-size: 1.8rem; font-weight: 700; color: var(--color-black); line-height: 1.3; }
        .modal-details p { margin: 6px 0; }
        .modal-book-price { font-size: 1.8rem; font-weight: 700; color: var(--color-red-vibrant); margin-top: 1.5rem; margin-bottom: 1.5rem; }
        .modal-book-meta { font-size: 1rem; color: var(--color-gray-dark); margin: 1rem 0; border-top: 1px solid var(--color-gray-light); padding-top: 1rem; }
        .modal-book-meta span { display: block; margin-bottom: 6px; }
        .modal-book-meta span strong { color: var(--color-black); font-weight: 600; }
        .modal-review-summary { margin-top: 1rem; padding-top: 1rem; border-top: 1px solid var(--color-gray-light); display: flex; align-items: center; }
        .modal-review-summary .stars { font-size: 1.2rem; color: #f59e0b; letter-spacing: 1px; }
        .modal-review-summary .stars .no-rating { color: var(--color-gray-medium); }
        .modal-review-summary .review-count { font-size: 0.9rem; color: var(--color-gray-dark); margin-left: 0.75rem; }
        .modal-footer { text-align: right; padding-top: 1.5rem; margin-top: 1.5rem; border-top: 1px solid var(--color-gray-medium); }
        .modal-btn-cancel { background-color: var(--color-gray-light); color: var(--color-black); border: 1px solid var(--color-gray-medium); padding: 10px 20px; font-size: 1rem; font-weight: 600; border-radius: var(--border-radius-main); cursor: pointer; margin-right: 10px; transition: all 0.3s; }
        .modal-btn-cancel:hover { background-color: var(--color-gray-medium); border-color: var(--color-gray-dark); }
        .js-open-modal { cursor: pointer; }
        .book-title.js-open-modal:hover { text-decoration: none; }
        
        /* --- Responsive --- */
        @media (max-width: 900px) {
            .top-header .container { flex-wrap: wrap; justify-content: center; }
            .logo { width: 100%; text-align: center; margin-bottom: 1rem; }
            .search-bar { order: 3; width: 100%; max-width: 100%; margin-top: 1rem; }
            .header-icons { order: 2; }
        }
        @media (max-width: 768px) {
            .main-nav ul { gap: 0; flex-direction: column; width: 100%; text-align: center; }
            .main-nav li a { padding: 0.75rem 1rem; }
            .main-nav .dropdown-content { position: static; display: none; background-color: #333; box-shadow: none; border-radius: 0; border-top: none; }
            .main-nav li.dropdown:hover .dropdown-content { display: none; }
            .main-nav li.dropdown:hover > a { background-color: var(--color-black); }
            .main-nav li.dropdown a:hover { background-color: var(--color-red-vibrant); }
            .book-grid { grid-template-columns: repeat(auto-fill, minmax(180px, 1fr)); gap: 1rem; }
        }
        @media (max-width: 480px) {
            .container { width: 95%; }
            .header-icons { gap: 1rem; }
            .book-grid { grid-template-columns: repeat(auto-fit, minmax(140px, 1fr)); }
            .book-title { font-size: 0.95rem; }
            .book-price { font-size: 1.1rem; }
            .btn-add-cart { padding: 10px; font-size: 0.85rem; }
            .modal-content { padding: 1rem; }
            .modal-body { gap: 1.5rem; }
            .modal-details h3 { font-size: 1.5rem; }
            .modal-book-price { font-size: 1.5rem; }
        }

    </style>
</head>
<body>
    <form id="form1" runat="server">

        <!-- [NEW] Header -->
        <header class="top-header">
            <div class="container">
                <div class="logo">The Red Bookmark</div>
                <div class="search-bar">
                    <asp:TextBox ID="txtSearch" runat="server" placeholder="Search for books, authors, or ISBN..." CssClass="search-input"></asp:TextBox>
                    <asp:LinkButton ID="btnSearch" runat="server" OnClick="btnSearch_Click" CssClass="search-button">
                         <i data-feather="search"></i>
                    </asp:LinkButton>
                </div>
                <div class="header-icons">
                    <asp:LinkButton ID="btnLogin" runat="server" PostBackUrl="~/loginPage.aspx" CssClass="asp-link">
                        Login  
                    </asp:LinkButton>
                    <asp:LinkButton ID="btnLogout" runat="server" OnClick="btnLogout_Click" Visible="false" CssClass="asp-link asp-link-logout">
                        Logout  
                    </asp:LinkButton>
                    <a href="cartPage.aspx" class="cart-link" title="ตะกร้าสินค้า" runat="server" id="cartLink">
                        <i data-feather="shopping-cart"></i>
                        <span runat="server" id="cartCount" class="cart-count empty">0</span>
                    </a>
                </div>
            </div>
        </header>

        <!-- [NEW] Navigation bar -->
        <nav class="main-nav">
             <div class="container">
                 <ul>
                    <li><a href="mainpage.aspx">Home</a></li>
                    <li><a href="topSalePage.aspx">Bestsellers</a></li>
                    <li class="dropdown">
                        <a href="#">Genres ▼</a>
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
                    <li><a href="myAccountPage.aspx">My Account</a></li>
                    <li><a href="myCollectionPage.aspx">My Collection</a></li>
                    <li><a href="reviewHistoryPage.aspx">Review History</a></li>
                </ul>
            </div>
        </nav>

        <!-- Main Content -->
        <main class="container">
            <h1 class="page-title">
                Category: <asp:Literal ID="litCategoryName" runat="server" Text="Loading..." />
            </h1>
            
            <section class="book-grid">
                <asp:Repeater ID="rptCategoryBooks" runat="server" OnItemCommand="Repeater_ItemCommand">
                    <ItemTemplate>
                        <div class="book-card"
                            data-bookid="<%# Eval("BookID") %>"
                            data-title="<%# Eval("Title") %>"
                            data-price="<%# Eval("Price", "{0:F2}") %>"
                            data-cover="<%# Eval("CoverUrl") %>"
                            data-authors="<%# Eval("Authors") %>"
                            data-edition="<%# Eval("Edition") %>"
                            data-category="<%# Eval("CategoryName") %>"
                            data-avg-rating="<%# Eval("AvgRating", "{0:F1}") %>"
                            data-review-count="<%# Eval("ReviewCount") %>">
                            
                            <!-- [NEW] Book card template -->
                            <a href="javascript:void(0);" class="book-cover-link js-open-modal">
                                <img src='<%# Eval("CoverUrl") %>' alt='<%# Eval("Title") %>' 
                                     onerror="this.onerror=null; this.src='https://placehold.co/400x600/eeeeee/cccccc?text=No+Cover';" />
                            </a>
                            
                            <div class="book-card-content">
                                <div>
                                    <h3 class="book-title js-open-modal">
                                        <%# Eval("Title") %>
                                    </h3>
                                    <p class="book-author"><%# Eval("Authors") %></p>
                                    <p class="book-category"><%# Eval("CategoryName") %></p>
                                </div>
                                <div>
                                    <p class="book-price">฿<%# Eval("Price", "{0:F2}") %></p>
                                    <asp:Button ID="btnAddToCart" runat="server" 
                                        Text="Add to Cart" 
                                        CommandName="AddToCart" 
                                        CommandArgument='<%# Eval("BookID") %>' 
                                        CssClass="btn-add-cart" />
                                </div>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </section>
            
            <!-- [NEW] Pagination Controls -->
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
                No books were found in this category.
            </asp:Panel>

        </main>
        
        <!-- [NEW] Book Detail Modal -->
        <div id="bookDetailModal" class="modal-overlay"> 
            <div class="modal-content">
                <span class="modal-close" onclick="closeBookDetailModal()">&times;</span> 
                <h2 style="margin-top:0;">Book Details</h2> 
                <div class="modal-body">
                    <img id="modalBookCover" src="" alt="Book Cover" class="modal-book-cover" />
                    <div class="modal-details">
                        <h3 id="modalBookTitle">Book Title</h3>
                        <div class="modal-book-meta">
                            <span id="modalBookAuthors"></span>
                            <span id="modalBookEdition"></span>
                            <span id="modalBookCategory"></span>
                        </div>
                        <div id="modalBookReviews" class="modal-review-summary"></div>
                        <p id="modalBookPrice" class="modal-book-price">฿0.00</p>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="modal-btn-cancel" onclick="closeBookDetailModal()">Close</button>
                </div>
            </div>
        </div>
        <!-- [End] Modal -->

    </form>

     <!-- [NEW] JavaScript for Modal & Icons -->
    <script type="text/javascript">
        // --- Feather Icons ---
        feather.replace();

        // --- Modal JavaScript ---
        const modal = document.getElementById('bookDetailModal');
        const modalBookCover = document.getElementById('modalBookCover');
        const modalBookTitle = document.getElementById('modalBookTitle');
        const modalBookPrice = document.getElementById('modalBookPrice');
        const modalBookAuthors = document.getElementById('modalBookAuthors');
        const modalBookEdition = document.getElementById('modalBookEdition');
        const modalBookCategory = document.getElementById('modalBookCategory');
        const modalBookReviews = document.getElementById('modalBookReviews');

        function generateStarRating(rating) {
            rating = Math.round(rating * 2) / 2; let stars = '';
            for (let i = 1; i <= 5; i++) { stars += (rating >= i ? '★' : (rating >= (i - 0.5) ? '★' : '☆')); }
            return stars;
        }

        function openBookDetailModal(clickedElement) {
            const cardElement = clickedElement.closest('.book-card'); if (!cardElement) return;
            const title = cardElement.getAttribute('data-title');
            const price = cardElement.getAttribute('data-price');
            const cover = cardElement.getAttribute('data-cover');
            const authors = cardElement.getAttribute('data-authors');
            const edition = cardElement.getAttribute('data-edition');
            const category = cardElement.getAttribute('data-category');
            let avgRating = parseFloat(cardElement.getAttribute('data-avg-rating')); if (isNaN(avgRating)) avgRating = 0;
            let reviewCount = parseInt(cardElement.getAttribute('data-review-count'), 10); if (isNaN(reviewCount)) reviewCount = 0;

            modalBookCover.src = cover;
            modalBookCover.alt = title;
            modalBookCover.onerror = function () {
                this.onerror = null;
                this.src = 'https://placehold.co/400x600/eeeeee/cccccc?text=No+Cover';
            };
            modalBookTitle.textContent = title;
            modalBookPrice.textContent = '฿' + price;
            modalBookAuthors.innerHTML = '<strong>Author:</strong> ' + (authors && authors !== 'N/A' ? authors : 'Unknown');
            modalBookEdition.innerHTML = '<strong>Edition:</strong> ' + (edition ? edition : 'N/A');
            modalBookCategory.innerHTML = '<strong>Genre:</strong> ' + (category ? category : 'N/A');

            if (reviewCount > 0 && avgRating > 0) {
                const stars = generateStarRating(avgRating);
                modalBookReviews.innerHTML = `<span class="stars">${stars}</span><span class="review-count">(${avgRating.toFixed(1)} based on ${reviewCount} reviews)</span>`;
            } else {
                modalBookReviews.innerHTML = `<span class="stars no-rating">☆☆☆☆☆</span><span class="review-count">(No reviews yet)</span>`;
            }
            modal.classList.add('show');
        }

        function closeBookDetailModal() { modal.classList.remove('show'); }

        document.addEventListener('DOMContentLoaded', function () {
            document.querySelectorAll('.js-open-modal').forEach(element => {
                element.addEventListener('click', function (e) {
                    e.preventDefault();
                    openBookDetailModal(this);
                });
            });
        });

        modal.addEventListener('click', function (e) { if (e.target === modal) closeBookDetailModal(); });

    </script>

</body>
</html>
