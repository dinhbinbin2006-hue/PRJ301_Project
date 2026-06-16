/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.CarDAO;
import dto.Car;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author HP
 */
@WebServlet(name = "EditCar", urlPatterns = {"/EditCar"})
public class EditCar extends HttpServlet {

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
        // B1: Đọc id xe từ form (hidden input)
        int id = Integer.parseInt(request.getParameter("id"));

        // B2: Đọc thông tin mới người dùng vừa nhập
        String brand = request.getParameter("brand");
        String model = request.getParameter("model");
        String color = request.getParameter("color");
        String type = request.getParameter("type");

        // B3: Tạo đối tượng Car và nạp dữ liệu mới vào
        Car car = new Car();
        car.setId(id);
        car.setBrand(brand.trim());
        car.setModel(model.trim());
        car.setColor(color.trim());
        car.setType(type.trim());

        // B4: Gọi DAO để UPDATE xuống DB
        int result = new CarDAO().updateCar(car);

        if (result >= 1) {
            // B5a: Thành công → quay về dashboard
            response.sendRedirect("MainController?action=customerDashboard");
        } else {
            // B5b: Thất bại → báo lỗi, load lại trang edit với dữ liệu cũ
            Car carData = new CarDAO().getCarById(id);
            request.setAttribute("CAR_DATA", carData);
            request.setAttribute("ERROR", "Cập nhật thất bại, vui lòng thử lại!");
            request.getRequestDispatcher("edit_car.jsp").forward(request, response);
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
