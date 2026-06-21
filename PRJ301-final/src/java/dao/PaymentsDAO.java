/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import dbutils.DBUtils;
import dto.Payments;
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
public class PaymentsDAO {

    public List<Payments> getPaymentsById(int paymentId) {
        List<Payments> result = new ArrayList<>();
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            if (cn != null) {
                String sql = "select paymentId, bookingId, amount, paymentMethod, paymentDate\n"
                        + "from dbo.Payments\n"
                        + "where paymentId=?";
                PreparedStatement st = cn.prepareStatement(sql);
                st.setInt(1, paymentId);
                ResultSet table = st.executeQuery();
                if (table != null) {
                    while (table.next()) {
                        int bookingId = table.getInt("bookingId");
                        double amount = table.getDouble("amount");
                        String paymentMethod = table.getString("paymentMethod");
                        Date paymentDate = table.getDate("paymentDate");
                        Payments b = new Payments(paymentId, bookingId, amount, paymentMethod, paymentDate);
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

    public Payments getAllPayments() {
        Payments result = null;
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            if (cn != null) {
                String sql = "select paymentId, bookingId, amount, paymentMethod, paymentDate\n"
                        + "from dbo.Payments\n";
                PreparedStatement st = cn.prepareStatement(sql);
                ResultSet table = st.executeQuery();
                if (table != null) {
                    while (table.next()) {
                        int paymentId = table.getInt("paymentId");
                        int bookingId = table.getInt("bookingId");
                        double amount = table.getDouble("amount");
                        String paymentMethod = table.getString("paymentMethod");
                        Date paymentDate = table.getDate("paymentDate");
                        Payments b = new Payments(paymentId, bookingId, amount, paymentMethod, paymentDate);
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
    public int createPayment(Payments c) {
        int result = 0;
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            if (cn != null) {
                String sql = "INSERT INTO dbo.Payments([bookingId],[amount],[paymentMethod],[paymentDate])\n"
                        + "VALUES(?,?,?,?)";
                PreparedStatement st = cn.prepareStatement(sql);
                st.setInt(1, c.getBookingId());
                st.setDouble(2, c.getAmount());
                st.setString(3, c.getPaymentMethod());
                st.setDate(4, c.getPaymentDate());

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
}
