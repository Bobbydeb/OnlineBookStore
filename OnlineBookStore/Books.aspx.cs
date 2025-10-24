using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;

namespace OnlineBookStoreWebForm
{
    public partial class Books : System.Web.UI.Page
    {
        private const string DefaultSort = "Title";
        private const string DefaultDir = "ASC";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadCategories();
                ddlPageSize.SelectedValue = "12";
                GridViewBooks.PageSize = 12;
                ViewState["SortExpression"] = DefaultSort;
                ViewState["SortDirection"] = DefaultDir;
                BindGrid();
            }
        }

        private string ConnStr => ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

        private void LoadCategories()
        {
            using (var conn = new SqlConnection(ConnStr))
            using (var cmd = new SqlCommand(@"SELECT CategoryID, CategoryName FROM BookCategory ORDER BY CategoryName", conn))
            using (var da = new SqlDataAdapter(cmd))
            {
                var dt = new DataTable();
                da.Fill(dt);

                ddlCategory.Items.Clear();
                ddlCategory.Items.Add(new ListItem("All categories", ""));
                foreach (DataRow r in dt.Rows)
                {
                    ddlCategory.Items.Add(new ListItem(r["CategoryName"].ToString(), r["CategoryID"].ToString()));
                }
            }
        }

        private void BindGrid()
        {
            string q = (txtSearch.Text ?? string.Empty).Trim();
            int cat;
            bool hasCat = int.TryParse(ddlCategory.SelectedValue, out cat);

            using (var conn = new SqlConnection(ConnStr))
            using (var cmd = new SqlCommand(@"
                SELECT b.BookID, b.Title, b.Price, b.Stock, c.CategoryName
                FROM Book b
                LEFT JOIN BookCategory c ON b.CategoryID = c.CategoryID
                WHERE (@q = '' OR b.Title LIKE '%' + @q + '%' OR b.ISBN LIKE '%' + @q + '%')
                  AND (@cat IS NULL OR b.CategoryID = @cat)
            ", conn))
            using (var da = new SqlDataAdapter(cmd))
            {
                cmd.Parameters.Add("@q", SqlDbType.NVarChar, 255).Value = q;
                if (hasCat)
                    cmd.Parameters.Add("@cat", SqlDbType.Int).Value = cat;
                else
                    cmd.Parameters.Add("@cat", SqlDbType.Int).Value = DBNull.Value;

                var dt = new DataTable();
                da.Fill(dt);

                // Sort in-memory with whitelist
                string sort = (ViewState["SortExpression"] as string) ?? DefaultSort;
                string dir = (ViewState["SortDirection"] as string) ?? DefaultDir;
                string safeSort;
                switch (sort)
                {
                    case "BookID":
                        safeSort = "BookID";
                        break;
                    case "Title":
                        safeSort = "Title";
                        break;
                    case "Price":
                        safeSort = "Price";
                        break;
                    case "Stock":
                        safeSort = "Stock";
                        break;
                    default:
                        safeSort = DefaultSort;
                        break;
                }


                string safeDir = dir.Equals("DESC", StringComparison.OrdinalIgnoreCase) ? "DESC" : "ASC";

                var dv = dt.DefaultView;
                dv.Sort = $"{safeSort} {safeDir}";

                GridViewBooks.PageSize = int.Parse(ddlPageSize.SelectedValue);
                GridViewBooks.DataSource = dv;
                GridViewBooks.DataBind();

                lblCount.Text = $"{dv.Count} result(s)";
            }
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            GridViewBooks.PageIndex = 0;
            BindGrid();
        }

        protected void ddlCategory_SelectedIndexChanged(object sender, EventArgs e)
        {
            GridViewBooks.PageIndex = 0;
            BindGrid();
        }

        protected void ddlPageSize_SelectedIndexChanged(object sender, EventArgs e)
        {
            GridViewBooks.PageIndex = 0;
            GridViewBooks.PageSize = int.Parse(ddlPageSize.SelectedValue);
            BindGrid();
        }

        protected void GridViewBooks_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            GridViewBooks.PageIndex = e.NewPageIndex;
            BindGrid();
        }

        protected void GridViewBooks_Sorting(object sender, GridViewSortEventArgs e)
        {
            string currentSort = (ViewState["SortExpression"] as string) ?? DefaultSort;
            string currentDir = (ViewState["SortDirection"] as string) ?? DefaultDir;

            if (string.Equals(currentSort, e.SortExpression, StringComparison.OrdinalIgnoreCase))
            {
                ViewState["SortDirection"] = currentDir == "ASC" ? "DESC" : "ASC";
            }
            else
            {
                ViewState["SortExpression"] = e.SortExpression;
                ViewState["SortDirection"] = "ASC";
            }

            BindGrid();
        }

        protected void GridViewBooks_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType != DataControlRowType.DataRow) return;

            var drv = (DataRowView)e.Row.DataItem;
            int stock = 0;
            if (drv != null && drv["Stock"] != DBNull.Value)
                stock = Convert.ToInt32(drv["Stock"]);

            var stockBadge = (HtmlGenericControl)e.Row.FindControl("stockBadge");
            if (stockBadge != null)
            {
                if (stock <= 0)
                {
                    stockBadge.InnerText = "Out of stock";
                    stockBadge.Attributes["class"] = "badge bg-danger";
                }
                else if (stock < 5)
                {
                    stockBadge.InnerText = $"Low: {stock}";
                    stockBadge.Attributes["class"] = "badge bg-warning text-dark";
                }
                else
                {
                    stockBadge.InnerText = $"In stock: {stock}";
                    stockBadge.Attributes["class"] = "badge bg-success";
                }
            }
        }
    }
}
