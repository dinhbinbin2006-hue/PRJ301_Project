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
    Customer cus = (Customer) request.getAttribute("CUSTOMER_DETAIL");
    List<Car> carList = (List<Car>) request.getAttribute("CUSTOMER_CARS");
    if (cus == null) {
        response.sendRedirect("AdminController?action=listCustomers");
        return;
    }
    String successMsg = (String) request.getAttribute("SUCCESS");
    String errorMsg = (String) request.getAttribute("ERROR");
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Chi tiết khách hàng - Admin</title>
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
                max-width:750px;
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
            .back-btn {
                background:#374151;
                color:white;
                padding:10px 20px;
                border-radius:8px;
                text-decoration:none;
            }
            .back-btn:hover {
                background:#4b5563;
            }
            .card {
                background:#111827;
                border-radius:14px;
                padding:32px;
                margin-bottom:24px;
            }
            .card h2 {
                font-size:18px;
                color:#9ca3af;
                margin-bottom:20px;
                border-bottom:1px solid #1f2937;
                padding-bottom:12px;
            }
            .info-row {
                display:flex;
                justify-content:space-between;
                padding:10px 0;
                border-bottom:1px solid #1f2937;
                font-size:15px;
            }
            .info-row:last-child {
                border-bottom:none;
            }
            .info-label {
                color:#9ca3af;
            }
            .info-value {
                color:white;
                font-weight:500;
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
            form label {
                display:block;
                color:#9ca3af;
                margin-bottom:6px;
                font-size:14px;
            }
            form input, form select {
                width:100%;
                padding:10px 14px;
                background:#1f2937;
                border:1px solid #374151;
                border-radius:8px;
                color:white;
                font-size:15px;
                margin-bottom:16px;
                outline:none;
            }
            form input:focus, form select:focus {
                border-color:#2563eb;
            }
            .btn-save {
                background:#2563eb;
                color:white;
                border:none;
                padding:12px 28px;
                border-radius:8px;
                cursor:pointer;
                font-size:15px;
                font-weight:600;
            }
            .btn-save:hover {
                background:#1d4ed8;
            }
            .btn-delete {
                background:#dc2626;
                color:white;
                border:none;
                padding:12px 28px;
                border-radius:8px;
                cursor:pointer;
                font-size:15px;
                font-weight:600;
            }
            .btn-delete:hover {
                background:#b91c1c;
            }
            .alert {
                padding:14px 18px;
                border-radius:8px;
                margin-bottom:20px;
                font-size:14px;
            }
            .alert-success {
                background:#14532d;
                color:#4ade80;
            }
            .alert-error {
                background:#450a0a;
                color:#f87171;
            }
            .action-row {
                display:flex;
                gap:12px;
            }
            /* Delete confirm modal */
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
                padding:40px;
                border-radius:16px;
                text-align:center;
                width:400px;
            }
            .modal-content h3 {
                color:white;
                margin-bottom:12px;
                font-size:20px;
            }
            .modal-content p {
                color:#9ca3af;
                margin-bottom:24px;
            }
            .modal-btns {
                display:flex;
                gap:12px;
                justify-content:center;
            }
            .modal-btns a {
                background:#dc2626;
                color:white;
                padding:11px 22px;
                border-radius:8px;
                text-decoration:none;
                font-weight:600;
            }
            .modal-btns button {
                background:#374151;
                color:white;
                border:none;
                padding:11px 22px;
                border-radius:8px;
                cursor:pointer;
                font-weight:600;
            }
        </style>
    </head>
    <body>

        <!-- Delete Confirm Modal -->
        <div id="deleteModal" class="modal">
            <div class="modal-content">
                <div style="font-size:48px;margin-bottom:16px">&#9888;</div>
                <h3>Xác nhận xóa khách hàng</h3>
                <p>Bạn có chắc muốn xóa tài khoản của <strong style="color:white"><%= cus.getFullname()%></strong>?<br>Hành động này sẽ vô hiệu hóa tài khoản.</p>
                <div class="modal-btns">
                    <a href="AdminController?action=deleteCustomer&cusId=<%= cus.getCusId()%>">Xác nhận xóa</a>
                    <button onclick="document.getElementById('deleteModal').style.display = 'none'">Hủy</button>
                </div>
            </div>
        </div>

        <div class="container">
            <div class="top-bar">
                <h1>&#128100; Chi tiết khách hàng #<%= cus.getCusId()%></h1>
                <a href="AdminController?action=listCustomers" class="back-btn">&#8592; Danh sách</a>
            </div>

            <% if (successMsg != null) {%>
            <div class="alert alert-success">&#10003; <%= successMsg%></div>
            <% } %>
            <% if (errorMsg != null) {%>
            <div class="alert alert-error">&#10007; <%= errorMsg%></div>
            <% }%>

            <!-- Thông tin hiện tại (read-only) -->
            <div class="card">
                <h2>&#128203; Thông tin tài khoản</h2>
                <div class="info-row"><span class="info-label">ID</span><span class="info-value">#<%= cus.getCusId()%></span></div>
                <div class="info-row"><span class="info-label">Email</span><span class="info-value"><%= cus.getEmail()%></span></div>
                <div class="info-row"><span class="info-label">Ngày đăng ký</span><span class="info-value"><%= cus.getCreatedAt() != null ? cus.getCreatedAt().toString() : "—"%></span></div>
                <div class="info-row"><span class="info-label">Hạng thành viên</span><span class="info-value"><%= cus.getMembershipLevel() != null ? cus.getMembershipLevel() : "—"%></span></div>
                <div class="info-row"><span class="info-label">Điểm tích lũy</span><span class="info-value"><%= cus.getPoints()%> pts</span></div>
                <div class="info-row">
                    <span class="info-label">Trạng thái</span>
                    <span class="info-value">
                        <% if (cus.isStatus()) { %><span class="badge badge-active">Hoạt động</span><% } else { %><span class="badge badge-inactive">Vô hiệu hóa</span><% }%>
                    </span>
                </div>
            </div>

            <!-- Form chỉnh sửa -->

            <div class="card">
                <h2>&#9998; Chỉnh sửa thông tin</h2>
                <form action="AdminController" method="post">

                    <input type="hidden" name="action" value="updateCustomer">
                    <input type="hidden" name="cusId" value="<%= cus.getCusId()%>">

                    <label>Họ và tên</label>
                    <input type="text" name="fullname"
                           value="<%= cus.getFullname() != null ? cus.getFullname() : ""%>">

                    <label>Email</label>
                    <input type="text" name="email"
                           value="<%= cus.getEmail() != null ? cus.getEmail() : ""%>">

                    <label>Password</label>
                    <input type="text" name="password"
                           value="<%= cus.getPassword() != null ? cus.getPassword() : ""%>">

                    <label>Giới tính</label>
                    <select name="gender">
                        <option value="Male"
                                <%= "Male".equals(cus.getGender()) ? "selected" : ""%>>
                            Nam
                        </option>

                        <option value="Female"
                                <%= "Female".equals(cus.getGender()) ? "selected" : ""%>>
                            Nữ
                        </option>

                        <option value="Other"
                                <%= "Other".equals(cus.getGender()) ? "selected" : ""%>>
                            Khác
                        </option>
                    </select>

                    <label>Ngày sinh</label>
                    <input type="date"
                           name="dateOfBirth"
                           value="<%= cus.getDateOfBirth() != null ? cus.getDateOfBirth().toString() : ""%>">

                    <label>Số điện thoại</label>
                    <input type="text"
                           name="phone"
                           value="<%= cus.getPhone() != null ? cus.getPhone() : ""%>">

                    <label>Tier ID</label>
                    <input type="number"
                           name="tierId"
                           value="<%= cus.getMembershipLevel()%>">

                    <label>Points</label>
                    <input type="number"
                           name="points"
                           value="<%= cus.getPoints()%>">

                    <div class="action-row">
                        <button type="submit" class="btn-save">
                            ✔ Lưu thay đổi
                        </button>

                        <button type="button"
                                class="btn-delete"
                                onclick="document.getElementById('deleteModal').style.display = 'flex'">
                            🗑 Xóa khách hàng
                        </button>
                    </div>

                </form>
            </div>

            <!-- Danh sách xe của khách hàng -->
            <div class="card">
                <h2>&#128663; Danh sách xe</h2>
                <% if (carList == null || carList.isEmpty()) { %>
                <p style="color:#9ca3af; text-align:center; padding:20px 0;">Khách hàng chưa có xe nào.</p>
                <% } else { %>
                <table style="width:100%; border-collapse:collapse; font-size:14px;">
                    <thead>
                        <tr style="color:#9ca3af; border-bottom:1px solid #374151;">
                            <th style="padding:10px; text-align:left;">Biển số</th>
                            <th style="padding:10px; text-align:left;">Loại</th>
                            <th style="padding:10px; text-align:left;">Hãng</th>
                            <th style="padding:10px; text-align:left;">Model</th>
                            <th style="padding:10px; text-align:left;">Màu</th>
                            <th style="padding:10px; text-align:left;">Trạng thái</th>
                            <th style="padding:10px; text-align:left;">Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (Car car : carList) {%>
                        <tr style="border-bottom:1px solid #1f2937;">
                            <td style="padding:10px; color:white;"><%= car.getLicensePlate()%></td>
                            <td style="padding:10px; color:white;"><%= car.getType()%></td>
                            <td style="padding:10px; color:white;"><%= car.getBrand()%></td>
                            <td style="padding:10px; color:white;"><%= car.getModel()%></td>
                            <td style="padding:10px; color:white;"><%= car.getColor()%></td>
                            <td style="padding:10px;">
                                <% if (car.isStatus()) { %>
                                <span class="badge badge-active">Hoạt động</span>
                                <% } else { %>
                                <span class="badge badge-inactive">Vô hiệu hóa</span>
                                <% }%>
                            </td>
                            <td style="padding:10px;">
                                <a href="AdminController?action=editCar&carId=<%= car.getId()%>&cusId=<%= cus.getCusId()%>"
                                   style="color:#60a5fa; text-decoration:none; margin-right:10px;">Sửa</a>
                                <a href="AdminController?action=deleteCar&id=<%= car.getId()%>"
                                   style="color:#f87171; text-decoration:none;"
                                   onclick="return confirm('Xóa xe này?')">Xóa</a>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
                <% }%>
            </div>
        </div>
    </body>
</html>
