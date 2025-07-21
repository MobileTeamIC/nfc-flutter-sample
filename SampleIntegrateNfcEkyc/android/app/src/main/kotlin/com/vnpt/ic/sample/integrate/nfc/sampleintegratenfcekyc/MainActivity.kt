package com.vnpt.ic.sample.integrate.nfc.sampleintegratenfcekyc

import android.content.Context
import android.content.Intent
import android.nfc.NfcManager
import android.util.Log
import com.google.gson.Gson
import com.vnptit.nfc.activity.VnptScanNFCActivity
import com.vnptit.nfc.nfc_tool.NfcResult
import com.vnptit.nfc.utils.KeyIntentConstantsNFC
import com.vnptit.nfc.utils.KeyResultConstantsNFC
import com.vnptit.nfc.utils.SDKEnumNFC
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import org.json.JSONObject

class MainActivity : FlutterActivity(), MethodChannel.MethodCallHandler {
   companion object {
      private const val CHANNEL = "flutter.sdk.ekyc/integrate"
      const val NFC_RESULT = "nfc_result"
      const val EKYC_REQUEST_CODE = 100
      const val NFC_NO_GUIDE_REQUEST_CODE = 101
      const val ERROR_NFC_CODE = "69"

      fun navigateToScanNfc(ctx: Context, json: JSONObject): Intent {
         return Intent(ctx, VnptScanNFCActivity::class.java).also {
            /**
             * Truyền access token chứa bearer
             */
            it.putExtra(KeyIntentConstantsNFC.ACCESS_TOKEN, json.getString("access_token"))
            /**
             * Truyền token id
             */
            it.putExtra(KeyIntentConstantsNFC.TOKEN_ID, json.getString("token_id"))
            /**
             * Truyền token key
             */
            it.putExtra(KeyIntentConstantsNFC.TOKEN_KEY, json.getString("token_key"))
            /**
             * Truyền access token ekyc chứa bearer
             */
            it.putExtra(KeyIntentConstantsNFC.ACCESS_TOKEN_EKYC, json.getString("access_token_ekyc"))
            /**
             * Truyền token id ekyc
             */
            it.putExtra(KeyIntentConstantsNFC.TOKEN_ID_EKYC, json.getString("token_id_ekyc"))
            /**
             * Truyền token key ekyc
             */
            it.putExtra(KeyIntentConstantsNFC.TOKEN_KEY_EKYC, json.getString("token_key_ekyc"))
            /**
             * điều chỉnh ngôn ngữ tiếng việt
             *    - vi: tiếng việt
             *    - en: tiếng anh
             */
            it.putExtra(KeyIntentConstantsNFC.LANGUAGE_SDK, SDKEnumNFC.LanguageEnum.VIETNAMESE.value)
            /**
             * hiển thị màn hình hướng dẫn + hiển thị nút bỏ qua hướng dẫn
             * - mặc định luôn luôn hiển thị màn hình hướng dẫn
             *    - true: hiển thị nút bỏ qua
             *    - false: ko hiển thị nút bỏ qua
             */
            it.putExtra(KeyIntentConstantsNFC.IS_ENABLE_GOT_IT, true)
            /**
             * bật tính năng upload ảnh
             *    - true: bật tính năng
             *    - false: tắt tính năng
             */
            it.putExtra(KeyIntentConstantsNFC.IS_ENABLE_UPLOAD_IMAGE, true)
            /**
             * bật tính năng get Postcode
             *    - true: bật tính năng
             *    - false: tắt tính năng
             */
            it.putExtra(KeyIntentConstantsNFC.IS_ENABLE_POSTCODE_MATCHING, true)
            /**
             * truyền các giá trị đọc thẻ
             *    - nếu không truyền gì mặc định sẽ đọc tất cả (MRZ,Verify Document,Image Avatar)
             *    - giá trị truyền vào là 1 mảng int: nếu muốn đọc giá trị nào sẽ truyền
             *      giá trị đó vào mảng
             * eg: chỉ đọc thông tin MRZ
             *    intArrayOf(SDKEnumNFC.ReadingNFCTags.MRZInfo.value)
             */
            it.putExtra(
               KeyIntentConstantsNFC.READING_TAGS_NFC,
               intArrayOf(
                  SDKEnumNFC.ReadingNFCTags.MRZInfo.value,
                  SDKEnumNFC.ReadingNFCTags.VerifyDocumentInfo.value,
                  SDKEnumNFC.ReadingNFCTags.ImageAvatarInfo.value
               )
            )
            /**
             * Truyền chế độ đọc thẻ
             */
            it.putExtra(KeyIntentConstantsNFC.READER_CARD_MODE, SDKEnumNFC.ReaderCardMode.NONE.getValue())
            // set baseDomain="" => sử dụng mặc định là Product
            it.putExtra(KeyIntentConstantsNFC.BASE_URL, "")
            // truyền id định danh căn cước công dân
            it.putExtra(KeyIntentConstantsNFC.ID_NUMBER_CARD, json.getString("card_id"))
            // truyền ngày sinh ghi trên căn cước công dân
            it.putExtra(KeyIntentConstantsNFC.BIRTHDAY_CARD, json.getString("card_dob"))
            // truyền ngày hết hạn căn cước công dân
            it.putExtra(KeyIntentConstantsNFC.EXPIRED_DATE_CARD, json.getString("card_expire_date"))
         }
      }
   }

