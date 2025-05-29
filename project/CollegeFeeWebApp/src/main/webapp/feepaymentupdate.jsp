<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.dao.FeePaymentDAO, com.model.FeePayment" %>
<%@ page import="java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Update Fee Payment</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
        <div class="container">
            <a class="navbar-brand" href="index.jsp">
                <i class="fas fa-graduation-cap"></i> College Fee Management
            </a>
            <div class="navbar-nav ms-auto">
                <a class="nav-link" href="index.jsp">Home</a>
                <a class="nav-link" href="DisplayFeePaymentsServlet">View Payments</a>
                <a class="nav-link" href="report_form.jsp">Reports</a>
            </div>
        </div>
    </nav>

    <div class="container mt-5">
        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="card">
                    <div class="card-header bg-warning text-dark">
                        <h4><i class="fas fa-edit"></i> Update Fee Payment</h4>
                    </div>
                    <div class="card-body">
                        <% 
                            int paymentId = Integer.parseInt(request.getParameter("paymentId"));
                            FeePaymentDAO dao = new FeePaymentDAO();
                            FeePayment payment = dao.selectPayment(paymentId);
                            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                        %>
                        
                        <% if (request.getParameter("error") != null) { %>
                            <div class="alert alert-danger" role="alert">
                                <%= request.getParameter("error") %>
                            </div>
                        <% } %>
                        
                        <form action="UpdateFeePaymentServlet" method="post">
                            <input type="hidden" name="paymentId" value="<%= payment.getPaymentId() %>">
                            <div class="mb-3">
                                <label for="studentId" class="form-label">Student ID</label>
                                <input type="number" class="form-control" id="studentId" name="studentId" value="<%= payment.getStudentId() %>" required>
                            </div>
                            <div class="mb-3">
                                <label for="studentName" class="form-label">Student Name</label>
                                <input type="text" class="form-control" id="studentName" name="studentName" value="<%= payment.getStudentName() %>" required>
                            </div>
                            <div class="mb-3">
                                <label for="paymentDate" class="form-label">Payment Date</label>
                                <input type="date" class="form-control" id="paymentDate" name="paymentDate" value="<%= sdf.format(payment.getPaymentDate()) %>" required>
                            </div>
                            <div class="mb-3">
                                <label for="amount" class="form-label">Amount</label>
                                <input type="number" step="0.01" class="form-control" id="amount" name="amount" value="<%= payment.getAmount() %>" required>
                            </div>
                            <div class="mb-3">
                                <label for="status" class="form-label">Status</label>
                                <select class="form-select" id="status" name="status" required>
                                    <option value="Paid" <%= "Paid".equals(payment.getStatus()) ? "selected" : "" %>>Paid</option>
                                    <option value="Overdue" <%= "Overdue".equals(payment.getStatus()) ? "selected" : "" %>>Overdue</option>
                                    <option value="Pending" <%= "Pending".equals(payment.getStatus()) ? "selected" : "" %>>Pending</option>
                                </select>
                            </div>
                            <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                                <a href="DisplayFeePaymentsServlet" class="btn btn-secondary me-md-2">Cancel</a>
                                <button type="submit" class="btn btn-warning">Update Payment</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>