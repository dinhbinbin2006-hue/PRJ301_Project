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
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author ADMIN
 */
public class BookingDAO {

    public Booking getBookingById(int bookingId) {
        Booking result = null;
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
                        Timestamp bookingDate = table.getTimestamp("bookingDate");
                        double totalAmount = table.getInt("totalAmount");
                        String bookingStatus = table.getString("bookingStatus");
                        Timestamp createdAt = table.getTimestamp("createdAt");
                        Booking b = new Booking(bookingId, cusId, carId, serviceId, bookingDate, totalAmount, bookingStatus, createdAt);
                        result = b;
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
        }
        return result;
    }

    public List<Booking> getPendingBooking(int cusId) {
        List<Booking> result = new ArrayList<>();
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            if (cn != null) {
                String sql = "select bookingId, cusId, carId, serviceId, bookingDate, totalAmount, bookingStatus, createdAt\n"
                        + "from dbo.Bookings\n"
                        + "where bookingStatus='PENDING' AND cusId = ?";
                PreparedStatement st = cn.prepareStatement(sql);
                st.setInt(1, cusId);
                ResultSet table = st.executeQuery();
                if (table != null) {
                    while (table.next()) {
                        int bookingId = table.getInt("bookingId");
                        int carId = table.getInt("carId");
                        int serviceId = table.getInt("serviceId");
                        Timestamp bookingDate = table.getTimestamp("bookingDate");
                        double totalAmount = table.getInt("totalAmount");
                        String bookingStatus = table.getString("bookingStatus");
                        Timestamp createdAt = table.getTimestamp("createdAt");
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

    public int createBooking(Booking c) {
        int result = 0;
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            if (cn != null) {
                String sql = "INSERT INTO dbo.Bookings([cusId],[carId],[serviceId],[bookingDate],[totalAmount],[bookingStatus],[createdAt])\n"
                        + "VALUES(?,?,?,?,?,?,?)";
                PreparedStatement st = cn.prepareStatement(sql);
                st.setInt(1, c.getCusId());
                st.setInt(2, c.getCarId());
                st.setInt(3, c.getServiceId());
                st.setObject(4, c.getBookingDate());
                st.setDouble(5, c.getTotalAmount());
                st.setString(6, c.getBookingStatus());
                st.setObject(7, c.getCreatedAt());

                result = st.executeUpdate();
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (cn != null) {
                    cn.close();
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return result;
    }

    public boolean hasConflict(int carId, LocalDateTime startTime, int durationMinutes) {
        boolean conflict = false;
        Connection cn = null;
        ResultSet rs = null;
        try {
            cn = DBUtils.getConnection();
            if (cn != null) {
                String sql = "SELECT COUNT(*) FROM Bookings b "
                        + "JOIN Services s ON b.serviceId = s.serviceId "
                        + "WHERE b.carId = ? "
                        + "AND b.bookingStatus != 'CANCELLED' "
                        + "AND b.bookingDate < ? "
                        + "AND DATEADD(MINUTE, s.durationMinutes, b.bookingDate) > ?";
                PreparedStatement st = cn.prepareStatement(sql);
                st.setInt(1, carId);
                st.setTimestamp(2, Timestamp.valueOf(startTime.plusMinutes(durationMinutes)));
                st.setTimestamp(3, Timestamp.valueOf(startTime));
                rs = st.executeQuery();
                if (rs.next()) {
                    int count = rs.getInt(1);
                    conflict = (count > 0);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
        }
        return conflict;
    }

    public int updateBookingStatus(int bookingId, String status) {
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            if (cn != null) {
                String sql = "UPDATE dbo.Bookings SET bookingStatus=? WHERE bookingId=?";

                PreparedStatement st = cn.prepareStatement(sql);
                st.setString(1, status);
                st.setInt(2, bookingId);
                return st.executeUpdate();
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (cn != null) {
                    cn.close();
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return 0;
    }
/////
    public List<Integer> getBookedHours(java.time.LocalDate date) {
        List<Integer> result = new ArrayList<>();
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            if (cn != null) {
                // Lấy tất cả giờ đã đặt trong ngày đó (status != CANCELLED)
                String sql = "SELECT DATEPART(HOUR, bookingDate) AS bookedHour "
                        + "FROM dbo.Bookings "
                        + "WHERE CAST(bookingDate AS DATE) = ? "
                        + "AND bookingStatus != 'CANCELLED'";
                PreparedStatement st = cn.prepareStatement(sql);
                st.setDate(1, Date.valueOf(date));
                ResultSet rs = st.executeQuery();
                while (rs.next()) {
                    result.add(rs.getInt("bookedHour"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (cn != null) {
                    cn.close();
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return result;
    }

    public List<Booking> getAllBooking() {
        List<Booking> result = new ArrayList<>();
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            if (cn != null) {
                String sql = "select bookingId, cusId, carId, serviceId, bookingDate, totalAmount, bookingStatus, createdAt\n"
                        + "from dbo.Bookings\n";
                PreparedStatement st = cn.prepareStatement(sql);
                ResultSet table = st.executeQuery();
                if (table != null) {
                    while (table.next()) {
                        int bookingId = table.getInt("bookingId");
                        int cusId = table.getInt("cusId");
                        int carId = table.getInt("carId");
                        int serviceId = table.getInt("serviceId");
                        Timestamp bookingDate = table.getTimestamp("bookingDate");
                        double totalAmount = table.getInt("totalAmount");
                        String bookingStatus = table.getString("bookingStatus");
                        Timestamp createdAt = table.getTimestamp("createdAt");
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
