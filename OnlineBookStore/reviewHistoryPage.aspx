<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="reviewHistoryPage.aspx.cs" Inherits="OnlineBookStore.reviewHistoryPage" %>

<!DOCTYPE html>
<html lang="th">
<head runat="server">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Review History | The Red Bookmark</title> <!-- Changed title -->
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
            background-color: var(--color-gray-light); 
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
        
        /* Header Icons (No Search Bar) */
        .top-header .container .header-icons {
             margin-left: auto; /* Push to the right */
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

        /* --- Content Styles --- */
        main { 
            padding: 3rem 0; 
        }
        
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
        
        /* --- Styles for Review History --- */
        .review-history-list { 
            display: grid; 
            grid-template-columns: 1fr; 
            gap: 1.5rem; 
        }
        .review-card { 
            background-color: var(--color-white); 
            border: 1px solid var(--color-gray-medium); 
            border-radius: var(--border-radius-main); 
            box-shadow: var(--shadow-soft); 
            display: flex; 
            flex-direction: column; /* Start vertical for mobile */
            gap: 1rem; 
            padding: 1.5rem; 
            transition: box-shadow 0.3s;
        }
         .review-card:hover {
            box-shadow: var(--shadow-medium);
         }
        @media (min-width: 640px) { /* Horizontal layout on larger screens */
            .review-card { 
                flex-direction: row; 
                gap: 1.5rem; 
                align-items: flex-start; /* Align items to top */
            }
        }
        .review-card-cover { 
            text-align: center; 
            flex-shrink: 0; /* Prevent cover from shrinking */
        }
        .review-card-cover img { 
            width: 100px; 
            height: 150px; 
            object-fit: cover; 
            border-radius: 4px; 
            background-color: var(--color-gray-light); 
            display: inline-block; 
            border: 1px solid var(--color-gray-medium);
        }
        .review-card-content { 
            flex: 1; /* Allow content to grow */
        }
        .review-card-content h3 { 
            font-size: 1.25rem; 
            font-weight: 600; 
            margin-top: 0; 
            margin-bottom: 0.5rem; 
            color: var(--color-black);
        }
        .review-book-details { 
            font-size: 0.8rem; 
            color: var(--color-gray-dark); 
            margin-bottom: 0.75rem; 
            display: flex; 
            flex-wrap: wrap; 
            gap: 0.5rem 1rem; /* Space between items */
            border-bottom: 1px solid var(--color-gray-light);
            padding-bottom: 0.75rem;
        }
        .review-book-details strong { 
            color: var(--color-black); 
            font-weight: 600;
        }
        .review-card-meta { 
            font-size: 0.9rem; 
            color: var(--color-gray-dark); 
            margin-bottom: 0.75rem; 
            display: flex;
            align-items: center;
            gap: 1rem;
        }
        .review-card-meta .rating { 
            font-weight: 600; 
            color: #eab308; /* Gold color for rating */
            font-size: 1rem;
        }
        .review-card-meta .rating i { /* Style for potential star icon */
             width: 18px;
             height: 18px;
             vertical-align: middle;
             margin-right: 4px;
             stroke-width: 2.5px;
        }
        .review-card-meta .date {
            font-style: italic;
        }

        .review-card-comment { 
            font-size: 0.95rem; 
            color: var(--color-black); 
            line-height: 1.6; 
            white-space: pre-wrap; /* Preserve line breaks */
            margin-top: 0.5rem; 
            background: var(--color-gray-light);
            padding: 1rem;
            border-radius: var(--border-radius-main);
            border: 1px solid var(--color-gray-medium);
        }
        
        .no-items-panel { 
            border: 2px dashed var(--color-gray-medium); 
            border-radius: var(--border-radius-main); 
            padding: 2rem; 
            text-align: center; 
            color: var(--color-gray-dark); 
            background-color: var(--color-white);
        }

        /* --- Responsive Adjustments --- */
         @media (max-width: 900px) {
            .top-header .container { flex-wrap: wrap; justify-content: center; }
            .logo { width: 100%; text-align: center; margin-bottom: 1rem; }
            .header-icons { margin-left: 0; }
        }
        @media (max-width: 768px) {
            .main-nav ul { gap: 0; flex-direction: column; width: 100%; text-align: center; }
            .main-nav li a { padding: 0.75rem 1rem; }
            .main-nav .dropdown-content { position: static; display: none; background-color: #333; box-shadow: none; border-radius: 0; border-top: none; }
            .main-nav li.dropdown:hover .dropdown-content { display: none; }
            .main-nav li.dropdown:hover > a { background-color: var(--color-black); }
            .main-nav li.dropdown a:hover { background-color: var(--color-red-vibrant); }
        }
        @media (max-width: 639px) { 
             /* Styles for smaller screens if needed */
             .review-card { padding: 1rem; }
             .review-card-content h3 { font-size: 1.1rem; }
        }
        
    </style>
</head>
<body>
    <form id="form1" runat="server">

        <!-- [NEW] Header (No Search Bar) -->
        <header class="top-header">
            <div class="container">
                <div class="logo">The Red Bookmark</div>
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
            <h1 class="page-title">My Review History</h1> <!-- Changed text -->

            <div class="review-history-list">
                <asp:Repeater ID="rptMyReviews" runat="server" OnItemDataBound="rptMyReviews_ItemDataBound">
                    <ItemTemplate>
                        <div class="review-card">
                            <div class="review-card-cover">
                                <asp:Image ID="imgBookCover" runat="server" 
                                     onerror="this.onerror=null; this.src='https://placehold.co/100x150/eeeeee/cccccc?text=No+Cover';" />
                            </div>
                            <div class="review-card-content">
                                <h3><%# Eval("Title") %></h3>
                                <div class="review-book-details">
                                    <span><strong>Author:</strong> <%# (Eval("Authors") == DBNull.Value || string.IsNullOrEmpty(Eval("Authors").ToString())) ? "N/A" : Eval("Authors") %></span>
                                    <span><strong>Genre:</strong> <%# Eval("CategoryName") == DBNull.Value ? "N/A" : Eval("CategoryName") %></span>
                                    <span><strong>Edition:</strong> <%# Eval("Edition") == DBNull.Value ? "N/A" : Eval("Edition") %></span>
                                </div>
                                <div class="review-card-meta">
                                    <span class="rating">
                                        <i data-feather="star" fill="#eab308" stroke="none"></i> <!-- Added star icon -->
                                        <%# Eval("Rating") %> / 5
                                    </span>
                                    <span class="date">
                                        Reviewed on <%# Eval("ReviewDate", "{0:dd MMMM yyyy}") %>
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
                                You haven't reviewed any books yet. <!-- Changed text -->
                            </div>
                        </asp:Panel>
                    </FooterTemplate>
                </asp:Repeater>
            </div>
        </main>

    </form>
    
    <!-- JavaScript for Icons -->
    <script type="text/javascript">
        feather.replace();
    </script>
</body>
</html>
