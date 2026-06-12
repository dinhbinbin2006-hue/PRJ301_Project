<%-- 
    Document   : register_page
    Created on : May 28, 2026, 8:12:58 PM
    Author     : HP
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Đăng Ký Tài Khoản</title>

        <style>
            *{
                margin:0;
                padding:0;
                box-sizing:border-box;
                font-family:'Segoe UI',sans-serif;
            }

            body{
                background:#0f172a;
                min-height:100vh;
                display: flex;
                justify-content: center;
                align-items: flex-start;
                padding: 40px 0;
            }

            .register-container{
                width:100%;
                max-width:1200px;
                padding:40px 80px;
                background: #1e293b;
                border-radius: 20px;
                box-shadow: 0 10px 25px rgba(0,0,0,0.3);
            }

            .title{
                color:white;
                text-align:center;
                margin-bottom:40px;
                font-size:34px;
                font-weight:700;
            }

            /* SECTION TITLE */
            .section-title{
                color:#60a5fa;
                font-size:24px;
                margin-top:45px;
                margin-bottom:25px;
                font-weight:600;
                border-left:5px solid #2563eb;
                padding-left:15px;
            }

            /* ROW */
            .row{
                display:flex;
                gap:20px;
            }

            .name-group{
                flex:2;
            }

            .gender-group{
                flex:1;
            }

            /* FORM */
            .form-group{
                margin-bottom:28px;
                width:100%;
            }

            .form-group label{
                display:block;
                color:white;
                font-size:17px;
                margin-bottom:10px;
                font-weight:500;
            }

            .form-group input,
            .custom-select{
                width:100%;
                background:transparent;
                border:none;
                border-bottom:1px solid #374151;
                padding:12px 0;
                color:white;
                font-size:17px;
                outline:none;
            }

            .form-group input::placeholder{
                color:#6b7280;
            }

            .form-group input:focus,
            .custom-select:focus{
                border-bottom:1px solid #3b82f6;
            }

            /* SELECT */
            .custom-select option{
                background:#111827;
                color:white;
            }

            /* READONLY / DISABLED */
            input[disabled]{
                color:#9ca3af;
                border-bottom: 1px dashed #4b5563;
            }

            /* PRIVACY */
            .privacy-section{
                margin-top:20px;
                background:#1f2937;
                padding:25px;
                border-radius:15px;
            }

            .checkbox-group{
                display:flex;
                align-items:center;
                gap:12px;
                margin-bottom:18px;
                color:white;
                font-size:16px;
                line-height:1.5;
            }

            .checkbox-group input[type="checkbox"]{
                width:18px;
                height:18px;
                accent-color:#2563eb;
                cursor:pointer;
            }

            .checkbox-group label{
                cursor:pointer;
                color:#e5e7eb;
            }

            /* BUTTON */
            .btn-register{
                width:100%;
                padding:15px;
                background:#22c55e;
                border:none;
                border-radius:12px;
                color:white;
                font-size:18px;
                cursor:pointer;
                margin-top:35px;
                transition:.3s;
                font-weight:600;
            }

            .btn-register:hover{
                background:#16a34a;
            }

            /* LOGIN LINK */
            .login-link{
                text-align:center;
                margin-top:25px;
            }

            .login-link a{
                color:#60a5fa;
                text-decoration:none;
                font-size:16px;
            }

            .login-link a:hover{
                text-decoration:underline;
            }

            /* MODAL TỔNG HỢP */
            .modal{
                position:fixed;
                top:0;
                left:0;
                width:100%;
                height:100%;
                background:rgba(0,0,0,.7);
                display:none;
                justify-content:center;
                align-items:center;
                z-index:1000;
            }

            .modal-content{
                background:#111827;
                padding:40px;
                border-radius:20px;
                text-align:center;
                width:420px;
                box-shadow:0 0 20px rgba(0,0,0,.4);
            }

            .success-icon{
                width:80px;
                height:80px;
                border:4px solid #22c55e;
                border-radius:50%;
                color:#22c55e;
                font-size:45px;
                display:flex;
                justify-content:center;
                align-items:center;
                margin:auto;
                margin-bottom:20px;
            }

            /* Style mới cho Icon Lỗi giống thiết kế của bạn */
            .error-icon{
                width:80px;
                height:80px;
                border:4px solid #ef4444;
                border-radius:50%;
                color:#ef4444;
                font-size:45px;
                display:flex;
                justify-content:center;
                align-items:center;
                margin:auto;
                margin-bottom:20px;
                font-weight: bold;
            }

            .modal-content h2{
                color:white;
                margin-bottom:15px;
                font-size:28px;
            }

            .modal-content p{
                color:#9ca3af;
                margin-bottom:30px;
                line-height:1.6;
            }

            .confirm-btn{
                background:#22c55e;
                color:white;
                border:none;
                padding:14px 30px;
                border-radius:10px;
                cursor:pointer;
                font-size:16px;
                transition:.3s;
                font-weight:600;
            }

            .confirm-btn:hover{
                background:#16a34a;
            }


            /* RESPONSIVE */
            @media(max-width:768px){
                .register-container{
                    width:95%;
                    padding:25px;
                }

                .row{
                    flex-direction:column;
                    gap:0;
                }

                .title{
                    font-size:28px;
                }

                .section-title{
                    font-size:22px;
                }

                .modal-content{
                    width:90%;
                }
            }
        </style>
    </head>

    <body>

        <%
            // Nhận thông báo lỗi từ Servlet (Trùng email, lỗi hệ thống...)
            String msg = (String) request.getAttribute("ERROR");
        %>

        <div id="errorModal" class="modal" <%= (msg != null) ? "style='display:flex;'" : ""%>>
            <div class="modal-content">
                <div class="error-icon">&times;</div>
                <h2>Đăng ký thất bại!</h2>
                <p><%= (msg != null) ? msg : ""%></p>
                <button class="close-error-btn" onclick="closeErrorModal()">Đóng</button>
            </div>
        </div>

        <div class="register-container">

            <h1 class="title">Đăng Ký Tài Khoản</h1>

            <form id="registerForm"
                  action="MainController"
                  method="post">

                <input type="hidden"
                       name="action"
                       value="register">

                <h2 class="section-title">Personal Information</h2>

                <div class="row">
                    <div class="form-group name-group">
                        <label>Họ tên</label>
                        <input type="text" name="fullname" placeholder="Nguyễn Văn A" required>
                    </div>

                    <div class="form-group gender-group">
                        <label>Giới tính</label>
                        <select name="gender" class="custom-select" required>
                            <option value="">Chọn</option>
                            <option value="Male">Nam</option>
                            <option value="Female">Nữ</option>
                            <option value="Other">Khác</option>
                        </select>
                    </div>
                </div>

                <div class="form-group">
                    <label>Ngày sinh</label>
                    <input type="date" name="dateOfBirth" required>
                </div>

                <div class="row">
                    <div class="form-group">
                        <label>Số điện thoại</label>
                        <input type="text" name="phone" placeholder="0123-888-999" pattern="^[0-9]{8,12}$" required>
                    </div>

                    <div class="form-group">
                        <label>Email</label>
                        <input type="email" name="email" placeholder="user@gmail.com" required>
                    </div>
                </div>

                <div class="row">
                    <div class="form-group">
                        <label>Mật khẩu</label>
                        <input type="password" name="password" placeholder="********" required>
                    </div>

                    <div class="form-group">
                        <label>Nhập lại mật khẩu</label>
                        <input type="password" name="confirmPassword" placeholder="********" required>
                    </div>
                </div>

                <h2 class="section-title">Vehicle Information</h2>

                <div class="row">
                    <div class="form-group">
                        <label>Biển số xe</label>
                        <input type="text" name="licensePlate" placeholder="51A-12345" required>
                    </div>

                    <div class="form-group">
                        <label>Loại xe</label>
                        <select name="vehicleType" class="custom-select" required>
                            <option value="">-- Chọn loại xe --</option>
                            <option value="Bike">Xe máy</option>
                            <option value="Car 4 Seats">Xe ô tô 4 chỗ</option>
                            <option value="Car 7 Seats">Xe ô tô 7 chỗ</option>
                        </select>
                    </div>
                </div>

                <div class="row">
                    <div class="form-group">
                        <label>Hãng xe</label>
                        <select name="vehicleBrand" class="custom-select" required>
                            <option value="">-- Chọn hãng xe --</option>
                            <option value="Toyota">Toyota</option>
                            <option value="Honda">Honda</option>
                            <option value="Kia">Kia</option>
                            <option value="Hyundai">Hyundai</option>
                            <option value="Ford">Ford</option>
                            <option value="Other">Khác</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label>Dòng xe (Model)</label>
                        <input type="text" name="model" placeholder="Vios / Civic / CX5" required>
                    </div>

                    <div class="form-group">
                        <label>Màu xe</label>
                        <input type="text" name="vehicleColor" placeholder="White / Black" required>
                    </div>
                </div>

                <h2 class="section-title">Loyalty Information</h2>

                <div class="row">
                    <div class="form-group">
                        <label>Hạng thành viên</label>
                        <input type="text" name="membershipLevel" value="Member" disabled>
                    </div>

                    <div class="form-group">
                        <label>Điểm tích lũy</label>
                        <input type="text" name="points" value="0" disabled>
                    </div>
                </div>

                <h2 class="section-title">Privacy & Consent</h2>

                <div class="privacy-section">
                    <div class="checkbox-group">
                        <input type="checkbox" name="txtchk1" id="chk1" required>
                        <label for="chk1">I agree to facial recognition check-in</label>
                    </div>
                    <div class="checkbox-group">
                        <input type="checkbox" name="txtchk2" id="chk2" required>
                        <label for="chk2">I agree to license plate recognition</label>
                    </div>
                    <div class="checkbox-group">
                        <input type="checkbox" name="txtchk3" id="chk3" required>
                        <label for="chk3">I accept the privacy policy</label>
                    </div>
                </div>

                <button type="submit" class="btn-register">Đăng ký</button>

            </form>

            <div class="login-link">
                <a href="MainController?action=loginPage">Đã có tài khoản? Đăng nhập</a>
            </div>

        </div>

        <div id="successModal" class="modal">
            <div class="modal-content">
                <div class="success-icon">✓</div>
                <h2>Đăng ký thành công!</h2>
                <p>Tài khoản của bạn đã được tạo.</p>
                <button class="confirm-btn" onclick="goToHome()">OK</button>
            </div>
        </div>

    </body>

    <script>
        const form = document.getElementById("registerForm");
        form.addEventListener("submit", function (e) {
            const password = document.querySelector('input[name="password"]').value;
            const confirmPassword = document.querySelector('input[name="confirmPassword"]').value;

            if (password !== confirmPassword) {
                alert("Mật khẩu nhập lại không khớp!");
                e.preventDefault();
            }
        });

        function goToHome() {
            window.location.href = "MainController?action=home";
        }



    </script>
</html>