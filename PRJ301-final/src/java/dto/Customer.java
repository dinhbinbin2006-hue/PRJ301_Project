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
    private String phone;
    private String email;
    private String password;
    private Date createdAt;
    private String  membershipLevel;
    private int points;
    private boolean status;
    private int totalPoints;
    private Date lastPointEarned;

    public Customer() {
    }

    

    public Customer(int cusId, String fullname, String gender, Date dateOfBirth, String phone, String email, String password, Date createdAt, String membershipLevel, int totalPoints, int points, Date lastPointEarned, boolean status) {
        this.cusId = cusId;
        this.fullname = fullname;
        this.gender = gender;
        this.dateOfBirth = dateOfBirth;
        this.phone = phone;
        this.email = email;
        this.password = password;
        this.createdAt = createdAt;
        this.membershipLevel = membershipLevel;
        this.totalPoints = totalPoints;
        this.points = points;
        this.lastPointEarned = lastPointEarned;
        this.status = status;
    }

    public int getCusId() {
        return cusId;
    }

    public void setCusId(int cusId) {
        this.cusId = cusId;
    }

    public String getFullname() {
        return fullname;
    }

    public void setFullname(String fullname) {
        this.fullname = fullname;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public Date getDateOfBirth() {
        return dateOfBirth;
    }

    public void setDateOfBirth(Date dateOfBirth) {
        this.dateOfBirth = dateOfBirth;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public String getMembershipLevel() {
        return membershipLevel;
    }

    public void setMembershipLevel(String membershipLevel) {
        this.membershipLevel = membershipLevel;
    }

    public int getPoints() {
        return points;
    }

    public void setPoints(int points) {
        this.points = points;
    }

    public boolean isStatus() {
        return status;
    }

    public void setStatus(boolean status) {
        this.status = status;
    }

    public int getTotalPoints() {
        return totalPoints;
    }

    public void setTotalPoints(int Totalpoints) {
        this.totalPoints = Totalpoints;
    }

    public Date getLastPointEarned() {
        return lastPointEarned;
    }

    public void setLastPointEarned(Date lastPointEarned) {
        this.lastPointEarned = lastPointEarned;
    }

    
    
}