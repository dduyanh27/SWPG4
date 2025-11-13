package controller.jobseeker;

import dal.RecruiterDAO;
import model.Recruiter;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "CompanyCultureServlet", urlPatterns = {"/company-culture"})
public class CompanyCultureServlet extends HttpServlet {

    private RecruiterDAO recruiterDAO;

    @Override
    public void init() throws ServletException {
        recruiterDAO = new RecruiterDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Lấy tham số tìm kiếm và lọc từ request
        String searchQuery = request.getParameter("search");
        String categoryFilter = request.getParameter("category");
        
        // Xử lý searchQuery: trim và replace nhiều dấu cách thành 1
        if (searchQuery != null && !searchQuery.trim().isEmpty()) {
            searchQuery = searchQuery.trim().replaceAll("\\s+", " ");
        }
        
        List<Recruiter> companies;

        boolean hasSearch = searchQuery != null && !searchQuery.trim().isEmpty();
        boolean hasCategory = categoryFilter != null && !categoryFilter.trim().isEmpty() && !"0".equals(categoryFilter);

        if (hasSearch && hasCategory) {
            // Kết hợp: tìm theo cả tên và danh mục
            int categoryId = Integer.parseInt(categoryFilter);
            companies = recruiterDAO.searchCompaniesByNameAndCategoryWithJobCount(searchQuery, categoryId);
        } else if (hasSearch && !hasCategory) {
            // Tìm theo tên kèm job count
            companies = recruiterDAO.searchCompaniesByNameWithJobCount(searchQuery);
        } else if (!hasSearch && hasCategory) {
            // Lọc theo danh mục kèm job count
            int categoryId = Integer.parseInt(categoryFilter);
            companies = recruiterDAO.getRecruitersByCategoryWithJobCount(categoryId);
        } else {
            // Mặc định: lấy tất cả kèm job count
            companies = recruiterDAO.getAllRecruitersWithJobCount();
        }
        
        // Đếm số lượng công ty
        int totalCompanies = companies.size();
        
        // Set attributes để truyền sang JSP
        request.setAttribute("companies", companies);
        request.setAttribute("totalCompanies", totalCompanies);
        request.setAttribute("searchQuery", searchQuery);
        request.setAttribute("categoryFilter", categoryFilter);
        
        // Forward đến JSP (đường dẫn tuyệt đối từ context root)
        request.getRequestDispatcher("/JobSeeker/company-culture-template.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
