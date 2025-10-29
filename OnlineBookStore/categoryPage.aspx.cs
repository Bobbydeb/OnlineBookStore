using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Linq; // [เพิ่ม] สำหรับ Enumerable.Range
using System.Web.UI.HtmlControls; // [เพิ่ม] สำหรับ HtmlGenericControl
// [เพิ่ม] Imports ที่จำเป็น
using System.Diagnostics;
using System.Web;


namespace OnlineBookStore
{
    public partial class categoryPage : System.Web.UI.Page
    {
        // [แก้ไข] เปลี่ยนเป็น private instance method
        private string GetConnectionString()
        {
            return "Data Source=.\\SQLEXPRESS;Initial Catalog=dbOnlineBookStore;Integrated Security=True";
        }
        private int categoryId = 0;
        private int currentPage = 1;

        protected void Page_Load(object sender, EventArgs e)
        {
            // 1. ตรวจสอบ Login (เหมือนหน้าอื่น)
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

            // 2. ตรวจสอบ QueryString "id"
            if (!int.TryParse(Request.QueryString["id"], out categoryId))
            {
                Response.Redirect("mainpage.aspx");
                return;
            }

            // 3. ตรวจสอบ QueryString "page"
            if (!int.TryParse(Request.QueryString["page"], out currentPage))
            {
                currentPage = 1;
            }
            if (currentPage < 1) currentPage = 1;


            if (!IsPostBack)
            {
                // [เพิ่ม] โหลดจำนวนตะกร้า
                LoadCartCount();
                // 4. โหลดข้อมูล
                LoadCategoryBooks();
            }
        }

        private void LoadCategoryBooks()
        {
            int pageSize = 10;

            using (SqlConnection con = new SqlConnection(GetConnectionString())) // [แก้ไข]
            {
                con.Open();

                // --- Query 1: ดึงชื่อหมวดหมู่ ---
                string catQuery = "SELECT CategoryName FROM BookCategory WHERE CategoryID = @CategoryID";
                using (SqlCommand catCmd = new SqlCommand(catQuery, con))
                {
                    catCmd.Parameters.AddWithValue("@CategoryID", categoryId);
                    object result = catCmd.ExecuteScalar();
                    if (result != null)
                    {
                        litCategoryName.Text = result.ToString();
                        this.Title = "หมวดหมู่: " + result.ToString();
                    }
                    else
                    {
                        Response.Redirect("mainpage.aspx");
                        return;
                    }
                }

                // --- Query 2: นับจำนวนหนังสือ ---
                int totalBooks = 0;
                string countQuery = "SELECT COUNT(BookID) FROM Book WHERE CategoryID = @CategoryID";
                using (SqlCommand countCmd = new SqlCommand(countQuery, con))
                {
                    countCmd.Parameters.AddWithValue("@CategoryID", categoryId);
                    totalBooks = (int)countCmd.ExecuteScalar();
                }

                if (totalBooks > 0)
                {
                    pnlNoBooks.Visible = false;

                    // --- Query 3: ดึงหนังสือแบบแบ่งหน้า ---
                    string bookQuery = @"
                        SELECT
                            b.BookID,
                            b.Title,
                            b.Edition,
                            c.CategoryName,
                            b.Price,
                            b.Stock,
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
                        WHERE b.CategoryID = @CategoryID
                        ORDER BY b.Title
                        OFFSET @Offset ROWS
                        FETCH NEXT @PageSize ROWS ONLY;";

                    using (SqlCommand bookCmd = new SqlCommand(bookQuery, con))
                    {
                        bookCmd.Parameters.AddWithValue("@CategoryID", categoryId);
                        bookCmd.Parameters.AddWithValue("@PageSize", pageSize);
                        bookCmd.Parameters.AddWithValue("@Offset", (currentPage - 1) * pageSize);

                        DataTable dt = new DataTable();
                        SqlDataAdapter sda = new SqlDataAdapter(bookCmd);
                        sda.Fill(dt);

                        rptCategoryBooks.DataSource = dt;
                        rptCategoryBooks.DataBind();
                    }

                    // --- Logic การสร้าง Pager ---
                    int totalPages = (int)Math.Ceiling((double)totalBooks / pageSize);
                    if (totalPages > 1)
                    {
                        var pages = Enumerable.Range(1, totalPages);
                        rptPager.DataSource = pages.Select(p => new { PageNum = p, IsCurrent = (p == currentPage) }).ToList();
                        rptPager.DataBind();
                        pnlPager.Visible = true;
                    }
                    else
                    {
                        pnlPager.Visible = false;
                    }
                }
                else
                {
                    rptCategoryBooks.DataSource = null;
                    rptCategoryBooks.DataBind();
                    pnlNoBooks.Visible = true;
                    pnlPager.Visible = false;
                }
                // [แก้ไข] ไม่ต้อง con.Close() เพราะใช้ using แล้ว
            }
        }

