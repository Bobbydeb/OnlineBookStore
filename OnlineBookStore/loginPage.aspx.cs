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
                "SELECT MemberID, FullName FROM Member " +
                "WHERE Email = '" + email + "' AND Password = '" + password + "'";

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand(query, conn);
                conn.Open();
                SqlDataReader dr = cmd.ExecuteReader();

                if (dr.Read())
                {
                    Session["MemberID"] = dr["MemberID"];
                    Session["FullName"] = dr["FullName"];
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
