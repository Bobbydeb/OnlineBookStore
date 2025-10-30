<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="loginPage.aspx.cs" Inherits="OnlineBookStore.loginPage" %>

<!DOCTYPE html>
<html lang="th">
<head runat="server">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login | ChaiChaKit</title> <!-- Changed title -->
    <!-- Minimalist Font -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">

    <!-- Feather Icons for UI -->
    <script src="https://unpkg.com/feather-icons"></script>
    <style>
        /* --- Modern Red/Black Theme Variables --- */
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

        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            font-family: var(--font-primary);
            background-color: var(--color-gray-light); /* Light gray background */
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh; /* Use min-height */
            margin: 0;
            padding: 2rem; /* Add padding for smaller screens */
        }

        .login-container {
            background-color: var(--color-white);
            padding: 2.5rem 3rem; /* Adjusted padding */
            border-radius: var(--border-radius-large); /* Use theme variable */
            box-shadow: var(--shadow-medium); /* Use theme variable */
            width: 100%; /* Full width on small screens */
            max-width: 420px; /* Max width */
            border: 1px solid var(--color-gray-medium); /* Subtle border */
        }

        .icon-container { /* Renamed for clarity */
            display: flex;
            justify-content: center;
            color: var(--color-red-vibrant); /* Theme color */
            margin-bottom: 1.5rem; /* Increased margin */
        }
        .icon-container i { /* Style feather icon */
             width: 48px;
             height: 48px;
             stroke-width: 1.5; /* Adjust stroke */
        }

        h1 {
            text-align: center;
            color: var(--color-black); /* Black heading */
            margin-bottom: 2rem; /* Increased margin */
            font-size: 1.8rem; /* Adjusted size */
            font-weight: 700;
        }

        label {
            display: block;
            margin-bottom: 0.5rem; /* Adjusted margin */
            color: var(--color-gray-dark); /* Darker gray */
            font-weight: 600;
            font-size: 0.9rem;
        }

        .input-group {
            display: flex;
            align-items: center;
            border: 1px solid var(--color-gray-medium); /* Theme border color */
            border-radius: var(--border-radius-main); /* Theme radius */
            padding: 0.6rem 0.8rem; /* Adjusted padding */
            margin-bottom: 1.25rem; /* Adjusted margin */
            transition: border-color 0.3s, box-shadow 0.3s;
        }

        .input-group:focus-within {
            border-color: var(--color-red-vibrant); /* Red border on focus */
            box-shadow: 0 0 0 3px rgba(230, 0, 0, 0.1); /* Red glow on focus */
        }

        .input-group i { /* Style feather icons in input */
            color: var(--color-gray-dark); /* Gray icon */
            margin-right: 0.75rem; /* Space after icon */
            width: 20px;
            height: 20px;
            stroke-width: 2;
            flex-shrink: 0; /* Prevent icon from shrinking */
        }

        /* --- Updated Input Styles --- */
        .input-group input[type="text"],
        .input-group input[type="password"],
        .input-group input[type="email"] /* Added email type */
        {
            border: none !important; /* Force remove border */
            outline: none !important; /* Force remove outline */
            box-shadow: none !important; /* Force remove shadow */
            width: 100%;
            padding: 0; /* Remove default padding */
            font-size: 1rem; /* Standard font size */
            background-color: transparent !important; /* Force transparent background */
            font-family: var(--font-primary);
            color: var(--color-black);
            height: auto; /* Allow height to adjust */
            line-height: inherit; /* Inherit line height */
            appearance: none; /* Remove default appearance */
             -webkit-appearance: none;
             -moz-appearance: none;
        }
         /* Placeholder styling */
        input::placeholder {
            color: var(--color-gray-medium);
            opacity: 1; /* Ensure placeholder is visible */
        }


        .btn-login {
            width: 100%;
            background-color: var(--color-red-vibrant); /* Theme red */
            color: var(--color-white); /* White text */
            border: none;
            padding: 0.8rem 1rem; /* Adjusted padding */
            font-size: 1rem;
            font-weight: 600; /* Medium bold */
            border-radius: var(--border-radius-main); /* Theme radius */
            cursor: pointer;
            transition: background-color 0.3s, transform 0.2s;
            margin-top: 1rem; /* Space above button */
        }

        .btn-login:hover {
            background-color: var(--color-red-deep); /* Darker red on hover */
            transform: translateY(-2px); /* Slight lift */
        }

        .msg {
            text-align: center;
            color: var(--color-red-vibrant); /* Theme red for errors */
            margin-top: 1rem; /* Space below button */
            font-size: 0.9rem;
            font-weight: 500;
        }

        /* Optional: Link for sign up */
        .signup-link {
            text-align: center;
            margin-top: 1.5rem;
            font-size: 0.9rem;
            color: var(--color-gray-dark);
        }
        .signup-link a {
            font-weight: 600;
             color: var(--color-red-vibrant);
        }
         .signup-link a:hover {
            text-decoration: underline;
         }

    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="login-container">
            <div class="icon-container">
                 <i data-feather="book-open"></i> <!-- Feather Icon -->
            </div>
            <h1>ChaiChaKit Bookstore Login</h1>

            <label for="<%= txtEmail.ClientID %>">Email Address</label> <!-- Changed label -->
            <div class="input-group">
                 <i data-feather="mail"></i> <!-- Feather Icon -->
                <%-- Update type to email for better semantics --%>
                <asp:TextBox ID="txtEmail" runat="server" placeholder=" you@example.com" type="email" />
            </div>

            <label for="<%= txtPassword.ClientID %>">Password</label>
            <div class="input-group">
                <i data-feather="lock"></i> <!-- Feather Icon -->
                <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" placeholder=" Enter your password" />
            </div>

            <asp:Button ID="btnLogin" runat="server" Text="Log In" CssClass="btn-login" OnClick="btnLogin_Click" />

            <asp:Label ID="lblMessage" runat="server" CssClass="msg" EnableViewState="false" /> <!-- Added EnableViewState=false -->

             <!-- Optional Sign Up Link -->
            <div class="signup-link">
                Don't have an account? <a href="registerPage.aspx">Sign Up</a>
                <%-- Make sure you have a registerPage.aspx if you use this --%>
            </div>
        </div>
    </form>
     <!-- Script to replace icons -->
    <script>
        feather.replace();
    </script>
</body>
</html>

