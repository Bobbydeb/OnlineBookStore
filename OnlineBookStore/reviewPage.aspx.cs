using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;

namespace OnlineBookStore
{
    public partial class reviewPage : System.Web.UI.Page
    {
        // ใช้ Connection String ที่มีอยู่
        private readonly string connStr =
            "Data Source=.\\SQLEXPRESS;Initial Catalog=dbOnlineBookStore;Integrated Security=True";

        private int bookID;
        private int memberID;

        protected void Page_Load(object sender, EventArgs e)
        {
            // 1. ตรวจสอบ Login
            if (Session["MemberID"] == null)
            {
                Response.Write("<script>alert('กรุณาทำการ login ก่อน');window.location='loginPage.aspx';</script>");
                return;
            }
            memberID = (int)Session["MemberID"];

            // 2. ตรวจสอบ BookID จาก QueryString
            if (Request.QueryString["BookID"] == null || !int.TryParse(Request.QueryString["BookID"], out bookID))
            {
                Response.Write("<script>alert('ไม่พบรหัสหนังสือ');window.location='myCollectionPage.aspx';</script>");
                return;
            }

            // ถ้า login แล้ว สลับปุ่ม
            btnLogin.Visible = false;
            btnLogout.Visible = true;

            if (!IsPostBack)
            {
                LoadBookDetails();
                PopulateRatingDropdown();

                // 3. ตรวจสอบว่าเคยรีวิวหรือยัง
                if (CheckIfReviewed())
                {
                    // ถ้ารีวิวแล้ว ซ่อนฟอร์ม และแสดงข้อความ
                    pnlReviewForm.Visible = false;
                    pnlReviewDone.Visible = true;
                }
                else
                {
                    // ถ้ายังไม่รีวิว แสดงฟอร์ม
                    pnlReviewForm.Visible = true;
                    pnlReviewDone.Visible = false;
                }
            }
        }

