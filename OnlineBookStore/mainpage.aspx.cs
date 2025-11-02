using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;
 
using System.Web;
// using System.Web.Services; // [ลบ] ไม่จำเป็นแล้ว
using System.Collections.Generic;
using System.Diagnostics;  

namespace OnlineBookStore
{
    public partial class mainpage : System.Web.UI.Page
    {
 
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

        //  สำหรับโหลดจำนวนสินค้าในตะกร้า
        private void LoadCartCount()
        {
            if (Session["MemberID"] != null)
            {
                int memberId = Convert.ToInt32(Session["MemberID"]);
                int cartId = GetCartId(memberId); // ใช้ GetCartId แบบ Select-only
                if (cartId > 0)
                {
                    int totalQuantity = GetTotalCartQuantity(cartId); // ใช้ version ที่รับ conn string ได้
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
                    // ถ้าไม่มี CartID เลย ก็ให้เป็น 0 และซ่อน
                    cartCount.InnerText = "0";
                    cartCount.Attributes["class"] = "cart-count empty";
                }
            }
            else
            {
                // ถ้ายังไม่ login ก็ให้เป็น 0 และซ่อน
                cartCount.InnerText = "0";
                cartCount.Attributes["class"] = "cart-count empty";
            }
        }

         
        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon(); // [แก้ไข] ใช้ Abandon เพื่อเคลียร์ Session จริงๆ
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
                        ISNULL(p.PublisherName, 'N/A') AS PublisherName, -- [เพิ่ม] ดึงชื่อ Publisher
                        ISNULL(cv.CoverUrl, 'https://raw.githubusercontent.com/Bobbydeb/OnlineBookStore/refs/heads/master/OnlineBookStore/wwwroot/images/00_DefaultBook.jpg') AS CoverUrl,
                        ISNULL(authors.AuthorNames, 'N/A') AS Authors,
                        ISNULL(reviews.AvgRating, 0) AS AvgRating,
                        ISNULL(reviews.ReviewCount, 0) AS ReviewCount
                    FROM Book b
                    LEFT JOIN BookCategory c ON b.CategoryID = c.CategoryID
                    LEFT JOIN Cover cv ON b.CoverID = cv.CoverID
                    LEFT JOIN Publisher p ON b.PublisherID = p.PublisherID -- [เพิ่ม] JOIN ตาราง Publisher
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
                    ORDER BY NEWID();"; // สุ่มข้อมูล 10 รายการ

