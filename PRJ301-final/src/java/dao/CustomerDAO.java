/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

/**
 *
 * @author HP
 */

package dao;

import dbutils.DBUtils;
import dto.Customer;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class CustomerDAO {

    // Lấy Customer theo email + password (dùng cho Login)
    public Customer getCustomer(String email, String password) {
        Customer result = null;
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            if (cn != null) {
                String sql = "select cusId,fullname,gender,dateOfBirth,phone,email,password,tierId,totalPoints,points,lastpointearned,createdAt,status\n"
                        + "from dbo.Customers\n"
                        + "where email=? and password=? and status=1";
                PreparedStatement st = cn.prepareStatement(sql);
                st.setString(1, email);
                st.setString(2, password);

                ResultSet table = st.executeQuery();
                if (table.next()) {
                    int cusid = table.getInt("cusId");
                    String name = table.getString("fullname");
                    String gender = table.getString("gender");
                    Date dateOfBirth = table.getDate("dateOfBirth");
                    String phone = table.getString("phone");
                    String membershipLevel = table.getString("tierId");
                    int totalPoints = table.getInt("totalPoints");
                    int points = table.getInt("points");
                    Date lastEarned = table.getDate("lastpointearned");
                    Date createDate = table.getDate("createdAt");
                    boolean status = table.getBoolean("status");
                    result = new Customer(cusid, name, gender, dateOfBirth, phone, email, password,
                            createDate, membershipLevel, totalPoints, points, lastEarned, status);
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

    // Lấy Customer theo email (check trùng khi Register)
    public Customer getCustomer(String email) {
        Customer result = null;
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            if (cn != null) {
                String sql = "select cusId,fullname,gender,dateOfBirth,phone,email,password,tierId,totalPoints,points,lastpointearned,createdAt,status\n"
                        + "from dbo.Customers\n"
                        + "where email=?";
                PreparedStatement st = cn.prepareStatement(sql);
                st.setString(1, email);
                ResultSet table = st.executeQuery();
                if (table.next()) {
                    int cusid = table.getInt("cusId");
                    String name = table.getString("fullname");
                    String gender = table.getString("gender");
                    Date dateOfBirth = table.getDate("dateOfBirth");
                    String phone = table.getString("phone");
                    String membershipLevel = table.getString("tierId");
                    int totalPoints = table.getInt("totalPoints");
                    int points = table.getInt("points");
                    Date lastEarned = table.getDate("lastpointearned");
                    Date createDate = table.getDate("createdAt");
                    boolean status = table.getBoolean("status");
                    String password = table.getString("password");
                    result = new Customer(cusid, name, gender, dateOfBirth, phone, email, password,
                            createDate, membershipLevel, totalPoints, points, lastEarned, status);
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

    // Tạo customer mới (Register)
    public int createCustomer(Customer c) {
        int result = 0;
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            if (cn != null) {
                String sql = "INSERT INTO dbo.Customers([fullname],[gender],[dateOfBirth],[phone],[email],[password],[tierId],[totalPoints],[points],[createdAt],[status])\n"
                        + "VALUES(?,?,?,?,?,?,?,?,?,?,?)";
                PreparedStatement st = cn.prepareStatement(sql);
                st.setString(1, c.getFullname());
                st.setString(2, c.getGender());
                st.setDate(3, c.getDateOfBirth());
                st.setString(4, c.getPhone());
                st.setString(5, c.getEmail());
                st.setString(6, c.getPassword());
                st.setInt(7, Integer.parseInt(c.getMembershipLevel()));
                st.setInt(8, c.getTotalPoints());
                st.setInt(9, c.getPoints());
                st.setDate(10, c.getCreatedAt());
                st.setBoolean(11, true);

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

    // Lấy Customer theo id (dùng cho Dashboard/EditCustomer)
    public Customer getCustomerById(int cusId) {
        Customer result = null;
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            if (cn != null) {
                String sql = "SELECT cusId,fullname,gender,dateOfBirth,phone,email,password,tierId,totalPoints,points,lastpointearned,createdAt,status "
                        + "FROM dbo.Customers WHERE cusId=?";
                PreparedStatement st = cn.prepareStatement(sql);
                st.setInt(1, cusId);
                ResultSet table = st.executeQuery();
                if (table.next()) {
                    String name = table.getString("fullname");
                    String gender = table.getString("gender");
                    Date dateOfBirth = table.getDate("dateOfBirth");
                    String phone = table.getString("phone");
                    String email = table.getString("email");
                    String password = table.getString("password");
                    String membershipLevel = table.getString("tierId");
                    int totalPoints = table.getInt("totalPoints");
                    int points = table.getInt("points");
                    Date lastEarned = table.getDate("lastpointearned");
                    Date createDate = table.getDate("createdAt");
                    boolean status = table.getBoolean("status");
                    result = new Customer(cusId, name, gender, dateOfBirth, phone, email, password,
                            createDate, membershipLevel, totalPoints, points, lastEarned, status);
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

    // Update thông tin customer (EditCustomer)
    public int updateCustomer(Customer c) {
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            if (cn != null) {
                String sql = "UPDATE dbo.Customers SET "
                        + "fullname=?, "
                        + "gender=?, "
                        + "dateOfBirth=?, "
                        + "phone=?, "
                        + "email=?, "
                        + "password=?, "
                        + "tierId=?, "
                        + "totalPoints=?, "
                        + "points=? "
                        + "WHERE cusId=?";

                PreparedStatement st = cn.prepareStatement(sql);
                st.setString(1, c.getFullname());
                st.setString(2, c.getGender());
                st.setDate(3, c.getDateOfBirth());
                st.setString(4, c.getPhone());
                st.setString(5, c.getEmail());
                st.setString(6, c.getPassword());
                st.setInt(7, Integer.parseInt(c.getMembershipLevel()));
                st.setInt(8, c.getTotalPoints());
                st.setInt(9, c.getPoints());
                st.setInt(10, c.getCusId());

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

    // Xóa mềm customer
    public int deleteCustomer(int cusId) {
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            if (cn != null) {
                String sql = "UPDATE dbo.Customers SET status=0 WHERE cusId=?";
                PreparedStatement st = cn.prepareStatement(sql);
                st.setInt(1, cusId);
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

    // Lấy tất cả customer (Admin)
    public java.util.List<Customer> getAllCustomers() {
        java.util.List<Customer> result = new java.util.ArrayList<>();
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            if (cn != null) {
                String sql = "select cusId,fullname,gender,dateOfBirth,phone,email,password,tierId,totalPoints,points,lastpointearned,createdAt,status "
                        + "from dbo.Customers";
                PreparedStatement st = cn.prepareStatement(sql);
                ResultSet table = st.executeQuery();
                while (table.next()) {
                    int cusid = table.getInt("cusId");
                    String name = table.getString("fullname");
                    String gender = table.getString("gender");
                    Date dateOfBirth = table.getDate("dateOfBirth");
                    String phone = table.getString("phone");
                    String email = table.getString("email");
                    String password = table.getString("password");
                    String membershipLevel = table.getString("tierId");
                    int totalPoints = table.getInt("totalPoints");
                    int points = table.getInt("points");
                    Date lastEarned = table.getDate("lastpointearned");
                    Date createDate = table.getDate("createdAt");
                    boolean status = table.getBoolean("status");
                    result.add(new Customer(cusid, name, gender, dateOfBirth, phone, email, password,
                            createDate, membershipLevel, totalPoints, points, lastEarned, status));
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

    // ===== LOYALTY ENGINE =====
    // Cộng điểm sau booking: cộng cả points (tiêu xài) và totalPoints (rank, không giảm)
    public int addPoints(int cusId, double totalAmount) {
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            if (cn != null) {
                String sqlGetBonus = "SELECT t.bonusRate FROM Customers c "
                        + "JOIN Tier t ON c.tierId = t.tierId WHERE c.cusId = ?";
                PreparedStatement stGet = cn.prepareStatement(sqlGetBonus);
                stGet.setInt(1, cusId);
                ResultSet rs = stGet.executeQuery();

                int bonusRate = 0;
                if (rs.next()) {
                    bonusRate = rs.getInt("bonusRate");
                }

                int pointsEarned = (int) (totalAmount / 1000 * (1 + bonusRate / 100.0));

                String sqlUpdate = "UPDATE Customers SET points = points + ?, "
                        + "totalPoints = totalPoints + ?, lastpointearned = GETDATE() WHERE cusId = ?";
                PreparedStatement stUpdate = cn.prepareStatement(sqlUpdate);
                stUpdate.setInt(1, pointsEarned);
                stUpdate.setInt(2, pointsEarned);
                stUpdate.setInt(3, cusId);
                int result = stUpdate.executeUpdate();

                if (result >= 1) {
                    String sqlLog = "INSERT INTO RewardTransactions (cusId, points, transactionType, description) "
                            + "VALUES (?, ?, 'EARN', ?)";
                    PreparedStatement stLog = cn.prepareStatement(sqlLog);
                    stLog.setInt(1, cusId);
                    stLog.setInt(2, pointsEarned);
                    stLog.setString(3, "Earned " + pointsEarned + " points (bonus " + bonusRate + "%)");
                    stLog.executeUpdate();
                }
                return pointsEarned;
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

    // Tự động lên/xuống hạng dựa theo totalPoints
    public void checkAndUpdateTier(int cusId) {
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            if (cn != null) {
                String sqlPoints = "SELECT totalPoints FROM Customers WHERE cusId = ?";
                PreparedStatement stPoints = cn.prepareStatement(sqlPoints);
                stPoints.setInt(1, cusId);
                ResultSet rs = stPoints.executeQuery();
                int totalPoints = 0;
                if (rs.next()) {
                    totalPoints = rs.getInt("totalPoints");
                }

                String sqlTier = "SELECT TOP 1 tierId FROM Tier WHERE minPoints <= ? AND status = 1 ORDER BY minPoints DESC";
                PreparedStatement stTier = cn.prepareStatement(sqlTier);
                stTier.setInt(1, totalPoints);
                ResultSet rsTier = stTier.executeQuery();

                if (rsTier.next()) {
                    int newTierId = rsTier.getInt("tierId");
                    String sqlUpdate = "UPDATE Customers SET tierId = ? WHERE cusId = ?";
                    PreparedStatement stUpdate = cn.prepareStatement(sqlUpdate);
                    stUpdate.setInt(1, newTierId);
                    stUpdate.setInt(2, cusId);
                    stUpdate.executeUpdate();
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
    }

    // Reset points (không đụng totalPoints) nếu 12 tháng không tích điểm
    public void checkExpiredPoints(int cusId) {
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            if (cn != null) {
                String sqlCheck = "SELECT lastpointearned FROM Customers WHERE cusId = ?";
                PreparedStatement stCheck = cn.prepareStatement(sqlCheck);
                stCheck.setInt(1, cusId);
                ResultSet rs = stCheck.executeQuery();

                if (rs.next()) {
                    Date lastEarned = rs.getDate("lastpointearned");
                    if (lastEarned != null) {
                        long diffMs = System.currentTimeMillis() - lastEarned.getTime();
                        long diffDays = diffMs / (1000L * 60 * 60 * 24);

                        if (diffDays >= 365) {
                            String sqlReset = "UPDATE Customers SET points = 0 WHERE cusId = ?";
                            PreparedStatement stReset = cn.prepareStatement(sqlReset);
                            stReset.setInt(1, cusId);
                            stReset.executeUpdate();

                            String sqlLog = "INSERT INTO RewardTransactions (cusId, points, transactionType, description) "
                                    + "VALUES (?, 0, 'EXPIRE', 'Points expired after 12 months')";
                            PreparedStatement stLog = cn.prepareStatement(sqlLog);
                            stLog.setInt(1, cusId);
                            stLog.executeUpdate();
                        }
                    }
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
    }

    // Đổi points lấy ưu đãi (không đụng totalPoints, rank giữ nguyên)
    public int redeemPoints(int cusId, int pointsToRedeem, String description) {
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            if (cn != null) {
                String sqlUpdate = "UPDATE Customers SET points = points - ? WHERE cusId = ? AND points >= ?";
                PreparedStatement stUpdate = cn.prepareStatement(sqlUpdate);
                stUpdate.setInt(1, pointsToRedeem);
                stUpdate.setInt(2, cusId);
                stUpdate.setInt(3, pointsToRedeem);
                int result = stUpdate.executeUpdate();

                if (result >= 1) {
                    String sqlLog = "INSERT INTO RewardTransactions (cusId, points, transactionType, description) "
                            + "VALUES (?, ?, 'REDEEM', ?)";
                    PreparedStatement stLog = cn.prepareStatement(sqlLog);
                    stLog.setInt(1, cusId);
                    stLog.setInt(2, pointsToRedeem);
                    stLog.setString(3, description);
                    stLog.executeUpdate();
                }
                return result;
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
}
