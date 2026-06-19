<!DOCTYPE html>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="dto.Customer"%>
<%
    Customer loggedUser = (Customer) session.getAttribute("USER");
    boolean isAdmin = (loggedUser != null && loggedUser.getEmail().equals("admin@admin.com"));
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>AutoWash</title>
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
                color:white;
            }
            .navbar{
                width:100%;
                padding:20px 80px;
                display:flex;
                justify-content:space-between;
                align-items:center;
                background:#111827;
            }
            .logo{
                font-size:30px;
                font-weight:700;
                color:#60a5fa;
            }
            .nav-links a{
                color:white;
                text-decoration:none;
                margin-left:20px;
                font-size:17px;
                transition:.3s;
            }
            .nav-links a:hover{
                color:#60a5fa;
            }
            .hero{
                display:flex;
                justify-content:center;
                align-items:center;
                flex-direction:column;
                text-align:center;
                height:85vh;
                padding:20px;
            }
            .hero h1{
                font-size:60px;
                margin-bottom:20px;
            }
            .hero p{
                font-size:20px;
                color:#9ca3af;
                max-width:700px;
                line-height:1.6;
                margin-bottom:35px;
            }
            .hero-buttons{
                display:flex;
                gap:20px;
            }
            .btn{
                padding:15px 30px;
                border-radius:10px;
                text-decoration:none;
                font-size:18px;
                transition:.3s;
            }
            .btn-login{
                background:#2563eb;
                color:white;
            }
            .btn-login:hover{
                background:#1d4ed8;
            }
            .btn-register{
                background:#22c55e;
                color:white;
            }
            .btn-register:hover{
                background:#16a34a;
            }
            .btn-admin{
                background:#7c3aed;
                color:white;
            }
            .btn-admin:hover{
                background:#6d28d9;
            }
            .features{
                padding:60px 80px;
                display:grid;
                grid-template-columns:repeat(auto-fit,minmax(250px,1fr));
                gap:25px;
            }
            .feature-card{
                background:#111827;
                padding:30px;
                border-radius:15px;
                text-align:center;
            }
            .feature-card h3{
                margin-bottom:15px;
                color:#60a5fa;
            }
            .feature-card p{
                color:#9ca3af;
                line-height:1.6;
            }
            @media(max-width:768px){
                .navbar{
                    padding:20px;
                    flex-direction:column;
                    gap:15px;
                }
                .hero h1{
                    font-size:42px;
                }
                .hero p{
                    font-size:18px;
                }
                .hero-buttons{
                    flex-direction:column;
                }
                .features{
                    padding:40px 20px;
                }
            }
        </style>
    </head>
    <body>
        <div class="navbar">
            <div class="logo">AutoWash Machine</div>
            <div class="nav-links">
                <a href="MainController?action=home">Home</a>
                <% if (loggedUser == null) { %>
                <a href="MainController?action=loginPage">Login</a>
                <a href="MainController?action=registerPage">Register</a>
                <% } else { %>
                <a href="MainController?action=logout">Logout</a>
                <% } %>
            </div>
        </div>

        <div class="hero">
            <h1>Smart Car Wash System</h1>
            <div class="hero-buttons">
                <% if (loggedUser == null) { %>
                <a href="MainController?action=loginPage" class="btn btn-login">Login</a>
                <a href="MainController?action=registerPage" class="btn btn-register">Register</a>
                <% } else if (isAdmin) { %>
                <a href="AdminController?action=listCustomers" class="btn btn-admin">&#128100; Admin Dashboard</a>
                <% } else { %>
                <a href="MainController?action=dashboard" class="btn btn-login">My Dashboard</a>
                <% } %>
            </div>
        </div>

        <script>
            function closeModal() {
                document.getElementById("successModal").style.display = "none";
            }
        </script>
        <%
            Boolean loginSuccess = (Boolean) session.getAttribute("LOGIN_SUCCESS");
            if (loginSuccess != null && loginSuccess) {
        %>
        <div id="successModal" style="display:flex;position:fixed;top:0;left:0;width:100%;height:100%;background:rgba(0,0,0,.6);justify-content:center;align-items:center;z-index:999">
            <div style="background:#111827;padding:40px;border-radius:20px;text-align:center;min-width:320px">
                <div style="font-size:48px;margin-bottom:16px">&#10003;</div>
                <h2 style="color:white;margin-bottom:10px">Đăng nhập thành công!</h2>
                <% if (isAdmin) { %>
                <p style="color:#9ca3af;margin-bottom:24px">Xin chào Admin!</p>
                <% } else {%>
                <p style="color:#9ca3af;margin-bottom:24px">Xin chào <%= loggedUser != null ? loggedUser.getFullname() : ""%>!</p>
                <% } %>
                <button onclick="closeModal()" style="background:#2563eb;color:white;border:none;padding:12px 24px;border-radius:10px;cursor:pointer;font-size:16px">OK</button>
            </div>
        </div>
        <script>
            window.onload = function () {
                document.getElementById("successModal").style.display = "flex";
            };
        </script>
        <%
                session.removeAttribute("LOGIN_SUCCESS");
            }
        %>
    </body>
</html>
