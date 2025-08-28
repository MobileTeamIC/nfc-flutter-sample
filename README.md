# NFC Flutter Sample

Dự án mẫu thực hiện việc tích hợp SDK Đọc thông tin thẻ chip bằng công nghệ NFC cho ứng dụng di động (Flutter)

## Lưu ý quan trọng

**Quan trọng**: Liên hệ với chúng tôi qua trang web: [https://ekyc.vnpt.vn/vi](https://ekyc.vnpt.vn/vi) hoặc email **vnptai@vnpt.vn** để có thể lấy được các token và SDK, nếu không app sẽ không chạy được.

**Lưu ý**: Ứng dụng này sử dụng FVM version 3.29.2

## Yêu cầu trước khi bắt đầu

- Flutter SDK >= 3.0.0
- Dart SDK >= 2.19.6
- Android Studio / Xcode
- Thiết bị Android/iOS hỗ trợ NFC
- Java 11/17 cho Android development
- Hien dang su dung FVM Flutter 3.29.2
## Cài đặt & Tích hợp SDK

### Tích hợp SDK iOS

#### Bước 1: Tạo thư mục SDK
- Điều hướng đến thư mục dự án iOS: `ios/Runner/`
- Tạo một thư mục mới tên `SDK` (nếu chưa có)
- Thư mục này sẽ chứa tất cả các framework SDK iOS

#### Bước 2: Thêm SDK Frameworks
Kéo thả các framework SDK sau vào thư mục `SDK`:
- `ICNFCCardReader.xcframework` - SDK đọc thẻ NFC
- `OpenSSL.xcframework` - Thư viện OpenSSL

#### Bước 3: Cấu hình Dự án Xcode
1. Mở dự án trong Xcode: `ios/Runner.xcworkspace`
2. Chọn dự án trong navigator
3. Chọn target `Runner`
4. Vào tab **General** → **Frameworks, Libraries, and Embedded Content**
5. Nhấn nút **+** và thêm các framework từ thư mục `SDK`
6. Đặt **Embed** thành "Embed & Sign" cho mỗi framework

### Tích hợp SDK Android

#### Bước 1: Thêm file AAR SDK
1. Điều hướng đến thư mục dự án Android: `android/`
2. Tạo các thư mục sau nếu chưa có:
   - `android/nfc/` - Chứa SDK NFC
   - `android/scanqr/` - Chứa SDK Scan QR (nếu cần)

#### Bước 2: Thêm SDK files
- Copy file `vnpt_nfc_sdk-release-v1.7.8.aar` vào thư mục `android/nfc/`
- Copy file `scanqr_ic_sdk-release-v1.0.5.aar` vào thư mục `android/scanqr/` (nếu cần)

#### Bước 3: Cấu hình build.gradle
Cập nhật file `android/settings.gradle`:

```gradle
include ':app'
include ':nfc'
include ':scanqr'
```

Cập nhật file `android/app/build.gradle`:

```gradle
dependencies {
    implementation project(':nfc')
    implementation project(':scanqr')
    // ... other dependencies
}
```


## Chạy ứng dụng

### Bước 1: Cài đặt dependencies
```bash
cd SampleIntegrateNfcEkyc
fvm flutter pub get
```
## Cấu trúc dự án

```
SampleIntegrateNfcEkyc/
├── lib/
│   ├── main.dart                 # Entry point
│   ├── ekyc_nfc_screen.dart      # Màn hình chính NFC
│   ├── log_screen.dart           # Màn hình log
│   └── services/
│       ├── nfc_config.dart       # Cấu hình NFC
│       ├── nfc_method_channel.dart # Method channel cho NFC
│       └── nfc_presentation.dart # Presentation layer
├── android/
│   ├── nfc/                      # SDK NFC Android
│   └── scanqr/                   # SDK Scan QR Android
├── ios/
│   └── Runner/
│       └── SDK/                  # SDK iOS
└── assets/
    └── config/                   # Cấu hình
```

## Hỗ trợ

Nếu gặp vấn đề, vui lòng liên hệ:
- Website: [https://ekyc.vnpt.vn/vi](https://ekyc.vnpt.vn/vi)
- Email: vnptai@vnpt.vn

## License

Dự án này được phát triển bởi VNPT AI Team.
