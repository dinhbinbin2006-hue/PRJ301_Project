/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dto;

import java.sql.Date;

/**
 *
 * @author ADMIN
 */
public class Booking {
    private int bookingId;
    private int cusId;
    private int carId;
    private int serviceId;
    private Date bookingDate;
    private int totalAmount;
    private String bookingStatus;
    private Date createdAt;

    public Booking() {
    }

    public Booking(int bookingId, int cusId, int carId, int serviceId, Date bookingDate, int totalAmount, String bookingStatus, Date createdAt) {
        this.bookingId = bookingId;
        this.cusId = cusId;
        this.carId = carId;
        this.serviceId = serviceId;
        this.bookingDate = bookingDate;
        this.totalAmount = totalAmount;
        this.bookingStatus = bookingStatus;
        this.createdAt = createdAt;
    }

    public int getBookingId() {
        return bookingId;
    }

    public void setBookingId(int bookingId) {
        this.bookingId = bookingId;
    }

    public int getCusId() {
        return cusId;
    }

    public void setCusId(int cusId) {
        this.cusId = cusId;
    }

    public int getCarId() {
        return carId;
    }

    public void setCarId(int carId) {
        this.carId = carId;
    }

    public int getServiceId() {
        return serviceId;
    }

    public void setServiceId(int serviceId) {
        this.serviceId = serviceId;
    }

    public Date getBookingDate() {
        return bookingDate;
    }

    public void setBookingDate(Date bookingDate) {
        this.bookingDate = bookingDate;
    }

    public int getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(int totalAmount) {
        this.totalAmount = totalAmount;
    }

    public String getBookingStatus() {
        return bookingStatus;
    }

    public void setBookingStatus(String bookingStatus) {
        this.bookingStatus = bookingStatus;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

}
