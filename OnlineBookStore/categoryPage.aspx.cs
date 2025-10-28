using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Linq; // [เพิ่ม] สำหรับ Enumerable.Range
using System.Web.UI.HtmlControls; // [เพิ่ม] สำหรับ HtmlGenericControl

namespace OnlineBookStore
{
    public partial class categoryPage : System.Web.UI.Page
    {
        private readonly string connStr = "Data Source=.\\SQLEXPRESS;Initial Catalog=dbOnlineBookStore;Integrated Security=True";
        private int categoryId = 0;
        private int currentPage = 1; // [เพิ่ม] ตัวแปรสำหรับเก็บหน้าปัจจุบัน

        protected void Page_Load(object sender, EventArgs e)
        {
            // 1. ตรวจสอบ Login (เหมือนหน้าอื่น)
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

            // 2. ตรวจสอบ QueryString "id"
            if (!int.TryParse(Request.QueryString["id"], out categoryId))
            {
                // ถ้าไม่มี id หรือ id ไม่ใช่ตัวเลข ให้ส่งกลับหน้าหลัก
                Response.Redirect("mainpage.aspx");
                return;
            }

            // [เพิ่ม] 3. ตรวจสอบ QueryString "page"
            if (!int.TryParse(Request.QueryString["page"], out currentPage))
            {
                currentPage = 1; // ถ้าไม่มี page= ให้เป็นหน้า 1
            }
            if (currentPage < 1) currentPage = 1;


            if (!IsPostBack)
            {
                // 4. ถ้ามี id ที่ถูกต้อง ให้โหลดข้อมูล
                LoadCategoryBooks();
            }
        }

        private void LoadCategoryBooks()
        {
            int pageSize = 10; // [แก้ไข] กำหนดขนาดหน้า

            using (SqlConnection con = new SqlConnection(connStr))
            {
                con.Open();

                // --- Query 1: ดึงชื่อหมวดหมู่มาแสดง (เหมือนเดิม) ---
                string catQuery = "SELECT CategoryName FROM BookCategory WHERE CategoryID = @CategoryID";
                using (SqlCommand catCmd = new SqlCommand(catQuery, con))
                {
                    catCmd.Parameters.AddWithValue("@CategoryID", categoryId);
                    object result = catCmd.ExecuteScalar();
                    if (result != null)
                    {
                        litCategoryName.Text = result.ToString();
                        this.Title = "หมวดหมู่: " + result.ToString();
                    }
                    else
                    {
                        Response.Redirect("mainpage.aspx");
                        return;
                    }
                }

                // [เพิ่ม] --- Query 2: นับจำนวนหนังสือทั้งหมด ---
                int totalBooks = 0;
                string countQuery = "SELECT COUNT(BookID) FROM Book WHERE CategoryID = @CategoryID";
                using (SqlCommand countCmd = new SqlCommand(countQuery, con))
                {
                    countCmd.Parameters.AddWithValue("@CategoryID", categoryId);
                    totalBooks = (int)countCmd.ExecuteScalar();
                }

                if (totalBooks > 0)
                {
                    pnlNoBooks.Visible = false;

                    // [แก้ไข] --- Query 3: ดึงหนังสือแบบแบ่งหน้า ---
                    string bookQuery = @"
                        SELECT 
                            b.Title, 
                            b.Edition,
                            c.CategoryName, 
                            b.Price,
                            ISNULL(cv.CoverUrl, 'https://raw.githubusercontent.com/Bobbydeb/OnlineBookStore/refs/heads/master/OnlineBookStore/wwwroot/images/00_DefaultBook.jpg') AS CoverUrl
                        FROM Book b
                        LEFT JOIN BookCategory c ON b.CategoryID = c.CategoryID
                        LEFT JOIN Cover cv ON b.CoverID = cv.CoverID
                        WHERE b.CategoryID = @CategoryID
                        ORDER BY b.Title -- OFFSET/FETCH ต้องใช้ ORDER BY
                        OFFSET @Offset ROWS
                        FETCH NEXT @PageSize ROWS ONLY;";

                    using (SqlCommand bookCmd = new SqlCommand(bookQuery, con))
                    {
                        bookCmd.Parameters.AddWithValue("@CategoryID", categoryId);
                        bookCmd.Parameters.AddWithValue("@PageSize", pageSize);
                        bookCmd.Parameters.AddWithValue("@Offset", (currentPage - 1) * pageSize);

                        DataTable dt = new DataTable();
                        SqlDataAdapter sda = new SqlDataAdapter(bookCmd);
                        sda.Fill(dt);

                        rptCategoryBooks.DataSource = dt;
                        rptCategoryBooks.DataBind();
                    }

                    // [เพิ่ม] --- Logic การสร้าง Pager ---
                    int totalPages = (int)Math.Ceiling((double)totalBooks / pageSize);
                    if (totalPages > 1)
                    {
                        // สร้าง List ของตัวเลขหน้า
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
                        pnlPager.Visible = false; // ไม่แสดง Pager ถ้ามีหน้าเดียว
                    }
                }
                else
                {
                    // ถ้าไม่มีหนังสือในหมวดนี้
                    rptCategoryBooks.DataSource = null;
                    rptCategoryBooks.DataBind();
                    pnlNoBooks.Visible = true;
                    pnlPager.Visible = false; // ซ่อน Pager ด้วย
                }
                con.Close();
            }
        }

        // [เพิ่ม] Event Handler สำหรับสร้างปุ่ม Pager
        protected void rptPager_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                HyperLink hlPageLink = (HyperLink)e.Item.FindControl("hlPageLink");

                // เราส่ง anonymous type (ที่มี PageNum, IsCurrent) เข้ามา
                dynamic pageData = e.Item.DataItem;

                int pageNum = pageData.PageNum;
                bool isCurrent = pageData.IsCurrent;

                hlPageLink.Text = pageNum.ToString();
                // สร้างลิงก์กลับมาที่หน้านี้ แต่เปลี่ยนแค่ 'page' (ต้องมี 'id' ของ categoryId ด้วย)
                hlPageLink.NavigateUrl = $"categoryPage.aspx?id={categoryId}&page={pageNum}";

                // ค้นหา <li> ที่ครอบ <a>
                HtmlGenericControl liContainer = (HtmlGenericControl)e.Item.FindControl("liPageItem");
                if (isCurrent)
                {
                    // ถ้าเป็นหน้าปัจจุบัน ให้เพิ่ม class 'active'
                    liContainer.Attributes["class"] += " active";
                    hlPageLink.Enabled = false; // ปิดลิงก์หน้าปัจจุบัน
                }
            }
        }


        // --- Eventพื้นฐาน (เหมือนหน้าอื่น) ---

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Response.Redirect("mainpage.aspx");
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            string query = txtSearch.Text.Trim();
            if (!string.IsNullOrEmpty(query))
            {
                Response.Redirect($"searchResultPage.aspx?query={Server.UrlEncode(query)}");
            }
        }
    }
}

