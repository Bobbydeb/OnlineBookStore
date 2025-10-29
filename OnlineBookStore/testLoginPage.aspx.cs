using System;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace OnlineBookStore
{
    public partial class testLoginPage : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // You can add any page load logic here if needed
        }

        /// <summary>
        /// Handles the click event of the test login button.
        /// Sets the MemberID in the session and redirects to the main page.
        /// </summary>
        protected void btnTestLogin_Click(object sender, EventArgs e)
        {
            if (!string.IsNullOrEmpty(txtMemberId.Text))
            {
                try
                {
                    // Set the MemberID in the session
                    Session["MemberID"] = Convert.ToInt32(txtMemberId.Text);

                    // Redirect back to the main page
                    Response.Redirect("mainpage.aspx");
                }
                catch (Exception ex)
                {
                    // Handle potential errors (e.g., if user types "abc")
                    // In a real app, show an error message. For testing, we can just log it.
                    System.Diagnostics.Debug.WriteLine("Test Login Error: " + ex.Message);
                }
            }
        }
    }
}
