<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="dto.Customer"%>
<%@page import="dto.Car"%>
<%
    Customer admin = (Customer) session.getAttribute("USER");
    if (admin == null || !admin.getEmail().equals("admin@admin.com")) {
        response.sendRedirect("MainController?action=home");
        return;
    }
    Car car = (Car) request.getAttribute("CAR_DETAIL");
    int cusId = (int) request.getAttribute("CUS_ID");
    if (car == null) {
        response.sendRedirect("AdminController?action=listCustomers");
        return;
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Sửa thông tin xe</title>
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
                max-width:600px;
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
            }
            .card h2 {
                font-size:18px;
                color:#9ca3af;
                margin-bottom:20px;
                border-bottom:1px solid #1f2937;
                padding-bottom:12px;
            }
            label {
                display:block;
                color:#9ca3af;
                margin-bottom:6px;
                font-size:14px;
            }
            input, select {
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
            input:focus, select:focus {
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
        </style>
    </head>
    <body>
        <div class="container">
            <div class="top-bar">
                <h1>&#128663; Sửa thông tin xe</h1>
                <a href="AdminController?action=viewCustomer&cusId=<%= cusId%>" class="back-btn">&#8592; Quay lại</a>
            </div>

            <div class="card">
                <h2>&#9998; Chỉnh sửa</h2>
                <form action="AdminController" method="post">
                    <input type="hidden" name="action" value="updateCar">
                    <input type="hidden" name="carId" value="<%= car.getId()%>">
                    <input type="hidden" name="cusId" value="<%= cusId%>">

                    <label>Biển số (không thể sửa)</label>
                    <input type="text" value="<%= car.getLicensePlate()%>" disabled>

                    <label>Hãng xe</label>
                    <input type="text" name="brand" value="<%= car.getBrand() != null ? car.getBrand() : ""%>">

                    <label>Model</label>
                    <input type="text" name="model" value="<%= car.getModel() != null ? car.getModel() : ""%>">

                    <label>Màu sắc</label>
                    <input type="text" name="color" value="<%= car.getColor() != null ? car.getColor() : ""%>">

                    <label>Loại xe</label>
                    <select name="type">
                        <option value="Sedan" <%= "Sedan".equals(car.getType()) ? "selected" : ""%>>Sedan</option>
                        <option value="SUV" <%= "SUV".equals(car.getType()) ? "selected" : ""%>>SUV</option>
                        <option value="Truck" <%= "Truck".equals(car.getType()) ? "selected" : ""%>>Truck</option>
                        <option value="Hatchback" <%= "Hatchback".equals(car.getType()) ? "selected" : ""%>>Hatchback</option>
                        <option value="Convertible" <%= "Convertible".equals(car.getType()) ? "selected" : ""%>>Convertible</option>
                    </select>

                    <button type="submit" class="btn-save">✔ Lưu thay đổi</button>
                </form>
            </div>
        </div>
    </body>
</html>