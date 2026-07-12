package util;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

public class DBConnection {

    private static String driver;
    private static String url;
    private static String username;
    private static String password;

    static {
        try {
            Properties props = new Properties();
            InputStream is = DBConnection.class.getClassLoader()
                    .getResourceAsStream("util/db.properties");
            if (is == null) {
                throw new RuntimeException("db.properties not found on classpath");
            }
            props.load(is);
            is.close();

            driver = props.getProperty("db.driver");
            url = props.getProperty("db.url");
            username = props.getProperty("db.username");
            password = props.getProperty("db.password");

            Class.forName(driver);
        } catch (IOException | ClassNotFoundException e) {
            throw new RuntimeException("Failed to load database configuration", e);
        }
    }

  public static Connection getConnection() throws SQLException {
    return DriverManager.getConnection(url, username, password);
}

public static void main(String[] args) {
    try {
        Connection c = getConnection();
        System.out.println("KET NOI DATABASE THANH CONG");
        c.close();
    } catch (Exception e) {
        e.printStackTrace();
    }
}

}
