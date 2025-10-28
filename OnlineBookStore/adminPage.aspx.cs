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
                Response.Write("<script>alert('คุณยังไม่ได้ login');window.location='loginPage.aspx';</script>");
                return;
            }


        }

        #region Load Data Methods

        void LoadBooks()
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                SqlDataAdapter da = new SqlDataAdapter("SELECT BookID, ISBN, Title, Price, Stock, PublisherID, CategoryID FROM Book ORDER BY BookID", con);
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
                SqlDataAdapter da = new SqlDataAdapter("SELECT OrderID, MemberID, OrderDate, TotalAmount, Status FROM OrderTable ORDER BY OrderID DESC", con);
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
                SqlDataAdapter da = new SqlDataAdapter("SELECT ReviewID, MemberID, BookID, Rating, Comment, ReviewDate FROM Review ORDER BY ReviewID DESC", con);
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

        /// <summary>
        /// Handles the RowEditing event for ALL GridViews.
        /// </summary>
        protected void GridView_RowEditing(object sender, GridViewEditEventArgs e)
        {
            GridView gv = (GridView)sender;
            gv.EditIndex = e.NewEditIndex;
            LoadDataForGridView(gv.ID); // Reload data for the specific grid
        }

        /// <summary>
        /// Handles the RowCancelingEdit event for ALL GridViews.
        /// </summary>
        protected void GridView_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            GridView gv = (GridView)sender;
            gv.EditIndex = -1;
            LoadDataForGridView(gv.ID); // Reload data for the specific grid
        }

        /// <summary>
        /// Helper to reload data for the correct GridView.
        /// </summary>
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

                // ตรวจความถูกต้องตามคอลัมน์
                if (string.IsNullOrWhiteSpace(isbn) || isbn.Length != 13) { ShowMessage("ISBN ต้องยาว 13 ตัวอักษร", "error"); return; }
                if (string.IsNullOrWhiteSpace(title)) { ShowMessage("Title ห้ามว่าง", "error"); return; }

                if (!decimal.TryParse(priceText, out decimal price)) { ShowMessage("Price ต้องเป็นตัวเลข", "error"); return; }
                if (price < 0) { ShowMessage("ราคาต้องมีค่ามากกว่าหรือเท่ากับ 0", "error"); return; }

                if (!int.TryParse(stockText, out int stock)) { ShowMessage("Stock ต้องเป็นจำนวนเต็ม", "error"); return; }
                if (stock < 0) { ShowMessage("Stock หนังสือต้องมีค่ามากกว่าหรือเท่ากับ 0", "error"); return; }

                if (!int.TryParse(pubText, out int publisherID)) { ShowMessage("PublisherID ต้องเป็นจำนวนเต็ม", "error"); return; }
                if (!int.TryParse(catText, out int categoryID)) { ShowMessage("CategoryID ต้องเป็นจำนวนเต็ม", "error"); return; }

                using (SqlConnection con = new SqlConnection(connStr))
                {
                    con.Open();

                    // FK: PublisherID ต้องมีอยู่จริง
                    using (var cmd = new SqlCommand("SELECT COUNT(*) FROM Publisher WHERE PublisherID=@id", con))
                    {
                        cmd.Parameters.AddWithValue("@id", publisherID);
                        if ((int)cmd.ExecuteScalar() == 0) { ShowMessage("ไม่พบ PublisherID นี้", "error"); return; }
                    }

                    // FK: CategoryID ต้องมีอยู่จริง
                    using (var cmd = new SqlCommand("SELECT COUNT(*) FROM BookCategory WHERE CategoryID=@id", con))
                    {
                        cmd.Parameters.AddWithValue("@id", categoryID);
                        if ((int)cmd.ExecuteScalar() == 0) { ShowMessage("ไม่พบ CategoryID นี้", "error"); return; }
                    }

                    // UNIQUE: ISBN ต้องไม่ซ้ำกับเล่มอื่น
                    using (var cmd = new SqlCommand("SELECT COUNT(*) FROM Book WHERE ISBN=@ISBN AND BookID<>@BookID", con))
                    {
                        cmd.Parameters.AddWithValue("@ISBN", isbn);
                        cmd.Parameters.AddWithValue("@BookID", bookID);
                        if ((int)cmd.ExecuteScalar() > 0) { ShowMessage("ISBN ซ้ำกับหนังสือเล่มอื่น", "error"); return; }
                    }

                    // ผ่านทุกเงื่อนไข ค่อยอัปเดต
                    using (var cmd = new SqlCommand(@"
                UPDATE Book
                SET ISBN=@ISBN, Title=@Title, Price=@Price, Stock=@Stock,
                    PublisherID=@PublisherID, CategoryID=@CategoryID
                WHERE BookID=@BookID", con))
                    {
                        cmd.Parameters.AddWithValue("@ISBN", isbn);
                        cmd.Parameters.AddWithValue("@Title", title);
                        cmd.Parameters.AddWithValue("@Price", price);
                        cmd.Parameters.AddWithValue("@Stock", stock);
                        cmd.Parameters.AddWithValue("@PublisherID", publisherID);
                        cmd.Parameters.AddWithValue("@CategoryID", categoryID);
                        cmd.Parameters.AddWithValue("@BookID", bookID);
                        cmd.ExecuteNonQuery();
                    }
                }

                GridViewBooks.EditIndex = -1;
                LoadBooks();
                ShowMessage("อัปเดตข้อมูลหนังสือสำเร็จ", "success");
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
                // Password (Cell 4) is ReadOnly, so we don't update it.
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
                // Other fields are ReadOnly
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
                // Other fields are ReadOnly
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

        // ===================================================================
        // ========== ADDED: New Methods for Add Buttons ==========
        // ===================================================================
        #region Add New Data Methods

        protected void btnSaveBook_Click(object sender, EventArgs e)
        {
            try
            {
                // 1. อ่านค่าจาก Modal TextBoxes
                string bookIdText = txtAddBookId.Text.Trim();
                string isbn = txtAddBookIsbn.Text.Trim();
                string title = txtAddBookTitle.Text.Trim();
                string priceText = txtAddBookPrice.Text.Trim();
                string stockText = txtAddBookStock.Text.Trim();
                string pubText = txtAddBookPubId.Text.Trim();
                string catText = txtAddBookCatId.Text.Trim();

                // 2. ตรวจสอบความถูกต้อง
                if (!int.TryParse(bookIdText, out int bookID)) { ShowMessage("BookID ต้องเป็นตัวเลข", "error"); return; }
                if (string.IsNullOrWhiteSpace(isbn) || isbn.Length != 13) { ShowMessage("ISBN ต้องยาว 13 ตัวอักษร", "error"); return; }
                if (string.IsNullOrWhiteSpace(title)) { ShowMessage("Title ห้ามว่าง", "error"); return; }
                if (!decimal.TryParse(priceText, out decimal price)) { ShowMessage("Price ต้องเป็นตัวเลข", "error"); return; }
                if (price < 0) { ShowMessage("ราคาต้องมีค่ามากกว่าหรือเท่ากับ 0", "error"); return; }
                if (!int.TryParse(stockText, out int stock)) { ShowMessage("Stock ต้องเป็นจำนวนเต็ม", "error"); return; }
                if (stock < 0) { ShowMessage("Stock หนังสือต้องมีค่ามากกว่าหรือเท่ากับ 0", "error"); return; }
                if (!int.TryParse(pubText, out int publisherID)) { ShowMessage("PublisherID ต้องเป็นจำนวนเต็ม", "error"); return; }
                if (!int.TryParse(catText, out int categoryID)) { ShowMessage("CategoryID ต้องเป็นจำนวนเต็ม", "error"); return; }

                using (SqlConnection con = new SqlConnection(connStr))
                {
                    con.Open();

                    // 3. ตรวจสอบ Constraints (PK, Unique, FK)
                    // PK: BookID ต้องไม่ซ้ำ
                    using (var cmd = new SqlCommand("SELECT COUNT(*) FROM Book WHERE BookID=@BookID", con))
                    {
                        cmd.Parameters.AddWithValue("@BookID", bookID);
                        if ((int)cmd.ExecuteScalar() > 0) { ShowMessage("BookID นี้มีอยู่แล้ว", "error"); return; }
                    }

                    // UNIQUE: ISBN ต้องไม่ซ้ำ
                    using (var cmd = new SqlCommand("SELECT COUNT(*) FROM Book WHERE ISBN=@ISBN", con))
                    {
                        cmd.Parameters.AddWithValue("@ISBN", isbn);
                        if ((int)cmd.ExecuteScalar() > 0) { ShowMessage("ISBN นี้ซ้ำกับหนังสือเล่มอื่น", "error"); return; }
                    }

                    // FK: PublisherID ต้องมีอยู่จริง
                    using (var cmd = new SqlCommand("SELECT COUNT(*) FROM Publisher WHERE PublisherID=@id", con))
                    {
                        cmd.Parameters.AddWithValue("@id", publisherID);
                        if ((int)cmd.ExecuteScalar() == 0) { ShowMessage("ไม่พบ PublisherID นี้", "error"); return; }
                    }

                    // FK: CategoryID ต้องมีอยู่จริง
                    using (var cmd = new SqlCommand("SELECT COUNT(*) FROM BookCategory WHERE CategoryID=@id", con))
                    {
                        cmd.Parameters.AddWithValue("@id", categoryID);
                        if ((int)cmd.ExecuteScalar() == 0) { ShowMessage("ไม่พบ CategoryID นี้", "error"); return; }
                    }

                    // 4. INSERT ข้อมูล
                    using (var cmd = new SqlCommand(@"
                INSERT INTO Book (BookID, ISBN, Title, Price, Stock, PublisherID, CategoryID)
                VALUES (@BookID, @ISBN, @Title, @Price, @Stock, @PublisherID, @CategoryID)", con))
                    {
                        cmd.Parameters.AddWithValue("@BookID", bookID);
                        cmd.Parameters.AddWithValue("@ISBN", isbn);
                        cmd.Parameters.AddWithValue("@Title", title);
                        cmd.Parameters.AddWithValue("@Price", price);
                        cmd.Parameters.AddWithValue("@Stock", stock);
                        cmd.Parameters.AddWithValue("@PublisherID", publisherID);
                        cmd.Parameters.AddWithValue("@CategoryID", categoryID);
                        cmd.ExecuteNonQuery();
                    }
                }

                // 5. สั่ง Refresh Grid, แสดงข้อความ, ปิด Modal
                LoadBooks();
                ShowMessage("เพิ่มหนังสือสำเร็จ", "success");
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
            try
            {
                // 1. อ่านค่า
                string authorIdText = txtAddAuthorId.Text.Trim();
                string authorName = txtAddAuthorName.Text.Trim();
                string email = txtAddAuthorEmail.Text.Trim();

                // 2. ตรวจสอบ
                if (!int.TryParse(authorIdText, out int authorID)) { ShowMessage("AuthorID ต้องเป็นตัวเลข", "error"); return; }
                if (string.IsNullOrWhiteSpace(authorName)) { ShowMessage("Author Name ห้ามว่าง", "error"); return; }

                using (SqlConnection con = new SqlConnection(connStr))
                {
                    con.Open();
                    // 3. ตรวจสอบ PK
                    using (var cmd = new SqlCommand("SELECT COUNT(*) FROM Author WHERE AuthorID=@AuthorID", con))
                    {
                        cmd.Parameters.AddWithValue("@AuthorID", authorID);
                        if ((int)cmd.ExecuteScalar() > 0) { ShowMessage("AuthorID นี้มีอยู่แล้ว", "error"); return; }
                    }

                    // 4. INSERT
                    string query = "INSERT INTO Author (AuthorID, AuthorName, Email) VALUES (@AuthorID, @AuthorName, @Email)";
                    SqlCommand cmdInsert = new SqlCommand(query, con);
                    cmdInsert.Parameters.AddWithValue("@AuthorID", authorID);
                    cmdInsert.Parameters.AddWithValue("@AuthorName", authorName);
                    cmdInsert.Parameters.AddWithValue("@Email", email);
                    cmdInsert.ExecuteNonQuery();
                }

                // 5. Refresh
                LoadAuthors();
                ShowMessage("เพิ่มผู้แต่งสำเร็จ", "success");
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
            try
            {
                // 1. อ่านค่า
                string publisherIdText = txtAddPublisherId.Text.Trim();
                string publisherName = txtAddPublisherName.Text.Trim();
                string address = txtAddPublisherAddress.Text.Trim();
                string phone = txtAddPublisherPhone.Text.Trim();

                // 2. ตรวจสอบ
                if (!int.TryParse(publisherIdText, out int publisherID)) { ShowMessage("PublisherID ต้องเป็นตัวเลข", "error"); return; }
                if (string.IsNullOrWhiteSpace(publisherName)) { ShowMessage("Publisher Name ห้ามว่าง", "error"); return; }

                using (SqlConnection con = new SqlConnection(connStr))
                {
                    con.Open();
                    // 3. ตรวจสอบ PK
                    using (var cmd = new SqlCommand("SELECT COUNT(*) FROM Publisher WHERE PublisherID=@PublisherID", con))
                    {
                        cmd.Parameters.AddWithValue("@PublisherID", publisherID);
                        if ((int)cmd.ExecuteScalar() > 0) { ShowMessage("PublisherID นี้มีอยู่แล้ว", "error"); return; }
                    }

                    // 4. INSERT
                    string query = "INSERT INTO Publisher (PublisherID, PublisherName, Address, Phone) VALUES (@PublisherID, @PublisherName, @Address, @Phone)";
                    SqlCommand cmdInsert = new SqlCommand(query, con);
                    cmdInsert.Parameters.AddWithValue("@PublisherID", publisherID);
                    cmdInsert.Parameters.AddWithValue("@PublisherName", publisherName);
                    cmdInsert.Parameters.AddWithValue("@Address", address);
                    cmdInsert.Parameters.AddWithValue("@Phone", phone);
                    cmdInsert.ExecuteNonQuery();
                }

                // 5. Refresh
                LoadPublishers();
                ShowMessage("เพิ่มสำนักพิมพ์สำเร็จ", "success");
                CloseModal("addPublisherModal");
                ClearPublisherModal();
            }
            catch (Exception ex)
            {
                ShowMessage("Error adding publisher: " + ex.Message, "error");
            }
        }

        // Helpers for clearing modal textboxes
        private void ClearBookModal()
        {
            txtAddBookId.Text = "";
            txtAddBookIsbn.Text = "";
            txtAddBookTitle.Text = "";
            txtAddBookPrice.Text = "";
            txtAddBookStock.Text = "";
            txtAddBookPubId.Text = "";
            txtAddBookCatId.Text = "";
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
        // ===================================================================
        // ===================================================================


        #region GridView Delete Methods

        protected void GridViewBooks_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            try
            {
                int bookID = Convert.ToInt32(GridViewBooks.DataKeys[e.RowIndex].Value);
                using (SqlConnection con = new SqlConnection(connStr))
                {
                    con.Open();
                    // Must delete from linking tables first
                    SqlCommand cmdLink = new SqlCommand("DELETE FROM BookAuthor WHERE BookID=@BookID", con);
                    cmdLink.Parameters.AddWithValue("@BookID", bookID);
                    cmdLink.ExecuteNonQuery();

                    // Must delete from dependent tables first (e.g., OrderDetail, Review)
                    SqlCommand cmdDetail = new SqlCommand("DELETE FROM OrderDetail WHERE BookID=@BookID", con);
                    cmdDetail.Parameters.AddWithValue("@BookID", bookID);
                    cmdDetail.ExecuteNonQuery();

                    SqlCommand cmdReview = new SqlCommand("DELETE FROM Review WHERE BookID=@BookID", con);
                    cmdReview.Parameters.AddWithValue("@BookID", bookID);
                    cmdReview.ExecuteNonQuery();

                    // Now delete the book
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
                    // Must delete from linking table first
                    SqlCommand cmdLink = new SqlCommand("DELETE FROM BookAuthor WHERE AuthorID=@AuthorID", con);
                    cmdLink.Parameters.AddWithValue("@AuthorID", authorID);
                    cmdLink.ExecuteNonQuery();

                    // Now delete the author
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
                    // NOTE: This will fail if any book still uses this publisher.
                    // A better approach would be to check first, or set books' PublisherID to NULL.
                    // For simplicity, we just try to delete.
                    SqlCommand cmd = new SqlCommand("DELETE FROM Publisher WHERE PublisherID=@PublisherID", con);
                    cmd.Parameters.AddWithValue("@PublisherID", publisherID);
                    cmd.ExecuteNonQuery();
                }
                LoadPublishers();
                ShowMessage("Publisher deleted successfully!", "success");
            }
            catch (Exception ex)
            {
                ShowMessage("ไม่สามารถลบสำนักพิมพ์ได้ เนื่องจากยังมีหนังสือที่ใช้สำนักพิมพ์นี้อยู่", "error");

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
                    // NOTE: This will fail if any order/review still uses this member.
                    // You must delete dependent records first.
                    SqlCommand cmdReview = new SqlCommand("DELETE FROM Review WHERE MemberID=@MemberID", con);
                    cmdReview.Parameters.AddWithValue("@MemberID", memberID);
                    cmdReview.ExecuteNonQuery();

                    // This is complex. Deleting orders might not be desirable.
                    // For now, we'll just show the error if it fails.
                    // A better way is to set the member to "inactive" instead of deleting.

                    SqlCommand cmd = new SqlCommand("DELETE FROM Member WHERE MemberID=@MemberID", con);
                    cmd.Parameters.AddWithValue("@MemberID", memberID);
                    cmd.ExecuteNonQuery();
                }
                LoadMembers();
                ShowMessage("Member deleted successfully!", "success");
            }
            catch (Exception ex)
            {
                ShowMessage("ไม่สามารถลบสมาชิกได้ เนื่องจากมีคำสั่งซื้อที่เชื่อมอยู่กับสมาชิกนี้ คุณต้องลบคำสังซื้อเหล่านั้นก่อน", "error");
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
                    // Must delete from OrderDetail first
                    SqlCommand cmdDetail = new SqlCommand("DELETE FROM OrderDetail WHERE OrderID=@OrderID", con);
                    cmdDetail.Parameters.AddWithValue("@OrderID", orderID);
                    cmdDetail.ExecuteNonQuery();

                    // Now delete the order
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
            // Cleans the message for JavaScript
            string cleanMessage = message.Replace("'", "\\'").Replace("\r", "\\r").Replace("\n", "\\n");
            string script = $"showMessage('{cleanMessage}', '{type}');";

            // Registers the script to run on the page
            // We use this.Page as the control so it works from within an UpdatePanel
            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "ShowMessage", script, true);
        }

        // ========== ADDED: Helper to close modal from server-side ==========
        /// <summary>
        /// Registers script to close a Bootstrap modal.
        /// </summary>
        /// <param name="modalId">The ClientID of the modal div.</param>
        private void CloseModal(string modalId)
        {
            // We need to get the ClientID of the modal, but since we used static IDs in the HTML,
            // we can just pass the string. If you used runat=server on the modal, you'd use modal.ClientID.
            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "CloseModal", $"hideModal('{modalId}');", true);
        }
        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Response.Redirect("mainpage.aspx");
        }
        // ===================================================================

        #endregion
    }
}