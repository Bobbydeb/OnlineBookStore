using System;
using System.Data.SqlClient;
using System.Web.UI;

namespace OnlineBookStore
{
    public partial class myAccountPage : System.Web.UI.Page
    {
        // Connection string (จากไฟล์เดิม)
        private readonly string connStr =
            "Data Source=.\\SQLEXPRESS;Initial Catalog=dbOnlineBookStore;Integrated Security=True";

        protected void Page_Load(object sender, EventArgs e)
        {
            // ถ้ายังไม่ได้ login ให้กลับไปหน้า login
            if (Session["MemberID"] == null)
            {
                Response.Write("<script>alert('คุณยังไม่ได้ login');window.location='loginPage.aspx';</script>");
                return;
            }

            // ถ้า login แล้ว สลับปุ่ม
            btnLogin.Visible = false;
            btnLogout.Visible = true;

            if (!IsPostBack)
            {
                // ถ้าเป็นการโหลดหน้าครั้งแรก ให้ดึงข้อมูลสมาชิกมาแสดง
                LoadMemberData();
            }
        }

        /// <summary>
        /// ดึงข้อมูลสมาชิกจากฐานข้อมูลมาเติมใน TextBoxes
        /// </summary>
        private void LoadMemberData()
        {
            lblProfileMessage.Text = "";
            lblPasswordMessage.Text = "";
            string memberID = Session["MemberID"].ToString();

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = "SELECT FullName, Email, Address, Phone FROM Member WHERE MemberID = @MemberID";
                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@MemberID", memberID);

                try
                {
                    conn.Open();
                    SqlDataReader reader = cmd.ExecuteReader();
                    if (reader.Read())
                    {
                        txtFullName.Text = reader["FullName"].ToString();
                        txtEmail.Text = reader["Email"].ToString();
                        txtAddress.Text = reader["Address"].ToString();
                        txtPhone.Text = reader["Phone"].ToString();

                        // แสดงชื่อผู้ใช้ (ตามโค้ดเดิม)
                        lblUserInfo.Text = "สวัสดีคุณ, " + reader["FullName"].ToString();
                    }
                    reader.Close();
                }
                catch (Exception ex)
                {
                    lblProfileMessage.Text = "เกิดข้อผิดพลาดในการโหลดข้อมูล: " + ex.Message;
                    lblProfileMessage.CssClass = "message-label message-error";
                }
            }
        }

