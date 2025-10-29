<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="myAccountPage.aspx.cs" Inherits="OnlineBookStore.myAccountPage" %>

<!DOCTYPE html>
<html lang="th">
<head runat="server">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Account | The Red Bookmark</title>
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
        
        /* [NEW] Search Bar Removed for My Account Page, uncomment if needed */
        /*
        .search-bar { 
            flex-grow: 1; 
            display: flex; 
            max-width: 500px;
            position: relative;
        }
        .search-input { 
            width: 100%; 
            padding: 12px 20px; 
            padding-right: 50px;
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
        */

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

        /* --- [NEW] Content & Form Styles --- */
        main { 
            padding: 3rem 0; 
        }
        
        /* [NEW] Page Title Style */
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
        
        .user-info-label {
            font-size: 1.25rem;
            font-weight: 500;
            text-align: center;
            margin-bottom: 2.5rem;
            color: var(--color-gray-dark);
        }
        .user-info-label strong {
            color: var(--color-black);
        }

        /* [NEW] Account Form Styles */
        .account-container { 
            display: grid; 
            grid-template-columns: 1fr;
            gap: 2rem; 
        }
        
        @media (min-width: 900px) {
            .account-container {
                grid-template-columns: 1fr 1fr; /* Two columns on desktop */
            }
        }

        .account-form { 
            background-color: var(--color-white); 
            border-radius: var(--border-radius-large); 
            box-shadow: var(--shadow-soft); 
            padding: 2rem; 
            border: 1px solid var(--color-gray-medium);
        }
        .account-form h3 { 
            font-size: 1.5rem; 
            color: var(--color-red-vibrant); 
            margin-top: 0; 
            margin-bottom: 1.5rem; 
            border-bottom: 2px solid var(--color-gray-light); 
            padding-bottom: 1rem; 
        }
        .form-group { 
            margin-bottom: 1.25rem; 
        }
        .form-group label { 
            display: block; 
            font-weight: 600; 
            margin-bottom: 0.5rem; 
            font-size: 0.9rem; 
            color: var(--color-black); 
        }
        .form-group .asp-textbox { 
            width: 100%; 
            padding: 12px 15px; 
            border: 1px solid var(--color-gray-medium); 
            border-radius: var(--border-radius-main); 
            box-sizing: border-box; 
            font-size: 1rem; 
            font-family: var(--font-primary);
            background-color: var(--color-white);
            transition: border-color 0.3s, box-shadow 0.3s;
        }
        .form-group .asp-textbox:focus {
            outline: none;
            border-color: var(--color-red-vibrant);
            box-shadow: 0 0 0 3px rgba(230, 0, 0, 0.1);
        }
        .form-group .asp-textbox.readonly { 
            background-color: var(--color-gray-light); 
            color: var(--color-gray-dark); 
            cursor: not-allowed; 
        }
        
        .form-actions { 
            margin-top: 2rem; 
            display: flex; 
            gap: 0.75rem; 
            flex-wrap: wrap;
        }
        
        /* [NEW] Button Styles */
        .btn { 
            padding: 12px 24px; 
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
            box-shadow: 0 4px 10px rgba(179, 0, 0, 0.2);
        }
        .btn-secondary { 
            background-color: var(--color-black); 
            color: var(--color-white); 
        }
        .btn-secondary:hover { 
            background-color: #333; 
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
        }
        .btn-light { 
            background-color: var(--color-gray-light); 
            color: var(--color-black); 
            border: 1px solid var(--color-gray-medium); 
        }
        .btn-light:hover { 
            background-color: var(--color-gray-medium); 
        }

        /* [NEW] Message & Validation Styles */
        .message-label { 
            font-size: 0.95rem; 
            font-weight: 500;
            display: block; 
            margin-top: 1.5rem; 
            padding: 1rem;
            border-radius: var(--border-radius-main);
        }
        .message-success { 
            color: #155724; 
            background-color: #d4edda;
            border: 1px solid #c3e6cb;
        }
        .message-error { 
            color: #721c24; 
            background-color: #f8d7da;
            border: 1px solid #f5c6cb;
        }
        .validation-error { 
            color: var(--color-red-vibrant); 
            font-size: 0.85rem; 
            margin-top: 5px; 
            display: block; 
        }
        .validation-summary {
            color: var(--color-red-vibrant);
            background: #fff5f5;
            border: 1px solid var(--color-red-vibrant);
            border-radius: var(--border-radius-main);
            padding: 1rem;
            margin-bottom: 1.5rem;
        }
        .validation-summary ul {
            margin-left: 1.5rem;
            padding: 0;
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
        }
        @media (max-width: 480px) {
            .container { width: 95%; }
            .header-icons { gap: 1rem; }
            .account-form { padding: 1.5rem; }
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

        <!-- [NEW] Navigation -->
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
            <h2 class="page-title">My Account</h2>
            
            <div class="user-info-label">
                <asp:Label ID="lblUserInfo" runat="server" Text="Welcome!" />
            </div>

            <div class="account-container">

                <!-- Profile Details Form -->
                <div class="account-form">
                    <h3>Profile Details</h3>
                    <asp:ValidationSummary ID="ProfileValidationSummary" runat="server" CssClass="validation-summary" HeaderText="Please correct the following errors:" ValidationGroup="Profile" Display="BulletList" />
                    
                    <div class="form-group">
                        <label for="<%= txtFullName.ClientID %>">Full Name</label>
                        <asp:TextBox ID="txtFullName" runat="server" CssClass="asp-textbox readonly" ReadOnly="true"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="reqFullName" runat="server" ControlToValidate="txtFullName"
                            ErrorMessage="Full Name is required." CssClass="validation-error" Display="Dynamic" ValidationGroup="Profile">*</asp:RequiredFieldValidator>
                    </div>
                    
                    <div class="form-group">
                        <label for="<%= txtEmail.ClientID %>">Email</label>
                        <asp:TextBox ID="txtEmail" runat="server" CssClass="asp-textbox readonly" ReadOnly="true"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="reqEmail" runat="server" ControlToValidate="txtEmail"
                            ErrorMessage="Email is required." CssClass="validation-error" Display="Dynamic" ValidationGroup="Profile">*</asp:RequiredFieldValidator>
                        <asp:RegularExpressionValidator ID="regexEmail" runat="server" ControlToValidate="txtEmail"
                            ErrorMessage="Email format is incorrect." ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"
                            CssClass="validation-error" Display="Dynamic" ValidationGroup="Profile">*</asp:RegularExpressionValidator>
                    </div>

                    <div class="form-group">
                        <label for="<%= txtAddress.ClientID %>">Address</label>
                        <asp:TextBox ID="txtAddress" runat="server" CssClass="asp-textbox readonly" TextMode="MultiLine" Rows="3" ReadOnly="true"></asp:TextBox>
                    </div>

                    <div class="form-group">
                        <label for="<%= txtPhone.ClientID %>">Phone</label>
                        <asp:TextBox ID="txtPhone" runat="server" CssClass="asp-textbox readonly" ReadOnly="true"></asp:TextBox>
                    </div>

                    <asp:Label ID="lblProfileMessage" runat="server" EnableViewState="false"></asp:Label>

                    <div class="form-actions">
                        <asp:Button ID="btnEditProfile" runat="server" Text="Edit Profile" CssClass="btn btn-primary" OnClick="btnEditProfile_Click" CausesValidation="false" />
                        <asp:Button ID="btnSaveProfile" runat="server" Text="Save Changes" CssClass="btn btn-primary" OnClick="btnSaveProfile_Click" ValidationGroup="Profile" Visible="false" />
                        <asp:Button ID="btnCancelEdit" runat="server" Text="Cancel" CssClass="btn btn-light" OnClick="btnCancelEdit_Click" CausesValidation="false" Visible="false" />
                    </div>
                </div>

                <!-- Change Password Form -->
                <div class="account-form">
                    <h3>Change Password</h3>
                    <asp:ValidationSummary ID="PasswordValidationSummary" runat="server" CssClass="validation-summary" HeaderText="Please correct the following errors:" ValidationGroup="Password" Display="BulletList" />

                    <div class="form-group">
                        <label for="<%= txtCurrentPassword.ClientID %>">Current Password</label>
                        <asp:TextBox ID="txtCurrentPassword" runat="server" CssClass="asp-textbox" TextMode="Password"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="reqCurrentPassword" runat="server" ControlToValidate="txtCurrentPassword"
                            ErrorMessage="Current Password is required." CssClass="validation-error" Display="Dynamic" ValidationGroup="Password">*</asp:RequiredFieldValidator>
                    </div>

                    <div class="form-group">
                        <label for="<%= txtNewPassword.ClientID %>">New Password</label>
                        <asp:TextBox ID="txtNewPassword" runat="server" CssClass="asp-textbox" TextMode="Password"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="reqNewPassword" runat="server" ControlToValidate="txtNewPassword"
                            ErrorMessage="New Password is required." CssClass="validation-error" Display="Dynamic" ValidationGroup="Password">*</asp:RequiredFieldValidator>
                    </div>

                    <div class="form-group">
                        <label for="<%= txtConfirmPassword.ClientID %>">Confirm New Password</label>
                        <asp:TextBox ID="txtConfirmPassword" runat="server" CssClass="asp-textbox" TextMode="Password"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="reqConfirmPassword" runat="server" ControlToValidate="txtConfirmPassword"
                            ErrorMessage="Please confirm your new password." CssClass="validation-error" Display="Dynamic" ValidationGroup="Password">*</asp:RequiredFieldValidator>
                        <asp:CompareValidator ID="compareNewPassword" runat="server" ControlToValidate="txtConfirmPassword"
                            ControlToCompare="txtNewPassword" Operator="Equal" Type="String"
                            ErrorMessage="The new passwords do not match." CssClass="validation-error" Display="Dynamic" ValidationGroup="Password">*</asp:CompareValidator>
                    </div>

                    <asp:Label ID="lblPasswordMessage" runat="server" EnableViewState="false"></asp:Label>

                    <div class="form-actions">
                        <asp:Button ID="btnChangePassword" runat="server" Text="Change Password" CssClass="btn btn-secondary" OnClick="btnChangePassword_Click" ValidationGroup="Password" />
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
