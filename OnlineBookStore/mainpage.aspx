<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="mainpage.aspx.cs" Inherits="OnlineBookStore.mainpage" %>

<!DOCTYPE html>
<html lang="th">
<head runat="server">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Luckpim Online - ร้านหนังสือการ์ตูน</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />

    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background-color: #f8f9fa;
        }
        .navbar {
            background-color: #e53935;
        }
        .navbar-brand {
            font-weight: bold;
            color: white !important;
        }
        .book-card img {
            height: 250px;
            object-fit: cover;
        }
        .login-btn {
            color: white;
            text-decoration: none;
            margin-left: 15px;
        }
        .login-btn:hover {
            text-decoration: underline;
            color: #ffebee;
        }
        footer {
            background-color: #212121;
            color: #fff;
            padding: 20px 0;
            margin-top: 40px;
            text-align: center;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">

        <nav class="navbar navbar-expand-lg navbar-dark">
            <div class="container">
                <a class="navbar-brand" href="#">Luckpim</a>
                <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                    <span class="navbar-toggler-icon"></span>
                </button>
                <div class="collapse navbar-collapse" id="navbarNav">
                    <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                        <li class="nav-item"><a class="nav-link active" href="#">หน้าแรก</a></li>
                        <li class="nav-item"><a class="nav-link" href="#">หนังสือใหม่</a></li>
                        <li class="nav-item"><a class="nav-link" href="#">โปรโมชั่น</a></li>
                        <li class="nav-item"><a class="nav-link" href="#">ติดต่อเรา</a></li>
                    </ul>

                    <form class="d-flex me-3">
                        <input class="form-control me-2" type="search" placeholder="ค้นหาหนังสือ..." aria-label="Search">
                        <button class="btn btn-light" type="submit">ค้นหา</button>
                    </form>

                    <a href="login.aspx" class="login-btn">เข้าสู่ระบบ / สมัครสมาชิก</a>
                </div>
            </div>
        </nav>

        <div id="mainCarousel" class="carousel slide mt-3" data-bs-ride="carousel">
            <div class="carousel-inner">
                <div class="carousel-item active">
                    <img src="https://via.placeholder.com/1200x400?text=โปรโมชั่น+ใหม่" class="d-block w-100" alt="Banner 1">
                </div>
                <div class="carousel-item">
                    <img src="https://via.placeholder.com/1200x400?text=การ์ตูน+มาใหม่" class="d-block w-100" alt="Banner 2">
                </div>
            </div>
            <button class="carousel-control-prev" type="button" data-bs-target="#mainCarousel" data-bs-slide="prev">
                <span class="carousel-control-prev-icon"></span>
            </button>
            <button class="carousel-control-next" type="button" data-bs-target="#mainCarousel" data-bs-slide="next">
                <span class="carousel-control-next-icon"></span>
            </button>
        </div>

        <div class="container mt-5">
            <h3 class="mb-4">หนังสือแนะนำ</h3>
            <div class="row g-4">
                <div class="col-md-3">
                    <div class="card book-card h-100">
                        <img src="https://via.placeholder.com/200x250?text=Book+1" class="card-img-top" alt="Book 1">
                        <div class="card-body text-center">
                            <h6 class="card-title">ชื่อหนังสือ 1</h6>
                            <p class="text-danger fw-bold">฿120</p>
                            <button class="btn btn-outline-danger btn-sm">หยิบใส่ตะกร้า</button>
                        </div>
                    </div>
                </div>

                <div class="col-md-3">
                    <div class="card book-card h-100">
                        <img src="https://via.placeholder.com/200x250?text=Book+2" class="card-img-top" alt="Book 2">
                        <div class="card-body text-center">
                            <h6 class="card-title">ชื่อหนังสือ 2</h6>
                            <p class="text-danger fw-bold">฿150</p>
                            <button class="btn btn-outline-danger btn-sm">หยิบใส่ตะกร้า</button>
                        </div>
                    </div>
                </div>

                <div class="col-md-3">
                    <div class="card book-card h-100">
                        <img src="https://via.placeholder.com/200x250?text=Book+3" class="card-img-top" alt="Book 3">
                        <div class="card-body text-center">
                            <h6 class="card-title">ชื่อหนังสือ 3</h6>
                            <p class="text-danger fw-bold">฿99</p>
                            <button class="btn btn-outline-danger btn-sm">หยิบใส่ตะกร้า</button>
                        </div>
                    </div>
                </div>

                <div class="col-md-3">
                    <div class="card book-card h-100">
                        <img src="https://via.placeholder.com/200x250?text=Book+4" class="card-img-top" alt="Book 4">
                        <div class="card-body text-center">
                            <h6 class="card-title">ชื่อหนังสือ 4</h6>
                            <p class="text-danger fw-bold">฿180</p>
                            <button class="btn btn-outline-danger btn-sm">หยิบใส่ตะกร้า</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="container mt-5">
            <h3 class="mb-4">หนังสือขายดี (Top 10) 🌟</h3>
            <div class="row row-cols-2 row-cols-md-3 row-cols-lg-5 g-4">

                <div class="col">
                    <div class="card book-card h-100">
                        <img src="https://via.placeholder.com/200x250?text=BOX+SET+15" class="card-img-top" alt="BOX SET หนุ่มเย็นชา">
                        <div class="card-body d-flex flex-column">
                            <p class="card-text text-muted" style="font-size: 0.8rem;">นิยาย/รักคอเมดี้</p>
                            <h6 class="card-title" style="font-size: 0.9rem; min-height: 40px;">【BOX SET】หนุ่มเย็นชากับยัยสาว... เล่ม 15 (จบ)</h6>
                            <p class="fw-bold text-danger mb-0 mt-auto">฿895.00</p>
                            <p class="text-muted small"><del>&nbsp;</del></p> <a href="#" class="btn btn-dark w-100 mt-2">เพิ่มลงตะกร้า</a>
                        </div>
                    </div>
                </div>

                <div class="col">
                    <div class="card book-card h-100">
                        <img src="https://via.placeholder.com/200x250?text=รายจ่ายโฮมเลส+1" class="card-img-top" alt="รายจ่ายโฮมเลสฯ เล่ม 1">
                        <div class="card-body d-flex flex-column">
                            <p class="card-text text-muted" style="font-size: 0.8rem;">นิยาย/วีรชนแฟนตาซี</p>
                            <h6 class="card-title" style="font-size: 0.9rem; min-height: 40px;">รายจ่ายโฮมเลสในต่างโลก เล่ม 1</h6>
                            <p class="fw-bold text-danger mb-0 mt-auto">฿100.00</p>
                            <p class="text-muted small"><del>฿120.00</del></p>
                            <a href="#" class="btn btn-dark w-100 mt-2">เพิ่มลงตะกร้า</a>
                        </div>
                    </div>
                </div>

                <div class="col">
                    <div class="card book-card h-100">
                        <img src="https://via.placeholder.com/200x250?text=รายจ่ายโฮมเลส+2" class="card-img-top" alt="รายจ่ายโฮมเลสฯ เล่ม 2">
                        <div class="card-body d-flex flex-column">
                            <p class="card-text text-muted" style="font-size: 0.8rem;">นิยาย/วีรชนแฟนตาซี</p>
                            <h6 class="card-title" style="font-size: 0.9rem; min-height: 40px;">รายจ่ายโฮมเลสในต่างโลก เล่ม 2</h6>
                            <p class="fw-bold text-danger mb-0 mt-auto">฿100.00</p>
                            <p class="text-muted small"><del>฿120.00</del></p>
                            <a href="#" class="btn btn-dark w-100 mt-2">เพิ่มลงตะกร้า</a>
                        </div>
                    </div>
                </div>

                <div class="col">
                    <div class="card book-card h-100">
                        <img src="https://via.placeholder.com/200x250?text=รายจ่ายโฮมเลส+5" class="card-img-top" alt="รายจ่ายโฮมเลสฯ เล่ม 5">
                        <div class="card-body d-flex flex-column">
                            <p class="card-text text-muted" style="font-size: 0.8rem;">นิยาย/วีรชนแฟนตาซี</p>
                            <h6 class="card-title" style="font-size: 0.9rem; min-height: 40px;">รายจ่ายโฮมเลสในต่างโลก เล่ม 5 (เล่มจบ)</h6>
                            <p class="fw-bold text-danger mb-0 mt-auto">฿100.00</p>
                            <p class="text-muted small"><del>฿120.00</del></p>
                            <a href="#" class="btn btn-dark w-100 mt-2">เพิ่มลงตะกร้า</a>
                        </div>
                    </div>
                </div>

                <div class="col">
                    <div class="card book-card h-100">
                        <img src="https://via.placeholder.com/200x250?text=เซ็ตพี่น้อง+13" class="card-img-top" alt="เซ็ตพี่น้องอลวน เล่ม 13">
                        <div class="card-body d-flex flex-column">
                            <p class="card-text text-muted" style="font-size: 0.8rem;">นิยาย/รักคอเมดี้</p>
                            <h6 class="card-title" style="font-size: 0.9rem; min-height: 40px;">เซ็ตพี่น้องอลวน เล่ม 13 (ปกพิเศษ)</h6>
                            <p class="fw-bold text-danger mb-0 mt-auto">฿195.00</p>
                            <p class="text-muted small"><del>฿280.00</del></p>
                            <a href="#" class="btn btn-dark w-100 mt-2">เพิ่มลงตะกร้า</a>
                        </div>
                    </div>
                </div>
                
                <div class="col">
                    <div class="card book-card h-100">
                        <img src="https://via.placeholder.com/200x250?text=SAKAMOTO+DAYS+13" class="card-img-top" alt="SAKAMOTO DAYS 13">
                        <div class="card-body d-flex flex-column">
                            <p class="card-text text-muted" style="font-size: 0.8rem;">มังงะ/ต่อสู้</p>
                            <h6 class="card-title" style="font-size: 0.9rem; min-height: 40px;">(พร้อมส่ง) Sakamoto Days เล่ม 13 (ปกพิเศษ)</h6>
                            <p class="fw-bold text-danger mb-0 mt-auto">฿195.00</p>
                             <p class="text-muted small"><del>&nbsp;</del></p> <a href="#" class="btn btn-dark w-100 mt-2">เพิ่มลงตะกร้า</a>
                        </div>
                    </div>
                </div>
                
                <div class="col">
                    <div class="card book-card h-100">
                        <img src="https://via.placeholder.com/200x250?text=จัสติแฟงเกอร์+4" class="card-img-top" alt="จัสติแฟงเกอร์ 4">
                        <div class="card-body d-flex flex-column">
                            <p class="card-text text-muted" style="font-size: 0.8rem;">นิยาย/แฟนตาซี</p>
                            <h6 class="card-title" style="font-size: 0.9rem; min-height: 40px;">จัสติแฟงเกอร์แห่งศีลธรรม เล่ม 4</h6>
                            <p class="fw-bold text-danger mb-0 mt-auto">฿100.00</p>
                            <p class="text-muted small"><del>฿120.00</del></p>
                            <a href="#" class="btn btn-dark w-100 mt-2">เพิ่มลงตะกร้า</a>
                        </div>
                    </div>
                </div>
                
                <div class="col">
                    <div class="card book-card h-100">
                        <img src="https://via.placeholder.com/200x250?text=หยุดถอดเกราะ+7" class="card-img-top" alt="หยุดถอดเกราะ 7">
                        <div class="card-body d-flex flex-column">
                            <p class="card-text text-muted" style="font-size: 0.8rem;">นิยาย/แฟนตาซี</p>
                            <h6 class="card-title" style="font-size: 0.9rem; min-height: 40px;">หยุดถอดเกราะคุณอัศวินที! เล่ม 07</h6>
                            <p class="fw-bold text-danger mb-0 mt-auto">฿112.50</p>
                            <p class="text-muted small"><del>฿125.00</del></p>
                            <a href="#" class="btn btn-dark w-100 mt-2">เพิ่มลงตะกร้า</a>
                        </div>
                    </div>
                </div>
                
                <div class="col">
                    <div class="card book-card h-100">
                        <img src="https://via.placeholder.com/200x250?text=จัสติแฟงเกอร์+3" class="card-img-top" alt="จัสติแฟงเกอร์ 3">
                        <div class="card-body d-flex flex-column">
                            <p class="card-text text-muted" style="font-size: 0.8rem;">นิยาย/แฟนตาซี</p>
                            <h6 class="card-title" style="font-size: 0.9rem; min-height: 40px;">จัสติแฟงเกอร์แห่งศีลธรรม เล่ม 3</h6>
                            <p class="fw-bold text-danger mb-0 mt-auto">฿100.00</p>
                            <p class="text-muted small"><del>฿120.00</del></p>
                            <a href="#" class="btn btn-dark w-100 mt-2">เพิ่มลงตะกร้า</a>
                        </div>
                    </div>
                </div>
                
                <div class="col">
                    <div class="card book-card h-100">
                        <img src="https://via.placeholder.com/200x250?text=จัสติแฟงเกอร์+2" class="card-img-top" alt="จัสติแฟงเกอร์ 2">
                        <div class="card-body d-flex flex-column">
                            <p class="card-text text-muted" style="font-size: 0.8rem;">นิยาย/แฟนตาซี</p>
                            <h6 class="card-title" style="font-size: 0.9rem; min-height: 40px;">จัสติแฟงเกอร์แห่งศีลธรรม เล่ม 2</h6>
                            <p class="fw-bold text-danger mb-0 mt-auto">฿100.00</p>
                            <p class="text-muted small"><del>฿120.00</del></p>
                            <a href="#" class="btn btn-dark w-100 mt-2">เพิ่มลงตะกร้า</a>
                        </div>
                    </div>
                </div>

            </div> </div> <footer>
            <div class="container">
                <p>© 2025 Luckpim Online. All rights reserved.</p>
                <p>ติดต่อ: support@luckpim.com | โทร: 02-xxx-xxxx</p>
            </div>
        </footer>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    </form>
</body>
</html>