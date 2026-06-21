<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="dto.Customer"%>
<%@page import="dto.Car"%>
<%@page import="java.util.List"%>
<%
    Customer admin = (Customer) session.getAttribute("USER");
    if (admin == null || !admin.getEmail().equals("admin@admin.com")) {
        response.sendRedirect("MainController?action=home");
        return;
    }
    List<Car> carList = (List<Car>) request.getAttribute("CAR_LIST");
    String currentPage = "cars";
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Admin - Danh sách xe</title>
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
            .btn-customers {
                background:#1e3a8a;
                color:white;
            }
            .btn-customers:hover {
                background:#1d4ed8;
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
            .btn-delete {
                background:#dc2626;
                color:white;
                padding:6px 14px;
                border-radius:6px;
                text-decoration:none;
                font-size:13px;
                border:none;
                cursor:pointer;
            }
            .btn-delete:hover {
                background:#b91c1c;
            }
            /* Modal */
            .modal {
                position:fixed;
                top:0;
                left:0;
                width:100%;
                height:100%;
                background:rgba(0,0,0,.7);
                display:none;
                justify-content:center;
                align-items:center;
                z-index:999;
            }
            .modal-content {
                background:#111827;
                padding:36px;
                border-radius:16px;
                text-align:center;
                width:380px;
            }
            .modal-content h3 {
                color:white;
                margin-bottom:10px;
                font-size:19px;
            }
            .modal-content p {
                color:#9ca3af;
                margin-bottom:22px;
                font-size:14px;
            }
            .modal-btns {
                display:flex;
                gap:12px;
                justify-content:center;
            }
            .modal-btns a {
                background:#dc2626;
                color:white;
                padding:10px 22px;
                border-radius:8px;
                text-decoration:none;
                font-weight:600;
                font-size:14px;
            }
            .modal-btns button {
                background:#374151;
                color:white;
                border:none;
                padding:10px 22px;
                border-radius:8px;
                cursor:pointer;
                font-weight:600;
                font-size:14px;
            }
        </style>
    </head>
    <body>
<%@ include file="includes/admin_sidebar.jspf" %> 
        <!-- Delete Confirm Modal -->
        <div id="deleteModal" class="modal">
            <div class="modal-content">
                <div style="font-size:44px;margin-bottom:14px">&#9888;</div>
                <h3>Xác nhận xóa xe</h3>
                <p id="deleteMsg">Bạn có chắc muốn xóa xe này không?</p>
                <div class="modal-btns">
                    <a id="deleteConfirmLink" href="#">Xác nhận xóa</a>
                    <button onclick="closeModal()">Hủy</button>
                </div>
            </div>
        </div>

        <div class="container">
            <div class="top-bar">
                <h1>&#128663; Quản lý xe</h1>
            </div>

            <%
                int totalActive = 0, totalInactive = 0;
                if (carList != null) {
                    for (Car c : carList) {
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
                    <div class="num"><%= carList != null ? carList.size() : 0%></div>
                    <div class="label">Tổng số xe</div>
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
                <input type="text" id="searchInput" placeholder="&#128269; Tìm theo biển số, hãng, model, màu..." onkeyup="filterTable()">
            </div>

            <table id="carTable">
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Chủ xe (cusId)</th>
                        <th>Biển số</th>
                        <th>Loại</th>
                        <th>Hãng</th>
                        <th>Model</th>
                        <th>Màu</th>
                        <th>Ngày đăng ký</th>
                        <th>Trạng thái</th>
                        <th>Hành động</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        if (carList != null && !carList.isEmpty()) {
                            for (Car c : carList) {
                    %>
                    <tr>
                        <td><%= c.getId()%></td>
                        <td><%= c.getCusid()%></td>
                        <td><%= c.getLicensePlate() != null ? c.getLicensePlate() : ""%></td>
                        <td><%= c.getType() != null ? c.getType() : ""%></td>
                        <td><%= c.getBrand() != null ? c.getBrand() : ""%></td>
                        <td><%= c.getModel() != null ? c.getModel() : ""%></td>
                        <td><%= c.getColor() != null ? c.getColor() : ""%></td>
                        <td><%= c.getCreatedDate() != null ? c.getCreatedDate().toString() : ""%></td>
                        <td>
                            <% if (c.isStatus()) { %>
                            <span class="badge badge-active">Hoạt động</span>
                            <% } else { %>
                            <span class="badge badge-inactive">Vô hiệu</span>
                            <% }%>
                        </td>
                        <td>
                            <button class="btn-delete"
                                    onclick="confirmDelete(<%= c.getId()%>, '<%= c.getLicensePlate() != null ? c.getLicensePlate() : ""%>')">
                                &#128465; Xóa
                            </button>
                        </td>
                    </tr>
                    <%
                        }
                    } else {
                    %>
                    <tr><td colspan="10" style="text-align:center;color:#6b7280;padding:30px">Không có xe nào.</td></tr>
                    <% }%>
                </tbody>
            </table>
        </div>

        <script>
            function confirmDelete(id, plate) {
                document.getElementById("deleteMsg").innerText =
                        "Bạn có chắc muốn xóa xe biển số "" + plate + "" không?";
                        document.getElementById("deleteConfirmLink").href =
                        "AdminController?action=deleteCar&id=" + id;
                document.getElementById("deleteModal").style.display = "flex";
            }

            function closeModal() {
                document.getElementById("deleteModal").style.display = "none";
            }

            function filterTable() {
                const input = document.getElementById("searchInput").value.toLowerCase();
                const rows = document.querySelectorAll("#carTable tbody tr");
                rows.forEach(row => {
                    row.style.display = row.innerText.toLowerCase().includes(input) ? "" : "none";
                });
            }
        </script>
    </body>
</html>