        /// <summary>
        /// คลิกปุ่ม Logout
        /// </summary>
        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Response.Redirect("mainpage.aspx");
        }

        /// <summary>
        /// คลิกปุ่ม "แก้ไขข้อมูล"
        /// </summary>
        protected void btnEditProfile_Click(object sender, EventArgs e)
        {
            // เปิดโหมดแก้ไข
            SetProfileEditMode(true);
            lblProfileMessage.Text = "";
        }

        /// <summary>
        /// คลิกปุ่ม "ยกเลิก" การแก้ไข
        /// </summary>
        protected void btnCancelEdit_Click(object sender, EventArgs e)
        {
            // ปิดโหมดแก้ไข
            SetProfileEditMode(false);
            // โหลดข้อมูลเดิมกลับมา (ถ้ามีการเปลี่ยนแปลงในช่อง)
            LoadMemberData();
        }

        /// <summary>
        /// คลิกปุ่ม "บันทึก" ข้อมูลส่วนตัว
        /// </summary>
        protected void btnSaveProfile_Click(object sender, EventArgs e)
        {
            // ตรวจสอบความถูกต้องของข้อมูล (ValidationGroup="Profile")
            if (!Page.IsValid)
            {
                return;
            }

            string memberID = Session["MemberID"].ToString();

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = "UPDATE Member SET FullName = @FullName, Email = @Email, Address = @Address, Phone = @Phone " +
                             "WHERE MemberID = @MemberID";
                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@FullName", txtFullName.Text.Trim());
                cmd.Parameters.AddWithValue("@Email", txtEmail.Text.Trim());
                cmd.Parameters.AddWithValue("@Address", txtAddress.Text.Trim());
                cmd.Parameters.AddWithValue("@Phone", txtPhone.Text.Trim());
                cmd.Parameters.AddWithValue("@MemberID", memberID);

                try
                {
                    conn.Open();
                    int rowsAffected = cmd.ExecuteNonQuery();
                    if (rowsAffected > 0)
                    {
                        lblProfileMessage.Text = "บันทึกข้อมูลส่วนตัวเรียบร้อยแล้ว";
                        lblProfileMessage.CssClass = "message-label message-success";
                        // ปิดโหมดแก้ไข
                        SetProfileEditMode(false);
                        // อัปเดตชื่อที่แสดง
                        lblUserInfo.Text = "สวัสดีคุณ, " + txtFullName.Text.Trim();
                    }
                    else
                    {
                        lblProfileMessage.Text = "ไม่สามารถบันทึกข้อมูลได้";
                        lblProfileMessage.CssClass = "message-label message-error";
                    }
                }
                catch (SqlException ex)
                {
                    if (ex.Number == 2627 || ex.Number == 2601) // Unique constraint violation (Email)
                    {
                        lblProfileMessage.Text = "อีเมลนี้ถูกใช้งานแล้ว กรุณาใช้อีเมลอื่น";
                        lblProfileMessage.CssClass = "message-label message-error";
                    }
                    else
                    {
                        lblProfileMessage.Text = "เกิดข้อผิดพลาดฐานข้อมูล: " + ex.Message;
                        lblProfileMessage.CssClass = "message-label message-error";
                    }
                }
                catch (Exception ex)
                {
                    lblProfileMessage.Text = "เกิดข้อผิดพลาด: " + ex.Message;
                    lblProfileMessage.CssClass = "message-label message-error";
                }
            }
        }

        /// <summary>
        /// คลิกปุ่ม "เปลี่ยนรหัสผ่าน"
        /// </summary>
        protected void btnChangePassword_Click(object sender, EventArgs e)
        {
            // ตรวจสอบความถูกต้องของข้อมูล (ValidationGroup="Password")
            if (!Page.IsValid)
            {
                return;
            }

            string memberID = Session["MemberID"].ToString();
            string currentPassword = txtCurrentPassword.Text;
            string newPassword = txtNewPassword.Text;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                // 1. ตรวจสอบรหัสผ่านปัจจุบัน
                string sqlCheck = "SELECT Password FROM Member WHERE MemberID = @MemberID";
                SqlCommand cmdCheck = new SqlCommand(sqlCheck, conn);
                cmdCheck.Parameters.AddWithValue("@MemberID", memberID);

                string dbPassword = cmdCheck.ExecuteScalar() as string;

                // **ข้อควรระวัง: นี่เป็นการเปรียบเทียบรหัสผ่านแบบ Plain Text ซึ่งไม่ปลอดภัยอย่างยิ่ง**
                // ในระบบจริงควรใช้การ Hashing (เช่น SHA256)
                if (dbPassword != currentPassword)
                {
                    lblPasswordMessage.Text = "รหัสผ่านปัจจุบันไม่ถูกต้อง";
                    lblPasswordMessage.CssClass = "message-label message-error";
                    return;
                }

                // 2. อัปเดตรหัสผ่านใหม่ (รหัสผ่านใหม่ตรงกัน ถูกตรวจสอบโดย CompareValidator แล้ว)
                string sqlUpdate = "UPDATE Member SET Password = @NewPassword WHERE MemberID = @MemberID";
                SqlCommand cmdUpdate = new SqlCommand(sqlUpdate, conn);
                cmdUpdate.Parameters.AddWithValue("@NewPassword", newPassword); // ควร Hash รหัสผ่านใหม่ก่อนบันทึก
                cmdUpdate.Parameters.AddWithValue("@MemberID", memberID);

                try
                {
                    int rowsAffected = cmdUpdate.ExecuteNonQuery();
                    if (rowsAffected > 0)
                    {
                        lblPasswordMessage.Text = "เปลี่ยนรหัสผ่านเรียบร้อยแล้ว";
                        lblPasswordMessage.CssClass = "message-label message-success";
                        // ล้างช่องรหัสผ่าน
                        txtCurrentPassword.Text = "";
                        txtNewPassword.Text = "";
                        txtConfirmPassword.Text = "";
                    }
                    else
                    {
                        lblPasswordMessage.Text = "ไม่สามารถเปลี่ยนรหัสผ่านได้";
                        lblPasswordMessage.CssClass = "message-label message-error";
                    }
                }
                catch (Exception ex)
                {
                    lblPasswordMessage.Text = "เกิดข้อผิดพลาด: " + ex.Message;
                    lblPasswordMessage.CssClass = "message-label message-error";
                }
            }
        }

        /// <summary>
        /// Helper
        /// </summary>
        private void SetProfileEditMode(bool isEditing)
        {
            // สลับสถานะ ReadOnly
            txtFullName.ReadOnly = !isEditing;
            txtEmail.ReadOnly = !isEditing;
            txtAddress.ReadOnly = !isEditing;
            txtPhone.ReadOnly = !isEditing;

            // สลับการแสดงผลของปุ่ม
            btnEditProfile.Visible = !isEditing;
            btnSaveProfile.Visible = isEditing;
            btnCancelEdit.Visible = isEditing;

            // เปลี่ยน Style ของ Textbox
            txtFullName.CssClass = isEditing ? "asp-textbox" : "asp-textbox readonly";
            txtEmail.CssClass = isEditing ? "asp-textbox" : "asp-textbox readonly";
            txtAddress.CssClass = isEditing ? "asp-textbox" : "asp-textbox readonly";
            txtPhone.CssClass = isEditing ? "asp-textbox" : "asp-textbox readonly";
        }
    }
}
