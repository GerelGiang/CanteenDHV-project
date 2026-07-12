# Website Quản Lý Căn Tin Trường Học

## 1. Giới thiệu

Website quản lý căn tin trường học cho phép:

- Sinh viên đăng ký, đăng nhập, xem thực đơn, đặt món, theo dõi đơn hàng.
- Quản trị viên quản lý món ăn, danh mục, đơn hàng, tài khoản sinh viên và thống kê doanh thu.

## 2. Công nghệ sử dụng

- Backend: Java Servlet, JSP, JSTL
- Build tool: Maven
- Cơ sở dữ liệu: MySQL 8
- Application server: Apache Tomcat 9
- Java: 11 trở lên
- Kiến trúc: MVC

Lưu ý:

- Dự án đang dùng `javax.servlet`, vì vậy nên chạy với Tomcat 9.
- Không nên dùng Tomcat 10+ nếu chưa migrate sang `jakarta.servlet`.

## 3. Cấu trúc thư mục

```text
.
├── database/
│   └── canteen_db.sql
├── src/main/java/
│   ├── controller/
│   ├── dao/
│   ├── filter/
│   ├── model/
│   └── util/
│       └── db.properties
├── src/main/webapp/
│   ├── WEB-INF/
│   ├── assets/
│   ├── common/
│   ├── uploads/
│   └── views/
├── pom.xml
└── README.md
```

## 4. Hướng dẫn cài đặt và chạy bằng terminal trên Windows

Phần này đi theo đúng thứ tự:

1. Cài các phần mềm cần thiết
2. Import dữ liệu mẫu
3. Build project
4. Deploy file WAR lên Tomcat
5. Chạy ứng dụng

Lưu ý:

- Các lệnh bên dưới ưu tiên dùng PowerShell.
- Ví dụ này dùng Tomcat `9.0.120` và Maven `3.9.16`, là bản đang có trên trang chính thức vào ngày `2026-07-09`.

### 4.1. Cài JDK 11

Mở PowerShell với quyền Administrator, sau đó chạy:

```powershell
winget install -e --id EclipseAdoptium.Temurin.11.JDK
```

Kiểm tra lại:

```powershell
java -version
```

### 4.2. Tải và cấu hình Maven

Maven trên Windows là bản ZIP, cần giải nén rồi thêm vào `PATH`.

```powershell
Set-Location $env:USERPROFILE\Downloads
Invoke-WebRequest -Uri "https://dlcdn.apache.org/maven/maven-3/3.9.16/binaries/apache-maven-3.9.16-bin.zip" -OutFile "apache-maven-3.9.16-bin.zip"
Expand-Archive -Path "apache-maven-3.9.16-bin.zip" -DestinationPath "$env:USERPROFILE\tools" -Force
```

Thêm Maven vào biến môi trường cho tài khoản hiện tại:

```powershell
[Environment]::SetEnvironmentVariable("MAVEN_HOME", "$env:USERPROFILE\tools\apache-maven-3.9.16", "User")
[Environment]::SetEnvironmentVariable("Path", [Environment]::GetEnvironmentVariable("Path", "User") + ";$env:USERPROFILE\tools\apache-maven-3.9.16\bin", "User")
```

Đóng PowerShell, mở lại cửa sổ mới rồi kiểm tra:

```powershell
mvn -version
```

### 4.3. Cài MySQL Server

Tải MySQL Installer for Windows tại:

```text
https://dev.mysql.com/downloads/installer/
```

Khi cài đặt:

- Chọn MySQL Server 8.x
- Đặt mật khẩu cho tài khoản `root`
- Nếu có tùy chọn, thêm `mysql.exe` vào `PATH`

Kiểm tra service MySQL:

```powershell
Get-Service *mysql*
Start-Service MySQL80
Get-Service MySQL80
```

Nếu service trên máy bạn không tên `MySQL80`, hãy dùng đúng tên hiển thị từ lệnh `Get-Service *mysql*`.

### 4.4. Tải Apache Tomcat 9

Tải bản ZIP 64-bit của Tomcat 9 và giải nén vào thư mục user:

```powershell
Set-Location $env:USERPROFILE\Downloads
Invoke-WebRequest -Uri "https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.120/bin/apache-tomcat-9.0.120-windows-x64.zip" -OutFile "apache-tomcat-9.0.120-windows-x64.zip"
Expand-Archive -Path "apache-tomcat-9.0.120-windows-x64.zip" -DestinationPath $env:USERPROFILE -Force
Rename-Item "$env:USERPROFILE\apache-tomcat-9.0.120" "$env:USERPROFILE\tomcat9"
```

