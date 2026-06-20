/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.CarDAO;
import dao.ServicesDAO;
import dto.Car;
import dto.Customer;
import dto.Services;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author ADMIN
 */
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

        int maxDays = getMaxBookingDays(cus.getMembershipLevel());
        request.setAttribute("maxDays", maxDays);

        request.getRequestDispatcher("booking_page.jsp").forward(request, response);
    }

    private int getMaxBookingDays(String tier) {
        switch (tier) {
            case "Member":
                return 7;
            case "Silver":
                return 10;
            case "Gold":
                return 12;
            case "Platinum":
                return 14;
            default:
                return 7;
        }
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
            request.getRequestDispatcher("booking_page.jsp").forward(request, response);
            return;
        }
        
        ServicesDAO serviceDao = new ServicesDAO();
        Services service = serviceDao.getServicesById(serviceId);
        if (service == null || !service.isStatus()) {
            request.setAttribute("ERROR", "Dịch vụ không khả dụng!");
            request.getRequestDispatcher("booking_page.jsp").forward(request, response);
            return;
        }
        
        double total = service.getPrice();
    }


    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
