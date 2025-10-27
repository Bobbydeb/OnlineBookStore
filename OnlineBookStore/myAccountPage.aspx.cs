using System;
using System.Web.UI;

namespace OnlineBookStore
{
    public partial class myAccountPage : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // ถ้ายังไม่ได้ login ให้กลับไปหน้า login
            if (Session["MemberID"] == null)
            {
                Response.Write("<script>alert('คุณยังไม่ได้ login');window.location='loginPage.aspx';</script>");
                return;
            }

            // ถ้า login แล้ว แสดงชื่อ และสลับปุ่ม
 
            btnLogin.Visible = false;
            btnLogout.Visible = true;
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Response.Redirect("mainpage.aspx");
        }
    }
}