Sau khi giải nén xong, Tomcat sẽ nằm tại:

```text
%USERPROFILE%\tomcat9
```

### 4.5. Import dữ liệu mẫu

Di chuyển vào thư mục project:

```powershell
Set-Location <thư_mục_project>
```

Import file SQL bằng `cmd`:

```powershell
cmd /c "mysql -u root -p < database\canteen_db.sql"
```

Nếu `mysql` chưa có trong `PATH`, dùng đường dẫn đầy đủ:

```powershell
cmd /c "\"C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe\" -u root -p < database\canteen_db.sql"
```

File `database/canteen_db.sql` sẽ:

- Xóa database cũ nếu đã tồn tại
- Tạo lại database `canteen_db`
- Tạo bảng
- Nạp dữ liệu mẫu

### 4.6. Cấu hình kết nối database

Mở file `src/main/java/util/db.properties` và sửa lại cho phù hợp máy của bạn.

Nội dung khuyến nghị khi chạy local:

```properties
db.driver=com.mysql.cj.jdbc.Driver
db.url=jdbc:mysql://localhost:3306/canteen_db?useSSL=false&serverTimezone=Asia/Ho_Chi_Minh&characterEncoding=UTF-8&allowPublicKeyRetrieval=true
db.username=root
db.password=mật_khẩu_mysql_của_bạn
```

Lưu ý quan trọng:

- Bản mặc định trong repo đang để host là `mysql`, phù hợp hơn cho môi trường container.
- Nếu chạy local trên Windows, thường phải đổi `mysql` thành `localhost`.

### 4.7. Build project

```powershell
mvn clean package
```

Sau khi build thành công, file WAR sẽ được tạo tại:

```text
target\DHVCanteen.war
```

### 4.8. Deploy file WAR lên Tomcat

Nếu Tomcat đang chạy, dừng lại trước:

```powershell
& "$env:USERPROFILE\tomcat9\bin\shutdown.bat"
```

Xóa bản deploy cũ và copy bản mới:

```powershell
Remove-Item "$env:USERPROFILE\tomcat9\webapps\DHVCanteen" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item "$env:USERPROFILE\tomcat9\webapps\DHVCanteen.war" -Force -ErrorAction SilentlyContinue
Copy-Item ".\target\DHVCanteen.war" "$env:USERPROFILE\tomcat9\webapps\DHVCanteen.war"
```

### 4.9. Chạy Tomcat

```powershell
& "$env:USERPROFILE\tomcat9\bin\startup.bat"
```

Theo dõi file log mới nhất:

```powershell
Get-ChildItem "$env:USERPROFILE\tomcat9\logs\catalina*.log" |
Sort-Object LastWriteTime -Descending |
Select-Object -First 1 |
Get-Content -Wait
```

Truy cập hệ thống:

```text
http://localhost:8080/DHVCanteen/
```

## 5. Tài khoản demo

| Vai trò | Email | Mật khẩu |
|---|---|---|
| Admin | admin@canteen.com | admin123 |
| Sinh viên 1 | sv1@student.edu.vn | student123 |
| Sinh viên 2 | sv2@student.edu.vn | student123 |
| Sinh viên 3 | sv3@student.edu.vn | student123 |

## 6. Quy trình chạy nhanh trên Windows

Nếu bạn đã cài xong Java, Maven, MySQL, Tomcat 9 thì chỉ cần:

```powershell
Set-Location <thư_mục_project>
cmd /c "mysql -u root -p < database\canteen_db.sql"
mvn clean package
Copy-Item ".\target\DHVCanteen.war" "$env:USERPROFILE\tomcat9\webapps\DHVCanteen.war"
& "$env:USERPROFILE\tomcat9\bin\startup.bat"
```

Sau đó mở:

```text
http://localhost:8080/DHVCanteen/
```

## 7. Lỗi thường gặp

### Không kết nối được MySQL

Kiểm tra:

- MySQL service đã được start chưa
- `db.username` và `db.password` đã đúng chưa
- `db.url` đã đổi từ `mysql` sang `localhost` chưa

### Lỗi 404 khi vào `/DHVCanteen`

Kiểm tra:

- Đã copy file `target\DHVCanteen.war` vào `webapps` chưa
- Tomcat đã start chưa
- File WAR đã được giải nén thành thư mục `DHVCanteen` trong `webapps` chưa

### Lỗi port 8080 đã được sử dụng

Bạn có thể đổi port trong file:

```text
%USERPROFILE%\tomcat9\conf\server.xml
```

## 8. Ghi chú

- Đã kiểm tra build thành công bằng lệnh `mvn clean package`.
- Dự án hiện chưa có test tự động.
