package com.servlet;

import com.dao.FeePaymentDAO;
import com.model.FeePayment;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

@WebServlet("/AddFeePaymentServlet")
public class AddFeePaymentServlet extends HttpServlet {
    private FeePaymentDAO feePaymentDAO;
    
    public void init() {
        feePaymentDAO = new FeePaymentDAO();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        try {
            // Debug: Print all parameters
            System.out.println("=== DEBUG: Request Parameters ===");
            System.out.println("StudentID: " + request.getParameter("studentId"));
            System.out.println("StudentName: " + request.getParameter("studentName"));
            System.out.println("PaymentDate: " + request.getParameter("paymentDate"));
            System.out.println("Amount: " + request.getParameter("amount"));
            System.out.println("Status: " + request.getParameter("status"));
            
            // Extract and validate parameters
            String studentIdStr = request.getParameter("studentId");
            String studentName = request.getParameter("studentName");
            String paymentDateStr = request.getParameter("paymentDate");
            String amountStr = request.getParameter("amount");
            String status = request.getParameter("status");
            
            // Validation
            if (studentIdStr == null || studentIdStr.trim().isEmpty()) {
                throw new IllegalArgumentException("Student ID is required");
            }
            if (studentName == null || studentName.trim().isEmpty()) {
                throw new IllegalArgumentException("Student Name is required");
            }
            if (paymentDateStr == null || paymentDateStr.trim().isEmpty()) {
                throw new IllegalArgumentException("Payment Date is required");
            }
            if (amountStr == null || amountStr.trim().isEmpty()) {
                throw new IllegalArgumentException("Amount is required");
            }
            if (status == null || status.trim().isEmpty()) {
                throw new IllegalArgumentException("Status is required");
            }
            
            // Parse parameters
            int studentId;
            try {
                studentId = Integer.parseInt(studentIdStr.trim());
                if (studentId <= 0) {
                    throw new NumberFormatException("Student ID must be positive");
                }
            } catch (NumberFormatException e) {
                throw new IllegalArgumentException("Invalid Student ID format: " + studentIdStr);
            }
            
            BigDecimal amount;
            try {
                amount = new BigDecimal(amountStr.trim());
                if (amount.compareTo(BigDecimal.ZERO) <= 0) {
                    throw new NumberFormatException("Amount must be positive");
                }
            } catch (NumberFormatException e) {
                throw new IllegalArgumentException("Invalid Amount format: " + amountStr);
            }
            
            Date paymentDate;
            try {
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                sdf.setLenient(false);
                paymentDate = sdf.parse(paymentDateStr.trim());
            } catch (ParseException e) {
                throw new IllegalArgumentException("Invalid Date format. Use YYYY-MM-DD: " + paymentDateStr);
            }
            
            // Create FeePayment object
            FeePayment payment = new FeePayment(studentId, studentName.trim(), paymentDate, amount, status.trim());
            
            System.out.println("=== DEBUG: Payment Object Created ===");
            System.out.println("Payment: " + payment.toString()); // Assuming toString() method exists
            
            // Test database connection first
            System.out.println("=== DEBUG: Testing Database Connection ===");
            try {
                // Test with a simple select operation first
                feePaymentDAO.selectAllPayments();
                System.out.println("Database connection test: SUCCESS");
            } catch (SQLException e) {
                System.err.println("Database connection test FAILED: " + e.getMessage());
                throw new SQLException("Database connection failed during test", e);
            }
            
            // Insert payment
            System.out.println("=== DEBUG: Attempting to Insert Payment ===");
            feePaymentDAO.insertPayment(payment);
            System.out.println("Payment inserted successfully!");
            
            // Success response
            out.println("<html><body>");
            out.println("<h2>Success!</h2>");
            out.println("<p>Payment added successfully for Student ID: " + studentId + "</p>");
            out.println("<p>Student Name: " + studentName + "</p>");
            out.println("<p>Amount: $" + amount + "</p>");
            out.println("<p>Status: " + status + "</p>");
            out.println("<a href='addPayment.jsp'>Add Another Payment</a> | ");
            out.println("<a href='viewPayments.jsp'>View All Payments</a>");
            out.println("</body></html>");
            
        } catch (IllegalArgumentException e) {
            System.err.println("Validation Error: " + e.getMessage());
            out.println("<html><body>");
            out.println("<h2>Validation Error</h2>");
            out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
            out.println("<a href='addPayment.jsp'>Go Back</a>");
            out.println("</body></html>");
            
        } catch (SQLException e) {
            System.err.println("Database Error: " + e.getMessage());
            e.printStackTrace();
            out.println("<html><body>");
            out.println("<h2>Database Error</h2>");
            out.println("<p style='color:red;'>Database Error: " + e.getMessage() + "</p>");
            out.println("<p>Please check:</p>");
            out.println("<ul>");
            out.println("<li>MySQL server is running</li>");
            out.println("<li>Database 'college_db' exists</li>");
            out.println("<li>Table 'FeePayments' exists with correct structure</li>");
            out.println("<li>Database credentials are correct</li>");
            out.println("</ul>");
            out.println("<a href='addPayment.jsp'>Go Back</a>");
            out.println("</body></html>");
            
        } catch (Exception e) {
            System.err.println("Unexpected Error: " + e.getMessage());
            e.printStackTrace();
            out.println("<html><body>");
            out.println("<h2>Unexpected Error</h2>");
            out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
            out.println("<a href='addPayment.jsp'>Go Back</a>");
            out.println("</body></html>");
        } finally {
            out.close();
        }
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Redirect GET requests to the form
        response.sendRedirect("addPayment.jsp");
    }
}