using System;
using System.Data;
using System.Data.SqlClient;

namespace OnlineBookStore
{
    public partial class mainpage : System.Web.UI.Page
    {
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

        private void LoadBooks()
        {
            string connStr = "Data Source=.\\SQLEXPRESS;Initial Catalog=dbOnlineBookStore;Integrated Security=True";

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = @"
                    SELECT TOP 10 
                        b.Title, 
                        b.Edition,
                        c.CategoryName, 
                        b.Price,
                        ISNULL(cv.CoverUrl, 'https://via.placeholder.com/180x250.png?text=' + b.Title) AS CoverUrl
                    FROM Book b
                    JOIN BookCategory c ON b.CategoryID = c.CategoryID
                    LEFT JOIN Cover cv ON b.CoverID = cv.CoverID
                    ORDER BY NEWID();";

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
            string connStr = "Data Source=.;Initial Catalog=dbOnlineBookStore;Integrated Security=True";

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = @"
                    SELECT TOP 10 
                        b.Title,
                        b.Edition,
                        c.CategoryName,
                        b.Price,
                        ISNULL(cv.CoverUrl, 'https://via.placeholder.com/180x250.png?text=' + b.Title) AS CoverUrl
                    FROM Book b
                    JOIN BookCategory c ON b.CategoryID = c.CategoryID
                    LEFT JOIN Cover cv ON b.CoverID = cv.CoverID
                    ORDER BY b.Stock DESC;"; // หรือ ORDER BY NEWID() ถ้าอยากสุ่ม

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