        /// <summary>
        /// โหลดข้อมูลหนังสือ (ชื่อ, ปก, และรายละเอียดเพิ่มเติม) มาแสดง
        /// </summary>
        private void LoadBookDetails()
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                // [แก้ไข] เพิ่มการดึง Edition, CategoryName, และ Authors
                string query = @"
                    SELECT 
                        b.Title, 
                        b.Edition,
                        bc.CategoryName,
                        c.CoverUrl,
                        (SELECT STUFF(
                            (SELECT ', ' + a.AuthorName
                             FROM Author a
                             JOIN BookAuthor ba ON a.AuthorID = ba.AuthorID
                             WHERE ba.BookID = b.BookID
                             FOR XML PATH('')),
                            1, 2, '')) AS Authors
                    FROM Book b
                    LEFT JOIN Cover c ON b.CoverID = c.CoverID
                    LEFT JOIN BookCategory bc ON b.CategoryID = bc.CategoryID
                    WHERE b.BookID = @BookID";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@BookID", bookID);
                    con.Open();
                    SqlDataReader reader = cmd.ExecuteReader();
                    if (reader.Read())
                    {
                        // ตั้งค่าข้อมูลหลัก
                        lblBookTitle.Text = reader["Title"].ToString();
                        string coverUrl = reader["CoverUrl"] != DBNull.Value ? reader["CoverUrl"].ToString() : "https://raw.githubusercontent.com/Bobbydeb/OnlineBookStore/refs/heads/master/OnlineBookStore/wwwroot/images/00_DefaultBook.jpg";
                        imgBookCover.ImageUrl = coverUrl;
                        imgBookCover.AlternateText = reader["Title"].ToString();

                        // [เพิ่ม] ตั้งค่า Label รายละเอียด
                        lblAuthors.Text = (reader["Authors"] == DBNull.Value || string.IsNullOrEmpty(reader["Authors"].ToString()))
                                            ? "ไม่ระบุ"
                                            : reader["Authors"].ToString();
                        lblCategory.Text = reader["CategoryName"] == DBNull.Value ? "ไม่ระบุ" : reader["CategoryName"].ToString();
                        lblEdition.Text = reader["Edition"] == DBNull.Value ? "N/A" : reader["Edition"].ToString();
                    }
                    else
                    {
                        // ถ้าไม่เจอ BookID ที่ส่งมา
                        Response.Redirect("myCollectionPage.aspx");
                    }
                    con.Close();
                }
            }
        }

        /// <summary>
        /// สร้างตัวเลือก 1-5 ดาว
        /// </summary>
        private void PopulateRatingDropdown()
        {
            ddlRating.Items.Clear();
            ddlRating.Items.Add(new ListItem("--- เลือกคะแนน ---", "0"));
            for (int i = 5; i >= 1; i--)
            {
                ddlRating.Items.Add(new ListItem($"{i} ดาว", i.ToString()));
            }
        }

        /// <summary>
        /// ตรวจสอบว่า Member เคยรีวิวหนังสือเล่มนี้หรือยัง
        /// </summary>
        private bool CheckIfReviewed()
        {
            bool reviewed = false;
            using (SqlConnection con = new SqlConnection(connStr))
            {
                // ใช้ Logic เดียวกับหน้า myCollectionPage
                string query = "SELECT COUNT(1) FROM Review WHERE BookID = @BookID AND MemberID = @MemberID";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@BookID", bookID);
                    cmd.Parameters.AddWithValue("@MemberID", memberID);
                    con.Open();
                    int count = (int)cmd.ExecuteScalar();
                    if (count > 0)
                    {
                        reviewed = true;
                    }
                    con.Close();
                }
            }
            return reviewed;
        }

        /// <summary>
        /// Event เมื่อกดปุ่ม "ส่งรีวิว"
        /// </summary>
        protected void btnSubmitReview_Click(object sender, EventArgs e)
        {
            // ดึงค่า
            int rating = Convert.ToInt32(ddlRating.SelectedValue);
            string comment = txtComment.Text.Trim();

            // 1. ตรวจสอบ Input
            if (rating == 0)
            {
                lblErrorMessage.Text = "กรุณาเลือกคะแนน (1-5 ดาว)";
                lblErrorMessage.Visible = true;
                return;
            }
            if (string.IsNullOrEmpty(comment))
            {
                lblErrorMessage.Text = "กรุณาใส่ความคิดเห็น";
                lblErrorMessage.Visible = true;
                return;
            }

            // 2. บันทึกลงฐานข้อมูล
            try
            {
                using (SqlConnection con = new SqlConnection(connStr))
                {
                    // หมายเหตุ: DDL ของคุณสำหรับ ReviewID ไม่ได้เป็น IDENTITY
                    // เราจึงต้องหา MAX ID + 1 เพื่อใส่เอง
                    string query = @"
                        INSERT INTO Review (ReviewID, MemberID, BookID, Rating, Comment, ReviewDate) 
                        VALUES ((SELECT ISNULL(MAX(ReviewID), 0) + 1 FROM Review), @MemberID, @BookID, @Rating, @Comment, @ReviewDate)";

                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@MemberID", memberID);
                        cmd.Parameters.AddWithValue("@BookID", bookID);
                        cmd.Parameters.AddWithValue("@Rating", rating);
                        cmd.Parameters.AddWithValue("@Comment", comment);
                        cmd.Parameters.AddWithValue("@ReviewDate", DateTime.Now);

                        con.Open();
                        cmd.ExecuteNonQuery();
                        con.Close();
                    }
                }

                // 3. ส่งกลับไปหน้า My Collection
                Response.Redirect("myCollectionPage.aspx");
            }
            catch (Exception ex)
            {
                // หากมีปัญหา
                lblErrorMessage.Text = "เกิดข้อผิดพลาดในการบันทึก: " + ex.Message;
                lblErrorMessage.Visible = true;
            }
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Response.Redirect("mainpage.aspx");
        }
    }
}

