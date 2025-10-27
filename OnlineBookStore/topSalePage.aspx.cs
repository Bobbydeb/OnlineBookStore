using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace OnlineBookStore
{
    public partial class topSalePage : Page
    {
        private readonly string connStr = "Data Source=.;Initial Catalog=dbOnlineBookStore;Integrated Security=True";

        protected void Page_Load(object sender, EventArgs e)
        {
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
                        B.BookID, B.Title, B.Price, SUM(OD.Quantity) AS TotalSold
                    FROM Book B
                    JOIN OrderDetail OD ON B.BookID = OD.BookID
                    WHERE B.CategoryID = @CategoryID
                    GROUP BY B.BookID, B.Title, B.Price
                    ORDER BY TotalSold DESC;";


                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@CategoryID", categoryId);
                    conn.Open();
                    SqlDataReader dr = cmd.ExecuteReader();
                    DataTable dt = new DataTable();
                    dt.Load(dr);

                    dt.Columns.Add("CoverUrl", typeof(string));
                    foreach (DataRow row in dt.Rows)
                    {
                        string title = row["Title"].ToString();
                        row["CoverUrl"] = "https://via.placeholder.com/180x250.png?text=" + Uri.EscapeDataString(title);
                    }

                    repeater.DataSource = dt;
                    repeater.DataBind();
                }
            }
        }
    }
}
