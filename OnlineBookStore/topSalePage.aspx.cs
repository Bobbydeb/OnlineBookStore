using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;
// Imports ที่ไม่จำเป็น (Services, Serialization, Linq, Generic.Collections) ถูกลบออกแล้ว

namespace OnlineBookStore
{
    // (คลาส CartItem ถูกย้ายไป cartPage.aspx.cs แล้ว)

    public partial class topSalePage : Page
    {
        // เปลี่ยนเป็น static readonly เพื่อให้ WebMethod (ซึ่งเป็น static) สามารถเรียกใช้ได้
        private static readonly string connStr = "Data Source=.\\SQLEXPRESS;Initial Catalog=dbOnlineBookStore;Integrated Security=True";

        protected void Page_Load(object sender, EventArgs e)
        {
            // --- ส่วนตรวจสอบ Login ---
            if (Session["MemberID"] != null)
            {
                // ถ้า login แล้ว
                btnLogin.Visible = false;
                btnLogout.Visible = true;
                isUserLoggedIn.Value = "true"; // อัปเดต HiddenField
            }
            else
            {
                // ถ้ายังไม่ได้ login
                btnLogin.Visible = true;
                btnLogout.Visible = false;
                isUserLoggedIn.Value = "false"; // อัปเดต HiddenField
            }
            // --- จบส่วนแก้ไข ---

            if (!IsPostBack)
            {
                // [ลบ] UpdateCartIconCount();
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

        } // <--- [ !! แก้ไข !! ] เพิ่มวงเล็บปีกกา } ที่หายไป เพื่อปิด Page_Load


        // --- [ !! ลบ !! ] ---
        // [WebMethod(EnableSession = true)] ... AddToCart(...)
        // ... โค้ด WebMethod ทั้งหมดถูกลบ ...
        // --- [จบ] WebMethod ---


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

        // [ลบ] เมธอดสำหรับอัปเดตไอคอนตะกร้า
        // private void UpdateCartIconCount() { ... }


        private void LoadTopCate(int categoryId, System.Web.UI.WebControls.Repeater repeater, System.Web.UI.WebControls.Literal literalTitle)
        {
            string categoryName = GetCategoryName(categoryId);
            literalTitle.Text = $"<div class='category-title'>หมวดหมู่ : {categoryName}</div>";

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                // (Query เหมือนเดิม)
                string query = @"
                SELECT TOP 5
                    B.BookID,
                    B.Title,
                    B.Edition,
                    B.Price,
                    B.Stock, 
                    ISNULL(SUM(OD.Quantity), 0) AS TotalSold, 
                    ISNULL(C.CoverUrl, 'https://raw.githubusercontent.com/Bobbydeb/OnlineBookStore/refs/heads/master/OnlineBookStore/wwwroot/images/00_DefaultBook.jpg') AS CoverUrl,
                    BC.CategoryName,
                    ISNULL(authors.AuthorNames, 'N/A') AS Authors,
                    ISNULL(reviews.AvgRating, 0) AS AvgRating,
                    ISNULL(reviews.ReviewCount, 0) AS ReviewCount
                FROM Book B
                LEFT JOIN OrderDetail OD ON B.BookID = OD.BookID 
                LEFT JOIN Cover C ON B.CoverID = C.CoverID
                LEFT JOIN BookCategory BC ON B.CategoryID = BC.CategoryID 
                OUTER APPLY (
                    SELECT STUFF(
                        (SELECT ', ' + a.AuthorName
                            FROM Author a
                            JOIN BookAuthor ba ON a.AuthorID = ba.AuthorID
                            WHERE ba.BookID = B.BookID
                            FOR XML PATH('')),
                    1, 2, '') AS AuthorNames
                ) AS authors
                OUTER APPLY (
                    SELECT
                        AVG(CAST(r.Rating AS FLOAT)) AS AvgRating,
                        COUNT(r.ReviewID) AS ReviewCount
                    FROM Review r
                    WHERE r.BookID = B.BookID
                ) AS reviews
                WHERE B.CategoryID = @CategoryID
                GROUP BY B.BookID, B.Title, B.Edition, B.Price, B.Stock, C.CoverUrl, BC.CategoryName, authors.AuthorNames, reviews.AvgRating, reviews.ReviewCount
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
