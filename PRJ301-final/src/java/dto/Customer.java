/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dto;

import java.sql.Date;

/**
 *
 * @author HP
 */
public class Customer {
    private int cusId;
    private String fullname;
    private String gender;
    private Date dateOfBirth;
    private int phone;
    private String email;
    private String password;
    private Date createdAt;
    private String  membershipLevel;
    private int points;
    private boolean status;

    public Customer() {
    }

    public Customer(int cusId, String fullname, String gender, Date dateOfBirth, int phone, String email, String password, Date createdAt, String membershipLevel, int points, boolean status) {
        this.cusId = cusId;
        this.fullname = fullname;
        this.gender = gender;
        this.dateOfBirth = dateOfBirth;
        this.phone = phone;
        this.email = email;
        this.password = password;
        this.createdAt = createdAt;
        this.membershipLevel = membershipLevel;
        this.points = points;
        this.status = status;
    }

    public int getCusId() {
        return cusId;
    }

    public String getFullname() {
        return fullname;
    }

    public String getGender() {
        return gender;
    }

    public Date getDateOfBirth() {
        return dateOfBirth;
    }

    public int getPhone() {
        return phone;
    }

    public String getEmail() {
        return email;
    }

    public String getPassword() {
        return password;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public String getMembershipLevel() {
        return membershipLevel;
    }

    public int getPoints() {
        return points;
    }

    public boolean isStatus() {
        return status;
    }

    public void setCusId(int cusId) {
        this.cusId = cusId;
    }

    public void setFullname(String fullname) {
        this.fullname = fullname;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public void setDateOfBirth(Date dateOfBirth) {
        this.dateOfBirth = dateOfBirth;
    }

    public void setPhone(int phone) {
        this.phone = phone;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public void setMembershipLevel(String membershipLevel) {
        this.membershipLevel = membershipLevel;
    }

    public void setPoints(int points) {
        this.points = points;
    }

    public void setStatus(boolean status) {
        this.status = status;
    }

    
}
