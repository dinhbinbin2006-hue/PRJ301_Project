/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import dbutils.DBUtils;
import dto.Booking;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author ADMIN
 */
public class BookingDAO {
        public List<Booking> getAllBookings(int bookingId) {
        List<Booking> result = new ArrayList<>();
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            if (cn != null) {
                String sql = "select bookingId, cusId, carId, serviceId, bookingDate, totalAmount, bookingStatus, createdAt\n"
                        + "from dbo.Bookings\n"
                        + "where bookingId=?";
                PreparedStatement st = cn.prepareStatement(sql);
                st.setInt(1, bookingId);
                ResultSet table = st.executeQuery();
                if (table != null) {
                    while (table.next()) {
                        int cusId = table.getInt("cusId");
                        int carId = table.getInt("carId");
                        int serviceId = table.getInt("serviceId");
                        Date bookingDate = table.getDate("bookingDate");
                        int totalAmount = table.getInt("totalAmount");
                        String bookingStatus = table.getString("bookingStatus");
                        Date createdAt = table.getDate("createdAt");
                        Booking b = new Booking(bookingId, cusId, carId, serviceId, bookingDate, totalAmount, bookingStatus, createdAt);
                        result.add(b);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
        }
        return result;
    }
}
