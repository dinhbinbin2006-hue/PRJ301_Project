/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.BookingDAO;
import dao.CustomerDAO;
import dao.PaymentsDAO;
import dto.Booking;
import dto.Customer;
import dto.Payments;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author ADMIN
 */
@WebServlet(name = "PaymentService", urlPatterns = {"/PaymentService"})
public class PaymentService extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try ( PrintWriter out = response.getWriter()) {
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet PaymentService</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet PaymentService at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("USER") == null) {
            response.sendRedirect("MainController?action=home");
            return;
        }
        Customer cus = (Customer) session.getAttribute("USER");

        BookingDAO bookingDAO = new BookingDAO();
        List<Booking> bookingList = bookingDAO.getPendingBooking(cus.getCusId());
        request.setAttribute("bookingList", bookingList);
        request.setAttribute("points", cus.getPoints());
        request.getRequestDispatcher("payment_page.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("USER") == null) {
            response.sendRedirect("MainController?action=home");
            return;
        }
        Customer cus = (Customer) session.getAttribute("USER");
        int bookingId = Integer.parseInt(request.getParameter("bookingId"));
        String paymentMethod = request.getParameter("paymentMethod");

        CustomerDAO cusDAO = new CustomerDAO();
        BookingDAO bookingDAO = new BookingDAO();
        PaymentsDAO payDAO = new PaymentsDAO();
        Payments payment = new Payments();

        if ("Points".equals(paymentMethod)) {

            // BỔ SUNG DÒNG NÀY: Thực hiện trừ 300 điểm tiêu xài trong Database
            int redeemResult = cusDAO.redeemPoints(cus.getCusId(), 300, "Đổi 300 điểm thanh toán lịch đặt #" + bookingId);

            if (redeemResult >= 1) {
                payment.setBookingId(bookingId);
                payment.setAmount(0); // Vì đổi bằng điểm nên số tiền mặt cần trả bằng 0đ
                payment.setPaymentMethod("Redeem Points");
                payment.setPaymentDate(new java.sql.Date(new java.util.Date().getTime()));

                payDAO.createPayment(payment);
                bookingDAO.updateBookingStatus(bookingId, "PAID");
            } else {
                // Trường hợp tài khoản không đủ điểm (phòng hờ user cố tình bypass giao diện)
                request.setAttribute("BOOKING_ERROR", "Tài khoản của bạn không đủ điểm để đổi thưởng!");
                doGet(request, response);
                return;
            }

        } else if ("Banking".equals(paymentMethod)) {
            double price = bookingDAO.getBookingById(bookingId).getTotalAmount();
            cusDAO.addPoints(cus.getCusId(), price);
            cusDAO.checkAndUpdateTier(cus.getCusId());

            payment.setBookingId(bookingId);
            payment.setAmount(price);
            payment.setPaymentMethod("Banking");
            payment.setPaymentDate(new java.sql.Date(new java.util.Date().getTime()));

            payDAO.createPayment(payment);
            bookingDAO.updateBookingStatus(bookingId, "PAID");
        }

// FIX: nạp lại Customer từ DB và cập nhật session, để điểm hiển thị đúng ngay sau khi thanh toán
        Customer refreshedCus = cusDAO.getCustomerById(cus.getCusId());
        if (refreshedCus != null) {
            session.setAttribute("USER", refreshedCus);
        }

        response.sendRedirect("PaymentService");
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }

}
