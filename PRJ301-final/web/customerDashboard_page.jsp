<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="dto.Customer"%>
<%@page import="dto.Car"%>
<%@page import="dto.Services"%>
<%@page import="java.util.List"%>
<%@page import="dto.Booking"%>
<%
    Customer cus = (Customer) session.getAttribute("USER");
    List<Car> carList = (List<Car>) request.getAttribute("CAR_LIST");
    List<Services> servicesList = (List<Services>) request.getAttribute("ServicesList");
    Integer maxBookingDays = (Integer) request.getAttribute("maxDays");
    if (maxBookingDays == null) {
        maxBookingDays = dao.TierUtil.getMaxBookingDays(cus != null ? cus.getMembershipLevel() : null);
    }
    String bookingError = (String) request.getAttribute("BOOKING_ERROR");
    if (cus == null) {
        response.sendRedirect("index.jsp");
        return;
    }
/////////////////
    String[] tierNames = {"", "Member", "Silver", "Gold", "Platinum"};
    String membershipName = "Member";
    try {
        int tierNum = Integer.parseInt(cus.getMembershipLevel());
        if (tierNum >= 1 && tierNum <= 4) {
            membershipName = tierNames[tierNum];
        }
    } catch (NumberFormatException e) {
        membershipName = cus.getMembershipLevel();
    }
