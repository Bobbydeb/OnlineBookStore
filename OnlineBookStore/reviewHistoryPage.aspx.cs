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
    public partial class reviewHistoryPage : System.Web.UI.Page
    {
        // ใช้ Connection String ที่มีอยู่
        private readonly string connStr =
            "Data Source=.\\SQLEXPRESS;Initial Catalog=dbOnlineBookStore;Integrated Security=True";

        protected void Page_Load(object sender, EventArgs e)
        {
            // 1. ตรวจสอบ Login
            if (Session["MemberID"] == null)
            {
                Response.Write("<script>alert('กรุณาทำการ login ก่อน');window.location='loginPage.aspx';</script>");
                return;
            }

            // ถ้า login แล้ว สลับปุ่ม
            btnLogin.Visible = false;
            btnLogout.Visible = true;

            if (!IsPostBack)
            {
                LoadMyReviews();
            }
        }

        /// <summary>
        /// โหลดรีวิวทั้งหมดของ Member ที่ Login อยู่
        /// </summary>
        private void LoadMyReviews()
        {
            int memberID = (int)Session["MemberID"];
            DataTable dt = new DataTable();

            using (SqlConnection con = new SqlConnection(connStr))
            {
                // [แก้ไข] เพิ่มการ JOIN และ SELECT Edition, CategoryName, และ Authors
                string query = @"
                    SELECT 
                        r.Rating, 
                        r.Comment, 
                        r.ReviewDate, 
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
                    FROM Review r
                    JOIN Book b ON r.BookID = b.BookID
                    LEFT JOIN Cover c ON b.CoverID = c.CoverID
                    LEFT JOIN BookCategory bc ON b.CategoryID = bc.CategoryID
                    WHERE r.MemberID = @MemberID
                    ORDER BY r.ReviewDate DESC";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@MemberID", memberID);
                    using (SqlDataAdapter sda = new SqlDataAdapter(cmd))
                    {
                        sda.Fill(dt);
                    }
                }
            }
            rptMyReviews.DataSource = dt;
            rptMyReviews.DataBind();
        }

        /// <summary>
        /// ตั้งค่ารูปปกหนังสือ
        /// </summary>
        protected void rptMyReviews_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView drv = (DataRowView)e.Item.DataItem;

                // ตั้งค่ารูปปก
                Image imgBookCover = (Image)e.Item.FindControl("imgBookCover");
                string coverUrl = drv["CoverUrl"] != DBNull.Value ? drv["CoverUrl"].ToString() : "https://raw.githubusercontent.com/Bobbydeb/OnlineBookStore/refs/heads/master/OnlineBookStore/wwwroot/images/00_DefaultBook.jpg";
                imgBookCover.ImageUrl = coverUrl;
                imgBookCover.AlternateText = drv["Title"].ToString();
            }
        }


        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Response.Redirect("mainpage.aspx");
        }
    }
}

