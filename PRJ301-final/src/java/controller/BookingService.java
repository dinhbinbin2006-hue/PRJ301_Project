/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;
import dao.CustomerDAO;
import dao.BookingDAO;
import dao.CarDAO;
import dao.ServicesDAO;
import dao.TierDAO;
import dto.Booking;
import dto.Car;
import dto.Customer;
import dto.Services;
import dto.Tier;
import java.io.IOException;
import java.sql.Date;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;
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
@WebServlet(name = "BookingService", urlPatterns = {"/BookingService"})
public class BookingService extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("USER") == null) {
            response.sendRedirect(
                    "MainController?action=home"
            );
            return;
        }
        Customer cus = (Customer) session.getAttribute("USER");

        CarDAO carDAO = new CarDAO();
        List<Car> carList = carDAO.getAllCars(cus.getCusId());
        request.setAttribute("CAR_LIST", carList);

        ServicesDAO serDAO = new ServicesDAO();
        List<Services> serviceList = serDAO.getAllServices();
        request.setAttribute("ServicesList", serviceList);

        String tierId = cus.getMembershipLevel();

        TierDAO tierDAO = new TierDAO();
        Tier tier = tierDAO.getTierById(tierId);
        if (tier == null) {
            tier = new Tier();
            tier.setBookingPriorityDays(7);
        }
        int maxDays = tier.getBookingPriorityDays();
        request.setAttribute("maxDays", maxDays);

        response.sendRedirect("PaymentService");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("USER") == null) {
            response.sendRedirect(
                    "MainController?action=home"
            );
            return;
        }
        Customer cus = (Customer) session.getAttribute("USER");
        int carId = Integer.parseInt(request.getParameter("carId"));
        int serviceId = Integer.parseInt(request.getParameter("serviceId"));
        String bookingDateStr = request.getParameter("bookingDate");

        CarDAO carDao = new CarDAO();
        Car car = carDao.getCarById(carId);
        if (car == null || car.getCusid() != cus.getCusId()) {
            request.setAttribute("ERROR", "Xe không hợp lệ!");
            response.sendRedirect("PaymentService");
            return;
        }

        ServicesDAO serviceDao = new ServicesDAO();
        Services service = serviceDao.getServicesById(serviceId);
        if (service == null || !service.isStatus()) {
            request.setAttribute("ERROR", "Dịch vụ không khả dụng!");
            response.sendRedirect("PaymentService");
            return;
        }

        String tierId = cus.getMembershipLevel();

        TierDAO tierDAO = new TierDAO();
        Tier tier = tierDAO.getTierById(tierId);
        if (tier == null) {
            tier = new Tier();
            tier.setBookingPriorityDays(7);
        }
        int maxDays = tier.getBookingPriorityDays();

        LocalDateTime bookingDateTime = LocalDateTime.parse(bookingDateStr);
        LocalDate bookingDate = bookingDateTime.toLocalDate();

        LocalDate today = LocalDate.now();

        if (bookingDate.isBefore(today)) {
            request.setAttribute("ERROR", "Ngày đặt không được trước hơn ngày hiện tại.");
            response.sendRedirect("PaymentService");
            return;
        }

        long daysBetween = ChronoUnit.DAYS.between(today, bookingDate);

        if (daysBetween > maxDays) {
            request.setAttribute("ERROR", "Bạn chỉ có thể đặt trước tối đa " + maxDays + " ngày. "
                    + "Ngày bạn chọn cách hiện tại " + daysBetween + " ngày.");
            response.sendRedirect("PaymentService");
            return;
        }

        int duration = service.getDurationMinutes();

        BookingDAO bookingDAO = new BookingDAO();
        if (bookingDAO.hasConflict(carId, bookingDateTime, duration)) {
            request.setAttribute("BOOKING_ERROR", "Khung giờ này đã có người đặt. Vui lòng chọn giờ khác.");
            response.sendRedirect("dashboard");
            return;
        }

        double total = service.getPrice();
        request.setAttribute("total", total);
        Timestamp bookingTimestamp = Timestamp.valueOf(bookingDateTime);

        Booking booking = new Booking();
        booking.setCusId(cus.getCusId());
        booking.setCarId(carId);
        booking.setServiceId(serviceId);
        booking.setBookingDate(bookingTimestamp);
        booking.setTotalAmount(total);
        booking.setBookingStatus("PENDING");
        booking.setCreatedAt(new Timestamp(System.currentTimeMillis()));

        BookingDAO bookingDao = new BookingDAO();
        bookingDao.createBooking(booking);
        response.sendRedirect("PaymentService");
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
