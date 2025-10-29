using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;
// [เพิ่ม] Imports ที่จำเป็นสำหรับ WebMethod และการเชื่อมต่อ
using System.Web;
using System.Web.Services;
using System.Collections.Generic;

namespace OnlineBookStore
{
    public partial class mainpage : System.Web.UI.Page
    {
        // [เพิ่ม] Connection String (ควรเก็บใน Web.config แต่เพื่อความง่าย ใช้วิธีนี้ไปก่อน)
        private static string GetConnectionString()
        {
            return "Data Source=.\\SQLEXPRESS;Initial Catalog=dbOnlineBookStore;Integrated Security=True";
        }


        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadBooks();
                LoadTopBooks();
                // [เพิ่ม] โหลดจำนวนสินค้าในตะกร้าเมื่อหน้าโหลด
                LoadCartCount();
            }

            if (Session["MemberID"] != null)
            {
                btnLogin.Visible = false;
                btnLogout.Visible = true;
            }
            else
            {
                btnLogin.Visible = true;
                btnLogout.Visible = false;
            }
        }

        // [เพิ่ม] เมธอดสำหรับโหลดจำนวนสินค้าในตะกร้า
        private void LoadCartCount()
        {
            if (Session["MemberID"] != null)
            {
                int memberId = Convert.ToInt32(Session["MemberID"]);
                int cartId = GetCartId(memberId); // ใช้ GetCartId แบบ Select-only
                if (cartId > 0)
                {
                    int totalQuantity = GetTotalCartQuantity(cartId);
                    if (totalQuantity > 0)
                    {
                        cartCount.InnerText = totalQuantity.ToString();
                        cartCount.Attributes["class"] = "cart-count"; // แสดงผล
                    }
                    else
                    {
                        cartCount.InnerText = "0";
                        cartCount.Attributes["class"] = "cart-count empty"; // ซ่อน
                    }
                }
                else
                {
                    cartCount.Attributes["class"] = "cart-count empty"; // ซ่อน
                }
            }
            else
            {
                cartCount.Attributes["class"] = "cart-count empty"; // ซ่อนถ้ายังไม่ login
            }
        }


        // --- เมธอดที่เพิ่มเข้ามา (คัดลอกจาก myAccountPage.aspx.cs) ---
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

        private void LoadBooks()
        {
            string connStr = GetConnectionString(); // [แก้ไข]

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = @"
                    SELECT TOP 10 
                        b.BookID, 
                        b.Title, 
                        b.Edition,
                        c.CategoryName, 
                        b.Price,
                        ISNULL(cv.CoverUrl, 'https://raw.githubusercontent.com/Bobbydeb/OnlineBookStore/refs/heads/master/OnlineBookStore/wwwroot/images/00_DefaultBook.jpg') AS CoverUrl,
                        ISNULL(authors.AuthorNames, 'N/A') AS Authors,
                        ISNULL(reviews.AvgRating, 0) AS AvgRating,
                        ISNULL(reviews.ReviewCount, 0) AS ReviewCount
                    FROM Book b
                    LEFT JOIN BookCategory c ON b.CategoryID = c.CategoryID
                    LEFT JOIN Cover cv ON b.CoverID = cv.CoverID
                    OUTER APPLY (
                        SELECT STUFF(
                            (SELECT ', ' + a.AuthorName
                             FROM Author a
                             JOIN BookAuthor ba ON a.AuthorID = ba.AuthorID
                             WHERE ba.BookID = b.BookID
                             FOR XML PATH('')), 
                        1, 2, '') AS AuthorNames
                    ) AS authors
                    OUTER APPLY (
                        SELECT 
                            AVG(CAST(r.Rating AS FLOAT)) AS AvgRating, 
                            COUNT(r.ReviewID) AS ReviewCount
                        FROM Review r
                        WHERE r.BookID = b.BookID
                    ) AS reviews
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
            string connStr = GetConnectionString(); // [แก้ไข]

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = @"
                    SELECT TOP 10 
                        b.BookID,
                        b.Title,
                        b.Edition,
                        c.CategoryName,
                        b.Price,
                        ISNULL(cv.CoverUrl, 'https://raw.githubusercontent.com/Bobbydeb/OnlineBookStore/refs/heads/master/OnlineBookStore/wwwroot/images/00_DefaultBook.jpg') AS CoverUrl,
                        ISNULL(SUM(od.Quantity), 0) AS TotalSold,
                        ISNULL(authors.AuthorNames, 'N/A') AS Authors,
                        ISNULL(reviews.AvgRating, 0) AS AvgRating,
                        ISNULL(reviews.ReviewCount, 0) AS ReviewCount
                    FROM Book b
                    LEFT JOIN BookCategory c ON b.CategoryID = c.CategoryID
                    LEFT JOIN Cover cv ON b.CoverID = cv.CoverID
                    LEFT JOIN OrderDetail od ON b.BookID = od.BookID
                    OUTER APPLY (
                        SELECT STUFF(
                            (SELECT ', ' + a.AuthorName
                             FROM Author a
                             JOIN BookAuthor ba ON a.AuthorID = ba.AuthorID
                             WHERE ba.BookID = b.BookID
                             FOR XML PATH('')), 
                        1, 2, '') AS AuthorNames
                    ) AS authors
                    OUTER APPLY (
                        SELECT 
                            AVG(CAST(r.Rating AS FLOAT)) AS AvgRating, 
                            COUNT(r.ReviewID) AS ReviewCount
                        FROM Review r
                        WHERE r.BookID = b.BookID
                    ) AS reviews
                    GROUP BY b.BookID, b.Title, b.Edition, c.CategoryName, b.Price, cv.CoverUrl, authors.AuthorNames, reviews.AvgRating, reviews.ReviewCount
                    ORDER BY TotalSold DESC;";

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


        // --- [เพิ่ม] ส่วนของ WebMethod สำหรับ AJAX ---

        [WebMethod]
        public static object AddToCart(int bookId, int quantity)
        {
            try
            {
                // 1. ตรวจสอบการ Login
                if (HttpContext.Current.Session["MemberID"] == null)
                {
                    return new { success = false, message = "กรุณาเข้าสู่ระบบก่อน" };
                }

                int memberId = Convert.ToInt32(HttpContext.Current.Session["MemberID"]);

                using (SqlConnection conn = new SqlConnection(GetConnectionString()))
                {
                    conn.Open();

                    // 2. ค้นหา หรือ สร้าง CartID
                    int cartId = GetOrCreateCartId(memberId, conn);

                    // 3. ตรวจสอบว่ามีสินค้านี้ในตะกร้าหรือยัง
                    string checkQuery = "SELECT Quantity FROM CartItem WHERE CartID = @CartID AND BookID = @BookID";
                    int currentQuantity = 0;
                    bool itemExists = false;

                    using (SqlCommand checkCmd = new SqlCommand(checkQuery, conn))
                    {
                        checkCmd.Parameters.AddWithValue("@CartID", cartId);
                        checkCmd.Parameters.AddWithValue("@BookID", bookId);
                        object result = checkCmd.ExecuteScalar();
                        if (result != null && result != DBNull.Value)
                        {
                            currentQuantity = Convert.ToInt32(result);
                            itemExists = true;
                        }
                    }

                    // 4. เพิ่ม หรือ อัปเดต สินค้า
                    if (itemExists)
                    {
                        // อัปเดตจำนวน
                        string updateQuery = "UPDATE CartItem SET Quantity = Quantity + @Quantity WHERE CartID = @CartID AND BookID = @BookID";
                        using (SqlCommand updateCmd = new SqlCommand(updateQuery, conn))
                        {
                            updateCmd.Parameters.AddWithValue("@Quantity", quantity);
                            updateCmd.Parameters.AddWithValue("@CartID", cartId);
                            updateCmd.Parameters.AddWithValue("@BookID", bookId);
                            updateCmd.ExecuteNonQuery();
                        }
                    }
                    else
                    {
                        // เพิ่มรายการใหม่
                        string insertQuery = "INSERT INTO CartItem (CartID, BookID, Quantity) VALUES (@CartID, @BookID, @Quantity)";
                        using (SqlCommand insertCmd = new SqlCommand(insertQuery, conn))
                        {
                            insertCmd.Parameters.AddWithValue("@CartID", cartId);
                            insertCmd.Parameters.AddWithValue("@BookID", bookId);
                            insertCmd.Parameters.AddWithValue("@Quantity", quantity);
                            insertCmd.ExecuteNonQuery();
                        }
                    }

                    // 5. ดึงจำนวนสินค้ารวมในตะกร้า
                    int totalQuantityInCart = GetTotalCartQuantity(cartId, conn);

                    // 6. ส่งผลลัพธ์กลับ
                    return new { success = true, newCount = totalQuantityInCart };
                }
            }
            catch (Exception ex)
            {
                // ควร Log error ไว้
                return new { success = false, message = ex.Message };
            }
        }

        // Helper: ค้นหา CartID ถ้าไม่เจอให้สร้างใหม่
        private static int GetOrCreateCartId(int memberId, SqlConnection conn)
        {
            int cartId = 0;
            string query = "SELECT CartID FROM Cart WHERE MemberID = @MemberID";
            using (SqlCommand cmd = new SqlCommand(query, conn))
            {
                cmd.Parameters.AddWithValue("@MemberID", memberId);
                object result = cmd.ExecuteScalar();
                if (result != null && result != DBNull.Value)
                {
                    cartId = Convert.ToInt32(result);
                }
                else
                {
                    // ไม่พบ Cart, สร้างใหม่
                    string insertQuery = "INSERT INTO Cart (MemberID, CreatedDate) VALUES (@MemberID, GETDATE()); SELECT SCOPE_IDENTITY();";
                    using (SqlCommand insertCmd = new SqlCommand(insertQuery, conn))
                    {
                        insertCmd.Parameters.AddWithValue("@MemberID", memberId);
                        cartId = Convert.ToInt32(insertCmd.ExecuteScalar());
                    }
                }
            }
            return cartId;
        }

        // Helper: ค้นหา CartID (สำหรับ Page_Load, ไม่สร้างใหม่)
        private int GetCartId(int memberId)
        {
            int cartId = 0;
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
            return cartId;
        }


        // Helper: ดึงจำนวนสินค้ารวมในตะกร้า
        private static int GetTotalCartQuantity(int cartId, SqlConnection conn = null)
        {
            bool closeConnection = false;
            if (conn == null)
            {
                conn = new SqlConnection(GetConnectionString());
                conn.Open();
                closeConnection = true;
            }

            int totalQuantity = 0;
            string query = "SELECT SUM(Quantity) FROM CartItem WHERE CartID = @CartID";
            using (SqlCommand cmd = new SqlCommand(query, conn))
            {
                cmd.Parameters.AddWithValue("@CartID", cartId);
                object result = cmd.ExecuteScalar();
                if (result != null && result != DBNull.Value)
                {
                    totalQuantity = Convert.ToInt32(result);
                }
            }

            if (closeConnection)
            {
                conn.Close();
            }
            return totalQuantity;
        }
    }
}
