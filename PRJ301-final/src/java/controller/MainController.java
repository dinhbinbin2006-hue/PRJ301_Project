/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.CarDAO;
import dto.Car;
import java.util.List;
import dto.Customer;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import controller.Login;

/**
 *
 * @author Admin
 */
public class MainController extends HttpServlet {

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
        try ( PrintWriter out = response.getWriter()) {
            String url = "index.jsp";
            String action = request.getParameter("action");

            if (action == null) {
                action = "home";
            }

            switch (action) {

                case "home":
                    url = "index.jsp";
                    break;

                case "loginPage":
                    url = "login_page.jsp";
                    break;

                case "registerPage":
                    url = "register_page.jsp";
                    break;

                case "login":
                    url = "Login";
                    break;

                case "register":
                    url = "/dang-ky";
                    break;

                case "cancelBooking":
                    int bookingId = Integer.parseInt(request.getParameter("bookingId"));
                    new dao.BookingDAO().updateBookingStatus(bookingId, "CANCELLED");
                    response.sendRedirect("MainController?action=dashboard");
                    return;

                case "dashboard":
                    Customer user = (Customer) request.getSession().getAttribute("USER");
                    if (user == null) {
                        url = "login_page.jsp";
                    } else {
                        CarDAO carDAO = new CarDAO();
                        List<Car> carList = carDAO.getCarsByCustomerId(user.getCusId());
                        dao.ServicesDAO servicesDAO = new dao.ServicesDAO();
                        List<dto.Services> servicesList = servicesDAO.getAllServices();
                        int maxDays = dao.TierUtil.getMaxBookingDays(user.getMembershipLevel());
                        request.setAttribute("CURRENT_USER", user);
                        request.setAttribute("CAR_LIST", carList);
                        request.setAttribute("ServicesList", servicesList);
                        request.setAttribute("maxDays", maxDays);
                        try {
                            java.sql.Connection cn = dbutils.DBUtils.getConnection();
                            java.sql.PreparedStatement st = cn.prepareStatement(
                                    "SELECT bookingId, cusId, carId, serviceId, bookingDate, totalAmount, bookingStatus, createdAt FROM dbo.Bookings WHERE cusId = ?"
                            );
                            st.setInt(1, user.getCusId());
                            java.sql.ResultSet rs = st.executeQuery();
                            java.util.List<dto.Booking> myBookings = new java.util.ArrayList<>();
                            while (rs.next()) {
                                dto.Booking b = new dto.Booking();
                                b.setBookingId(rs.getInt("bookingId"));
                                b.setCusId(rs.getInt("cusId"));
                                b.setCarId(rs.getInt("carId"));
                                b.setServiceId(rs.getInt("serviceId"));
                                b.setBookingDate(rs.getTimestamp("bookingDate"));
                                b.setTotalAmount(rs.getDouble("totalAmount"));
                                b.setBookingStatus(rs.getString("bookingStatus"));
                                b.setCreatedAt(rs.getTimestamp("createdAt"));
                                myBookings.add(b);
                            }
                            request.setAttribute("BOOKING_LIST", myBookings);
                            cn.close();
                        } catch (Exception e) {
                            e.printStackTrace();
                        }
                        url = "customerDashboard_page.jsp";
                    }
                    break;

                case "addCar":
                    url = "AddCar";
                    break;
//////////////////////
                case "editCar":
                    String carIdStr = request.getParameter("id");
                    if (carIdStr != null && !carIdStr.isEmpty()) {
                        Car carData = new CarDAO().getCarById(Integer.parseInt(carIdStr));
                        request.setAttribute("CAR_DATA", carData);
                        url = "admin_edit_car.jsp";
                    } else {
                        url = "customerDashboard_page.jsp";
                    }
                    break;

                case "removeCar":
                    url = "RemoveCar";
                    break;

                case "logout":
                    url = "Logout";
                    break;

                default:
                    url = "index.jsp";
            }
            request.getRequestDispatcher(url).forward(request, response);
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
