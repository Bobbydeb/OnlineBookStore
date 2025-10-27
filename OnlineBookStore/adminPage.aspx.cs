using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace OnlineBookStore
{

    public partial class adminPage : System.Web.UI.Page
    {
        // ใช้ตัวแปร readonly เก็บ connection string
        private readonly string connStr =
            "Data Source=.\\SQLEXPRESS;Initial Catalog=dbOnlineBookStore;Integrated Security=True";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadBooks();
                LoadAuthors();
                LoadPublishers();
                LoadMembers();
                LoadOrders();
                LoadReviews();
            }
        }

        void LoadBooks()
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                SqlDataAdapter da = new SqlDataAdapter("SELECT * FROM Book", con);
                DataTable dt = new DataTable();
                da.Fill(dt);
                GridViewBooks.DataSource = dt;
                GridViewBooks.DataBind();
            }
        }

        void LoadAuthors()
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                SqlDataAdapter da = new SqlDataAdapter(
                    "SELECT AuthorID, AuthorName, Email FROM Author ORDER BY AuthorID", con);
                DataTable dt = new DataTable();
                da.Fill(dt);
                GridViewAuthors.DataSource = dt;
                GridViewAuthors.DataBind();
            }
        }


        void LoadPublishers()
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                SqlDataAdapter da = new SqlDataAdapter(
                    "SELECT PublisherID, PublisherName, Address, Phone FROM Publisher ORDER BY PublisherID", con);
                DataTable dt = new DataTable();
                da.Fill(dt);
                GridViewPublishers.DataSource = dt;
                GridViewPublishers.DataBind();
            }
        }

        void LoadMembers()
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                SqlDataAdapter da = new SqlDataAdapter("SELECT * FROM Member", con);
                DataTable dt = new DataTable();
                da.Fill(dt);
                GridViewMembers.DataSource = dt;
                GridViewMembers.DataBind();
            }
        }

        void LoadOrders()
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                SqlDataAdapter da = new SqlDataAdapter("SELECT * FROM OrderTable", con);
                DataTable dt = new DataTable();
                da.Fill(dt);
                GridViewOrders.DataSource = dt;
                GridViewOrders.DataBind();
            }
        }

        void LoadReviews()
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                SqlDataAdapter da = new SqlDataAdapter("SELECT * FROM Review", con);
                DataTable dt = new DataTable();
                da.Fill(dt);
                GridViewReviews.DataSource = dt;
                GridViewReviews.DataBind();
            }
        }
        protected void GridViewBooks_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            GridViewBooks.PageIndex = e.NewPageIndex;
            LoadBooks();
        }

        protected void GridViewAuthors_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            GridViewAuthors.PageIndex = e.NewPageIndex;
            LoadAuthors();
        }

        protected void GridViewPublishers_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            GridViewPublishers.PageIndex = e.NewPageIndex;
            LoadPublishers();
        }

        protected void GridViewMembers_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            GridViewMembers.PageIndex = e.NewPageIndex;
            LoadMembers();
        }

        protected void GridViewOrders_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            GridViewOrders.PageIndex = e.NewPageIndex;
            LoadOrders();
        }

        protected void GridViewReviews_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            GridViewReviews.PageIndex = e.NewPageIndex;
            LoadReviews();
        }


    }
}
