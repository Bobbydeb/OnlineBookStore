<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="MonthlySales.aspx.cs" Inherits="OnlineBookStore.MonthlySales" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Monthly Sales Report</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
</head>
<body class="bg-light">
    <form id="form1" runat="server">
        <div class="container py-5">
            <div class="card shadow-sm">
                <div class="card-header bg-primary text-white text-center">
                    <h3>📊 รายงานยอดขายรายเดือน (Monthly Sales)</h3>
                </div>
                <div class="card-body">
                    <asp:GridView ID="GridView1" runat="server"
                        AutoGenerateColumns="true"
                        CssClass="table table-bordered table-hover text-center align-middle"
                        Font-Names="Segoe UI"
                        Font-Size="Medium">
                    </asp:GridView>
                </div>
            </div>
        </div>
    </form>
</body>
</html>
