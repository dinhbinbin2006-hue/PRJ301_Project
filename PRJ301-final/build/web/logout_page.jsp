<%-- 
    Document   : logout_page
    Created on : May 28, 2026, 8:51:23 PM
    Author     : HP
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>

        <meta http-equiv="Content-Type"
              content="text/html; charset=UTF-8">

        <title>Logout</title>

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
            }

            .logout-container{
                width:500px;
                background:#111827;
                padding:40px;
                border-radius:15px;
                text-align:center;
                box-shadow:0 0 20px rgba(0,0,0,.3);
            }

            .title{
                color:white;
                font-size:32px;
                margin-bottom:20px;
            }

            .message{
                color:#9ca3af;
                margin-bottom:30px;
                font-size:18px;
            }

            .btn-login{
                display:inline-block;
                padding:14px 25px;
                background:#2563eb;
                color:white;
                text-decoration:none;
                border-radius:10px;
                transition:0.3s;
            }

            .btn-login:hover{
                background:#1d4ed8;
            }

        </style>

    </head>

    <body>

        <div class="logout-container">

            <h1 class="title">
                Đăng xuất thành công
            </h1>

            <p class="message">
                Cảm ơn bạn đã sử dụng AutoWash
            </p>

            <a href="MainController?action=home"
               class="btn-login">
                Trở về trang chủ
            </a>

        </div>

    </body>
</html>
