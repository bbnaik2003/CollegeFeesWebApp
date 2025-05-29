<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.model.FeePayment, com.dao.FeePaymentDAO" %>
<%@ page import="java.text.SimpleDateFormat, java.text.NumberFormat" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Fee Payments Display</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .status-badge {
            font-size: 0.75em;
        }
        .table-responsive {
            border-radius: 0.5rem;
            overflow: hidden;
        }
    </style>
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
        <div class="container">
            <a class="navbar-brand" href="index.jsp">
                <i class="fas fa-graduation-cap"></i> College Fee Management
            </a>
            <div class="navbar-nav ms-auto">
                <a class="nav-link" href="index.jsp">Home</a>
                <a class="nav-link active" href="DisplayFeePaymentsServlet">View Payments</a>
                <a class="nav-link" href="report_form.jsp">Reports</a>
            </div>
        </div>
    </nav>

    <div class="container mt-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2><i class="fas fa-list"></i> Fee Payment Records</h2>
            <a href="feepaymentadd.jsp" class="btn btn-success">
                <i class="fas fa-plus"></i> Add New Payment
            </a>
        </div>

        <% if (request.getParameter("success") != null) { %>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="fas fa-check-circle"></i> <%= request.getParameter("success") %>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>

        <% if (request.getParameter("error") != null) { %>
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="fas fa-exclamation-circle"></i> <%= request.getParameter("error") %>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>

        <%
            List<FeePayment> listPayments = (List<FeePayment>) request.getAttribute("listPayments");
            if (listPayments == null) {
                FeePaymentDAO dao = new FeePaymentDAO();
                listPayments = dao.selectAllPayments();
            }
            SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
            NumberFormat nf = NumberFormat.getCurrencyInstance();
        %>

        <div class="card">
            <div class="card-body">
                <% if (listPayments != null && !listPayments.isEmpty()) { %>
                    <div class="table-responsive">
                        <table class="table table-striped table-hover">
                            <thead class="table-dark">
                                <tr>
                                    <th>Payment ID</th>
                                    <th>Student ID</th>
                                    <th>Student Name</th>
                                    <th>Payment Date</th>
                                    <th>Amount</th>
                                    <th>Status</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (FeePayment payment : listPayments) { %>
                                    <tr>
                                        <td><%= payment.getPaymentId() %></td>
                                        <td><%= payment.getStudentId() %></td>
                                        <td><%= payment.getStudentName() %></td>
                                        <td><%= sdf.format(payment.getPaymentDate()) %></td>
                                        <td>₹<%= payment.getAmount() %></td>
                                        <td>
                                            <% if ("Paid".equals(payment.getStatus())) { %>
                                                <span class="badge bg-success status-badge">Paid</span>
                                            <% } else if ("Overdue".equals(payment.getStatus())) { %>
                                                <span class="badge bg-danger status-badge">Overdue</span>
                                            <% } else { %>
                                                <span class="badge bg-warning status-badge">Pending</span>
                                            <% } %>
                                        </td>
                                        <td>
                                            <a href="feepaymentupdate.jsp?paymentId=<%= payment.getPaymentId() %>" 
                                               class="btn btn-sm btn-warning me-1">
                                                <i class="fas fa-edit"></i>
                                            </a>
                                            <a href="DeleteFeePaymentServlet?paymentId=<%= payment.getPaymentId() %>" 
                                               class="btn btn-sm btn-danger"
                                               onclick="return confirm('Are you sure you want to delete this payment record?')">
                                                <i class="fas fa-trash"></i>
                                            </a>
                                        </td>
                                    </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                <% } else { %>
                    <div class="text-center py-5">
                        <i class="fas fa-inbox fa-3x text-muted mb-3"></i>
                        <h5 class="text-muted">No payment records found</h5>
                        <p class="text-muted">Start by adding a new fee payment record.</p>
                        <a href="feepaymentadd.jsp" class="btn btn-success">
                            <i class="fas fa-plus"></i> Add First Payment
                        </a>
                    </div>
                <% } %>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>