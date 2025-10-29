using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Linq;
using System.Web.UI.HtmlControls;
using System.Diagnostics; // Added for Debug
using System.Web; // Added for HttpUtility

namespace OnlineBookStore
{
    public partial class searchResultPage : System.Web.UI.Page
    {
        // Use GetConnectionString for consistency
        private string GetConnectionString()
        {
            return "Data Source=.\\SQLEXPRESS;Initial Catalog=dbOnlineBookStore;Integrated Security=True";
        }

        private string searchQuery = "";
        private int currentPage = 1;

        protected void Page_Load(object sender, EventArgs e)
        {
            // Login check
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

            // Get QueryString values
            searchQuery = Request.QueryString["query"];
            if (!int.TryParse(Request.QueryString["page"], out currentPage)) { currentPage = 1; }
            if (currentPage < 1) { currentPage = 1; }

            if (!IsPostBack)
            {
                LoadCartCount(); // Load cart count on initial load

                if (!string.IsNullOrEmpty(searchQuery))
                {
                    litSearchQuery.Text = Server.HtmlEncode(searchQuery);
                    txtSearch.Text = searchQuery; // Populate search box
                    LoadSearchResults(searchQuery);
                }
                else
                {
                    litSearchQuery.Text = "[Search term not specified]";
                    pnlNoResults.Visible = true;
                    pnlPager.Visible = false; // Hide pager if no query
                }
            }
        }

        private void LoadSearchResults(string query)
        {
            int pageSize = 10;
            DataTable dt = new DataTable();
            int totalResults = 0;

            using (SqlConnection con = new SqlConnection(GetConnectionString()))
            {
                try // Added try-catch
                {
                    con.Open();

                    // Count total results
                    string countQuery = @"
                        SELECT COUNT(DISTINCT b.BookID)
                        FROM Book b
                        LEFT JOIN BookAuthor ba ON b.BookID = ba.BookID
                        LEFT JOIN Author a ON ba.AuthorID = a.AuthorID
                        WHERE b.Title LIKE @Query OR a.AuthorName LIKE @Query";

                    using (SqlCommand countCmd = new SqlCommand(countQuery, con))
                    {
                        countCmd.Parameters.AddWithValue("@Query", $"%{query}%");
                        totalResults = (int)countCmd.ExecuteScalar();
                    }

                    if (totalResults > 0)
                    {
                        pnlNoResults.Visible = false;

                        // Fetch paginated results (Added more fields)
                        string sqlQuery = @"
                            SELECT DISTINCT
                                b.BookID, b.Title, b.Edition,
                                c.CategoryName, b.Price,
                                ISNULL(cv.CoverUrl, 'https://raw.githubusercontent.com/Bobbydeb/OnlineBookStore/refs/heads/master/OnlineBookStore/wwwroot/images/00_DefaultBook.jpg') AS CoverUrl,
                                ISNULL(authors.AuthorNames, 'N/A') AS Authors,
                                ISNULL(reviews.AvgRating, 0) AS AvgRating,
                                ISNULL(reviews.ReviewCount, 0) AS ReviewCount
                            FROM Book b
                            LEFT JOIN BookCategory c ON b.CategoryID = c.CategoryID
                            LEFT JOIN Cover cv ON b.CoverID = cv.CoverID
                            LEFT JOIN BookAuthor ba ON b.BookID = ba.BookID
                            LEFT JOIN Author a ON ba.AuthorID = a.AuthorID
                            OUTER APPLY (
                                SELECT STUFF(
                                    (SELECT ', ' + auth.AuthorName
                                     FROM Author auth JOIN BookAuthor ba2 ON auth.AuthorID = ba2.AuthorID
                                     WHERE ba2.BookID = b.BookID FOR XML PATH('')), 1, 2, '')
                            ) AS authors(AuthorNames)
                            OUTER APPLY (
                                SELECT AVG(CAST(r.Rating AS FLOAT)), COUNT(r.ReviewID)
                                FROM Review r WHERE r.BookID = b.BookID
                            ) AS reviews(AvgRating, ReviewCount)
                            WHERE b.Title LIKE @Query OR a.AuthorName LIKE @Query
                            ORDER BY b.Title
                            OFFSET @Offset ROWS FETCH NEXT @PageSize ROWS ONLY;";

                        using (SqlCommand cmd = new SqlCommand(sqlQuery, con))
                        {
                            cmd.Parameters.AddWithValue("@Query", $"%{query}%");
                            cmd.Parameters.AddWithValue("@PageSize", pageSize);
                            cmd.Parameters.AddWithValue("@Offset", (currentPage - 1) * pageSize);

                            using (SqlDataAdapter sda = new SqlDataAdapter(cmd))
                            {
                                sda.Fill(dt);
                            }
                        }

                        rptSearchResults.DataSource = dt;
                        rptSearchResults.DataBind();

                        // Setup Pager
                        int totalPages = (int)Math.Ceiling((double)totalResults / pageSize);
                        if (totalPages > 1)
                        {
                            var pages = Enumerable.Range(1, totalPages);
                            rptPager.DataSource = pages.Select(p => new { PageNum = p, IsCurrent = (p == currentPage) }).ToList();
                            rptPager.DataBind();
                            pnlPager.Visible = true;
                        }
                        else { pnlPager.Visible = false; }
                    }
                    else
                    {
                        // No results found
                        rptSearchResults.DataSource = null;
                        rptSearchResults.DataBind();
                        pnlNoResults.Visible = true;
                        pnlPager.Visible = false;
                    }
                }
                catch (Exception ex)
                {
                    Debug.WriteLine("Error loading search results: " + ex.Message);
                    // Optionally show an error message to the user
                    pnlNoResults.Visible = true;
                    pnlPager.Visible = false;
                    rptSearchResults.DataSource = null;
                    rptSearchResults.DataBind();
                }
            } // Connection closed automatically
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
                hlPageLink.NavigateUrl = $"searchResultPage.aspx?query={Server.UrlEncode(searchQuery)}&page={pageNum}";

                HtmlGenericControl liContainer = (HtmlGenericControl)e.Item.FindControl("liPageItem");
                if (isCurrent)
                {
                    liContainer.Attributes["class"] += " active";
                    hlPageLink.Enabled = false;
                }
            }
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            string query = txtSearch.Text.Trim();
            if (!string.IsNullOrEmpty(query))
            {
                Response.Redirect($"searchResultPage.aspx?query={Server.UrlEncode(query)}&page=1");
            }
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon(); // Use Abandon
            Response.Redirect("mainpage.aspx");
        }