%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width,initial-scale=1.0">
        <title>Dashboard – AutoWash</title>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
        <style>
            :root{
                --bg:#080d14;
                --surface:#0e1520;
                --surface2:#141f2e;
                --surface3:#1a2638;
                --border:rgba(96,165,250,.12);
                --blue:#3b82f6;
                --blue-dim:rgba(59,130,246,.15);
                --cyan:#06b6d4;
                --green:#10b981;
                --yellow:#f59e0b;
                --red:#ef4444;
                --purple:#8b5cf6;
                --text:#f1f5f9;
                --muted:#64748b;
                --sidebar-w:260px;
            }
            *{
                margin:0;
                padding:0;
                box-sizing:border-box;
            }
            body{
                background:var(--bg);
                color:var(--text);
                font-family:'Inter',sans-serif;
                min-height:100vh;
                display:flex;
            }

            /* ── SIDEBAR ── */
            .sidebar{
                width:var(--sidebar-w);
                background:var(--surface);
                border-right:1px solid var(--border);
                display:flex;
                flex-direction:column;
                position:fixed;
                top:0;
                left:0;
                bottom:0;
                z-index:50;
            }
            .sidebar-logo{
                display:flex;
                align-items:center;
                gap:10px;
                padding:24px 22px;
                border-bottom:1px solid var(--border);
                text-decoration:none;
                color:var(--text);
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
                flex-shrink:0;
            }
            .logo-text{
                font-size:18px;
                font-weight:800;
                letter-spacing:-.3px;
            }
            .sidebar-nav{
                flex:1;
                padding:16px 12px;
                overflow-y:auto;
            }
            .nav-group-label{
                font-size:10px;
                font-weight:700;
                letter-spacing:1.2px;
                text-transform:uppercase;
                color:var(--muted);
                padding:10px 10px 6px;
            }
            .nav-item{
                display:flex;
                align-items:center;
                gap:11px;
                padding:10px 12px;
                border-radius:10px;
                color:var(--muted);
                text-decoration:none;
                font-size:14px;
                font-weight:500;
                transition:all .18s;
                cursor:pointer;
                border:none;
                background:none;
                width:100%;
                text-align:left;
            }
            .nav-item:hover,.nav-item.active{
                background:var(--blue-dim);
                color:var(--blue);
            }
            .nav-item .nav-icon{
                font-size:17px;
                flex-shrink:0;
            }
            .sidebar-footer{
                padding:16px 12px;
                border-top:1px solid var(--border);
            }
            .user-pill{
                display:flex;
                align-items:center;
                gap:10px;
                padding:10px 12px;
                border-radius:10px;
                background:var(--surface2);
                margin-bottom:8px;
            }
            .avatar{
                width:36px;
                height:36px;
                border-radius:50%;
                background:linear-gradient(135deg,var(--blue),var(--purple));
                display:flex;
                align-items:center;
                justify-content:center;
                font-weight:700;
                font-size:14px;
                flex-shrink:0;
            }
            .user-info .name{
                font-size:13px;
                font-weight:600;
                white-space:nowrap;
                overflow:hidden;
                text-overflow:ellipsis;
                max-width:160px;
            }
            .user-info .email{
                font-size:11px;
                color:var(--muted);
                white-space:nowrap;
                overflow:hidden;
                text-overflow:ellipsis;
                max-width:160px;
            }

            /* ── MAIN ── */
            .main{
                margin-left:var(--sidebar-w);
                flex:1;
                padding:32px;
                max-width:calc(100% - var(--sidebar-w));
            }
            .topbar{
                display:flex;
                align-items:center;
                justify-content:space-between;
                margin-bottom:28px;
            }
            .page-title{
                font-size:24px;
                font-weight:800;
                letter-spacing:-.5px;
            }
            .page-title span{
                color:var(--blue);
            }

            /* ── TABS ── */
            .tab-bar{
                display:flex;
                gap:4px;
                background:var(--surface);
                border:1px solid var(--border);
                border-radius:12px;
                padding:4px;
                margin-bottom:28px;
                width:fit-content;
            }
            .tab{
                padding:8px 18px;
                border-radius:9px;
                font-size:13px;
                font-weight:600;
                cursor:pointer;
                border:none;
                background:none;
                color:var(--muted);
                transition:all .18s;
            }
            .tab.active{
                background:var(--blue);
                color:#fff;
            }
            .tab:hover:not(.active){
                color:var(--text);
            }
            .tab-panel{
                display:none;
            }
            .tab-panel.active{
                display:block;
            }

            /* ── STAT CARDS ── */
            .stat-row{
                display:grid;
                grid-template-columns:repeat(auto-fit,minmax(180px,1fr));
                gap:16px;
                margin-bottom:28px;
            }
            .stat-card{
                background:var(--surface);
                border:1px solid var(--border);
                border-radius:14px;
                padding:20px;
                display:flex;
                flex-direction:column;
                gap:6px;
            }
            .stat-card-label{
                font-size:11px;
                font-weight:700;
                text-transform:uppercase;
                letter-spacing:.8px;
                color:var(--muted);
            }
            .stat-card-val{
                font-size:26px;
                font-weight:800;
                letter-spacing:-1px;
            }
            .stat-card-sub{
                font-size:12px;
                color:var(--muted);
            }
            .val-blue{
                color:var(--blue);
            }
            .val-green{
                color:var(--green);
            }
            .val-yellow{
                color:var(--yellow);
            }
            .val-purple{
                color:var(--purple);
            }

            /* ── PROFILE CARD ── */
            .profile-grid{
                display:grid;
                grid-template-columns:1fr 1fr;
                gap:14px;
            }
            .info-row{
                background:var(--surface);
                border:1px solid var(--border);
                border-radius:12px;
                padding:18px;
            }
            .info-row label{
                font-size:11px;
                font-weight:700;
                text-transform:uppercase;
                letter-spacing:.8px;
                color:var(--muted);
                display:block;
                margin-bottom:5px;
            }
            .info-row p{
                font-size:15px;
                font-weight:500;
            }
            .badge-member{
                display:inline-block;
                padding:4px 12px;
                border-radius:100px;
                font-size:12px;
                font-weight:700;
                background:linear-gradient(135deg,var(--blue),var(--cyan));
                color:#fff;
            }
            .badge-points{
                display:inline-flex;
                align-items:center;
                gap:6px;
                padding:4px 14px;
                border-radius:100px;
                background:rgba(16,185,129,.15);
                border:1px solid rgba(16,185,129,.3);
                color:var(--green);
                font-size:13px;
                font-weight:700;
            }

            /* ── SECTION HEADER ── */
            .section-hd{
                display:flex;
                align-items:center;
                justify-content:space-between;
                margin-bottom:16px;
            }
            .section-hd h3{
                font-size:16px;
                font-weight:700;
            }
            .btn-sm{
                display:inline-flex;
                align-items:center;
                gap:6px;
                padding:8px 16px;
                border-radius:8px;
                font-size:13px;
                font-weight:600;
                text-decoration:none;
                border:none;
                cursor:pointer;
                transition:all .18s;
            }
            .btn-primary{
                background:var(--blue);
                color:#fff;
            }
            .btn-primary:hover{
                background:#2563eb;
            }
            .btn-danger{
                background:rgba(239,68,68,.12);
                color:var(--red);
                border:1px solid rgba(239,68,68,.25);
            }
            .btn-danger:hover{
                background:rgba(239,68,68,.22);
            }
            .btn-edit{
                background:var(--surface3);
                color:var(--text);
                border:1px solid var(--border);
            }
            .btn-edit:hover{
                border-color:var(--blue);
                color:var(--blue);
            }
            .btn-ghost{
                background:none;
                border:1px solid var(--border);
                color:var(--muted);
            }
            .btn-ghost:hover{
                color:var(--text);
                border-color:var(--muted);
            }

            /* ── TABLE ── */
            .table-wrap{
                background:var(--surface);
                border:1px solid var(--border);
                border-radius:14px;
                overflow:hidden;
            }
            table{
                width:100%;
                border-collapse:collapse;
            }
            thead tr{
                background:var(--surface2);
            }
            th{
                padding:12px 16px;
                text-align:left;
                font-size:11px;
                font-weight:700;
                letter-spacing:.8px;
                text-transform:uppercase;
                color:var(--muted);
            }
            td{
                padding:13px 16px;
                font-size:14px;
                border-top:1px solid var(--border);
            }
            tr:hover td{
                background:var(--surface2);
            }
            .empty-row td{
                text-align:center;
                padding:40px;
                color:var(--muted);
                font-size:14px;
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
            .modal-overlay.open{
                display:flex;
            }
            .modal-box{
                background:var(--surface);
                border:1px solid var(--border);
                border-radius:20px;
                padding:36px 32px;
                width:460px;
                max-width:calc(100vw - 32px);
                max-height:90vh;
                overflow-y:auto;
            }
            .modal-box h2{
                font-size:18px;
                font-weight:700;
                margin-bottom:20px;
            }
            .form-group{
                margin-bottom:16px;
            }
            .form-group label{
                display:block;
                font-size:12px;
                font-weight:600;
                text-transform:uppercase;
                letter-spacing:.7px;
                color:var(--muted);
                margin-bottom:6px;
            }
            .form-group input,
            .form-group select{
                width:100%;
                background:var(--surface2);
                border:1px solid var(--border);
                border-radius:8px;
                padding:10px 14px;
                color:var(--text);
                font-size:14px;
                font-family:inherit;
                transition:border-color .18s;
            }
            .form-group input:focus,
            .form-group select:focus{
                outline:none;
                border-color:var(--blue);
            }
            .form-group select option{
                background:var(--surface2);
            }
            .modal-actions{
                display:flex;
                gap:10px;
                justify-content:flex-end;
                margin-top:24px;
            }

            /* ── BOOKING PACKAGES ── */
            .pkg-grid{
                display:grid;
                grid-template-columns:repeat(2,1fr);
                gap:12px;
                margin-bottom:20px;
            }
            .pkg-card{
                border:2px solid var(--border);
                border-radius:12px;
                padding:16px;
                cursor:pointer;
                transition:all .18s;
            }
            .pkg-card:hover{
                border-color:var(--blue);
            }
            .pkg-card.selected{
                border-color:var(--blue);
                background:var(--blue-dim);
            }
            .pkg-card input[type=radio]{
                display:none;
            }
            .pkg-card-name{
                font-size:13px;
                font-weight:700;
                margin-bottom:4px;
            }
            .pkg-card-price{
                font-size:20px;
                font-weight:800;
                color:var(--blue);
            }
            .pkg-card-desc{
                font-size:11px;
                color:var(--muted);
                margin-top:4px;
            }

            /* ── TIME SLOTS ── */
            .time-slot{
                border:2px solid var(--border);
                border-radius:10px;
                padding:10px 4px;
                text-align:center;
                font-size:13px;
                font-weight:600;
                cursor:pointer;
                transition:all .15s;
                background:var(--surface2);
                color:var(--text);
            }
            .time-slot:hover:not(.disabled){
                border-color:var(--blue);
            }
            .time-slot.selected{
                border-color:var(--blue);
                background:var(--blue-dim);
                color:var(--blue);
            }
            .time-slot.disabled{
                opacity:.35;
                cursor:not-allowed;
                text-decoration:line-through;
            }

            /* ── BOOKING TABLE STATUS ── */
            .status-badge{
                display:inline-block;
                padding:3px 10px;
                border-radius:100px;
                font-size:11px;
                font-weight:700;
            }
            .status-pending{
                background:rgba(245,158,11,.12);
                color:var(--yellow);
                border:1px solid rgba(245,158,11,.25);
            }
            .status-done{
                background:rgba(16,185,129,.12);
                color:var(--green);
                border:1px solid rgba(16,185,129,.25);
            }

            .status-paid{
                background:rgba(59,130,246,.12);
                color:var(--blue);
                border:1px solid rgba(59,130,246,.25);
            }

            .status-cancelled{
                background:rgba(239,68,68,.12);
                color:var(--red);
                border:1px solid rgba(239,68,68,.25);
            }

            /* ── CONFIRM MODAL ── */
            .confirm-icon{
                font-size:44px;
                text-align:center;
                margin-bottom:12px;
            }
            .confirm-text{
                text-align:center;
                color:var(--muted);
                font-size:14px;
                margin-bottom:24px;
                line-height:1.6;
            }

            @media(max-width:900px){
                .sidebar{
                    display:none;
                }
                .main{
                    margin-left:0;
                    max-width:100%;
                }
                .profile-grid{
                    grid-template-columns:1fr;
                }
                .pkg-grid{
                    grid-template-columns:1fr;
                }
            }
        </style>
    </head>
    <body>

        <!-- SIDEBAR -->
        <aside class="sidebar">
            <a href="MainController?action=home" class="sidebar-logo">
                <div class="logo-icon">🚗</div>
                <span class="logo-text">AutoWash</span>
            </a>
            <nav class="sidebar-nav">
                <div class="nav-group-label">Menu</div>
                <button class="nav-item active" onclick="switchTab('profile')">
                    <span class="nav-icon">👤</span> Hồ sơ
                </button>
                <button class="nav-item" onclick="switchTab('cars')">
                    <span class="nav-icon">🚘</span> Quản lý xe
                </button>
                <button class="nav-item" onclick="switchTab('booking')">
                    <span class="nav-icon">📅</span> Đặt lịch rửa xe
                </button>
                <button class="nav-item" onclick="switchTab('history')">
                    <span class="nav-icon">📋</span> Lịch sử đặt lịch
                </button>
                <a href="PaymentService" class="nav-item">
                    <span class="nav-icon">💳</span> Thanh toán
                </a>
            </nav>
            <div class="sidebar-footer">
                <div class="user-pill">
                    <div class="avatar"><%= cus.getFullname().substring(0, 1).toUpperCase()%></div>
                    <div class="user-info">
                        <div class="name"><%= cus.getFullname()%></div>
                        <div class="email"><%= cus.getEmail()%></div>
                    </div>
                </div>
                <button class="nav-item" onclick="document.getElementById('logoutModal').classList.add('open')" style="color:var(--red);">
                    <span class="nav-icon">🚪</span> Đăng xuất
                </button>
            </div>
        </aside>

        <!-- MAIN -->
        <div class="main">

            <!-- TOPBAR -->
            <div class="topbar">
                <div>
                    <div class="page-title">Xin chào, <span><%= cus.getFullname()%></span> 👋</div>
                </div>
                <div style="display:flex;gap:8px;">
                    <div class="badge-points">⭐ <%= cus.getPoints()%> điểm</div>
                    <div class="badge-member"><%= membershipName%></div>
                </div>
            </div>

            <!-- STAT ROW -->
            <div class="stat-row">
                <div class="stat-card">
                    <div class="stat-card-label">Số xe đã đăng ký</div>
                    <div class="stat-card-val val-blue"><%= (carList != null ? carList.size() : 0)%></div>
                    <div class="stat-card-sub">Xe trong tài khoản</div>
                </div>
                <div class="stat-card">
                    <div class="stat-card-label">Điểm khả dụng</div>
                    <div class="stat-card-val val-green"><%= cus.getPoints()%></div>
                    <div class="stat-card-sub">Dùng để đổi rửa xe free</div>
                </div>
                <div class="stat-card">
                    <div class="stat-card-label">Tổng điểm tích lũy</div>
                    <div class="stat-card-val val-purple"><%= cus.getTotalPoints()%></div>
                    <div class="stat-card-sub">Dùng để xét hạng thành viên</div>
                </div>
                <div class="stat-card">
                    <div class="stat-card-label">Hạng thành viên</div>
                    <div class="stat-card-val val-yellow" style="font-size:16px;padding-top:4px;"><%= membershipName%></div>
                    <div class="stat-card-sub">Membership</div>
                </div>
            </div>

            <!-- TABS -->
            <div class="tab-bar">
                <button class="tab active" id="tab-profile" onclick="switchTab('profile')">👤 Hồ sơ</button>
                <button class="tab" id="tab-cars" onclick="switchTab('cars')">🚘 Xe của tôi</button>
                <button class="tab" id="tab-booking" onclick="switchTab('booking')">📅 Đặt lịch</button>
                <button class="tab" id="tab-history" onclick="switchTab('history')">📋 Lịch sử</button>
            </div>

            <!-- PANEL: PROFILE -->
            <div id="panel-profile" class="tab-panel active">
                <div class="profile-grid">
                    <div class="info-row"><label>Họ tên</label><p><%= cus.getFullname()%></p></div>
                    <div class="info-row"><label>Email</label><p><%= cus.getEmail()%></p></div>
                    <div class="info-row"><label>Số điện thoại</label><p><%= cus.getPhone()%></p></div>
                    <div class="info-row"><label>Ngày sinh</label><p><%= cus.getDateOfBirth()%></p></div>
                    <div class="info-row"><label>Giới tính</label><p><%= cus.getGender()%></p></div>
                    <div class="info-row"><label>Hạng thành viên</label><p><span class="badge-member"><%= membershipName%></span></p></div>
                    <div class="info-row">
                        <label>Điểm khả dụng</label>
                        <p>
                            <span class="badge-points">
                                ⭐ <%= cus.getPoints()%> Points
                            </span>
                        </p>
                    </div>

                    <div class="info-row">
                        <label>Tổng điểm tích lũy</label>
                        <p>
                            <span class="badge-points"
                                  style="
                                  background: rgba(139,92,246,.15);
                                  border-color: rgba(139,92,246,.35);
                                  color: var(--purple);
                                  ">
                                🏆 <%= cus.getTotalPoints()%> Points
                            </span>
                        </p>
                    </div>                

                </div>
            </div>

            <!-- PANEL: CARS -->
            <div id="panel-cars" class="tab-panel">
                <div class="section-hd">
                    <h3>Danh sách xe của bạn</h3>
                    <button class="btn-sm btn-primary" onclick="openModal('addCarModal')">＋ Thêm xe</button>
                </div>
                <% String carError = (String) request.getAttribute("ERROR");
                    if (carError != null) {%>
                <div style="background:rgba(239,68,68,.12);color:#fca5a5;border:1px solid rgba(239,68,68,.35);border-radius:10px;padding:10px 14px;margin-bottom:12px;">
                    ⚠ <%= carError%>
                </div>
                <% } %>
                <div class="profile-grid">
                    <%
                        if (carList != null && !carList.isEmpty()) {
                            for (Car car : carList) {
                    %>
                    <div class="info-row" style="grid-column:1/-1;">
                        <div style="display:flex;justify-content:space-between;align-items:center;flex-wrap:wrap;gap:10px;">
                            <div>
                                <label>Biển số</label>
                                <p><strong><%= car.getLicensePlate() != null ? car.getLicensePlate() : ""%></strong></p>
                            </div>
                            <div>
                                <label>Hãng</label>
                                <p><%= car.getBrand() != null ? car.getBrand() : ""%></p>
                            </div>
                            <div>
                                <label>Model</label>
                                <p><%= car.getModel() != null ? car.getModel() : ""%></p>
                            </div>
                            <div>
                                <label>Màu</label>
                                <p><%= car.getColor() != null ? car.getColor() : ""%></p>
                            </div>
                            <div>
                                <label>Loại</label>
                                <p><%= car.getType() != null ? car.getType() : ""%></p>
                            </div>
                            <div style="display:flex;gap:8px;">
                                <a href="<%= request.getContextPath()%>/EditCar?id=<%= car.getId()%>" class="btn-sm btn-edit">✏️ Sửa</a>                                
                                <button class="btn-sm btn-danger" onclick="confirmDelete('<%= car.getLicensePlate()%>', '<%= car.getId()%>')">🗑 Xóa</button>
                            </div>
                        </div>
                    </div>
                    <%
                        }
                    } else {
                    %>
                    <div class="info-row" style="grid-column:1/-1;text-align:center;color:var(--muted);">
                        🚗 Bạn chưa đăng ký xe nào. Thêm xe để bắt đầu!
                    </div>
                    <% } %>
                </div>
            </div>

            <!-- PANEL: BOOKING -->
            <div id="panel-booking" class="tab-panel">
                <div class="section-hd">
                    <h3>Đặt lịch rửa xe</h3>
                </div>
                <% if (bookingError != null) {%>
                <div style="margin-bottom:16px;padding:14px;background:rgba(239,68,68,.12);border:1px solid rgba(239,68,68,.35);border-radius:10px;color:#fca5a5;font-size:13px;">
                    ⚠️ <%= bookingError%>
                </div>
                <% }%>
                <div class="profile-grid">
                    <form id="bookingForm" action="BookingService" method="POST" style="display:contents;">
                        <input type="hidden" name="serviceId" id="bookingServiceId"/>
                        <input type="hidden" name="bookingDate" id="bookingDateTime"/>

                        <!-- Chọn gói -->
                        <div class="info-row" style="grid-column:1/-1;">
                            <label>Chọn gói dịch vụ</label>
                            <div class="pkg-grid" style="margin-top:10px;">
                                <%
                                    if (servicesList != null) {
                                        for (Services svc : servicesList) {
                                            if (!svc.isStatus())
                                                continue;
                                %>
                                <label class="pkg-card" onclick="selectPkg(this, '<%= svc.getServiceId()%>', '<%= svc.getPrice()%>')">
                                    <input type="radio" name="servicePackageRadio"/>
                                    <div class="pkg-card-name">💧 <%= svc.getServiceName()%></div>
                                    <div class="pkg-card-price"><%= String.format("%,.0f", svc.getPrice())%>đ</div>
                                    <div class="pkg-card-desc"><%= svc.getDescription() != null ? svc.getDescription() : ""%></div>
                                </label>
                                <%  }
                                } else { %>
                                <div style="color:var(--muted);font-size:13px;">Hiện chưa có gói dịch vụ nào khả dụng.</div>
                                <% } %>
                            </div>
                        </div>

                        <!-- Chọn xe -->
                        <div class="info-row">
                            <label>Chọn xe</label>
                            <select name="carId" required style="margin-top:8px;width:100%;background:var(--bg);border:1px solid var(--border);color:var(--text);border-radius:8px;padding:10px 12px;font-size:14px;">
                                <option value="">-- Chọn xe --</option>
                                <% if (carList != null) {
                                        for (Car c : carList) {%>
                                <option value="<%= c.getId()%>"><%= c.getLicensePlate()%> – <%= c.getBrand()%> <%= c.getModel()%></option>
                                <% }
                                    }%>
                            </select>
                        </div>

                        <!-- Ngày đặt -->
                        <div class="info-row">
                            <label>Ngày đặt (tối đa <%= maxBookingDays%> ngày)</label>
                            <input type="date" name="bookingDateInput" id="bookingDateInput" required
                                   style="margin-top:8px;width:100%;background:var(--bg);border:1px solid var(--border);color:var(--text);border-radius:8px;padding:10px 12px;font-size:14px;box-sizing:border-box;"/>
                        </div>

                        <!-- Khung giờ -->
                        <div class="info-row" id="timeSlotSection" style="grid-column:1/-1;display:none;">
                            <label>Chọn khung giờ</label>
                            <div id="timeSlotGrid" style="display:grid;grid-template-columns:repeat(6,1fr);gap:8px;margin-top:10px;"></div>
                            <div id="timeSlotHint" style="margin-top:8px;font-size:12px;color:var(--muted);"></div>
                        </div>

                        <!-- Ghi chú -->
                        <div class="info-row" style="grid-column:1/-1;">
                            <label>Ghi chú (tùy chọn)</label>
                            <input type="text" name="note" placeholder="Ví dụ: xe bị bám nhựa đường..."
                                   style="margin-top:8px;width:100%;background:var(--bg);border:1px solid var(--border);color:var(--text);border-radius:8px;padding:10px 12px;font-size:14px;box-sizing:border-box;"/>
                        </div>

                        <!-- Tổng tiền + Submit -->
                        <div class="info-row" style="grid-column:1/-1;">
                            <div style="display:flex;justify-content:space-between;align-items:center;flex-wrap:wrap;gap:12px;">
                                <p style="font-size:13px;color:var(--muted);">
                                    💡 Tổng tiền: <strong id="selectedPrice" style="color:var(--blue);">Chưa chọn gói</strong>
                                    &nbsp;|&nbsp; Giờ đã chọn: <strong id="selectedTimeLabel" style="color:var(--blue);">Chưa chọn giờ</strong>
                                </p>
                                <button type="submit" class="btn-sm btn-primary" style="padding:12px 28px;font-size:14px;">
                                    📅 Xác nhận đặt lịch
                                </button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>

            <!-- PANEL: HISTORY -->
            <div id="panel-history" class="tab-panel">                
                <div class="section-hd">
                    <h3>Lịch sử đặt lịch</h3>
                </div>
                <%
                    java.util.List<dto.Booking> myBookings = (java.util.List<dto.Booking>) request.getAttribute("BOOKING_LIST");
                    if (myBookings != null && !myBookings.isEmpty()) {
                %>
                <div class="table-wrap">
                    <table>
                        <thead>
                            <tr>
                                <th>Xe</th>
                                <th>Dịch vụ</th>
                                <th>Ngày đặt</th>
                                <th>Tổng tiền</th>
                                <th>Trạng thái</th>
                                <th>Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (dto.Booking b : myBookings) { %>
                            <%
                                dao.CarDAO bCarDAO = new dao.CarDAO();
                                dto.Car bCar = bCarDAO.getCarById(b.getCarId());
                                dao.ServicesDAO bSvcDAO = new dao.ServicesDAO();
                                dto.Services bSvc = bSvcDAO.getServicesById(b.getServiceId());
                            %>
                            <tr>
                                <td>
                                    <strong><%= bCar != null ? bCar.getLicensePlate() : "N/A"%></strong><br>
                                    <span style="font-size:12px;color:var(--muted);"><%= bCar != null ? bCar.getBrand() + " " + bCar.getModel() : ""%></span>
                                </td>
                                <td><%= bSvc != null ? bSvc.getServiceName() : "N/A"%></td>
                                <td><%= b.getBookingDate()%></td>
                                <td><%= String.format("%,.0f", b.getTotalAmount())%>đ</td>
                                <td>
                                    <span class="status-badge
                                          <%= "PENDING".equals(b.getBookingStatus()) ? "status-pending"
                                                  : "DONE".equals(b.getBookingStatus()) ? "status-done"
                                                  : "PAID".equals(b.getBookingStatus()) ? "status-paid"
                                                  : "status-cancelled"%>">                                        

                                        <%= b.getBookingStatus()%>
                                    </span>
                                </td>
                                <td>
                                    <% if ("PENDING".equals(b.getBookingStatus())) {%>
                                    <form action="MainController" method="POST" onsubmit="return confirm('Bạn có chắc muốn hủy lịch này không?')">
                                        <input type="hidden" name="action" value="cancelBooking"/>
                                        <input type="hidden" name="bookingId" value="<%= b.getBookingId()%>"/>
                                        <button type="submit" class="btn-sm btn-danger">✕ Hủy</button>
                                    </form>
                                    <% } %>
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
                <% } else { %>
                <div class="profile-grid">
                    <div class="info-row" style="grid-column:1/-1;text-align:center;color:var(--muted);">
                        📋 Chưa có lịch sử đặt lịch nào.
                    </div>
                </div>
                <% }%>
            </div>

            <!-- MODAL: THÊM XE -->
            <div id="addCarModal" class="modal-overlay">
                <div class="modal-box">
                    <h2>🚗 Thêm xe mới</h2>
                    <form action="MainController" method="POST">
                        <input type="hidden" name="action" value="addCar"/>
                        <div class="form-group">
                            <label>Biển số xe</label>
                            <input type="text" name="licensePlate" placeholder="VD: 51A-123.45" required/>
                        </div>
                        <div style="display:grid;grid-template-columns:1fr 1fr;gap:12px;">
                            <div class="form-group">
                                <label>Hãng xe</label>
                                <input type="text" name="brand" placeholder="Toyota, Honda..." required/>
                            </div>
                            <div class="form-group">
                                <label>Model</label>
                                <input type="text" name="model" placeholder="Vios, City..." required/>
                            </div>
                        </div>
                        <div style="display:grid;grid-template-columns:1fr 1fr;gap:12px;">
                            <div class="form-group">
                                <label>Màu xe</label>
                                <input type="text" name="color" placeholder="Trắng, Đen..." required/>
                            </div>
                            <div class="form-group">
                                <label>Loại xe</label>
                                <select name="type" required>
                                    <option value="">-- Chọn loại --</option>
                                    <option value="Sedan">Sedan</option>
                                    <option value="SUV">SUV</option>
                                    <option value="Hatchback">Hatchback</option>
                                    <option value="Pickup">Pickup</option>
                                    <option value="Van">Van</option>
                                    <option value="Coupe">Coupe</option>
                                    <option value="Khác">Khác</option>
                                </select>
                            </div>
                        </div>
                        <div class="modal-actions">
                            <button type="button" class="btn-sm btn-ghost" onclick="closeModal('addCarModal')">Hủy</button>
                            <button type="submit" class="btn-sm btn-primary">＋ Thêm xe</button>
                        </div>
                    </form>
                </div>
            </div>


            <!-- MODAL: XÓA XE -->
            <div id="deleteCarModal" class="modal-overlay">
                <div class="modal-box" style="text-align:center;">
                    <div class="confirm-icon">🗑️</div>
                    <h2>Xóa xe này?</h2>
                    <div class="confirm-text">Bạn sắp xóa xe <strong id="deletePlate"></strong>.<br>Hành động này không thể hoàn tác.</div>
                    <div class="modal-actions" style="justify-content:center;">
                        <button class="btn-sm btn-ghost" onclick="closeModal('deleteCarModal')">Hủy</button>
                        <a id="deleteCarLink" href="#" class="btn-sm btn-danger">Xóa xe</a>
                    </div>
                </div>
            </div>

            <!-- MODAL: LOGOUT -->
            <div id="logoutModal" class="modal-overlay">
                <div class="modal-box" style="text-align:center;">
                    <div class="confirm-icon">👋</div>
                    <h2>Đăng xuất?</h2>
                    <div class="confirm-text">Bạn có chắc muốn đăng xuất khỏi tài khoản không?</div>
                    <div class="modal-actions" style="justify-content:center;">
                        <button class="btn-sm btn-ghost" onclick="closeModal('logoutModal')">Ở lại</button>
                        <a href="MainController?action=logout" class="btn-sm btn-danger">Đăng xuất</a>
                    </div>
                </div>
            </div>

            <script>
                // Tab switching
                function switchTab(name) {
                    document.querySelectorAll('.tab-panel').forEach(p => p.classList.remove('active'));
                    document.querySelectorAll('.tab').forEach(t => t.classList.remove('active'));
                    document.querySelectorAll('.nav-item').forEach(n => n.classList.remove('active'));
                    document.getElementById('panel-' + name).classList.add('active');
                    document.getElementById('tab-' + name).classList.add('active');
                }

                // Modal helpers
                function openModal(id) {
                    document.getElementById(id).classList.add('open');
                }
                function closeModal(id) {
                    document.getElementById(id).classList.remove('open');
                }
                document.querySelectorAll('.modal-overlay').forEach(m => {
                    m.addEventListener('click', function (e) {
                        if (e.target === m)
                            m.classList.remove('open');
                    });
                });

                // Delete car confirm
                function confirmDelete(plate, carId) {
                    document.getElementById('deletePlate').textContent = plate;
                    document.getElementById('deleteCarLink').href = 'MainController?action=removeCar&carId=' + carId;
                    openModal('deleteCarModal');
                }
                // Edit car: điền sẵn dữ liệu hiện tại vào modal sửa xe
                function openEditCar(carId, brand, model, color, type) {
                    window.location.href = '<%= request.getContextPath()%>/EditCar?id=' + carId;
                }

                // Package selection
                function selectPkg(el, serviceId, price) {
                    document.querySelectorAll('.pkg-card').forEach(c => c.classList.remove('selected'));
                    el.classList.add('selected');
                    document.getElementById('bookingServiceId').value = serviceId;
                    const fmt = Number(price).toLocaleString('vi-VN') + 'đ';
                    document.getElementById('selectedPrice').textContent = fmt;
                }

                // Set min/max date for booking theo số ngày tối đa của hạng thành viên
                const maxBookingDaysJs = <%= maxBookingDays%>;
                const dateInput = document.getElementById('bookingDateInput');
                if (dateInput) {
                    const now = new Date();
                    const toISODate = (d) => d.toISOString().split('T')[0];
                    dateInput.setAttribute('min', toISODate(now));
                    const maxDate = new Date(now);
                    maxDate.setDate(maxDate.getDate() + maxBookingDaysJs);
                    dateInput.setAttribute('max', toISODate(maxDate));
                }

                // ── KHUNG GIỜ ──
                // Toàn tiệm chỉ phục vụ 1 xe/giờ -> hiển thị 24 nút giờ (0h-23h),
                // disable những giờ đã có người đặt trong ngày được chọn.
                let selectedHour = null;

                function buildTimeSlotGrid(bookedHours) {
                    const grid = document.getElementById('timeSlotGrid');
                    grid.innerHTML = '';
                    const now = new Date();
                    const selectedDateStr = dateInput.value;
                    const isToday = selectedDateStr === now.toISOString().split('T')[0];
                    const currentHour = now.getHours();

                    for (let h = 0; h < 24; h++) {
                        const slot = document.createElement('div');
                        slot.className = 'time-slot';
                        slot.textContent = String(h).padStart(2, '0') + ':00';

                        const isBooked = bookedHours.includes(h);
                        const isPast = isToday && h <= currentHour;

                        if (isBooked || isPast) {
                            slot.classList.add('disabled');
                        } else {
                            slot.onclick = function () {
                                document.querySelectorAll('.time-slot').forEach(s => s.classList.remove('selected'));
                                slot.classList.add('selected');
                                selectedHour = h;
                                document.getElementById('selectedTimeLabel').textContent = slot.textContent;
                            };
                        }
                        grid.appendChild(slot);
                    }
                }

                function loadBookedHoursForDate() {
                    const dateVal = dateInput.value;
                    const section = document.getElementById('timeSlotSection');
                    const hint = document.getElementById('timeSlotHint');

                    if (!dateVal) {
                        section.style.display = 'none';
                        return;
                    }

                    selectedHour = null;
                    document.getElementById('selectedTimeLabel').textContent = 'Chưa chọn giờ';
                    section.style.display = 'block';
                    hint.textContent = 'Đang tải khung giờ trống...';

                    fetch('GetBookedHours?date=' + encodeURIComponent(dateVal))
                            .then(res => res.json())
                            .then(data => {
                                const bookedHours = data.bookedHours || [];
                                buildTimeSlotGrid(bookedHours);
                                hint.textContent = '⏱️ Mỗi lượt rửa xe chiếm 1 khung giờ. Khung giờ đã gạch ngang nghĩa là đã có khách đặt.';
                            })
                            .catch(() => {
                                buildTimeSlotGrid([]);
                            });
                }

                if (dateInput) {
                    dateInput.addEventListener('change', loadBookedHoursForDate);
                    if (dateInput.value) {
                        loadBookedHoursForDate();
                    }
                }

                // Gộp ngày + giờ thành định dạng LocalDateTime (yyyy-MM-ddTHH:00) trước khi submit
                const bookingForm = document.getElementById('bookingForm');
                if (bookingForm) {
                    bookingForm.addEventListener('submit', function (e) {
                        const dateVal = document.getElementById('bookingDateInput').value;
                        const serviceIdVal = document.getElementById('bookingServiceId').value;

                        if (!serviceIdVal) {
                            e.preventDefault();
                            alert('Vui lòng chọn gói dịch vụ.');
                            return;
                        }
                        if (!dateVal) {
                            e.preventDefault();
                            alert('Vui lòng chọn ngày đặt lịch.');
                            return;
                        }
                        if (selectedHour === null) {
                            e.preventDefault();
                            alert('Vui lòng chọn khung giờ.');
                            return;
                        }
                        const hourStr = String(selectedHour).padStart(2, '0');
                        document.getElementById('bookingDateTime').value = dateVal + 'T' + hourStr + ':00';
                    });
                }

                <% if (request.getAttribute("ERROR") != null) { %>
                // Có lỗi khi thêm xe -> mở lại tab "Xe của tôi" và modal "Thêm xe"
                switchTab('cars');
                openModal('addCarModal');
                <% }%>

                <% if (bookingError != null) { %>
                // Có lỗi khi đặt lịch -> mở lại tab "Đặt lịch"
                switchTab('booking');
                <% }%>
            </script>
    </body>
</html>
