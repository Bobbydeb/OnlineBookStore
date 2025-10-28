using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace OnlineBookStore
{
    public partial class topSalePage : Page
    {
        private readonly string connStr = "Data Source=.\\SQLEXPRESS;Initial Catalog=dbOnlineBookStore;Integrated Security=True";

        protected void Page_Load(object sender, EventArgs e)
        {
            // --- 1. ส่วนที่เพิ่มเข้ามา ---
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

            if (!IsPostBack)
            {
                LoadTopCate(1, RepeaterLoadTopCate1, LiteralCate1);
                LoadTopCate(2, RepeaterLoadTopCate2, LiteralCate2);
                LoadTopCate(3, RepeaterLoadTopCate3, LiteralCate3);
                LoadTopCate(4, RepeaterLoadTopCate4, LiteralCate4);
                LoadTopCate(5, RepeaterLoadTopCate5, LiteralCate5);
                LoadTopCate(6, RepeaterLoadTopCate6, LiteralCate6);
                LoadTopCate(7, RepeaterLoadTopCate7, LiteralCate7);
                LoadTopCate(8, RepeaterLoadTopCate8, LiteralCate8);
                LoadTopCate(9, RepeaterLoadTopCate9, LiteralCate9);
                LoadTopCate(10, RepeaterLoadTopCate10, LiteralCate10);
                LoadTopCate(11, RepeaterLoadTopCate11, LiteralCate11);
            }

        }
        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Response.Redirect("topSalePage.aspx"); // หรือ mainpage.aspx
        }

        // เมธอดดึงชื่อหมวดหมู่จากตาราง BookCategory
        private string GetCategoryName(int categoryId)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = "SELECT CategoryName FROM BookCategory WHERE CategoryID = @CategoryID";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@CategoryID", categoryId);
                    conn.Open();
                    object result = cmd.ExecuteScalar();
                    return result != null ? result.ToString() : "ไม่ทราบหมวดหมู่";
                }
            }
        }

        // โหลดหนังสือขายดีของแต่ละหมวด และตั้งชื่อหมวดจากฐานข้อมูล
        private void LoadTopCate(int categoryId, System.Web.UI.WebControls.Repeater repeater, System.Web.UI.WebControls.Literal literalTitle)
        {
            string categoryName = GetCategoryName(categoryId);
            literalTitle.Text = $"<div class='category-title'>หมวดหมู่ : {categoryName}</div>";

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = @"
                SELECT TOP 5 
                    B.BookID, 
                    B.Title, 
                    B.Edition,
                    B.Price, 
                    SUM(OD.Quantity) AS TotalSold, 
                    ISNULL(C.CoverUrl, 'https://via.placeholder.com/180x250.png?text=' + B.Title) AS CoverUrl
                FROM Book B
                JOIN OrderDetail OD ON B.BookID = OD.BookID
                LEFT JOIN Cover C ON B.CoverID = C.CoverID
                WHERE B.CategoryID = @CategoryID
                GROUP BY B.BookID, B.Title, B.Edition, B.Price, C.CoverUrl
                ORDER BY TotalSold DESC;";


                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@CategoryID", categoryId);
                    conn.Open();
                    SqlDataReader dr = cmd.ExecuteReader();
                    DataTable dt = new DataTable();
                    dt.Load(dr);

                    repeater.DataSource = dt;
                    repeater.DataBind();
                }
            }
        }

    }
}
