using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
// [เพิ่ม] Imports ที่จำเป็น
using System.Data;
using System.Data.SqlClient;

namespace OnlineBookStore
{
    public partial class cartPage : System.Web.UI.Page
    {
        // [เพิ่ม] Connection String
        private string GetConnectionString()
        {
            return "Data Source=.\\SQLEXPRESS;Initial Catalog=dbOnlineBookStore;Integrated Security=True";
        }


        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // [เพิ่ม] ตรวจสอบการ Login
                if (Session["MemberID"] == null)
                {
                    Response.Redirect("loginPage.aspx");
                    return;
                }

                LoadCart();
                LoadCartCount(); // [เพิ่ม] โหลดจำนวนสินค้าบน Header
            }

            // [เพิ่ม] จัดการการแสดงผลปุ่ม Login/Logout (เหมือน mainpage)
            if (Session["MemberID"] != null)
            {
                btnLogin.Visible = false;
                btnLogout.Visible = true;
            }
            else
            {
                btnLogin.Visible = true;
                btnLogout.Visible = false;
            }
        }

        // [เพิ่ม] เมธอดสำหรับโหลดจำนวนสินค้าในตะกร้า (จาก mainpage.aspx.cs)
        private void LoadCartCount()
        {
            if (Session["MemberID"] != null)
            {
                int memberId = Convert.ToInt32(Session["MemberID"]);
                int cartId = GetCartId(memberId); // ใช้ GetCartId (Select-only) ที่มีอยู่แล้ว
                if (cartId > 0)
                {
                    int totalQuantity = GetTotalCartQuantity(cartId); // [เพิ่ม] Helper นี้
                    if (totalQuantity > 0)
                    {
                        cartCount.InnerText = totalQuantity.ToString();
                        cartCount.Attributes["class"] = "cart-count"; // แสดงผล
                    }
                    else
                    {
                        cartCount.InnerText = "0";
                        cartCount.Attributes["class"] = "cart-count empty"; // ซ่อน
                    }
                }
                else
                {
                    cartCount.Attributes["class"] = "cart-count empty"; // ซ่อน
                }
            }
            else
            {
                cartCount.Attributes["class"] = "cart-count empty"; // ซ่อนถ้ายังไม่ login
            }
        }

        // [เพิ่ม] Helper: ดึงจำนวนสินค้ารวมในตะกร้า (จาก mainpage.aspx.cs)
        private int GetTotalCartQuantity(int cartId)
        {
            int totalQuantity = 0;
            using (SqlConnection conn = new SqlConnection(GetConnectionString()))
            {
                conn.Open();
                string query = "SELECT SUM(Quantity) FROM CartItem WHERE CartID = @CartID";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@CartID", cartId);
                    object result = cmd.ExecuteScalar();
                    if (result != null && result != DBNull.Value)
                    {
                        totalQuantity = Convert.ToInt32(result);
                    }
                }
            }
            return totalQuantity;
        }


        // [เพิ่ม] เมธอดสำหรับโหลดข้อมูลตะกร้า
        private void LoadCart()
        {
            // ... (โค้ด LoadCart() เดิมของคุณถูกต้องแล้ว ไม่มีการเปลี่ยนแปลง) ...
            if (Session["MemberID"] == null) return;

            int memberId = Convert.ToInt32(Session["MemberID"]);
            decimal subtotal = 0;
            const decimal shippingCost = 50; // ค่าส่งคงที่

            using (SqlConnection conn = new SqlConnection(GetConnectionString()))
            {
                // [เพิ่ม] Query ดึงข้อมูลตะกร้า
                string query = @"
                    SELECT 
                        b.BookID,
                        b.Title,
                        ISNULL(cv.CoverUrl, 'https://raw.githubusercontent.com/Bobbydeb/OnlineBookStore/refs/heads/master/OnlineBookStore/wwwroot/images/00_DefaultBook.jpg') AS CoverUrl,
                        b.Price,
                        ci.Quantity,
                        (b.Price * ci.Quantity) AS TotalPrice
                    FROM CartItem ci
                    JOIN Cart c ON ci.CartID = c.CartID
                    JOIN Book b ON ci.BookID = b.BookID
                    LEFT JOIN Cover cv ON b.CoverID = cv.CoverID
                    WHERE c.MemberID = @MemberID";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@MemberID", memberId);
                    conn.Open();

                    DataTable dt = new DataTable();
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.Fill(dt);

                    if (dt.Rows.Count > 0)
                    {
                        // มีสินค้าในตะกร้า
                        pnlCart.Visible = true;
                        pnlEmptyCart.Visible = false;

                        RepeaterCart.DataSource = dt;
                        RepeaterCart.DataBind();

                        // [เพิ่ม] คำนวณราคารวม
                        foreach (DataRow row in dt.Rows)
                        {
                            subtotal += Convert.ToDecimal(row["TotalPrice"]);
                        }

                        ltlSubtotal.Text = $"฿{subtotal:N2}";
                        ltlShipping.Text = $"฿{shippingCost:N2}";
                        ltlTotal.Text = $"฿{subtotal + shippingCost:N2}";
                    }
                    else
                    {
                        // ไม่มีสินค้าในตะกร้า
                        pnlCart.Visible = false;
                        pnlEmptyCart.Visible = true;
                    }
                }
            }
        }

        // [เพิ่ม] Event Handler สำหรับปุ่มใน Repeater
        protected void RepeaterCart_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (Session["MemberID"] == null)
            {
                Response.Redirect("loginPage.aspx");
                return;
            }

            int memberId = Convert.ToInt32(Session["MemberID"]);
            int bookId = Convert.ToInt32(e.CommandArgument);

            // หา CartID ของ user
            int cartId = GetCartId(memberId);
            if (cartId == 0) return; // ไม่ควรเกิดขึ้นถ้า user มีของในตะกร้า

            if (e.CommandName == "Remove")
            {
                // ลบสินค้าออกจาก CartItem
                RemoveFromCart(cartId, bookId);
            }
            else if (e.CommandName == "Update")
            {
                // อัปเดตจำนวนสินค้า
                TextBox txtQuantity = (TextBox)e.Item.FindControl("txtQuantity");
                int newQuantity;
                if (int.TryParse(txtQuantity.Text, out newQuantity) && newQuantity > 0)
                {
                    UpdateCartItem(cartId, bookId, newQuantity);
                }
                else if (newQuantity <= 0)
                {
                    // ถ้าใส่ 0 หรือน้อยกว่า ให้ลบ
                    RemoveFromCart(cartId, bookId);
                }
            }

            // โหลดข้อมูลตะกร้าใหม่
            LoadCart();
            // [เพิ่ม] อัปเดตตัวเลขบน Header ด้วย
            LoadCartCount();
        }

        // [เพิ่ม] Helper: หา CartID
        private int GetCartId(int memberId)
        {
            int cartId = 0;
            using (SqlConnection conn = new SqlConnection(GetConnectionString()))
            {
                conn.Open();
                string query = "SELECT CartID FROM Cart WHERE MemberID = @MemberID";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@MemberID", memberId);
                    object result = cmd.ExecuteScalar();
                    if (result != null && result != DBNull.Value)
                    {
                        cartId = Convert.ToInt32(result);
                    }
                }
            }
            return cartId;
        }

        // [เพิ่ม] Helper: ลบสินค้า
        private void RemoveFromCart(int cartId, int bookId)
        {
            using (SqlConnection conn = new SqlConnection(GetConnectionString()))
            {
                conn.Open();
                string query = "DELETE FROM CartItem WHERE CartID = @CartID AND BookID = @BookID";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@CartID", cartId);
                    cmd.Parameters.AddWithValue("@BookID", bookId);
                    cmd.ExecuteNonQuery();
                }
            }
        }

        // [เพิ่ม] Helper: อัปเดตจำนวน
        private void UpdateCartItem(int cartId, int bookId, int quantity)
        {
            using (SqlConnection conn = new SqlConnection(GetConnectionString()))
            {
                conn.Open();
                string query = "UPDATE CartItem SET Quantity = @Quantity WHERE CartID = @CartID AND BookID = @BookID";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@Quantity", quantity);
                    cmd.Parameters.AddWithValue("@CartID", cartId);
                    cmd.Parameters.AddWithValue("@BookID", bookId);
                    cmd.ExecuteNonQuery();
                }
            }
        }

        // --- [เพิ่ม] Event Handlers สำหรับ Header (จาก mainpage.aspx.cs) ---

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Response.Redirect("mainpage.aspx");
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            string query = txtSearch.Text.Trim();
            if (!string.IsNullOrEmpty(query))
            {
                Response.Redirect($"searchResultPage.aspx?query={Server.UrlEncode(query)}");
            }
        }
    }
}

