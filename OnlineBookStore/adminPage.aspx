<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="adminPage.aspx.cs" Inherits="OnlineBookStore.adminPage" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Admin Page</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet" />
    
    <style>
        /* Optional: Ensure the GridView header looks good with Bootstrap */
        .table-primary th {
            color: #fff;
            background-color: #0d6efd;
            border-color: #0d6efd;
        }

        /*
         * STYLES FOR BOOTSTRAP GRIDVIEW PAGER
        */
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
            color: #0d6efd;
            background-color: #fff;
            border: 1px solid #dee2e6;
            text-decoration: none;
            transition: color .15s ease-in-out,background-color .15s ease-in-out,border-color .15s ease-in-out,box-shadow .15s ease-in-out;
        }
        
        .gridview-pagination span {
            z-index: 3;
            color: #fff;
            background-color: #0d6efd;
            border-color: #0d6efd;
            cursor: default;
        }
        
        .gridview-pagination a:hover {
            z-index: 2;
            color: #0a58ca;
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

        /*
         * NEW STYLE TO FIX COLUMN WIDTHS
         * table-layout: fixed; forces the table to respect header widths
         * instead of resizing based on content.
        */
        .table-fixed {
            table-layout: fixed;
            width: 100%;
        }

        /* * Optional: Handle long text in fixed cells 
         * This will cut off long text with an ellipsis (...)
        */
        .table-fixed td, 
        .table-fixed th {
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }

    </style>
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark sticky-top">
        <div class="container-fluid">
            <a class="navbar-brand" href="#"><i class="bi bi-shield-lock-fill"></i> Admin Panel</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#adminNavbar" aria-controls="adminNavbar" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="adminNavbar">
                <ul class="navbar-nav ms-auto mb-2 mb-lg-0">
                    <li class="nav-item">
                        <a class="nav-link" href="#">Storefront</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#">Logout</a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <form id="form1" runat="server">
        <!-- ADDED: ScriptManager is required for UpdatePanels to work -->
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>

        <!-- ADDED: Hidden field to store the active tab's ID -->
        <asp:HiddenField ID="hdnActiveTab" runat="server" ClientIDMode="Static" />

        <div class="container mt-4 mb-4">
            
            <h2 class="mb-3"><i class="bi bi-gear-wide-connected"></i> Admin Management</h2>

            <ul class="nav nav-tabs" id="adminTabs" role="tablist">
                <li class="nav-item" role="presentation">
                    <a class="nav-link active" id="books-tab" data-bs-toggle="tab" href="#books" role="tab" aria-controls="books" aria-selected="true"><i class="bi bi-book"></i> หนังสือ</a>
                </li>
                <li class="nav-item" role="presentation">
                    <a class="nav-link" id="authors-tab" data-bs-toggle="tab" href="#authors" role="tab" aria-controls="authors" aria-selected="false"><i class="bi bi-person"></i> ผู้แต่ง</a>
                </li>
                <li class="nav-item" role="presentation">
                    <a class="nav-link" id="publishers-tab" data-bs-toggle="tab" href="#publishers" role="tab" aria-controls="publishers" aria-selected="false"><i class="bi bi-building"></i> สำนักพิมพ์</a>
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

                <!-- Books Tab -->
                <div class="tab-pane fade show active" id="books" role="tabpanel" aria-labelledby="books-tab">
                    <!-- ADDED: UpdatePanel wraps the tab content -->
                    <asp:UpdatePanel ID="UpdatePanelBooks" runat="server" UpdateMode="Conditional">
                        <ContentTemplate>
                            <div class="card shadow-sm">
                                <div class="card-header bg-light">
                                    <h4 class="mb-0">จัดการหนังสือ</h4>
                                </div>
                                <div class="card-body">
                                    <div class="d-flex justify-content-end mb-3">
                                        <asp:Button ID="btnAddBook" runat="server" Text="เพิ่มหนังสือใหม่" CssClass="btn btn-primary btn-sm" />
                                    </div>
                                    
                                    <div class="table-responsive">
                                        <asp:GridView ID="GridViewBooks" runat="server"
                                            CssClass="table table-striped table-hover table-bordered table-fixed"
                                            HeaderStyle-CssClass="table-primary"
                                            AutoGenerateColumns="true"
                                            AllowPaging="true"
                                            PageSize="25"
                                            PagerSettings-Position="TopAndBottom"
                                            PagerSettings-Mode="NumericFirstLast"
                                            OnPageIndexChanging="GridViewBooks_PageIndexChanging"
                                            PagerStyle-CssClass="gridview-pagination"
                                            PagerSettings-FirstPageText="&laquo;"
                                            PagerSettings-PreviousPageText="&lsaquo;"
                                            PagerSettings-NextPageText="&rsaquo;"
                                            PagerSettings-LastPageText="&raquo;"
                                            PagerSettings-PageButtonCount="5">
                                        </asp:GridView>
                                    </div>
                                </div>
                            </div>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </div>

                <!-- Authors Tab -->
                <div class="tab-pane fade" id="authors" role="tabpanel" aria-labelledby="authors-tab">
                    <!-- ADDED: UpdatePanel wraps the tab content -->
                    <asp:UpdatePanel ID="UpdatePanelAuthors" runat="server" UpdateMode="Conditional">
                        <ContentTemplate>
                            <div class="card shadow-sm">
                                <div class="card-header bg-light">
                                    <h4 class="mb-0">จัดการผู้แต่ง</h4>
                                </div>
                                <div class="card-body">
                                    <div class="d-flex justify-content-end mb-3">
                                        <asp:Button ID="btnAddAuthor" runat="server" Text="เพิ่มผู้แต่งใหม่" CssClass="btn btn-primary btn-sm" />
                                    </div>
                                    <div class="table-responsive">
                                        <asp:GridView ID="GridViewAuthors" runat="server"
                                            CssClass="table table-striped table-hover table-bordered table-fixed"
                                            HeaderStyle-CssClass="table-primary"
                                            AutoGenerateColumns="true"
                                            AllowPaging="true"
                                            PageSize="25"
                                            PagerSettings-Position="TopAndBottom"
                                            PagerSettings-Mode="NumericFirstLast"
                                            OnPageIndexChanging="GridViewAuthors_PageIndexChanging"
                                            PagerStyle-CssClass="gridview-pagination"
                                            PagerSettings-FirstPageText="&laquo;"
                                            PagerSettings-PreviousPageText="&lsaquo;"
                                            PagerSettings-NextPageText="&rsaquo;"
                                            PagerSettings-LastPageText="&raquo;"
                                            PagerSettings-PageButtonCount="5">
                                        </asp:GridView>
                                    </div>
                                </div>
                            </div>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </div>

                <!-- Publishers Tab -->
                <div class="tab-pane fade" id="publishers" role="tabpanel" aria-labelledby="publishers-tab">
                    <!-- ADDED: UpdatePanel wraps the tab content -->
                    <asp:UpdatePanel ID="UpdatePanelPublishers" runat="server" UpdateMode="Conditional">
                        <ContentTemplate>
                            <div class="card shadow-sm">
                                <div class="card-header bg-light">
                                    <h4 class="mb-0">จัดการสำนักพิมพ์</h4>
                                </div>
                                <div class="card-body">
                                    <div class="d-flex justify-content-end mb-3">
                                        <asp:Button ID="btnAddPublisher" runat="server" Text="เพิ่มสำนักพิมพ์ใหม่" CssClass="btn btn-primary btn-sm" />
                                    </div>
                                    <div class="table-responsive">
                                        <asp:GridView ID="GridViewPublishers" runat="server"
                                            CssClass="table table-striped table-hover table-bordered table-fixed"
                                            HeaderStyle-CssClass="table-primary"
                                            AutoGenerateColumns="true"
                                            AllowPaging="true"
                                            PageSize="25"
                                            PagerSettings-Position="TopAndBottom"
                                            PagerSettings-Mode="NumericFirstLast"
                                            OnPageIndexChanging="GridViewPublishers_PageIndexChanging"
                                            PagerStyle-CssClass="gridview-pagination"
                                            PagerSettings-FirstPageText="&laquo;"
                                            PagerSettings-PreviousPageText="&lsaquo;"
                                            PagerSettings-NextPageText="&rsaquo;"
                                            PagerSettings-LastPageText="&raquo;"
                                            PagerSettings-PageButtonCount="5">
                                        </asp:GridView>
                                    </div>
                                </div>
                            </div>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </div>

                <!-- Members Tab -->
                <div class="tab-pane fade" id="members" role="tabpanel" aria-labelledby="members-tab">
                    <!-- ADDED: UpdatePanel wraps the tab content -->
                    <asp:UpdatePanel ID="UpdatePanelMembers" runat="server" UpdateMode="Conditional">
                        <ContentTemplate>
                            <div class="card shadow-sm">
                                <div class="card-header bg-light">
                                    <h4 class="mb-0">จัดการสมาชิก</h4>
                                </div>
                                <div class="card-body">
                                    <div class="table-responsive">
                                        <asp:GridView ID="GridViewMembers" runat="server"
                                            CssClass="table table-striped table-hover table-bordered table-fixed"
                                            HeaderStyle-CssClass="table-primary"
                                            AutoGenerateColumns="true"
                                            AllowPaging="true"
                                            PageSize="25"
                                            PagerSettings-Position="TopAndBottom"
                                            PagerSettings-Mode="NumericFirstLast"
                                            OnPageIndexChanging="GridViewMembers_PageIndexChanging"
                                            PagerStyle-CssClass="gridview-pagination"
                                            PagerSettings-FirstPageText="&laquo;"
                                            PagerSettings-PreviousPageText="&lsaquo;"
                                            PagerSettings-NextPageText="&rsaquo;"
                                            PagerSettings-LastPageText="&raquo;"
                                            PagerSettings-PageButtonCount="5">
                                        </asp:GridView>
                                    </div>
                                </div>
                            </div>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </div>

                <!-- Orders Tab -->
                <div class="tab-pane fade" id="orders" role="tabpanel" aria-labelledby="orders-tab">
                    <!-- ADDED: UpdatePanel wraps the tab content -->
                    <asp:UpdatePanel ID="UpdatePanelOrders" runat="server" UpdateMode="Conditional">
                        <ContentTemplate>
                            <div class="card shadow-sm">
                                <div class="card-header bg-light">
                                    <h4 class="mb-0">จัดการคำสั่งซื้อ</h4>
                                </div>
                                <div class="card-body">
                                    <div class="table-responsive">
                                        <asp:GridView ID="GridViewOrders" runat="server"
                                            CssClass="table table-striped table-hover table-bordered table-fixed"
                                            HeaderStyle-CssClass="table-primary"
                                            AutoGenerateColumns="true"
                                            AllowPaging="true"
                                            PageSize="25"
                                            PagerSettings-Position="TopAndBottom"
                                            PagerSettings-Mode="NumericFirstLast"
                                            OnPageIndexChanging="GridViewOrders_PageIndexChanging"
                                            PagerStyle-CssClass="gridview-pagination"
                                            PagerSettings-FirstPageText="&laquo;"
                                            PagerSettings-PreviousPageText="&lsaquo;"
                                            PagerSettings-NextPageText="&rsaquo;"
                                            PagerSettings-LastPageText="&raquo;"
                                            PagerSettings-PageButtonCount="5">
                                        </asp:GridView>
                                    </div>
                                </div>
                            </div>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </div>

                <!-- Reviews Tab -->
                <div class="tab-pane fade" id="reviews" role="tabpanel" aria-labelledby="reviews-tab">
                    <!-- ADDED: UpdatePanel wraps the tab content -->
                    <asp:UpdatePanel ID="UpdatePanelReviews" runat="server" UpdateMode="Conditional">
                        <ContentTemplate>
                            <div class="card shadow-sm">
                                <div class="card-header bg-light">
                                    <h4 class="mb-0">จัดการรีวิว</h4>
                                </div>
                                <div class="card-body">
                                    <div class="table-responsive">
                                        <asp:GridView ID="GridViewReviews" runat="server"
                                            CssClass="table table-striped table-hover table-bordered table-fixed"
                                            HeaderStyle-CssClass="table-primary"
                                            AutoGenerateColumns="true"
                                            AllowPaging="true"
                                            PageSize="25"
                                            PagerSettings-Position="TopAndBottom"
                                            PagerSettings-Mode="NumericFirstLast"
                                            OnPageIndexChanging="GridViewReviews_PageIndexChanging"
                                            PagerStyle-CssClass="gridview-pagination"
                                            PagerSettings-FirstPageText="&laquo;"
                                            PagerSettings-PreviousPageText="&lsaquo;"
                                            PagerSettings-NextPageText="&rsaquo;"
                                            PagerSettings-LastPageText="&raquo;"
                                            PagerSettings-PageButtonCount="5">
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
    
    <footer class="bg-light text-center text-muted p-3 mt-auto">
        &copy; <%= DateTime.Now.Year %> Admin Panel
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <!-- ADDED: Script to preserve active tab on postback -->
    <script type="text/javascript">
        document.addEventListener("DOMContentLoaded", function () {
            var activeTabField = document.getElementById('hdnActiveTab');
            var adminTabs = document.getElementById('adminTabs');

            // 1. Save the active tab's href when it's shown
            if (adminTabs) {
                var tabLinks = adminTabs.querySelectorAll('a[data-bs-toggle="tab"]');
                tabLinks.forEach(function (tabLink) {
                    // Use 'shown.bs.tab' to save the ID *after* the tab is visible
                    tabLink.addEventListener('shown.bs.tab', function (event) {
                        if (activeTabField) {
                            activeTabField.value = event.target.getAttribute('href');
                        }
                    });
                });
            }

            // 2. On page load (including postbacks), restore the active tab
            if (activeTabField && activeTabField.value) {
                var tabToActivate = document.querySelector('a[href="' + activeTabField.value + '"]');
                if (tabToActivate) {
                    // Use Bootstrap's own method to correctly show the tab
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
        // This is crucial because the UpdatePanel might re-create the tab content
        var prm = Sys.WebForms.PageRequestManager.getInstance();
        if (prm) {
            prm.add_endRequest(function (sender, args) {
                // After an async postback, re-apply the logic to save the active tab
                var activeTabField = document.getElementById('hdnActiveTab');
                var adminTabs = document.getElementById('adminTabs');

                if (adminTabs) {
                    var tabLinks = adminTabs.querySelectorAll('a[data-bs-toggle="tab"]');
                    tabLinks.forEach(function (tabLink) {
                        // Re-bind the 'shown.bs.tab' event
                        // Note: This might add duplicate listeners if not careful,
                        // but for this simple case it's generally fine.
                        // A more robust solution would check if listener exists.
                        tabLink.addEventListener('shown.bs.tab', function (event) {
                            if (activeTabField) {
                                activeTabField.value = event.target.getAttribute('href');
                            }
                        });
                    });
                }

                // Also, ensure the correct tab is still visually active
                if (activeTabField && activeTabField.value) {
                    var tabToActivate = document.querySelector('a[href="' + activeTabField.value + '"]');
                    if (tabToActivate) {
                        // We don't call tabInstance.show() here again,
                        // as that would be disruptive. We just ensure the
                        // save-on-click logic is re-attached.
                        // The tab *should* already be active from the previous JS.
                    }
                }
            });
        }
    </script>
</body>
</html>

