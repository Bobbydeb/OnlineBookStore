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
            // ถ้ายังไม่ได้ login ให้กลับไปหน้า login
            if (Session["MemberID"] == null)
            {
                // ใช้ Response.Redirect แทน Response.Write + script เพื่อความปลอดภัยและเสถียรภาพ
                Response.Redirect("loginPage.aspx");
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
        /// โหลดเฉพาะหนังสือที่ Member เป็นเจ้าของ (จาก Order ที่มีสถานะ 'Delivered')
        /// </summary>
        private void LoadMyBooks()
        {
            int memberID = (int)Session["MemberID"];
            DataTable dt = new DataTable();

            using (SqlConnection con = new SqlConnection(connStr))
            {
                // **ข้อควรระวัง:** สถานะ 'Delivered' เป็นการสมมติ, 
                // กรุณาเปลี่ยนเป็นสถานะที่ถูกต้อง (เช่น 'จัดส่งแล้ว', 'Completed') ตามที่คุณใช้จริงในระบบ
                string query = @"
                    SELECT DISTINCT b.BookID, b.Title, c.CoverUrl
                    FROM Book b
                    LEFT JOIN Cover c ON b.CoverID = c.CoverID
                    JOIN OrderDetail od ON b.BookID = od.BookID
                    JOIN OrderTable ot ON od.OrderID = ot.OrderID
                    WHERE ot.MemberID = @MemberID AND ot.Status = 'Delivered'";

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
            switch (status.ToLower())
            {
                case "pending":
                case "รอดำเนินการ":
                    return "bg-yellow-200 text-yellow-800";
                case "processing":
                case "กำลังเตรียมจัดส่ง":
                    return "bg-blue-200 text-blue-800";
                case "delivered":
                case "จัดส่งแล้ว":
                    return "bg-green-200 text-green-800";
                case "cancelled":
                case "ยกเลิก":
                    return "bg-red-200 text-red-800";
                default:
                    return "bg-gray-200 text-gray-800";
            }
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Response.Redirect("mainpage.aspx");
        }
    }
}
