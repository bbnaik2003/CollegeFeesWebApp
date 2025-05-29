package com.dao;

import com.model.FeePayment;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.math.BigDecimal;

public class FeePaymentDAO {
    private String jdbcURL = "jdbc:mysql://localhost:3306/collegefeedb";
    private String jdbcUsername = "root";
    private String jdbcPassword = "";

    private static final String INSERT_PAYMENT_SQL = "INSERT INTO FeePayments (StudentID, StudentName, PaymentDate, Amount, Status) VALUES (?, ?, ?, ?, ?)";
    private static final String SELECT_PAYMENT_BY_ID = "SELECT PaymentID, StudentID, StudentName, PaymentDate, Amount, Status FROM FeePayments WHERE PaymentID = ?";
    private static final String SELECT_ALL_PAYMENTS = "SELECT * FROM FeePayments ORDER BY PaymentDate DESC";
    private static final String DELETE_PAYMENT_SQL = "DELETE FROM FeePayments WHERE PaymentID = ?";
    private static final String UPDATE_PAYMENT_SQL = "UPDATE FeePayments SET StudentID = ?, StudentName = ?, PaymentDate = ?, Amount = ?, Status = ? WHERE PaymentID = ?";
    private static final String SELECT_OVERDUE_PAYMENTS = "SELECT * FROM FeePayments WHERE Status = 'Overdue' ORDER BY PaymentDate";
    private static final String SELECT_PAYMENTS_IN_PERIOD = "SELECT * FROM FeePayments WHERE PaymentDate BETWEEN ? AND ?";
    private static final String SELECT_TOTAL_COLLECTION = "SELECT SUM(Amount) as total FROM FeePayments WHERE PaymentDate BETWEEN ? AND ? AND Status = 'Paid'";

    protected Connection getConnection() throws SQLException {
        Connection connection = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            connection = DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);
            
