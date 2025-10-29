<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="cartPage.aspx.cs" Inherits="OnlineBookStore.cartPage" %>

<!DOCTYPE html>
<html lang="th">
<head runat="server">
    <title>Shopping Cart | The Red Bookmark</title> <!-- Changed title -->
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
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

        /* Specific link style within cart item */
        .cart-item-details a {
             color: var(--color-black);
             font-weight: 600;
             font-size: 1rem;
        }
         .cart-item-details a:hover {
             color: var(--color-red-vibrant);
             text-decoration: underline;
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
            /* Removed flex-wrap: wrap; */
        }
        .logo {
            font-size: 2rem;
            font-weight: 700;
            color: var(--color-red-vibrant);
            flex-shrink: 0;
            /* Removed margin-right: auto; */
        }
        .logo a { /* Ensure logo link inherits color */
            color: inherit;
        }
        .logo a:hover {
            color: var(--color-red-deep);
        }
 

        /* Header Icons - Pushed to the right */
        .header-icons {
            display: flex;
            gap: 1.5rem;
            font-size: 0.95rem;
            align-items: center;
            flex-shrink: 0;
            margin-left: auto; /* Pushes icons to the far right */
        }

        .header-icons .asp-link { /* Used for Login/Logout LinkButtons */
            font-weight: 500;
            color: var(--color-black);
            padding: 8px 16px;
            border-radius: 20px;
            border: 1px solid var(--color-gray-medium);
            transition: all 0.3s;
            font-size: 0.95rem; /* Match other icons */
            text-decoration: none; /* Override default LinkButton underline */
        }
        .header-icons .asp-link:hover {
            background: var(--color-gray-light);
            border-color: var(--color-gray-dark);
            color: var(--color-black); /* Keep color on hover */
        }
        .header-icons .asp-link-logout {
            border-color: var(--color-red-vibrant);
            color: var(--color-red-vibrant) !important; /* Ensure override */
        }
        .header-icons .asp-link-logout:hover {
            background: var(--color-red-vibrant);
            color: var(--color-white) !important;
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

        /* --- Cart Page Specific Styles --- */
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

        .cart-container {
            background-color: var(--color-white);
            padding: 2.5rem; /* Increased padding */
            border-radius: var(--border-radius-large); /* Larger radius */
            box-shadow: var(--shadow-medium); /* Stronger shadow */
            max-width: 1000px; /* Adjusted max-width */
            margin: 0 auto; /* Center container */
        }

        /* Cart Table */
        .cart-grid {
            border-collapse: collapse;
            width: 100%;
            margin-top: 1.5rem; /* Added margin */
        }
        .cart-grid th, .cart-grid td {
            padding: 1rem 1.25rem; /* Adjusted padding */
            text-align: left;
            border-bottom: 1px solid var(--color-gray-medium);
        }
        .cart-grid th {
            background-color: var(--color-gray-light);
            font-size: 0.85rem;
            text-transform: uppercase;
            color: var(--color-gray-dark);
            font-weight: 600;
        }
        .cart-grid td {
            vertical-align: middle;
            font-size: 0.95rem;
        }
        /* Remove bottom border for last row */
        .cart-grid tr:last-child td {
            border-bottom: none;
        }


        .cart-item-image {
            width: 70px; /* Slightly smaller */
            height: 105px;
            object-fit: cover;
            border-radius: 4px;
            margin-right: 1.25rem;
            border: 1px solid var(--color-gray-medium);
        }
        .cart-item-info {
            display: flex;
            align-items: center;
        }
        .cart-item-details {
            flex-grow: 1;
        }
        .cart-item-details .title { /* Already styled above */
            display: block;
            margin-bottom: 0.25rem;
        }
        .cart-item-details .meta {
            font-size: 0.8rem;
            color: var(--color-gray-dark);
        }

        /* Quantity Input and Update Button */
        .cart-quantity {
             display: flex;
             align-items: center;
             gap: 0.5rem;
        }
        .asp-input-sm { /* Style for quantity textbox */
             width: 60px;
             padding: 8px;
             text-align: center;
             border: 1px solid var(--color-gray-medium);
             border-radius: var(--border-radius-main);
             font-family: var(--font-primary);
             font-size: 0.95rem;
        }
        .asp-input-sm:focus {
             outline: none;
             border-color: var(--color-red-vibrant);
             box-shadow: 0 0 0 3px rgba(224, 0, 0, 0.1);
        }

        /* General Button Styles (including Update, Remove) */
        .btn {
            padding: 8px 16px;
            border: none;
            border-radius: var(--border-radius-main);
            font-size: 0.9rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            text-align: center;
            line-height: 1.4; /* Ensure text aligns well */
        }
        .btn-primary {
             background-color: var(--color-red-vibrant);
             color: var(--color-white);
        }
        .btn-primary:hover {
             background-color: var(--color-red-deep);
             box-shadow: 0 4px 10px rgba(224, 0, 0, 0.2);
        }
        .btn-secondary {
             background-color: var(--color-gray-light);
             color: var(--color-black);
             border: 1px solid var(--color-gray-medium);
        }
        .btn-secondary:hover {
             background-color: var(--color-gray-medium);
        }
         .btn-link-danger { /* Style for Remove LinkButton */
            color: var(--color-red-vibrant);
            font-size: 0.9rem;
            font-weight: 600;
            background: none;
            border: none;
            padding: 0;
            text-decoration: none; /* Override default */
         }
         .btn-link-danger:hover {
            color: var(--color-red-deep);
            text-decoration: underline;
         }

        /* Specific placement for update button */
        .cart-quantity .btn-secondary {
            padding: 6px 10px; /* Smaller padding */
            font-size: 0.8rem;
            font-weight: 500;
        }

        .cart-price {
            font-size: 1rem;
            color: var(--color-black);
            font-weight: 500;
        }
        .cart-total-price strong {
            font-weight: 700;
            font-size: 1.05rem;
        }

        /* Cart Summary */
        .cart-summary {
            margin-top: 2rem;
            padding-top: 1.5rem;
            border-top: 2px solid var(--color-gray-medium);
            width: 100%;
            max-width: 400px;
            margin-left: auto; /* Align to the right */
        }
        .summary-row {
            display: flex;
            justify-content: space-between;
            padding: 0.75rem 0;
            font-size: 1rem;
        }
        .summary-row span:first-child {
             color: var(--color-gray-dark);
        }
         .summary-row span:last-child {
             font-weight: 600;
             color: var(--color-black);
         }
        .summary-row.total {
            font-size: 1.25rem; /* Larger total */
            font-weight: 700;
            border-top: 1px solid var(--color-gray-medium);
            padding-top: 1rem;
            margin-top: 0.75rem;
        }
         .summary-row.total span:last-child {
             color: var(--color-red-vibrant); /* Highlight total price */
         }

        /* Cart Actions (Checkout, Continue Shopping) */
        .cart-actions {
            margin-top: 2.5rem;
            display: flex;
            justify-content: flex-end; /* Align buttons right */
            gap: 1rem; /* Space between buttons */
            flex-wrap: wrap; /* Allow wrapping on small screens */
        }
        .cart-actions .btn { /* Adjust size for main action buttons */
             padding: 12px 25px;
             font-size: 1rem;
        }
        .cart-actions .btn-secondary {
            font-weight: 500; /* Normal weight for secondary action */
        }


        /* Empty Cart Message */
        .empty-cart-message {
            text-align: center;
            padding: 4rem 2rem; /* More padding */
            font-size: 1.1rem; /* Slightly larger text */
            color: var(--color-gray-dark);
            border: 2px dashed var(--color-gray-medium);
            border-radius: var(--border-radius-large);
            background-color: var(--color-white);
        }
        .empty-cart-message p {
            margin-bottom: 1.5rem; /* Space below text */
        }
        .empty-cart-message .btn-primary {
            font-weight: 600; /* Bold button text */
        }

        /* Responsive */
        @media (max-width: 768px) { /* Adjusted breakpoint for nav collapse */
            .main-nav ul { gap: 0; flex-direction: column; width: 100%; text-align: center; }
            .main-nav li a { padding: 0.75rem 1rem; }
            .main-nav .dropdown-content { position: static; display: none; background-color: #333; box-shadow: none; border-radius: 0; border-top: none; }
            .main-nav li.dropdown:hover .dropdown-content { display: none; }
            .main-nav li.dropdown:hover > a { background-color: var(--color-black); }
            .main-nav li.dropdown a:hover { background-color: var(--color-red-vibrant); }

            /* Cart specific responsive */
            .cart-container { padding: 1.5rem; }
            .cart-grid th, .cart-grid td { padding: 0.75rem; font-size: 0.9rem; }
            .cart-item-image { width: 50px; height: 75px; margin-right: 0.75rem;}
            .cart-item-details .title { font-size: 0.95rem; }
            .cart-quantity { flex-direction: column; align-items: flex-start; gap: 0.25rem; }
            .asp-input-sm { width: 50px; }
             .cart-summary { max-width: none; } /* Full width summary on mobile */
             .cart-actions { justify-content: center; } /* Center buttons */
        }

    </style>
</head>
<body>
    <form id="form1" runat="server">

 
        <header class="top-header">
            <div class="container">
                <div class="logo"><a href="mainpage.aspx">The Red Bookmark</a></div>
     
                <div class="header-icons">
                    <asp:LinkButton ID="btnLogin" runat="server" PostBackUrl="~/loginPage.aspx" CssClass="asp-link">
                        Login
                    </asp:LinkButton>
                    <asp:LinkButton ID="btnLogout" runat="server" OnClick="btnLogout_Click" Visible="false" CssClass="asp-link asp-link-logout">
                        Logout
                    </asp:LinkButton>
                    <a href="cartPage.aspx" class="cart-link" title="Shopping Cart" runat="server" id="cartLink">
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

        <!-- Cart Content -->
        <main class="container">
             <div class="cart-container">
                <h1 class="page-title">Shopping Cart</h1>

                <!-- Panel for Cart Items -->
                <asp:Panel ID="pnlCart" runat="server" Visible="false">
                    <table class="cart-grid">
                        <thead>
                            <tr>
                                <th colspan="2">Product</th>
                                <th>Price</th>
                                <th>Quantity</th>
                                <th>Total</th>
                                <th>&nbsp;</th>
                            </tr>
                        </thead>
                        <tbody>
                            <asp:Repeater ID="RepeaterCart" runat="server" OnItemCommand="RepeaterCart_ItemCommand">
                                <ItemTemplate>
                                    <tr>
                                        <td style="width: 70px;"> <!-- Fixed width for image column -->
                                            <img src='<%# Eval("CoverUrl") %>' alt='<%# Eval("Title") %>' class="cart-item-image"
                                                 onerror="this.onerror=null; this.src='https://placehold.co/70x105/eeeeee/cccccc?text=No+Cover';" />
                                        </td>
                                        <td>
                                            <div class="cart-item-details">
                                                <a href='bookDetailPage.aspx?id=<%# Eval("BookID") %>' class="title"><%# Eval("Title") %></a>
                                                <span class="meta">BookID: <%# Eval("BookID") %></span>
                                            </div>
                                        </td>
                                        <td class="cart-price">฿<%# Eval("Price", "{0:N2}") %></td>
                                        <td class="cart-quantity">
                                            <asp:TextBox ID="txtQuantity" runat="server" TextMode="Number" Text='<%# Eval("Quantity") %>'
                                                CssClass="asp-input-sm" min="1"></asp:TextBox> <!-- Added min attribute -->
                                            <asp:Button ID="btnUpdate" runat="server" Text="Update" CommandName="Update"
                                                CommandArgument='<%# Eval("BookID") %>' CssClass="btn btn-secondary" />
                                        </td>
                                        <td class="cart-total-price"><strong>฿<%# Eval("TotalPrice", "{0:N2}") %></strong></td>
                                        <td class="cart-remove">
                                            <asp:LinkButton ID="btnRemove" runat="server" CommandName="Remove"
                                                CommandArgument='<%# Eval("BookID") %>' OnClientClick="return confirm('Are you sure you want to remove this item?');"
                                                CssClass="btn-link-danger">Remove</asp:LinkButton>
                                        </td>
                                    </tr>
                                </ItemTemplate>
                            </asp:Repeater>
                        </tbody>
                    </table>

                    <div class="cart-summary">
                        <div class="summary-row">
                            <span>Subtotal</span>
                            <span><asp:Literal ID="ltlSubtotal" runat="server" Text="฿0.00"></asp:Literal></span>
                        </div>
                        <div class="summary-row">
                            <span>Shipping</span>
                            <span><asp:Literal ID="ltlShipping" runat="server" Text="฿50.00"></asp:Literal></span>
                        </div>
                        <div class="summary-row total">
                            <span>Total</span>
                            <span><asp:Literal ID="ltlTotal" runat="server" Text="฿0.00"></asp:Literal></span>
                        </div>
                    </div>

                    <div class="cart-actions">
                        <a href="mainpage.aspx" class="btn btn-secondary">Continue Shopping</a>
                        <asp:Button ID="btnCheckout" runat="server" Text="Confirm Order" CssClass="btn btn-primary" OnClick="btnCheckout_Click" />
                    </div>
                </asp:Panel>

                 <!-- Panel for Empty Cart Message -->
                <asp:Panel ID="pnlEmptyCart" runat="server" Visible="true" CssClass="empty-cart-message">
                    <p>Your shopping cart is empty.</p>
                    <a href="mainpage.aspx" class="btn btn-primary">Go Shopping</a>
                </asp:Panel>

            </div>
        </main>
    </form>
    
    <!-- JavaScript for Icons -->
    <script type="text/javascript">
        feather.replace();
    </script>
</body>
</html>

