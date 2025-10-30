using System;
using System.Data.SqlClient;
using System.Web.UI;
// [เพิ่ม] Imports ที่จำเป็น
using System.Diagnostics;
using System.Web;


namespace OnlineBookStore
{
    public partial class myAccountPage : System.Web.UI.Page
    {
        // [แก้ไข] เปลี่ยนเป็น private instance method และเพิ่ม GetConnectionString
        private string GetConnectionString()
        {
            return "Data Source=.\\SQLEXPRESS;Initial Catalog=dbOnlineBookStore;Integrated Security=True";
        }


        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["MemberID"] == null)
            {
                // [แก้ไข] เปลี่ยน alert เป็น Redirect พร้อม returnUrl
                string returnUrl = HttpUtility.UrlEncode(Request.Url.PathAndQuery);
                Response.Redirect($"loginPage.aspx?returnUrl={returnUrl}");
                return;
            }

            btnLogin.Visible = false;
            btnLogout.Visible = true;

            if (!IsPostBack)
            {
                // [เพิ่ม] โหลดจำนวนตะกร้า
                LoadCartCount();
                LoadMemberData();
            }
        }

        private void LoadMemberData()
        {
            lblProfileMessage.Text = "";
            lblPasswordMessage.Text = "";
            string memberID = Session["MemberID"].ToString();

            using (SqlConnection conn = new SqlConnection(GetConnectionString())) // [แก้ไข]
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
                        txtAddress.Text = reader["Address"]?.ToString() ?? ""; // [แก้ไข] เพิ่ม Null check
                        txtPhone.Text = reader["Phone"]?.ToString() ?? "";   // [แก้ไข] เพิ่ม Null check

                        lblUserInfo.Text = "Hello, " + reader["FullName"].ToString();
                    }
                    // [แก้ไข] ไม่ต้อง reader.Close() เพราะใช้ using แล้ว
                }
                catch (Exception ex)
                {
                    lblProfileMessage.Text = "something wrong: " + ex.Message;
                    lblProfileMessage.CssClass = "message-label message-error";
                }
            }
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon(); // [แก้ไข] ใช้ Abandon
            Response.Redirect("mainpage.aspx");
        }

        protected void btnEditProfile_Click(object sender, EventArgs e)
        {
            SetProfileEditMode(true);
            lblProfileMessage.Text = "";
        }

        protected void btnCancelEdit_Click(object sender, EventArgs e)
        {
            SetProfileEditMode(false);
            LoadMemberData();
        }

        protected void btnSaveProfile_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            string memberID = Session["MemberID"].ToString();

            using (SqlConnection conn = new SqlConnection(GetConnectionString())) // [แก้ไข]
            {
                // [แก้ไข] เพิ่มการจัดการค่า NULL สำหรับ Address และ Phone
                string sql = @"UPDATE Member
                               SET FullName = @FullName,
                                   Email = @Email,
                                   Address = CASE WHEN @Address = '' THEN NULL ELSE @Address END,
                                   Phone = CASE WHEN @Phone = '' THEN NULL ELSE @Phone END
                               WHERE MemberID = @MemberID";

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
                        SetProfileEditMode(false);
                        lblUserInfo.Text = "สวัสดีคุณ, " + txtFullName.Text.Trim();
                    }
                    // ... (ส่วน catch เหมือนเดิม) ...
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

        protected void btnChangePassword_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            string memberID = Session["MemberID"].ToString();
            string currentPassword = txtCurrentPassword.Text;
            string newPassword = txtNewPassword.Text;

            using (SqlConnection conn = new SqlConnection(GetConnectionString())) // [แก้ไข]
            {
                conn.Open();
                string sqlCheck = "SELECT Password FROM Member WHERE MemberID = @MemberID";
                SqlCommand cmdCheck = new SqlCommand(sqlCheck, conn);
                cmdCheck.Parameters.AddWithValue("@MemberID", memberID);
                string dbPassword = cmdCheck.ExecuteScalar() as string;

                if (dbPassword != currentPassword) // **ควรใช้ Hashing**
                {
                    lblPasswordMessage.Text = "รหัสผ่านปัจจุบันไม่ถูกต้อง";
                    lblPasswordMessage.CssClass = "message-label message-error";
                    return;
                }

                string sqlUpdate = "UPDATE Member SET Password = @NewPassword WHERE MemberID = @MemberID";
                SqlCommand cmdUpdate = new SqlCommand(sqlUpdate, conn);
                cmdUpdate.Parameters.AddWithValue("@NewPassword", newPassword); // **ควร Hash ก่อนบันทึก**
                cmdUpdate.Parameters.AddWithValue("@MemberID", memberID);

                try
                {
                    int rowsAffected = cmdUpdate.ExecuteNonQuery();
                    if (rowsAffected > 0)
                    {
                        lblPasswordMessage.Text = "เปลี่ยนรหัสผ่านเรียบร้อยแล้ว";
                        lblPasswordMessage.CssClass = "message-label message-success";
                        txtCurrentPassword.Text = "";
                        txtNewPassword.Text = "";
                        txtConfirmPassword.Text = "";
                    }
                    // ... (ส่วน else/catch เหมือนเดิม) ...
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

        private void SetProfileEditMode(bool isEditing)
        {
            txtFullName.ReadOnly = !isEditing;
            txtEmail.ReadOnly = !isEditing;
            txtAddress.ReadOnly = !isEditing;
            txtPhone.ReadOnly = !isEditing;

            btnEditProfile.Visible = !isEditing;
            btnSaveProfile.Visible = isEditing;
            btnCancelEdit.Visible = isEditing;

            // [แก้ไข] ปรับ CSS Class ให้ถูกต้อง
            txtFullName.CssClass = !isEditing ? "asp-textbox readonly" : "asp-textbox";
            txtEmail.CssClass = !isEditing ? "asp-textbox readonly" : "asp-textbox";
            txtAddress.CssClass = !isEditing ? "asp-textbox readonly" : "asp-textbox";
            txtPhone.CssClass = !isEditing ? "asp-textbox readonly" : "asp-textbox";
        }

        // --- [เพิ่ม] โค้ด Helpers สำหรับตะกร้า (เหมือนหน้าอื่น) ---
        private int GetCartId(int memberId)
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
                        // [สำคัญ] ต้องหา Control จาก Master Page หรือใช้ FindControl
                        // สมมติว่า cartCount อยู่ใน Header ของ .aspx โดยตรง
                        var cartCountSpan = (System.Web.UI.HtmlControls.HtmlGenericControl)FindControl("cartCount");
                        if (cartCountSpan != null)
                        {
                            cartCountSpan.InnerText = totalQuantity.ToString();
                            cartCountSpan.Attributes["class"] = "cart-count";
                        }
                        else
                        {
                            Debug.WriteLine("Error: cartCount span not found!");
                        }
                    }
                    else
                    {
                        var cartCountSpan = (System.Web.UI.HtmlControls.HtmlGenericControl)FindControl("cartCount");
                        if (cartCountSpan != null)
                        {
                            cartCountSpan.InnerText = "0";
                            cartCountSpan.Attributes["class"] = "cart-count empty";
                        }
                    }
                }
                else
                {
                    var cartCountSpan = (System.Web.UI.HtmlControls.HtmlGenericControl)FindControl("cartCount");
                    if (cartCountSpan != null)
                    {
                        cartCountSpan.InnerText = "0";
                        cartCountSpan.Attributes["class"] = "cart-count empty";
                    }
                }
            }
            else
            {
                var cartCountSpan = (System.Web.UI.HtmlControls.HtmlGenericControl)FindControl("cartCount");
                if (cartCountSpan != null)
                {
                    cartCountSpan.InnerText = "0";
                    cartCountSpan.Attributes["class"] = "cart-count empty";
                }
            }
        }
        // --- [จบ] โค้ดที่เพิ่ม ---
    }
}
