using System;
using System.Data.SqlClient;
using System.Web.UI;
using System.Diagnostics; // For Debug

namespace OnlineBookStore
{
    public partial class registerPage : System.Web.UI.Page
    {
        // Connection String (Ensure this is correct for your environment)
        private string GetConnectionString()
        {
            return "Data Source=.\\SQLEXPRESS;Initial Catalog=dbOnlineBookStore;Integrated Security=True";
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            // Optional: Add logic if needed on page load (e.g., if user is already logged in)
            if (Session["MemberID"] != null)
            {
                // Optional: Redirect if already logged in
                // Response.Redirect("mainpage.aspx");
            }
        }

        protected void btnRegister_Click(object sender, EventArgs e)
        {
            // Ensure validation controls passed client-side validation
            if (!Page.IsValid)
            {
                // Optional: Add extra logging or handling if server-side validation fails unexpectedly
                return;
            }

            // Get form values
            string fullName = txtFullName.Text.Trim();
            string email = txtEmail.Text.Trim();
            string password = txtPassword.Text; // Password comparison already done by CompareValidator
            string address = txtAddress.Text.Trim();
            string phone = txtPhone.Text.Trim();

            using (SqlConnection conn = new SqlConnection(GetConnectionString()))
            {
                try
                {
                    conn.Open();

                    // 1. Check if email already exists
                    string checkEmailQuery = "SELECT COUNT(*) FROM Member WHERE Email = @Email";
                    using (SqlCommand cmdCheck = new SqlCommand(checkEmailQuery, conn))
                    {
                        cmdCheck.Parameters.AddWithValue("@Email", email);
                        int emailCount = (int)cmdCheck.ExecuteScalar();
                        if (emailCount > 0)
                        {
                            lblMessage.Text = "This email address is already registered.";
                            lblMessage.CssClass = "msg"; // Keep default error style
                            return; // Stop registration
                        }
                    }

                    // 2. Get the next MemberID (MAX + 1 approach based on DDL)
                    // **Warning:** This approach is not safe in high concurrency environments.
                    // An IDENTITY column or GUID is strongly recommended for production.
                    int nextMemberId = 1; // Default if table is empty
                    string getMaxIdQuery = "SELECT ISNULL(MAX(MemberID), 0) FROM Member";
                    using (SqlCommand cmdMaxId = new SqlCommand(getMaxIdQuery, conn))
                    {
                        nextMemberId = (int)cmdMaxId.ExecuteScalar() + 1;
                    }


                    // 3. Insert the new member
                    string insertQuery = @"
                        INSERT INTO Member (MemberID, FullName, Email, Password, Address, Phone, Role)
                        VALUES (@MemberID, @FullName, @Email, @Password, @Address, @Phone, @Role)";

                    using (SqlCommand cmdInsert = new SqlCommand(insertQuery, conn))
                    {
                        cmdInsert.Parameters.AddWithValue("@MemberID", nextMemberId);
                        cmdInsert.Parameters.AddWithValue("@FullName", fullName);
                        cmdInsert.Parameters.AddWithValue("@Email", email);
                        cmdInsert.Parameters.AddWithValue("@Password", password); // Store password (should be hashed in production)

                        // Handle optional fields: Insert DBNull.Value if empty
                        cmdInsert.Parameters.AddWithValue("@Address", string.IsNullOrEmpty(address) ? (object)DBNull.Value : address);
                        cmdInsert.Parameters.AddWithValue("@Phone", string.IsNullOrEmpty(phone) ? (object)DBNull.Value : phone);

                        cmdInsert.Parameters.AddWithValue("@Role", "member"); // Default role

                        int rowsAffected = cmdInsert.ExecuteNonQuery();

                        if (rowsAffected > 0)
                        {
                            // Registration successful
                            // Optional: Clear form or display success message before redirect
                            // Show success message briefly using JavaScript alert or update label temporarily
                            // ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('Registration successful! Please log in.');window.location='loginPage.aspx';", true);

                            // Redirect to login page after successful registration
                            Response.Redirect("loginPage.aspx?registered=true"); // Add query param for optional success message on login page
                        }
                        else
                        {
                            // Insertion failed unexpectedly
                            lblMessage.Text = "Registration failed. Please try again.";
                            lblMessage.CssClass = "msg";
                        }
                    }
                }
                catch (SqlException sqlEx)
                {
                    // Handle specific SQL errors if needed
                    Debug.WriteLine($"SQL Error during registration: {sqlEx.Message}");
                    lblMessage.Text = "Database error during registration. Please contact support.";
                    lblMessage.CssClass = "msg";
                }
                catch (Exception ex)
                {
                    // Handle other potential errors
                    Debug.WriteLine($"General Error during registration: {ex.Message}");
                    lblMessage.Text = "An unexpected error occurred. Please try again later.";
                    lblMessage.CssClass = "msg";
                }
            } // Connection is automatically closed here
        }
    }
}
