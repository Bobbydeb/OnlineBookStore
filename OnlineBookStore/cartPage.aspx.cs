using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
// [เพิ่ม] Imports ที่จำเป็น
using System.Data;
using System.Data.SqlClient;
using System.Diagnostics; // สำหรับ Debug

namespace OnlineBookStore
{
    public partial class cartPage : System.Web.UI.Page
    {
        // [เพิ่ม] Connection String
        private string GetConnectionString()
        {
            // ตรวจสอบให้แน่ใจว่า Connection String นี้ถูกต้องสำหรับเครื่องของคุณ
            return "Data Source=.\\SQLEXPRESS;Initial Catalog=dbOnlineBookStore;Integrated Security=True";
        }


        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // [สำคัญ] ตรวจสอบการ Login
                if (Session["MemberID"] == null)
                {
                    // ถ้ายังไม่ Login, ส่งไปหน้า Login
                    Response.Redirect("loginPage.aspx");
                    return; // หยุดการทำงานของ Page_Load
                }

                // ถ้า Login แล้ว, โหลดข้อมูลตะกร้า
                LoadCart();
                LoadCartCount(); // โหลดจำนวนสินค้าบน Header
            }

            // [เพิ่ม] จัดการการแสดงผลปุ่ม Login/Logout (เหมือน mainpage)
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
        }

        // [เพิ่ม] เมธอดสำหรับโหลดจำนวนสินค้าในตะกร้า (จาก mainpage.aspx.cs)
        private void LoadCartCount()
        {
            if (Session["MemberID"] != null)
            {
                int memberId = Convert.ToInt32(Session["MemberID"]);
                int cartId = GetCartId(memberId); // ใช้ GetCartId (Select-only)
                if (cartId > 0)
                {
                    int totalQuantity = GetTotalCartQuantity(cartId);
                    if (totalQuantity > 0)
                    {
                        cartCount.InnerText = totalQuantity.ToString();
                        cartCount.Attributes["class"] = "cart-count"; // แสดงผล
                    }
                    else
                    {
                        cartCount.InnerText = "0";
                        cartCount.Attributes["class"] = "cart-count empty"; // ซ่อน
                    }
                }
                else
                {
                    // ถ้าไม่มี CartID เลย ก็ให้เป็น 0
                    cartCount.InnerText = "0";
                    cartCount.Attributes["class"] = "cart-count empty"; // ซ่อน (ยังไม่มีตะกร้า)
                }
            }
            else
            {
                cartCount.InnerText = "0";
                cartCount.Attributes["class"] = "cart-count empty"; // ซ่อนถ้ายังไม่ login
            }
        }

        // [เพิ่ม] Helper: ดึงจำนวนสินค้ารวมในตะกร้า (จาก mainpage.aspx.cs)
        private int GetTotalCartQuantity(int cartId)
        {
            int totalQuantity = 0;
            using (SqlConnection conn = new SqlConnection(GetConnectionString()))
            {
                try
                {
                    conn.Open();
                    string query = "SELECT SUM(Quantity) FROM CartItem WHERE CartID = @CartID";
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
                catch (Exception ex)
                {
                    Debug.WriteLine("Error in GetTotalCartQuantity: " + ex.Message);
                }
            }
            return totalQuantity;
        }


        // [เพิ่ม] เมธอดสำหรับโหลดข้อมูลตะกร้า
        private void LoadCart()
        {
            if (Session["MemberID"] == null) return; // เช็คอีกครั้งเผื่อไว้

            int memberId = Convert.ToInt32(Session["MemberID"]);
            decimal subtotal = 0;
            const decimal shippingCost = 50; // ค่าส่งคงที่

            using (SqlConnection conn = new SqlConnection(GetConnectionString()))
            {
                // Query ดึงข้อมูลตะกร้า
                // ใช้ ISNULL เพื่อกำหนด URL รูปภาพเริ่มต้นหาก CoverUrl เป็น NULL
                string query = @"
                    SELECT
                        b.BookID,
                        b.Title,
                        ISNULL(cv.CoverUrl, 'https://raw.githubusercontent.com/Bobbydeb/OnlineBookStore/refs/heads/master/OnlineBookStore/wwwroot/images/00_DefaultBook.jpg') AS CoverUrl,
                        b.Price,
                        ci.Quantity,
                        (b.Price * ci.Quantity) AS TotalPrice
                    FROM CartItem ci
                    JOIN Cart c ON ci.CartID = c.CartID
                    JOIN Book b ON ci.BookID = b.BookID
                    LEFT JOIN Cover cv ON b.CoverID = cv.CoverID
                    WHERE c.MemberID = @MemberID";

                try
                {
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@MemberID", memberId);
                        conn.Open();

                        DataTable dtCartItems = new DataTable(); // [แก้ไข] เปลี่ยนชื่อ dt เป็น dtCartItems เพื่อความชัดเจน
                        SqlDataAdapter da = new SqlDataAdapter(cmd);
                        da.Fill(dtCartItems);

                        if (dtCartItems.Rows.Count > 0)
                        {
                            // มีสินค้าในตะกร้า
                            pnlCart.Visible = true;
                            pnlEmptyCart.Visible = false;

                            RepeaterCart.DataSource = dtCartItems;
                            RepeaterCart.DataBind();

                            // คำนวณราคารวม
                            foreach (DataRow row in dtCartItems.Rows)
                            {
                                subtotal += Convert.ToDecimal(row["TotalPrice"]);
                            }

                            ltlSubtotal.Text = $"฿{subtotal:N2}";
                            ltlShipping.Text = $"฿{shippingCost:N2}";
                            ltlTotal.Text = $"฿{subtotal + shippingCost:N2}";

                            // [เพิ่ม] เก็บข้อมูล cart items และ total ไว้ใน Session หรือ ViewState เพื่อใช้ตอน Checkout
                            Session["CartItemsData"] = dtCartItems;
                            Session["CartTotalAmount"] = subtotal + shippingCost;
                        }
                        else
                        {
                            // ไม่มีสินค้าในตะกร้า
                            pnlCart.Visible = false;
                            pnlEmptyCart.Visible = true;

                            // ตั้งค่าเริ่มต้นสำหรับ Panel ว่าง
                            ltlSubtotal.Text = "฿0.00";
                            ltlShipping.Text = "฿0.00"; // ถ้าไม่มีของก็ไม่ควรมีค่าส่ง
                            ltlTotal.Text = "฿0.00";

                            // [เพิ่ม] ล้าง Session ที่อาจค้างอยู่
                            Session.Remove("CartItemsData");
                            Session.Remove("CartTotalAmount");
                        }
                    }
                }
                catch (Exception ex)
                {
                    Debug.WriteLine("Error loading cart: " + ex.Message);
                    // อาจจะแสดงข้อความ Error บนหน้าเว็บ
                    pnlCart.Visible = false;
                    pnlEmptyCart.Visible = true;
                    Session.Remove("CartItemsData");
                    Session.Remove("CartTotalAmount");
                }
            }
        }

        // [เพิ่ม] Event Handler สำหรับปุ่มใน Repeater
        protected void RepeaterCart_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (Session["MemberID"] == null)
            {
                Response.Redirect("loginPage.aspx");
                return;
            }

            int memberId = Convert.ToInt32(Session["MemberID"]);
            int bookId = Convert.ToInt32(e.CommandArgument);

            // หา CartID ของ user
            int cartId = GetCartId(memberId);
            if (cartId == 0) return; // ไม่ควรเกิดขึ้นถ้า user มีของในตะกร้า

            if (e.CommandName == "Remove")
            {
                // ลบสินค้าออกจาก CartItem
                RemoveFromCart(cartId, bookId);
            }
            else if (e.CommandName == "Update")
            {
                // อัปเดตจำนวนสินค้า
                TextBox txtQuantity = (TextBox)e.Item.FindControl("txtQuantity");
                int newQuantity;
                if (int.TryParse(txtQuantity.Text, out newQuantity) && newQuantity > 0)
                {
                    UpdateCartItem(cartId, bookId, newQuantity);
                }
                else if (newQuantity <= 0)
                {
                    // ถ้าใส่ 0 หรือน้อยกว่า ให้ลบ
                    RemoveFromCart(cartId, bookId);
                }
                // ถ้าใส่ค่าไม่ถูกต้อง (เช่น "abc") ก็จะไม่ทำอะไร
            }

            // โหลดข้อมูลตะกร้าและจำนวนใหม่ทั้งหมด
            LoadCart();
            LoadCartCount();
        }

        // --- [เพิ่ม] Event Handler สำหรับปุ่ม Checkout ---
        protected void btnCheckout_Click(object sender, EventArgs e)
        {
            if (Session["MemberID"] == null)
            {
                Response.Redirect("loginPage.aspx");
                return;
            }
            // [แก้ไข] ดึงข้อมูลจาก Session มาใช้โดยตรง ถ้าไม่มีค่อยโหลดใหม่
            DataTable dtCartItems = Session["CartItemsData"] as DataTable;
            object totalAmountObj = Session["CartTotalAmount"];

            if (dtCartItems == null || totalAmountObj == null)
            {
                // ไม่มีข้อมูลตะกร้าใน Session อาจเกิดข้อผิดพลาด หรือตะกร้าว่าง
                LoadCart(); // ลองโหลดใหม่จาก DB
                // ดึงข้อมูลจาก Session อีกครั้งหลัง LoadCart()
                dtCartItems = Session["CartItemsData"] as DataTable;
                totalAmountObj = Session["CartTotalAmount"];

                if (dtCartItems == null || totalAmountObj == null || dtCartItems.Rows.Count == 0) // ถ้ายังไม่มี หรือโหลดมาแล้วว่าง ก็ไม่ต้องทำอะไรต่อ
                {
                    Debug.WriteLine("Checkout attempt with no cart data.");
                    // อาจจะแสดงข้อความว่าตะกร้าว่าง
                    return;
                }
            }

            int memberId = Convert.ToInt32(Session["MemberID"]);
            decimal totalAmount = Convert.ToDecimal(totalAmountObj);
            int cartId = GetCartId(memberId); // CartID สำหรับใช้ลบ CartItem

            // ตรวจสอบอีกครั้งก่อนดำเนินการ เผื่อกรณีข้อมูลใน Session ไม่ตรงกับ DB
            if (dtCartItems.Rows.Count == 0 || cartId == 0)
            {
                Debug.WriteLine("Checkout attempt with empty cart data or invalid CartID.");
                LoadCart(); // โหลดข้อมูลจริงจาก DB เพื่อแสดงผลให้ถูกต้อง
                LoadCartCount();
                return; // ตะกร้าว่าง หรือหา CartID ไม่เจอ
            }


            int newOrderId = 0; // ตัวแปรสำหรับเก็บ OrderID ที่สร้างใหม่

            using (SqlConnection conn = new SqlConnection(GetConnectionString()))
            {
                conn.Open();
                SqlTransaction transaction = conn.BeginTransaction(); // เริ่ม Transaction

                try
                {
                    // 1. สร้าง Order ใหม่ใน OrderTable
                    string insertOrderQuery = @"
                        INSERT INTO OrderTable (MemberID, TotalAmount)
                        OUTPUT INSERTED.OrderID
                        VALUES (@MemberID, @TotalAmount);";
                    // OrderDate และ Status จะใช้ค่า DEFAULT จาก DDL

                    using (SqlCommand cmdOrder = new SqlCommand(insertOrderQuery, conn, transaction))
                    {
                        cmdOrder.Parameters.AddWithValue("@MemberID", memberId);
                        cmdOrder.Parameters.AddWithValue("@TotalAmount", totalAmount);

                        // ExecuteScalar เพื่อดึงค่า OrderID ที่เพิ่งสร้าง (จาก OUTPUT INSERTED.OrderID)
                        newOrderId = (int)cmdOrder.ExecuteScalar();
                    }

                    if (newOrderId > 0)
                    {
                        // 2. เพิ่มรายการสินค้าลงใน OrderDetail
                        string insertDetailQuery = @"
                            INSERT INTO OrderDetail (OrderID, BookID, Quantity, UnitPrice)
                            VALUES (@OrderID, @BookID, @Quantity, @UnitPrice);";

                        using (SqlCommand cmdDetail = new SqlCommand(insertDetailQuery, conn, transaction))
                        {
                            foreach (DataRow row in dtCartItems.Rows)
                            {
                                cmdDetail.Parameters.Clear(); // ล้าง Parameters เก่าก่อนวนรอบใหม่
                                cmdDetail.Parameters.AddWithValue("@OrderID", newOrderId);
                                cmdDetail.Parameters.AddWithValue("@BookID", Convert.ToInt32(row["BookID"]));
                                cmdDetail.Parameters.AddWithValue("@Quantity", Convert.ToInt32(row["Quantity"]));
                                cmdDetail.Parameters.AddWithValue("@UnitPrice", Convert.ToDecimal(row["Price"])); // ใช้ราคาต่อหน่วย ณ ตอนสั่งซื้อ
                                cmdDetail.ExecuteNonQuery();
                            }
                        }

                        // 3. ลบสินค้าออกจาก CartItem (ล้างตะกร้า)
                        string deleteCartItemsQuery = "DELETE FROM CartItem WHERE CartID = @CartID";
                        using (SqlCommand cmdDeleteCart = new SqlCommand(deleteCartItemsQuery, conn, transaction))
                        {
                            cmdDeleteCart.Parameters.AddWithValue("@CartID", cartId);
                            cmdDeleteCart.ExecuteNonQuery();
                        }

                        // ถ้าทุกอย่างสำเร็จ ให้ Commit Transaction
                        transaction.Commit();

                        // 4. ล้าง Session
                        Session.Remove("CartItemsData");
                        Session.Remove("CartTotalAmount");

                        // 5. [เพิ่ม] อัปเดต UI ให้แสดงตะกร้าว่างก่อน Redirect
                        pnlCart.Visible = false;
                        pnlEmptyCart.Visible = true;
                        ltlSubtotal.Text = "฿0.00";
                        ltlShipping.Text = "฿0.00";
                        ltlTotal.Text = "฿0.00";
                        RepeaterCart.DataSource = null; // เคลียร์ DataSource
                        RepeaterCart.DataBind();        // Bind ใหม่เพื่อให้ Repeater ว่าง

                        // 6. อัปเดตเลขตะกร้าบน Header เป็น 0
                        LoadCartCount();

                        // 7. [แก้ไข] Redirect ไปหน้า myCollectionPage แทน
                        Response.Redirect("myCollectionPage.aspx");
                    }
                    else
                    {
                        // ไม่สามารถสร้าง OrderID ได้
                        throw new Exception("Failed to create new OrderID.");
                    }
                }
                catch (Exception ex)
                {
                    // หากเกิดข้อผิดพลาด ให้ Rollback Transaction
                    try
                    {
                        transaction.Rollback();
                    }
                    catch (Exception rbEx)
                    {
                        Debug.WriteLine("Rollback failed: " + rbEx.Message);
                    }
                    Debug.WriteLine("Error during checkout process: " + ex.Message);
                    // อาจจะแสดงข้อความแจ้งเตือนผู้ใช้บนหน้าเว็บ
                    // lblErrorMessage.Text = "เกิดข้อผิดพลาดในการสั่งซื้อ กรุณาลองใหม่อีกครั้ง";
                    // lblErrorMessage.Visible = true;
                }
            } // ปิด Connection อัตโนมัติ
        }


        // [เพิ่ม] Helper: หา CartID
        private int GetCartId(int memberId)
        {
            int cartId = 0;
            using (SqlConnection conn = new SqlConnection(GetConnectionString()))
            {
                try
                {
                    conn.Open();
                    // เราต้องการ CartID ที่มีอยู่
                    string query = "SELECT CartID FROM Cart WHERE MemberID = @MemberID";
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@MemberID", memberId);
                        object result = cmd.ExecuteScalar();
                        if (result != null && result != DBNull.Value)
                        {
                            cartId = Convert.ToInt32(result);
                        }
                        // [เพิ่ม] ถ้าไม่มี Cart ให้สร้างใหม่ (กรณีที่ไม่เคยมีตะกร้าเลย)
                        else
                        {
                            string createCartQuery = "INSERT INTO Cart (MemberID) OUTPUT INSERTED.CartID VALUES (@MemberID)";
                            using (SqlCommand cmdCreate = new SqlCommand(createCartQuery, conn))
                            {
                                cmdCreate.Parameters.AddWithValue("@MemberID", memberId);
                                cartId = (int)cmdCreate.ExecuteScalar();
                            }
                        }
                    }
                }
                catch (Exception ex)
                {
                    Debug.WriteLine("Error in GetCartId: " + ex.Message);
                }
            }
            return cartId;
        }

        // [เพิ่ม] Helper: ลบสินค้า
        private void RemoveFromCart(int cartId, int bookId)
        {
            using (SqlConnection conn = new SqlConnection(GetConnectionString()))
            {
                try
                {
                    conn.Open();
                    string query = "DELETE FROM CartItem WHERE CartID = @CartID AND BookID = @BookID";
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@CartID", cartId);
                        cmd.Parameters.AddWithValue("@BookID", bookId);
                        cmd.ExecuteNonQuery();
                    }
                }
                catch (Exception ex)
                {
                    Debug.WriteLine("Error in RemoveFromCart: " + ex.Message);
                }
            }
        }

        // [เพิ่ม] Helper: อัปเดตจำนวน
        private void UpdateCartItem(int cartId, int bookId, int quantity)
        {
            using (SqlConnection conn = new SqlConnection(GetConnectionString()))
            {
                try
                {
                    conn.Open();
                    string query = "UPDATE CartItem SET Quantity = @Quantity WHERE CartID = @CartID AND BookID = @BookID";
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@Quantity", quantity);
                        cmd.Parameters.AddWithValue("@CartID", cartId);
                        cmd.Parameters.AddWithValue("@BookID", bookId);
                        cmd.ExecuteNonQuery();
                    }
                }
                catch (Exception ex)
                {
                    Debug.WriteLine("Error in UpdateCartItem: " + ex.Message);
                }
            }
        }

        // --- [เพิ่ม] Event Handlers สำหรับ Header (จาก mainpage.aspx.cs) ---

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon(); // ควรใช้ Abandon เพื่อทำลาย Session จริงๆ
            Response.Redirect("mainpage.aspx");
        }

 
    }
}

