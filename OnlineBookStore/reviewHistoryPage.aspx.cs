using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
// [เพิ่ม] Imports
using System.Diagnostics;


namespace OnlineBookStore
{
    public partial class reviewHistoryPage : System.Web.UI.Page
    {
        // [แก้ไข] เปลี่ยนเป็น private instance method
        private string GetConnectionString()
        {
            return "Data Source=.\\SQLEXPRESS;Initial Catalog=dbOnlineBookStore;Integrated Security=True";
        }


        protected void Page_Load(object sender, EventArgs e)
        {
            // 1. ตรวจสอบ Login
            if (Session["MemberID"] == null)
            {
                // [แก้ไข] Redirect พร้อม returnUrl
                string returnUrl = HttpUtility.UrlEncode(Request.Url.PathAndQuery);
                Response.Redirect($"loginPage.aspx?returnUrl={returnUrl}");
                return;
            }

            btnLogin.Visible = false;
            btnLogout.Visible = true;

            if (!IsPostBack)
            {
                // [เพิ่ม] โหลดจำนวนตะกร้า
                LoadCartCount();
                LoadMyReviews();
            }
        }

        private void LoadMyReviews()
        {
            int memberID = (int)Session["MemberID"];
            DataTable dt = new DataTable();

            using (SqlConnection con = new SqlConnection(GetConnectionString())) // [แก้ไข]
            {
                // Query เหมือนเดิม แต่เพิ่ม ISNULL ให้ CoverUrl
                string query = @"
                    SELECT
                        r.Rating,
                        r.Comment,
                        r.ReviewDate,
                        b.Title,
                        b.Edition,
                        bc.CategoryName,
                        ISNULL(c.CoverUrl, 'https://raw.githubusercontent.com/Bobbydeb/OnlineBookStore/refs/heads/master/OnlineBookStore/wwwroot/images/00_DefaultBook.jpg') AS CoverUrl,
                        (SELECT STUFF(
                            (SELECT ', ' + a.AuthorName
                             FROM Author a
                             JOIN BookAuthor ba ON a.AuthorID = ba.AuthorID
                             WHERE ba.BookID = b.BookID
                             FOR XML PATH('')),
                            1, 2, '')) AS Authors
                    FROM Review r
                    JOIN Book b ON r.BookID = b.BookID
                    LEFT JOIN Cover c ON b.CoverID = c.CoverID
                    LEFT JOIN BookCategory bc ON b.CategoryID = bc.CategoryID
                    WHERE r.MemberID = @MemberID
                    ORDER BY r.ReviewDate DESC";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@MemberID", memberID);
                    using (SqlDataAdapter sda = new SqlDataAdapter(cmd))
                    {
                        sda.Fill(dt);
                    }
                }
            }
            rptMyReviews.DataSource = dt;
            rptMyReviews.DataBind();
        }

        protected void rptMyReviews_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView drv = (DataRowView)e.Item.DataItem;
                Image imgBookCover = (Image)e.Item.FindControl("imgBookCover");
                string coverUrl = drv["CoverUrl"].ToString(); // ไม่ต้องเช็ค DBNull เพราะ Query จัดการแล้ว
                imgBookCover.ImageUrl = coverUrl;
                imgBookCover.AlternateText = drv["Title"].ToString();
            }
        }


        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon(); // [แก้ไข] ใช้ Abandon
            Response.Redirect("mainpage.aspx");
        }

        // --- [เพิ่ม] โค้ด Helpers สำหรับตะกร้า (เหมือนหน้า myCollectionPage) ---
        private int GetCartId(int memberId)
        {
            int cartId = 0;
            try
            {
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
            }
            catch (Exception ex) { Debug.WriteLine($"Error in GetCartId: {ex.Message}"); }
            return cartId;
        }

        private int GetTotalCartQuantity(int cartId)
        {
            int totalQuantity = 0;
            try
            {
                using (SqlConnection conn = new SqlConnection(GetConnectionString()))
                {
                    conn.Open();
                    string query = "SELECT SUM(ISNULL(Quantity, 0)) FROM CartItem WHERE CartID = @CartID";
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
            }
            catch (Exception ex) { Debug.WriteLine($"Error in GetTotalCartQuantity: {ex.Message}"); }
            return totalQuantity;
        }

        private void LoadCartCount()
        {
            if (Session["MemberID"] != null)
            {
                int memberId = Convert.ToInt32(Session["MemberID"]);
                int cartId = GetCartId(memberId);
                if (cartId > 0)
                {
                    int totalQuantity = GetTotalCartQuantity(cartId);
                    if (totalQuantity > 0)
                    {
                        cartCount.InnerText = totalQuantity.ToString();
                        cartCount.Attributes["class"] = "cart-count";
                    }
                    else
                    {
                        cartCount.InnerText = "0";
                        cartCount.Attributes["class"] = "cart-count empty";
                    }
                }
                else
                {
                    cartCount.InnerText = "0";
                    cartCount.Attributes["class"] = "cart-count empty";
                }
            }
            else
            {
                cartCount.InnerText = "0";
                cartCount.Attributes["class"] = "cart-count empty";
            }
        }
        // --- [จบ] โค้ดที่เพิ่ม ---
    }
}