        protected void rptPager_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                HyperLink hlPageLink = (HyperLink)e.Item.FindControl("hlPageLink");
                dynamic pageData = e.Item.DataItem;
                int pageNum = pageData.PageNum;
                bool isCurrent = pageData.IsCurrent;

                hlPageLink.Text = pageNum.ToString();
                hlPageLink.NavigateUrl = $"categoryPage.aspx?id={categoryId}&page={pageNum}";

                HtmlGenericControl liContainer = (HtmlGenericControl)e.Item.FindControl("liPageItem");
                if (isCurrent)
                {
                    liContainer.Attributes["class"] += " active";
                    hlPageLink.Enabled = false;
                }
            }
        }


        // --- Eventพื้นฐาน ---
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

        // --- [เพิ่ม] โค้ดทั้งหมดจาก mainpage/topSalePage สำหรับตะกร้า ---

        // [เพิ่ม] Event Handler สำหรับปุ่มใน Repeater
        protected void Repeater_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "AddToCart")
            {
                // 1. ตรวจสอบการ Login
                if (Session["MemberID"] == null)
                {
                    Response.Redirect($"loginPage.aspx?returnUrl=categoryPage.aspx?id={categoryId}&page={currentPage}"); // [แก้ไข] returnUrl
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
                        int cartId = GetOrCreateCartId(memberId, conn);
                        if (cartId == 0) return;

                        string checkQuery = "SELECT Quantity FROM CartItem WHERE CartID = @CartID AND BookID = @BookID";
                        bool itemExists = false;
                        using (SqlCommand checkCmd = new SqlCommand(checkQuery, conn))
                        {
                            checkCmd.Parameters.AddWithValue("@CartID", cartId);
                            checkCmd.Parameters.AddWithValue("@BookID", bookId);
                            if (checkCmd.ExecuteScalar() != null) itemExists = true;
                        }

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
                    LoadCartCount();
                }
            }
        }

        // [เพิ่ม] Helper: ค้นหา หรือ สร้าง CartID (Non-Static)
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

        // [เพิ่ม] Helper: ค้นหา CartID (สำหรับ Page_Load, ไม่สร้างใหม่)
        private int GetCartId(int memberId)
        {
            int cartId = 0;
            try
            { /* ... (เหมือนเดิม) ... */
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
            catch (Exception ex) { Debug.WriteLine($"Error in GetCartId: {ex.Message}"); }
            return cartId;
        }


        // [เพิ่ม] Helper: ดึงจำนวนสินค้ารวมในตะกร้า (Non-Static)
        private int GetTotalCartQuantity(int cartId)
        {
            int totalQuantity = 0;
            try
            { /* ... (เหมือนเดิม) ... */
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
            catch (Exception ex) { Debug.WriteLine($"Error in GetTotalCartQuantity: {ex.Message}"); }
            return totalQuantity;
        }

        // [เพิ่ม] เมธอดสำหรับโหลดจำนวนสินค้าในตะกร้า (หลัก)
        private void LoadCartCount()
        {
            // ... (เหมือนเดิม) ...
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
        // --- [จบ] โค้ดที่เพิ่ม ---
    }
}