   private lateinit var channel: MethodChannel
   private lateinit var result: MethodChannel.Result

   override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
      super.configureFlutterEngine(flutterEngine)
      channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
      channel.setMethodCallHandler(this)
   }

   override fun cleanUpFlutterEngine(flutterEngine: FlutterEngine) {
      super.cleanUpFlutterEngine(flutterEngine)
      channel.setMethodCallHandler(null)
   }

   override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
      this.result = result

      val json = parseJsonFromArgs(call)
      val intent = when (call.method) {
         "navigateToNfcQrCode" -> navigateToNfcQrCode(json)
         "navigateToScanNfc" -> navigateToScanNfc(this, json)
         "navigateToScanNfcNoGuide" -> Intent(this, NfcTransparentActivity::class.java).also {
            it.putExtra(
               NfcTransparentActivity.KEY_EXTRA_INFO_NFC, json.toString()
            )
         }

         else -> {
            result.notImplemented()
            null
         }
      }



      intent?.let {
         if (!isDeviceSupportedNfc()) {
            result.error(ERROR_NFC_CODE, "Thiết bị không hỗ trợ NFC", null)
            return
         }

         if (call.method == "navigateToScanNfcNoGuide") {
            activity.startActivityForResult(it, NFC_NO_GUIDE_REQUEST_CODE)
         } else {
            activity.startActivityForResult(it, EKYC_REQUEST_CODE)
         }
      }
   }

   override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
      super.onActivityResult(requestCode, resultCode, data)
      if (requestCode == EKYC_REQUEST_CODE) {
         if (resultCode == RESULT_OK) {
            if (data != null) {
               /**
                * đường dẫn ảnh mặt trước trong thẻ chip lưu trong cache
                * [KeyResultConstantsNFC.PATH_IMAGE_AVATAR]
                */
               val avatarPath = data.getStringExtra(KeyResultConstantsNFC.PATH_IMAGE_AVATAR)

               /**
                * chuỗi thông tin cua SDK
                * [KeyResultConstantsNFC.CLIENT_SESSION_RESULT]
                */
               val clientSession =
                  data.getStringExtra(KeyResultConstantsNFC.CLIENT_SESSION_RESULT)

               /**
                * kết quả NFC
                * [KeyResultConstantsNFC.DATA_NFC_RESULT]
                */
               val dataNfcResult = data.getStringExtra(KeyResultConstantsNFC.DATA_NFC_RESULT)

               /**
                * mã hash avatar
                * [KeyResultConstantsNFC.HASH_IMAGE_AVATAR]
                */
               val hashAvatar = data.getStringExtra(KeyResultConstantsNFC.HASH_IMAGE_AVATAR)

               /**
                * chuỗi json string chứa thông tin post code của quê quán
                * [KeyResultConstantsNFC.POST_CODE_ORIGINAL_LOCATION_RESULT]
                */
               val postCodeOriginalLocation =
                  data.getStringExtra(KeyResultConstantsNFC.POST_CODE_ORIGINAL_LOCATION_RESULT)

               /**
                * chuỗi json string chứa thông tin post code của nơi thường trú
                * [KeyResultConstantsNFC.POST_CODE_RECENT_LOCATION_RESULT]
                */
               val postCodeRecentLocation =
                  data.getStringExtra(KeyResultConstantsNFC.POST_CODE_RECENT_LOCATION_RESULT)

               /**
                * kết quả check chip căn cước công dân
                * [KeyResultConstantsNFC.CHECK_AUTH_CHIP_RESULT]
                */
               val checkAuthChipResult =
                  data.getStringExtra(KeyResultConstantsNFC.STATUS_CHIP_AUTHENTICATION)

               /**
                * kết quả quét QRCode căn cước công dân
                * [KeyResultConstantsNFC.QR_CODE_RESULT_NFC]
                */
               val qrCodeResult = data.getStringExtra(KeyResultConstantsNFC.QR_CODE_RESULT)

               result.success(
                  JSONObject().apply {
                     putSafe(KeyResultConstantsNFC.PATH_IMAGE_AVATAR, avatarPath)
                     putSafe(KeyResultConstantsNFC.CLIENT_SESSION_RESULT, clientSession)
                     putSafe(KeyResultConstantsNFC.DATA_NFC_RESULT, dataNfcResult)
                     putSafe(KeyResultConstantsNFC.HASH_IMAGE_AVATAR, hashAvatar)
                     putSafe(
                        KeyResultConstantsNFC.POST_CODE_ORIGINAL_LOCATION_RESULT,
                        postCodeOriginalLocation
                     )
                     putSafe(
                        KeyResultConstantsNFC.POST_CODE_RECENT_LOCATION_RESULT,
                        postCodeRecentLocation
                     )
                     putSafe(KeyResultConstantsNFC.STATUS_CHIP_AUTHENTICATION, checkAuthChipResult)
                     putSafe(KeyResultConstantsNFC.QR_CODE_RESULT, qrCodeResult)
                  }.toString()
               )
            }
         }
      }
      else if (requestCode == NFC_NO_GUIDE_REQUEST_CODE) {
         if (resultCode == RESULT_OK) {
            data?.let {
               Log.d("MainActivity", "NFC Result: $data")
               val resultStr = it.getStringExtra(NFC_RESULT)
               val resultObj = Gson().fromJson(resultStr, NfcResult::class.java)
               result.success(
                  JSONObject().apply {
                     putSafe(KeyResultConstantsNFC.CLIENT_SESSION_RESULT, resultObj.clientSessionNfc)
                     putSafe(KeyResultConstantsNFC.DATA_NFC_RESULT, resultObj.logNfcResult)
                     putSafe(
                        KeyResultConstantsNFC.POST_CODE_ORIGINAL_LOCATION_RESULT,
                        resultObj.postCodeOriginalLocationResult
                     )
                     putSafe(
                        KeyResultConstantsNFC.POST_CODE_RECENT_LOCATION_RESULT,
                        resultObj.postCodeRecentLocationResult
                     )
                     putSafe(KeyResultConstantsNFC.STATUS_CHIP_AUTHENTICATION, resultObj.statusChipAuthentication)
                  }.toString()
               )
            }
         }
      }
   }

   private fun isDeviceSupportedNfc(): Boolean {
      val adapter = (getSystemService(NFC_SERVICE) as? NfcManager)?.defaultAdapter
      return adapter != null && adapter.isEnabled
   }

   private fun navigateToNfcQrCode(json: JSONObject): Intent {
      return Intent(this, VnptScanNFCActivity::class.java).also {
         /**
          * Truyền access token chứa bearer
          */
         it.putExtra(KeyIntentConstantsNFC.ACCESS_TOKEN, json.getString("access_token"))
         /**
          * Truyền token id
          */
         it.putExtra(KeyIntentConstantsNFC.TOKEN_ID, json.getString("token_id"))
         /**
          * Truyền token key
          */
         it.putExtra(KeyIntentConstantsNFC.TOKEN_KEY, json.getString("token_key"))
         /**
          * Truyền access token ekyc chứa bearer
          */
         it.putExtra(KeyIntentConstantsNFC.ACCESS_TOKEN_EKYC, json.getString("access_token_ekyc"))
         /**
          * Truyền token id ekyc
          */
         it.putExtra(KeyIntentConstantsNFC.TOKEN_ID_EKYC, json.getString("token_id_ekyc"))
         /**
          * Truyền token key ekyc
          */
         it.putExtra(KeyIntentConstantsNFC.TOKEN_KEY_EKYC, json.getString("token_key_ekyc"))
         /**
          * điều chỉnh ngôn ngữ tiếng việt
          *    - vi: tiếng việt
          *    - en: tiếng anh
          */
         it.putExtra(KeyIntentConstantsNFC.LANGUAGE_SDK, SDKEnumNFC.LanguageEnum.VIETNAMESE.value)
         /**
          * hiển thị màn hình hướng dẫn + hiển thị nút bỏ qua hướng dẫn
          * - mặc định luôn luôn hiển thị màn hình hướng dẫn
          *    - true: hiển thị nút bỏ qua
          *    - false: ko hiển thị nút bỏ qua
          */
         it.putExtra(KeyIntentConstantsNFC.IS_ENABLE_GOT_IT, true)
         /**
          * bật tính năng upload ảnh
          *    - true: bật tính năng
          *    - false: tắt tính năng
          */
         it.putExtra(KeyIntentConstantsNFC.IS_ENABLE_UPLOAD_IMAGE, true)
         /**
          * bật tính năng get Postcode
          *    - true: bật tính năng
          *    - false: tắt tính năng
          */
         it.putExtra(KeyIntentConstantsNFC.IS_ENABLE_POSTCODE_MATCHING, true)
         /**
          * truyền các giá trị đọc thẻ
          *    - nếu không truyền gì mặc định sẽ đọc tất cả (MRZ,Verify Document,Image Avatar)
          *    - giá trị truyền vào là 1 mảng int: nếu muốn đọc giá trị nào sẽ truyền
          *      giá trị đó vào mảng
          * eg: chỉ đọc thông tin MRZ
          *    intArrayOf(SDKEnumNFC.ReadingNFCTags.MRZInfo.value)
          */
         it.putExtra(
            KeyIntentConstantsNFC.READING_TAGS_NFC,
            intArrayOf(
               SDKEnumNFC.ReadingNFCTags.MRZInfo.value,
               SDKEnumNFC.ReadingNFCTags.VerifyDocumentInfo.value,
               SDKEnumNFC.ReadingNFCTags.ImageAvatarInfo.value
            )
         )
         /**
          * set baseDomain="" => sử dụng mặc định là Product của VNPT
          */
         it.putExtra(KeyIntentConstantsNFC.BASE_URL, "")
      }
   }

   private fun parseJsonFromArgs(call: MethodCall): JSONObject {
      return try {
         @Suppress("UNCHECKED_CAST")
         (JSONObject(call.arguments as Map<String, Any>))
      } catch (e: Exception) {
         JSONObject(mapOf<String, Any>())
      }
   }

   /**
    * put value to [JSONObject] with null-safety
    */
   private fun JSONObject.putSafe(key: String, value: String?) {
      value?.let { put(key, JsonUtil.prettify(it)) }
   }
}
