<%-- 
    Document   : login_page
    Created on : May 28, 2026, 5:56:03 PM
    Author     : HP
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type"
              content="text/html; charset=UTF-8">

        <title>Login</title>

        <style>

            *{
                margin:0;
                padding:0;
                box-sizing:border-box;
                font-family:'Segoe UI',sans-serif;
            }

            body{
                background:#0f172a;
                display:flex;
                justify-content:center;
                align-items:center;
                min-height:100vh;
                padding:30px 0;
            }

            .login-container{
                width:500px;
                background:#111827;
                padding:40px;
                border-radius:15px;
                box-shadow:0 0 20px rgba(0,0,0,.3);
            }

            .title{
                color:white;
                text-align:center;
                margin-bottom:30px;
                font-size:32px;
                font-weight:600;
            }

            .form-group{
                margin-bottom:28px;
            }

            .form-group label{
                display:block;
                color:white;
                font-size:18px;
                margin-bottom:10px;
            }

            .form-group input{
                width:100%;
                background:transparent;
                border:none;
                border-bottom:1px solid #374151;
                padding:12px 0;
                color:white;
                font-size:18px;
                outline:none;
            }

            .form-group input::placeholder{
                color:#6b7280;
            }

            .form-group input:focus{
                border-bottom:1px solid #3b82f6;
            }

            .btn-login{
                width:100%;
                padding:15px;
                background:#2563eb;
                border:none;
                border-radius:10px;
                color:white;
                font-size:18px;
                cursor:pointer;
                margin-top:20px;
                transition:0.3s;
            }

            .btn-login:hover{
                background:#1d4ed8;
            }

            .register-link{
                text-align:center;
                margin-top:20px;
            }

            .register-link a{
                color:#60a5fa;
                text-decoration:none;
            }

            .register-link a:hover{
                text-decoration:underline;
            }

            @media(max-width:600px){

                .login-container{
                    width:95%;
                    padding:25px;
                }

                .title{
                    font-size:26px;
                }
            }

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
            }

            .modal-content{
                background:#111827;
                padding:40px;
                border-radius:20px;
                text-align:center;
                width:420px;
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

            .modal-content h2{
                color:white;
                margin-bottom:15px;
            }

            .modal-content p{
                color:#9ca3af;
                margin-bottom:30px;
            }

            .confirm-btn{
                background:#22c55e;
                color:white;
                border:none;
                padding:14px 30px;
                border-radius:10px;
                cursor:pointer;
            }
        </style>

    </head>

    <body>

        <div class="login-container">

            <h1 class="title">Đăng Nhập</h1>

            <form action="MainController" method="post">

                <input type="hidden"
                       name="action"
                       value="login">

                <div class="form-group">

                    <label>Email</label>

                    <input type="email"
                           name="email"
                           placeholder="user@gmail.com"
                           required>

                </div>

                <div class="form-group">

                    <label>Mật khẩu</label>

                    <input type="password"
                           name="password"
                           placeholder="******"
                           required>

                </div>

                <button type="submit" class="btn-login">
                    Đăng nhập
                </button>

            </form>

            <%
                String msg = (String) request.getAttribute("ERROR");
                if (msg != null) {
            %>
            <p style="color:red; text-align: center; margin-top: 15px;">
                <%= msg%>
            </p>
            <%
                }
            %>

            <div class="register-link">

                <a href="MainController?action=registerPage">
                    Chưa có tài khoản? Đăng ký
                </a>

                <div id="successModal" class="modal">

                    <div class="modal-content">

                        <div class="success-icon">
                            ✓
                        </div>

                        <h2>Đăng nhập thành công!</h2>

                        <p>Welcome to AutoWash Pro</p>

                        <button class="confirm-btn"
                                onclick="goToDashboard()">

                            OK

                        </button>

                    </div>

                </div>

            </div>

        </div>

        <%
            Boolean success = (Boolean) request.getAttribute("SUCCESS");

            if (success != null && success) {
        %>

        <script>

            window.onload = function () {
                document.getElementById("successModal").style.display = "flex";
            }

            function goToDashboard() {
                window.location.href =
                        "MainController?action=dashboard";
            }

        </script>

        <%
            }
        %>
    </body>
</html>