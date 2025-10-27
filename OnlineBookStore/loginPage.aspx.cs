using System;
using System.Data.SqlClient;

namespace OnlineBookStore
{
    public partial class loginPage : System.Web.UI.Page
    {
        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string connStr = "Data Source=.;Initial Catalog=dbOnlineBookStore;Integrated Security=True";
            string email = txtEmail.Text.Trim();
            string password = txtPassword.Text.Trim();
            string query =
                "SELECT MemberID, FullName, Role FROM Member " +
                "WHERE Email = @Email AND Password = @Password";

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@Email", email);
                cmd.Parameters.AddWithValue("@Password", password);

                conn.Open();
                SqlDataReader dr = cmd.ExecuteReader();

                if (dr.Read())
                {
                    Session["MemberID"] = dr["MemberID"];
                    Session["FullName"] = dr["FullName"];
                    Session["Role"] = dr["Role"];

                    string role = dr["Role"].ToString().ToLower();
                    if (role == "admin")
                        Response.Redirect("adminDashboard.aspx");
                    else
                        Response.Redirect("mainpage.aspx");
                }
                else
                {
                    lblMessage.Text = "อีเมลหรือรหัสผ่านไม่ถูกต้อง";
                }
            }
        }

    }
}
