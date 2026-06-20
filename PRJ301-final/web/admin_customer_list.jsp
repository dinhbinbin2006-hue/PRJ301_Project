<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="dto.Customer"%>
<%@page import="java.util.List"%>
<%
    Customer admin = (Customer) session.getAttribute("USER");
    if (admin == null || !admin.getEmail().equals("admin@admin.com")) {
        response.sendRedirect("MainController?action=home");
        return;
    }
    List<Customer> customerList = (List<Customer>) request.getAttribute("CUSTOMER_LIST");
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Admin - Danh sách khách hàng</title>
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
                padding:40px;
            }
            .container {
                max-width:1100px;
                margin:auto;
            }
            .top-bar {
                display:flex;
                justify-content:space-between;
                align-items:center;
                margin-bottom:30px;
            }
            h1 {
                font-size:26px;
                color:#60a5fa;
            }
            .nav-btns {
                display:flex;
                gap:10px;
            }
            .btn {
                padding:10px 20px;
                border-radius:8px;
                text-decoration:none;
                font-size:14px;
                font-weight:600;
            }
            .btn-home {
                background:#374151;
                color:white;
            }
            .btn-home:hover {
                background:#4b5563;
            }
            .btn-cars {
                background:#0f766e;
                color:white;
            }
            .btn-cars:hover {
                background:#0d9488;
            }
            .stats {
                display:flex;
                gap:20px;
                margin-bottom:24px;
            }
            .stat-card {
                background:#111827;
                padding:20px 30px;
                border-radius:12px;
                flex:1;
                text-align:center;
            }
            .stat-card .num {
                font-size:34px;
                font-weight:700;
                color:#60a5fa;
            }
            .stat-card .label {
                color:#9ca3af;
                margin-top:4px;
                font-size:14px;
            }
            .search-bar {
                margin-bottom:16px;
            }
            .search-bar input {
                width:100%;
                padding:11px 16px;
                background:#111827;
                border:1px solid #374151;
                border-radius:8px;
                color:white;
                font-size:15px;
                outline:none;
            }
            .search-bar input:focus {
                border-color:#2563eb;
            }
            .search-bar input::placeholder {
                color:#6b7280;
            }
            table {
                width:100%;
                border-collapse:collapse;
                background:#111827;
                border-radius:12px;
                overflow:hidden;
            }
            th {
                background:#0f172a;
                color:#60a5fa;
                padding:13px 16px;
                text-align:left;
                font-size:13px;
                text-transform:uppercase;
                letter-spacing:.5px;
            }
            td {
                padding:13px 16px;
                color:white;
                border-bottom:1px solid #1f2937;
                font-size:14px;
            }
            tr:last-child td {
                border-bottom:none;
            }
            tr:hover td {
                background:#1f2937;
            }
            .badge {
                display:inline-block;
                padding:3px 10px;
                border-radius:20px;
                font-size:12px;
                font-weight:600;
            }
            .badge-active {
                background:#14532d;
                color:#4ade80;
            }
            .badge-inactive {
                background:#450a0a;
                color:#f87171;
            }
            .btn-view {
                background:#2563eb;
                color:white;
                padding:6px 14px;
                border-radius:6px;
                text-decoration:none;
                font-size:13px;
            }
            .btn-view:hover {
                background:#1d4ed8;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <div class="top-bar">
                <h1>&#128100; Quản lý khách hàng</h1>
                <div class="nav-btns">
                    <a href="AdminController?action=listCars" class="btn btn-cars">&#128663; Quản lý xe</a>
                    <a href="MainController?action=home" class="btn btn-home">&#8592; Trang chủ</a>
                </div>
            </div>

            <%
                int totalActive = 0, totalInactive = 0;
                if (customerList != null) {
                    for (Customer c : customerList) {
                        if (c.isStatus()) {
                            totalActive++;
                        } else {
                            totalInactive++;
                        }
                    }
                }
            %>
            <div class="stats">
                <div class="stat-card">
                    <div class="num"><%= customerList != null ? customerList.size() : 0%></div>
                    <div class="label">Tổng khách hàng</div>
                </div>
                <div class="stat-card">
                    <div class="num" style="color:#4ade80"><%= totalActive%></div>
                    <div class="label">Đang hoạt động</div>
                </div>
                <div class="stat-card">
                    <div class="num" style="color:#f87171"><%= totalInactive%></div>
                    <div class="label">Đã vô hiệu hóa</div>
                </div>
            </div>

            <div class="search-bar">
                <input type="text" id="searchInput" placeholder="&#128269; Tìm theo tên, email, số điện thoại..." onkeyup="filterTable()">
            </div>

            <table id="customerTable">
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Họ tên</th>
                        <th>Email</th>
                        <th>Số điện thoại</th>
                        <th>Giới tính</th>
                        <th>Hạng</th>
                        <th>Điểm</th>
                        <th>Trạng thái</th>
                        <th>Ngày đăng ký</th>
                        <th>Hành động</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        if (customerList != null && !customerList.isEmpty()) {
                            for (Customer c : customerList) {
                    %>
                    <tr>
                        <td><%= c.getCusId()%></td>
                        <td><%= c.getFullname() != null ? c.getFullname() : ""%></td>
                        <td><%= c.getEmail() != null ? c.getEmail() : ""%></td>
                        <td><%= c.getPhone() != null ? c.getPhone() : ""%></td>
                        <td><%= c.getGender() != null ? c.getGender() : ""%></td>
                        <td><%= c.getMembershipLevel() != null ? c.getMembershipLevel() : ""%></td>
                        <td><%= c.getPoints()%></td>
                        <td>
                            <% if (c.isStatus()) { %>
                            <span class="badge badge-active">Hoạt động</span>
                            <% } else { %>
                            <span class="badge badge-inactive">Vô hiệu</span>
                            <% }%>
                        </td>
                        <td><%= c.getCreatedAt() != null ? c.getCreatedAt().toString() : ""%></td>
                        <td>
                            <a href="AdminController?action=viewCustomer&cusId=<%= c.getCusId()%>" class="btn-view">Xem</a>
                        </td>
                    </tr>
                    <%
                        }
                    } else {
                    %>
                    <tr><td colspan="10" style="text-align:center;color:#6b7280;padding:30px">Không có khách hàng nào.</td></tr>
                    <% }%>
                </tbody>
            </table>
        </div>

        <script>
            function filterTable() {
                const input = document.getElementById("searchInput").value.toLowerCase();
                const rows = document.querySelectorAll("#customerTable tbody tr");
                rows.forEach(row => {
                    row.style.display = row.innerText.toLowerCase().includes(input) ? "" : "none";
                });
            }
        </script>
    </body>
</html>
