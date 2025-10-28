using System;
using System.Data;
using System.Data.SqlClient;
// [เพิ่ม] ต้องใช้ System.Web.UI.WebControls
using System.Web.UI.WebControls;

namespace OnlineBookStore
{
    public partial class mainpage : System.Web.UI.Page
    {
        // [ลบ] ไม่จำเป็นต้องประกาศ txtSearch, btnSearch ที่นี่ เพราะมีใน .designer.cs แล้ว

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadBooks();
                LoadTopBooks();
            }
            // --- ส่วนที่เพิ่มเข้ามา ---
            if (Session["MemberID"] != null)
            {
                // ถ้า login แล้ว ให้ซ่อนปุ่ม Login และแสดงปุ่ม Logout
                btnLogin.Visible = false;
                btnLogout.Visible = true;
            }
            else
            {
                // ถ้ายังไม่ได้ login (สถานะปกติ)
                btnLogin.Visible = true;
                btnLogout.Visible = false;
            }
            // --- จบส่วนที่เพิ่มเข้ามา ---


        }


        // --- เมธอดที่เพิ่มเข้ามา (คัดลอกจาก myAccountPage.aspx.cs) ---
        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Response.Redirect("mainpage.aspx");

        }

        // [เพิ่ม] Event Handler สำหรับปุ่มค้นหา (นี่คือส่วนที่ขาดไป)
        protected void btnSearch_Click(object sender, EventArgs e)
        {
            string query = txtSearch.Text.Trim();
            if (!string.IsNullOrEmpty(query))
            {
                // ส่งต่อไปยังหน้า searchResultPage.aspx พร้อมกับคำค้นหา
                Response.Redirect($"searchResultPage.aspx?query={Server.UrlEncode(query)}");
            }
        }

        private void LoadBooks()
        {
            // [แก้ไข] ใช้ Connection String ที่สอดคล้องกัน
            string connStr = "Data Source=.\\SQLEXPRESS;Initial Catalog=dbOnlineBookStore;Integrated Security=True";

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = @"
                    SELECT TOP 10 
                        b.Title, 
                        b.Edition,
                        c.CategoryName, 
                        b.Price,
                        ISNULL(cv.CoverUrl, 'https://raw.githubusercontent.com/Bobbydeb/OnlineBookStore/refs/heads/master/OnlineBookStore/wwwroot/images/00_DefaultBook.jpg') AS CoverUrl
                    FROM Book b
                    LEFT JOIN BookCategory c ON b.CategoryID = c.CategoryID
                    LEFT JOIN Cover cv ON b.CoverID = cv.CoverID
                    ORDER BY NEWID();"; // สุ่มหนังสือแนะนำ

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    conn.Open();
                    SqlDataReader dr = cmd.ExecuteReader();
                    DataTable dt = new DataTable();
                    dt.Load(dr);

                    RepeaterBooks.DataSource = dt;
                    RepeaterBooks.DataBind();
                }
            }
        }

        private void LoadTopBooks()
        {
            // [แก้ไข] ใช้ Connection String ที่สอดคล้องกัน
            string connStr = "Data Source=.\\SQLEXPRESS;Initial Catalog=dbOnlineBookStore;Integrated Security=True";

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = @"
                    SELECT TOP 10 
                        b.Title,
                        b.Edition,
                        c.CategoryName,
                        b.Price,
                        ISNULL(cv.CoverUrl, 'https://raw.githubusercontent.com/Bobbydeb/OnlineBookStore/refs/heads/master/OnlineBookStore/wwwroot/images/00_DefaultBook.jpg') AS CoverUrl,
                        ISNULL(SUM(od.Quantity), 0) AS TotalSold
                    FROM Book b
                    LEFT JOIN BookCategory c ON b.CategoryID = c.CategoryID
                    LEFT JOIN Cover cv ON b.CoverID = cv.CoverID
                    LEFT JOIN OrderDetail od ON b.BookID = od.BookID
                    GROUP BY b.BookID, b.Title, b.Edition, c.CategoryName, b.Price, cv.CoverUrl
                    ORDER BY TotalSold DESC;"; // [แก้ไข] เรียงลำดับตามยอดขาย (TotalSold)

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    conn.Open();
                    SqlDataReader dr = cmd.ExecuteReader();
                    DataTable dt = new DataTable();
                    dt.Load(dr);

                    RepeaterTopBooks.DataSource = dt;
                    RepeaterTopBooks.DataBind();
                }
            }
        }
    }
}

