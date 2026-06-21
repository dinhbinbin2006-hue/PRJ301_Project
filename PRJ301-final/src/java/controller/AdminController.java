package controller;

import java.util.List;
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

@WebServlet(name = "AdminController", urlPatterns = {"/AdminController"})
public class AdminController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); //bảo vệ trình duyệt ko lưu cache trang này. muon61 xem phải gọi server
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0); // đánh dấu trang đđa hết hạn

        // Bảo vệ: chỉ admin mới vào được
        Customer admin = (Customer) request.getSession().getAttribute("USER");
        if (admin == null || !admin.getEmail().equals("admin@admin.com")) {
            response.sendRedirect("MainController?action=home");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) {
            action = "listCustomers";
        }

        switch (action) {
//////////////////////////////////
            case "dashboard": {
                List<Customer> allCustomers = new CustomerDAO().getAllCustomers();
                List<Car> allCars = new CarDAO().getAllCarsAdmin();
                int totalCustomers = allCustomers != null ? allCustomers.size() : 0;
                int activeCustomers = 0;
                if (allCustomers != null) {
                    for (Customer c : allCustomers) {
                        if (c.isStatus()) {
                            activeCustomers++;
                        }
                    }
                }
                int totalCars = allCars != null ? allCars.size() : 0;
                request.setAttribute("TOTAL_CUSTOMERS", totalCustomers);
                request.setAttribute("ACTIVE_CUSTOMERS", activeCustomers);
                request.setAttribute("INACTIVE_CUSTOMERS", totalCustomers - activeCustomers);
                request.setAttribute("TOTAL_CARS", totalCars);

                List<dto.Booking> allBookings = new dao.BookingDAO().getAllBooking();
                int totalBookings = allBookings != null ? allBookings.size() : 0;
                double totalRevenue = 0;
                if (allBookings != null) {
                    for (dto.Booking b : allBookings) {
                        totalRevenue += b.getTotalAmount();
                    }
                }
                request.setAttribute("TOTAL_BOOKINGS", totalBookings);
                request.setAttribute("TOTAL_REVENUE", totalRevenue);

                request.getRequestDispatcher("admin_dashboard.jsp").forward(request, response);
                break;
            }
            case "listCustomers": {
                List<Customer> customerList = new CustomerDAO().getAllCustomers();
                request.setAttribute("CUSTOMER_LIST", customerList);
                request.getRequestDispatcher("admin_customer_list.jsp").forward(request, response);
                break;
            }
            ////////////////
            case "viewCustomer": {
                int cusId
                        = Integer.parseInt(
                                request.getParameter("cusId"));
                Customer cus
                        = new CustomerDAO()
                                .getCustomerById(cusId);
                List<Car> cars
                        = new CarDAO()
                                .getCarsByCustomerId(cusId);
                request.setAttribute(
                        "CUSTOMER_DETAIL",
                        cus);
                request.setAttribute(
                        "CUSTOMER_CARS",
                        cars);
                request.getRequestDispatcher(
                        "admin_customer_detail.jsp")
                        .forward(request, response);
                break;
            }
            ///////////////
            case "updateCustomer": {
                int cusId = Integer.parseInt(request.getParameter("cusId"));
                Customer cus = new CustomerDAO().getCustomerById(cusId);
                if (cus != null) {
                    String fullname = request.getParameter("fullname");
                    String gender = request.getParameter("gender");
                    String phone = request.getParameter("phone");
                    String dobStr = request.getParameter("dateOfBirth");
                    String email = request.getParameter("email");
                    String password = request.getParameter("password");
                    String tierId = request.getParameter("tierId");
                    String pointsStr = request.getParameter("points");
                    String totalPointsStr = request.getParameter("totalPoints");

                    cus.setFullname(fullname != null ? fullname.trim() : cus.getFullname());
                    cus.setGender(gender);
                    ///////////
                    cus.setPhone(phone != null ? phone.trim() : cus.getPhone());
                    cus.setEmail(email);
                    cus.setPassword(password);
                    cus.setMembershipLevel(tierId);

                    try {
                        cus.setPoints(Integer.parseInt(pointsStr));
                    } catch (Exception e) {
                    }
                    try {
                        cus.setTotalPoints(Integer.parseInt(totalPointsStr));
                    } catch (Exception e) {
                    }
                    if (dobStr != null && !dobStr.isEmpty()) {
                        try {
                            java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd");
                            java.util.Date dob = sdf.parse(dobStr);
                            cus.setDateOfBirth(new java.sql.Date(dob.getTime()));
                        } catch (Exception e) {
                            /* giữ nguyên nếu lỗi */ }
                    }

                    int result = new CustomerDAO().updateCustomer(cus);
                    // Load lại để hiển thị
                    cus = new CustomerDAO().getCustomerById(cusId);
                    request.setAttribute("CUSTOMER_DETAIL", cus);
                    ////////////// load lai danh sach xe
                    List<Car> cars = new CarDAO().getCarsByCustomerId(cusId);
                    request.setAttribute("CUSTOMER_CARS", cars);
                    if (result >= 1) {
                        request.setAttribute("SUCCESS", "Cập nhật thông tin thành công!");
                    } else {
                        request.setAttribute("ERROR", "Cập nhật thất bại, vui lòng thử lại!");
                    }
                    request.getRequestDispatcher("admin_customer_detail.jsp").forward(request, response);
                } else {
                    response.sendRedirect("AdminController?action=listCustomers");
                }
                break;
            }
            case "deleteCustomer": {
                int cusId = Integer.parseInt(request.getParameter("cusId"));
                new CustomerDAO().deleteCustomer(cusId);
                response.sendRedirect("AdminController?action=listCustomers");
                break;
            }
            case "listCars": {
                List<Car> carList = new CarDAO().getAllCarsAdmin();
                request.setAttribute("CAR_LIST", carList);
                request.getRequestDispatcher("admin_car_list.jsp").forward(request, response);
                break;
            }

            case "listBookings": {
                List<dto.Booking> bookingList = new dao.BookingDAO().getAllBooking();
                request.setAttribute("BOOKING_LIST", bookingList);
                request.getRequestDispatcher("admin_booking_list.jsp").forward(request, response);
                break;
            }

            // thêm 2 case edit và update car
            case "editCar": {
                int carId = Integer.parseInt(request.getParameter("carId"));
                int cusId = Integer.parseInt(request.getParameter("cusId"));
                Car car = new CarDAO().getCarById(carId);
                request.setAttribute("CAR_DETAIL", car);
                request.setAttribute("CUS_ID", cusId);
                request.getRequestDispatcher("admin_edit_car.jsp").forward(request, response);
                break;
            }
            case "updateCar": {
                int carId = Integer.parseInt(request.getParameter("carId"));
                int cusId = Integer.parseInt(request.getParameter("cusId"));
                Car car = new CarDAO().getCarById(carId);
                car.setBrand(request.getParameter("brand"));
                car.setModel(request.getParameter("model"));
                car.setColor(request.getParameter("color"));
                car.setType(request.getParameter("type"));
                int result = new CarDAO().updateCar(car);
                response.sendRedirect("AdminController?action=viewCustomer&cusId=" + cusId);
                break;
            }
            case "deleteCar": {
                int carId = Integer.parseInt(request.getParameter("id"));
                new CarDAO().deleteCar(carId);
                response.sendRedirect("AdminController?action=listCars");
                break;
            }
            default:
                List<Customer> customerList = new CustomerDAO().getAllCustomers();
                request.setAttribute("CUSTOMER_LIST", customerList);
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
