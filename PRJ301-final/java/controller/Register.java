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

/**
 *
 * @author HP
 */
public class Register extends HttpServlet {

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
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet Register</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet Register at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
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
        request.getRequestDispatcher("register_page.jsp").forward(request, response);
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

        //lấy thông tin khách hàng
        String fullname = request.getParameter("fullname");
        String genderStr = request.getParameter("gender");
        String dobStr = request.getParameter("dateOfBirth");
        String phoneStr = request.getParameter("phone");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        
        // lấy thông tin xe khách hàng
        String licensePlate = request.getParameter("licensePlate");
        String brand = request.getParameter("vehicleBrand");
        String model = request.getParameter("model");
        String vehicleType = request.getParameter("vehicleType");
        String color = request.getParameter("vehicleColor");

        //add khách hàng vào database
        Customer c = new Customer();
        c.setFullname(fullname.trim()); //setname

        c.setGender(genderStr);  //setgender

        //set date of birth
        if (dobStr != null && !dobStr.isEmpty()) {
            try {
                java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd");
                java.util.Date dob = sdf.parse(dobStr);
                c.setDateOfBirth(new java.sql.Date(dob.getTime()));
            } catch (Exception e) {
                c.setDateOfBirth(null);
            }
        }

        //set phone
        
        c.setPhone(phoneStr.trim());

        //set email
        c.setEmail(email);

        //setpasswork
        c.setPassword(password);

        //mặc định level=1 point=0 status=true date=date tạo
        c.setCreatedAt(new java.sql.Date(new java.util.Date().getTime()));
        c.setMembershipLevel("1");
        c.setPoints(0);
        c.setStatus(true);

        CustomerDAO d = new CustomerDAO();
        Customer found = d.getCustomer(email);//getCustomer = email(yes này có code của cô sửa lại là đc)

        if (found == null) {
            // Email chưa tồn tại → tiến hành đăng ký
            int result = d.createCustomer(c);
            System.out.println("Result = " + result);
            if (result >= 1) {
                // Lấy cusId vừa tạo để gán cho Car
                Customer newCustomer = d.getCustomer(email);
                int newCusId = newCustomer.getCusId();

                // Tạo Car nếu có nhập biển số
                if (licensePlate != null && !licensePlate.trim().isEmpty()) {
                    Car car = new Car();
                    car.setCusid(newCusId);
                    car.setLicensePlate(licensePlate.trim());
                    car.setBrand(brand.trim());
                    car.setType(vehicleType.trim());
                    car.setModel(model.trim());
                    car.setColor(color);
                    car.setCreatedDate(new java.sql.Date(new java.util.Date().getTime()));
                    car.setStatus(true);

                    CarDAO carDAO = new CarDAO();
                    carDAO.createCar(car);
                }

                response.sendRedirect(
                        "MainController?action=loginPage"
                );

            } else {
                response.getWriter().print("comming soon");
            }

        } else {
            // Email đã tồn tại → báo lỗi
            String msg = "duplicate Email";
            request.setAttribute("ERROR", msg);
            request.getRequestDispatcher("register_page.jsp").forward(request, response);
        }

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
