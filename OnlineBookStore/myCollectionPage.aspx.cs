using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Diagnostics;

namespace OnlineBookStore
{
    public partial class myCollectionPage : System.Web.UI.Page
    {
        private string GetConnectionString()
        {
            return "Data Source=.\\SQLEXPRESS;Initial Catalog=dbOnlineBookStore;Integrated Security=True";
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["MemberID"] == null)
            {
                string returnUrl = HttpUtility.UrlEncode(Request.Url.PathAndQuery);
                Response.Redirect($"loginPage.aspx?returnUrl={returnUrl}");
                return;
            }

            btnLogin.Visible = false;
            btnLogout.Visible = true;

            if (!IsPostBack)
            {
                LoadCartCount();
                LoadOrders();
                LoadMyBooks();
            }
        }

        private void LoadOrders()
        {
            int memberID = (int)Session["MemberID"];
            DataTable dt = new DataTable();

            using (SqlConnection con = new SqlConnection(GetConnectionString()))
            {
                string query = "SELECT OrderID, OrderDate, TotalAmount, Status FROM OrderTable WHERE MemberID = @MemberID ORDER BY OrderDate DESC";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@MemberID", memberID);
                    using (SqlDataAdapter sda = new SqlDataAdapter(cmd))
                    {
                        sda.Fill(dt);
                    }
                }
            }
            rptOrders.DataSource = dt;
            rptOrders.DataBind();
        }

        protected void rptOrders_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                Repeater rptOrderBooks = (Repeater)e.Item.FindControl("rptOrderBooks");
                DataRowView drv = (DataRowView)e.Item.DataItem;
                int orderID = Convert.ToInt32(drv["OrderID"]);

                rptOrderBooks.DataSource = GetBooksByOrderID(orderID);
                rptOrderBooks.DataBind();
            }
        }

        // [ << แก้ไข >> ] เพิ่ม Case "CancelOrder"
        protected void rptOrders_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (Session["MemberID"] == null)
            {
                Response.Redirect("loginPage.aspx");
                return;
            }

            int orderID = Convert.ToInt32(e.CommandArgument);
            int memberID = (int)Session["MemberID"];

            if (e.CommandName == "Pay")
            {
                UpdateOrderStatus(orderID, memberID, "กำลังจัดส่ง", "รอการชำระเงิน");
            }
            else if (e.CommandName == "Received")
            {
                UpdateOrderStatus(orderID, memberID, "จัดส่งสำเร็จ", "กำลังจัดส่ง");
            }
            // [ << เพิ่ม >> ] Handle ปุ่ม CancelOrder
            else if (e.CommandName == "CancelOrder")
            {
                // อัปเดตสถานะเป็น "ถูกยกเลิก" (จาก 'กำลังจัดส่ง')
                UpdateOrderStatus(orderID, memberID, "ถูกยกเลิก", "กำลังจัดส่ง");
            }


            LoadOrders();
            LoadMyBooks(); // โหลดใหม่เผื่อมีผลกับการรีวิว (กรณีเปลี่ยนเป็น จัดส่งสำเร็จ)
        }

        // Helper Method สำหรับอัปเดตสถานะ Order (เหมือนเดิม)
        private void UpdateOrderStatus(int orderID, int memberID, string newStatus, string requiredCurrentStatus)
        {
            try
            {
                using (SqlConnection con = new SqlConnection(GetConnectionString()))
                {
                    con.Open();
                    string query = $@"UPDATE OrderTable
                                      SET Status = @NewStatus
                                      WHERE OrderID = @OrderID
                                        AND MemberID = @MemberID
                                        AND Status = @RequiredCurrentStatus";
                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@NewStatus", newStatus);
                        cmd.Parameters.AddWithValue("@OrderID", orderID);
                        cmd.Parameters.AddWithValue("@MemberID", memberID);
                        cmd.Parameters.AddWithValue("@RequiredCurrentStatus", requiredCurrentStatus);
                        int rowsAffected = cmd.ExecuteNonQuery();

                        if (rowsAffected > 0)
                        {
                            Debug.WriteLine($"Order {orderID} status updated from '{requiredCurrentStatus}' to '{newStatus}'.");
                        }
                        else
                        {
                            Debug.WriteLine($"Failed to update status for Order {orderID}. It might not be '{requiredCurrentStatus}' or belong to Member {memberID}.");
                            // คุณอาจจะเพิ่ม Label เพื่อแจ้งผู้ใช้ว่าสถานะถูกเปลี่ยนไปแล้วหรือไม่ถูกต้อง
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                Debug.WriteLine($"Error updating order status for Order {orderID}: {ex.Message}");
                // ควรแสดงข้อความ Error ให้ผู้ใช้ทราบ
            }
        }


        private DataTable GetBooksByOrderID(int orderID)
        {
            DataTable dt = new DataTable();
            using (SqlConnection con = new SqlConnection(GetConnectionString()))
            {
                string query = @"
                    SELECT b.Title, od.Quantity
                    FROM OrderDetail od
                    JOIN Book b ON od.BookID = b.BookID
                    WHERE od.OrderID = @OrderID";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@OrderID", orderID);
                    using (SqlDataAdapter sda = new SqlDataAdapter(cmd))
                    {
                        sda.Fill(dt);
                    }
                }
            }
            return dt;
        }

        // LoadMyBooks (เหมือนเดิม - ใช้สถานะ 'Completed' และ 'จัดส่งสำเร็จ')
        private void LoadMyBooks()
        {
            int memberID = (int)Session["MemberID"];
            DataTable dt = new DataTable();

            using (SqlConnection con = new SqlConnection(GetConnectionString()))
            {
                string query = @"
                    SELECT DISTINCT
                        b.BookID, b.Title, b.Edition,
                        ISNULL(c.CoverUrl, 'https://raw.githubusercontent.com/Bobbydeb/OnlineBookStore/refs/heads/master/OnlineBookStore/wwwroot/images/00_DefaultBook.jpg') AS CoverUrl,
                        bc.CategoryName,
                        (SELECT STUFF(
                            (SELECT ', ' + a.AuthorName
                             FROM Author a
                             JOIN BookAuthor ba ON a.AuthorID = ba.AuthorID
                             WHERE ba.BookID = b.BookID
                             FOR XML PATH('')),
                            1, 2, '')) AS Authors
                    FROM Book b
                    LEFT JOIN Cover c ON b.CoverID = c.CoverID
                    LEFT JOIN BookCategory bc ON b.CategoryID = bc.CategoryID
                    JOIN OrderDetail od ON b.BookID = od.BookID
                    JOIN OrderTable ot ON od.OrderID = ot.OrderID
                    WHERE ot.MemberID = @MemberID AND ot.Status IN ('Completed', 'จัดส่งสำเร็จ')";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@MemberID", memberID);
                    using (SqlDataAdapter sda = new SqlDataAdapter(cmd))
                    {
                        sda.Fill(dt);
                    }
                }
            }
            rptMyBooks.DataSource = dt;
            rptMyBooks.DataBind();
        }


        protected void rptMyBooks_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView drv = (DataRowView)e.Item.DataItem;
                int bookID = Convert.ToInt32(drv["BookID"]);
                int memberID = (int)Session["MemberID"];

                Image imgBookCover = (Image)e.Item.FindControl("imgBookCover");
                string coverUrl = drv["CoverUrl"].ToString();
                imgBookCover.ImageUrl = coverUrl;
                imgBookCover.AlternateText = drv["Title"].ToString();


                HyperLink hlReview = (HyperLink)e.Item.FindControl("hlReview");
                Label lblReviewStatus = (Label)e.Item.FindControl("lblReviewStatus");
                hlReview.NavigateUrl = $"reviewPage.aspx?BookID={bookID}";

                if (CheckIfReviewed(bookID, memberID))
                {
                    hlReview.Visible = false;
                    lblReviewStatus.Text = "คุณรีวิวหนังสือเล่มนี้แล้ว";
                    lblReviewStatus.Visible = true;
                }
                else
                {
                    hlReview.Visible = true;
                    lblReviewStatus.Visible = false;
                }

                Label lblAuthors = (Label)e.Item.FindControl("lblAuthors");
                Label lblCategory = (Label)e.Item.FindControl("lblCategory");
                Label lblEdition = (Label)e.Item.FindControl("lblEdition");

                lblAuthors.Text = (drv["Authors"] == DBNull.Value || string.IsNullOrEmpty(drv["Authors"].ToString()))
                                    ? "ไม่ระบุ"
                                    : drv["Authors"].ToString();
                lblCategory.Text = drv["CategoryName"] == DBNull.Value ? "ไม่ระบุ" : drv["CategoryName"].ToString();
                lblEdition.Text = drv["Edition"] == DBNull.Value ? "N/A" : drv["Edition"].ToString();
            }
        }

        private bool CheckIfReviewed(int bookID, int memberID)
        {
            bool reviewed = false;
            using (SqlConnection con = new SqlConnection(GetConnectionString()))
            {
                string query = "SELECT COUNT(1) FROM Review WHERE BookID = @BookID AND MemberID = @MemberID";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@BookID", bookID);
                    cmd.Parameters.AddWithValue("@MemberID", memberID);
                    con.Open();
                    int count = (int)cmd.ExecuteScalar();
                    reviewed = (count > 0);
                }
            }
            return reviewed;
        }

        // [ << แก้ไข >> ] Helper Method สำหรับเปลี่ยนสีสถานะ (เพิ่ม case "ถูกยกเลิก")
        protected string GetStatusClass(string status)
        {
            switch (status?.ToLower())
            {
                case "รอการชำระเงิน":
                    return "status-yellow";
                case "pending":
                    return "status-blue";
                case "processing":
                case "กำลังจัดส่ง":
                    return "status-blue";
                case "delivered":
                case "completed":
                case "จัดส่งสำเร็จ":
                    return "status-green";
                case "cancelled":
                case "ยกเลิก":
                case "ถูกยกเลิก": // [ << เพิ่ม >> ] ใช้สีแดง
                    return "status-red";
                default:
                    return "status-gray";
            }
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("mainpage.aspx");
        }

        // --- โค้ด Helpers สำหรับตะกร้า (เหมือนเดิม) ---
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
        // --- [จบ] โค้ดตะกร้า ---
    }
}

