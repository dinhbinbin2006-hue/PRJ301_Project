<%-- 
    Document   : customerDashboard_page
    Created on : May 28, 2026, 7:50:11 PM
    Author     : HP
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="dto.Customer"%>
<%@page import="dto.Car"%>
<%@page import="java.util.List"%>

<%
    Customer cus = (Customer) request.getAttribute("CURRENT_USER");
    List<Car> carList = (List<Car>) request.getAttribute("CAR_LIST");

    if (cus == null) {
        response.sendRedirect("index.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
    <head>

        <meta http-equiv="Content-Type"
              content="text/html; charset=UTF-8">

        <title>Dashboard</title>

        <style>

            *{
                margin:0;
                padding:0;
                box-sizing:border-box;
                font-family:'Segoe UI',sans-serif;
            }

            body{
                background:#0f172a;
                min-height:100vh;
                padding:40px;
            }

            .dashboard-container{
                max-width:900px;
                margin:auto;
                background:#111827;
                padding:40px;
                border-radius:15px;
                box-shadow:0 0 20px rgba(0,0,0,.3);
            }

            .top-bar{
                gap:10px;
                display:flex;
                align-items:center;
                margin-bottom:30px;
            }

            .title{
                color:white;
                font-size:32px;
                font-weight:600;
                margin-right: auto;
            }

            .logout-btn{
                background:#dc2626;
                color:white;
                padding:12px 20px;
                border-radius:10px;
                text-decoration:none;
            }

            .home-btn {
                background:#374151;
                color:white;
                padding:12px 20px;
                border-radius:10px;
                text-decoration:none;
                border:none;
                cursor:pointer;
                font-size:inherit;
            }

            .card{
                background:#1f2937;
                padding:25px;
                border-radius:12px;
                margin-bottom:20px;
            }

            .card h3{
                color:#9ca3af;
                margin-bottom:10px;
            }

            .card p{
                color:white;
                font-size:20px;
            }

            .membership{
                background:#1e3a8a;
            }

            .reward{
                background:#14532d;
            }
            table{
                width:100%;
                border-collapse:collapse;
                margin-top:10px;
                background:#1f2937;
                border-radius:12px;
                overflow:hidden;
            }
            th, td{
                padding:12px;
                text-align:left;
                color:white;
                border-bottom:1px solid #374151;
            }
            th{
                background:#0f172a;
                color:#60a5fa;
            }
            .modal{
                position:fixed;
                top:0;
                left:0;
                width:100%;
                height:100%;
                background:rgba(0,0,0,.7);
                display:none;
                justify-content:center;
                align-items:center;
            }

            .modal-content{
                background:#111827;
                padding:40px;
                border-radius:20px;
                text-align:center;
                width:420px;
            }

            .icon{
                width:80px;
                height:80px;
                border:4px solid #fcd9b6;
                border-radius:50%;
                color:#fcd9b6;
                font-size:50px;
                display:flex;
                justify-content:center;
                align-items:center;
                margin:auto;
                margin-bottom:20px;
            }

            .modal-content h2{
                color:white;
                margin-bottom:15px;
            }

            .modal-content p{
                color:#9ca3af;
                margin-bottom:30px;
            }

            .modal-buttons{
                display:flex;
                justify-content:center;
                gap:15px;
            }

            .confirm-btn{
                background:#d9ff00;
                color:black;
                padding:14px 20px;
                border-radius:10px;
                text-decoration:none;
                font-weight:600;
            }

            .cancel-btn{
                background:#94a3b8;
                color:white;
                border:none;
                padding:14px 20px;
                border-radius:10px;
                cursor:pointer;
            }
        </style>

    </head>
    <!-- Logout Modal -->

    <div id="logoutModal" class="modal">

        <div class="modal-content">

            <div class="icon">!</div>

            <h2>Thông báo đăng xuất!</h2>

            <p>Bạn có muốn thực hiện hành động?</p>

            <div class="modal-buttons">

                <a href="MainController?action=logout"
                   class="confirm-btn">
                    Đăng xuất ngay
                </a>

                <button class="cancel-btn"
                        onclick="closeLogoutModal()">
                    Cancel
                </button>

            </div>

        </div>

    </div>

    <script>

        function openLogoutModal() {
            document.getElementById("logoutModal").style.display = "flex";
        }

        function closeLogoutModal() {
            document.getElementById("logoutModal").style.display = "none";
        }
//Dùng thẻ <a> thay vì <button> vì nút này chỉ điều hướng thẳng về trang chủ, không cần modal xác nhận như Logout.
    </script>
    <body>

        <div class="dashboard-container">

            <div class="top-bar">

                <h1 class="title">
                    Customer Dashboard
                </h1>

                <a href="MainController?action=home" class="home-btn">
                     Trang chủ
                </a>

                <button class ="logout-btn"
                        onclick="openLogoutModal()">
                    Logout
                </button>

            </div>

            <div class="card">
                <h3>Họ tên</h3>
                <p><%= cus.getFullname()%></p>
            </div>
            <div class="card">
                <h3>Ngày sinh</h3>
                <p><%= cus.getDateOfBirth()%></p>
            </div>

            <div class="card">
                <h3>Giới tính</h3>
                <p><%= cus.getGender()%></p>
            </div>

            <div class="card">
                <h3>Email</h3>
                <p><%= cus.getEmail()%></p>
            </div>

            <div class="card">
                <h3>Phone</h3>
                <p><%= cus.getPhone()%></p>
            </div>

            <div class="card membership">
                <h3>Hạng thành viên</h3>
                <p><%= cus.getMembershipLevel()%></p>
            </div>

            <div class="card reward">
                <h3>Điểm tích lũy</h3>
                <p><%= cus.getPoints()%> Points</p>
            </div>

            <div class="card">
                <h3>Danh sách xe của bạn</h3>
                <table>
                    <thead>
                        <tr><th>Biển số</th><th>Hãng</th><th>Model</th><th>Màu</th><th>Loại</th></tr>
                    </thead>
                    <tbody>
                        <%
                            if (carList != null && !carList.isEmpty()) {
                                for (Car car : carList) {
                        %>
                        <tr>
                            <td><%= car.getLicensePlate() != null ? car.getLicensePlate() : ""%></td>
                            <td><%= car.getBrand() != null ? car.getBrand() : ""%></td>
                            <td><%= car.getModel() != null ? car.getModel() : ""%></td>
                            <td><%= car.getColor() != null ? car.getColor() : ""%></td>
                            <td><%= car.getType() != null ? car.getType() : ""%></td>
                        </tr>
                        <%
                            }
                        } else {
                        %>
                        <tr><td colspan="6">Bạn chưa đăng ký xe nào.</td></tr>
                        <% }%>
                    </tbody>
                </table>
            </div>

        </div>

    </body>
</html>
