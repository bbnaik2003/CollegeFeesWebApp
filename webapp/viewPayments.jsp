<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.dao.FeePaymentDAO, com.model.FeePayment, java.util.List, java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>View Payments - College Management System</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px;
        }
        
        .container {
            background: white;
            border-radius: 15px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
            padding: 30px;
            margin: 0 auto;
            max-width: 1200px;
        }
        
        .header {
            text-align: center;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 2px solid #f0f0f0;
        }
        
        .header h1 {
            color: #333;
            font-size: 2.5em;
            margin-bottom: 10px;
            font-weight: 300;
        }
        
        .header p {
            color: #666;
            font-size: 1.1em;
        }
        
        .actions {
            margin-bottom: 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 15px;
        }
        
        .btn {
            padding: 12px 25px;
            border: none;
            border-radius: 8px;
            font-size: 1em;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-block;
        }
        
        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 25px rgba(102, 126, 234, 0.3);
        }
        
        .btn-refresh {
            background: #28a745;
            color: white;
        }
        
        .btn-refresh:hover {
            background: #218838;
            transform: translateY(-2px);
        }
        
        .search-box {
            flex: 1;
            max-width: 300px;
        }
        
        .search-box input {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #e1e1e1;
            border-radius: 8px;
            font-size: 1em;
        }
        
        .search-box input:focus {
            outline: none;
            border-color: #667eea;
        }
        
        .table-container {
            overflow-x: auto;
            margin-bottom: 20px;
        }
        
        table {
            width: 100%;
            border-collapse: collapse;
            background: white;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }
        
        th, td {
            padding: 15px 20px;
            text-align: left;
            border-bottom: 1px solid #f0f0f0;
        }
        
        th {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            font-weight: 600;
            text-transform: uppercase;
            font-size: 0.9em;
            letter-spacing: 0.5px;
        }
        
        tr:hover {
            background: #f8f9fa;
        }
        
        .status {
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 0.85em;
            font-weight: 600;
            text-transform: uppercase;
        }
        
        .status-paid {
            background: #d4edda;
            color: #155724;
        }
        
        .status-pending {
            background: #fff3cd;
            color: #856404;
        }
        
        .status-overdue {
            background: #f8d7da;
            color: #721c24;
        }
        
        .status-partial {
            background: #d1ecf1;
            color: #0c5460;
        }
        
        .amount {
            font-weight: 600;
            color: #28a745;
        }
        
        .no-data {
            text-align: center;
            padding: 50px;
            color: #666;
            font-size: 1.2em;
        }
        
        .error-message {
            background: #f8d7da;
            color: #721c24;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            border: 1px solid #f5c6cb;
        }
        
        .summary {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .summary-card {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 8px;
            text-align: center;
            border: 2px solid #e9ecef;
        }
        
        .summary-card h3 {
            color: #495057;
            margin-bottom: 10px;
            font-size: 0.9em;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        .summary-card .value {
            font-size: 1.8em;
            font-weight: 700;
            color: #667eea;
        }
        
        @media (max-width: 768px) {
            .container {
                padding: 20px 15px;
            }
            
            .header h1 {
                font-size: 2em;
            }
            
            .actions {
                flex-direction: column;
                align-items: stretch;
            }
            
            .search-box {
                max-width: none;
            }
            
            th, td {
                padding: 10px 8px;
                font-size: 0.9em;
            }
            
            .summary {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>Fee Payments</h1>
            <p>View and manage all student payments</p>
        </div>
        
        <%
            FeePaymentDAO paymentDAO = new FeePaymentDAO();
            List<FeePayment> payments = null;
            String errorMessage = null;
            
            try {
                payments = paymentDAO.selectAllPayments();
            } catch (Exception e) {
                errorMessage = "Error loading payments: " + e.getMessage();
            }
        %>
        
        <div class="actions">
            <a href="addPayment.jsp" class="btn btn-primary">Add New Payment</a>
            <div class="search-box">
                <input type="text" id="searchInput" placeholder="Search by student name or ID...">
            </div>
            <button onclick="location.reload()" class="btn btn-refresh">Refresh</button>
        </div>
        
        <% if (payments != null && !payments.isEmpty()) { %>
            <div class="summary">
                <div class="summary-card">
                    <h3>Total Payments</h3>
                    <div class="value"><%= payments.size() %></div>
                </div>
                <div class="summary-card">
                    <h3>Paid</h3>
                    <div class="value">
                        <%= payments.stream().mapToInt(p -> "Paid".equals(p.getStatus()) ? 1 : 0).sum() %>
                    </div>
                </div>
                <div class="summary-card">
                    <h3>Pending</h3>
                    <div class="value">
                        <%= payments.stream().mapToInt(p -> "Pending".equals(p.getStatus()) ? 1 : 0).sum() %>
                    </div>
                </div>
                <div class="summary-card">
                    <h3>Overdue</h3>
                    <div class="value">
                        <%= payments.stream().mapToInt(p -> "Overdue".equals(p.getStatus()) ? 1 : 0).sum() %>
                    </div>
                </div>
            </div>
        <% } %>
        
        <% if (errorMessage != null) { %>
            <div class="error-message">
                <strong>Error:</strong> <%= errorMessage %>
                <br><br>
                <strong>Possible causes:</strong>
                <ul style="margin-top: 10px;">
                    <li>MySQL server is not running</li>
                    <li>Database 'college_db' does not exist</li>
                    <li>Table 'FeePayments' does not exist</li>
                    <li>Database connection credentials are incorrect</li>
                </ul>
            </div>
        <% } else if (payments == null || payments.isEmpty()) { %>
            <div class="no-data">
                <h3>No payment records found</h3>
                <p>Start by adding your first payment record</p>
                <br>
                <a href="addPayment.jsp" class="btn btn-primary">Add First Payment</a>
            </div>
        <% } else { %>
            <div class="table-container">
                <table id="paymentsTable">
                    <thead>
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
                            SimpleDateFormat sdf = new SimpleDateFormat("MMM dd, yyyy");
                            for (FeePayment payment : payments) {
                        %>
                            <tr>
                                <td><%= payment.getPaymentId() %></td>
                                <td><%= payment.getStudentId() %></td>
                                <td><%= payment.getStudentName() %></td>
                                <td><%= sdf.format(payment.getPaymentDate()) %></td>
                                <td class="amount">₹<%= String.format("%.2f", payment.getAmount()) %></td>
                                <td>
                                    <span class="status status-<%= payment.getStatus().toLowerCase() %>">
                                        <%= payment.getStatus() %>
                                    </span>
                                </td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        <% } %>
    </div>
    
    <script>
        // Search functionality
        document.getElementById('searchInput').addEventListener('keyup', function() {
            const searchTerm = this.value.toLowerCase();
            const table = document.getElementById('paymentsTable');
            const rows = table.getElementsByTagName('tbody')[0].getElementsByTagName('tr');
            
            for (let i = 0; i < rows.length; i++) {
                const studentId = rows[i].cells[1].textContent.toLowerCase();
                const studentName = rows[i].cells[2].textContent.toLowerCase();
                
                if (studentId.includes(searchTerm) || studentName.includes(searchTerm)) {
                    rows[i].style.display = '';
                } else {
                    rows[i].style.display = 'none';
                }
            }
        });
        
        // Auto-refresh every 30 seconds
        setTimeout(function() {
            location.reload();
        }, 30000);
    </script>
</body>
</html>