        // --- Add to Cart Functionality (Copied from mainpage.aspx.cs) ---

        protected void Repeater_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "AddToCart")
            {
                if (Session["MemberID"] == null)
                {
                    // Redirect to login, include return URL with search query and page
                    string returnUrl = HttpUtility.UrlEncode($"searchResultPage.aspx?query={Server.UrlEncode(searchQuery)}&page={currentPage}");
                    Response.Redirect($"loginPage.aspx?returnUrl={returnUrl}");
                    return;
                }

                int memberId = Convert.ToInt32(Session["MemberID"]);
                int bookId = Convert.ToInt32(e.CommandArgument);
                int quantity = 1; // Default quantity

                Debug.WriteLine($"Repeater AddToCart called: BookID={bookId}, MemberID={memberId}");

                try
                {
                    using (SqlConnection conn = new SqlConnection(GetConnectionString()))
                    {
                        conn.Open();
                        int cartId = GetOrCreateCartId(memberId, conn);
                        if (cartId == 0)
                        {
                            Debug.WriteLine("AddToCart Error: Failed to get or create CartID.");
                            return; // Maybe show error
                        }

                        // Check if item exists
                        string checkQuery = "SELECT Quantity FROM CartItem WHERE CartID = @CartID AND BookID = @BookID";
                        bool itemExists = false;
                        using (SqlCommand checkCmd = new SqlCommand(checkQuery, conn))
                        {
                            checkCmd.Parameters.AddWithValue("@CartID", cartId);
                            checkCmd.Parameters.AddWithValue("@BookID", bookId);
                            if (checkCmd.ExecuteScalar() != null) itemExists = true;
                        }

                        // Add or Update
                        if (itemExists)
                        {
                            string updateQuery = "UPDATE CartItem SET Quantity = Quantity + @Quantity WHERE CartID = @CartID AND BookID = @BookID";
                            using (SqlCommand updateCmd = new SqlCommand(updateQuery, conn))
                            {
                                updateCmd.Parameters.AddWithValue("@Quantity", quantity);
                                updateCmd.Parameters.AddWithValue("@CartID", cartId);
                                updateCmd.Parameters.AddWithValue("@BookID", bookId);
                                updateCmd.ExecuteNonQuery();
                                Debug.WriteLine($"CartItem updated for BookID {bookId}.");
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
                                Debug.WriteLine($"CartItem inserted for BookID {bookId}.");
                            }
                        }
                    } // Connection closed
                }
                catch (Exception ex)
                {
                    Debug.WriteLine($"Error in AddToCart (Repeater): {ex.Message}");
                    // Show error message?
                }
                finally
                {
                    LoadCartCount(); // Update cart count in header
                }
            }
        }

        private int GetOrCreateCartId(int memberId, SqlConnection conn) // Pass connection
        {
            int cartId = 0;
            string query = "SELECT CartID FROM Cart WHERE MemberID = @MemberID";
            using (SqlCommand cmd = new SqlCommand(query, conn)) // Use passed connection
            {
                cmd.Parameters.AddWithValue("@MemberID", memberId);
                object result = cmd.ExecuteScalar();
                if (result != null && result != DBNull.Value)
                {
                    cartId = Convert.ToInt32(result);
                }
                else
                {
                    // Create new cart if not found
                    string insertQuery = "INSERT INTO Cart (MemberID, CreatedDate) OUTPUT INSERTED.CartID VALUES (@MemberID, GETDATE())";
                    using (SqlCommand insertCmd = new SqlCommand(insertQuery, conn)) // Use passed connection
                    {
                        insertCmd.Parameters.AddWithValue("@MemberID", memberId);
                        try
                        {
                            object insertedId = insertCmd.ExecuteScalar();
                            if (insertedId != null) cartId = Convert.ToInt32(insertedId);
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

        // --- Cart Count Helpers (Copied from mainpage.aspx.cs) ---
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
                    else { ResetCartCountUI(); }
                }
                else { ResetCartCountUI(); }
            }
            else { ResetCartCountUI(); }
        }

        private int GetCartId(int memberId) // Select only version
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
                        if (result != null && result != DBNull.Value) { cartId = Convert.ToInt32(result); }
                    }
                }
            }
            catch (Exception ex) { Debug.WriteLine($"Error in GetCartId (Select): {ex.Message}"); }
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
                        if (result != null && result != DBNull.Value) { totalQuantity = Convert.ToInt32(result); }
                    }
                }
            }
            catch (Exception ex) { Debug.WriteLine($"Error in GetTotalCartQuantity: {ex.Message}"); }
            return totalQuantity;
        }

        private void ResetCartCountUI()
        {
            cartCount.InnerText = "0";
            cartCount.Attributes["class"] = "cart-count empty";
        }
        // --- End Cart Count Helpers ---
    }
}
