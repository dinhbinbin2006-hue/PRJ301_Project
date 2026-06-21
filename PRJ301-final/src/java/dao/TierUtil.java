/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

/**
 * Tiện ích dùng chung cho hệ thống Tier (hạng thành viên).
 * Cột membershipLevel/tierId trong DB lưu giá trị số dạng chuỗi: "1","2","3","4".
 * Class này chịu trách nhiệm map qua lại giữa tierId và tên hiển thị,
 * cũng như xác định tier dựa trên totalPoints.
 *
 * Quy ước:
 *   Tier 1 = Member     (totalPoints >= 0)
 *   Tier 2 = Silver     (totalPoints >= 2000)
 *   Tier 3 = Gold       (totalPoints >= 6000)
 *   Tier 4 = Platinum   (totalPoints >= 15000)
 *
 * @author HP
 */
public class TierUtil {

    public static final String TIER_MEMBER = "1";
    public static final String TIER_SILVER = "2";
    public static final String TIER_GOLD = "3";
    public static final String TIER_PLATINUM = "4";

    public static final int MIN_POINTS_SILVER = 2000;
    public static final int MIN_POINTS_GOLD = 6000;
    public static final int MIN_POINTS_PLATINUM = 15000;

    /**
     * Trả về tên hiển thị (tiếng Anh) của tier dựa trên tierId.
     * Dùng cho mọi nơi cần hiển thị "Member"/"Silver"/"Gold"/"Platinum".
     */
    public static String getTierName(String tierId) {
        if (tierId == null) {
            return "Member";
        }
        switch (tierId.trim()) {
            case TIER_SILVER:
                return "Silver";
            case TIER_GOLD:
                return "Gold";
            case TIER_PLATINUM:
                return "Platinum";
            case TIER_MEMBER:
            default:
                return "Member";
        }
    }

    /**
     * Xác định tierId tương ứng với số totalPoints hiện có.
     * Dùng khi cần tự tính tier từ điểm (không phụ thuộc bảng Tier trong DB).
     */
    public static String getTierIdByPoints(int totalPoints) {
        if (totalPoints >= MIN_POINTS_PLATINUM) {
            return TIER_PLATINUM;
        } else if (totalPoints >= MIN_POINTS_GOLD) {
            return TIER_GOLD;
        } else if (totalPoints >= MIN_POINTS_SILVER) {
            return TIER_SILVER;
        } else {
            return TIER_MEMBER;
        }
    }

    /**
     * Số ngày được đặt lịch trước tối đa, theo từng hạng.
     */
    public static int getMaxBookingDays(String tierId) {
        if (tierId == null) {
            return 7;
        }
        switch (tierId.trim()) {
            case TIER_SILVER:
                return 10;
            case TIER_GOLD:
                return 12;
            case TIER_PLATINUM:
                return 14;
            case TIER_MEMBER:
            default:
                return 7;
        }
    }
}
