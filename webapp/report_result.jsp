<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.model.FeePayment, java.math.BigDecimal" %>
<%@ page import="java.text.SimpleDateFormat, java.text.NumberFormat" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Report Results</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        @media print {
            .no-print { display: none !important; }
            .navbar { display: none !important; }
        }
        .status-badge {
            font-size: 0.75em;
        }
    </style>
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark no-print">
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

    <div class="container mt-4">
        <div class="d-flex justify-content-between align-items-center mb-4 no-print">
            <h2><i class="fas fa-file-alt"></i> Report Results</h2>
            <div>
                <button onclick="window.print()" class="btn btn-primary me-2">
                    <i class="fas fa-print"></i> Print Report
                </button>
                <a href="report_form.jsp" class="btn btn-secondary">
                    <i class="fas fa-arrow-left"></i> Back to Reports
                </a>
            </div>
        </div>

        <div class="card">
            <div class="card-header bg-primary text-white">
                <h4><%= request.getAttribute("reportTitle") %></h4>
                <small>Generated on: <%= new java.util.Date() %></small>
            </div>
            <div class="card-body">
                <%
                    String reportType = (String) request.getAttribute("reportType");
                    if ("payments".equals(reportType)) {
                        List<FeePayment> reportData = (List<FeePayment>) request.getAttribute("reportData");
                        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
                %>
                    <% if (reportData != null && !reportData.isEmpty()) { %>
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
                                    </tr>
                                </thead>
                                <tbody>
                                    <% 
                                        BigDecimal totalAmount = BigDecimal.ZERO;
                                        for (FeePayment payment : reportData) { 
                                            totalAmount = totalAmount.add(payment.getAmount());
                                    %>
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
                                        </tr>
                                    <% } %>
                                </tbody>
                                <tfoot class="table-secondary">
                                    <tr>
                                        <th colspan="4">Total Records: <%= reportData.size() %></th>
                                        <th>₹<%= totalAmount %></th>
                                        <th></th>
                                    </tr>
                                </tfoot>
                            </table>
                        </div>
                    <% } else { %>
                        <div class="text-center py-5">
                            <i class="fas fa-inbox fa-3x text-muted mb-3"></i>
                            <h5 class="text-muted">No records found</h5>
                            <p class="text-muted">No data available for the selected criteria.</p>
                        </div>
                    <% } %>
                <%
                    } else if ("collection".equals(reportType)) {
                        BigDecimal totalAmount = (BigDecimal) request.getAttribute("totalAmount");
                %>
                    <div class="text-center py-5">
                        <div class="row justify-content-center">
                            <div class="col-md-6">
                                <div class="card bg-success text-white">
                                    <div class="card-body">
                                        <i class="fas fa-money-bill-wave fa-3x mb-3"></i>
                                        <h2 class="display-4">₹<%= totalAmount != null ? totalAmount : BigDecimal.ZERO %></h2>
                                        <h5>Total Collection</h5>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                <% } %>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>