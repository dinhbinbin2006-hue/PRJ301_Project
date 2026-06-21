package controller;

import dao.ServicesDAO;
import dto.Services;
import dao.BookingDAO;
import dao.CarDAO;
import dto.Booking;
import dto.Car;
import dto.Customer;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class CustomerDashboard extends HttpServlet {

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

        BookingDAO bookingDAO = new BookingDAO();
        List<Booking> allBookings = bookingDAO.getAllBooking();
        List<Booking> bookingList = new java.util.ArrayList<>();
        for (Booking b : allBookings) {
            if (b.getCusId() == cus.getCusId()) {
                bookingList.add(b);
            }
        }

        ServicesDAO servicesDAO = new ServicesDAO();
        List<Services> servicesList = servicesDAO.getAllServices();
        
        request.setAttribute("CURRENT_USER", cus);
        request.setAttribute("CAR_LIST", carList);
        request.setAttribute("BOOKING_LIST", bookingList);
        request.setAttribute("ServicesList", servicesList);
        request.getRequestDispatcher("customerDashboard_page.jsp").forward(request, response);
    }
}
