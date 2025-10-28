using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;

namespace OnlineBookStore
{
    public partial class myCollectionPage : System.Web.UI.Page
    {
        // ใช้ Connection String ที่มีอยู่
        private readonly string connStr =
            "Data Source=.\\SQLEXPRESS;Initial Catalog=dbOnlineBookStore;Integrated Security=True";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["MemberID"] == null)
            {
                Response.Write("<script>alert('กรุณาทำการ login ก่อนเข้าใช้หน้านี้');window.location='loginPage.aspx';</script>");
                return;
            }

            // ถ้า login แล้ว สลับปุ่ม
            btnLogin.Visible = false;
            btnLogout.Visible = true;

            if (!IsPostBack)
            {
                LoadOrders();
                LoadMyBooks();
            }
        }

        /// <summary>
        /// โหลดประวัติการสั่งซื้อทั้งหมดของ Member ที่ Login อยู่
        /// </summary>
        private void LoadOrders()
        {
            int memberID = (int)Session["MemberID"];
            DataTable dt = new DataTable();

            using (SqlConnection con = new SqlConnection(connStr))
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

        /// <summary>
        /// Event นี้ทำงานเมื่อแต่ละรายการใน rptOrders ถูกสร้างขึ้น
        /// ใช้สำหรับโหลดรายการหนังสือ (nested repeater) ในแต่ละคำสั่งซื้อ
        /// </summary>
        protected void rptOrders_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                // ค้นหา Repeater ภายใน (nested)
                Repeater rptOrderBooks = (Repeater)e.Item.FindControl("rptOrderBooks");

                // ดึง OrderID จากรายการหลัก
                DataRowView drv = (DataRowView)e.Item.DataItem;
                int orderID = Convert.ToInt32(drv["OrderID"]);

                // โหลดหนังสือสำหรับ OrderID นี้
                rptOrderBooks.DataSource = GetBooksByOrderID(orderID);
                rptOrderBooks.DataBind();
            }
        }

        /// <summary>
        /// ดึงข้อมูลหนังสือตาม OrderID
        /// </summary>
        private DataTable GetBooksByOrderID(int orderID)
        {
            DataTable dt = new DataTable();
            using (SqlConnection con = new SqlConnection(connStr))
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

        /// <summary>
        /// โหลดเฉพาะหนังสือที่ Member เป็นเจ้าของ (จาก Order ที่มีสถานะ 'Completed')
        /// </summary>
        private void LoadMyBooks()
        {
            int memberID = (int)Session["MemberID"];
            DataTable dt = new DataTable();

            using (SqlConnection con = new SqlConnection(connStr))
            {
                // [แก้ไข] เพิ่มการดึง Edition, CategoryName, และ Authors
                string query = @"
                    SELECT DISTINCT 
                        b.BookID, b.Title, b.Edition, 
                        c.CoverUrl, 
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
                    WHERE ot.MemberID = @MemberID AND ot.Status = 'Completed'";

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

        /// <summary>
        /// Event นี้ทำงานเมื่อแต่ละรายการใน rptMyBooks ถูกสร้างขึ้น
        /// ใช้สำหรับตั้งค่าลิงก์รีวิวและตรวจสอบสถานะการรีวิว
        /// </summary>
        protected void rptMyBooks_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView drv = (DataRowView)e.Item.DataItem;
                int bookID = Convert.ToInt32(drv["BookID"]);
                int memberID = (int)Session["MemberID"];

                // ตั้งค่ารูปปก
                Image imgBookCover = (Image)e.Item.FindControl("imgBookCover");
                string coverUrl = drv["CoverUrl"] != DBNull.Value ? drv["CoverUrl"].ToString() : "https://raw.githubusercontent.com/Bobbydeb/OnlineBookStore/refs/heads/master/OnlineBookStore/wwwroot/images/00_DefaultBook.jpg";
                imgBookCover.ImageUrl = coverUrl;
                imgBookCover.AlternateText = drv["Title"].ToString();


                HyperLink hlReview = (HyperLink)e.Item.FindControl("hlReview");
                Label lblReviewStatus = (Label)e.Item.FindControl("lblReviewStatus");

                // ตั้งค่าลิงก์ไปยังหน้า review
                hlReview.NavigateUrl = $"reviewPage.aspx?BookID={bookID}";

                // ตรวจสอบว่าเคยรีวิวหรือยัง
                if (CheckIfReviewed(bookID, memberID))
                {
                    hlReview.Visible = false; // ซ่อนปุ่มเขียนรีวิว
                    lblReviewStatus.Text = "คุณรีวิวหนังสือเล่มนี้แล้ว";
                    lblReviewStatus.Visible = true;
                }
                else
                {
                    hlReview.Visible = true; // แสดงปุ่มเขียนรีวิว
                    lblReviewStatus.Visible = false;
                }

                // [เพิ่ม] Find Controls for new labels
                Label lblAuthors = (Label)e.Item.FindControl("lblAuthors");
                Label lblCategory = (Label)e.Item.FindControl("lblCategory");
                Label lblEdition = (Label)e.Item.FindControl("lblEdition");

                // [เพิ่ม] Set text for new labels, handling nulls
                lblAuthors.Text = (drv["Authors"] == DBNull.Value || string.IsNullOrEmpty(drv["Authors"].ToString()))
                                    ? "ไม่ระบุ"
                                    : drv["Authors"].ToString();
                lblCategory.Text = drv["CategoryName"] == DBNull.Value ? "ไม่ระบุ" : drv["CategoryName"].ToString();
                lblEdition.Text = drv["Edition"] == DBNull.Value ? "N/A" : drv["Edition"].ToString();
            }
        }

        /// <summary>
        /// ตรวจสอบว่า Member เคยรีวิวหนังสือเล่มนี้หรือยัง
        /// </summary>
        private bool CheckIfReviewed(int bookID, int memberID)
        {
            bool reviewed = false;
            using (SqlConnection con = new SqlConnection(connStr))
            {
                string query = "SELECT COUNT(1) FROM Review WHERE BookID = @BookID AND MemberID = @MemberID";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@BookID", bookID);
                    cmd.Parameters.AddWithValue("@MemberID", memberID);
                    con.Open();
                    int count = (int)cmd.ExecuteScalar();
                    if (count > 0)
                    {
                        reviewed = true;
                    }
                    con.Close();
                }
            }
            return reviewed;
        }

        /// <summary>
        /// Helper Method สำหรับเปลี่ยนสีของสถานะคำสั่งซื้อ
        /// </summary>
        protected string GetStatusClass(string status)
        {
            // [แก้ไข] เปลี่ยน return value ให้ตรงกับ CSS Class ใน .aspx
            switch (status.ToLower())
            {
                case "pending":
                case "รอดำเนินการ":
                    return "status-yellow";
                case "processing":
                case "กำลังเตรียมจัดส่ง":
                    return "status-blue";
                case "delivered":
                case "จัดส่งแล้ว":
                case "completed": // [แก้ไข] เพิ่ม case 'completed'
                    return "status-green";
                case "cancelled":
                case "ยกเลิก":
                    return "status-red";
                default:
                    return "status-gray";
            }
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Response.Redirect("mainpage.aspx");
        }
    }
}

