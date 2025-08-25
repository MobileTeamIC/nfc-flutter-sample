//
//  ICMainNFCReaderProtocols.h
//  ICNFCCardReader
//
//  Created by Minh Minh iOS on 02/07/2021.
//  Copyright © 2021 Innovation Center - VNPT IT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    QRCode,     // Quét mã QR sau đó thực hiện đọc thông tin bằng NFC
    MRZCode,    // Quét mã MRZ sau đó thực hiện đọc thông tin bằng NFC
    NFCReader,  // Đọc thông tin bằng NFC
    NFCOutside, // Đọc thông tin bằng NFC ngay tại Ứng dụng (không mở SDK)
} ReaderCardMode; // Định nghĩa luồng thực hiện đọc thông tin thẻ căn cước


typedef NS_ENUM(NSInteger, CardReaderValues) {
    VerifyDocumentInfo      = 100019,       // Security Object Document (SOD)
    MRZInfo                 = 100020,       // MRZ Code (DG1)
    ImageAvatarInfo         = 100021,       // Image Base64 (DG2)
    SecurityDataInfo        = 100022,       // Security Data (DG14, DG15)
};


typedef enum : NSUInteger {
    ICNFCStarted,       // Trạng thái bắt đầu lắng nghe
    ICNFCDidDetect,     // Trạng thái xác định được tín hiệu đọc thẻ căn cước
    ICNFCReading,       // Trạng thái đang đọc thẻ căn cước
    ICNFCDidError,      // Trạng thái đọc thẻ căn cước bị lỗi
    ICNFCCompleted   // Trạng thái hoàn thành đọc thẻ căn cước 
} ICNFCReaderState;


typedef enum : NSUInteger {
    ASNone,         // Không thực hiện xác thực CA AA
    ASSuccess,      // Xác thực CA hoặc AA THÀNH CÔNG
    ASFailed,       // Xác thực CA hoặc AA KHÔNG THÀNH CÔNG
} ICNFCAuthenticationStatus;


typedef enum : NSUInteger {
    ICNFCHelpQRCode,        // Hướng dẫn quét mã QR
    ICNFCScanQRCode,        // Quét mã QR
    ICNFCHelpMRZCode,       // Hướng dẫn quét mã MRZ
    ICNFCScanMRZCode,       // Quét mã MRZ
    ICNFCReaderNFC          // Đọc thông tin NFC
} ICNFCLastStep; // Xác định các giá trị của bước cuối cùng khi người dùng thoát SDK


// Nút đóng SDK trên thanh tiêu đề
typedef enum : NSUInteger {
    LeftButton,     // nút đóng bên trái
    RightButton,    // nút đóng bên phải.
} ModeButtonHeaderBar;


#pragma mark - WireFrameProtocol

@protocol ICMainNFCReaderWireframeProtocol <NSObject>

- (void) presentICPopupWarningWithTitle:(NSString *)title content:(NSString *)content;

@end

#pragma mark - ICMainNFCReaderPresenterProtocol

@protocol ICMainNFCReaderPresenterProtocol <NSObject>

@end

#pragma mark - ICMainNFCReaderInteractorProtocol

@protocol ICMainNFCReaderInteractorOutputProtocol <NSObject>

/** Interactor -> Presenter */

- (void) sendResultUploadSucceedAvatarImage:(NSString *)hash;

- (void) sendResultUploadDataNFCSucceed:(NSDictionary *)data;

- (void) sendResultGetPostcodeMatchingPlaceOfOriginSucceed:(NSDictionary *)data;

- (void) sendResultGetPostcodeMatchingPlaceOfResidenceSucceed:(NSDictionary *)data;


@end

@protocol ICMainNFCReaderInteractorInputProtocol <NSObject>

- (void)setOutput:(id<ICMainNFCReaderInteractorOutputProtocol>)output;
- (id<ICMainNFCReaderInteractorOutputProtocol>)getOutputProtocol;

/** Presenter -> Interactor */
- (void) handleUploadAvatarGetHashFileName:(NSString *)fileName title:(NSString *)title description:(NSString *)description dataFile:(NSData *)dataFile;

- (void) handleUploadDataNFCWithHashImage:(NSString *)imageFace dataGroups:(NSDictionary<NSString *,NSString *> *)dataGroups mrzs:(NSArray *)mrzs details:(NSDictionary *)details;

- (void) handleGetPostcodeMatchingPlaceOfOrigin:(NSString *)placeOfOrigin;
- (void) handleGetPostcodeMatchingPlaceOfResidence:(NSString *)placeOfResidence;



// thực hiện CÀI ĐẶT LẠI thông tin ICNFCSaveData
- (void) handleResetICNFCSaveData;

- (void) handleSaveClientSession:(NSString *)clientSession;

- (void) handleSaveMRZCodeImage:(UIImage *)image cropedImage:(UIImage *)cropedImage path:(NSURL *)path;

- (void) handleSaveQRCode:(NSString *)qrCode image:(UIImage *)image cropedImage:(UIImage *)cropedImage path:(NSURL *)path;

- (void) handleSaveAvatar:(UIImage *)avatar;

- (void) handleSaveChipAuthentication:(ICNFCAuthenticationStatus)chipAuthentication activeAuthentication:(ICNFCAuthenticationStatus)activeAuthentication;



@end

#pragma mark - ICMainNFCReaderViewProtocol

@protocol ICMainNFCReaderViewProtocol <NSObject>

/** Presenter -> ViewController */

- (void) showResultUploadSucceedAvatarImage:(NSString *)hash;

- (void) showResultUploadDataNFCSucceed:(NSDictionary *)data;

- (void) showResultGetPostcodeMatchingPlaceOfOriginSucceed:(NSDictionary *)data;

- (void) showResultGetPostcodeMatchingPlaceOfResidenceSucceed:(NSDictionary *)data;


@end
