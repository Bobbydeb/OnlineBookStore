<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="myAccountPage.aspx.cs" Inherits="OnlineBookStore.myAccountPage" %>

<!DOCTYPE html>
<html lang="th">
<head runat="server">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Bookstore - บัญชีของฉัน</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 0; background-color: #f0f2f5; color: #333; }
        a { text-decoration: none; color: inherit; }
        .container { width: 90%; max-width: 1200px; margin: 0 auto; }
        
        /* Header & Nav Styles (from original file) */
        .top-header { background-color: #fff; padding: 10px 0; border-bottom: 1px solid #ddd; }
        .top-header .container { display: flex; justify-content: space-between; align-items: center; }
        .logo { font-size: 1.5rem; font-weight: bold; color: #d90000; }
        .search-bar { flex-grow: 1; margin: 0 20px; }
        .search-bar input { width: 100%; max-width: 400px; padding: 8px 40px 8px 12px; border: 1px solid #ccc; border-radius: 20px; }
        .header-icons { display: flex; gap: 15px; font-size: 0.95rem; }
        .main-nav { background-color: #333; color: #fff; padding: 6px 0; }
        .main-nav .container { display: flex; justify-content: center; align-items: center; }
        .main-nav ul { list-style: none; margin: 0; padding: 0; display: flex; gap: 10px; flex-wrap: wrap; justify-content: center; }
        .main-nav li a { padding: 6px 10px; font-size: 0.9rem; display: block; border-radius: 5px; transition: background-color 0.2s; color: #fff; }
        .main-nav li a:hover { background-color: #555; }
        .dropdown-content { display: none; position: absolute; top: 100%; left: 0; background-color: #444; min-width: 200px; border-radius: 6px; padding: 8px 0; box-shadow: 0 6px 16px rgba(0,0,0,0.2); }
        .dropdown-content a { padding: 8px 14px; font-size: 0.9rem; display: block; color: #fff; }
        .dropdown-content a:hover { background-color: #555; }
        .dropdown:hover .dropdown-content { display: block; }
        
        /* Main Content Styles */
        main { padding: 20px 0; }
        .section-title { font-size: 1.8rem; font-weight: bold; margin: 20px 0 30px 0; color: #111; }

        /* Account Form Styles */
        .account-container {
            display: flex;
            gap: 30px;
            flex-wrap: wrap;
        }
        .account-form {
            flex: 2;
            min-width: 300px;
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
            padding: 25px 30px;
        }
        .account-form h3 {
            font-size: 1.5rem;
            color: #d90000;
            margin-top: 0;
            margin-bottom: 25px;
            border-bottom: 2px solid #f0f0f0;
            padding-bottom: 10px;
        }
        .form-group {
            margin-bottom: 18px;
        }
        .form-group label {
            display: block;
            font-weight: bold;
            margin-bottom: 6px;
            font-size: 0.9rem;
            color: #555;
        }
        .form-group .asp-textbox {
            width: 100%;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 5px;
            box-sizing: border-box; /* Important for 100% width */
            font-size: 1rem;
            background-color: #fafafa;
        }
        .form-group .asp-textbox[readonly] {
            background-color: #eee;
            color: #777;
            cursor: not-allowed;
        }
        .form-actions {
            margin-top: 25px;
            display: flex;
            gap: 10px;
        }
        .btn {
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            font-size: 1rem;
            font-weight: bold;
            cursor: pointer;
            transition: background-color 0.2s, box-shadow 0.2s;
        }
        .btn-primary {
            background-color: #d90000;
            color: #fff;
        }
        .btn-primary:hover {
            background-color: #b30000;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        .btn-secondary {
            background-color: #6c757d;
            color: #fff;
        }
        .btn-secondary:hover {
            background-color: #5a6268;
        }
        .btn-light {
            background-color: #f0f0f0;
            color: #333;
            border: 1px solid #ccc;
        }
        .btn-light:hover {
            background-color: #e0e0e0;
        }

        .message-label {
            font-size: 0.9rem;
            display: block;
            margin-top: 15px;
        }
        .message-success {
            color: green;
        }
        .message-error {
            color: red;
        }
        .validation-error {
            color: red;
            font-size: 0.85rem;
            margin-top: 5px;
        }

    </style>
</head>
<body>
    <form id="form1" runat="server">

        <!-- Header -->
        <header class="top-header">
            <div class="container">
                <div class="logo">MyBookstore</div>
                <div class="search-bar">
                    <input type="text" placeholder="ค้นหาหนังสือ...">
                </div>
                <div class="header-icons">
                    <asp:LinkButton ID="btnLogin" runat="server" PostBackUrl="~/loginPage.aspx">
                        👤 Login
                    </asp:LinkButton>
                    <asp:LinkButton ID="btnLogout" runat="server" OnClick="btnLogout_Click" ForeColor="Red" Visible="false">
                        ⏻ Logout
                    </asp:LinkButton>
                </div>
            </div>
        </header>

        <!-- Navigation -->
        <nav class="main-nav">
            <div class="container">
                <ul>
                    <li><a href="mainpage.aspx">หน้าแรก</a></li>
                    <li><a href="topSalePage.aspx">หนังสือขายดี</a></li>
                    <li class="dropdown">
                        <a href="#">หมวดหมู่ ▼</a>
                        <div class="dropdown-content">
                            <%-- Category links --%>
                            <a href="#">Fiction</a>
                            <a href="#">Non-fiction</a>
                            <a href="#">Children’s Books</a>
                            <a href="#">Education / Academic</a>
                        </div>
                    </li>
                    <li><a href="myAccountPage.aspx">บัญชีของฉัน</a></li>
                    <li><a href="myCollectionPage.aspx">คอลเลคชั่นของฉัน</a></li>
                </ul>
            </div>
        </nav>

        <!-- Main Content -->
        <main class="container">
            <h2 class="section-title">บัญชีของฉัน</h2>
            
            <%-- User Info Label (Original, can be removed or kept) --%>
            <asp:Label ID="lblUserInfo" runat="server" Font-Bold="true" Font-Size="Large" />

            <div class="account-container">

                <!-- Profile Details Form -->
                <div class="account-form">
                    <h3>ข้อมูลส่วนตัว</h3>
                    <asp:ValidationSummary ID="ProfileValidationSummary" runat="server" CssClass="validation-error" HeaderText="กรุณาแก้ไขข้อผิดพลาด:" />
                    
                    <div class="form-group">
                        <label for="txtFullName">ชื่อ-นามสกุล (Full Name)</label>
                        <asp:TextBox ID="txtFullName" runat="server" CssClass="asp-textbox" ReadOnly="true"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="reqFullName" runat="server" ControlToValidate="txtFullName"
                            ErrorMessage="กรุณากรอกชื่อ-นามสกุล" CssClass="validation-error" Display="Dynamic" ValidationGroup="Profile">*</asp:RequiredFieldValidator>
                    </div>
                    
                    <div class="form-group">
                        <label for="txtEmail">อีเมล (Email)</label>
                        <asp:TextBox ID="txtEmail" runat="server" CssClass="asp-textbox" ReadOnly="true"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="reqEmail" runat="server" ControlToValidate="txtEmail"
                            ErrorMessage="กรุณากรอกอีเมล" CssClass="validation-error" Display="Dynamic" ValidationGroup="Profile">*</asp:RequiredFieldValidator>
                        <asp:RegularExpressionValidator ID="regexEmail" runat="server" ControlToValidate="txtEmail"
                            ErrorMessage="รูปแบบอีเมลไม่ถูกต้อง" ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"
                            CssClass="validation-error" Display="Dynamic" ValidationGroup="Profile">*</asp:RegularExpressionValidator>
                    </div>

                    <div class="form-group">
                        <label for="txtAddress">ที่อยู่ (Address)</label>
                        <asp:TextBox ID="txtAddress" runat="server" CssClass="asp-textbox" TextMode="MultiLine" Rows="3" ReadOnly="true"></asp:TextBox>
                    </div>

                    <div class="form-group">
                        <label for="txtPhone">เบอร์โทรศัพท์ (Phone)</label>
                        <asp:TextBox ID="txtPhone" runat="server" CssClass="asp-textbox" ReadOnly="true"></asp:TextBox>
                    </div>

                    <asp:Label ID="lblProfileMessage" runat="server" CssClass="message-label" EnableViewState="false"></asp:Label>

                    <div class="form-actions">
                        <asp:Button ID="btnEditProfile" runat="server" Text="แก้ไขข้อมูล" CssClass="btn btn-primary" OnClick="btnEditProfile_Click" />
                        <asp:Button ID="btnSaveProfile" runat="server" Text="บันทึก" CssClass="btn btn-primary" OnClick="btnSaveProfile_Click" ValidationGroup="Profile" Visible="false" />
                        <asp:Button ID="btnCancelEdit" runat="server" Text="ยกเลิก" CssClass="btn btn-light" OnClick="btnCancelEdit_Click" CausesValidation="false" Visible="false" />
                    </div>
                </div>

                <!-- Change Password Form -->
                <div class="account-form">
                    <h3>เปลี่ยนรหัสผ่าน</h3>
                    <asp:ValidationSummary ID="PasswordValidationSummary" runat="server" CssClass="validation-error" HeaderText="กรุณาแก้ไขข้อผิดพลาด:" ValidationGroup="Password" />

                    <div class="form-group">
                        <label for="txtCurrentPassword">รหัสผ่านปัจจุบัน</label>
                        <asp:TextBox ID="txtCurrentPassword" runat="server" CssClass="asp-textbox" TextMode="Password"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="reqCurrentPassword" runat="server" ControlToValidate="txtCurrentPassword"
                            ErrorMessage="กรุณากรอกรหัสผ่านปัจจุบัน" CssClass="validation-error" Display="Dynamic" ValidationGroup="Password">*</asp:RequiredFieldValidator>
                    </div>

                    <div class="form-group">
                        <label for="txtNewPassword">รหัสผ่านใหม่</label>
                        <asp:TextBox ID="txtNewPassword" runat="server" CssClass="asp-textbox" TextMode="Password"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="reqNewPassword" runat="server" ControlToValidate="txtNewPassword"
                            ErrorMessage="กรุณากรอกรหัสผ่านใหม่" CssClass="validation-error" Display="Dynamic" ValidationGroup="Password">*</asp:RequiredFieldValidator>
                    </div>

                    <div class="form-group">
                        <label for="txtConfirmPassword">ยืนยันรหัสผ่านใหม่</label>
                        <asp:TextBox ID="txtConfirmPassword" runat="server" CssClass="asp-textbox" TextMode="Password"></asp:TextBox>
                        <asp:CompareValidator ID="compareNewPassword" runat="server" ControlToValidate="txtConfirmPassword"
                            ControlToCompare="txtNewPassword" Operator="Equal" Type="String"
                            ErrorMessage="รหัสผ่านใหม่และการยืนยันไม่ตรงกัน" CssClass="validation-error" Display="Dynamic" ValidationGroup="Password">*</asp:CompareValidator>
                    </div>

                    <asp:Label ID="lblPasswordMessage" runat="server" CssClass="message-label" EnableViewState="false"></asp:Label>

                    <div class="form-actions">
                        <asp:Button ID="btnChangePassword" runat="server" Text="เปลี่ยนรหัสผ่าน" CssClass="btn btn-secondary" OnClick="btnChangePassword_Click" ValidationGroup="Password" />
                    </div>
                </div>

            </div>

        </main>

    </form>
</body>
</html>
