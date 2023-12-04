import UIKit
import Flutter
import ICNFCCardReader

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    
    var methodChannel: FlutterResult?
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        let channel = FlutterMethodChannel(name: "flutter.sdk.ekyc/integrate",
                                           binaryMessenger: controller.binaryMessenger)
        
        channel.setMethodCallHandler({
            (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            // Note: this method is invoked on the UI thread.
            // Handle battery messages.
            self.methodChannel = result
            
            var idNumberCard = ""
            var birthdayCard = ""
            var expiredDateCard = ""
            
            if let info = call.arguments as? [String: String] {
                //print(self.convertToDictionary(text: info))
                // input key - get from flutter
                ICNFCSaveData.shared().sdTokenId = info["token_id"] ?? ""
                ICNFCSaveData.shared().sdTokenKey = info["token_key"] ?? ""
                ICNFCSaveData.shared().sdAuthorization = info["access_token"] ?? ""
                idNumberCard = info["card_id"] ?? ""
                birthdayCard = info["card_dob"] ?? ""
                expiredDateCard = info["card_expire_date"] ?? ""
            }
            
            DispatchQueue.main.async {
                if call.method == "navigateToNfcQrCode" {
                    self.actionOpenQRAndNFC(controller)
                } else if call.method == "navigateToScanNfc" {
                    self.actionOpenOnlyNFC(controller, idNumberCard: idNumberCard, birthdayCard: birthdayCard, expiredDateCard: expiredDateCard)
                }
            }
            
            print("channel.setMethodCallHandler")
            
        })
        
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    
    private func actionOpenQRAndNFC(_ controller: UIViewController) {
        
        // Chức năng đọc thông tin thẻ chip bằng NFC, từ iOS 13.0 trở lên
        if #available(iOS 13.0, *) {
            let objICMainNFCReader = ICMainNFCReaderRouter.createModule() as! ICMainNFCReaderViewController
            
            // Đặt giá trị DELEGATE để nhận kết quả trả về
            objICMainNFCReader.icMainNFCDelegate = self
            
            // Hiển thị màn hình trợ giúp
            objICMainNFCReader.isShowTutorial = true
            
            // Bật chức năng hiển thị nút bấm "Bỏ qua hướng dẫn" tại các màn hình hướng dẫn bằng video.
            objICMainNFCReader.isEnableGotIt = true
            
            // Thuộc tính quy định việc đọc thông tin NFC
            // - QRCode: Quét mã QR sau đó đọc thông tin thẻ Chip NFC
            // - NFCReader: Nhập thông tin cho idNumberCard, birthdayCard và expiredDateCard => sau đó đọc thông tin thẻ Chip NFC
            objICMainNFCReader.cardReaderStep = QRCode
            
            // bật chức năng tải ảnh chân dung trong CCCD
            objICMainNFCReader.isEnableUploadAvatarImage = true
            
            // Bật tính năng Matching Postcode.
            objICMainNFCReader.isGetPostcodeMatching = true
            
            // bật tính năng xác thực thẻ.
            objICMainNFCReader.isEnableVerifyChip = true
            
            // Giá trị này được truyền vào để xác định các thông tin cần để đọc. Các phần tử truyền vào là các giá trị của CardReaderValues.
            // Security Object Document (SOD, COM)
            // MRZ Code (DG1)
            // Image Base64 (DG2)
            // Security Data (DG14, DG15)
            // ** Lưu Ý: Nếu không truyền dữ liệu hoặc truyền mảng rỗng cho readingTagsNFC. SDK sẽ đọc hết các thông tin trong thẻ
            objICMainNFCReader.readingTagsNFC = [CardReaderValues.VerifyDocumentInfo.rawValue, CardReaderValues.MRZInfo.rawValue, CardReaderValues.SecurityDataInfo.rawValue]
            
            // Giá trị tên miền chính của SDK
            // Giá trị "" => gọi đến môi trường Product
            objICMainNFCReader.baseDomain = ""
            
            // Giá trị này xác định ngôn ngữ được sử dụng trong SDK.
            // - icnfc_vi: Tiếng Việt
            // - icnfc_en: Tiếng Anh
            objICMainNFCReader.languageSdk = "icekyc_vi"
            
            
            objICMainNFCReader.modalPresentationStyle = .fullScreen
            objICMainNFCReader.modalTransitionStyle = .coverVertical
            
            controller.present(objICMainNFCReader, animated: true, completion: nil)
        } else {
            // Fallback on earlier versions
        }
    }
    
    private func actionOpenOnlyNFC(_ controller: UIViewController, idNumberCard: String, birthdayCard: String, expiredDateCard: String) {
        
        // Chức năng đọc thông tin thẻ chip bằng NFC, từ iOS 13.0 trở lên
        if #available(iOS 13.0, *) {
            let objICMainNFCReader = ICMainNFCReaderRouter.createModule() as! ICMainNFCReaderViewController
            
            // Đặt giá trị DELEGATE để nhận kết quả trả về
            objICMainNFCReader.icMainNFCDelegate = self
            
            // Hiển thị màn hình trợ giúp
            objICMainNFCReader.isShowTutorial = true
            
            // Bật chức năng hiển thị nút bấm "Bỏ qua hướng dẫn" tại các màn hình hướng dẫn bằng video.
            objICMainNFCReader.isEnableGotIt = true
            
            // Thuộc tính quy định việc đọc thông tin NFC
            // - QRCode: Quét mã QR sau đó đọc thông tin thẻ Chip NFC
            // - NFCReader: Nhập thông tin cho idNumberCard, birthdayCard và expiredDateCard => sau đó đọc thông tin thẻ Chip NFC
            objICMainNFCReader.cardReaderStep = NFCReader
            // Số giấy tờ căn cước, là dãy số gồm 12 ký tự.
            objICMainNFCReader.idNumberCard = idNumberCard
            // Ngày sinh của người dùng được in trên Căn cước, có định dạng YYMMDD (ví dụ 18 tháng 5 năm 1978 thì giá trị là 780518).
            objICMainNFCReader.birthdayCard = birthdayCard
            // Ngày hết hạn của Căn cước, có định dạng YYMMDD (ví dụ 18 tháng 5 năm 2047 thì giá trị là 470518).
            objICMainNFCReader.expiredDateCard = expiredDateCard
            
            
            // bật chức năng tải ảnh chân dung trong CCCD
            objICMainNFCReader.isEnableUploadAvatarImage = true
            
            // Bật tính năng Matching Postcode.
            objICMainNFCReader.isGetPostcodeMatching = true
            
            // bật tính năng xác thực thẻ.
            objICMainNFCReader.isEnableVerifyChip = true
            
            // Giá trị này được truyền vào để xác định các thông tin cần để đọc. Các phần tử truyền vào là các giá trị của CardReaderValues.
            // Security Object Document (SOD, COM)
            // MRZ Code (DG1)
            // Image Base64 (DG2)
            // Security Data (DG14, DG15)
            // ** Lưu Ý: Nếu không truyền dữ liệu hoặc truyền mảng rỗng cho readingTagsNFC. SDK sẽ đọc hết các thông tin trong thẻ
            objICMainNFCReader.readingTagsNFC = [CardReaderValues.VerifyDocumentInfo.rawValue, CardReaderValues.MRZInfo.rawValue, CardReaderValues.SecurityDataInfo.rawValue]
            
            // Giá trị tên miền chính của SDK
            // Giá trị "" => gọi đến môi trường Product
            objICMainNFCReader.baseDomain = ""
            
            // Giá trị này xác định ngôn ngữ được sử dụng trong SDK.
            // - icnfc_vi: Tiếng Việt
            // - icnfc_en: Tiếng Anh
            objICMainNFCReader.languageSdk = "icekyc_vi"
            
            
            objICMainNFCReader.modalPresentationStyle = .fullScreen
            objICMainNFCReader.modalTransitionStyle = .coverVertical
            controller.present(objICMainNFCReader, animated: true, completion: nil)
        } else {
            // Fallback on earlier versions
        }
    }
}

