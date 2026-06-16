/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.CarDAO;
import dao.CustomerDAO;
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
@WebServlet(name = "EditCustomer", urlPatterns = {"/EditCustomer"})
public class EditCustomer extends HttpServlet {

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
        // B1
        //:Lấy customer hiện tại từ session
        HttpSession session = request.getSession(false);
        Customer c = (Customer) session.getAttribute("CUSTOMER");

        // B2: Đọc thông tin mới từ form
        String fullname = request.getParameter("fullname");
        String gender = request.getParameter("gender");
        String dobStr = request.getParameter("dateOfBirth");
        String phone = request.getParameter("phone");

        // B3: Cập nhật thông tin mới vào object customer
        c.setFullname(fullname.trim());
        c.setGender(gender);
        c.setPhone(phone.trim());

        // B4: Parse ngày sinh
        if (dobStr != null && !dobStr.isEmpty()) {
            try {
                java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd");
                java.util.Date dob = sdf.parse(dobStr);
                c.setDateOfBirth(new java.sql.Date(dob.getTime()));
            } catch (Exception e) {
                c.setDateOfBirth(null);
            }
        }

        // B5: Gọi DAO để UPDATE xuống DB
        int result = new CustomerDAO().updateCustomer(c);

        if (result >= 1) {
            // B6a: Thành công → cập nhật lại session với thông tin mới
            // quan trọng: phải set lại session không thì dashboard vẫn hiển thị thông tin cũ
            session.setAttribute("CUSTOMER", c);
            response.sendRedirect("MainController?action=customerDashboard");
        } else {
            // B6b: Thất bại → báo lỗi, load lại trang edit
            request.setAttribute("ERROR", "Cập nhật thất bại, vui lòng thử lại!");
            request.getRequestDispatcher("edit_customer.jsp").forward(request, response);
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
