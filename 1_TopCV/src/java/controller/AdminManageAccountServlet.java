package controller;

import dal.AccountDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Account;

//public class AdminManageAccountServlet extends HttpServlet {
//
//    @Override
//    protected void doGet(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//        AccountDAO accountDAO = new AccountDAO();
//        List<Account> accountList = accountDAO.getAllAccount();
//        request.setAttribute("accountList", accountList); // Truyền danh sách vào request
//        request.getRequestDispatcher("admin-manage-account.jsp").forward(request, response); // Chuyển đến JSP
//    }
//
//    @Override
//    protected void doPost(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//        doGet(request, response); // Gọi lại doGet cho POST nếu cần
//    }
//}