<!DOCTYPE html>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="dto.Customer"%>
<%
    Customer loggedUser = (Customer) session.getAttribute("USER");
    boolean isAdmin = (loggedUser != null && loggedUser.getEmail().equals("admin@admin.com"));
%>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>AutoWash – Trạm Rửa Xe Thông Minh</title>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">
        <style>
            :root {
                --bg:        #080d14;
                --surface:   #0e1520;
                --surface2:  #141f2e;
                --border:    rgba(96,165,250,.12);
                --blue:      #3b82f6;
                --blue-glow: rgba(59,130,246,.35);
                --cyan:      #06b6d4;
                --text:      #f1f5f9;
                --muted:     #64748b;
                --card-h:    230px;
            }
            *{
                margin:0;
                padding:0;
                box-sizing:border-box;
            }
            html{
                scroll-behavior:smooth;
            }
            body{
                background:var(--bg);
                color:var(--text);
                font-family:'Inter',sans-serif;
                min-height:100vh;
                overflow-x:hidden;
            }

            /* ── NAVBAR ── */
            nav{
                position:fixed;
                top:0;
                left:0;
                right:0;
                z-index:100;
                display:flex;
                justify-content:space-between;
                align-items:center;
                padding:0 60px;
                height:68px;
                background:rgba(8,13,20,.82);
                backdrop-filter:blur(14px);
                border-bottom:1px solid var(--border);
            }
            .logo{
                display:flex;
                align-items:center;
                gap:10px;
                font-size:20px;
                font-weight:800;
                letter-spacing:-.3px;
                color:var(--text);
                text-decoration:none;
            }
            .logo-icon{
                width:34px;
                height:34px;
                background:linear-gradient(135deg,var(--blue),var(--cyan));
                border-radius:8px;
                display:flex;
                align-items:center;
                justify-content:center;
                font-size:18px;
            }
            .nav-links{
                display:flex;
                align-items:center;
                gap:8px;
            }
            .nav-links a{
                color:var(--muted);
                text-decoration:none;
                padding:7px 14px;
                border-radius:8px;
                font-size:14px;
                font-weight:500;
                transition:color .2s,background .2s;
            }
            .nav-links a:hover{
                color:var(--text);
                background:var(--surface2);
            }
            .nav-cta{
                background:var(--blue)!important;
                color:#fff!important;
                padding:7px 18px!important;
            }
            .nav-cta:hover{
                background:#2563eb!important;
            }

            /* ── HERO ── */
            .hero{
                min-height:100vh;
                display:flex;
                flex-direction:column;
                align-items:center;
                justify-content:center;
                text-align:center;
                padding:100px 24px 60px;
                position:relative;
            }
            .hero::before{
                content:'';
                position:absolute;
                top:0;
                left:50%;
                transform:translateX(-50%);
                width:900px;
                height:600px;
                background:radial-gradient(ellipse at 50% 20%, rgba(59,130,246,.18) 0%, transparent 70%);
                pointer-events:none;
            }
            .hero-badge{
                display:inline-flex;
                align-items:center;
                gap:6px;
                background:rgba(59,130,246,.1);
                border:1px solid rgba(59,130,246,.3);
                border-radius:100px;
                padding:5px 14px;
                font-size:12px;
                font-weight:600;
                color:var(--blue);
                text-transform:uppercase;
                letter-spacing:.8px;
                margin-bottom:28px;
            }
            .hero h1{
                font-size:clamp(44px,7vw,80px);
                font-weight:900;
                line-height:1.05;
                letter-spacing:-2px;
                margin-bottom:24px;
            }
            .hero h1 span{
                background:linear-gradient(90deg,var(--blue),var(--cyan));
                -webkit-background-clip:text;
                -webkit-text-fill-color:transparent;
            }
            .hero p{
                font-size:18px;
                color:var(--muted);
                max-width:560px;
                line-height:1.7;
                margin-bottom:40px;
            }
            .hero-btns{
                display:flex;
                gap:14px;
                flex-wrap:wrap;
                justify-content:center;
            }
            .btn{
                display:inline-flex;
                align-items:center;
                gap:8px;
                padding:14px 28px;
                border-radius:10px;
                font-size:15px;
                font-weight:600;
                text-decoration:none;
                transition:all .2s;
                cursor:pointer;
                border:none;
            }
            .btn-primary{
                background:var(--blue);
                color:#fff;
                box-shadow:0 0 28px var(--blue-glow);
            }
            .btn-primary:hover{
                background:#2563eb;
                transform:translateY(-1px);
            }
            .btn-secondary{
                background:var(--surface2);
                color:var(--text);
                border:1px solid var(--border);
            }
            .btn-secondary:hover{
                border-color:var(--blue);
                color:var(--blue);
            }
            .btn-admin{
                background:linear-gradient(135deg,#7c3aed,#6d28d9);
                color:#fff;
                box-shadow:0 0 24px rgba(124,58,237,.3);
            }
            .btn-admin:hover{
                transform:translateY(-1px);
            }
            .btn-green{
                background:linear-gradient(135deg,#059669,#047857);
                color:#fff;
                box-shadow:0 0 24px rgba(5,150,105,.3);
            }
            .btn-green:hover{
                transform:translateY(-1px);
            }

            /* ── STATS ROW ── */
            .stats{
                display:flex;
                gap:0;
                background:var(--surface);
                border:1px solid var(--border);
                border-radius:16px;
                overflow:hidden;
                margin:56px auto 0;
                max-width:700px;
                width:100%;
            }
            .stat{
                flex:1;
                padding:22px 20px;
                text-align:center;
                border-right:1px solid var(--border);
            }
            .stat:last-child{
                border-right:none;
            }
            .stat-num{
                font-size:28px;
                font-weight:800;
                color:var(--blue);
            }
            .stat-label{
                font-size:12px;
                color:var(--muted);
                margin-top:4px;
                text-transform:uppercase;
                letter-spacing:.6px;
            }

            /* ── PACKAGES ── */
            .section{
                padding:80px 60px;
                max-width:1200px;
                margin:0 auto;
            }
            .section-label{
                font-size:12px;
                font-weight:700;
                letter-spacing:1.2px;
                text-transform:uppercase;
                color:var(--blue);
                margin-bottom:12px;
            }
            .section-title{
                font-size:clamp(28px,4vw,42px);
                font-weight:800;
                letter-spacing:-1px;
                margin-bottom:12px;
            }
            .section-sub{
                font-size:16px;
                color:var(--muted);
                max-width:500px;
                line-height:1.6;
                margin-bottom:48px;
            }
            .packages{
                display:grid;
                grid-template-columns:repeat(auto-fit,minmax(220px,1fr));
                gap:20px;
            }
            .pkg{
                background:var(--surface);
                border:1px solid var(--border);
                border-radius:16px;
                padding:28px 24px;
                transition:border-color .25s,transform .25s;
                position:relative;
                overflow:hidden;
            }
            .pkg:hover{
                border-color:var(--blue);
                transform:translateY(-3px);
            }
            .pkg.featured{
                border-color:var(--blue);
                background:linear-gradient(145deg,rgba(59,130,246,.08),var(--surface));
            }
            .pkg-badge{
                position:absolute;
                top:14px;
                right:14px;
                background:var(--blue);
                color:#fff;
                font-size:10px;
                font-weight:700;
                padding:3px 8px;
                border-radius:100px;
                letter-spacing:.5px;
                text-transform:uppercase;
            }
            .pkg-icon{
                font-size:32px;
                margin-bottom:14px;
            }
            .pkg-name{
                font-size:16px;
                font-weight:700;
                margin-bottom:6px;
            }
            .pkg-price{
                font-size:30px;
                font-weight:900;
                color:var(--blue);
                margin-bottom:4px;
                letter-spacing:-1px;
            }
            .pkg-price span{
                font-size:14px;
                font-weight:500;
                color:var(--muted);
            }
            .pkg-desc{
                font-size:13px;
                color:var(--muted);
                line-height:1.6;
                margin-top:10px;
            }
            .pkg-features{
                margin-top:16px;
                list-style:none;
            }
            .pkg-features li{
                font-size:13px;
                color:var(--muted);
                padding:5px 0;
                border-bottom:1px solid var(--border);
                display:flex;
                align-items:center;
                gap:8px;
            }
            .pkg-features li:last-child{
                border-bottom:none;
            }
            .pkg-features li::before{
                content:'✓';
                color:var(--cyan);
                font-weight:700;
                font-size:12px;
            }

            /* ── HOW IT WORKS ── */
            .steps{
                display:grid;
                grid-template-columns:repeat(auto-fit,minmax(200px,1fr));
                gap:24px;
                margin-top:0;
            }
            .step{
                background:var(--surface);
                border:1px solid var(--border);
                border-radius:14px;
                padding:28px 22px;
            }
            .step-num{
                width:40px;
                height:40px;
                border-radius:10px;
                background:linear-gradient(135deg,var(--blue),var(--cyan));
                display:flex;
                align-items:center;
                justify-content:center;
                font-weight:800;
                font-size:16px;
                margin-bottom:16px;
            }
            .step h4{
                font-size:15px;
                font-weight:700;
                margin-bottom:8px;
            }
            .step p{
                font-size:13px;
                color:var(--muted);
                line-height:1.6;
            }

            /* ── FOOTER ── */
            footer{
                border-top:1px solid var(--border);
                text-align:center;
                padding:32px;
                font-size:13px;
                color:var(--muted);
            }

            /* ── MODAL ── */
            .modal-overlay{
                position:fixed;
                inset:0;
                background:rgba(0,0,0,.7);
                display:none;
                align-items:center;
                justify-content:center;
                z-index:999;
                backdrop-filter:blur(4px);
            }
            .modal-box{
                background:var(--surface);
                border:1px solid var(--border);
                border-radius:20px;
                padding:44px 40px;
                text-align:center;
                width:360px;
            }
            .modal-icon{
                font-size:52px;
                margin-bottom:16px;
            }
            .modal-box h2{
                font-size:22px;
                font-weight:700;
                margin-bottom:8px;
            }
            .modal-box p{
                font-size:14px;
                color:var(--muted);
                margin-bottom:28px;
                line-height:1.6;
            }

            @media(max-width:768px){
                nav{
                    padding:0 20px;
                }
                .section{
                    padding:60px 20px;
                }
                .stats{
                    flex-direction:column;
                }
                .stat{
                    border-right:none;
                    border-bottom:1px solid var(--border);
                }
                .stat:last-child{
                    border-bottom:none;
                }
            }
        </style>
    </head>
    <body>

        <!-- NAVBAR -->
        <nav>
            <a href="MainController?action=home" class="logo">
                    AutoWash
            </a>
            <div class="nav-links">
                <a href="#packages">Bảng giá</a>
                <a href="#how">Quy trình</a>
                <% if (loggedUser == null) { %>
                <a href="MainController?action=loginPage">Đăng nhập</a>
                <a href="MainController?action=registerPage" class="nav-cta">Đăng ký</a>
                <% } else { %>
                <% if (isAdmin) { %>
                <a href="AdminController?action=listCustomers" class="nav-cta">Admin Dashboard</a>
                <% } else { %>
                <a href="MainController?action=dashboard" class="nav-cta">Dashboard</a>
                <% } %>
                <a href="MainController?action=logout">Đăng xuất</a>
                <% } %>
            </div>
        </nav>

        <!-- HERO -->
        <section class="hero">
            <div class="hero-badge">✦ Hệ thống rửa xe tự động</div>
            <h1>Sạch bóng mọi<br><span>chiếc xe của bạn</span></h1>
            <p>Đặt lịch rửa xe nhanh chóng, theo dõi tiến trình và tích luỹ điểm thưởng – tất cả trong một nền tảng duy nhất.</p>
            <div class="hero-btns">
                <% if (loggedUser == null) { %>
                <a href="MainController?action=loginPage" class="btn btn-primary">🚀 Bắt đầu ngay</a>
                <a href="MainController?action=registerPage" class="btn btn-secondary">Tạo tài khoản</a>
                <% } else if (isAdmin) { %>
                <a href="AdminController?action=listCustomers" class="btn btn-admin">👤 Admin Dashboard</a>
                <% } else { %>
                <a href="MainController?action=dashboard" class="btn btn-primary">📊 Vào Dashboard</a>
                <a href="#packages" class="btn btn-secondary">Xem gói rửa xe</a>
                <% } %>
            </div>
            <div class="stats">
                <div class="stat"><div class="stat-num">3</div><div class="stat-label">Gói dịch vụ</div></div>
                <div class="stat"><div class="stat-num">99%</div><div class="stat-label">Hài lòng</div></div>
                <div class="stat"><div class="stat-num">24/7</div><div class="stat-label">Hỗ trợ</div></div>
            </div>
        </section>

        <!-- PACKAGES -->
        <div id="packages" style="max-width:1200px;margin:0 auto;padding:80px 60px;">
            <div class="section-label">Bảng giá dịch vụ</div>
            <div class="section-title">Chọn gói rửa xe phù hợp</div>
            <div class="section-sub">Từ rửa xe cơ bản đến chăm sóc toàn diện – chúng tôi có gói dịch vụ dành riêng cho bạn.</div>
            <div class="packages">
                <div class="pkg">
                    <div class="pkg-icon">💧</div>
                    <div class="pkg-name">Basic Wash</div>
                    <div class="pkg-price">100K<span> /lần</span></div>
                    <div class="pkg-desc">Rửa nhanh, sạch bụi bẩn bên ngoài xe.</div>
                    <ul class="pkg-features">
                        <li>Exterior wash</li>
                        <li>Lau khô cơ bản</li>
                        <li>Tích 100 điểm</li>
                    </ul>
                </div>
                <div class="pkg featured">
                    <div class="pkg-badge">Phổ biến</div>
                    <div class="pkg-icon">✨</div>
                    <div class="pkg-name">Premium Wash</div>
                    <div class="pkg-price">250K<span> /lần</span></div>
                    <div class="pkg-desc">Rửa sạch toàn diện trong và ngoài xe.</div>
                    <ul class="pkg-features">
                        <li>Exterior + Interior</li>
                        <li>Hút bụi ghế</li>
                        <li>Tích 250 điểm</li>
                    </ul>
                </div>
                <div class="pkg">
                    <div class="pkg-icon">🌟</div>
                    <div class="pkg-name">Wax Coating</div>
                    <div class="pkg-price">300K<span> /lần</span></div>
                    <div class="pkg-desc">Phủ sáp bảo vệ, tăng độ bóng cho sơn xe.</div>
                    <ul class="pkg-features">
                        <li>Wax protection</li>
                        <li>Bảo vệ lớp sơn</li>
                        <li>Tích 300 điểm</li>
                    </ul>
                </div>
            </div>
        </div>

        <!-- HOW IT WORKS -->
        <div id="how" style="max-width:1200px;margin:0 auto;padding:0 60px 80px;">
            <div class="section-label">Quy trình</div>
            <div class="section-title">Đặt lịch trong 3 bước</div>
            <div class="section-sub" style="margin-bottom:36px;">Đơn giản, nhanh chóng và hoàn toàn trực tuyến.</div>
            <div class="steps">
                <div class="step">
                    <div class="step-num">1</div>
                    <h4>Đăng nhập & chọn xe</h4>
                    <p>Đăng nhập tài khoản, thêm xe của bạn vào hệ thống chỉ trong vài giây.</p>
                </div>
                <div class="step">
                    <div class="step-num">2</div>
                    <h4>Chọn gói & đặt lịch</h4>
                    <p>Chọn gói dịch vụ phù hợp và chọn thời gian thuận tiện nhất với bạn.</p>
                </div>
                <div class="step">
                    <div class="step-num">3</div>
                    <h4>Tích điểm & nhận thưởng</h4>
                    <p>Mỗi lần rửa xe tích luỹ điểm thưởng, đổi ưu đãi hấp dẫn.</p>
                </div>
            </div>
        </div>


        <!-- SUCCESS MODAL -->
        <%
            Boolean loginSuccess = (Boolean) session.getAttribute("LOGIN_SUCCESS");
            if (loginSuccess != null && loginSuccess) {
        %>
        <div id="successModal" class="modal-overlay" style="display:flex;">
            <div class="modal-box">
                <div class="modal-icon">🎉</div>
                <h2>Đăng nhập thành công!</h2>
                <% if (isAdmin) { %>
                <p>Xin chào Admin! Chào mừng trở lại.</p>
                <% } else {%>
                <p>Xin chào <strong>
                        <%= loggedUser != null ? loggedUser.getFullname() : ""%>
                    </strong>!<br>Chào mừng bạn trở lại AutoWash.</p>
                    <% } %>
                <button onclick="document.getElementById('successModal').style.display = 'none'" class="btn btn-primary" style="font-size:14px;padding:12px 28px;">
                    Tiếp tục
                </button>
            </div>
        </div>
        <%
                session.removeAttribute("LOGIN_SUCCESS");
            }
        %>

    </body>
</html>
