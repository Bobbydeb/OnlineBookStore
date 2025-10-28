using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Linq; // [เพิ่ม]
using System.Web.UI.HtmlControls; // [เพิ่ม]

namespace OnlineBookStore
{
    public partial class searchResultPage : System.Web.UI.Page
    {
        private readonly string connStr =
            "Data Source=.\\SQLEXPRESS;Initial Catalog=dbOnlineBookStore;Integrated Security=True";

        // [เพิ่ม] ตัวแปรสำหรับเก็บค่าจาก QueryString
        private string searchQuery = "";
        private int currentPage = 1;

        protected void Page_Load(object sender, EventArgs e)
        {
            // ตรวจสอบ Login (เหมือนหน้าอื่น)
            if (Session["MemberID"] != null)
            {
                btnLogin.Visible = false;
                btnLogout.Visible = true;
            }
            else
            {
                btnLogin.Visible = true;
                btnLogout.Visible = false;
            }

            // [แก้ไข] ดึงค่า query และ page มาเก็บในตัวแปร
            searchQuery = Request.QueryString["query"];

            if (!int.TryParse(Request.QueryString["page"], out currentPage))
            {
                currentPage = 1;
            }
            if (currentPage < 1) currentPage = 1;

            if (!IsPostBack)
            {
                if (!string.IsNullOrEmpty(searchQuery))
                {
                    litSearchQuery.Text = Server.HtmlEncode(searchQuery);
                    txtSearch.Text = searchQuery;
                    LoadSearchResults(searchQuery);
                }
                else
                {
                    litSearchQuery.Text = "[ไม่ได้ระบุคำค้นหา]";
                    pnlNoResults.Visible = true; // [แก้ไข] แสดง pnlNoResults ทันที
                }
            }
        }

        private void LoadSearchResults(string query)
        {
            int pageSize = 10;
            DataTable dt = new DataTable();
            int totalResults = 0;

            using (SqlConnection con = new SqlConnection(connStr))
            {
                con.Open();

                // [แก้ไข] Query 1: นับจำนวนผลลัพธ์ทั้งหมด
                string countQuery = @"
                    SELECT COUNT(DISTINCT b.BookID)
                    FROM Book b
                    LEFT JOIN BookAuthor ba ON b.BookID = ba.BookID
                    LEFT JOIN Author a ON ba.AuthorID = a.AuthorID
                    WHERE b.Title LIKE @Query OR a.AuthorName LIKE @Query";

                using (SqlCommand countCmd = new SqlCommand(countQuery, con))
                {
                    countCmd.Parameters.AddWithValue("@Query", $"%{query}%");
                    totalResults = (int)countCmd.ExecuteScalar();
                }

                if (totalResults > 0)
                {
                    pnlNoResults.Visible = false;

                    // [แก้ไข] Query 2: ดึงข้อมูลแบบแบ่งหน้า
                    string sqlQuery = @"
                        SELECT DISTINCT
                            b.BookID, b.Title, b.Edition,
                            c.CategoryName, b.Price,
                            ISNULL(cv.CoverUrl, 'https://raw.githubusercontent.com/Bobbydeb/OnlineBookStore/refs/heads/master/OnlineBookStore/wwwroot/images/00_DefaultBook.jpg') AS CoverUrl
                        FROM Book b
                        LEFT JOIN BookCategory c ON b.CategoryID = c.CategoryID
                        LEFT JOIN Cover cv ON b.CoverID = cv.CoverID
                        LEFT JOIN BookAuthor ba ON b.BookID = ba.BookID
                        LEFT JOIN Author a ON ba.AuthorID = a.AuthorID
                        WHERE b.Title LIKE @Query OR a.AuthorName LIKE @Query
                        ORDER BY b.Title
                        OFFSET @Offset ROWS
                        FETCH NEXT @PageSize ROWS ONLY;";

                    using (SqlCommand cmd = new SqlCommand(sqlQuery, con))
                    {
                        cmd.Parameters.AddWithValue("@Query", $"%{query}%");
                        cmd.Parameters.AddWithValue("@PageSize", pageSize);
                        cmd.Parameters.AddWithValue("@Offset", (currentPage - 1) * pageSize);

                        using (SqlDataAdapter sda = new SqlDataAdapter(cmd))
                        {
                            sda.Fill(dt);
                        }
                    }

                    rptSearchResults.DataSource = dt;
                    rptSearchResults.DataBind();

                    // [เพิ่ม] Logic การสร้าง Pager (เหมือน categoryPage)
                    int totalPages = (int)Math.Ceiling((double)totalResults / pageSize);
                    if (totalPages > 1)
                    {
                        var pages = Enumerable.Range(1, totalPages);
                        rptPager.DataSource = pages.Select(p => new {
                            PageNum = p,
                            IsCurrent = (p == currentPage)
                        }).ToList();
                        rptPager.DataBind();
                        pnlPager.Visible = true;
                    }
                    else
                    {
                        pnlPager.Visible = false;
                    }
                }
                else
                {
                    // ไม่มีผลลัพธ์
                    rptSearchResults.DataSource = null;
                    rptSearchResults.DataBind();
                    pnlNoResults.Visible = true;
                    pnlPager.Visible = false;
                }

                con.Close();
            }
        }

        // [เพิ่ม] Event Handler สำหรับ Pager
        protected void rptPager_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                HyperLink hlPageLink = (HyperLink)e.Item.FindControl("hlPageLink");
                dynamic pageData = e.Item.DataItem;

                int pageNum = pageData.PageNum;
                bool isCurrent = pageData.IsCurrent;

                hlPageLink.Text = pageNum.ToString();
                // [แก้ไข] ลิงก์ต้องมีทั้ง 'query' และ 'page'
                hlPageLink.NavigateUrl = $"searchResultPage.aspx?query={Server.UrlEncode(searchQuery)}&page={pageNum}";

                HtmlGenericControl liContainer = (HtmlGenericControl)e.Item.FindControl("liPageItem");
                if (isCurrent)
                {
                    liContainer.Attributes["class"] += " active";
                    hlPageLink.Enabled = false;
                }
            }
        }

        /// <summary>
        /// Event เมื่อกดปุ่มค้นหา (ในหน้านี้)
        /// </summary>
        protected void btnSearch_Click(object sender, EventArgs e)
        {
            string query = txtSearch.Text.Trim();
            if (!string.IsNullOrEmpty(query))
            {
                // [แก้ไข] Redirect ไปที่หน้าตัวเองพร้อม query ใหม่ (และเริ่มที่หน้า 1)
                Response.Redirect($"searchResultPage.aspx?query={Server.UrlEncode(query)}&page=1");
            }
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Response.Redirect("mainpage.aspx");
        }
    }
}
