using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace OnlineBookStore
{
    public partial class adminPage : System.Web.UI.Page
    {
        private readonly string connStr =
            "Data Source=.\\SQLEXPRESS;Initial Catalog=dbOnlineBookStore;Integrated Security=True";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadBooks();
                LoadAuthors();
                LoadPublishers();
                LoadMembers();
                LoadOrders();
                LoadReviews();

            }
            if (Session["MemberID"] == null)
            {
              
                Response.Write("<script>alert('You are not logged in.');window.location='loginPage.aspx';</script>");
                return;
            }


        }

        #region Load Data Methods

        void LoadBooks()
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                
                string query = @"
                    SELECT 
                        b.BookID, b.ISBN, b.Title, b.Price, b.Stock, b.PublisherID, b.CategoryID,
                        c.CoverUrl
                    FROM Book b
                    LEFT JOIN Cover c ON b.CoverID = c.CoverID
                    ORDER BY b.BookID";
                SqlDataAdapter da = new SqlDataAdapter(query, con);
              

                DataTable dt = new DataTable();
                da.Fill(dt);
                GridViewBooks.DataSource = dt;
                GridViewBooks.DataBind();
            }
        }

        void LoadAuthors()
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                SqlDataAdapter da = new SqlDataAdapter("SELECT AuthorID, AuthorName, Email FROM Author ORDER BY AuthorID", con);
                DataTable dt = new DataTable();
                da.Fill(dt);
                GridViewAuthors.DataSource = dt;
                GridViewAuthors.DataBind();
            }
        }

        void LoadPublishers()
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                SqlDataAdapter da = new SqlDataAdapter("SELECT PublisherID, PublisherName, Address, Phone FROM Publisher ORDER BY PublisherID", con);
                DataTable dt = new DataTable();
                da.Fill(dt);
                GridViewPublishers.DataSource = dt;
                GridViewPublishers.DataBind();
            }
        }

        void LoadMembers()
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                SqlDataAdapter da = new SqlDataAdapter("SELECT MemberID, FullName, Email, Password, Address, Phone, Role FROM Member ORDER BY MemberID", con);
                DataTable dt = new DataTable();
                da.Fill(dt);
                GridViewMembers.DataSource = dt;
                GridViewMembers.DataBind();
            }
        }

        void LoadOrders()
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                SqlDataAdapter da = new SqlDataAdapter("SELECT OrderID, MemberID, OrderDate, TotalAmount, Status FROM OrderTable ORDER BY OrderID ", con);
                DataTable dt = new DataTable();
                da.Fill(dt);
                GridViewOrders.DataSource = dt;
                GridViewOrders.DataBind();
            }
        }

        void LoadReviews()
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                SqlDataAdapter da = new SqlDataAdapter("SELECT ReviewID, MemberID, BookID, Rating, Comment, ReviewDate FROM Review ORDER BY ReviewID", con);
                DataTable dt = new DataTable();
                da.Fill(dt);
                GridViewReviews.DataSource = dt;
                GridViewReviews.DataBind();
            }
        }

        #endregion

        #region Page Index Changing Methods

        protected void GridViewBooks_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            GridViewBooks.PageIndex = e.NewPageIndex;
            LoadBooks();
        }

        protected void GridViewAuthors_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            GridViewAuthors.PageIndex = e.NewPageIndex;
            LoadAuthors();
        }

        protected void GridViewPublishers_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            GridViewPublishers.PageIndex = e.NewPageIndex;
            LoadPublishers();
        }

        protected void GridViewMembers_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            GridViewMembers.PageIndex = e.NewPageIndex;
            LoadMembers();
        }

        protected void GridViewOrders_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            GridViewOrders.PageIndex = e.NewPageIndex;
            LoadOrders();
        }

        protected void GridViewReviews_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            GridViewReviews.PageIndex = e.NewPageIndex;
            LoadReviews();
        }

        #endregion

        #region Generic GridView Edit/Cancel Methods

 
        protected void GridView_RowEditing(object sender, GridViewEditEventArgs e)
        {
            GridView gv = (GridView)sender;
            gv.EditIndex = e.NewEditIndex;
            LoadDataForGridView(gv.ID);  
        }
 
        protected void GridView_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            GridView gv = (GridView)sender;
            gv.EditIndex = -1;
            LoadDataForGridView(gv.ID);  
        }

        
        private void LoadDataForGridView(string gridViewId)
        {
            switch (gridViewId)
            {
                case "GridViewBooks":
                    LoadBooks();
                    break;
                case "GridViewAuthors":
                    LoadAuthors();
                    break;
                case "GridViewPublishers":
                    LoadPublishers();
                    break;
                case "GridViewMembers":
                    LoadMembers();
                    break;
                case "GridViewOrders":
                    LoadOrders();
                    break;
                case "GridViewReviews":
                    LoadReviews();
                    break;
            }
        }

        #endregion

        #region GridView Update Methods

        protected void GridViewBooks_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            try
            {
                GridViewRow row = GridViewBooks.Rows[e.RowIndex];
                int bookID = Convert.ToInt32(GridViewBooks.DataKeys[e.RowIndex].Value);

                // อ่านค่าเป็นสตริงก่อน แล้วแปลงแบบ TryParse เพื่อให้บอกฟิลด์ที่ผิดได้
                string isbn = (row.Cells[2].Controls[0] as TextBox).Text?.Trim();
                string title = (row.Cells[3].Controls[0] as TextBox).Text?.Trim();
                string priceText = (row.Cells[4].Controls[0] as TextBox).Text?.Trim();
                string stockText = (row.Cells[5].Controls[0] as TextBox).Text?.Trim();
                string pubText = (row.Cells[6].Controls[0] as TextBox).Text?.Trim();
                string catText = (row.Cells[7].Controls[0] as TextBox).Text?.Trim();
         
                string coverUrl = (row.Cells[8].Controls[0] as TextBox).Text?.Trim();

                 
                if (string.IsNullOrWhiteSpace(isbn) || isbn.Length != 13) { ShowMessage("ISBN must be 13 characters long.", "error"); return; }
                if (string.IsNullOrWhiteSpace(title)) { ShowMessage("Title cannot be empty.", "error"); return; }

                if (!decimal.TryParse(priceText, out decimal price)) { ShowMessage("Price must be a number.", "error"); return; }
                if (price < 0) { ShowMessage("Price must be 0 or greater.", "error"); return; }

                if (!int.TryParse(stockText, out int stock)) { ShowMessage("Stock must be an integer.", "error"); return; }
                if (stock < 0) { ShowMessage("Stock must be 0 or greater.", "error"); return; }

                if (!int.TryParse(pubText, out int publisherID)) { ShowMessage("PublisherID must be an integer.", "error"); return; }
                if (!int.TryParse(catText, out int categoryID)) { ShowMessage("CategoryID must be an integer.", "error"); return; }


                using (SqlConnection con = new SqlConnection(connStr))
                {
                    con.Open();

                    // FK: PublisherID ต้องมีอยู่จริง
                    using (var cmd = new SqlCommand("SELECT COUNT(*) FROM Publisher WHERE PublisherID=@id", con))
                    {
                        cmd.Parameters.AddWithValue("@id", publisherID);
                     
                        if ((int)cmd.ExecuteScalar() == 0) { ShowMessage("This PublisherID was not found.", "error"); return; }
                    }

                    // FK: CategoryID ต้องมีอยู่จริง
                    using (var cmd = new SqlCommand("SELECT COUNT(*) FROM BookCategory WHERE CategoryID=@id", con))
                    {
                        cmd.Parameters.AddWithValue("@id", categoryID);
                    
                        if ((int)cmd.ExecuteScalar() == 0) { ShowMessage("This CategoryID was not found.", "error"); return; }
                    }

                    // UNIQUE: ISBN ต้องไม่ซ้ำกับเล่มอื่น
                    using (var cmd = new SqlCommand("SELECT COUNT(*) FROM Book WHERE ISBN=@ISBN AND BookID<>@BookID", con))
                    {
                        cmd.Parameters.AddWithValue("@ISBN", isbn);
                        cmd.Parameters.AddWithValue("@BookID", bookID);
                  
                        if ((int)cmd.ExecuteScalar() > 0) { ShowMessage("This ISBN already exists for another book.", "error"); return; }
                    }

                 
                    int? newCoverID = null;

                    // 1. Get  CoverID 
                    int? currentCoverID = null;
                    using (var cmdGetCover = new SqlCommand("SELECT CoverID FROM Book WHERE BookID = @BookID", con))
                    {
                        cmdGetCover.Parameters.AddWithValue("@BookID", bookID);
                        object result = cmdGetCover.ExecuteScalar();
                        if (result != null && result != DBNull.Value)
                        {
                            currentCoverID = Convert.ToInt32(result);
                        }
                    }

                    if (string.IsNullOrWhiteSpace(coverUrl))
                    {
                       
                        newCoverID = null;
                    }
                    else  
                    {
                        if (currentCoverID.HasValue)
                        {
                           
                            using (var cmdUpdateCover = new SqlCommand("UPDATE Cover SET CoverUrl = @CoverUrl WHERE CoverID = @CoverID", con))
                            {
                                cmdUpdateCover.Parameters.AddWithValue("@CoverUrl", coverUrl);
                                cmdUpdateCover.Parameters.AddWithValue("@CoverID", currentCoverID.Value);
                                cmdUpdateCover.ExecuteNonQuery();
                            }
                            newCoverID = currentCoverID;  
                        }
                        else
                        {
                          
                            using (var cmdInsertCover = new SqlCommand("INSERT INTO Cover (CoverUrl) VALUES (@CoverUrl); SELECT SCOPE_IDENTITY();", con))
                            {
                                cmdInsertCover.Parameters.AddWithValue("@CoverUrl", coverUrl);
                                object result = cmdInsertCover.ExecuteScalar();
                                if (result != null && result != DBNull.Value)
                                {
                                    newCoverID = Convert.ToInt32(result);
                                }
                            }
                        }
                    }
              

                    // ผ่านทุกเงื่อนไข ค่อยอัปเดต
                 
                    using (var cmd = new SqlCommand(@"
                UPDATE Book
                SET ISBN=@ISBN, Title=@Title, Price=@Price, Stock=@Stock,
                    PublisherID=@PublisherID, CategoryID=@CategoryID, CoverID=@CoverID
                WHERE BookID=@BookID", con))
                    {
                        cmd.Parameters.AddWithValue("@ISBN", isbn);
                        cmd.Parameters.AddWithValue("@Title", title);
                        cmd.Parameters.AddWithValue("@Price", price);
                        cmd.Parameters.AddWithValue("@Stock", stock);
                        cmd.Parameters.AddWithValue("@PublisherID", publisherID);
                        cmd.Parameters.AddWithValue("@CategoryID", categoryID);

                 
                        if (newCoverID.HasValue)
                        {
                            cmd.Parameters.AddWithValue("@CoverID", newCoverID.Value);
                        }
                        else
                        {
                            cmd.Parameters.AddWithValue("@CoverID", DBNull.Value);
                        }

                        cmd.Parameters.AddWithValue("@BookID", bookID);
                        cmd.ExecuteNonQuery();
                    }
                }

                GridViewBooks.EditIndex = -1;
                LoadBooks();
          
                ShowMessage("Book updated successfully!", "success");
            }
            catch (Exception ex)
            {
                ShowMessage("Error updating book: " + ex.Message, "error");
            }
        }




        protected void GridViewAuthors_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            try
            {
                GridViewRow row = GridViewAuthors.Rows[e.RowIndex];
                int authorID = Convert.ToInt32(GridViewAuthors.DataKeys[e.RowIndex].Value);
                string authorName = (row.Cells[2].Controls[0] as TextBox).Text;
                string email = (row.Cells[3].Controls[0] as TextBox).Text;

                using (SqlConnection con = new SqlConnection(connStr))
                {
                    con.Open();
                    string query = "UPDATE Author SET AuthorName=@AuthorName, Email=@Email WHERE AuthorID=@AuthorID";
                    SqlCommand cmd = new SqlCommand(query, con);
                    cmd.Parameters.AddWithValue("@AuthorName", authorName);
                    cmd.Parameters.AddWithValue("@Email", email);
                    cmd.Parameters.AddWithValue("@AuthorID", authorID);
                    cmd.ExecuteNonQuery();
                }

                GridViewAuthors.EditIndex = -1;
                LoadAuthors();
                ShowMessage("Author updated successfully!", "success");
            }
            catch (Exception ex)
            {
                ShowMessage("Error updating author: " + ex.Message, "error");
            }
        }

        protected void GridViewPublishers_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            try
            {
                GridViewRow row = GridViewPublishers.Rows[e.RowIndex];
                int publisherID = Convert.ToInt32(GridViewPublishers.DataKeys[e.RowIndex].Value);
                string publisherName = (row.Cells[2].Controls[0] as TextBox).Text;
                string address = (row.Cells[3].Controls[0] as TextBox).Text;
                string phone = (row.Cells[4].Controls[0] as TextBox).Text;

                using (SqlConnection con = new SqlConnection(connStr))
                {
                    con.Open();
                    string query = "UPDATE Publisher SET PublisherName=@PublisherName, Address=@Address, Phone=@Phone WHERE PublisherID=@PublisherID";
                    SqlCommand cmd = new SqlCommand(query, con);
                    cmd.Parameters.AddWithValue("@PublisherName", publisherName);
                    cmd.Parameters.AddWithValue("@Address", address);
                    cmd.Parameters.AddWithValue("@Phone", phone);
                    cmd.Parameters.AddWithValue("@PublisherID", publisherID);
                    cmd.ExecuteNonQuery();
                }

                GridViewPublishers.EditIndex = -1;
                LoadPublishers();
                ShowMessage("Publisher updated successfully!", "success");
            }
            catch (Exception ex)
            {
                ShowMessage("Error updating publisher: " + ex.Message, "error");
            }
        }

        protected void GridViewMembers_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            try
            {
                GridViewRow row = GridViewMembers.Rows[e.RowIndex];
                int memberID = Convert.ToInt32(GridViewMembers.DataKeys[e.RowIndex].Value);
                string fullName = (row.Cells[2].Controls[0] as TextBox).Text;
                string email = (row.Cells[3].Controls[0] as TextBox).Text;
          
                string address = (row.Cells[5].Controls[0] as TextBox).Text;
                string phone = (row.Cells[6].Controls[0] as TextBox).Text;
                string role = (row.Cells[7].Controls[0] as TextBox).Text;


                using (SqlConnection con = new SqlConnection(connStr))
                {
                    con.Open();
                    string query = "UPDATE Member SET FullName=@FullName, Email=@Email, Address=@Address, Phone=@Phone, Role=@Role WHERE MemberID=@MemberID";
                    SqlCommand cmd = new SqlCommand(query, con);
                    cmd.Parameters.AddWithValue("@FullName", fullName);
                    cmd.Parameters.AddWithValue("@Email", email);
                    cmd.Parameters.AddWithValue("@Address", address);
                    cmd.Parameters.AddWithValue("@Phone", phone);
                    cmd.Parameters.AddWithValue("@Role", role);
                    cmd.Parameters.AddWithValue("@MemberID", memberID);
                    cmd.ExecuteNonQuery();
                }

                GridViewMembers.EditIndex = -1;
                LoadMembers();
                ShowMessage("Member updated successfully!", "success");
            }
            catch (Exception ex)
            {
                ShowMessage("Error updating member: " + ex.Message, "error");
            }
        }

        protected void GridViewOrders_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            try
            {
                GridViewRow row = GridViewOrders.Rows[e.RowIndex];
                int orderID = Convert.ToInt32(GridViewOrders.DataKeys[e.RowIndex].Value);
      
                string status = (row.Cells[5].Controls[0] as TextBox).Text;

                using (SqlConnection con = new SqlConnection(connStr))
                {
                    con.Open();
                    string query = "UPDATE OrderTable SET Status=@Status WHERE OrderID=@OrderID";
                    SqlCommand cmd = new SqlCommand(query, con);
                    cmd.Parameters.AddWithValue("@Status", status);
                    cmd.Parameters.AddWithValue("@OrderID", orderID);
                    cmd.ExecuteNonQuery();
                }

                GridViewOrders.EditIndex = -1;
                LoadOrders();
                ShowMessage("Order status updated successfully!", "success");
            }
            catch (Exception ex)
            {
                ShowMessage("Error updating order: " + ex.Message, "error");
            }
        }

        protected void GridViewReviews_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            try
            {
                GridViewRow row = GridViewReviews.Rows[e.RowIndex];
                int reviewID = Convert.ToInt32(GridViewReviews.DataKeys[e.RowIndex].Value);
    
                int rating = Convert.ToInt32((row.Cells[4].Controls[0] as TextBox).Text);
                string comment = (row.Cells[5].Controls[0] as TextBox).Text;

                using (SqlConnection con = new SqlConnection(connStr))
                {
                    con.Open();
                    string query = "UPDATE Review SET Rating=@Rating, Comment=@Comment WHERE ReviewID=@ReviewID";
                    SqlCommand cmd = new SqlCommand(query, con);
                    cmd.Parameters.AddWithValue("@Rating", rating);
                    cmd.Parameters.AddWithValue("@Comment", comment);
                    cmd.Parameters.AddWithValue("@ReviewID", reviewID);
                    cmd.ExecuteNonQuery();
                }

                GridViewReviews.EditIndex = -1;
                LoadReviews();
                ShowMessage("Review updated successfully!", "success");
            }
            catch (Exception ex)
            {
                ShowMessage("Error updating review: " + ex.Message, "error");
            }
        }


        #endregion
 
        #region Add New Data Methods

        protected void btnSaveBook_Click(object sender, EventArgs e)
        {
          
            Page.Validate("AddBookValidation");
            if (!Page.IsValid)
            {
                return;  
            }
          

            try
            {
         
                int bookID = Convert.ToInt32(txtAddBookId.Text.Trim());
                string isbn = txtAddBookIsbn.Text.Trim();
                string title = txtAddBookTitle.Text.Trim();
                decimal price = Convert.ToDecimal(txtAddBookPrice.Text.Trim());
                int stock = Convert.ToInt32(txtAddBookStock.Text.Trim());
                int publisherID = Convert.ToInt32(txtAddBookPubId.Text.Trim());
                int categoryID = Convert.ToInt32(txtAddBookCatId.Text.Trim());
                string imageUrl = txtAddBookImageUrl.Text.Trim();

                // 2. ตรวจสอบความถูกต้อง  
            

                using (SqlConnection con = new SqlConnection(connStr))
                {
                    con.Open();

                
                    int? coverID = null; // Use nullable int
                    if (!string.IsNullOrWhiteSpace(imageUrl))
                    {
           
                        using (var cmdCover = new SqlCommand("INSERT INTO Cover (CoverUrl) VALUES (@CoverUrl); SELECT SCOPE_IDENTITY();", con))
                        {
                            cmdCover.Parameters.AddWithValue("@CoverUrl", imageUrl);
                            object result = cmdCover.ExecuteScalar();
                            if (result != null && result != DBNull.Value)
                            {
                                coverID = Convert.ToInt32(result);
                            }
                        }
                    }
                    // --- ▲▲▲ END: New Logic ---

                    // 3. ตรวจสอบ Constraints (PK, Unique, FK)
            
                    // PK: BookID ต้องไม่ซ้ำ
                    using (var cmd = new SqlCommand("SELECT COUNT(*) FROM Book WHERE BookID=@BookID", con))
                    {
                        cmd.Parameters.AddWithValue("@BookID", bookID);
              
                        if ((int)cmd.ExecuteScalar() > 0) { ShowMessage("This BookID already exists.", "error"); return; }
                    }

                    // UNIQUE: ISBN ต้องไม่ซ้ำ
                    using (var cmd = new SqlCommand("SELECT COUNT(*) FROM Book WHERE ISBN=@ISBN", con))
                    {
                        cmd.Parameters.AddWithValue("@ISBN", isbn);
          
                        if ((int)cmd.ExecuteScalar() > 0) { ShowMessage("This ISBN already exists for another book.", "error"); return; }
                    }

                    // FK: PublisherID ต้องมีอยู่จริง
                    using (var cmd = new SqlCommand("SELECT COUNT(*) FROM Publisher WHERE PublisherID=@id", con))
                    {
                        cmd.Parameters.AddWithValue("@id", publisherID);
                  
                        if ((int)cmd.ExecuteScalar() == 0) { ShowMessage("This PublisherID was not found.", "error"); return; }
                    }

                    // FK: CategoryID ต้องมีอยู่จริง
                    using (var cmd = new SqlCommand("SELECT COUNT(*) FROM BookCategory WHERE CategoryID=@id", con))
                    {
                        cmd.Parameters.AddWithValue("@id", categoryID);
                      
                        if ((int)cmd.ExecuteScalar() == 0) { ShowMessage("This CategoryID was not found.", "error"); return; }
                    }

                    // 4. INSERT ข้อมูล
                    using (var cmd = new SqlCommand(@"
                INSERT INTO Book (BookID, ISBN, Title, Price, Stock, PublisherID, CategoryID, CoverID)
                VALUES (@BookID, @ISBN, @Title, @Price, @Stock, @PublisherID, @CategoryID, @CoverID)", con))
                    {
                        cmd.Parameters.AddWithValue("@BookID", bookID);
                        cmd.Parameters.AddWithValue("@ISBN", isbn);
                        cmd.Parameters.AddWithValue("@Title", title);
                        cmd.Parameters.AddWithValue("@Price", price);
                        cmd.Parameters.AddWithValue("@Stock", stock);
                        cmd.Parameters.AddWithValue("@PublisherID", publisherID);
                        cmd.Parameters.AddWithValue("@CategoryID", categoryID);

                        if (coverID.HasValue)
                        {
                            cmd.Parameters.AddWithValue("@CoverID", coverID.Value);
                        }
                        else
                        {
                            cmd.Parameters.AddWithValue("@CoverID", DBNull.Value);
                        }

                        cmd.ExecuteNonQuery();
                    }
                }

                // 5. สั่ง Refresh Grid, แสดงข้อความ, ปิด Modal
                LoadBooks();
              
                ShowMessage("Book added successfully!", "success");
                CloseModal("addBookModal");
                ClearBookModal();
            }
            catch (Exception ex)
            {
                ShowMessage("Error adding book: " + ex.Message, "error");
            }
        }

        protected void btnSaveAuthor_Click(object sender, EventArgs e)
        {
  
            Page.Validate("AddAuthorValidation");
            if (!Page.IsValid)
            {
                return;  
            }
           

            try
            {
                // 1. อ่านค่า (Safely parse)
                int authorID = Convert.ToInt32(txtAddAuthorId.Text.Trim());
                string authorName = txtAddAuthorName.Text.Trim();
                string email = txtAddAuthorEmail.Text.Trim();

                // 2. ตรวจสอบ (REMOVED redundant checks)

                using (SqlConnection con = new SqlConnection(connStr))
                {
                    con.Open();
                    // 3. ตรวจสอบ PK (Business logic - STAYS)
                    using (var cmd = new SqlCommand("SELECT COUNT(*) FROM Author WHERE AuthorID=@AuthorID", con))
                    {
                        cmd.Parameters.AddWithValue("@AuthorID", authorID);
                        // MODIFIED: Translated message
                        if ((int)cmd.ExecuteScalar() > 0) { ShowMessage("This AuthorID already exists.", "error"); return; }
                    }

                    // 4. INSERT
                    string query = "INSERT INTO Author (AuthorID, AuthorName, Email) VALUES (@AuthorID, @AuthorName, @Email)";
                    SqlCommand cmdInsert = new SqlCommand(query, con);
                    cmdInsert.Parameters.AddWithValue("@AuthorID", authorID);
                    cmdInsert.Parameters.AddWithValue("@AuthorName", authorName);
                    cmdInsert.Parameters.AddWithValue("@Email", string.IsNullOrWhiteSpace(email) ? (object)DBNull.Value : email); // Handle optional email
                    cmdInsert.ExecuteNonQuery();
                }

                // 5. Refresh
                LoadAuthors();
              
                ShowMessage("Author added successfully!", "success");
                CloseModal("addAuthorModal");
                ClearAuthorModal();
            }
            catch (Exception ex)
            {
                ShowMessage("Error adding author: " + ex.Message, "error");
            }
        }

        protected void btnSavePublisher_Click(object sender, EventArgs e)
        {
         
            Page.Validate("AddPublisherValidation");
            if (!Page.IsValid)
            {
                return; // Validators will show messages
            }
           

            try
            {
                // 1. อ่านค่า (Safely parse)
                int publisherID = Convert.ToInt32(txtAddPublisherId.Text.Trim());
                string publisherName = txtAddPublisherName.Text.Trim();
                string address = txtAddPublisherAddress.Text.Trim();
                string phone = txtAddPublisherPhone.Text.Trim();

                // 2. ตรวจสอบ (REMOVED redundant checks)

                using (SqlConnection con = new SqlConnection(connStr))
                {
                    con.Open();
                    // 3. ตรวจสอบ PK (Business logic - STAYS)
                    using (var cmd = new SqlCommand("SELECT COUNT(*) FROM Publisher WHERE PublisherID=@PublisherID", con))
                    {
                        cmd.Parameters.AddWithValue("@PublisherID", publisherID);
                   
                        if ((int)cmd.ExecuteScalar() > 0) { ShowMessage("This PublisherID already exists.", "error"); return; }
                    }

                    // 4. INSERT
                    string query = "INSERT INTO Publisher (PublisherID, PublisherName, Address, Phone) VALUES (@PublisherID, @PublisherName, @Address, @Phone)";
                    SqlCommand cmdInsert = new SqlCommand(query, con);
                    cmdInsert.Parameters.AddWithValue("@PublisherID", publisherID);
                    cmdInsert.Parameters.AddWithValue("@PublisherName", publisherName);
                    cmdInsert.Parameters.AddWithValue("@Address", string.IsNullOrWhiteSpace(address) ? (object)DBNull.Value : address);
                    cmdInsert.Parameters.AddWithValue("@Phone", string.IsNullOrWhiteSpace(phone) ? (object)DBNull.Value : phone);
                    cmdInsert.ExecuteNonQuery();
                }

                // 5. Refresh
                LoadPublishers();
          
                ShowMessage("Publisher added successfully!", "success");
                CloseModal("addPublisherModal");
                ClearPublisherModal();
            }
            catch (Exception ex)
            {
                ShowMessage("Error adding publisher: " + ex.Message, "error");
            }
        }

        
        private void ClearBookModal()
        {
            txtAddBookId.Text = "";
            txtAddBookIsbn.Text = "";
            txtAddBookTitle.Text = "";
            txtAddBookPrice.Text = "";
            txtAddBookStock.Text = "";
            txtAddBookPubId.Text = "";
            txtAddBookCatId.Text = "";
            txtAddBookImageUrl.Text = "";
        }

        private void ClearAuthorModal()
        {
            txtAddAuthorId.Text = "";
            txtAddAuthorName.Text = "";
            txtAddAuthorEmail.Text = "";
        }

        private void ClearPublisherModal()
        {
            txtAddPublisherId.Text = "";
            txtAddPublisherName.Text = "";
            txtAddPublisherAddress.Text = "";
            txtAddPublisherPhone.Text = "";
        }

        #endregion
       
        


        #region GridView Delete Methods

        protected void GridViewBooks_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            try
            {
                int bookID = Convert.ToInt32(GridViewBooks.DataKeys[e.RowIndex].Value);
                using (SqlConnection con = new SqlConnection(connStr))
                {
                    con.Open();
                 
                    SqlCommand cmdLink = new SqlCommand("DELETE FROM BookAuthor WHERE BookID=@BookID", con);
                    cmdLink.Parameters.AddWithValue("@BookID", bookID);
                    cmdLink.ExecuteNonQuery();

                  
                    SqlCommand cmdDetail = new SqlCommand("DELETE FROM OrderDetail WHERE BookID=@BookID", con);
                    cmdDetail.Parameters.AddWithValue("@BookID", bookID);
                    cmdDetail.ExecuteNonQuery();

                    SqlCommand cmdReview = new SqlCommand("DELETE FROM Review WHERE BookID=@BookID", con);
                    cmdReview.Parameters.AddWithValue("@BookID", bookID);
                    cmdReview.ExecuteNonQuery();
 
                    SqlCommand cmd = new SqlCommand("DELETE FROM Book WHERE BookID=@BookID", con);
                    cmd.Parameters.AddWithValue("@BookID", bookID);
                    cmd.ExecuteNonQuery();
                }
                LoadBooks();
                ShowMessage("Book deleted successfully!", "success");
            }
            catch (Exception ex)
            {
                ShowMessage("Error deleting book: " + ex.Message, "error");
            }
        }

        protected void GridViewAuthors_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            try
            {
                int authorID = Convert.ToInt32(GridViewAuthors.DataKeys[e.RowIndex].Value);
                using (SqlConnection con = new SqlConnection(connStr))
                {
                    con.Open();
 
                    SqlCommand cmdLink = new SqlCommand("DELETE FROM BookAuthor WHERE AuthorID=@AuthorID", con);
                    cmdLink.Parameters.AddWithValue("@AuthorID", authorID);
                    cmdLink.ExecuteNonQuery();

       
                    SqlCommand cmd = new SqlCommand("DELETE FROM Author WHERE AuthorID=@AuthorID", con);
                    cmd.Parameters.AddWithValue("@AuthorID", authorID);
                    cmd.ExecuteNonQuery();
                }
                LoadAuthors();
                ShowMessage("Author deleted successfully!", "success");
            }
            catch (Exception ex)
            {
                ShowMessage("Error deleting author: " + ex.Message, "error");
            }
        }

        protected void GridViewPublishers_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            try
            {
                int publisherID = Convert.ToInt32(GridViewPublishers.DataKeys[e.RowIndex].Value);
                using (SqlConnection con = new SqlConnection(connStr))
                {
                    con.Open();
      
                    SqlCommand cmd = new SqlCommand("DELETE FROM Publisher WHERE PublisherID=@PublisherID", con);
                    cmd.Parameters.AddWithValue("@PublisherID", publisherID);
                    cmd.ExecuteNonQuery();
                }
                LoadPublishers();
                ShowMessage("Publisher deleted successfully!", "success");
            }
            catch (Exception ex)
            {
       
                ShowMessage("Cannot delete publisher. It is still in use by one or more books.", "error");

            }
        }

        protected void GridViewMembers_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            try
            {
                int memberID = Convert.ToInt32(GridViewMembers.DataKeys[e.RowIndex].Value);
                using (SqlConnection con = new SqlConnection(connStr))
                {
                    con.Open();
      
                    SqlCommand cmdReview = new SqlCommand("DELETE FROM Review WHERE MemberID=@MemberID", con);
                    cmdReview.Parameters.AddWithValue("@MemberID", memberID);
                    cmdReview.ExecuteNonQuery();

    

                    SqlCommand cmd = new SqlCommand("DELETE FROM Member WHERE MemberID=@MemberID", con);
                    cmd.Parameters.AddWithValue("@MemberID", memberID);
                    cmd.ExecuteNonQuery();
                }
                LoadMembers();
                ShowMessage("Member deleted successfully!", "success");
            }
            catch (Exception ex)
            {
      
                ShowMessage("Cannot delete member. Orders are still associated with this member. You must delete those orders first.", "error");
            }
        }

        protected void GridViewOrders_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            try
            {
                int orderID = Convert.ToInt32(GridViewOrders.DataKeys[e.RowIndex].Value);
                using (SqlConnection con = new SqlConnection(connStr))
                {
                    con.Open();
         
                    SqlCommand cmdDetail = new SqlCommand("DELETE FROM OrderDetail WHERE OrderID=@OrderID", con);
                    cmdDetail.Parameters.AddWithValue("@OrderID", orderID);
                    cmdDetail.ExecuteNonQuery();
 
                    SqlCommand cmd = new SqlCommand("DELETE FROM OrderTable WHERE OrderID=@OrderID", con);
                    cmd.Parameters.AddWithValue("@OrderID", orderID);
                    cmd.ExecuteNonQuery();
                }
                LoadOrders();
                ShowMessage("Order deleted successfully!", "success");
            }
            catch (Exception ex)
            {
                ShowMessage("Error deleting order: " + ex.Message, "error");
            }
        }

        protected void GridViewReviews_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            try
            {
                int reviewID = Convert.ToInt32(GridViewReviews.DataKeys[e.RowIndex].Value);
                using (SqlConnection con = new SqlConnection(connStr))
                {
                    con.Open();
                    SqlCommand cmd = new SqlCommand("DELETE FROM Review WHERE ReviewID=@ReviewID", con);
                    cmd.Parameters.AddWithValue("@ReviewID", reviewID);
                    cmd.ExecuteNonQuery();
                }
                LoadReviews();
                ShowMessage("Review deleted successfully!", "success");
            }
            catch (Exception ex)
            {
                ShowMessage("Error deleting review: " + ex.Message, "error");
            }
        }

        #endregion

        #region Notification Helper

        /// <summary>
        /// Shows a non-blocking notification message on the screen.
        /// </summary>
        /// <param name="message">The message to display.</param>
        /// <param name="type">'success' or 'error'</param>
        private void ShowMessage(string message, string type)
        {
    
            string cleanMessage = message.Replace("'", "\\'").Replace("\r", "\\r").Replace("\n", "\\n");
            string script = $"showMessage('{cleanMessage}', '{type}');";

            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "ShowMessage", script, true);
        }

      
        /// <summary>
        /// 
        /// </summary>
        /// <param name="modalId">The ClientID of the modal div.</param>
        private void CloseModal(string modalId)
        {

            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "CloseModal", $"hideModal('{modalId}');", true);
        }
        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Response.Redirect("mainpage.aspx");
        }
        

        #endregion
    }
}
