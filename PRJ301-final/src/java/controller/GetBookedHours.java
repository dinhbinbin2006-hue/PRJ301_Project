/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.BookingDAO;
import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDate;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Trả về (JSON) danh sách các giờ (0-23) trong ngày được chỉ định mà đã có
 * người đặt lịch (toàn tiệm chỉ phục vụ 1 xe/giờ), để giao diện disable
 * những khung giờ đó khi khách chọn ngày đặt lịch.
 *
 * Request: GET GetBookedHours?date=yyyy-MM-dd
 * Response: {"bookedHours":[8,9,14]}
 *
 * @author HP
 */
@WebServlet(name = "GetBookedHours", urlPatterns = {"/GetBookedHours"})

public class GetBookedHours extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("USER") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            try (PrintWriter out = response.getWriter()) {
                out.print("{\"error\":\"unauthorized\"}");
            }
            return;
        }

        String dateStr = request.getParameter("date");
        LocalDate date;
        try {
            date = LocalDate.parse(dateStr);
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            try (PrintWriter out = response.getWriter()) {
                out.print("{\"error\":\"invalid date\"}");
            }
            return;
        }

        BookingDAO bookingDAO = new BookingDAO();
        List<Integer> bookedHours = bookingDAO.getBookedHours(date);

        StringBuilder sb = new StringBuilder();
        sb.append("{\"bookedHours\":[");
        for (int i = 0; i < bookedHours.size(); i++) {
            if (i > 0) {
                sb.append(",");
            }
            sb.append(bookedHours.get(i));
        }
        sb.append("]}");

        try (PrintWriter out = response.getWriter()) {
            out.print(sb.toString());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

}
