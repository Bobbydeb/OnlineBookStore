<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="adminPage.aspx.cs" Inherits="OnlineBookStore.adminPage" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Admin Page</title>
    <%-- Stylesheets... --%>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet" />
    
    <style>
        /* ▼▼▼ NEW COLOR PALETTE ▼▼▼ */
        :root {
            --bookstore-primary: #C70039; /* Ruby Red */
            --bookstore-primary-hover: #A3002D; /* Darker Ruby */
            --bookstore-accent-gold: #D4AF37; 
            --bookstore-accent-gold-hover: #B8860B;
            --bookstore-charcoal: #343A40;
            --bookstore-light-gray: #F8F9FA;
            --bookstore-white: #FFFFFF;
            --bookstore-danger: #dc3545;
            --bookstore-danger-hover: #c82333;
            --bookstore-success: #28a745;
            --bookstore-success-hover: #218838;
            --bookstore-secondary: #6c757d;
            --bookstore-secondary-hover: #5c636a;
        }

        body {
            background-color: var(--bookstore-light-gray); /* Use light gray neutral */
        }
        
        /* --- Navigation --- */
        .navbar-dark.bg-dark {
             background-color: var(--bookstore-charcoal) !important;
        }

        .footer.bg-dark {
             background-color: var(--bookstore-charcoal) !important;
        }

        .nav-tabs .nav-link {
            color: var(--bookstore-secondary);
        }
        .nav-tabs .nav-link.active,
        .nav-tabs .nav-item.show .nav-link {
            color: var(--bookstore-primary);
            background-color: var(--bookstore-white);
            border-color: #dee2e6 #dee2e6 var(--bookstore-white);
        }
        .nav-tabs .nav-link:hover,
        .nav-tabs .nav-link:focus {
             border-color: #e9ecef #e9ecef #dee2e6;
             color: var(--bookstore-primary-hover);
        }


        /* --- Buttons --- */
        .btn-primary {
            background-color: var(--bookstore-primary);
            border-color: var(--bookstore-primary);
            color: var(--bookstore-white);
        }
        .btn-primary:hover {
            background-color: var(--bookstore-primary-hover);
            border-color: var(--bookstore-primary-hover);
            color: var(--bookstore-white);
        }

        /* --- GridView Styles --- */
        .table-primary th {
            color: var(--bookstore-white);
            background-color: var(--bookstore-primary);
            border-color: var(--bookstore-primary);
        }
        .gridview-pagination table {
            border-collapse: collapse;
            margin: 1rem 0;
            border: 0;
        }
        .gridview-pagination td {
            padding: 0;
            border: 0;
        }
        .gridview-pagination a,
        .gridview-pagination span {
            display: block;
            padding: 0.375rem 0.75rem;
            margin-left: -1px; /* Collapses borders */
            line-height: 1.25;
            color: var(--bookstore-primary); /* Use primary color for links */
            background-color: var(--bookstore-white);
            border: 1px solid #dee2e6;
            text-decoration: none;
            transition: color .15s ease-in-out,background-color .15s ease-in-out,border-color .15s ease-in-out,box-shadow .15s ease-in-out;
        }
        .gridview-pagination span {
            z-index: 3;
            color: var(--bookstore-white);
            background-color: var(--bookstore-primary); /* Use primary color for active page */
            border-color: var(--bookstore-primary);
            cursor: default;
        }
        .gridview-pagination a:hover {
            z-index: 2;
            color: var(--bookstore-primary-hover);
            background-color: #e9ecef;
            border-color: #dee2e6;
        }
        .gridview-pagination td:first-child a,
        .gridview-pagination td:first-child span {
            border-top-left-radius: 0.25rem;
            border-bottom-left-radius: 0.25rem;
        }
        .gridview-pagination td:last-child a,
        .gridview-pagination td:last-child span {
            border-top-right-radius: 0.25rem;
            border-bottom-right-radius: 0.25rem;
        }
        .gridview-pagination table {
            margin-left: auto;
            margin-right: auto;
        }
        .card-body > .gridview-pagination {
             margin-bottom: 1rem;
        }
        .card-body > .table-responsive + .gridview-pagination {
            margin-top: 1rem;
            margin-bottom: 0;
        }
        .table-responsive a[href*="Edit"],
        .table-responsive a[href*="Delete"],
        .table-responsive a[href*="Update"],
        .table-responsive a[href*="Cancel"] {
            display: inline-block;
            margin-right: 5px;
            padding: 0.25rem 0.5rem;
            font-size: .875rem;
            border-radius: 0.2rem;
            text-decoration: none;
            color: var(--bookstore-white); /* Default to white text */
        }
        .table-responsive a[href*="Edit"] {
            background-color: var(--bookstore-secondary);
            border-color: var(--bookstore-secondary);
        }
        .table-responsive a[href*="Edit"]:hover {
            background-color: var(--bookstore-secondary-hover);
        }
        .table-responsive a[href*="Delete"] {
            background-color: var(--bookstore-danger);
            border-color: var(--bookstore-danger);
        }
         .table-responsive a[href*="Delete"]:hover {
            background-color: var(--bookstore-danger-hover);
        }
        .table-responsive a[href*="Update"] {
            background-color: var(--bookstore-success);
            border-color: var(--bookstore-success);
        }
        .table-responsive a[href*="Update"]:hover {
            background-color: var(--bookstore-success-hover);
        }
        .table-responsive a[href*="Cancel"] {
            color: var(--bookstore-charcoal); /* Gold needs dark text */
            background-color: var(--bookstore-accent-gold);
            border-color: var(--bookstore-accent-gold);
        }
        .table-responsive a[href*="Cancel"]:hover {
            background-color: var(--bookstore-accent-gold-hover);
        }
        .table-responsive input[type="text"] {
            width: 100%;
            min-width: 150px; /* Adjust as needed */
            padding: 0.25rem;
            font-size: 0.9rem;
            box-sizing: border-box; /* Important */
        }
        #messageBar {
            display: none;
            position: fixed;
            top: 20px;
            right: 20px;
            z-index: 2000;
            min-width: 300px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
        }
        .form-label {
            font-weight: 500;
        }
        .validator-error {
            color: var(--bookstore-danger); /* Use danger color */
            font-size: 0.875em;
            display: block;
            margin-top: 0.25rem;
        }
    </style>
