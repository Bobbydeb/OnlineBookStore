<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="MonthlySales.aspx.cs" Inherits="OnlineBookStore.MonthlySales" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Monthly Sales Report</title>
</head>
<body>
    <form id="form1" runat="server">
        <div style="width:80%; margin:auto; text-align:center;">
            <h2>ยอดขายรายเดือน (Monthly Sales)</h2>
            <asp:GridView ID="GridView1" runat="server" 
                AutoGenerateColumns="true" 
                BorderColor="Gray" 
                BorderWidth="1px"
                CellPadding="6"
                GridLines="Both"
                Font-Names="Segoe UI" 
                Font-Size="Medium">
            </asp:GridView>
        </div>
    </form>
</body>
</html>
