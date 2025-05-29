<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Generate Reports</title>
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
                <a class="nav-link active" href="report_form.jsp">Reports</a>
            </div>
        </div>
    </nav>

    <div class="container mt-5">
        <h2 class="mb-4"><i class="fas fa-chart-bar"></i> Generate Reports</h2>

        <% if (request.getParameter("error") != null) { %>
            <div class="alert alert-danger" role="alert">
                <%= request.getParameter("error") %>
            </div>
        <% } %>

        <div class="row">
            <!-- Overdue Payments Report -->
            <div class="col-md-4 mb-4">
                <div class="card h-100">
                    <div class="card-header bg-danger text-white">
                        <h5><i class="fas fa-exclamation-triangle"></i> Overdue Payments</h5>
                    </div>
                    <div class="card-body">
                        <p class="card-text">Generate a report of all students with overdue payments.</p>
                        <form action="ReportServlet" method="post">
                            <input type="hidden" name="reportType" value="overdue">
                            <button type="submit" class="btn btn-danger w-100">Generate Report</button>
                        </form>
                    </div>
                </div>
            </div>

            <!-- Payments in Period Report -->
            <div class="col-md-4 mb-4">
                <div class="card h-100">
                    <div class="card-header bg-info text-white">
                        <h5><i class="fas fa-calendar-alt"></i> Payments in Period</h5>
                    </div>
                    <div class="card-body">
                        <p class="card-text">Generate a report of payments within a specific date range.</p>
                        <form action="ReportServlet" method="post">
                            <input type="hidden" name="reportType" value="period">
                            <div class="mb-3">
                                <label for="startDate1" class="form-label">Start Date</label>
                                <input type="date" class="form-control" id="startDate1" name="startDate" required>
                            </div>
                            <div class="mb-3">
                                <label for="endDate1" class="form-label">End Date</label>
                                <input type="date" class="form-control" id="endDate1" name="endDate" required>
                            </div>
                            <button type="submit" class="btn btn-info w-100">Generate Report</button>
                        </form>
                    </div>
                </div>
            </div>

            <!-- Total Collection Report -->
            <div class="col-md-4 mb-4">
                <div class="card h-100">
                    <div class="card-header bg-success text-white">
                        <h5><i class="fas fa-dollar-sign"></i> Total Collection</h5>
                    </div>
                    <div class="card-body">
                        <p class="card-text">Generate a report of total fee collection within a date range.</p>
                        <form action="ReportServlet" method="post">
                            <input type="hidden" name="reportType" value="collection">
                            <div class="mb-3">
                                <label for="startDate2" class="form-label">Start Date</label>
                                <input type="date" class="form-control" id="startDate2" name="startDate" required>
                            </div>
                            <div class="mb-3">
                                <label for="endDate2" class="form-label">End Date</label>
                                <input type="date" class="form-control" id="endDate2" name="endDate" required>
                            </div>
                            <button type="submit" class="btn btn-success w-100">Generate Report</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>