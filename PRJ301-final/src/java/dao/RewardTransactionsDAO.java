/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import dbutils.DBUtils;
import dto.RewardTransactions;
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
public class RewardTransactionsDAO {

    public List<RewardTransactions> getRewardTransactionById(int transactionId) {
        List<RewardTransactions> result = new ArrayList<>();
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            if (cn != null) {
                String sql = "select transactionId, cusId, points, transactionType, description, createdAt\n"
                        + "from dbo.RewardTransactions\n"
                        + "where transactionId=?";
                PreparedStatement st = cn.prepareStatement(sql);
                st.setInt(1, transactionId);
                ResultSet table = st.executeQuery();
                if (table != null) {
                    while (table.next()) {
                        int cusId = table.getInt("cusId");
                        int points = table.getInt("points");
                        String transactionType = table.getString("transactionType");
                        String description = table.getString("description");
                        Date createdAt = table.getDate("createdAt");
                        RewardTransactions b = new RewardTransactions(transactionId, cusId, points, transactionType, description, createdAt);
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

    public RewardTransactions getAllRewardTransactions() {
        RewardTransactions result = null;
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            if (cn != null) {
                String sql = "select transactionId, cusId, points, transactionType, description, createdAt\n"
                        + "from dbo.RewardTransactions\n"
                        + "where transactionId=?";
                PreparedStatement st = cn.prepareStatement(sql);
                ResultSet table = st.executeQuery();
                if (table != null) {
                    while (table.next()) {
                        int transactionId = table.getInt("transactionId");
                        int cusId = table.getInt("cusId");
                        int points = table.getInt("points");
                        String transactionType = table.getString("transactionType");
                        String description = table.getString("description");
                        Date createdAt = table.getDate("createdAt");
                        RewardTransactions b = new RewardTransactions(transactionId, cusId, points, transactionType, description, createdAt);
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
