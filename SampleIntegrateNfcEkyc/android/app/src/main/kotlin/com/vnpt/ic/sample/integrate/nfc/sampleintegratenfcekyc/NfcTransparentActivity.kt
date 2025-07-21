package com.vnpt.ic.sample.integrate.nfc.sampleintegratenfcekyc

import android.app.Activity
import android.content.Intent
import android.os.Bundle
import android.view.View
import androidx.appcompat.app.AppCompatActivity
import androidx.core.view.WindowCompat
import com.google.gson.Gson
import com.vnpt.ic.sample.integrate.nfc.sampleintegratenfcekyc.MainActivity.Companion.EKYC_REQUEST_CODE
import com.vnpt.ic.sample.integrate.nfc.sampleintegratenfcekyc.MainActivity.Companion.NFC_RESULT
import com.vnptit.nfc.nfc_tool.NfcCallback
import com.vnptit.nfc.nfc_tool.NfcError
import com.vnptit.nfc.nfc_tool.NfcOptionNoGuide
import com.vnptit.nfc.nfc_tool.NfcResult
import com.vnptit.nfc.nfc_tool.NfcTool
import com.vnptit.nfc.utils.KeyResultConstantsNFC
import org.json.JSONObject

class NfcTransparentActivity : AppCompatActivity() {

   companion object {
      const val KEY_EXTRA_INFO_NFC = "extra::NFC"
   }

   private var nfcTool: NfcTool? = null

   override fun onCreate(savedInstanceState: Bundle?) {
      super.onCreate(savedInstanceState)

      WindowCompat.setDecorFitsSystemWindows(window, false)
      setContentView(View(this))

      val jsonObject = JSONObject(intent.getStringExtra(KEY_EXTRA_INFO_NFC) ?: "{}")

      nfcTool = NfcTool(this)
      // clear previous session reader chip
      nfcTool?.clearReadChip()
      // start new session
      nfcTool?.startReadChip(
         NfcOptionNoGuide().setExtras(MainActivity.navigateToScanNfc(this, jsonObject)),
         object : NfcCallback() {
            override fun onSuccess(result: NfcResult?) {
               val intent = Intent()
               val gson = Gson()

               intent.putExtra(NFC_RESULT, gson.toJson(result))
               setResult(RESULT_OK, intent)
               finish()
            }

            override fun onError(message: NfcError?) {
               val intent = Intent()
               intent.putExtra(NFC_RESULT, message)
               setResult(RESULT_OK, intent)
               finish()
            }
         }
      )
   }

   override fun onNewIntent(intent: Intent?) {
      super.onNewIntent(intent)
      nfcTool?.handleIntent(intent)
   }

   override fun onDestroy() {
      super.onDestroy()
      nfcTool?.clearReadChip()
   }
}