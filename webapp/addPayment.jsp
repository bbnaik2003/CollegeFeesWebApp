<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Fee Payment - College Management System</title>
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
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }
        
        .container {
            background: white;
            border-radius: 15px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
            padding: 40px;
            width: 100%;
            max-width: 600px;
        }
        
        .header {
            text-align: center;
            margin-bottom: 30px;
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
        
        .form-group {
            margin-bottom: 25px;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #333;
            font-size: 1.1em;
        }
        
        .form-group input,
        .form-group select {
            width: 100%;
            padding: 15px;
            border: 2px solid #e1e1e1;
            border-radius: 8px;
            font-size: 1em;
            transition: all 0.3s ease;
            background: #f8f9fa;
        }
        
        .form-group input:focus,
        .form-group select:focus {
            outline: none;
            border-color: #667eea;
            background: white;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }
        
        .form-group input[type="number"]::-webkit-outer-spin-button,
        .form-group input[type="number"]::-webkit-inner-spin-button {
            -webkit-appearance: none;
            margin: 0;
        }
        
        .form-group input[type="number"] {
            -moz-appearance: textfield;
        }
        
        .btn-container {
            display: flex;
            gap: 15px;
            margin-top: 30px;
        }
        
        .btn {
            flex: 1;
            padding: 15px 25px;
            border: none;
            border-radius: 8px;
            font-size: 1.1em;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            text-align: center;
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
        
        .btn-secondary {
            background: #f8f9fa;
            color: #333;
            border: 2px solid #e1e1e1;
        }
        
        .btn-secondary:hover {
            background: #e9ecef;
            transform: translateY(-2px);
        }
        
        .required {
            color: #e74c3c;
        }
        
        .form-row {
            display: flex;
            gap: 20px;
        }
        
        .form-row .form-group {
            flex: 1;
        }
        
        @media (max-width: 768px) {
            .container {
                padding: 30px 20px;
            }
            
            .header h1 {
                font-size: 2em;
            }
            
            .form-row {
                flex-direction: column;
                gap: 0;
            }
            
            .btn-container {
                flex-direction: column;
            }
        }
        
        .info-box {
            background: #e3f2fd;
            border: 1px solid #bbdefb;
            border-radius: 8px;
            padding: 15px;
            margin-bottom: 25px;
        }
        
        .info-box h3 {
            color: #1976d2;
            margin-bottom: 10px;
            font-size: 1.1em;
        }
        
        .info-box p {
            color: #1565c0;
            margin: 5px 0;
            font-size: 0.95em;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>Add Fee Payment</h1>
            <p>Enter student payment details</p>
        </div>
        
        <div class="info-box">
            <h3>Payment Information</h3>
            <p>• All fields marked with <span class="required">*</span> are required</p>
            <p>• Enter amount in decimal format (e.g., 1000.50)</p>
            <p>• Use YYYY-MM-DD format for date</p>
        </div>
        
        <form action="AddFeePaymentServlet" method="post" id="paymentForm">
            <div class="form-row">
                <div class="form-group">
                    <label for="studentId">
                        Student ID <span class="required">*</span>
                    </label>
                    <input 
                        type="number" 
                        id="studentId" 
                        name="studentId" 
                        required 
                        min="1"
                        placeholder="Enter student ID"
                    >
                </div>
                
                <div class="form-group">
                    <label for="studentName">
                        Student Name <span class="required">*</span>
                    </label>
                    <input 
                        type="text" 
                        id="studentName" 
                        name="studentName" 
                        required 
                        maxlength="100"
                        placeholder="Enter student full name"
                    >
                </div>
            </div>
            
            <div class="form-row">
                <div class="form-group">
                    <label for="paymentDate">
                        Payment Date <span class="required">*</span>
                    </label>
                    <input 
                        type="date" 
                        id="paymentDate" 
                        name="paymentDate" 
                        required
                    >
                </div>
                
                <div class="form-group">
                    <label for="amount">
                        Amount ($) <span class="required">*</span>
                    </label>
                    <input 
                        type="number" 
                        id="amount" 
                        name="amount" 
                        required 
                        min="0.01" 
                        step="0.01"
                        placeholder="0.00"
                    >
                </div>
            </div>
            
            <div class="form-group">
                <label for="status">
                    Payment Status <span class="required">*</span>
                </label>
                <select id="status" name="status" required>
                    <option value="">Select payment status</option>
                    <option value="Paid">Paid</option>
                    <option value="Pending">Pending</option>
                    <option value="Overdue">Overdue</option>
                    <option value="Partial">Partial</option>
                </select>
            </div>
            
            <div class="btn-container">
                <button type="submit" class="btn btn-primary">
                    Add Payment
                </button>
                <a href="viewPayments.jsp" class="btn btn-secondary">
                    View All Payments
                </a>
            </div>
        </form>
    </div>
    
    <script>
        // Set today's date as default
        document.getElementById('paymentDate').valueAsDate = new Date();
        
        // Form validation
        document.getElementById('paymentForm').addEventListener('submit', function(e) {
            const studentId = document.getElementById('studentId').value;
            const studentName = document.getElementById('studentName').value.trim();
            const amount = document.getElementById('amount').value;
            const status = document.getElementById('status').value;
            
            if (!studentId || studentId <= 0) {
                alert('Please enter a valid Student ID');
                e.preventDefault();
                return;
            }
            
            if (!studentName) {
                alert('Please enter Student Name');
                e.preventDefault();
                return;
            }
            
            if (!amount || parseFloat(amount) <= 0) {
                alert('Please enter a valid amount greater than 0');
                e.preventDefault();
                return;
            }
            
            if (!status) {
                alert('Please select a payment status');
                e.preventDefault();
                return;
            }
            
            // Confirm submission
            if (!confirm('Are you sure you want to add this payment record?')) {
                e.preventDefault();
            }
        });
        
        // Format amount input
        document.getElementById('amount').addEventListener('blur', function() {
            if (this.value) {
                this.value = parseFloat(this.value).toFixed(2);
            }
        });
        
        // Auto-capitalize student name
        document.getElementById('studentName').addEventListener('input', function() {
            this.value = this.value.replace(/\b\w/g, function(txt) {
                return txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase();
            });
        });
    </script>
</body>
</html>