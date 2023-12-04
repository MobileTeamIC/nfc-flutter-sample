package com.vnpt.ic.sample.integrate.nfc.sampleintegratenfcekyc

import org.json.JSONArray
import org.json.JSONException
import org.json.JSONObject
import org.json.JSONTokener

object JsonUtil {

   fun prettify(json: String): String? {
      return try {
         when (detectJsonRoot(json)) {
            0 -> JSONObject(json).toString(4)
            1 -> JSONArray(json).toString(4)
            else -> json
         }
      } catch (e: JSONException) {
         json
      }
   }

   private fun detectJsonRoot(json: String): Int {
      return try {
         when (JSONTokener(json).nextValue()) {
            is JSONObject -> 0
            is JSONArray -> 1
            else -> 2
         }
      } catch (e: JSONException) {
         2
      }
   }
}