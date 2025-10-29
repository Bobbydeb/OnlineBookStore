<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="reviewPage.aspx.cs" Inherits="OnlineBookStore.reviewPage" %>

<!DOCTYPE html>
<html lang="th">
<head runat="server">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Write a Review | The Red Bookmark</title> <!-- Changed title -->
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
            margin-bottom: 2rem; /* Reduced bottom margin slightly */
            color: var(--color-black); 
            text-align: center;
            position: relative;
        }
         /* Removed the ::after pseudo-element for this page's title */
        
        /* --- Styles for Review Page --- */
        .review-layout {
            display: flex;
            justify-content: center; /* Center the form container */
        }

        .review-form-container {
            background-color: var(--color-white);
            border: 1px solid var(--color-gray-medium);
            border-radius: var(--border-radius-large); /* Larger radius */
            box-shadow: var(--shadow-medium); /* Slightly stronger shadow */
            padding: 2.5rem; /* Increased padding */
            width: 100%;
            max-width: 700px; /* Increased max width */
            box-sizing: border-box;
        }

        .review-book-info {
            display: flex;
            flex-direction: column; 
            align-items: center;   
            gap: 1.5rem;             
            margin-bottom: 2.5rem;
            border-bottom: 1px solid var(--color-gray-medium);
            padding-bottom: 2rem;
            text-align: center;
        }
        .review-book-info img {
            width: 100%;
            max-width: 200px; /* Adjusted size */
            height: 300px;    /* Adjusted size */
            object-fit: cover;
            border-radius: var(--border-radius-main);    
            background-color: var(--color-gray-light);
            border: 1px solid var(--color-gray-medium);
            box-shadow: var(--shadow-soft);
        }
       
        .review-book-details {
            width: 100%;
        }
        .review-book-details .reviewing-label { /* Added class for "You are reviewing:" */
             font-size: 0.9rem; 
             color: var(--color-gray-dark); 
             font-weight: 500;
             display: block;
             margin-bottom: 0.25rem;
        }
        .review-book-details h2 { /* Title */
            font-size: 1.75rem; /* Larger title */
            font-weight: 600;
            margin: 0 0 0.75rem 0; /* Adjusted margin */
            color: var(--color-black);
            line-height: 1.3;
        }
       
        .review-book-details p {
            font-size: 0.9rem;
            color: var(--color-gray-dark);
            margin: 0.25rem 0;
        }
        .review-book-details strong {
            color: var(--color-black);
            font-weight: 600;
        }
       
        .form-group {
            margin-bottom: 1.5rem;
        }
        .form-group label {
            display: block;
            font-size: 1rem;
            font-weight: 600;
            margin-bottom: 0.6rem;
            color: var(--color-black);
        }
        /* Styling for Dropdown and Textarea */
        .asp-input {
            width: 100%;
            padding: 0.8rem 1rem;
            font-size: 1rem;
            border: 1px solid var(--color-gray-medium);
            border-radius: var(--border-radius-main);
            box-sizing: border-box; 
            font-family: var(--font-primary);
            background-color: var(--color-white);
            transition: border-color 0.3s, box-shadow 0.3s;
        }
        .asp-input:focus {
             outline: none;
             border-color: var(--color-red-vibrant);
             box-shadow: 0 0 0 3px rgba(224, 0, 0, 0.1);
        }
        
        .asp-textarea {
             min-height: 180px; /* Taller textarea */
             resize: vertical;
        }

        .form-actions {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 1rem;
            margin-top: 2rem; /* Added margin-top */
            padding-top: 1.5rem;
            border-top: 1px solid var(--color-gray-medium);
        }
        
        /* Consistent Button Styling */
        .btn { 
            padding: 10px 20px; 
            border: none; 
            border-radius: var(--border-radius-main); 
            font-size: 1rem; 
            font-weight: 600; 
            cursor: pointer; 
            transition: all 0.3s;
            text-align: center;
        }
        .btn-primary { 
             background-color: var(--color-red-vibrant); 
             color: var(--color-white); 
        }
        .btn-primary:hover { 
             background-color: var(--color-red-deep); 
             box-shadow: 0 4px 10px rgba(224, 0, 0, 0.2);
        }
        .btn-link { /* For the back link */
             color: var(--color-gray-dark);
             font-size: 0.95rem;
             font-weight: 500;
             background: none;
             border: none;
             padding: 0;
        }
        .btn-link:hover {
             color: var(--color-black);
             text-decoration: underline;
        }

        .error-message {
            color: var(--color-red-vibrant);
            margin-bottom: 1.5rem; /* Increased margin */
            font-weight: 600;
            background-color: #fee2e2; /* Light red background */
            border: 1px solid var(--color-red-deep);
            padding: 0.75rem 1rem;
            border-radius: var(--border-radius-main);
            text-align: center;
        }
        
        .review-done-message {
             text-align: center;
             font-size: 1.1rem;
             color: var(--color-black);
             background-color: #d1fae5; /* Light green background */
             border: 1px solid #065f46; /* Darker green border */
             padding: 1.5rem;
             border-radius: var(--border-radius-main);
        }
        .review-done-message p {
            margin-bottom: 1rem;
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
            .review-form-container { padding: 1.5rem; } /* Less padding on mobile */
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

        <!-- Main Content -->
        <main class="container">
            <div class="review-layout">
                
                <div class="review-form-container">
                    <h1 class="page-title">Write a Review</h1> <!-- Changed text -->
                    
                    <div class="review-book-info">
                        <asp:Image ID="imgBookCover" runat="server" 
                            onerror="this.onerror=null; this.src='https://placehold.co/200x300/eeeeee/cccccc?text=No+Cover';" />
                        <div class="review-book-details">
                           <span class="reviewing-label">You are reviewing:</span>
                            <asp:Label ID="lblBookTitle" runat="server" TagName="h2" Text="Loading..."></asp:Label>
                            <p><strong>Author:</strong> <asp:Label ID="lblAuthors" runat="server">N/A</asp:Label></p>
                            <p><strong>Genre:</strong> <asp:Label ID="lblCategory" runat="server">N/A</asp:Label></p>
                            <p><strong>Edition:</strong> <asp:Label ID="lblEdition" runat="server">N/A</asp:Label></p>
                        </div>
                    </div>

                    <!-- Panel for review form -->
                    <asp:Panel ID="pnlReviewForm" runat="server">
                        <asp:Label ID="lblErrorMessage" runat="server" CssClass="error-message" Visible="false"></asp:Label>
                        
                        <div class="form-group">
                            <label for="<%= ddlRating.ClientID %>">Rating</label>
                            <asp:DropDownList ID="ddlRating" runat="server" CssClass="asp-input"></asp:DropDownList> 
                        </div>
                        
                        <div class="form-group">
                            <label for="<%= txtComment.ClientID %>">Comment</label>
                            <asp:TextBox ID="txtComment" runat="server" TextMode="MultiLine" CssClass="asp-input asp-textarea" Rows="6"></asp:TextBox> 
                        </div>

                        <div class="form-actions">
                             <asp:Button ID="btnSubmitReview" runat="server" Text="Submit Review" CssClass="btn btn-primary" OnClick="btnSubmitReview_Click" />
                             <asp:HyperLink ID="hlBack" runat="server" NavigateUrl="~/myCollectionPage.aspx" CssClass="btn btn-link">Back to My Collection</asp:HyperLink> 
                        </div>
                    </asp:Panel>
                    
                    <!-- Panel shown when already reviewed -->
                     <asp:Panel ID="pnlReviewDone" runat="server" Visible="false" CssClass="review-done-message">
                        <p>You have already reviewed this book.</p>
                        <asp:HyperLink ID="hlBack2" runat="server" NavigateUrl="~/myCollectionPage.aspx" CssClass="btn btn-link" Font-Bold="true">Back to My Collection</asp:HyperLink> 
                    </asp:Panel>

                </div>

            </div>
        </main>

    </form>
    
    <!-- JavaScript for Icons -->
    <script type="text/javascript">
        feather.replace();
    </script>
</body>
</html>
