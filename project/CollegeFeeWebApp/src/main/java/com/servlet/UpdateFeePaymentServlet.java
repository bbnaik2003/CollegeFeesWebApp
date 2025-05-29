package com.servlet;

import com.dao.FeePaymentDAO;
import com.model.FeePayment;

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

@WebServlet("/UpdateFeePaymentServlet")
public class UpdateFeePaymentServlet extends HttpServlet {
    private FeePaymentDAO feePaymentDAO;

    public void init() {
        feePaymentDAO = new FeePaymentDAO();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int paymentId = Integer.parseInt(request.getParameter("paymentId"));
            int studentId = Integer.parseInt(request.getParameter("studentId"));
            String studentName = request.getParameter("studentName");
            String paymentDateStr = request.getParameter("paymentDate");
            BigDecimal amount = new BigDecimal(request.getParameter("amount"));
            String status = request.getParameter("status");

            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            Date paymentDate = sdf.parse(paymentDateStr);

            FeePayment payment = new FeePayment(studentId, studentName, paymentDate, amount, status);
            payment.setPaymentId(paymentId);

            feePaymentDAO.updatePayment(payment);

            response.sendRedirect("feepaymentdisplay.jsp?success=Payment updated successfully");
        } catch (SQLException | ParseException | NumberFormatException e) {
            e.printStackTrace();
            response.sendRedirect("feepaymentupdate.jsp?error=Error updating payment");
        }
    }
}
