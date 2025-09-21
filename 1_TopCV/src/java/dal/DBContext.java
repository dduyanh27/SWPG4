package dal;


import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBContext {
    protected Connection c;

    public DBContext() {
        try {
            String url = "jdbc:sqlserver://localhost;databaseName=topcv4;TrustServerCertificate=true;";
            String username = "sa";
            String pass = "123";
            // Thử driver cũ nếu driver mới không có
            try {
                Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            } catch (ClassNotFoundException e1) {
                try {
                    Class.forName("com.microsoft.jdbc.sqlserver.SQLServerDriver");
                } catch (ClassNotFoundException e2) {
                    throw new Exception("SQL Server JDBC Driver not found. Please add mssql-jdbc JAR to WEB-INF/lib");
                }
            }
            c = DriverManager.getConnection(url, username, pass);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void closeConnection() {
        try {
            if (c != null && !c.isClosed()) {
                c.close();
                System.out.println("Connection closed successfully.");
            }
        } catch (SQLException e) {
            System.out.println("Error closing connection: " + e.getMessage());
        }
    }
    public static void main(String[] args) {
        DBContext d = new DBContext();
    }
}
