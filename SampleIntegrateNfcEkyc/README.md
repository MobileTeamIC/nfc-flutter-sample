# ekyc-android-sample
Dự án mẫu thực hiện việc tích hợp SDK VNPT NFC cho ứng dụng di động (Android)

## Hướng dẫn cài đặt
## Quan trọng: Liên hệ với chúng tôi qua trang web: [https://ekyc.vnpt.vn/vi]() hoặc email **vnptai@vnpt.vn** để có thể lấy được các token và sdk, nếu không app sẽ không chạy được

## Hướng dẫn cài đặt
### Bước 1: Cài đặt Android Studio
- Tải Android Studio tại [đây](https://developer.android.com/studio)
- Cài đặt Android Studio theo hướng dẫn trên trang web
### Bước 2: Tải mã nguồn
- Tải mã nguồn dự án về máy tính của bạn bằng cách sử dụng lệnh sau trong terminal:
```bash
git clone ...
```
### Bước 3: Mở dự án trong Android Studio
- Mở Android Studio và chọn "Open an existing Android Studio project"
- Chọn thư mục chứa mã nguồn dự án mà bạn đã tải về
- Chờ Android Studio tải các phụ thuộc và cấu hình dự án
- Nếu bạn gặp lỗi về phiên bản Gradle, hãy kiểm tra tệp `gradle-wrapper.properties` trong thư mục `gradle/wrapper` và đảm bảo rằng phiên bản Gradle tương thích với phiên bản Android Studio của bạn
- Lưu ý: Sử dụng Java 11/17 và phiên bản Flutter > 3.0.0 để build dự án v

### Bước 4: Cấu hình thiết bị
- Kết nối thiết bị Android của bạn với máy tính qua cáp USB
- Bật chế độ "USB Debugging" trên thiết bị Android của bạn
- Mở Android Studio và chọn thiết bị của bạn từ danh sách thiết bị ảo hoặc thiết bị thật
- Nếu bạn chưa cài đặt trình điều khiển USB cho thiết bị của mình, hãy làm theo hướng dẫn trên trang web của nhà sản xuất thiết bị để cài đặt trình điều khiển

### Bước 5 (quan trọng): Cấu hình ứng dụng
- Khách hàng sẽ đăng nhập bằng tài khoản trên landing page
- Truy cập vào mục "Quản lý Token" ở cột bên trái và lấy các giá trị token
- Để ý hộp nhỏ ở góc trên bên phải màn hình để chọn đúng dịch vụ
- Thay token vào các giá trị tương ứng trong class main.dart
- **Chú ý**: Mỗi chức năng sẽ đều cần người dùng tự truyền token, nên người dùng cần truyền token vào mọi hàm gọi chức năng trong main.dart
- **Chú ý**: AccessToken sẽ sử dụng API để refresh định kì

### Bước 6: Chạy ứng dụng
- Nhấn nút "Run" (hình tam giác màu xanh) trong Android Studio để biên dịch và chạy ứng dụng trên thiết bị của bạn
- Chờ cho ứng dụng được cài đặt và khởi động trên thiết bị
- Khi ứng dụng đã chạy, bạn có thể thử nghiệm các tính năng của nó bằng cách sử dụng NFC trên thiết bị của bạn