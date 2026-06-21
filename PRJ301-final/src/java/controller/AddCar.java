/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.CarDAO;
import dto.Car;
import dto.Customer;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author HP
 */
@WebServlet(name = "AddCar", urlPatterns = {"/AddCar"})
public class AddCar extends HttpServlet {

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
        // B1: Lấy cusId từ session
        HttpSession session = request.getSession(false);
        Customer c = (Customer) session.getAttribute("USER");
        int cusId = c.getCusId();

        // B2: Đọc thông tin xe từ form
        String licensePlate = request.getParameter("licensePlate");
        String brand = request.getParameter("brand");
        String model = request.getParameter("model");
        String color = request.getParameter("color");
        String type = request.getParameter("type");

        // B3: Kiểm tra biển số trùng
        CarDAO carDAO = new CarDAO();
        if (carDAO.getCarByLicensePlate(licensePlate.trim()) != null) {
            request.setAttribute("ERROR", "Biển số xe đã tồn tại!");
            request.getRequestDispatcher("MainController?action=dashboard").forward(request, response);
            return;
        }

        // B4: Tạo đối tượng Car
        Car car = new Car();
        car.setCusid(cusId);
        car.setLicensePlate(licensePlate.trim());
        car.setBrand(brand.trim());
        car.setModel(model.trim());
        car.setColor(color.trim());
        car.setType(type.trim());
        car.setCreatedDate(new java.sql.Date(new java.util.Date().getTime()));
        car.setStatus(true);

        // B5: Gọi DAO insert xuống DB
        int result = carDAO.createCar(car);

        if (result >= 1) {
            response.sendRedirect("MainController?action=dashboard");
        } else {
            request.setAttribute("ERROR", "Thêm xe thất bại, vui lòng thử lại!");
            request.getRequestDispatcher("MainController?action=dashboard").forward(request, response);
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