                try // [เพิ่ม] Try-catch
                {
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        conn.Open();
                        SqlDataReader dr = cmd.ExecuteReader();
                        DataTable dt = new DataTable();
                        dt.Load(dr); // Load data from reader to DataTable

                        RepeaterBooks.DataSource = dt;
                        RepeaterBooks.DataBind();
                    }
                }
                catch (Exception ex)
                {
                    Debug.WriteLine("Error Loading Books: " + ex.Message);
                    // Handle error (e.g., display a message to the user)
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
                        ISNULL(p.PublisherName, 'N/A') AS PublisherName, -- [เพิ่ม] ดึงชื่อ Publisher
                        ISNULL(cv.CoverUrl, 'https://raw.githubusercontent.com/Bobbydeb/OnlineBookStore/refs/heads/master/OnlineBookStore/wwwroot/images/00_DefaultBook.jpg') AS CoverUrl,
                        ISNULL(SUM(od.Quantity), 0) AS TotalSold,
                        ISNULL(authors.AuthorNames, 'N/A') AS Authors,
                        ISNULL(reviews.AvgRating, 0) AS AvgRating,
                        ISNULL(reviews.ReviewCount, 0) AS ReviewCount
                    FROM Book b
                    LEFT JOIN BookCategory c ON b.CategoryID = c.CategoryID
                    LEFT JOIN Cover cv ON b.CoverID = cv.CoverID
                    LEFT JOIN Publisher p ON b.PublisherID = p.PublisherID -- [เพิ่ม] JOIN ตาราง Publisher
                    LEFT JOIN OrderDetail od ON b.BookID = od.BookID
                    LEFT JOIN OrderTable ot ON od.OrderID = ot.OrderID AND ot.Status = 'Completed' -- นับเฉพาะ Order ที่เสร็จสมบูรณ์
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
                    GROUP BY b.BookID, b.Title, b.Edition, c.CategoryName, b.Price, cv.CoverUrl, p.PublisherName, authors.AuthorNames, reviews.AvgRating, reviews.ReviewCount -- [เพิ่ม] p.PublisherName ใน GROUP BY
                    ORDER BY TotalSold DESC;"; // เรียงตามยอดขาย

                try // [เพิ่ม] Try-catch
                {
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        conn.Open();
                        SqlDataReader dr = cmd.ExecuteReader();
                        DataTable dt = new DataTable();
                        dt.Load(dr); // Load data from reader to DataTable

                        RepeaterTopBooks.DataSource = dt;
                        RepeaterTopBooks.DataBind();
                    }
                }
                catch (Exception ex)
                {
                    Debug.WriteLine("Error Loading Top Books: " + ex.Message);
                    // Handle error
                }
            }
        }


 
        protected void RepeaterBooks_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "AddToCart")
            {
         
                if (Session["MemberID"] == null)
                {
                    // ถ้ายังไม่ Login, ส่งไปหน้า Login (และบอกให้ Login เสร็จแล้วกลับมาหน้านี้)
                    Response.Redirect("loginPage.aspx?returnUrl=mainpage.aspx");
                    return;
                }

                int memberId = Convert.ToInt32(Session["MemberID"]);
                int bookId = Convert.ToInt32(e.CommandArgument);
                int quantity = 1;  

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
                            else
                            {
                                Debug.WriteLine("Item does not exist in cart.");
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
                                int rowsAffected = updateCmd.ExecuteNonQuery();
                                Debug.WriteLine($"CartItem updated. Rows affected: {rowsAffected}");
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
                                int rowsAffected = insertCmd.ExecuteNonQuery();
                                Debug.WriteLine($"CartItem inserted. Rows affected: {rowsAffected}");
                            }
                        }

                        // 5. ดึงจำนวนสินค้ารวมในตะกร้า (เพื่ออัปเดต Header)
 
                    }
                }
                catch (SqlException sqlEx)
                {
                    Debug.WriteLine($"SQL Error in AddToCart (Repeater): {sqlEx.Message}\n{sqlEx.StackTrace}");
 
                }
                catch (Exception ex)
                {
                    Debug.WriteLine($"General Error in AddToCart (Repeater): {ex.Message}\n{ex.StackTrace}");
    
                }
                finally
                {
                    // 6. อัปเดตตัวเลขบนตะกร้า (Header)
      
                    LoadCartCount();

 
                }
            }
        }


 
        private int GetOrCreateCartId(int memberId, SqlConnection conn)
        {
            int cartId = 0;
            // First, try to find an existing cart
            string query = "SELECT CartID FROM Cart WHERE MemberID = @MemberID";
            using (SqlCommand cmd = new SqlCommand(query, conn)) // Use the passed connection
            {
                cmd.Parameters.AddWithValue("@MemberID", memberId);
                object result = cmd.ExecuteScalar();
                if (result != null && result != DBNull.Value)
                {
                    cartId = Convert.ToInt32(result);
                    Debug.WriteLine($"Found existing CartID: {cartId} for MemberID: {memberId}");
                }
                else
                {
                    // No cart found, create a new one
                    Debug.WriteLine($"No Cart found for MemberID: {memberId}. Creating new cart.");
                    string insertQuery = "INSERT INTO Cart (MemberID, CreatedDate) OUTPUT INSERTED.CartID VALUES (@MemberID, GETDATE())";
                    using (SqlCommand insertCmd = new SqlCommand(insertQuery, conn)) // Use the passed connection
                    {
                        insertCmd.Parameters.AddWithValue("@MemberID", memberId);
                        try
                        {
                            object insertedId = insertCmd.ExecuteScalar();
                            if (insertedId != null && insertedId != DBNull.Value)
                            {
                                cartId = Convert.ToInt32(insertedId);
                                Debug.WriteLine($"Created new CartID: {cartId} for MemberID: {memberId}");
                            }
                            else
                            {
                                Debug.WriteLine($"Error: INSERT INTO Cart did not return a CartID for MemberID: {memberId}");
                            }
                        }
                        catch (SqlException insertEx)
                        {
                            Debug.WriteLine($"SQL Error creating cart for MemberID {memberId}: {insertEx.Message}");
                            return 0; // Indicate failure
                        }
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
                    string query = "SELECT SUM(ISNULL(Quantity, 0)) FROM CartItem WHERE CartID = @CartID"; // Use ISNULL for safety
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


    }
}
