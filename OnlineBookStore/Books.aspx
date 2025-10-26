<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Books.aspx.cs" Inherits="OnlineBookStoreWebForm.Books" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Books | Online Bookstore</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
</head>
<body class="bg-light">
    <form id="form1" runat="server">
        
        <asp:ScriptManager ID="ScriptManager1" runat="server" />
        <nav class="navbar navbar-expand-lg bg-white border-bottom">
            <div class="container">
                <a class="navbar-brand fw-bold" href="#">OnlineBookStore</a>
            </div>
        </nav>

        <div class="container py-4">
            <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="true"></asp:GridView>
            <div class="card shadow-sm">
                <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                    <ContentTemplate>
                        <div class="card-body">
                            <div class="row g-2 align-items-center mb-3">
                                <div class="col-md-6">
                                    <div class="input-group">
                                        <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control" placeholder="Search by title or ISBN" />
                                        <asp:Button ID="btnSearch" runat="server" Text="Search" CssClass="btn btn-outline-secondary" OnClick="btnSearch_Click" UseSubmitBehavior="false" />
                                    </div>
                                </div>
                                <div class="col-md-3">
                                    <asp:DropDownList ID="ddlCategory" runat="server" CssClass="form-select" AutoPostBack="true" OnSelectedIndexChanged="ddlCategory_SelectedIndexChanged" />
                                </div>
                                <div class="col-md-3 text-md-end">
                                    <asp:DropDownList ID="ddlPageSize" runat="server" CssClass="form-select w-auto d-inline" AutoPostBack="true" OnSelectedIndexChanged="ddlPageSize_SelectedIndexChanged">
                                        <asp:ListItem Text="12 / page" Value="12" Selected="True" />
                                        <asp:ListItem Text="24 / page" Value="24" />
                                        <asp:ListItem Text="48 / page" Value="48" />
                                    </asp:DropDownList>
                                </div>
                            </div>

                            <div class="d-flex justify-content-between align-items-center mb-2">
                                <h5 class="mb-0">Books</h5>
                                <asp:Label ID="lblCount" runat="server" CssClass="text-muted small" />
                            </div>

                            <asp:GridView ID="GridViewBooks" runat="server"
                                CssClass="table table-hover align-middle"
                                HeaderStyle-CssClass="table-light"
                                AutoGenerateColumns="False"
                                AllowPaging="True" AllowSorting="True"
                                PageSize="12"
                                DataKeyNames="BookID"
                                GridLines="None"
                                OnPageIndexChanging="GridViewBooks_PageIndexChanging"
                                OnSorting="GridViewBooks_Sorting"
                                OnRowDataBound="GridViewBooks_RowDataBound"
                                PagerSettings-Mode="NumericFirstLast"
                                PagerSettings-FirstPageText="First"
                                PagerSettings-LastPageText="Last">
                                <Columns>
                                    <asp:BoundField DataField="BookID" HeaderText="ID" SortExpression="BookID" ItemStyle-CssClass="text-muted" />
                                    <asp:TemplateField HeaderText="Title" SortExpression="Title">
                                        <ItemTemplate>
                                            <div class="fw-semibold"><%# Eval("Title") %></div>
                                            <div class="small text-muted">Category: <%# Eval("CategoryName") %></div>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:BoundField DataField="Price" HeaderText="Price" SortExpression="Price" DataFormatString="{0:C}" HtmlEncode="False">
                                        <ItemStyle CssClass="fw-semibold text-nowrap" />
                                    </asp:BoundField>
                                    <asp:TemplateField HeaderText="Stock" SortExpression="Stock">
                                        <ItemTemplate>
                                            <span runat="server" id="stockBadge" class="badge"></span>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField>
                                        <ItemTemplate>
                                            <a class="btn btn-sm btn-primary" href='<%# "BookDetails.aspx?id=" + Eval("BookID") %>'>Details</a>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                                <EmptyDataTemplate>
                                    <div class="text-center py-5">
                                        <h6 class="mb-1">No books found</h6>
                                        <p class="text-muted mb-0">Try a different search or category.</p>
                                    </div>
                                </EmptyDataTemplate>
                            </asp:GridView>
                        </div>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    </form>
</body>
</html>
