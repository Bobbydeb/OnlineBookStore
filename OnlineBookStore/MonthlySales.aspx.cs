using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace OnlineBookStore
{
    public partial class MonthlySales : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadData();
            }
        }

        private void LoadData()
        {
            // ดึง connection string จาก Web.config
            string connStr = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = @"SELECT FORMAT(o.OrderDate, 'yyyy-MM') AS OrderMonth,
                                      SUM(o.TotalAmount) AS MonthlySales
                               FROM OrderTable o
                               GROUP BY FORMAT(o.OrderDate, 'yyyy-MM')
                               ORDER BY OrderMonth";

                SqlDataAdapter da = new SqlDataAdapter(sql, conn);
                DataTable dt = new DataTable();
                da.Fill(dt);

                GridView1.DataSource = dt;
                GridView1.DataBind();
            }
        }
    }
}
