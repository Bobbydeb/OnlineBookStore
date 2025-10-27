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

        }

        private void LoadBooks()
        {
            string connStr = "Data Source=.;Initial Catalog=dbOnlineBookStore;Integrated Security=True";

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = @"
                    SELECT TOP 10 
                        b.Title, 
                        c.CategoryName, 
                        b.Price
                    FROM Book b
                    JOIN BookCategory c ON b.CategoryID = c.CategoryID
                    ORDER BY NEWID();";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    conn.Open();
                    SqlDataReader dr = cmd.ExecuteReader();
                    DataTable dt = new DataTable();
                    dt.Load(dr);

                    // เพิ่มคอลัมน์ CoverUrl สำหรับรูป placeholder
                    dt.Columns.Add("CoverUrl", typeof(string));
                    foreach (DataRow row in dt.Rows)
                    {
                        string title = row["Title"].ToString();
                        row["CoverUrl"] = "https://via.placeholder.com/180x250.png?text=" + Uri.EscapeDataString(title);
                    }

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
                    c.CategoryName,
                    b.Price,
                    cv.CoverUrl
                    FROM Book b
                    JOIN BookCategory c ON b.CategoryID = c.CategoryID
                    LEFT JOIN Cover cv ON b.CoverID = cv.CoverID
                    ORDER BY b.Stock DESC;";   // หรือ ORDER BY NEWID() ถ้าอยากสุ่ม

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
