<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="dto.Customer"%>
<%@page import="dto.Booking"%>
<%@page import="dto.Car"%>
<%@page import="dto.Services"%>
<%@page import="dao.CarDAO"%>
<%@page import="dao.ServicesDAO"%>
<%@page import="java.util.List"%>
<%
    CarDAO carDAO_pp = new CarDAO();
    ServicesDAO servicesDAO_pp = new ServicesDAO();
%>
<%
    Customer cus = (Customer) session.getAttribute("USER");
    List<Booking> bookingList = (List<Booking>) request.getAttribute("bookingList");
    Integer points = (Integer) request.getAttribute("points");
    if (cus == null) {
        response.sendRedirect("index.jsp");
        return;
    }
    if (points == null) {
        points = cus.getPoints();
    }

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

    // Points to VND rate: 1 point = 1,000 VND (adjust as needed)
    final int POINTS_TO_VND = 1000;
    // Min points required for redeem (from backend: 300)
    final int MIN_POINTS = 300;
%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width,initial-scale=1.0">
        <title>Thanh Toán – AutoWash</title>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
        <style>
            :root {
                --bg: #080d14;
                --surface: #0e1520;
                --surface2: #141f2e;
                --surface3: #1a2638;
                --border: rgba(96,165,250,.12);
                --blue: #3b82f6;
                --blue-dim: rgba(59,130,246,.15);
                --cyan: #06b6d4;
                --green: #10b981;
                --yellow: #f59e0b;
                --red: #ef4444;
                --purple: #8b5cf6;
                --text: #f1f5f9;
                --muted: #64748b;
                --sidebar-w: 260px;
            }
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }
            body {
                background: var(--bg);
                color: var(--text);
                font-family: 'Inter', sans-serif;
                min-height: 100vh;
                display: flex;
            }

            /* ── SIDEBAR ── */
            .sidebar {
                width: var(--sidebar-w);
                background: var(--surface);
                border-right: 1px solid var(--border);
                display: flex;
                flex-direction: column;
                position: fixed;
                top: 0;
                left: 0;
                bottom: 0;
                z-index: 50;
            }
            .sidebar-logo {
                display: flex;
                align-items: center;
                gap: 10px;
                padding: 24px 22px;
                border-bottom: 1px solid var(--border);
                text-decoration: none;
                color: var(--text);
            }
            .logo-icon {
                width: 34px;
                height: 34px;
                background: linear-gradient(135deg, var(--blue), var(--cyan));
                border-radius: 8px;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 18px;
                flex-shrink: 0;
            }
            .logo-text {
                font-size: 18px;
                font-weight: 800;
                letter-spacing: -.3px;
            }
            .sidebar-nav {
                flex: 1;
                padding: 16px 12px;
                overflow-y: auto;
            }
            .nav-group-label {
                font-size: 10px;
                font-weight: 700;
                letter-spacing: 1.2px;
                text-transform: uppercase;
                color: var(--muted);
                padding: 10px 10px 6px;
            }
            .nav-item {
                display: flex;
                align-items: center;
                gap: 12px;
                width: 100%;
                padding: 10px 12px;
                border-radius: 8px;
                border: none;
                background: none;
                color: var(--muted);
                font-size: 14px;
                font-weight: 500;
                text-decoration: none;
                cursor: pointer;
                transition: all .2s;
                text-align: left;
            }
            .nav-item:hover, .nav-item.active {
                background: var(--blue-dim);
                color: var(--blue);
            }
            .nav-icon {
                font-size: 16px;
                width: 20px;
                text-align: center;
                flex-shrink: 0;
            }
            .sidebar-footer {
                padding: 16px 12px;
                border-top: 1px solid var(--border);
            }
            .user-card {
                display: flex;
                align-items: center;
                gap: 10px;
                padding: 10px 12px;
                border-radius: 8px;
                background: var(--surface2);
            }
            .avatar {
                width: 34px;
                height: 34px;
                background: linear-gradient(135deg, var(--purple), var(--blue));
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 14px;
                font-weight: 700;
                flex-shrink: 0;
            }
            .user-name {
                font-size: 13px;
                font-weight: 600;
            }
            .user-tier {
                font-size: 11px;
                color: var(--yellow);
                font-weight: 500;
            }

            /* ── MAIN ── */
            .main {
                margin-left: var(--sidebar-w);
                flex: 1;
                padding: 32px;
                max-width: calc(100% - var(--sidebar-w));
            }
            .page-header {
                margin-bottom: 28px;
            }
            .page-header h1 {
                font-size: 24px;
                font-weight: 800;
            }
            .page-header p {
                color: var(--muted);
                font-size: 14px;
                margin-top: 4px;
            }

            /* ── POINTS BANNER ── */
            .points-banner {
                display: flex;
                align-items: center;
                gap: 16px;
                background: linear-gradient(135deg, rgba(139,92,246,.15), rgba(59,130,246,.1));
                border: 1px solid rgba(139,92,246,.3);
                border-radius: 12px;
                padding: 18px 22px;
                margin-bottom: 24px;
            }
            .points-icon {
                font-size: 28px;
            }
            .points-info {
                flex: 1;
            }
            .points-label {
                font-size: 12px;
                color: var(--muted);
                font-weight: 500;
                margin-bottom: 2px;
            }
            .points-value {
                font-size: 22px;
                font-weight: 800;
                color: var(--purple);
            }
            .points-note {
                font-size: 12px;
                color: var(--muted);
                margin-top: 2px;
            }
            .points-equiv {
                text-align: right;
                font-size: 13px;
                color: var(--muted);
            }
            .points-equiv strong {
                color: var(--green);
                font-size: 15px;
            }

            /* ── BOOKING LIST ── */
            .section-title {
                font-size: 15px;
                font-weight: 700;
                margin-bottom: 14px;
                display: flex;
                align-items: center;
                gap: 8px;
            }
            .badge-count {
                background: var(--blue-dim);
                color: var(--blue);
                font-size: 11px;
                font-weight: 700;
                padding: 2px 8px;
                border-radius: 20px;
            }
            .booking-list {
                display: flex;
                flex-direction: column;
                gap: 14px;
                margin-bottom: 32px;
            }

            .booking-card {
                background: var(--surface);
                border: 1px solid var(--border);
                border-radius: 14px;
                padding: 20px;
                transition: border-color .2s;
            }
            .booking-card:hover {
                border-color: rgba(96,165,250,.3);
            }

            .booking-card-header {
                display: flex;
                align-items: flex-start;
                justify-content: space-between;
                margin-bottom: 16px;
            }
            .booking-id {
                font-size: 12px;
                color: var(--muted);
                margin-bottom: 3px;
            }
            .booking-service {
                font-size: 16px;
                font-weight: 700;
            }
            .status-badge {
                font-size: 11px;
                font-weight: 600;
                padding: 4px 10px;
                border-radius: 20px;
                flex-shrink: 0;
                background: rgba(245,158,11,.15);
                color: var(--yellow);
                border: 1px solid rgba(245,158,11,.3);
            }

            .booking-meta {
                display: grid;
                grid-template-columns: repeat(3, 1fr);
                gap: 12px;
                margin-bottom: 18px;
            }
            .meta-item {
            }
            .meta-label {
                font-size: 11px;
                color: var(--muted);
                font-weight: 500;
                margin-bottom: 3px;
            }
            .meta-value {
                font-size: 13px;
                font-weight: 600;
            }

            .booking-amount {
                display: flex;
                align-items: center;
                justify-content: space-between;
                background: var(--surface2);
                border-radius: 10px;
                padding: 12px 16px;
                margin-bottom: 18px;
            }
            .amount-label {
                font-size: 13px;
                color: var(--muted);
            }
            .amount-value {
                font-size: 20px;
                font-weight: 800;
                color: var(--green);
            }

            /* ── PAYMENT METHOD SELECTOR ── */
            .method-label {
                font-size: 12px;
                color: var(--muted);
                font-weight: 600;
                text-transform: uppercase;
                letter-spacing: .8px;
                margin-bottom: 10px;
            }
            .method-grid {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 10px;
                margin-bottom: 16px;
            }

            .method-option {
                position: relative;
            }
            .method-option input[type="radio"] {
                position: absolute;
                opacity: 0;
                width: 0;
                height: 0;
            }
            .method-card {
                display: flex;
                align-items: center;
                gap: 12px;
                padding: 14px 16px;
                border-radius: 10px;
                border: 1.5px solid var(--border);
                cursor: pointer;
                transition: all .2s;
                background: var(--surface2);
            }
            .method-card:hover {
                border-color: rgba(96,165,250,.4);
            }
            .method-option input:checked + .method-card {
                border-color: var(--blue);
                background: var(--blue-dim);
            }
            .method-icon {
                width: 36px;
                height: 36px;
                border-radius: 8px;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 18px;
                flex-shrink: 0;
            }
            .method-icon.banking {
                background: rgba(6,182,212,.15);
            }
            .method-icon.points  {
                background: rgba(139,92,246,.15);
            }
            .method-text {
            }
            .method-name {
                font-size: 14px;
                font-weight: 600;
            }
            .method-desc {
                font-size: 11px;
                color: var(--muted);
                margin-top: 1px;
            }

            /* ── BANKING DETAILS (shown when banking selected) ── */
            .banking-detail {
                display: none;
                background: var(--surface3);
                border-radius: 10px;
                border: 1px solid var(--border);
                padding: 16px;
                margin-bottom: 16px;
            }
            .banking-detail.show {
                display: block;
            }
            .bank-row {
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: 7px 0;
                border-bottom: 1px solid rgba(255,255,255,.04);
            }
            .bank-row:last-child {
                border-bottom: none;
            }
            .bank-key {
                font-size: 12px;
                color: var(--muted);
            }
            .bank-val {
                font-size: 13px;
                font-weight: 600;
            }
            .bank-val.highlight {
                color: var(--cyan);
            }
            .copy-btn {
                background: none;
                border: 1px solid var(--border);
                color: var(--muted);
                font-size: 11px;
                padding: 3px 8px;
                border-radius: 5px;
                cursor: pointer;
                transition: all .2s;
                margin-left: 8px;
            }
            .copy-btn:hover {
                color: var(--blue);
                border-color: var(--blue);
            }
            .qr-area {
                text-align: center;
                padding: 12px 0 4px;
            }
            .qr-placeholder {
                width: 100px;
                height: 100px;
                margin: 0 auto 8px;
                background: white;
                border-radius: 8px;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 42px;
            }
            .qr-note {
                font-size: 11px;
                color: var(--muted);
            }

            /* ── POINTS DETAIL (shown when points selected) ── */
            .points-detail {
                display: none;
                background: var(--surface3);
                border-radius: 10px;
                border: 1px solid var(--border);
                padding: 16px;
                margin-bottom: 16px;
            }
            .points-detail.show {
                display: block;
            }
            .points-calc {
            }
            .calc-row {
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: 7px 0;
                border-bottom: 1px solid rgba(255,255,255,.04);
                font-size: 13px;
            }
            .calc-row:last-child {
                border-bottom: none;
            }
            .calc-key {
                color: var(--muted);
            }
            .calc-val {
                font-weight: 600;
            }
            .calc-val.green {
                color: var(--green);
            }
            .calc-val.red   {
                color: var(--red);
            }
            .calc-val.purple {
                color: var(--purple);
            }

            .insufficient-warn {
                display: flex;
                align-items: center;
                gap: 8px;
                background: rgba(239,68,68,.1);
                border: 1px solid rgba(239,68,68,.25);
                border-radius: 8px;
                padding: 10px 12px;
                font-size: 12px;
                color: #fca5a5;
                margin-top: 10px;
            }

            /* ── ACTION BUTTONS ── */
            .pay-btn {
                width: 100%;
                padding: 14px;
                border-radius: 10px;
                border: none;
                font-size: 15px;
                font-weight: 700;
                cursor: pointer;
                transition: all .2s;
                letter-spacing: .3px;
            }
            .pay-btn.banking {
                background: linear-gradient(135deg, var(--blue), var(--cyan));
                color: white;
            }
            .pay-btn.banking:hover {
                opacity: .9;
                transform: translateY(-1px);
            }
            .pay-btn.points-pay {
                background: linear-gradient(135deg, var(--purple), #7c3aed);
                color: white;
            }
            .pay-btn.points-pay:hover {
                opacity: .9;
                transform: translateY(-1px);
            }
            .pay-btn:disabled {
                background: var(--surface3);
                color: var(--muted);
                cursor: not-allowed;
                transform: none;
                opacity: 1;
            }

            /* ── EMPTY STATE ── */
            .empty-state {
                text-align: center;
                padding: 60px 20px;
                background: var(--surface);
                border: 1px solid var(--border);
                border-radius: 14px;
            }
            .empty-icon {
                font-size: 48px;
                margin-bottom: 14px;
            }
            .empty-title {
                font-size: 18px;
                font-weight: 700;
                margin-bottom: 6px;
            }
            .empty-sub {
                font-size: 14px;
                color: var(--muted);
            }

            /* ── MODAL ── */
            .modal-overlay {
                display: none;
                position: fixed;
                inset: 0;
                background: rgba(0,0,0,.7);
                backdrop-filter: blur(4px);
                z-index: 200;
                align-items: center;
                justify-content: center;
            }
            .modal-overlay.open {
                display: flex;
            }
            .modal {
                background: var(--surface);
                border: 1px solid var(--border);
                border-radius: 16px;
                padding: 28px;
                width: 380px;
                max-width: 90vw;
            }
            .modal-icon {
                font-size: 40px;
                text-align: center;
                margin-bottom: 12px;
            }
            .modal-title {
                font-size: 18px;
                font-weight: 800;
                text-align: center;
                margin-bottom: 6px;
            }
            .modal-body {
                font-size: 14px;
                color: var(--muted);
                text-align: center;
                margin-bottom: 22px;
                line-height: 1.6;
            }
            .modal-actions {
                display: flex;
                gap: 10px;
            }
            .modal-btn {
                flex: 1;
                padding: 12px;
                border-radius: 8px;
                border: none;
                font-size: 14px;
                font-weight: 600;
                cursor: pointer;
                transition: .2s;
            }
            .modal-btn.cancel {
                background: var(--surface3);
                color: var(--muted);
            }
            .modal-btn.cancel:hover {
                color: var(--text);
            }
            .modal-btn.confirm-banking {
                background: linear-gradient(135deg, var(--blue), var(--cyan));
                color: white;
            }
            .modal-btn.confirm-points {
                background: linear-gradient(135deg, var(--purple), #7c3aed);
                color: white;
            }
            .modal-btn:hover {
                opacity: .9;
            }

            /* ── SUCCESS TOAST ── */
            .toast {
                position: fixed;
                top: 24px;
                right: 24px;
                background: var(--green);
                color: white;
                padding: 14px 20px;
                border-radius: 10px;
                font-size: 14px;
                font-weight: 600;
                display: flex;
                align-items: center;
                gap: 8px;
                z-index: 999;
                transform: translateX(200%);
                transition: transform .3s ease;
                box-shadow: 0 8px 24px rgba(0,0,0,.4);
            }
            .toast.show {
                transform: translateX(0);
            }
        </style>
    </head>
    <body>

        <!-- ══ SIDEBAR ══ -->
        <aside class="sidebar">
            <a href="MainController?action=home" class="sidebar-logo">
                <div class="logo-icon">🚗</div>
                <span class="logo-text">AutoWash</span>
            </a>
            <nav class="sidebar-nav">
                <div class="nav-group-label">Menu</div>
                <a href="dashboard" class="nav-item">
                    <span class="nav-icon">🏠</span> Dashboard
                </a>
            </nav>
            <div class="sidebar-footer">
                <div class="user-card">
                    <div class="avatar"><%= cus.getFullname().substring(0, 1).toUpperCase()%></div>
                    <div>
                        <div class="user-name"><%= cus.getFullname()%></div>
                        <div class="user-tier">⭐ <%= membershipName%></div>
                    </div>
                </div>
            </div>
        </aside>

        <!-- ══ MAIN ══ -->
        <main class="main">
            <div class="page-header">
                <h1>💳 Thanh Toán</h1>
                <p>Chọn phương thức thanh toán cho lịch rửa xe của bạn</p>
            </div>

            <!-- Points Banner -->
            <div class="points-banner">
                <div class="points-icon">💎</div>
                <div class="points-info">
                    <div class="points-label">Điểm tích lũy hiện có</div>
                    <div class="points-value"><%= String.format("%,d", points)%> điểm</div>
                    <div class="points-note">Cần <%= String.format("%,d", 300)%> điểm để đổi 1 lần rửa miễn phí</div>
                </div>
                <div class="points-equiv">
                    <div style="font-size:11px;color:var(--muted);margin-bottom:2px;">Tương đương</div>
                    <strong><%= String.format("%,.0f", points * 1000.0)%> đ</strong>
                </div>
            </div>

            <%
                if (bookingList == null || bookingList.isEmpty()) {
            %>
            <!-- Empty State -->
            <div class="empty-state">
                <div class="empty-icon">✅</div>
                <div class="empty-title">Không có lịch chờ thanh toán</div>
                <div class="empty-sub">Tất cả lịch đặt của bạn đã được thanh toán hoặc chưa có lịch nào.</div>
                <a href="dashboard" style="display:inline-block;margin-top:20px;padding:10px 24px;background:var(--blue);color:white;border-radius:8px;text-decoration:none;font-weight:600;font-size:14px;">
                    Đặt lịch mới
                </a>
            </div>
            <%
            } else {
            %>

            <div class="section-title">
                Lịch chờ thanh toán
                <span class="badge-count"><%= bookingList.size()%></span>
            </div>

            <div class="booking-list">
                <%
                    for (Booking b : bookingList) {
                        boolean canPayPoints = points >= 300;
                        double amt = b.getTotalAmount();
                %>
                <div class="booking-card" id="card-<%= b.getBookingId()%>">
                    <div class="booking-card-header">
                        <div>
                            <div class="booking-id">#<%= b.getBookingId()%></div>
                            <div class="booking-service">Dịch vụ #<%= b.getServiceId()%></div>
                        </div>
                        <span class="status-badge">⏳ Chờ thanh toán</span>
                    </div>

                    <div class="booking-meta">
                        <div class="meta-item">
                            <div class="meta-label">📅 Ngày đặt</div>
                            <div class="meta-value">
                                <%= b.getBookingDate() != null
                                        ? new java.text.SimpleDateFormat("dd/MM/yyyy").format(b.getBookingDate())
                                        : "—"%>
                            </div>
                        </div>
                        <div class="meta-item">
                            <div class="meta-label">🕐 Giờ đặt</div>
                            <div class="meta-value">
                                <%= b.getBookingDate() != null
                                        ? new java.text.SimpleDateFormat("HH:mm").format(b.getBookingDate())
                                        : "—"%>
                            </div>
                        </div>
                    </div>

                    <div class="booking-amount">
                        <span class="amount-label">💰 Tổng tiền</span>
                        <span class="amount-value"><%= String.format("%,.0f", amt)%> đ</span>
                    </div>

                    <!-- Payment Method Selector -->
                    <div class="method-label">Chọn phương thức thanh toán</div>
                    <div class="method-grid">
                        <!-- Banking -->
                        <label class="method-option">
                            <input type="radio" name="method-<%= b.getBookingId()%>" value="Banking"
                                   onchange="selectMethod(<%= b.getBookingId()%>, 'Banking')" checked>
                            <div class="method-card">
                                <div class="method-icon banking">🏦</div>
                                <div class="method-text">
                                    <div class="method-name">Chuyển khoản</div>
                                    <div class="method-desc">Nhận điểm thưởng</div>
                                </div>
                            </div>
                        </label>

                        <!-- Points -->
                        <label class="method-option">
                            <input type="radio" name="method-<%= b.getBookingId()%>" value="Points"
                                   onchange="selectMethod(<%= b.getBookingId()%>, 'Points')"
                                   <%= !canPayPoints ? "disabled" : ""%>>
                            <div class="method-card" style="<%= !canPayPoints ? "opacity:.5;cursor:not-allowed;" : ""%>">
                                <div class="method-icon points">💎</div>
                                <div class="method-text">
                                    <div class="method-name">Đổi điểm</div>
                                    <div class="method-desc"><%= canPayPoints ? "Dùng " + String.format("%,d", 300) + " điểm" : "Không đủ điểm"%></div>
                                </div>
                            </div>
                        </label>
                    </div>

                    <!-- Banking Details -->


                    <!-- Points Details -->
                    <div class="points-detail" id="points-<%= b.getBookingId()%>">
                        <div style="font-size:12px;color:var(--muted);font-weight:600;margin-bottom:10px;text-transform:uppercase;letter-spacing:.8px;">
                            💎 Chi tiết đổi điểm
                        </div>
                        <div class="points-calc">
                            <div class="calc-row">
                                <span class="calc-key">Điểm hiện có</span>
                                <span class="calc-val purple"><%= String.format("%,d", points)%> điểm</span>
                            </div>
                            <div class="calc-row">
                                <span class="calc-key">Điểm sẽ dùng</span>
                                <span class="calc-val red">– 300 điểm</span>
                            </div>
                            <div class="calc-row">
                                <span class="calc-key">Quy đổi</span>
                                <span class="calc-val green">300,000 đ</span>
                            </div>
                            <div class="calc-row">
                                <span class="calc-key">Điểm còn lại</span>
                                <span class="calc-val purple"><%= String.format("%,d", points - 300)%> điểm</span>
                            </div>
                        </div>
                        <% if (!canPayPoints) {%>
                        <div class="insufficient-warn">
                            ⚠️ Bạn cần ít nhất 300 điểm để sử dụng phương thức này.
                            Hiện có <strong><%= points%> điểm</strong>.
                        </div>
                        <% }%>
                    </div>

                    <!-- Pay Button -->
                    <button class="pay-btn banking" id="paybtn-<%= b.getBookingId()%>"
                            onclick="openConfirm(<%= b.getBookingId()%>, '<%= String.format("%,.0f", amt)%>')">
                        Xác nhận đã thanh toán
                    </button>
                </div>
                <% } %>
            </div>

            <% } %>
        </main>

        <!-- ══ CONFIRM MODAL ══ -->
        <div class="modal-overlay" id="confirmModal">
            <div class="modal">
                <div class="modal-icon" id="modalIcon">💳</div>
                <div class="modal-title" id="modalTitle">Xác nhận thanh toán</div>
                <div class="modal-body" id="modalBody">Bạn có chắc muốn thanh toán?S</div>
                <div class="modal-actions">
                    <button class="modal-btn cancel" onclick="closeModal()">Hủy bỏ</button>
                    <button class="modal-btn confirm-banking" id="confirmBtn" onclick="submitPayment()">
                        Xác nhận
                    </button>
                </div>
            </div>
        </div>

        <!-- Hidden form -->
        <form id="payForm" action="PaymentService" method="POST" style="display:none;">
            <input type="hidden" name="bookingId" id="formBookingId">
            <input type="hidden" name="paymentMethod" id="formPaymentMethod">
        </form>

        <!-- Toast -->
        <div class="toast" id="toast">✅ <span id="toastMsg">Thao tác thành công!</span></div>

        <script>
            // Track selected method per booking
            const selectedMethods = {};

            <% if (bookingList != null) {
                    for (Booking b : bookingList) {%>
            selectedMethods[<%= b.getBookingId()%>] = 'Banking';
            <% }
                }%>

            function selectMethod(bookingId, method) {
                selectedMethods[bookingId] = method;

                const bankingDiv = document.getElementById('banking-' + bookingId);
                const pointsDiv = document.getElementById('points-' + bookingId);
                const payBtn = document.getElementById('paybtn-' + bookingId);

                if (method === 'Banking') {
                    bankingDiv.classList.add('show');
                    pointsDiv.classList.remove('show');
                    payBtn.className = 'pay-btn banking';
                    payBtn.textContent = '🏦 Xác nhận đã chuyển khoản';
                    payBtn.disabled = false;
                } else {
                    bankingDiv.classList.remove('show');
                    pointsDiv.classList.add('show');
                    const canPay = <%= points%> >= 300;
                    payBtn.className = 'pay-btn points-pay';
                    payBtn.textContent = '💎 Thanh toán bằng điểm (300 điểm)';
                    payBtn.disabled = !canPay;
                }
            }

            let pendingBookingId = null;
            let pendingMethod = null;

            function openConfirm(bookingId, amount) {
                pendingBookingId = bookingId;
                pendingMethod = selectedMethods[bookingId] || 'Banking';

                const modal = document.getElementById('confirmModal');
                const icon = document.getElementById('modalIcon');
                const title = document.getElementById('modalTitle');
                const body = document.getElementById('modalBody');
                const btn = document.getElementById('confirmBtn');

                if (pendingMethod === 'Banking') {
                    icon.textContent = '🏦';
                    title.textContent = 'Xác nhận chuyển khoản';
                    body.innerHTML = `Bạn xác nhận đã chuyển khoản <strong style="color:#10b981">${amount} đ</strong> đến tài khoản AutoWash?<br><br>
                        <small style="color:#64748b">Nội dung: <strong>AUTOWASH${bookingId}</strong></small>`;
                    btn.className = 'modal-btn confirm-banking';
                    btn.textContent = '✅ Xác nhận đã CK';
                } else {
                    icon.textContent = '💎';
                    title.textContent = 'Đổi điểm thanh toán';
                    body.innerHTML = `Sử dụng <strong style="color:#8b5cf6">300 điểm</strong> để thanh toán lịch #${bookingId}?<br><br>
                        <small style="color:#64748b">Điểm còn lại sau giao dịch: <strong><%= points%> – 300 = <%= points - 300%> điểm</strong></small>`;
                    btn.className = 'modal-btn confirm-points';
                    btn.textContent = '💎 Đổi điểm ngay';
                }

                modal.classList.add('open');
            }

            function closeModal() {
                document.getElementById('confirmModal').classList.remove('open');
                pendingBookingId = null;
                pendingMethod = null;
            }

            function submitPayment() {
                if (!pendingBookingId)
                    return;
                document.getElementById('formBookingId').value = pendingBookingId;
                document.getElementById('formPaymentMethod').value = pendingMethod;
                closeModal();
                showToast(pendingMethod === 'Banking'
                        ? 'Đang xử lý thanh toán chuyển khoản…'
                        : '💎 Đang đổi điểm…');
                setTimeout(() => document.getElementById('payForm').submit(), 800);
            }

            function copyText(text, btn) {
                navigator.clipboard.writeText(text).then(() => {
                    const orig = btn.textContent;
                    btn.textContent = '✓ Đã chép';
                    btn.style.color = '#10b981';
                    setTimeout(() => {
                        btn.textContent = orig;
                        btn.style.color = '';
                    }, 2000);
                });
            }

            function showToast(msg) {
                const t = document.getElementById('toast');
                document.getElementById('toastMsg').textContent = msg;
                t.classList.add('show');
                setTimeout(() => t.classList.remove('show'), 3000);
            }

            // Close modal on backdrop click
            document.getElementById('confirmModal').addEventListener('click', function (e) {
                if (e.target === this)
                    closeModal();
            });
        </script>
    </body>
</html>
