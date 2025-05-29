package com.servlet;

import com.dao.FeePaymentDAO;
import com.model.FeePayment;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

@WebServlet("/ReportServlet")
public class ReportServlet extends HttpServlet {
    private FeePaymentDAO feePaymentDAO;

    public void init() {
        feePaymentDAO = new FeePaymentDAO();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String reportType = request.getParameter("reportType");
        
        try {
            if ("overdue".equals(reportType)) {
                List<FeePayment> overduePayments = feePaymentDAO.getOverduePayments();
                request.setAttribute("reportTitle", "Students with Overdue Payments");
                request.setAttribute("reportData", overduePayments);
                request.setAttribute("reportType", "payments");
            } else if ("period".equals(reportType)) {
                String startDateStr = request.getParameter("startDate");
                String endDateStr = request.getParameter("endDate");
                
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                Date startDate = sdf.parse(startDateStr);
                Date endDate = sdf.parse(endDateStr);
                
                List<FeePayment> paymentsInPeriod = feePaymentDAO.getPaymentsInPeriod(startDate, endDate);
                request.setAttribute("reportTitle", "Payments from " + startDateStr + " to " + endDateStr);
                request.setAttribute("reportData", paymentsInPeriod);
                request.setAttribute("reportType", "payments");
            } else if ("collection".equals(reportType)) {
                String startDateStr = request.getParameter("startDate");
                String endDateStr = request.getParameter("endDate");
                
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                Date startDate = sdf.parse(startDateStr);
                Date endDate = sdf.parse(endDateStr);
                
                BigDecimal totalCollection = feePaymentDAO.getTotalCollection(startDate, endDate);
                request.setAttribute("reportTitle", "Total Collection from " + startDateStr + " to " + endDateStr);
                request.setAttribute("totalAmount", totalCollection);
                request.setAttribute("reportType", "collection");
            }
            
            RequestDispatcher dispatcher = request.getRequestDispatcher("report_result.jsp");
            dispatcher.forward(request, response);
            
        } catch (ParseException e) {
            e.printStackTrace();
            response.sendRedirect("report_form.jsp?error=Invalid date format");
        } catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
    }
}