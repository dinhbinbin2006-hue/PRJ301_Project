/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dto;

/**
 *
 * @author ADMIN
 */
public class Tier {
    private String tierId;
    private String tierName;
    private int minPoints;
    private int bookingPriorityDays;
    private int bonusRate;
    private boolean status;

    public Tier() {
    }

    public Tier(String tierId, String tierName, int minPoints, int bookingPriorityDays, int bonusRate, boolean status) {
        this.tierId = tierId;
        this.tierName = tierName;
        this.minPoints = minPoints;
        this.bookingPriorityDays = bookingPriorityDays;
        this.bonusRate = bonusRate;
        this.status = status;
    }

    public String getTierId() {
        return tierId;
    }

    public void setTierId(String tierId) {
        this.tierId = tierId;
    }

    public String getTierName() {
        return tierName;
    }

    public void setTierName(String tierName) {
        this.tierName = tierName;
    }

    public int getMinPoints() {
        return minPoints;
    }

    public void setMinPoints(int minPoints) {
        this.minPoints = minPoints;
    }

    public int getBookingPriorityDays() {
        return bookingPriorityDays;
    }

    public void setBookingPriorityDays(int bookingPriorityDays) {
        this.bookingPriorityDays = bookingPriorityDays;
    }

    public int getBonusRate() {
        return bonusRate;
    }

    public void setBonusRate(int bonusRate) {
        this.bonusRate = bonusRate;
    }

    public boolean isStatus() {
        return status;
    }

    public void setStatus(boolean status) {
        this.status = status;
    }
    
}
