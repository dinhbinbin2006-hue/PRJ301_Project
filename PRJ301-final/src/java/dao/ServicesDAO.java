/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import dbutils.DBUtils;
import dto.Services;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author ADMIN
 */
public class ServicesDAO {
            public Services getServicesById(int serviceId) {
        Services result = null;
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            if (cn != null) {
                String sql = "select serviceId, serviceName, description, price, durationMinutes, status\n"
                        + "from dbo.Services\n"
                        + "where serviceId=?";
                PreparedStatement st = cn.prepareStatement(sql);
                st.setInt(1, serviceId);
                ResultSet table = st.executeQuery();
                if (table != null) {
                    while (table.next()) {
                        String serviceName = table.getString("serviceName");
                        String description = table.getString("description");
                        double price = table.getDouble("price");
                        int durationMinutes = table.getInt("durationMinutes");
                        Boolean status = table.getBoolean("status");
                        Services s = new Services(serviceId, serviceName, description, price, durationMinutes, status);
                        result = s;
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
        }
        return result;
    }
        public List<Services> getAllServices() {
        List<Services> result = new ArrayList<>();
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            if (cn != null) {
                String sql = "select serviceId, serviceName, description, price, durationMinutes, status\n"
                        + "from dbo.Services\n";
                PreparedStatement st = cn.prepareStatement(sql);
                ResultSet table = st.executeQuery();
                if (table != null) {
                    while (table.next()) {
                        int serviceId = table.getInt("serviceId");
                        String serviceName = table.getString("serviceName");
                        String description = table.getString("description");
                        double price = table.getDouble("price");
                        int durationMinutes = table.getInt("durationMinutes");
                        Boolean status = table.getBoolean("status");
                        Services s = new Services(serviceId, serviceName, description, price, durationMinutes, status);
                        result.add(s);
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
