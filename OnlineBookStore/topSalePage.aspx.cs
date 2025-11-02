using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;
// [เพิ่ม] Imports ที่จำเป็น
using System.Diagnostics;
using System.Web;


namespace OnlineBookStore
{
    public partial class topSalePage : Page
    {
     
        private string GetConnectionString()
        {
            return "Data Source=.\\SQLEXPRESS;Initial Catalog=dbOnlineBookStore;Integrated Security=True";
        }

        protected void Page_Load(object sender, EventArgs e)
        {
     
            if (Session["MemberID"] != null)
            {
                // ถ้า login แล้ว
                btnLogin.Visible = false;
                btnLogout.Visible = true;
                // [ลบ] isUserLoggedIn.Value = "true";
            }
            else
            {
                // ถ้ายังไม่ได้ login
                btnLogin.Visible = true;
                btnLogout.Visible = false;
                // [ลบ] isUserLoggedIn.Value = "false";
            }
      

            if (!IsPostBack)
            {
                // [เพิ่ม] โหลดจำนวนตะกร้า
                LoadCartCount();

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
            Session.Abandon(); // [แก้ไข] ใช้ Abandon
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
            using (SqlConnection conn = new SqlConnection(GetConnectionString())) // [แก้ไข]
            {
                string query = "SELECT CategoryName FROM BookCategory WHERE CategoryID = @CategoryID";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@CategoryID", categoryId);
                    conn.Open();
                    object result = cmd.ExecuteScalar();
                    return result != null ? result.ToString() : "Uncetegorize";
                }
            }
        }

        private void LoadTopCate(int categoryId, System.Web.UI.WebControls.Repeater repeater, System.Web.UI.WebControls.Literal literalTitle)
        {
            string categoryName = GetCategoryName(categoryId);
            literalTitle.Text = $"<div class='category-title'>Category : {categoryName}</div>";

            using (SqlConnection conn = new SqlConnection(GetConnectionString())) // [แก้ไข]
            {
             
                string query = @"
                SELECT TOP 5
                    B.BookID,
                    B.Title,
                    B.Edition,
                    B.Price,
                    B.Stock, 
                    ISNULL(p.PublisherName, 'N/A') AS PublisherName, -- [เพิ่ม]
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
                LEFT JOIN Publisher p ON B.PublisherID = p.PublisherID -- [เพิ่ม]
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
                GROUP BY B.BookID, B.Title, B.Edition, B.Price, B.Stock, C.CoverUrl, BC.CategoryName, p.PublisherName, authors.AuthorNames, reviews.AvgRating, reviews.ReviewCount -- [เพิ่ม] p.PublisherName
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



        protected void Repeater_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "AddToCart")
            {
                // 1. ตรวจสอบการ Login
                if (Session["MemberID"] == null)
                {
                    Response.Redirect("loginPage.aspx?returnUrl=topSalePage.aspx"); // [แก้ไข] returnUrl
                    return;
                }

                int memberId = Convert.ToInt32(Session["MemberID"]);
                int bookId = Convert.ToInt32(e.CommandArgument);
                int quantity = 1; // ค่าเริ่มต้น 1

                Debug.WriteLine($"Repeater AddToCart called: BookID={bookId}, MemberID={memberId}");

                try
                {
                    using (SqlConnection conn = new SqlConnection(GetConnectionString()))
                    {
                        conn.Open();
                        Debug.WriteLine("Database connection opened.");

                        // 2. ค้นหา หรือ สร้าง CartID
                        int cartId = GetOrCreateCartId(memberId, conn);
                        Debug.WriteLine($"CartID: {cartId}");

                        if (cartId == 0)
                        {
                            Debug.WriteLine("AddToCart Error: Failed to get or create CartID.");
                            return;
                        }

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
                                Debug.WriteLine($"Item exists in cart. Current quantity: {currentQuantity}");
                            }
                        }

                        // 4. เพิ่ม หรือ อัปเดต สินค้า
                        if (itemExists)
                        {
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
                            string insertQuery = "INSERT INTO CartItem (CartID, BookID, Quantity) VALUES (@CartID, @BookID, @Quantity)";
                            using (SqlCommand insertCmd = new SqlCommand(insertQuery, conn))
                            {
                                insertCmd.Parameters.AddWithValue("@CartID", cartId);
                                insertCmd.Parameters.AddWithValue("@BookID", bookId);
                                insertCmd.Parameters.AddWithValue("@Quantity", quantity);
                                insertCmd.ExecuteNonQuery();
                            }
                        }
                    }
                }
                catch (Exception ex)
                {
                    Debug.WriteLine($"Error in AddToCart (Repeater): {ex.Message}");
                }
                finally
                {
                    // 5. อัปเดตตัวเลขบนตะกร้า (Header)
                    LoadCartCount();
                }
            }
        }


     
        private int GetOrCreateCartId(int memberId, SqlConnection conn)
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
                    string insertQuery = "INSERT INTO Cart (MemberID, CreatedDate) OUTPUT INSERTED.CartID VALUES (@MemberID, GETDATE())";
                    using (SqlCommand insertCmd = new SqlCommand(insertQuery, conn))
                    {
                        insertCmd.Parameters.AddWithValue("@MemberID", memberId);
                        cartId = (int)insertCmd.ExecuteScalar();
                    }
                }
            }
            return cartId;
        }
 
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
            catch (Exception ex)
            {
                Debug.WriteLine($"Error in GetCartId (Page_Load): {ex.Message}");
            }
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
            catch (Exception ex)
            {
                Debug.WriteLine($"Error in GetTotalCartQuantity (instance): {ex.Message}");
            }
            return totalQuantity;
        }

        //  สำหรับโหลดจำนวนสินค้าในตะกร้า (หลัก)
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

    }
}