</head>
<body class="bg-light">
    
 
       <div id="messageBar" class="alert alert-dismissible fade" role="alert">
        <span id="messageText"></span>
        <button type="button" class="btn-close" onclick="hideMessageBar()" aria-label="Close"></button>
    </div>

    <form id="form1" runat="server">
        <%-- ... (Your Navbar) ... --%>
            <nav class="navbar navbar-expand-lg navbar-dark bg-dark sticky-top">
                <div class="container-fluid">
                    <a class="navbar-brand" href="#"><i class="bi bi-shield-lock-fill"></i> Admin Panel</a>
                    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#adminNavbar" aria-controls="adminNavbar" aria-expanded="false" aria-label="Toggle navigation">
                        <span class="navbar-toggler-icon"></span>
                    </button>
      
                   <div class="collapse navbar-collapse" id="adminNavbar">
                        <ul class="navbar-nav ms-auto mb-2 mb-lg-0">                  
                            <li class="nav-item">
                                <asp:LinkButton ID="btnLogout" runat="server" CssClass="nav-link" OnClick="btnLogout_Click">Logout</asp:LinkButton>
                            </li>
                        </ul>
                    </div>
                </div>
            </nav>
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
        <asp:HiddenField ID="hdnActiveTab" runat="server" ClientIDMode="Static" />

        <div class="container mt-4 mb-4">
            
      
           <h2 class="mb-3"><i class="bi bi-gear-wide-connected"></i> Bookstore Management</h2>

            <%-- ... (Your Nav Tabs) ... --%>
            <ul class="nav nav-tabs" id="adminTabs" role="tablist">
                <li class="nav-item" role="presentation">
                    <a class="nav-link active" id="books-tab" data-bs-toggle="tab" href="#books" role="tab" aria-controls="books" aria-selected="true"><i class="bi bi-book"></i> หนังสือ</a>
                </li>
                <li class="nav-item" role="presentation">
                    <a class="nav-link" id="authors-tab" data-bs-toggle="tab" href="#authors" role="tab" aria-controls="authors" aria-selected="false"><i class="bi bi-person"></i> ผู้แต่ง</a>
                </li>
                <li class="nav-item" role="presentation">
                    <a class="nav-link" id="publishers-tab" data-bs-toggle="tab" href="#publishers" role="tab" 
 aria-controls="publishers" aria-selected="false"><i class="bi bi-building"></i> สำนักพิมพ์</a>
                </li>
                <li class="nav-item" role="presentation">
                    <a class="nav-link" id="members-tab" data-bs-toggle="tab" href="#members" role="tab" aria-controls="members" aria-selected="false"><i class="bi bi-people"></i> สมาชิก</a>
                </li>
                 <li class="nav-item" role="presentation">
                    <a class="nav-link" id="orders-tab" data-bs-toggle="tab" href="#orders" role="tab" aria-controls="orders" aria-selected="false"><i class="bi bi-box-seam"></i> คำสั่งซื้อ</a>
                </li>
                <li class="nav-item" role="presentation">
                    <a class="nav-link" id="reviews-tab" data-bs-toggle="tab" href="#reviews" role="tab" aria-controls="reviews" aria-selected="false"><i class="bi bi-star"></i> รีวิว</a>
                 </li>
            </ul>

            <div class="tab-content mt-3">

                <!-- ======================= BOOKS TAB ======================= -->
                <div class="tab-pane fade show active" id="books" role="tabpanel" aria-labelledby="books-tab">
                    
                    <asp:UpdatePanel ID="UpdatePanelBooks" runat="server" UpdateMode="Conditional">
                        <ContentTemplate>
                            <div class="card shadow-sm">
                                <div class="card-header bg-light">
                                     <h4 class="mb-0">จัดการหนังสือ</h4>
                                </div>
                                <div class="card-body">
                                     <div class="d-flex justify-content-end mb-3">
                                         <button type="button" class="btn btn-primary btn-sm" data-bs-toggle="modal" data-bs-target="#addBookModal">
                                            <i class="bi bi-plus-circle"></i> เพิ่มหนังสือใหม่
                                        </button>
                                    </div>
                                    <div class="table-responsive">
                                         <asp:GridView ID="GridViewBooks" runat="server"
                                            CssClass="table table-striped table-hover table-bordered"
                                            HeaderStyle-CssClass="table-primary"
                                            AutoGenerateColumns="false"
                                            AllowPaging="true" PageSize="10"
                                            DataKeyNames="BookID"
                                            PagerSettings-Position="TopAndBottom"
                                            PagerSettings-Mode="NumericFirstLast"
                                            PagerStyle-CssClass="gridview-pagination"
                                            PagerSettings-FirstPageText="&laquo;"
                                            PagerSettings-PreviousPageText="&lsaquo;" 
                                            PagerSettings-NextPageText="&rsaquo;" 
                                            PagerSettings-LastPageText="&raquo;" 
                                            PagerSettings-PageButtonCount="5"
                                            OnPageIndexChanging="GridViewBooks_PageIndexChanging"
                                            OnRowEditing="GridView_RowEditing"
                                            OnRowCancelingEdit="GridView_RowCancelingEdit"
                                            OnRowUpdating="GridViewBooks_RowUpdating"
                                            OnRowDeleting="GridViewBooks_RowDeleting">
                                            <Columns>
                                                 <asp:CommandField ShowEditButton="true" ShowDeleteButton="true" ShowCancelButton="true" 
                                                    HeaderText="Actions" ItemStyle-Width="150px" ControlStyle-CssClass="gridview-command" />
                                                 <asp:BoundField DataField="BookID" HeaderText="BookID" ReadOnly="true" ItemStyle-Width="80px" />
                                                <asp:BoundField DataField="ISBN" HeaderText="ISBN" ItemStyle-Width="130px" />
                                                <asp:BoundField DataField="Title" HeaderText="Title" />
                                                <asp:BoundField DataField="Price" HeaderText="Price" DataFormatString="{0:n2}" ItemStyle-Width="100px" ItemStyle-HorizontalAlign="Right" />
                                                <asp:BoundField DataField="Stock" HeaderText="Stock" ItemStyle-Width="80px" ItemStyle-HorizontalAlign="Center" />
                                                <asp:BoundField DataField="PublisherID" HeaderText="PublisherID" ItemStyle-Width="80px"  />
                                                <asp:BoundField DataField="CategoryID" HeaderText="CategoryID" ItemStyle-Width="80px"  />
                                                <asp:BoundField DataField="CoverUrl" HeaderText="Image URL" />
                                            </Columns>
                                            <PagerStyle CssClass="gridview-pagination" />
                                            <HeaderStyle CssClass="table-primary" />
                                            <RowStyle VerticalAlign="Top" />
                                            <EditRowStyle BackColor="#f2f2f2" />
                                         </asp:GridView>
                                    </div>
                                </div>
                            </div>
                        </ContentTemplate>
                        <%-- This Trigger makes the GRID refresh when the SAVE button (in the modal) is clicked --%>
                        <Triggers>
                            <asp:AsyncPostBackTrigger ControlID="btnSaveBook" EventName="Click" />
                        </Triggers>
                    </asp:UpdatePanel>

                    <%-- Book Modal (outside the grid's UpdatePanel) --%>
                    <div class="modal fade" id="addBookModal" tabindex="-1" aria-labelledby="addBookModalLabel" aria-hidden="true">
                        <div class="modal-dialog modal-lg">
                            <div class="modal-content">
                                <asp:UpdatePanel ID="UpdatePanelAddBook" runat="server" UpdateMode="Conditional">
                                    <ContentTemplate>
                                        <div class="modal-header">
                                            <h5 class="modal-title" id="addBookModalLabel"><i class="bi bi-book-fill"></i> เพิ่มหนังสือใหม่</h5>
                                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                        </div>
                                        <div class="modal-body">
                                            <div class="row g-3">
                                                <div class="col-md-6">
                                                    <label for="<%= txtAddBookId.ClientID %>" class="form-label">BookID (รหัสหนังสือ)</label>
                                                    <asp:TextBox ID="txtAddBookId" runat="server" CssClass="form-control" placeholder="เช่น 1001"></asp:TextBox>
                                                    <asp:RequiredFieldValidator ID="rfvBookId" runat="server" ErrorMessage="กรุณากรอก BookID" ControlToValidate="txtAddBookId" Display="Dynamic" CssClass="validator-error" ValidationGroup="AddBookValidation"></asp:RequiredFieldValidator>
                                                    <asp:CompareValidator ID="cvBookId" runat="server" ErrorMessage="BookID ต้องเป็นตัวเลข" ControlToValidate="txtAddBookId" Operator="DataTypeCheck" Type="Integer" Display="Dynamic" CssClass="validator-error" ValidationGroup="AddBookValidation"></asp:CompareValidator>
                                                </div>
                                                <div class="col-md-6">
                                                    <label for="<%= txtAddBookIsbn.ClientID %>" class="form-label">ISBN (13 หลัก)</label>
                                                    <asp:TextBox ID="txtAddBookIsbn" runat="server" CssClass="form-control" MaxLength="13"></asp:TextBox>
                                                    <asp:RequiredFieldValidator ID="rfvBookIsbn" runat="server" ErrorMessage="กรุณากรอก ISBN" ControlToValidate="txtAddBookIsbn" Display="Dynamic" CssClass="validator-error" ValidationGroup="AddBookValidation"></asp:RequiredFieldValidator>
                                                    <asp:RegularExpressionValidator ID="revBookIsbn" runat="server" ErrorMessage="ISBN ต้องเป็นตัวเลข 13 หลัก" ControlToValidate="txtAddBookIsbn" ValidationExpression="^\d{13}$" Display="Dynamic" CssClass="validator-error" ValidationGroup="AddBookValidation"></asp:RegularExpressionValidator>
                                                </div>
                                                <div class="col-12">
                                                    <label for="<%= txtAddBookTitle.ClientID %>" class="form-label">Title (ชื่อหนังสือ)</label>
                                                    <asp:TextBox ID="txtAddBookTitle" runat="server" CssClass="form-control"></asp:TextBox>
                                                    <asp:RequiredFieldValidator ID="rfvBookTitle" runat="server" ErrorMessage="กรุณากรอกชื่อหนังสือ" ControlToValidate="txtAddBookTitle" Display="Dynamic" CssClass="validator-error" ValidationGroup="AddBookValidation"></asp:RequiredFieldValidator>
                                                </div>
                                                <div class="col-md-4">
                                                    <label for="<%= txtAddBookPrice.ClientID %>" class="form-label">Price (ราคา)</label>
                                                    <asp:TextBox ID="txtAddBookPrice" runat="server" CssClass="form-control" TextMode="Number" step="0.01"></asp:TextBox>
                                                    <asp:RequiredFieldValidator ID="rfvBookPrice" runat="server" ErrorMessage="กรุณากรอกราคา" ControlToValidate="txtAddBookPrice" Display="Dynamic" CssClass="validator-error" ValidationGroup="AddBookValidation"></asp:RequiredFieldValidator>
                                                    <asp:CompareValidator ID="cvBookPriceType" runat="server" ErrorMessage="ราคาต้องเป็นตัวเลข" ControlToValidate="txtAddBookPrice" Operator="DataTypeCheck" Type="Currency" Display="Dynamic" CssClass="validator-error" ValidationGroup="AddBookValidation"></asp:CompareValidator>
                                                    <asp:RangeValidator ID="rvBookPrice" runat="server" ErrorMessage="ราคาต้องไม่ติดลบ" ControlToValidate="txtAddBookPrice" MinimumValue="0" MaximumValue="999999" Type="Currency" Display="Dynamic" CssClass="validator-error" ValidationGroup="AddBookValidation"></asp:RangeValidator>
                                                </div>
                                                <div class="col-md-4">
                                                    <label for="<%= txtAddBookStock.ClientID %>" class="form-label">Stock (จำนวนคงคลัง)</label>
                                                    <asp:TextBox ID="txtAddBookStock" runat="server" CssClass="form-control" TextMode="Number"></asp:TextBox>
                                                    <asp:RequiredFieldValidator ID="rfvBookStock" runat="server" ErrorMessage="กรุณากรอกจำนวน" ControlToValidate="txtAddBookStock" Display="Dynamic" CssClass="validator-error" ValidationGroup="AddBookValidation"></asp:RequiredFieldValidator>
                                                    <asp:CompareValidator ID="cvBookStock" runat="server" ErrorMessage="Stock ต้องเป็นตัวเลข" ControlToValidate="txtAddBookStock" Operator="DataTypeCheck" Type="Integer" Display="Dynamic" CssClass="validator-error" ValidationGroup="AddBookValidation"></asp:CompareValidator>
                                                    <asp:RangeValidator ID="rvBookStock" runat="server" ErrorMessage="Stock ต้องไม่ติดลบ" ControlToValidate="txtAddBookStock" MinimumValue="0" MaximumValue="99999" Type="Integer" Display="Dynamic" CssClass="validator-error" ValidationGroup="AddBookValidation"></asp:RangeValidator>
                                                </div>
                                                <div class="col-md-4">
                                                    <label for="<%= txtAddBookPubId.ClientID %>" class="form-label">PublisherID (รหัสสำนักพิมพ์)</label>
                                                    <asp:TextBox ID="txtAddBookPubId" runat="server" CssClass="form-control" TextMode="Number"></asp:TextBox>
                                                    <asp:RequiredFieldValidator ID="rfvBookPubId" runat="server" ErrorMessage="กรุณากรอก PublisherID" ControlToValidate="txtAddBookPubId" Display="Dynamic" CssClass="validator-error" ValidationGroup="AddBookValidation"></asp:RequiredFieldValidator>
                                                    <asp:CompareValidator ID="cvBookPubId" runat="server" ErrorMessage="PublisherID ต้องเป็นตัวเลข" ControlToValidate="txtAddBookPubId" Operator="DataTypeCheck" Type="Integer" Display="Dynamic" CssClass="validator-error" ValidationGroup="AddBookValidation"></asp:CompareValidator>
                                                </div>
                                                <div class="col-md-4">
                                                    <label for="<%= txtAddBookCatId.ClientID %>" class="form-label">CategoryID (รหัสประเภท)</label>
                                                    <asp:TextBox ID="txtAddBookCatId" runat="server" CssClass="form-control" TextMode="Number"></asp:TextBox>
                                                    <asp:RequiredFieldValidator ID="rfvBookCatId" runat="server" ErrorMessage="กรุณากรอก CategoryID" ControlToValidate="txtAddBookCatId" Display="Dynamic" CssClass="validator-error" ValidationGroup="AddBookValidation"></asp:RequiredFieldValidator>
                                                    <asp:CompareValidator ID="cvBookCatId" runat="server" ErrorMessage="CategoryID ต้องเป็นตัวเลข" ControlToValidate="txtAddBookCatId" Operator="DataTypeCheck" Type="Integer" Display="Dynamic" CssClass="validator-error" ValidationGroup="AddBookValidation"></asp:CompareValidator>
                                                </div>
                                                <div class="col-md-8">
                                                    <label for="<%= txtAddBookImageUrl.ClientID %>" class="form-label">Image URL (ลิงก์รูปภาพ)</label>
                                                    <asp:TextBox ID="txtAddBookImageUrl" runat="server" CssClass="form-control" TextMode="Url" placeholder="https://example.com/image.jpg"></asp:TextBox>
                                                    <%-- ไม่บังคับ --%>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="modal-footer">
                                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">ปิด</button>
                                            <%-- ▼▼▼ MODIFIED Button ▼▼▼ --%>
                                            <asp:Button ID="btnSaveBook" runat="server" Text="บันทึก" CssClass="btn btn-primary" OnClick="btnSaveBook_Click" ValidationGroup="AddBookValidation" />
                                        </div>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- ======================= AUTHORS TAB ======================= -->
                <div class="tab-pane fade" id="authors" role="tabpanel" aria-labelledby="authors-tab">
                    <asp:UpdatePanel ID="UpdatePanelAuthors" runat="server" UpdateMode="Conditional">
                        <ContentTemplate>
                            <div class="card shadow-sm">
                                 <div class="card-header bg-light">
                                    <h4 class="mb-0">จัดการผู้แต่ง</h4>
                                </div>
                                     <div class="card-body">
                                    <div class="d-flex justify-content-end mb-3">
                                        <button type="button" class="btn btn-primary btn-sm" data-bs-toggle="modal" data-bs-target="#addAuthorModal">
                                            <i class="bi bi-plus-circle"></i> เพิ่มผู้แต่งใหม่
                                        </button>
                                    </div>
                                    <div class="table-responsive">
                                         <asp:GridView ID="GridViewAuthors" runat="server"
                                            CssClass="table table-striped table-hover table-bordered"
                                             HeaderStyle-CssClass="table-primary"
                                            AutoGenerateColumns="false"
                                             AllowPaging="true" PageSize="10"
                                            DataKeyNames="AuthorID"
                                            PagerSettings-Position="TopAndBottom"
                                            PagerSettings-Mode="NumericFirstLast"
                                            PagerStyle-CssClass="gridview-pagination"
                                            PagerSettings-FirstPageText="&laquo;"
                                            PagerSettings-PreviousPageText="&lsaquo;" 
                                            PagerSettings-NextPageText="&rsaquo;" 
                                            PagerSettings-LastPageText="&raquo;" 
                                            PagerSettings-PageButtonCount="5"
                                            OnPageIndexChanging="GridViewAuthors_PageIndexChanging"
                                            OnRowEditing="GridView_RowEditing"
                                            OnRowCancelingEdit="GridView_RowCancelingEdit"
                                            OnRowUpdating="GridViewAuthors_RowUpdating"
                                            OnRowDeleting="GridViewAuthors_RowDeleting">
                                            <Columns>
                                                 <asp:CommandField ShowEditButton="true" ShowDeleteButton="true" ShowCancelButton="true" 
                                                    HeaderText="Actions" ItemStyle-Width="150px" ControlStyle-CssClass="gridview-command" />
                                                 <asp:BoundField DataField="AuthorID" HeaderText="AuthorID" ReadOnly="true" ItemStyle-Width="100px" />
                                                <asp:BoundField DataField="AuthorName" HeaderText="Author Name" />
                                                <asp:BoundField DataField="Email" HeaderText="Email" />
                                            </Columns>
                                            <PagerStyle CssClass="gridview-pagination" />
                                            <HeaderStyle CssClass="table-primary" />
                                            <EditRowStyle BackColor="#f2f2f2" />
                                        </asp:GridView>
                                    </div>
                                 </div>
                            </div>
                        </ContentTemplate>
                        <Triggers>
                            <asp:AsyncPostBackTrigger ControlID="btnSaveAuthor" EventName="Click" />
                        </Triggers>
                    </asp:UpdatePanel>

                    <%-- Author Modal (outside the grid's UpdatePanel) --%>
                    <div class="modal fade" id="addAuthorModal" tabindex="-1" aria-labelledby="addAuthorModalLabel" aria-hidden="true">
                        <div class="modal-dialog">
                            <div class="modal-content">
                                <asp:UpdatePanel ID="UpdatePanelAddAuthor" runat="server" UpdateMode="Conditional">
                                    <ContentTemplate>
                                        <div class="modal-header">
                                            <h5 class="modal-title" id="addAuthorModalLabel"><i class="bi bi-person-fill-add"></i> เพิ่มผู้แต่งใหม่</h5>
                                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                        </div>
                                        <div class="modal-body">
                                            <div class="mb-3">
                                                <label for="<%= txtAddAuthorId.ClientID %>" class="form-label">AuthorID (รหัสผู้แต่ง)</label>
                                                <asp:TextBox ID="txtAddAuthorId" runat="server" CssClass="form-control" placeholder="เช่น 2001"></asp:TextBox>
                                                <asp:RequiredFieldValidator ID="rfvAuthorId" runat="server" ErrorMessage="กรุณากรอก AuthorID" ControlToValidate="txtAddAuthorId" Display="Dynamic" CssClass="validator-error" ValidationGroup="AddAuthorValidation"></asp:RequiredFieldValidator>
                                                <asp:CompareValidator ID="cvAuthorId" runat="server" ErrorMessage="AuthorID ต้องเป็นตัวเลข" ControlToValidate="txtAddAuthorId" Operator="DataTypeCheck" Type="Integer" Display="Dynamic" CssClass="validator-error" ValidationGroup="AddAuthorValidation"></asp:CompareValidator>
                                            </div>
                                            <div class="mb-3">
                                                <label for="<%= txtAddAuthorName.ClientID %>" class="form-label">Author Name (ชื่อผู้แต่ง)</label>
                                                <asp:TextBox ID="txtAddAuthorName" runat="server" CssClass="form-control"></asp:TextBox>
                                                <asp:RequiredFieldValidator ID="rfvAuthorName" runat="server" ErrorMessage="กรุณากรอกชื่อผู้แต่ง" ControlToValidate="txtAddAuthorName" Display="Dynamic" CssClass="validator-error" ValidationGroup="AddAuthorValidation"></asp:RequiredFieldValidator>
                                            </div>
                                            <div class="mb-3">
                                                <label for="<%= txtAddAuthorEmail.ClientID %>" class="form-label">Email</label>
                                                <asp:TextBox ID="txtAddAuthorEmail" runat="server" CssClass="form-control" TextMode="Email"></asp:TextBox>
                                                <asp:RegularExpressionValidator ID="revAuthorEmail" runat="server" ErrorMessage="รูปแบบ Email ไม่ถูกต้อง" ControlToValidate="txtAddAuthorEmail" ValidationExpression="^\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$" Display="Dynamic" CssClass="validator-error" ValidationGroup="AddAuthorValidation"></asp:RegularExpressionValidator>
                                            </div>
                                        </div>
                                        <div class="modal-footer">
                                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">ปิด</button>
                                            <%-- ▼▼▼ MODIFIED Button ▼▼▼ --%>
                                            <asp:Button ID="btnSaveAuthor" runat="server" Text="บันทึก" CssClass="btn btn-primary" OnClick="btnSaveAuthor_Click" ValidationGroup="AddAuthorValidation" />
                                        </div>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </div>
                        </div>
                    </div>
                 </div>

                <!-- ======================= PUBLISHERS TAB ======================= -->
                <div class="tab-pane fade" id="publishers" role="tabpanel" aria-labelledby="publishers-tab">
                    <asp:UpdatePanel ID="UpdatePanelPublishers" runat="server" UpdateMode="Conditional">
                        <ContentTemplate>
                             <div class="card shadow-sm">
                                <div class="card-header bg-light">
                                    <h4 class="mb-0">จัดการสำนักพิมพ์</h4>
                                 </div>
                                <div class="card-body">
                                    <div class="d-flex justify-content-end mb-3">
                                        <button type="button" class="btn btn-primary btn-sm" data-bs-toggle="modal" data-bs-target="#addPublisherModal">
                                            <i class="bi bi-plus-circle"></i> เพิ่มสำนักพิมพ์ใหม่
                                        </button>
                                    </div>
                                     <div class="table-responsive">
                                        <asp:GridView ID="GridViewPublishers" runat="server"
                                             CssClass="table table-striped table-hover table-bordered"
                                            HeaderStyle-CssClass="table-primary"
                                            AutoGenerateColumns="false"
                                            AllowPaging="true" PageSize="10"
                                            DataKeyNames="PublisherID"
                                            PagerSettings-Position="TopAndBottom"
                                            PagerSettings-Mode="NumericFirstLast"
                                            PagerStyle-CssClass="gridview-pagination"
                                            PagerSettings-FirstPageText="&laquo;"
                                            PagerSettings-PreviousPageText="&lsaquo;" 
                                            PagerSettings-NextPageText="&rsaquo;" 
                                            PagerSettings-LastPageText="&raquo;" 
                                            PagerSettings-PageButtonCount="5"
                                            OnPageIndexChanging="GridViewPublishers_PageIndexChanging"
                                            OnRowEditing="GridView_RowEditing"
                                            OnRowCancelingEdit="GridView_RowCancelingEdit"
                                            OnRowUpdating="GridViewPublishers_RowUpdating"
                                            OnRowDeleting="GridViewPublishers_RowDeleting">
                                            <Columns>
                                                 <asp:CommandField ShowEditButton="true" ShowDeleteButton="true" ShowCancelButton="true" 
                                                    HeaderText="Actions" ItemStyle-Width="150px" ControlStyle-CssClass="gridview-command" />
                                                 <asp:BoundField DataField="PublisherID" HeaderText="PublisherID" ReadOnly="true" ItemStyle-Width="100px" />
                                                <asp:BoundField DataField="PublisherName" HeaderText="Publisher Name" />
                                                <asp:BoundField DataField="Address" HeaderText="Address" />
                                                <asp:BoundField DataField="Phone" HeaderText="Phone" ItemStyle-Width="150px" />
                                           </Columns>
                                            <PagerStyle CssClass="gridview-pagination" />
                                            <HeaderStyle CssClass="table-primary" />
                                            <EditRowStyle BackColor="#f2f2f2" />
                                         </asp:GridView> 
                                    </div>
                                </div>
                            </div>
                        </ContentTemplate>
                        <Triggers>
                            <asp:AsyncPostBackTrigger ControlID="btnSavePublisher" EventName="Click" />
                        </Triggers>
                    </asp:UpdatePanel>

                    <%-- Publisher Modal (outside the grid's UpdatePanel) --%>
                    <div class="modal fade" id="addPublisherModal" tabindex="-1" aria-labelledby="addPublisherModalLabel" aria-hidden="true">
                        <div class="modal-dialog">
                            <div class="modal-content">
                                <asp:UpdatePanel ID="UpdatePanelAddPublisher" runat="server" UpdateMode="Conditional">
                                    <ContentTemplate>
                                        <div class="modal-header">
                                            <h5 class="modal-title" id="addPublisherModalLabel"><i class="bi bi-building-fill-add"></i> เพิ่มสำนักพิมพ์ใหม่</h5>
                                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                        </div>
                                        <div class="modal-body">
                                            <div class="mb-3">
                                                <label for="<%= txtAddPublisherId.ClientID %>" class="form-label">PublisherID (รหัสสำนักพิมพ์)</label>
                                                <asp:TextBox ID="txtAddPublisherId" runat="server" CssClass="form-control" placeholder="เช่น 3001"></asp:TextBox>
                                                <asp:RequiredFieldValidator ID="rfvPubId" runat="server" ErrorMessage="กรุณากรอก PublisherID" ControlToValidate="txtAddPublisherId" Display="Dynamic" CssClass="validator-error" ValidationGroup="AddPublisherValidation"></asp:RequiredFieldValidator>
                                                <asp:CompareValidator ID="cvPubId" runat="server" ErrorMessage="PublisherID ต้องเป็นตัวเลข" ControlToValidate="txtAddPublisherId" Operator="DataTypeCheck" Type="Integer" Display="Dynamic" CssClass="validator-error" ValidationGroup="AddPublisherValidation"></asp:CompareValidator>
                                            </div>
                                            <div class="mb-3">
                                                <label for="<%= txtAddPublisherName.ClientID %>" class="form-label">Publisher Name (ชื่อสำนักพิมพ์)</label>
                                                <asp:TextBox ID="txtAddPublisherName" runat="server" CssClass="form-control"></asp:TextBox>
                                                <asp:RequiredFieldValidator ID="rfvPubName" runat="server" ErrorMessage="กรุณากรอกชื่อสำนักพิมพ์" ControlToValidate="txtAddPublisherName" Display="Dynamic" CssClass="validator-error" ValidationGroup="AddPublisherValidation"></asp:RequiredFieldValidator>
                                            </div>
                                            <div class="mb-3">
                                                <label for="<%= txtAddPublisherAddress.ClientID %>" class="form-label">Address (ที่อยู่)</label>
                                                <asp:TextBox ID="txtAddPublisherAddress" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3"></asp:TextBox>
                                            </div>
                                            <div class="mb-3">
                                                <label for="<%= txtAddPublisherPhone.ClientID %>" class="form-label">Phone (เบอร์โทร)</label>
                                                <asp:TextBox ID="txtAddPublisherPhone" runat="server" CssClass="form-control"></asp:TextBox>
                                            </div>
                                        </div>
                                        <div class="modal-footer">
                                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">ปิด</button>
                                            <%-- ▼▼▼ MODIFIED Button ▼▼▼ --%>
                                            <asp:Button ID="btnSavePublisher" runat="server" Text="บันทึก" CssClass="btn btn-primary" OnClick="btnSavePublisher_Click" ValidationGroup="AddPublisherValidation" />
                                        </div>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- ======================= MEMBERS TAB ======================= -->
                <div class="tab-pane fade" id="members" role="tabpanel" aria-labelledby="members-tab">
                    <asp:UpdatePanel ID="UpdatePanelMembers" runat="server" UpdateMode="Conditional">
                        <ContentTemplate>
                            <div class="card shadow-sm">
                                 <div class="card-header bg-light">
                                    <h4 class="mb-0">จัดการสมาชิก</h4>
                                </div>
                                     <div class="card-body">
                                    <div class="table-responsive">
                                        <asp:GridView ID="GridViewMembers" runat="server"
                                            CssClass="table table-striped table-hover table-bordered"
                                            HeaderStyle-CssClass="table-primary"
                                            AutoGenerateColumns="false"
                                            AllowPaging="true" PageSize="10"
                                            DataKeyNames="MemberID"
                                            PagerSettings-Position="TopAndBottom"
                                            PagerSettings-Mode="NumericFirstLast"
                                            PagerStyle-CssClass="gridview-pagination"
                                            PagerSettings-FirstPageText="&laquo;"
                                            PagerSettings-PreviousPageText="&lsaquo;" 
                                            PagerSettings-NextPageText="&rsaquo;" 
                                            PagerSettings-LastPageText="&raquo;" 
                                            PagerSettings-PageButtonCount="5"
                                            OnPageIndexChanging="GridViewMembers_PageIndexChanging"
                                            OnRowEditing="GridView_RowEditing"
                                            OnRowCancelingEdit="GridView_RowCancelingEdit"
                                            OnRowUpdating="GridViewMembers_RowUpdating"
                                            OnRowDeleting="GridViewMembers_RowDeleting">
                                            <Columns>
                                                 <asp:CommandField ShowEditButton="true" ShowDeleteButton="true" ShowCancelButton="true" 
                                                    HeaderText="Actions" ItemStyle-Width="150px" ControlStyle-CssClass="gridview-command" />
                                                 <asp:BoundField DataField="MemberID" HeaderText="MemberID" ReadOnly="true" ItemStyle-Width="100px" />
                                                <asp:BoundField DataField="FullName" HeaderText="Full Name" />
                                                <asp:BoundField DataField="Email" HeaderText="Email" />
                                                <asp:BoundField DataField="Password" HeaderText="Password" ReadOnly="true" />
                                                <asp:BoundField DataField="Address" HeaderText="Address" />
                                                <asp:BoundField DataField="Phone" HeaderText="Phone" ItemStyle-Width="150px" />
                                                <asp:BoundField DataField="Role" HeaderText="Role" ItemStyle-Width="100px" />
                                            </Columns>
                                            <PagerStyle CssClass="gridview-pagination" />
                                            <HeaderStyle CssClass="table-primary" />
                                            <EditRowStyle BackColor="#f2f2f2" />
                                        </asp:GridView>
                                    </div>
                                 </div>
                            </div>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                 </div>

                <!-- ======================= ORDERS TAB ======================= -->
                <div class="tab-pane fade" id="orders" role="tabpanel" aria-labelledby="orders-tab">
                    <asp:UpdatePanel ID="UpdatePanelOrders" runat="server" UpdateMode="Conditional">
                       <ContentTemplate>
                            <div class="card shadow-sm">
                                <div class="card-header bg-light">
                                     <h4 class="mb-0">จัดการคำสั่งซื้อ</h4>
                                </div>
                                <div class="card-body">
                                     <div class="table-responsive">
                                        <asp:GridView ID="GridViewOrders" runat="server"
                                            CssClass="table table-striped table-hover table-bordered"
                                            HeaderStyle-CssClass="table-primary"
                                            AutoGenerateColumns="false"
                                            AllowPaging="true" PageSize="10"
                                            DataKeyNames="OrderID"
                                            PagerSettings-Position="TopAndBottom"
                                            PagerSettings-Mode="NumericFirstLast"
                                            PagerStyle-CssClass="gridview-pagination"
                                            PagerSettings-FirstPageText="&laquo;"
                                            PagerSettings-PreviousPageText="&lsaquo;" 
                                            PagerSettings-NextPageText="&rsaquo;" 
                                            PagerSettings-LastPageText="&raquo;" 
                                            PagerSettings-PageButtonCount="5"
                                            OnPageIndexChanging="GridViewOrders_PageIndexChanging"
                                            OnRowEditing="GridView_RowEditing"
                                            OnRowCancelingEdit="GridView_RowCancelingEdit"
                                            OnRowUpdating="GridViewOrders_RowUpdating"
                                            OnRowDeleting="GridViewOrders_RowDeleting">
                                            <Columns>
                                                 <asp:CommandField ShowEditButton="true" ShowDeleteButton="true" ShowCancelButton="true" 
                                                    HeaderText="Actions" ItemStyle-Width="150px" ControlStyle-CssClass="gridview-command" />
                                                 <asp:BoundField DataField="OrderID" HeaderText="OrderID" ReadOnly="true" ItemStyle-Width="100px" />
                                                <asp:BoundField DataField="MemberID" HeaderText="MemberID" ReadOnly="true" ItemStyle-Width="100px" />
                                                <asp:BoundField DataField="OrderDate" HeaderText="Order Date" ReadOnly="true" DataFormatString="{0:yyyy-MM-dd HH:mm}" />
                                                <asp:BoundField DataField="TotalAmount" HeaderText="Total" ReadOnly="true" DataFormatString="{0:n2}" ItemStyle-Width="100px" />
                                                <asp:BoundField DataField="Status" HeaderText="Status" ItemStyle-Width="120px" />
                                            </Columns>
                                            <PagerStyle CssClass="gridview-pagination" />
                                            <HeaderStyle CssClass="table-primary" />
                                            <EditRowStyle BackColor="#f2f2f2" />
                                        </asp:GridView>
                                    </div>
                                 </div>
                            </div>
                        </ContentTemplate>
                       </asp:UpdatePanel>
                </div>

                <!-- ======================= REVIEWS TAB ======================= -->
                <div class="tab-pane fade" id="reviews" role="tabpanel" aria-labelledby="reviews-tab">
                    <asp:UpdatePanel ID="UpdatePanelReviews" runat="server" UpdateMode="Conditional">
                       <ContentTemplate>
                            <div class="card shadow-sm">
                                <div class="card-header bg-light">
                                     <h4 class="mb-0">จัดการรีวิว</h4>
                                </div>
                                <div class="card-body">
                                     <div class="table-responsive">
                                        <asp:GridView ID="GridViewReviews" runat="server"
                                            CssClass="table table-striped table-hover table-bordered"
                                            HeaderStyle-CssClass="table-primary"
                                            AutoGenerateColumns="false"
                                            AllowPaging="true" PageSize="10"
                                            DataKeyNames="ReviewID"
                                            PagerSettings-Position="TopAndBottom"
                                            PagerSettings-Mode="NumericFirstLast"
                                            PagerStyle-CssClass="gridview-pagination"
                                            PagerSettings-FirstPageText="&laquo;"
                                            PagerSettings-PreviousPageText="&lsaquo;" 
                                            PagerSettings-NextPageText="&rsaquo;" 
                                            PagerSettings-LastPageText="&raquo;" 
                                            PagerSettings-PageButtonCount="5"
                                            OnPageIndexChanging="GridViewReviews_PageIndexChanging"
                                            OnRowEditing="GridView_RowEditing"
                                            OnRowCancelingEdit="GridView_RowCancelingEdit"
                                            OnRowUpdating="GridViewReviews_RowUpdating"
                                            OnRowDeleting="GridViewReviews_RowDeleting">
                                            <Columns>
                                                 <asp:CommandField ShowEditButton="true" ShowDeleteButton="true" ShowCancelButton="true" 
                                                    HeaderText="Actions" ItemStyle-Width="150px" ControlStyle-CssClass="gridview-command" />
                                                 <asp:BoundField DataField="ReviewID" HeaderText="ReviewID" ReadOnly="true" ItemStyle-Width="100px" />
                                                <asp:BoundField DataField="MemberID" HeaderText="MemberID" ReadOnly="true" ItemStyle-Width="100px" />
                                                <asp:BoundField DataField="BookID" HeaderText="BookID" ReadOnly="true" ItemStyle-Width="100px" />
                                                <asp:BoundField DataField="Rating" HeaderText="Rating" ItemStyle-Width="80px" />
                                                <asp:BoundField DataField="Comment" HeaderText="Comment" />
                                                <asp:BoundField DataField="ReviewDate" HeaderText="Review Date" ReadOnly="true" DataFormatString="{0:yyyy-MM-dd}" />
                                          </Columns>
                                            <PagerStyle CssClass="gridview-pagination" />
                                            <HeaderStyle CssClass="table-primary" />
                                            <EditRowStyle BackColor="#f2f2f2" />
                                         </asp:GridView>
                                    </div>
                                </div>
                         </div>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </div>

            </div> 
        </div> 
    </form>
    
  
       <footer class="bg-dark text-center text-white-50 p-3 mt-auto">
        &copy;
 <%= DateTime.Now.Year %> Admin Panel
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <script type="text/javascript">
        // --- Notification System ---
        function showMessage(message, type) {
            var bar = document.getElementById('messageBar');
            var text = document.getElementById('messageText');
            if (!bar || !text) return;

            text.innerText = message;
            // Reset classes
            bar.classList.remove('alert-success', 'alert-danger', 'alert-warning', 'show');
            // Add new class
            if (type === 'success') {
                bar.classList.add('alert-success');
            } else if (type === 'error') {
                bar.classList.add('alert-danger');
            } else {
                bar.classList.add('alert-warning');
            }

            bar.style.display = 'block';
            bar.classList.add('show');
            // Auto-hide after 5 seconds
            setTimeout(hideMessageBar, 5000);
        }

        function hideMessageBar() {
            var bar = document.getElementById('messageBar');
            if (bar) {
                bar.classList.remove('show');
                // Wait for fade-out transition (must match CSS)
                setTimeout(function () { bar.style.display = 'none'; }, 150);
            }
        }

        // --- ADDED: Function to hide a modal by ID ---
        function hideModal(modalId) {
            var modalEl = document.getElementById(modalId);
            if (modalEl) {
                var modalInstance = bootstrap.Modal.getInstance(modalEl);
                if (modalInstance) {
                    modalInstance.hide();
                } else {
                    // Fallback if instance isn't found (e.g., after partial postback)
                    // Try to create a new instance just to hide it
                    try {
                        var newModalInstance = new bootstrap.Modal(modalEl);
                        newModalInstance.hide();
                    } catch (e) {
                        console.error("Could not hide modal: ", modalId, e);
                    }
                }
            }
        }
        // ---------------------------------------------


        // --- Tab Persistence ---
        document.addEventListener("DOMContentLoaded", function () {
            var activeTabField = document.getElementById('hdnActiveTab');
            var adminTabs = document.getElementById('adminTabs');

            // 1. Save the active tab's href when it's shown
            if (adminTabs) {

                var tabLinks = adminTabs.querySelectorAll('a[data-bs-toggle="tab"]');
                tabLinks.forEach(function (tabLink) {
                    tabLink.addEventListener('shown.bs.tab', function (event) {
                        if (activeTabField) {

                            activeTabField.value = event.target.getAttribute('href');
                        }
                    });
                });
            }

            // 2. On page 
            load(including postbacks), restore the active tab
            if (activeTabField && activeTabField.value) {
                var tabToActivate = document.querySelector('a[href="' + activeTabField.value + '"]');
                if (tabToActivate) {
                    var tabInstance = new bootstrap.Tab(tabToActivate);
                    tabInstance.show();
                }
            } else if (activeTabField) {
                // If it's the very first load (no value saved), set the default
                var defaultActiveTab = document.querySelector('#adminTabs a.active[data-bs-toggle="tab"]');
                if (defaultActiveTab) {
                    activeTabField.value = defaultActiveTab.getAttribute('href');
                }
            }
        });

        // 3. Re-initialize tab persistence after an UpdatePanel refreshes
        var prm = Sys.WebForms.PageRequestManager.getInstance();
        if (prm) {
            prm.add_endRequest(function (sender, args) {
                var activeTabField = document.getElementById('hdnActiveTab');
                var adminTabs = document.getElementById('adminTabs');

                if (adminTabs) {
                    var tabLinks = adminTabs.querySelectorAll('a[data-bs-toggle="tab"]');

                    // We must re-bind the 'shown.bs.tab' event after AJAX load
                    // We use a simple flag to avoid duplicate bindings
                    tabLinks.forEach(function (tabLink) {

                        if (!tabLink.dataset.tabBound) { // Check if already bound
                            tabLink.addEventListener('shown.bs.tab', function (event) {
                                if (activeTabField) {

                                    activeTabField.value = event.target.getAttribute('href');
                                }
                            });
                            tabLink.dataset.tabBound =
                                "true"; // Mark as bound
                        }
                    });
                }

                // Ensure the correct tab is still visually active after AJAX
                if (activeTabField && activeTabField.value) {
                    var tabToActivate = document.querySelector('a[href="' + activeTabField.value + '"]');
                    if (tabToActivate && !tabToActivate.classList.contains('active')) {
                        // Only show if it's not already active
                        var tabInstance = new bootstrap.Tab(tabToActivate);
                        tabInstance.show();
                    }
                }
            });
        }
    </script>
</body>
</html>
