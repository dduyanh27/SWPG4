<%-- 
    Document   : check-email
    Created on : Sep 28, 2025, 2:07:18 PM
    Author     : ADMIN
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Check Email</title>
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
                width: 420px;
                border-radius: 12px;
                box-shadow: 0 8px 20px rgba(0,0,0,0.08);
                text-align: center;
            }
            h2 {
                margin-bottom: 15px;
            }
            h2 span {
                color: #22c55e;
                margin-right: 6px;
            }
            p {
                font-size: 14px;
                color: #555;
                line-height: 1.6;
            }
            p strong {
                color: #000;
            }
            a {
                color: #6a5acd;
                text-decoration: none;
            }
            a:hover {
                text-decoration: underline;
            }
            .back-link {
                display: block;
                margin-top: 20px;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <h2><span>✔</span>Check your email</h2>
            <p>
                If an account exists for <strong id="userEmail"></strong>, you'll get an email with instructions to reset your password.
            </p>
            <p>
                Didn’t receive the email? Check your spam folder or 
                <a href="contact.html">contact support</a>
            </p>
            <a href="/Test_ResetPassword/Admin/admin-login.jsp" class="back-link" id="backLink">← Back to Log in</a>
        </div>

        <script>
            window.addEventListener('load', function() {
                // Get email from request attribute
                const email = '${email}';
                document.getElementById("userEmail").innerText = email || "your email";
                
                // Countdown timer
                let countdown = 5;
                const backLink = document.getElementById('backLink');
                
                const timer = setInterval(function() {
                    backLink.textContent = '← Back to Log in (' + countdown + 's)';
                    countdown--;
                    
                    if (countdown < 0) {
                        clearInterval(timer);
                        window.location.href = '/Test_ResetPassword/Admin/admin-login.jsp';
                    }
                }, 1000);
            });
        </script>
    </body>
</html>

