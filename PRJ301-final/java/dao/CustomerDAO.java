/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import dbutils.DBUtils;
import dto.Customer;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.List;

/**
 *
 * @author HP
 */
//TOÀN BỘ DAO Ở ĐÂY CƠ BẢN LÀ PLACEHOLDER CHỨ ĐÉO ĐỦ 1 CÁI CON CAK GÌ NHA MN
public class CustomerDAO {
    //ham nay de lay Customer dua vao email,pass

    public Customer getCustomer(String email, String password) {
        Customer result = null;
        Connection cn = null;
        try {
            //buoc 1: make connection
            cn = DBUtils.getConnection();
            if (cn != null) {
                //buoc 2 : viet sql
                String sql = "select cusId,fullname,gender,dateOfBirth,phone,email,password,tierId,points,createdAt,status\n"
                        + "from dbo.Customers\n"
                        + "where email=? and password=? and status=1";
                PreparedStatement st = cn.prepareStatement(sql);
                st.setString(1, email);
                st.setString(2, password);

                ResultSet table = st.executeQuery();
                //buoc 3: doc data trong bien table
                while (table.next()) {
                    int cusid = table.getInt("cusId");
                    String name = table.getString("fullname");
                    String gender = table.getString("gender");
                    Date dateOfBirth = table.getDate("dateOfBirth");
                    String phone = table.getString("phone");
                    String membershipLevel = table.getString("tierId");
                    int points = table.getInt("points");
                    Date createDate = table.getDate("CreatedAt");
                    boolean status = table.getBoolean("status");
                    result = new Customer(cusid, name, gender, dateOfBirth, phone, email, password, createDate, membershipLevel, points, status);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                //buoc 4
                if (cn != null) {
                    cn.close();
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        return result;
    }

    //ham nay de lay Customer dua vao email(kiểm tra email có trùng lặp không)
    public Customer getCustomer(String email) {
        Customer result = null;
        Connection cn = null;
        try {
            //buoc 1: make connection
            cn = DBUtils.getConnection();
            if (cn != null) {
                //buoc 2 : viet sql
                String sql = "select cusId,fullname,gender,dateOfBirth,phone,email,password,tierId,points,createdAt,status\n"
                        + "from dbo.Customers\n"
                        + "where email=?";
                PreparedStatement st = cn.prepareStatement(sql);
                st.setString(1, email);
                ResultSet table = st.executeQuery();
                //buoc 3: doc data trong bien table
                while (table.next()) {
                    int cusid = table.getInt("cusId");
                    String name = table.getString("fullname");
                    String gender = table.getString("gender");
                    Date dateOfBirth = table.getDate("dateOfBirth");
                    String phone = table.getString("phone");
                    String membershipLevel = table.getString("tierId");
                    int points = table.getInt("points");
                    Date createDate = table.getDate("CreatedAt");
                    boolean status = table.getBoolean("status");
                    String password = table.getString("password");
                    result = new Customer(cusid, name, gender, dateOfBirth, phone, email, password, createDate, membershipLevel, points, status);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                //buoc 4
                if (cn != null) {
                    cn.close();
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        return result;
    }

    public int createCustomer(Customer c) {
        int result = 0;
        Connection cn = null;
        try {
            //buoc 1: make connection
            cn = DBUtils.getConnection();
            if (cn != null) {
                //buoc 2 : viet sql
                // CustomerDAO.java - sửa dòng sql trong createCustomer()
                String sql = "INSERT INTO dbo.Customers([fullname],[gender],[dateOfBirth],[phone],[email],[password],[tierId],[points],[createdAt],[status])\n"
                        + "VALUES(?,?,?,?,?,?,?,?,?,?)";
                PreparedStatement st = cn.prepareStatement(sql);
                st.setString(1, c.getFullname());
                st.setString(2, c.getGender());
                st.setDate(3, c.getDateOfBirth());
                st.setString(4, c.getPhone());
                st.setString(5, c.getEmail());
                st.setString(6, c.getPassword());
                st.setInt(7, Integer.parseInt(c.getMembershipLevel()));
                st.setInt(8, c.getPoints());
                st.setDate(9, c.getCreatedAt());
                st.setBoolean(10, true);

                result = st.executeUpdate();
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                //buoc 4
                if (cn != null) {
                    cn.close();
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return result;
    }

    public Customer getCustomerById(int cusId) {
        Customer result = null;
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            if (cn != null) {
                String sql = "SELECT cusId,fullname,gender,dateOfBirth,phone,email,password,tierId,points,createdAt,status "
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
                    int points = table.getInt("points");
                    Date createDate = table.getDate("createdAt");
                    boolean status = table.getBoolean("status");
                    result = new Customer(cusId, name, gender, dateOfBirth, phone, email, password, createDate, membershipLevel, points, status);
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

    public int updateCustomer(Customer c) {
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            if (cn != null) {
                String sql = "UPDATE dbo.Customers SET fullname=?, gender=?, dateOfBirth=?, phone=? WHERE cusId=?";
                PreparedStatement st = cn.prepareStatement(sql);
                st.setString(1, c.getFullname());
                st.setString(2, c.getGender());
                st.setDate(3, c.getDateOfBirth());
                st.setString(4, c.getPhone());
                st.setInt(5, c.getCusId());
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

    public java.util.List<Customer> getAllCustomers() {
        java.util.List<Customer> result = new java.util.ArrayList<>();
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            if (cn != null) {
                String sql = "select cusId,fullname,gender,dateOfBirth,phone,email,password,tierId,points,createdAt,status "
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
                    String membershipLevel = table.getString("membershipLevel");
                    int points = table.getInt("points");
                    Date createDate = table.getDate("createdAt");
                    boolean status = table.getBoolean("status");
                    result.add(new Customer(cusid, name, gender, dateOfBirth, phone, email, password, createDate, membershipLevel, points, status));
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
}
