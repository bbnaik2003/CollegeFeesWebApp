package com.servlet;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/ReportCriteriaServlet")
public class ReportCriteriaServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String reportType = request.getParameter("reportType");
        request.setAttribute("reportType", reportType);
        
        if ("dateRange".equals(reportType)) {
            request.getRequestDispatcher("report_form.jsp?type=dateRange").forward(request, response);
        } else if ("student".equals(reportType)) {
            request.getRequestDispatcher("report_form.jsp?type=student").forward(request, response);
        } else {
            // For "all" reports, we can directly call ReportServlet
            response.sendRedirect("ReportServlet?reportType=all");
        }
    }
}