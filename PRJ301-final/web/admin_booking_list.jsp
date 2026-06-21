<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="dto.Customer"%>
<%@page import="dto.Booking"%>
<%@page import="dto.Car"%>
<%@page import="dto.Services"%>
<%@page import="dao.CustomerDAO"%>
<%@page import="dao.CarDAO"%>
<%@page import="dao.ServicesDAO"%>
<%@page import="java.util.List"%>
<%
    Customer admin = (Customer) session.getAttribute("USER");
    if (admin == null || !admin.getEmail().equals("admin@admin.com")) {
        response.sendRedirect("MainController?action=home");
        return;
    }
    List<Booking> bookingList = (List<Booking>) request.getAttribute("BOOKING_LIST");
    String currentPage = "bookings";
    CustomerDAO customerDAO = new CustomerDAO();
    CarDAO carDAO = new CarDAO();
    ServicesDAO servicesDAO = new ServicesDAO();
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Admin - Quản lý lịch đặt</title>
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
            h1 {
                font-size:26px;
                color:#60a5fa;
                margin-bottom:6px;
            }
            .subtitle {
                color:#9ca3af;
                font-size:14px;
                margin-bottom:28px;
            }
            .table-wrap {
                background:#111827;
                border:1px solid #1f2937;
                border-radius:14px;
                overflow:hidden;
            }
            table {
                width:100%;
                border-collapse:collapse;
            }
            thead tr {
                background:#1e293b;
            }
            th {
                padding:13px 16px;
                text-align:left;
                font-size:11px;
                font-weight:700;
                letter-spacing:.8px;
                text-transform:uppercase;
                color:#64748b;
            }
            td {
                padding:13px 16px;
                font-size:14px;
                border-top:1px solid #1f2937;
            }
            tr:hover td {
                background:#1e293b;
            }
            .status-badge {
                display:inline-block;
                padding:3px 10px;
                border-radius:100px;
                font-size:11px;
                font-weight:700;
            }
            .status-pending {
                background:rgba(245,158,11,.12);
                color:#f59e0b;
                border:1px solid rgba(245,158,11,.25);
            }
            .status-done {
                background:rgba(16,185,129,.12);
                color:#10b981;
                border:1px solid rgba(16,185,129,.25);
            }
            .status-cancelled {
                background:rgba(239,68,68,.12);
                color:#ef4444;
                border:1px solid rgba(239,68,68,.25);
            }
            .empty {
                text-align:center;
                padding:40px;
                color:#64748b;
            }
        </style>
    </head>
    <body>
        <%@ include file="includes/admin_sidebar.jspf" %>
        <div class="container">
            <h1>📋 Quản lý lịch đặt</h1>
            <div class="subtitle">Danh sách tất cả lịch đặt xe</div>

            <div class="table-wrap">
                <table>
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>Khách hàng</th>
                            <th>Xe</th>
                            <th>Dịch vụ</th>
                            <th>Ngày đặt</th>
                            <th>Tổng tiền</th>
                            <th>Trạng thái</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (bookingList != null && !bookingList.isEmpty()) {
                                for (Booking b : bookingList) {
                                    Customer cus = customerDAO.getCustomerById(b.getCusId());
                                    Car car = carDAO.getCarById(b.getCarId());
                                    Services svc = servicesDAO.getServicesById(b.getServiceId());
                        %>
                        <tr>
                            <td><%= b.getBookingId()%></td>
                            <td>
                                <strong><%= cus != null ? cus.getFullname() : "N/A"%></strong><br>
                                <span style="font-size:12px;color:#64748b;"><%= cus != null ? cus.getEmail() : ""%></span>
                            </td>
                            <td>
                                <strong><%= car != null ? car.getLicensePlate() : "N/A"%></strong><br>
                                <span style="font-size:12px;color:#64748b;"><%= car != null ? car.getBrand() + " " + car.getModel() : ""%></span>
                            </td>
                            <td><%= svc != null ? svc.getServiceName() : "N/A"%></td>
                            <td><%= b.getBookingDate()%></td>
                            <td><%= String.format("%,.0f", b.getTotalAmount())%>đ</td>
                            <td>
                                <span class="status-badge <%= "PENDING".equals(b.getBookingStatus()) ? "status-pending" : "DONE".equals(b.getBookingStatus()) ? "status-done" : "status-cancelled"%>">
                                    <%= b.getBookingStatus()%>
                                </span>
                            </td>
                        </tr>
                        <% }
                        } else { %>
                        <tr><td colspan="7" class="empty">📋 Chưa có lịch đặt nào.</td></tr>
                        <% }%>
                    </tbody>
                </table>
            </div>
        </div>
    </body>
</html>