extension AppDelegate: ICMainNFCReaderDelegate {
    
    func icNFCMainDismissed() {
        print("Close")
        self.methodChannel!(FlutterMethodNotImplemented)
    }
    
    func icNFCCardReaderGetResult() {
        
        // Hiển thị thông tin kết quả QUÉT QR
        print("scanQRCodeResult = \(ICNFCSaveData.shared().scanQRCodeResult)")
        
        // Hiển thị thông tin đọc thẻ chip dạng chi tiết
        print("dataNFCResult = \(ICNFCSaveData.shared().dataNFCResult)")
        
        // Hiển thị thông tin POSTCODE
        print("postcodePlaceOfOriginResult = \(ICNFCSaveData.shared().postcodePlaceOfOriginResult)")
        print("postcodePlaceOfResidenceResult = \(ICNFCSaveData.shared().postcodePlaceOfResidenceResult)")
        
        // Hiển thị thông tin xác thực C06
        print("verifyNFCCardResult = \(ICNFCSaveData.shared().verifyNFCCardResult)")
        
        // Hiển thị thông tin ảnh chân dung đọc từ thẻ
        print("imageAvatar = \(ICNFCSaveData.shared().imageAvatar)")
        print("hashImageAvatar = \(ICNFCSaveData.shared().hashImageAvatar)")
        
        // Hiển thị thông tin Client Session
        print("clientSessionResult = \(ICNFCSaveData.shared().clientSessionResult)")
        
        // Hiển thị thông tin đọc dữ liệu nguyên bản của thẻ CHIP: COM, DG1, DG2, … DG14, DG15
        print("dataGroupsResult = \(ICNFCSaveData.shared().dataGroupsResult)")
        
        var verifyNFCCardResult = ""
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: ICNFCSaveData.shared().verifyNFCCardResult, options: .prettyPrinted)
            verifyNFCCardResult = String(data: jsonData, encoding: .ascii) ?? ""
        } catch {
            print(error.localizedDescription)
        }
        
        var dataNFCResult = ""
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: ICNFCSaveData.shared().dataNFCResult, options: .prettyPrinted)
            dataNFCResult = String(data: jsonData, encoding: .ascii) ?? ""
        } catch {
            print(error.localizedDescription)
        }
        
        var postcodePlaceOfOriginResult = ""
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: ICNFCSaveData.shared().postcodePlaceOfOriginResult, options: .prettyPrinted)
            postcodePlaceOfOriginResult = String(data: jsonData, encoding: .ascii) ?? ""
        } catch {
            print(error.localizedDescription)
        }
        
        var postcodePlaceOfResidenceResult = ""
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: ICNFCSaveData.shared().postcodePlaceOfResidenceResult, options: .prettyPrinted)
            postcodePlaceOfResidenceResult = String(data: jsonData, encoding: .ascii) ?? ""
        } catch {
            print(error.localizedDescription)
        }
        
        let dict = [
            // Thông tin mã QR
            "QR_CODE_RESULT_NFC": ICNFCSaveData.shared().scanQRCodeResult,
            // Thông tin verify C06
            "CHECK_AUTH_CHIP_RESULT": verifyNFCCardResult,
            // Thông tin ẢNH chân dung
            "IMAGE_AVATAR_CARD_NFC": ICNFCSaveData.shared().pathImageAvatar.absoluteString,
            "HASH_AVATAR": ICNFCSaveData.shared().hashImageAvatar,
            // Thông tin Client Session
            "CLIENT_SESSION_RESULT": ICNFCSaveData.shared().clientSessionResult,
            // Thông tin NFC
            "LOG_NFC": dataNFCResult,
            // Thông tin postcode
            "POST_CODE_ORIGINAL_LOCATION_RESULT": postcodePlaceOfOriginResult,
            "POST_CODE_RECENT_LOCATION_RESULT": postcodePlaceOfResidenceResult
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
            let jsonString = String(data: jsonData, encoding: String.Encoding.ascii)
            self.methodChannel!(jsonString)
            
        } catch {
            print(error.localizedDescription)
            self.methodChannel!(FlutterMethodNotImplemented)
        }
        
    }
    
    
}
