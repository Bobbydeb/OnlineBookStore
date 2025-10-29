<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="registerPage.aspx.cs" Inherits="OnlineBookStore.registerPage" %>

<!DOCTYPE html>
<html lang="th">
<head runat="server">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sign Up | The Red Bookmark</title>
    <!-- Minimalist Font -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">

    <!-- Feather Icons for UI -->
    <script src="https://unpkg.com/feather-icons"></script>
    <style>
        /* --- Modern Red/Black Theme Variables (Copied from loginPage) --- */
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
            background-color: var(--color-gray-light);
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            margin: 0;
            padding: 2rem;
        }

        .register-container { /* Renamed from login-container */
            background-color: var(--color-white);
            padding: 2.5rem 3rem;
            border-radius: var(--border-radius-large);
            box-shadow: var(--shadow-medium);
            width: 100%;
            max-width: 480px; /* Slightly wider for more fields */
            border: 1px solid var(--color-gray-medium);
        }

        .icon-container {
            display: flex;
            justify-content: center;
            color: var(--color-red-vibrant);
            margin-bottom: 1.5rem;
        }
        .icon-container i {
             width: 48px;
             height: 48px;
             stroke-width: 1.5;
        }

        h1 {
            text-align: center;
            color: var(--color-black);
            margin-bottom: 2rem;
            font-size: 1.8rem;
            font-weight: 700;
        }

        label {
            display: block;
            margin-bottom: 0.5rem;
            color: var(--color-gray-dark);
            font-weight: 600;
            font-size: 0.9rem;
        }

        .input-group {
            display: flex;
            align-items: center;
            border: 1px solid var(--color-gray-medium);
            border-radius: var(--border-radius-main);
            padding: 0.6rem 0.8rem;
            margin-bottom: 1.25rem;
            transition: border-color 0.3s, box-shadow 0.3s;
        }

        .input-group:focus-within {
            border-color: var(--color-red-vibrant);
            box-shadow: 0 0 0 3px rgba(230, 0, 0, 0.1);
        }

        .input-group i {
            color: var(--color-gray-dark);
            margin-right: 0.75rem;
            width: 20px;
            height: 20px;
            stroke-width: 2;
            flex-shrink: 0;
        }

        /* --- Updated Input and Textarea Styles --- */
        .input-group input[type="text"],
        .input-group input[type="password"],
        .input-group input[type="email"],
        .input-group input[type="tel"], /* Added tel type */
        .input-group textarea
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
        .input-group textarea {
             resize: vertical; /* Allow vertical resize */
             min-height: 40px; /* Adjusted minimum height for address */
             line-height: 1.5; /* Improve textarea line height */
             padding-top: 2px; /* Fine-tune alignment */
        }

        input::placeholder, textarea::placeholder { /* Added textarea */
            color: #aaa; /* Lighter placeholder */
            opacity: 1;
        }
        /* --- End Updated Styles --- */


        .btn-register { /* Renamed from btn-login */
            width: 100%;
            background-color: var(--color-red-vibrant);
            color: var(--color-white);
            border: none;
            padding: 0.8rem 1rem;
            font-size: 1rem;
            font-weight: 600;
            border-radius: var(--border-radius-main);
            cursor: pointer;
            transition: background-color 0.3s, transform 0.2s;
            margin-top: 1rem;
        }

        .btn-register:hover { /* Renamed */
            background-color: var(--color-red-deep);
            transform: translateY(-2px);
        }

        .msg { /* General message/error label */
            display: block; /* Ensure it takes space */
            text-align: center;
            color: var(--color-red-vibrant);
            margin-top: 1rem;
            font-size: 0.9rem;
            font-weight: 500;
            min-height: 1.2em; /* Reserve space */
        }
         .msg-success { /* Specific style for success */
             color: green;
         }

        .login-link { /* Renamed from signup-link */
            text-align: center;
            margin-top: 1.5rem;
            font-size: 0.9rem;
            color: var(--color-gray-dark);
        }
        .login-link a {
            font-weight: 600;
             color: var(--color-red-vibrant);
        }
         .login-link a:hover {
            text-decoration: underline;
         }

        /* Validation Error Styles */
        .validation-error {
             color: var(--color-red-vibrant);
             font-size: 0.85rem;
             margin-top: 4px; /* Space below input group */
             margin-bottom: 0.75rem; /* Space before next label */
             display: block;
        }
        /* Style for ValidationSummary */
        .validation-summary {
            margin-bottom: 1rem;
            padding: 0.75rem 1rem;
            border: 1px solid var(--color-red-vibrant);
            background-color: #fee2e2; /* Light red background */
            border-radius: var(--border-radius-main);
        }
        .validation-summary ul {
            padding-left: 20px;
            margin: 0;
            color: var(--color-red-deep);
        }
         .validation-summary li {
             margin-bottom: 0.25rem;
             font-size: 0.9rem;
         }
         .validation-summary span { /* Header text */
             font-weight: 600;
             color: var(--color-red-deep);
             display: block;
             margin-bottom: 0.5rem;
         }

         /* Adjust margin for input groups immediately followed by a validation error */
         .input-group + .validation-error {
             margin-top: -0.75rem; /* Pull error closer to the input */
         }


    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="register-container">
            <div class="icon-container">
                 <i data-feather="user-plus"></i> <!-- Changed Icon -->
            </div>
            <h1>Create Your Account</h1>

            <%-- Display Validation Summary at the top --%>
            <asp:ValidationSummary ID="RegisterValidationSummary" runat="server"
                 CssClass="validation-summary" HeaderText="Please fix the following errors:"
                 ValidationGroup="Register" Display="BulletList" />

            <%-- General Message Label (for success/non-validation errors) --%>
            <asp:Label ID="lblMessage" runat="server" CssClass="msg" EnableViewState="false" />

            <label for="<%= txtFullName.ClientID %>">Full Name</label>
            <div class="input-group">
                 <i data-feather="user"></i>
                <asp:TextBox ID="txtFullName" runat="server" placeholder="Enter your full name" />
            </div>
            <asp:RequiredFieldValidator ID="reqFullName" runat="server" ControlToValidate="txtFullName"
                ErrorMessage="Full Name is required." CssClass="validation-error" Display="Dynamic" ValidationGroup="Register">*</asp:RequiredFieldValidator>

            <label for="<%= txtEmail.ClientID %>">Email Address</label>
            <div class="input-group">
                 <i data-feather="mail"></i>
                <asp:TextBox ID="txtEmail" runat="server" placeholder="you@example.com" type="email" />
            </div>
            <asp:RequiredFieldValidator ID="reqEmail" runat="server" ControlToValidate="txtEmail"
                ErrorMessage="Email is required." CssClass="validation-error" Display="Dynamic" ValidationGroup="Register">*</asp:RequiredFieldValidator>
            <asp:RegularExpressionValidator ID="regexEmail" runat="server" ControlToValidate="txtEmail"
                ErrorMessage="Invalid email format." ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"
                CssClass="validation-error" Display="Dynamic" ValidationGroup="Register">*</asp:RegularExpressionValidator>


            <label for="<%= txtPassword.ClientID %>">Password</label>
            <div class="input-group">
                <i data-feather="lock"></i>
                <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" placeholder="Create a password" />
            </div>
             <asp:RequiredFieldValidator ID="reqPassword" runat="server" ControlToValidate="txtPassword"
                ErrorMessage="Password is required." CssClass="validation-error" Display="Dynamic" ValidationGroup="Register">*</asp:RequiredFieldValidator>


            <label for="<%= txtConfirmPassword.ClientID %>">Confirm Password</label>
            <div class="input-group">
                <i data-feather="check-circle"></i>
                <asp:TextBox ID="txtConfirmPassword" runat="server" TextMode="Password" placeholder="Confirm your password" />
            </div>
             <asp:RequiredFieldValidator ID="reqConfirmPassword" runat="server" ControlToValidate="txtConfirmPassword"
                ErrorMessage="Please confirm your password." CssClass="validation-error" Display="Dynamic" ValidationGroup="Register">*</asp:RequiredFieldValidator>
            <asp:CompareValidator ID="comparePassword" runat="server" ControlToValidate="txtConfirmPassword"
                ControlToCompare="txtPassword" Operator="Equal" Type="String"
                ErrorMessage="Passwords do not match." CssClass="validation-error" Display="Dynamic" ValidationGroup="Register">*</asp:CompareValidator>


             <label for="<%= txtAddress.ClientID %>">Address (Optional)</label>
            <div class="input-group">
                <i data-feather="home"></i>
                <%-- Using TextMode="MultiLine" renders a textarea --%>
                <asp:TextBox ID="txtAddress" runat="server" TextMode="MultiLine" Rows="2" placeholder="Enter your address"></asp:TextBox>
            </div>


            <label for="<%= txtPhone.ClientID %>">Phone (Optional)</label>
            <div class="input-group">
                <i data-feather="phone"></i>
                <asp:TextBox ID="txtPhone" runat="server" placeholder="Enter your phone number" type="tel" />
            </div>


            <asp:Button ID="btnRegister" runat="server" Text="Sign Up" CssClass="btn-register" OnClick="btnRegister_Click" ValidationGroup="Register" />


            <div class="login-link">
                Already have an account? <a href="loginPage.aspx">Log In</a>
            </div>
        </div>
    </form>
     <!-- Script to replace icons -->
    <script>
        feather.replace();
    </script>
</body>
</html>

