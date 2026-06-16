/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import dbutils.DBUtils;
import static dbutils.DBUtils.getConnection;
import dto.Car;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author HP
 */
public class CarDAO {

    //code placeholder để tạo car 
    public int createCar(Car car) {
        String sql = "insert into Cars (cusid,licensePlate,type,brand,model,color,createdDate,status)\n"
                + "values (?,?,?,?,?,?,?,?)";
        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, car.getCusid());
            ps.setString(2, car.getLicensePlate());
            ps.setString(3, car.getType());
            ps.setString(4, car.getBrand());
            ps.setString(5, car.getModel());
            ps.setString(6, car.getColor());
            ps.setDate(7, car.getCreatedDate());
            ps.setBoolean(8, car.isStatus());
            return ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<Car> getAllCars(int custid) {
        List<Car> result = new ArrayList<>();
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            if (cn != null) {
                String sql = "select id, cusid, licensePlate, brand, model, color, createdDate, status,type\n"
                        + "from dbo.Cars\n"
                        + "where cusid=?";
                PreparedStatement st = cn.prepareStatement(sql);
                st.setInt(1, custid);
                ResultSet table = st.executeQuery();
                if (table != null) {
                    while (table.next()) {
                        int id = table.getInt("id");
                        String liPlate = table.getString("licensePlate");
                        String type = table.getString("type");
                        String brand = table.getString("brand");
                        String model = table.getString("model");
                        String color = table.getString("color");
                        Date date = table.getDate("createdDate");
                        boolean status = table.getBoolean("status");
                        Car c = new Car(id, custid, liPlate, type, brand, model, color, date, status); // ← sửa
                        result.add(c);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
        }
        return result;
    }

    public Car getCarByLicensePlate(String licensePlate) {
        Car result = null;
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            if (cn != null) {
                String sql = "SELECT id, cusid, licensePlate, type, brand, model, color, createdDate, status "
                        + "FROM dbo.Cars WHERE licensePlate=? AND status=1";
                PreparedStatement st = cn.prepareStatement(sql);
                st.setString(1, licensePlate);
                ResultSet table = st.executeQuery();
                if (table.next()) {
                    result = new Car(
                            table.getInt("id"), table.getInt("cusid"),
                            table.getString("licensePlate"), table.getString("type"),
                            table.getString("brand"), table.getString("model"),
                            table.getString("color"), table.getDate("createdDate"),
                            table.getBoolean("status")
                    );
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

    public Car getCarById(int id) {
        Car result = null;
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            if (cn != null) {
                String sql = "SELECT id, cusid, licensePlate, type, brand, model, color, createdDate, status "
                        + "FROM dbo.Cars WHERE id=? AND status=1";
                PreparedStatement st = cn.prepareStatement(sql);
                st.setInt(1, id);
                ResultSet table = st.executeQuery();
                if (table.next()) {
                    result = new Car(
                            table.getInt("id"), table.getInt("cusid"),
                            table.getString("licensePlate"), table.getString("type"),
                            table.getString("brand"), table.getString("model"),
                            table.getString("color"), table.getDate("createdDate"),
                            table.getBoolean("status")
                    );
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

    public int updateCar(Car car) {
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            if (cn != null) {
                String sql = "UPDATE dbo.Cars SET brand=?, model=?, color=?, type=? WHERE id=?";
                PreparedStatement st = cn.prepareStatement(sql);
                st.setString(1, car.getBrand());
                st.setString(2, car.getModel());
                st.setString(3, car.getColor());
                st.setString(4, car.getType());
                st.setInt(5, car.getId());
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

    public int deleteCar(int id) {
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            if (cn != null) {
                String sql = "UPDATE dbo.Cars SET status=0 WHERE id=?";
                PreparedStatement st = cn.prepareStatement(sql);
                st.setInt(1, id);
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
}
