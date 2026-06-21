/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import dbutils.DBUtils;
import dto.Tier;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author ADMIN
 */
public class TierDAO {

    public Tier getTierById(String tierId) {
        Tier result =null;
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            if (cn != null) {
                String sql = "select tierId, tierName, minPoints, bookingPriorityDays, bonusRate, status\n"
                        + "from dbo.Tier\n"
                        + "where tierId=?";
                PreparedStatement st = cn.prepareStatement(sql);
                st.setString(1, tierId);
                ResultSet table = st.executeQuery();
                if (table != null) {
                    while (table.next()) {
                        String tierName = table.getString("tierName");
                        int minPoints = table.getInt("minPoints");
                        int bookingPriorityDays = table.getInt("bookingPriorityDays");
                        int bonusRate = table.getInt("bonusRate");
                        boolean status = table.getBoolean("status");
                        Tier b = new Tier(tierId, tierName, minPoints, bookingPriorityDays, bonusRate, status);
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
}
