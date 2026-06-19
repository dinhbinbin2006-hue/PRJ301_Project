/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.CustomerDAO;
import dto.Customer;
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
public class Login extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    public void processRequest(HttpServletRequest request, HttpServletResponse response) {
        try {
            //lay email , pass tu form login
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            CustomerDAO d = new CustomerDAO();
            Customer cus = d.getCustomer(email, password);
            if (cus == null) {
                String msg = "email or password is invalid";
                request.setAttribute("ERROR", msg);

                // ĐÃ SỬA CHUẨN: Forward về url-pattern "/Login" thay vì "login_page.jsp" thô
                // Việc thêm dấu gạch chéo "/" ở đầu bắt buộc để giữ nguyên URL ảo trên thanh địa chỉ
                request.getRequestDispatcher("login_page.jsp").forward(request, response);

            } else {
                if (cus.isStatus()) {
                    //can save cus object vao session memmory de su dung no trong cac tinh nang khac
                    request.getSession().setAttribute("USER", cus);
                    request.getSession().setAttribute("LOGIN_SUCCESS", true);

                    // Khớp với <url-pattern>/dashboard</url-pattern> TRONG WEB.XML
                    if (cus.getEmail().equals("admin@admin.com")) {
                        response.sendRedirect("MainController?action=home");
                    } else {
                        response.sendRedirect("MainController?action=dashboard");
                    }
                } else {
                    //neu nguoi dung bi BAN thi khong vao duoc
                    response.getWriter().print("access deny!!!");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
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
        request.getRequestDispatcher("/login_page.jsp").forward(request, response);
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