            // Test the connection
            if (connection == null || connection.isClosed()) {
                throw new SQLException("Failed to establish database connection");
            }
            
        } catch (ClassNotFoundException e) {
            System.err.println("MySQL JDBC Driver not found: " + e.getMessage());
            throw new SQLException("Database driver not found", e);
        } catch (SQLException e) {
            System.err.println("Database connection failed: " + e.getMessage());
            throw new SQLException("Cannot connect to database", e);
        }
        return connection;
    }

    public void insertPayment(FeePayment payment) throws SQLException {
        if (payment == null) {
            throw new IllegalArgumentException("Payment object cannot be null");
        }
        
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        
        try {
            connection = getConnection();
            if (connection == null) {
                throw new SQLException("Database connection is null");
            }
            
            preparedStatement = connection.prepareStatement(INSERT_PAYMENT_SQL);
            preparedStatement.setInt(1, payment.getStudentId());
            preparedStatement.setString(2, payment.getStudentName());
            preparedStatement.setDate(3, new java.sql.Date(payment.getPaymentDate().getTime()));
            preparedStatement.setBigDecimal(4, payment.getAmount());
            preparedStatement.setString(5, payment.getStatus());
            
            int rowsAffected = preparedStatement.executeUpdate();
            if (rowsAffected == 0) {
                throw new SQLException("Failed to insert payment record");
            }
            
        } catch (SQLException e) {
            System.err.println("Error inserting payment: " + e.getMessage());
            throw e;
        } finally {
            closeResources(preparedStatement, connection);
        }
    }

    public FeePayment selectPayment(int paymentId) throws SQLException {
        if (paymentId <= 0) {
            throw new IllegalArgumentException("Payment ID must be positive");
        }
        
        FeePayment payment = null;
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet rs = null;
        
        try {
            connection = getConnection();
            if (connection == null) {
                throw new SQLException("Database connection is null");
            }
            
            preparedStatement = connection.prepareStatement(SELECT_PAYMENT_BY_ID);
            preparedStatement.setInt(1, paymentId);
            rs = preparedStatement.executeQuery();

            if (rs.next()) {
                int studentId = rs.getInt("StudentID");
                String studentName = rs.getString("StudentName");
                Date paymentDate = rs.getDate("PaymentDate");
                BigDecimal amount = rs.getBigDecimal("Amount");
                String status = rs.getString("Status");

                payment = new FeePayment(studentId, studentName, paymentDate, amount, status);
                payment.setPaymentId(paymentId);
            }
        } catch (SQLException e) {
            System.err.println("Error selecting payment: " + e.getMessage());
            throw e;
        } finally {
            closeResources(rs, preparedStatement, connection);
        }
        return payment;
    }

    public List<FeePayment> selectAllPayments() throws SQLException {
        List<FeePayment> payments = new ArrayList<>();
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet rs = null;
        
        try {
            connection = getConnection();
            if (connection == null) {
                throw new SQLException("Database connection is null");
            }
            
            preparedStatement = connection.prepareStatement(SELECT_ALL_PAYMENTS);
            rs = preparedStatement.executeQuery();

            while (rs.next()) {
                int paymentId = rs.getInt("PaymentID");
                int studentId = rs.getInt("StudentID");
                String studentName = rs.getString("StudentName");
                Date paymentDate = rs.getDate("PaymentDate");
                BigDecimal amount = rs.getBigDecimal("Amount");
                String status = rs.getString("Status");

                FeePayment payment = new FeePayment(studentId, studentName, paymentDate, amount, status);
                payment.setPaymentId(paymentId);
                payments.add(payment);
            }
        } catch (SQLException e) {
            System.err.println("Error selecting all payments: " + e.getMessage());
            throw e;
        } finally {
            closeResources(rs, preparedStatement, connection);
        }
        return payments;
    }

    public boolean deletePayment(int paymentId) throws SQLException {
        if (paymentId <= 0) {
            throw new IllegalArgumentException("Payment ID must be positive");
        }
        
        Connection connection = null;
        PreparedStatement statement = null;
        boolean rowDeleted = false;
        
        try {
            connection = getConnection();
            if (connection == null) {
                throw new SQLException("Database connection is null");
            }
            
            statement = connection.prepareStatement(DELETE_PAYMENT_SQL);
            statement.setInt(1, paymentId);
            rowDeleted = statement.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error deleting payment: " + e.getMessage());
            throw e;
        } finally {
            closeResources(statement, connection);
        }
        return rowDeleted;
    }

    public boolean updatePayment(FeePayment payment) throws SQLException {
        if (payment == null) {
            throw new IllegalArgumentException("Payment object cannot be null");
        }
        
        Connection connection = null;
        PreparedStatement statement = null;
        boolean rowUpdated = false;
        
        try {
            connection = getConnection();
            if (connection == null) {
                throw new SQLException("Database connection is null");
            }
            
            statement = connection.prepareStatement(UPDATE_PAYMENT_SQL);
            statement.setInt(1, payment.getStudentId());
            statement.setString(2, payment.getStudentName());
            statement.setDate(3, new java.sql.Date(payment.getPaymentDate().getTime()));
            statement.setBigDecimal(4, payment.getAmount());
            statement.setString(5, payment.getStatus());
            statement.setInt(6, payment.getPaymentId());

            rowUpdated = statement.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error updating payment: " + e.getMessage());
            throw e;
        } finally {
            closeResources(statement, connection);
        }
        return rowUpdated;
    }

    public List<FeePayment> getOverduePayments() throws SQLException {
        List<FeePayment> overduePayments = new ArrayList<>();
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet rs = null;
        
        try {
            connection = getConnection();
            if (connection == null) {
                throw new SQLException("Database connection is null");
            }
            
            preparedStatement = connection.prepareStatement(SELECT_OVERDUE_PAYMENTS);
            rs = preparedStatement.executeQuery();

            while (rs.next()) {
                int paymentId = rs.getInt("PaymentID");
                int studentId = rs.getInt("StudentID");
                String studentName = rs.getString("StudentName");
                Date paymentDate = rs.getDate("PaymentDate");
                BigDecimal amount = rs.getBigDecimal("Amount");
                String status = rs.getString("Status");

                FeePayment payment = new FeePayment(studentId, studentName, paymentDate, amount, status);
                payment.setPaymentId(paymentId);
                overduePayments.add(payment);
            }
        } catch (SQLException e) {
            System.err.println("Error getting overdue payments: " + e.getMessage());
            throw e;
        } finally {
            closeResources(rs, preparedStatement, connection);
        }
        return overduePayments;
    }

    public List<FeePayment> getPaymentsInPeriod(java.util.Date startDate, java.util.Date endDate) throws SQLException {
        if (startDate == null || endDate == null) {
            throw new IllegalArgumentException("Start date and end date cannot be null");
        }
        
        List<FeePayment> payments = new ArrayList<>();
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet rs = null;
        
        try {
            connection = getConnection();
            if (connection == null) {
                throw new SQLException("Database connection is null");
            }
            
            preparedStatement = connection.prepareStatement(SELECT_PAYMENTS_IN_PERIOD);
            preparedStatement.setDate(1, new java.sql.Date(startDate.getTime()));
            preparedStatement.setDate(2, new java.sql.Date(endDate.getTime()));
            rs = preparedStatement.executeQuery();

            while (rs.next()) {
                int paymentId = rs.getInt("PaymentID");
                int studentId = rs.getInt("StudentID");
                String studentName = rs.getString("StudentName");
                Date paymentDate = rs.getDate("PaymentDate");
                BigDecimal amount = rs.getBigDecimal("Amount");
                String status = rs.getString("Status");

                FeePayment payment = new FeePayment(studentId, studentName, paymentDate, amount, status);
                payment.setPaymentId(paymentId);
                payments.add(payment);
            }
        } catch (SQLException e) {
            System.err.println("Error getting payments in period: " + e.getMessage());
            throw e;
        } finally {
            closeResources(rs, preparedStatement, connection);
        }
        return payments;
    }

    public BigDecimal getTotalCollection(java.util.Date startDate, java.util.Date endDate) throws SQLException {
        if (startDate == null || endDate == null) {
            throw new IllegalArgumentException("Start date and end date cannot be null");
        }
        
        BigDecimal total = BigDecimal.ZERO;
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet rs = null;
        
        try {
            connection = getConnection();
            if (connection == null) {
                throw new SQLException("Database connection is null");
            }
            
            preparedStatement = connection.prepareStatement(SELECT_TOTAL_COLLECTION);
            preparedStatement.setDate(1, new java.sql.Date(startDate.getTime()));
            preparedStatement.setDate(2, new java.sql.Date(endDate.getTime()));
            rs = preparedStatement.executeQuery();

            if (rs.next()) {
                total = rs.getBigDecimal("total");
                if (total == null) total = BigDecimal.ZERO;
            }
        } catch (SQLException e) {
            System.err.println("Error getting total collection: " + e.getMessage());
            throw e;
        } finally {
            closeResources(rs, preparedStatement, connection);
        }
        return total;
    }
    
    // Helper method to close resources properly
    private void closeResources(AutoCloseable... resources) {
        for (AutoCloseable resource : resources) {
            if (resource != null) {
                try {
                    resource.close();
                } catch (Exception e) {
                    System.err.println("Error closing resource: " + e.getMessage());
                }
            }
        }
    }
}