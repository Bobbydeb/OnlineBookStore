<!DOCTYPE html>
<html lang="th">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Bookstore (Layout inspired by Luckpim)</title>
    <style>
        /* General Styles */
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            background-color: #f0f2f5;
            color: #333;
        }

        a {
            text-decoration: none;
            color: inherit;
        }

        .container {
            width: 90%;
            max-width: 1200px;
            margin: 0 auto;
        }

        /* Header (Top Bar) */
        .top-header {
            background-color: #ffffff;
            padding: 10px 0;
            border-bottom: 1px solid #ddd;
        }

        .top-header .container {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .logo {
            font-size: 1.5rem;
            font-weight: bold;
            color: #d90000; /* Inspired color */
        }

        .search-bar {
            flex-grow: 1;
            margin: 0 20px;
        }

        .search-bar input {
            width: 100%;
            padding: 8px 12px;
            border: 1px solid #ccc;
            border-radius: 20px;
        }

        .header-icons {
            display: flex;
            gap: 15px;
        }

        /* Navigation Bar */
        .main-nav {
            background-color: #333;
            color: white;
            padding: 10px 0;
        }

        .main-nav .container {
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .main-nav ul {
            list-style: none;
            margin: 0;
            padding: 0;
            display: flex;
            gap: 15px;
            flex-wrap: wrap;
            justify-content: center;
        }

        .main-nav li a {
            padding: 10px 12px;
            font-size: 0.9rem;
            display: block;
            border-radius: 5px;
            transition: background-color 0.3s;
        }

        .main-nav li a:hover {
            background-color: #555;
        }

        /* Main Content */
        main {
            padding: 20px 0;
        }

        .section-title {
            font-size: 1.8rem;
            font-weight: bold;
            margin-top: 20px;
            margin-bottom: 20px;
            color: #111;
        }

        /* Book Grid */
        .book-grid {
            display: grid;
            grid-template-columns: repeat(5, 1fr);
            gap: 20px;
            min-height: 300px; /* เพิ่ม min-height เผื่อตอน JavaScript โหลด */
        }

        .book-card {
            background-color: #ffffff;
            border: 1px solid #e0e0e0;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 2px 5px rgba(0,0,0,0.05);
            transition: transform 0.3s, box-shadow 0.3s;
            display: flex; /* ใช้ flexbox ช่วยจัด layout ภายใน card */
            flex-direction: column; /* เรียงจากบนลงล่าง */
        }

        .book-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }

        .book-card img {
            width: 100%;
            height: 250px;
            object-fit: cover;
            background-color: #ccc; /* Placeholder color */
        }

        .book-card-content {
            padding: 15px;
            flex-grow: 1; /* ทำให้ content ขยายเต็มพื้นที่ที่เหลือ */
            display: flex;
            flex-direction: column;
            justify-content: space-between; /* จัด Title/Category ไว้บน Price ไว้ล่าง */
        }

         .book-card-content div { /* จัดกลุ่ม Title กับ Category */
             margin-bottom: 10px;
         }


        .book-title {
            font-size: 1rem;
            font-weight: 600;
            margin: 0;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
            height: 40px; /* Adjust height based on font-size and line-height */
            line-height: 1.25;
        }

        .book-category {
            font-size: 0.85rem;
            color: #777;
            margin-top: 5px;
        }

        .book-price {
            font-size: 1.1rem;
            font-weight: bold;
            color: #d90000;
            margin-top: auto; /* ดันราคาลงล่างสุด */
        }
    </style>
</head>
<body>

    <header class="top-header">
        <div class="container">
            <div class="logo">MyBookstore</div>
            <div class="search-bar">
                <input type="text" placeholder="ค้นหาหนังสือ...">
            </div>
            <div class="header-icons">
                <span>🛒 Cart</span>
                <span>👤 Login</span>
            </div>
        </div>
    </header>

    <nav class="main-nav">
        <div class="container">
            <ul>
                <li><a href="#">หน้าแรก</a></li>
                <li><a href="#">Fiction</a></li>
                <li><a href="#">Non-fiction</a></li>
                <li><a href="#">Children’s Books</a></li>
                <li><a href="#">Education / Academic</a></li>
                <li><a href="#">Comics / Graphic Novels / Manga</a></li>
                <li><a href="#">Art / Design / Photography</a></li>
                <li><a href="#">Religion / Spirituality</a></li>
                <li><a href="#">Science / Technology</a></li>
                <li><a href="#">Business / Economics</a></li>
                <li><a href="#">Cookbooks / Lifestyle</a></li>
                <li><a href="#">Poetry / Drama</a></li>
            </ul>
        </div>
    </nav>

    <main class="container">

        <h2 class="section-title">หนังสือแนะนำ</h2>
        <section id="recommended-books" class="book-grid">
            </section>


        <h2 class="section-title">Top 10 หนังสือขายดี</h2>
        <section class="book-grid">

    </main>

    <script>
        document.addEventListener('DOMContentLoaded', () => {
            const recommendedBooksGrid = document.querySelector('#recommended-books'); // อ้างอิงจาก ID ที่เพิ่มเข้าไป

            // Mapping CategoryID to CategoryName (จาก insertSamples.sql)
            const categoryMap = {
                1: 'Fiction', 2: 'Non-fiction', 3: 'Children’s Books', 4: 'Education / Academic',
                5: 'Comics / Graphic Novels / Manga', 6: 'Art / Design / Photography', 7: 'Religion / Spirituality',
                8: 'Science / Technology', 9: 'Business / Economics', 10: 'Cookbooks / Lifestyle', 11: 'Poetry / Drama'
            };

            // ข้อมูลหนังสือทั้งหมด (จาก insertSamples.sql)
            // หมายเหตุ: เพื่อความกระชับ ในตัวอย่างนี้ใส่ข้อมูลแค่บางส่วน คุณต้องใส่ข้อมูลหนังสือให้ครบ 200 เล่ม
            const allBooks = [
                { title: "Across Darkness", categoryId: 11, price: 56.82 },
                { title: "The Dream", categoryId: 9, price: 81.52 },
                { title: "Across Fire", categoryId: 9, price: 59.06 },
                { title: "Across Ocean", categoryId: 4, price: 72.89 },
                { title: "The Empire", categoryId: 5, price: 31.12 },
                { title: "Across Secret", categoryId: 11, price: 64.23 },
                { title: "A Darkness", categoryId: 8, price: 102.77 },
                { title: "Under Fire", categoryId: 7, price: 46.75 },
                { title: "Inside Darkness", categoryId: 2, price: 107.59 },
                { title: "Under Light", categoryId: 7, price: 94.69 },
                { title: "The Empire", categoryId: 4, price: 100.32 },
                { title: "Beyond Dream", categoryId: 6, price: 31.44 },
                { title: "Inside Light", categoryId: 1, price: 94.66 },
                { title: "The Ocean", categoryId: 3, price: 11.76 },
                { title: "A Secret", categoryId: 8, price: 92.56 },
                { title: "Beyond Secret", categoryId: 5, price: 40.77 },
                { title: "Inside Light", categoryId: 9, price: 12.29 },
                { title: "The Darkness", categoryId: 1, price: 72.32 },
                { title: "The Darkness", categoryId: 4, price: 49.72 },
                { title: "Under Empire", categoryId: 9, price: 32.53 },
                { title: "Across Ocean", categoryId: 4, price: 76.55 },
                { title: "Across Ocean", categoryId: 7, price: 28.87 },
                { title: "Beyond Journey", categoryId: 2, price: 84.59 },
                { title: "Inside Light", categoryId: 9, price: 50.45 },
                { title: "A Fire", categoryId: 9, price: 20.92 },
                { title: "Inside Future", categoryId: 2, price: 89.07 },
                { title: "Beyond Ocean", categoryId: 5, price: 35.58 },
                { title: "Under Fire", categoryId: 7, price: 105.48 },
                { title: "Under Future", categoryId: 11, price: 70.94 },
                { title: "Across Dream", categoryId: 2, price: 66.67 },
                { title: "Under Darkness", categoryId: 7, price: 58.79 },
                { title: "Under Dream", categoryId: 11, price: 49.81 },
                { title: "Beyond Light", categoryId: 7, price: 30.6 },
                { title: "Beyond Ocean", categoryId: 2, price: 34.17 },
                { title: "Inside Darkness", categoryId: 11, price: 17.89 },
                { title: "Beyond Darkness", categoryId: 3, price: 54.53 },
                { title: "Inside Empire", categoryId: 9, price: 119.83 },
                { title: "Across War", categoryId: 9, price: 28.69 },
                { title: "Beyond Light", categoryId: 2, price: 72.33 },
                { title: "The Dream", categoryId: 5, price: 79.62 },
                { title: "A Fire", categoryId: 6, price: 11.86 },
                { title: "Under Future", categoryId: 1, price: 92.13 },
                { title: "Beyond Future", categoryId: 9, price: 109.53 },
                { title: "The Dream", categoryId: 10, price: 15.88 },
                { title: "Under Light", categoryId: 9, price: 28.43 },
                { title: "Under Fire", categoryId: 5, price: 10.85 },
                { title: "A Darkness", categoryId: 4, price: 85.04 },
                { title: "Inside War", categoryId: 6, price: 112.58 },
                { title: "A Empire", categoryId: 3, price: 86.74 },
                { title: "The War", categoryId: 2, price: 39.69 },
                { title: "Across Journey", categoryId: 7, price: 12.81 },
                { title: "Inside Secret", categoryId: 8, price: 92.23 },
                { title: "Beyond Darkness", categoryId: 10, price: 89.13 },
                { title: "A Journey", categoryId: 11, price: 38.28 },
                { title: "Across Future", categoryId: 5, price: 15.77 },
                { title: "The War", categoryId: 4, price: 40.35 },
                { title: "A Empire", categoryId: 3, price: 85.55 },
                { title: "Under Ocean", categoryId: 1, price: 113.92 },
                { title: "A Ocean", categoryId: 8, price: 39.6 },
                { title: "Across War", categoryId: 10, price: 44.96 },
                { title: "Across War", categoryId: 11, price: 14.26 },
                { title: "Under Fire", categoryId: 6, price: 83.9 },
                { title: "Under Ocean", categoryId: 7, price: 22.49 },
                { title: "The Secret", categoryId: 6, price: 81.04 },
                { title: "Beyond Journey", categoryId: 7, price: 60.64 },
                { title: "A Empire", categoryId: 11, price: 84.93 },
                { title: "A Light", categoryId: 10, price: 15.49 },
                { title: "Across Fire", categoryId: 9, price: 16.53 },
                { title: "A Future", categoryId: 7, price: 86.24 },
                { title: "Under Dream", categoryId: 11, price: 107.9 },
                { title: "Under Journey", categoryId: 3, price: 96.35 },
                { title: "The Journey", categoryId: 6, price: 22.39 },
                { title: "Under Darkness", categoryId: 8, price: 102.84 },
                { title: "A War", categoryId: 1, price: 71.35 },
                { title: "The Light", categoryId: 11, price: 53.91 },
                { title: "Under Dream", categoryId: 3, price: 87.17 },
                { title: "Inside Fire", categoryId: 1, price: 86.06 },
                { title: "Beyond Light", categoryId: 8, price: 58.22 },
                { title: "Beyond Fire", categoryId: 2, price: 101.98 },
                { title: "A Dream", categoryId: 11, price: 40.65 },
                { title: "Inside Journey", categoryId: 7, price: 62.56 },
                { title: "The War", categoryId: 1, price: 82.55 },
                { title: "Inside Dream", categoryId: 5, price: 85.61 },
                { title: "A Light", categoryId: 10, price: 90.32 },
                { title: "Beyond Fire", categoryId: 11, price: 95.06 },
                { title: "Inside Fire", categoryId: 7, price: 23.84 },
                { title: "Beyond Darkness", categoryId: 3, price: 105.55 },
                { title: "A Future", categoryId: 1, price: 69.61 },
                { title: "Across Empire", categoryId: 9, price: 88.06 },
                { title: "A Journey", categoryId: 9, price: 107.03 },
                { title: "Under Dream", categoryId: 6, price: 67.45 },
                { title: "A Fire", categoryId: 8, price: 53.41 },
                { title: "Beyond War", categoryId: 1, price: 71.27 },
                { title: "A Secret", categoryId: 9, price: 32.69 },
                { title: "Beyond Empire", categoryId: 11, price: 41.07 },
                { title: "The War", categoryId: 6, price: 49.15 },
                { title: "A Empire", categoryId: 5, price: 111.45 },
                { title: "Inside Dream", categoryId: 3, price: 102.71 },
                { title: "Beyond Fire", categoryId: 3, price: 44.62 },
                { title: "Beyond Future", categoryId: 8, price: 95.67 },
                { title: "Inside Journey", categoryId: 1, price: 40.65 },
                { title: "Across Dream", categoryId: 7, price: 77.28 },
                { title: "Beyond War", categoryId: 1, price: 54.95 },
                { title: "A War", categoryId: 11, price: 68.93 },
                { title: "Inside Dream", categoryId: 3, price: 115.74 },
                { title: "Beyond Fire", categoryId: 3, price: 111.48 },
                { title: "Beyond Dream", categoryId: 10, price: 53.29 },
                { title: "Across Journey", categoryId: 5, price: 96.55 },
                { title: "The Fire", categoryId: 7, price: 16.09 },
                { title: "Beyond Light", categoryId: 8, price: 98.63 },
                { title: "The Empire", categoryId: 5, price: 111.3 },
                { title: "Inside Journey", categoryId: 10, price: 68.27 },
                { title: "A Ocean", categoryId: 6, price: 24.81 },
                { title: "A Empire", categoryId: 1, price: 66.01 },
                { title: "Beyond War", categoryId: 5, price: 54.4 },
                { title: "A Ocean", categoryId: 9, price: 33.53 },
                { title: "Across Fire", categoryId: 7, price: 113.85 },
                { title: "A Empire", categoryId: 10, price: 55.14 },
                { title: "Across Secret", categoryId: 10, price: 113.02 },
                { title: "The Future", categoryId: 7, price: 63.28 },
                { title: "The Empire", categoryId: 7, price: 92.52 },
                { title: "Inside Light", categoryId: 6, price: 28.96 },
                { title: "A Secret", categoryId: 5, price: 87.57 },
                { title: "Across Ocean", categoryId: 7, price: 101.27 },
                { title: "The Light", categoryId: 2, price: 87.27 },
                { title: "The War", categoryId: 2, price: 87.6 },
                { title: "A Fire", categoryId: 4, price: 56.72 },
                { title: "Under Darkness", categoryId: 7, price: 66.16 },
                { title: "Across Journey", categoryId: 3, price: 119.47 },
                { title: "Beyond Journey", categoryId: 11, price: 73.73 },
                { title: "Under Ocean", categoryId: 6, price: 65.31 },
                { title: "A Light", categoryId: 1, price: 17.93 },
                { title: "The Fire", categoryId: 6, price: 87.34 },
                { title: "Under Darkness", categoryId: 9, price: 100.71 },
                { title: "Under Secret", categoryId: 4, price: 111.74 },
                { title: "Across Dream", categoryId: 3, price: 109.64 },
                { title: "Beyond Ocean", categoryId: 7, price: 80.73 },
                { title: "A Journey", categoryId: 3, price: 95.48 },
                { title: "Under Future", categoryId: 11, price: 80.84 },
                { title: "Inside Fire", categoryId: 8, price: 74.23 },
                { title: "Under War", categoryId: 11, price: 13.22 },
                { title: "The Journey", categoryId: 2, price: 57.39 },
                { title: "The Light", categoryId: 4, price: 112.66 },
                { title: "Beyond Ocean", categoryId: 8, price: 11.34 },
                { title: "Under Light", categoryId: 7, price: 26.19 },
                { title: "Inside Ocean", categoryId: 9, price: 74.36 },
                { title: "Beyond Future", categoryId: 11, price: 47.52 },
                { title: "Inside Secret", categoryId: 10, price: 59.14 },
                { title: "The Dream", categoryId: 9, price: 71.07 },
                { title: "A Darkness", categoryId: 1, price: 86.11 },
                { title: "Beyond Light", categoryId: 10, price: 93.84 },
                { title: "A War", categoryId: 2, price: 84.49 },
                { title: "Across Light", categoryId: 10, price: 25.99 },
                { title: "Beyond Ocean", categoryId: 9, price: 58.38 },
                { title: "Across Journey", categoryId: 6, price: 36.17 },
                { title: "Across War", categoryId: 2, price: 74.86 },
                { title: "Across Future", categoryId: 9, price: 72.86 },
                { title: "Across Secret", categoryId: 5, price: 78.43 },
                { title: "Across Future", categoryId: 4, price: 97.76 },
                { title: "The War", categoryId: 7, price: 35.77 },
                { title: "The War", categoryId: 9, price: 19.65 },
                { title: "Across Secret", categoryId: 4, price: 49.68 },
                { title: "Under Future", categoryId: 6, price: 10.06 },
                { title: "Beyond Future", categoryId: 7, price: 80.65 },
                { title: "Across Dream", categoryId: 2, price: 104.44 },
                { title: "The Darkness", categoryId: 1, price: 29.39 },
                { title: "Inside Secret", categoryId: 2, price: 83.48 },
                { title: "Under Dream", categoryId: 6, price: 44.15 },
                { title: "Under Darkness", categoryId: 1, price: 82.52 },
                { title: "Beyond Secret", categoryId: 7, price: 105.89 },
                { title: "A War", categoryId: 3, price: 58.94 },
                { title: "Across Light", categoryId: 7, price: 16.91 },
                { title: "A Empire", categoryId: 3, price: 28.39 },
                { title: "Inside Journey", categoryId: 3, price: 85.93 },
                { title: "The Empire", categoryId: 6, price: 119.07 },
                { title: "Beyond Light", categoryId: 2, price: 42.83 },
                { title: "Across Ocean", categoryId: 8, price: 20.7 },
                { title: "Under Empire", categoryId: 6, price: 26.28 },
                { title: "A Ocean", categoryId: 3, price: 86.2 },
                { title: "Inside Future", categoryId: 5, price: 109.0 },
                { title: "A Secret", categoryId: 1, price: 54.33 },
                { title: "Inside Future", categoryId: 10, price: 81.62 },
                { title: "Under Journey", categoryId: 10, price: 92.28 },
                { title: "A Ocean", categoryId: 10, price: 22.19 },
                { title: "Across Secret", categoryId: 10, price: 70.28 },
                { title: "The Fire", categoryId: 10, price: 65.05 },
                { title: "The Light", categoryId: 11, price: 34.16 },
                { title: "Beyond Ocean", categoryId: 2, price: 56.93 },
                { title: "Across Darkness", categoryId: 3, price: 103.3 },
                { title: "The Dream", categoryId: 9, price: 57.88 },
                { title: "Inside Light", categoryId: 9, price: 110.1 },
                { title: "Across Future", categoryId: 9, price: 44.48 },
                { title: "Inside War", categoryId: 1, price: 80.87 },
                { title: "Inside Journey", categoryId: 1, price: 20.94 },
                { title: "The Darkness", categoryId: 8, price: 76.11 },
                { title: "Inside Darkness", categoryId: 10, price: 57.59 },
                { title: "Beyond Light", categoryId: 5, price: 118.97 },
                { title: "Beyond Dream", categoryId: 2, price: 16.45 },
                { title: "Beyond War", categoryId: 4, price: 94.05 },
                { title: "Across Fire", categoryId: 5, price: 85.01 }
            ];

            // ฟังก์ชันสุ่มลำดับ Array (Fisher-Yates Shuffle)
            function shuffleArray(array) {
                for (let i = array.length - 1; i > 0; i--) {
                    const j = Math.floor(Math.random() * (i + 1));
                    [array[i], array[j]] = [array[j], array[i]]; // สลับตำแหน่ง
                }
                return array;
            }

            const shuffledBooks = shuffleArray([...allBooks]); // ทำสำเนา array ก่อนสุ่ม
            const randomBooks = shuffledBooks.slice(0, 10); // เลือก 10 เล่มแรกหลังสุ่ม

            recommendedBooksGrid.innerHTML = ''; // ล้างการ์ดหนังสือเก่า (ถ้ามี)

            // วนลูปสร้างการ์ดหนังสือ 10 เล่ม
            randomBooks.forEach(book => {
                const bookCard = document.createElement('div');
                bookCard.classList.add('book-card');

                // สร้าง HTML content สำหรับการ์ด
                bookCard.innerHTML = `
                    <img src="https://via.placeholder.com/180x250.png?text=${encodeURIComponent(book.title.replace(/ /g, '+'))}" alt="${book.title}">
                    <div class="book-card-content">
                        <div>
                           <h3 class="book-title">${book.title}</h3>
                           <p class="book-category">${categoryMap[book.categoryId] || 'Unknown'}</p>
                        </div>
                        <p class="book-price">$${book.price.toFixed(2)}</p>
                    </div>
                `;
                recommendedBooksGrid.appendChild(bookCard); // เพิ่มการ์ดลงใน grid
            });
        });
    </script>

</body>
</html>