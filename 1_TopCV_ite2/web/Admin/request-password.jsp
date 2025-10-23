<%-- 
    Document   : request-password
    Created on : Sep 28, 2025, 11:13:09 AM
    Author     : ADMIN
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Forgot Password</title>
        <style>
            :root{
                --bg-left:#061f3b;
                --bg-right:#0a67ff;
            }
            body {
                display: flex;
                justify-content: center;
                align-items: center;
                height: 100vh;
                background: linear-gradient(90deg, var(--bg-left) 0%, var(--bg-right) 100%) !important;
                font-family: 'Inter', sans-serif;
            }
            .container {
                background: #fff;
                padding: 40px;
                width: 380px;
                border-radius: 12px;
                box-shadow: 0 8px 20px rgba(0,0,0,0.08);
                text-align: center;
            }
            .container h2 {
                margin-bottom: 15px;
            }
            input {
                width: 100%;
                padding: 12px;
                border: 1px solid #ccc;
                border-radius: 8px;
                margin-bottom: 20px;
            }
            button {
                width: 100%;
                padding: 12px;
                background: #6a5acd;
                color: white;
                border: none;
                border-radius: 8px;
                cursor: pointer;
            }
            button:hover {
                background: #5a4abc;
            }
            .back-link {
                display: block;
                margin-top: 20px;
                font-size: 14px;
                color: #6a5acd;
                text-decoration: none;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <h2>Forgot your password?</h2>
            <p>Enter email address to receive password reset link</p>
            <form action="/Test_ResetPassword/requestPassword" method="POST">
                <input type="hidden" name="userType" value="admin">
                <input type="email" name="email" placeholder="Email" required>
                <button type="submit">Reset password</button>
            </form>
            <a href="admin-login.jsp" class="back-link">← Back to Log in</a>
        </div>

        <div style="color: red; margin-top: 10px;">${mess}</div>
    </body>
</html>

