/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

import dao.CarDAO;
import dao.CustomerDAO;
import dto.Car;
import dto.Customer;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author Admin
 */
@WebServlet(name = "AdminController", urlPatterns = {"/AdminController"})
public class AdminController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        String action = request.getParameter("action");
        if (action == null) {
            action = "listCustomers";
        }

        switch (action) {
            case "listCustomers": {
                List<Customer> customerList = new CustomerDAO().getAllCustomers();
                request.setAttribute("CUSTOMER_LIST", customerList);
                request.getRequestDispatcher("admin_customer_list.jsp").forward(request, response);
                break;
            }
            case "listCars": {
                List<Car> carList = new CarDAO().getAllCarsAdmin();
                request.setAttribute("CAR_LIST", carList);
                request.getRequestDispatcher("admin_car_list.jsp").forward(request, response);
                break;
            }
            case "deleteCustomer": {
                int cusId = Integer.parseInt(request.getParameter("cusId"));
                new CustomerDAO().deleteCustomer(cusId);
                response.sendRedirect("AdminController?action=listCustomers");
                break;
            }
            case "deleteCar": {
                int carId = Integer.parseInt(request.getParameter("id"));
                new CarDAO().deleteCar(carId);
                response.sendRedirect("AdminController?action=listCars");
                break;
            }
            default:
                request.getRequestDispatcher("admin_customer_list.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }
}