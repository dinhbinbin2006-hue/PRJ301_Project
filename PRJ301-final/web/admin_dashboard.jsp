<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="dto.Customer"%>
<%
    Customer admin = (Customer) session.getAttribute("USER");
    if (admin == null || !admin.getEmail().equals("admin@admin.com")) {
        response.sendRedirect("MainController?action=home");
        return;
    }
    String currentPage = "dashboard";
    Integer totalCustomers = (Integer) request.getAttribute("TOTAL_CUSTOMERS");
    Integer activeCustomers = (Integer) request.getAttribute("ACTIVE_CUSTOMERS");
    Integer inactiveCustomers = (Integer) request.getAttribute("INACTIVE_CUSTOMERS");
    Integer totalCars = (Integer) request.getAttribute("TOTAL_CARS");
    Integer totalBookings = (Integer) request.getAttribute("TOTAL_BOOKINGS");
    Double totalRevenue = (Double) request.getAttribute("TOTAL_REVENUE");
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Dashboard - Admin</title>
        <style>
            * {
                margin:0;
                padding:0;
                box-sizing:border-box;
                font-family:'Segoe UI',sans-serif;
            }
            body {
                background:#0f172a;
                min-height:100vh;
                color:white;
                padding:40px 40px 40px 280px;
            }
            .container {
                max-width:1100px;
                margin:auto;
            }
            .top-bar {
                margin-bottom:8px;
            }
            h1 {
                font-size:28px;
                color:#60a5fa;
            }
            .subtitle {
                color:#9ca3af;
                margin-bottom:32px;
                font-size:14px;
            }
            .stats {
                display:grid;
                grid-template-columns:repeat(3, 1fr);
                gap:20px;
                margin-bottom:36px;
            }
            .stat-card {
                background:#111827;
                padding:24px;
                border-radius:14px;
                border:1px solid #1f2937;
            }
            .stat-card .icon {
                font-size:22px;
                margin-bottom:10px;
            }
            .stat-card .num {
                font-size:32px;
                font-weight:700;
                color:#60a5fa;
            }
            .stat-card .label {
                color:#9ca3af;
                margin-top:6px;
                font-size:13px;
            }
            .quick-section {
                background:#111827;
                border:1px solid #1f2937;
                border-radius:14px;
                padding:28px;
            }
            .quick-section h2 {
                font-size:18px;
                color:#e2e8f0;
                margin-bottom:18px;
            }
            .quick-links {
                display:flex;
                gap:16px;
                flex-wrap:wrap;
            }
            .quick-link {
                flex:1;
                min-width:220px;
                background:#0f172a;
                border:1px solid #1f2937;
                border-radius:12px;
                padding:20px;
                text-decoration:none;
                color:white;
                transition:.15s;
            }
            .quick-link:hover {
                border-color:#2563eb;
                background:#1e293b;
            }
            .quick-link .ql-title {
                font-weight:600;
                font-size:15px;
                display:flex;
                align-items:center;
                gap:10px;
                margin-bottom:6px;
            }
            .quick-link .ql-desc {
                font-size:13px;
                color:#9ca3af;
            }
        </style>
    </head>
    <body>
        <%@ include file="includes/admin_sidebar.jspf" %>
        <div class="container">
            <div class="top-bar">
                <h1>Dashboard</h1>
            </div>
            <div class="subtitle">Tổng quan hệ thống AutoWash</div>

            <div class="stats">
                <div class="stat-card">
                    <div class="icon">&#128100;</div>
                    <div class="num"><%= totalCustomers != null ? totalCustomers : 0%></div>
                    <div class="label">Tổng khách hàng</div>
                </div>
                <div class="stat-card">
                    <div class="icon">&#9989;</div>
                    <div class="num" style="color:#4ade80"><%= activeCustomers != null ? activeCustomers : 0%></div>
                    <div class="label">Đang hoạt động</div>
                </div>
                <div class="stat-card">
                    <div class="icon">&#128683;</div>
                    <div class="num" style="color:#f87171"><%= inactiveCustomers != null ? inactiveCustomers : 0%></div>
                    <div class="label">Đã vô hiệu hóa</div>
                </div>
                <div class="stat-card">
                    <div class="icon">&#128663;</div>
                    <div class="num"><%= totalCars != null ? totalCars : 0%></div>
                    <div class="label">Tổng số xe</div>
                </div>
                <div class="stat-card">
                    <div class="icon">&#128203;</div>
                    <div class="num" style="color:#a78bfa"><%= totalBookings != null ? totalBookings : 0%></div>
                    <div class="label">Tổng lượt đặt</div>
                </div>
                <div class="stat-card">
                    <div class="icon">&#128176;</div>
                    <div class="num" style="color:#fbbf24; font-size:22px">
                        <%
                            double rev = totalRevenue != null ? totalRevenue : 0;
                            if (rev >= 1_000_000_000) {
                                out.print(String.format("%.1fB", rev / 1_000_000_000));
                            } else if (rev >= 1_000_000) {
                                out.print(String.format("%.1fM", rev / 1_000_000));
                            } else {
                                out.print(String.format("%,.0f", rev));
                            }
                        %>
                    </div>
                    <div class="label">Tổng thu nhập (VNĐ)</div>
                </div>
            </div>

            <div class="quick-section">
                <h2>Truy cập nhanh</h2>
                <div class="quick-links">
                    <a href="AdminController?action=listCustomers" class="quick-link">
                        <div class="ql-title">&#128100; Quản lý khách hàng</div>
                        <div class="ql-desc">Xem, chỉnh sửa, vô hiệu hóa tài khoản khách hàng</div>
                    </a>
                    <a href="AdminController?action=listCars" class="quick-link">
                        <div class="ql-title">&#128663; Quản lý xe</div>
                        <div class="ql-desc">Xem và quản lý danh sách xe của khách hàng</div>
                    </a>

                    
                    <a href="AdminController?action=listBookings" class="quick-link">
                        <div class="ql-title">&#128203; Quản lý lịch đặt</div>
                        <div class="ql-desc">Xem và quản lý lịch đặt xe của khách hàng</div>
                    </a>

                </div>
            </div>
        </div>
    </body>
</html>