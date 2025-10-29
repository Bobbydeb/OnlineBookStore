<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="myCollectionPage.aspx.cs" Inherits="OnlineBookStore.myCollectionPage" %>

<!DOCTYPE html>
<html lang="th">
<head runat="server">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Collection | The Red Bookmark</title>
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
            background-color: var(--color-gray-light); /* Light gray bg for account page */
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
        
        /* [NEW] Header Icons (No Search Bar) */
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
        
        .content-layout { 
            display: grid; 
            grid-template-columns: 1fr; 
            gap: 2.5rem; 
        }
        @media (min-width: 1024px) { 
            .content-layout { 
                grid-template-columns: 2fr 1fr; /* 2 columns on large screens */
            } 
        }
        
        .section-title-2 { 
            font-size: 1.5rem; 
            font-weight: 600; 
            margin-bottom: 1.5rem;
            color: var(--color-black);
            padding-bottom: 0.75rem;
            border-bottom: 2px solid var(--color-gray-medium);
        }

        /* Order History */
        .order-item { 
            border: 1px solid var(--color-gray-medium); 
            border-radius: var(--border-radius-main); 
            padding: 1.5rem; 
            margin-bottom: 1rem; 
            background-color: var(--color-white); 
            box-shadow: var(--shadow-soft); 
        }
        .order-item-header { 
            display: flex; 
            justify-content: space-between; 
            align-items: center; 
            margin-bottom: 0.75rem; 
            flex-wrap: wrap; 
            gap: 0.5rem; 
        }
        .order-item-details { 
            display: flex; 
            justify-content: space-between; 
            align-items: center; 
           /* Removed margin-bottom to rely on gap */
            flex-wrap: wrap; 
            gap: 1rem; 
        }
        .order-item-header h3 { 
            font-size: 1.25rem; 
            font-weight: 600; 
            margin: 0;
            color: var(--color-red-vibrant);
        }
        .order-item-header span { 
            font-size: 0.9rem; 
            color: var(--color-gray-dark); 
        }
        .order-item-details .total { 
            font-weight: 600;
            font-size: 1.1rem;
            color: var(--color-black);
        }
        .order-item-details .status-container { 
            display: flex; 
            align-items: center; 
            gap: 0.75rem; 
            flex-wrap: wrap; 
        }
        .order-item-details .status { 
            font-weight: 600; 
            padding: 0.25rem 0.75rem; 
            border-radius: 9999px; 
            font-size: 0.875rem; 
        }
        .status-yellow { background-color: #fefcbf; color: #92400e; }
        .status-blue { background-color: #dbeafe; color: #1e40af; }
        .status-green { background-color: #d1fae5; color: #065f46; }
        .status-red { background-color: #fee2e2; color: #991b1b; } 
        .status-gray { background-color: #e5e7eb; color: #374151; }
        
        .order-book-list { 
            padding: 1rem; 
            color: var(--color-gray-dark); 
            margin-top: 1rem; /* Added margin-top to separate from details */
            border-top: 1px solid var(--color-gray-light);
            background: var(--color-gray-light);
            border-radius: var(--border-radius-main);
        }
        .order-book-list h4 { 
            font-size: 1rem; 
            font-weight: 600; 
            margin-bottom: 0.75rem; 
            margin-top: 0; 
            color: var(--color-black);
        }
        .order-book-list ul { 
            list-style-type: disc; 
            margin: 0; 
            padding-left: 1.25rem;
            font-size: 0.9rem;
        }

        /* Button Styles */
        .btn { 
            padding: 8px 16px; 
            border: none; 
            border-radius: var(--border-radius-main); 
            font-size: 0.9rem; 
            font-weight: 600; 
            cursor: pointer; 
            transition: all 0.3s;
            text-align: center;
        }
        .btn-green { 
            background-color: #10b981; 
            color: var(--color-white); 
        }
        .btn-green:hover { 
            background-color: #059669; 
            box-shadow: 0 4px 10px rgba(16, 185, 129, 0.2);
        }
        .btn-blue { 
            background-color: #2563eb; 
            color: var(--color-white); 
        }
        .btn-blue:hover { 
            background-color: #1d4ed8; 
            box-shadow: 0 4px 10px rgba(37, 99, 235, 0.2);
        }
        .btn-red { 
            background-color: var(--color-red-vibrant); 
            color: var(--color-white); 
        }
        .btn-red:hover { 
            background-color: var(--color-red-deep); 
            box-shadow: 0 4px 10px rgba(224, 0, 0, 0.2);
        }
        
        /* My Books Layout */
        .my-books-grid { 
            display: grid; 
            grid-template-columns: 1fr; /* Default to 1 column */
            gap: 1.5rem; 
        }
        /* 2 columns for medium screens */
        @media (min-width: 640px) { 
            .my-books-grid { grid-template-columns: repeat(2, 1fr); } 
        }
        /* If overall layout is 2 columns (desktop), keep My Books as 2 columns */
        @media (min-width: 1024px) {
            .my-books-grid { grid-template-columns: repeat(2, 1fr); }
        }
        /* If screen is very wide, maybe allow 3 columns? Adjust if needed */
        @media (min-width: 1400px) {
             .my-books-grid { grid-template-columns: repeat(2, 1fr); } /* Stays 2 for now */
        }


        .book-card-my-collection { 
            background-color: var(--color-white); 
            border: 1px solid var(--color-gray-medium); 
            border-radius: var(--border-radius-main); 
            overflow: hidden; 
            box-shadow: var(--shadow-soft); 
            display: flex; 
            flex-direction: column; /* Vertical card */
            height: 100%; /* Ensure cards align height in grid */
            transition: transform 0.3s, box-shadow 0.3s;
        }
        .book-card-my-collection:hover {
            transform: translateY(-5px);             
            box-shadow: var(--shadow-medium); 
        }

        .book-card-my-collection img { 
            width: 100%; /* Full width image */
            aspect-ratio: 2 / 3; 
            object-fit: cover; 
            background: var(--color-gray-light);
            flex-shrink: 0;
        }
        .book-card-content-my-collection { 
            padding: 1rem; 
            flex-grow: 1; 
            display: flex; 
            flex-direction: column; 
            justify-content: space-between; 
        }
        .book-card-content-my-collection h3 { 
            font-size: 1rem; 
            font-weight: 600; 
            margin-bottom: 0.5rem; 
            margin-top: 0; 
            line-height: 1.4; 
             /* Limit title to 2 lines */
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
            text-overflow: ellipsis;
            min-height: 2.8em; /* Ensure space for 2 lines */
        }
        .book-card-details-my-collection { 
            font-size: 0.8rem; 
            color: var(--color-gray-dark); 
            margin-bottom: 1rem; 
        }
        .book-card-details-my-collection p { 
            margin: 0.2rem 0; 
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }
        .book-card-details-my-collection strong { 
            color: var(--color-black); 
            font-weight: 600;
        }
        .review-button { 
            display: block; 
            width: 100%; 
            text-align: center; 
            background-color: var(--color-black); 
            color: white !important; 
            font-weight: 600; 
            padding: 0.6rem 1rem; 
            border-radius: var(--border-radius-main); 
            transition: background-color 0.3s; 
            box-sizing: border-box; 
            margin-top: auto; /* Push button to bottom */
        }
        .review-button:hover { 
            background-color: #333; 
        }
        .review-status { 
            display: block; 
            width: 100%; 
            text-align: center; 
            color: var(--color-gray-dark); 
            margin-top: 0.75rem;
            font-weight: 500;
            font-style: italic;
             font-size: 0.9rem;
        }
        .no-items-panel { 
            border: 2px dashed var(--color-gray-medium); 
            border-radius: var(--border-radius-main); 
            padding: 2rem; 
            text-align: center; 
            color: var(--color-gray-dark); 
            background-color: var(--color-white);
            grid-column: 1 / -1; 
        }

        /* --- Responsive --- */
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
             /* my-books-grid already set to 2 columns at 640px */
        }
        @media (max-width: 639px) { /* Adjust breakpoint if needed */
             .my-books-grid { grid-template-columns: 1fr; } /* Back to 1 column below 640px */
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
            <h1 class="page-title">My Collection</h1>

            <div class="content-layout">

                <!-- Order History -->
                <div>
                    <h2 class="section-title-2">Order History</h2>
                    <asp:Repeater ID="rptOrders" runat="server"
                        OnItemDataBound="rptOrders_ItemDataBound"
                        OnItemCommand="rptOrders_ItemCommand">
                        <ItemTemplate>
                            <div class="order-item">
                                <div class="order-item-header">
                                    <h3>Order #<%# Eval("OrderID") %></h3>
                                    <span>Date: <%# Eval("OrderDate", "{0:dd/MM/yyyy}") %></span>
                                </div>
                                <div class="order-item-details">
                                    <span class="total">Total: ฿<%# Eval("TotalAmount", "{0:N2}") %></span>
                                    <div class="status-container">
                                        <span class="status <%# GetStatusClass(Eval("Status").ToString()) %>">
                                            <%# Eval("Status") %>
                                        </span>
                                        <asp:Button ID="btnPay" runat="server"
                                            Text="Pay Now"
                                            CssClass="btn btn-blue"
                                            CommandName="Pay"
                                            CommandArgument='<%# Eval("OrderID") %>'
                                            Visible='<%# Eval("Status").ToString() == "รอการชำระเงิน" %>'
                                            OnClientClick="return confirm('Confirm payment for this order?');"
                                            />
                                        <asp:Panel runat="server" Visible='<%# Eval("Status").ToString() == "กำลังจัดส่ง" %>' style="display:inline-flex; gap: 0.5rem;">
                                            <asp:Button ID="btnReceived" runat="server"
                                                Text="Confirm Receipt"
                                                CssClass="btn btn-green"
                                                CommandName="Received"
                                                CommandArgument='<%# Eval("OrderID") %>'
                                                OnClientClick="return confirm('Confirm you have received this order?');"
                                                />
                                            <asp:Button ID="btnCancelOrder" runat="server"
                                                Text="Cancel Order"
                                                CssClass="btn btn-red"
                                                CommandName="CancelOrder"
                                                CommandArgument='<%# Eval("OrderID") %>'
                                                OnClientClick="return confirm('Are you sure you want to cancel this order?');"
                                                />
                                        </asp:Panel>
                                    </div>
                                </div>

                                <%-- [MODIFIED] Gave Panel an ID and removed inline Visible property --%>
                                <asp:Panel ID="pnlOrderBooksContainer" runat="server" Visible="false" CssClass="order-book-list-container">
                                    <div class="order-book-list">
                                        <h4>Books in this order:</h4>
                                        <ul>
                                            <asp:Repeater ID="rptOrderBooks" runat="server">
                                                <ItemTemplate>
                                                    <li><%# Eval("Title") %> (Qty: <%# Eval("Quantity") %>)</li>
                                                </ItemTemplate>
                                            </asp:Repeater>
                                        </ul>
                                    </div>
                                </asp:Panel>
                            </div>
                        </ItemTemplate>
                        <FooterTemplate>
                            <asp:Panel runat="server" ID="pnlNoOrders" Visible='<%# rptOrders.Items.Count == 0 %>'>
                                <div class="no-items-panel">
                                    You have no order history.
                                </div>
                            </asp:Panel>
                        </FooterTemplate>
                    </asp:Repeater>
                </div>

                <!-- My Books for Review -->
                <div>
                    <h2 class="section-title-2">My Books</h2>
                    <div class="my-books-grid">
                        <asp:Repeater ID="rptMyBooks" runat="server" OnItemDataBound="rptMyBooks_ItemDataBound">
                            <ItemTemplate>
                                <div class="book-card-my-collection">
                                    <asp:Image ID="imgBookCover" runat="server" 
                                        onerror="this.onerror=null; this.src='https://placehold.co/200x300/eeeeee/cccccc?text=No+Cover';" /> <%-- Adjusted placeholder size --%>
                                    <div class="book-card-content-my-collection">
                                        <div>
                                            <h3>
                                                <asp:Label ID="lblBookTitle" runat="server" Text='<%# Eval("Title") %>'></asp:Label>
                                            </h3>
                                            <div class="book-card-details-my-collection">
                                                <p><strong>Author:</strong> <asp:Label ID="lblAuthors" runat="server"></asp:Label></p>
                                                <p><strong>Genre:</strong> <asp:Label ID="lblCategory" runat="server"></asp:Label></p>
                                                <p><strong>Edition:</strong> <asp:Label ID="lblEdition" runat="server"></asp:Label></p>
                                            </div>
                                        </div>
                                        <div>
                                            <asp:HyperLink ID="hlReview" runat="server"
                                                CssClass="review-button">
                                                Write a Review
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
                             You do not have any delivered books yet.
                         </asp:Panel>
                    </div>
                </div>
            </div>
        </main>

    </form>
    
    <!-- [NEW] JavaScript for Icons -->
    <script type="text/javascript">
        feather.replace();
    </script>
</body>
</html>

