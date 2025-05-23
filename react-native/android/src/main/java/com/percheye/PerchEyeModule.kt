package com.percheye

import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.util.Base64
import android.util.Log
import com.facebook.react.bridge.*
import com.onix.faceauth.sdk.ImageResult
import com.onix.faceauth.sdk.PerchEye

class PerchEyeModule(private val reactContext: ReactApplicationContext) :
  ReactContextBaseJavaModule(reactContext), LifecycleEventListener {

  private var perchEye: PerchEye = PerchEye(reactContext)

  companion object {
    private const val TAG = "PerchEyeModule"
    const val NAME = "PerchEyeModule"
  }

  init {
    reactContext.addLifecycleEventListener(this)
    perchEye.init()
  }

  override fun getName(): String = NAME

  override fun onHostDestroy() {
    perchEye.destroy()
  }

  override fun onHostPause() {}
  override fun onHostResume() {}

  @ReactMethod
  fun init(promise: Promise) {
    perchEye.init()
    promise.resolve(null)
  }

  @ReactMethod
  fun destroy(promise: Promise) {
    perchEye.destroy()
    promise.resolve(null)
  }

  @ReactMethod
  fun openTransaction(promise: Promise) {
    perchEye.openTransaction()
    promise.resolve(null)
  }

  @ReactMethod
  fun addImage(params: ReadableMap, promise: Promise) {
    val img = params.getString("img")
    val bmp = decode(img)
    val res = bmp?.let { perchEye.addImage(it).name } ?: "INTERNAL_ERROR"
    promise.resolve(res)
  }

  @ReactMethod
  fun enroll(promise: Promise) {
    val hash = perchEye.enroll()
    promise.resolve(hash)
  }

  @ReactMethod
  fun verify(params: ReadableMap, promise: Promise) {
    val hash = params.getString("hash")
    val sim = if (hash != null) perchEye.verify(hash) else 0.0f
    promise.resolve(sim.toDouble())
  }

  @ReactMethod
  fun evaluate(params: ReadableMap, promise: Promise) {
    try {
      val images = params.getArray("images")?.toArrayList()?.mapNotNull { decode(it as String) } ?: emptyList()
      if (images.isEmpty()) {
        promise.reject("INVALID_ARGUMENT", "Images list is empty or invalid")
        return
      }

      perchEye.openTransaction()

      val successful = images.filter {
        perchEye.addImage(it) == ImageResult.SUCCESS
      }

      if (successful.isEmpty()) {
        promise.reject("NO_VALID_IMAGES", "None of the images passed addImage()")
        return
      }

      val hash = perchEye.evaluate(successful)
      promise.resolve(hash)
    } catch (e: Exception) {
      promise.reject("ERROR", e)
    }
  }

  @ReactMethod
  fun compareList(params: ReadableMap, promise: Promise) {
    try {
      val images = params.getArray("images")?.toArrayList()?.mapNotNull { decode(it as String) } ?: emptyList()
      val hash = params.getString("hash")

      perchEye.openTransaction()

      val sim = if (hash != null) perchEye.compare(images, hash) else 0.0f
      promise.resolve(sim.toDouble())
    } catch (e: Exception) {
      promise.reject("ERROR", e)
    }
  }

  @ReactMethod
  fun compareFaces(params: ReadableMap, promise: Promise) {
    try {
      val img1 = params.getString("img1")
      val img2 = params.getString("img2")

      if (img1.isNullOrEmpty() || img2.isNullOrEmpty()) {
        promise.resolve(0.0)
        return
      }

      val bmp1 = decode(img1) ?: run { promise.resolve(0.0); return }
      val bmp2 = decode(img2) ?: run { promise.resolve(0.0); return }

      perchEye.openTransaction()
      if (perchEye.addImage(bmp1) != ImageResult.SUCCESS) {
        promise.resolve(0.0)
        return
      }

      val hash = perchEye.enroll()

      perchEye.openTransaction()
      if (perchEye.addImage(bmp2) != ImageResult.SUCCESS || hash.isEmpty()) {
        promise.resolve(0.0)
        return
      }

      val similarity = perchEye.verify(hash)
      promise.resolve(similarity)
    } catch (e: Exception) {
      promise.reject("ERROR", e)
    }
  }

  private fun decode(base64: String?): Bitmap? {
    return try {
      val bytes = Base64.decode(base64, Base64.DEFAULT)
      BitmapFactory.decodeByteArray(bytes, 0, bytes.size)
    } catch (e: Exception) {
      Log.e(TAG, "Failed to decode base64", e)
      null
    }
  }
}