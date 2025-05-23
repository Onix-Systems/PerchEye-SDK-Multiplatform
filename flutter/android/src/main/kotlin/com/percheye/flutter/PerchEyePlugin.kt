package com.percheye.flutter

import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.util.Base64
import android.util.Log
import androidx.annotation.NonNull
import com.onix.faceauth.sdk.ImageResult
import com.onix.faceauth.sdk.PerchEye
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

class PerchEyePlugin: FlutterPlugin, MethodCallHandler {
    private lateinit var channel: MethodChannel
    private lateinit var perchEye: PerchEye

    companion object {
        private const val TAG = "PerchEyePlugin"
    }

    override fun onAttachedToEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(binding.binaryMessenger, "perch_eye_method_channel")
        channel.setMethodCallHandler(this)
        perchEye = PerchEye(binding.applicationContext)
        perchEye.init()
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            "init" -> {
                perchEye.init()
                result.success(null)
            }
            "destroy" -> {
                perchEye.destroy()
                result.success(null)
            }
            "openTransaction" -> {
                perchEye.openTransaction()
                result.success(null)
            }
            "addImage" -> {
                val img = call.argument<String>("img")
                val bmp = decode(img)
                val res = bmp?.let { perchEye.addImage(it).name } ?: "INTERNAL_ERROR"
                result.success(res)
            }
            "addImageRaw" -> {
                val pixels = call.argument<ByteArray>("pixels")
                val width = call.argument<Int>("width") ?: 0
                val height = call.argument<Int>("height") ?: 0
                if (pixels == null || width <= 0 || height <= 0) {
                    result.error("INVALID_ARGUMENT", "Missing or invalid RGBA data", null)
                    return
                }

                val imageResult = perchEye.addImage(pixels, width, height)
                result.success(imageResult.name)
            }
            "enroll" -> {
                val hash = perchEye.enroll()
                result.success(hash)
            }
            "verify" -> {
                val hash = call.argument<String>("hash")
                val sim = if (hash != null) perchEye.verify(hash) else 0.0f
                result.success(sim.toDouble())
            }
            "evaluate" -> {
                val images = call.argument<List<String>>("images")
                if (images.isNullOrEmpty()) {
                    result.error("INVALID_ARGUMENT", "Images list is empty", null)
                    return
                }

                val bitmaps = images.mapNotNull { decode(it) }
                if (bitmaps.size != images.size) {
                    result.error("DECODE_ERROR", "Some images failed to decode", null)
                    return
                }

                perchEye.openTransaction()

                val successful = mutableListOf<Bitmap>()
                bitmaps.forEachIndexed { i, bmp ->
                    val res = perchEye.addImage(bmp)
                    Log.d("PerchEyePlugin", "evaluate: image[$i] -> addImage() result: $res")
                    if (res == ImageResult.SUCCESS) {
                        successful.add(bmp)
                    }
                }

                if (successful.isEmpty()) {
                    result.error("NO_VALID_IMAGES", "None of the images passed addImage()", null)
                    return
                }

                val hash = perchEye.evaluate(successful)
                Log.d("PerchEyePlugin", "evaluate result hash: $hash")
                result.success(hash)
            }
            "compareList" -> {
                val imgs = call.argument<List<String>>("images")?.mapNotNull { decode(it) } ?: emptyList()
                val hash = call.argument<String>("hash")
                perchEye.openTransaction()
                val sim = if (hash != null) perchEye.compare(imgs, hash) else 0.0f
                result.success(sim.toDouble())
            }
            "compareFaces" -> {
                val img1 = call.argument<String>("img1")
                val img2 = call.argument<String>("img2")
                val sim = compare(img1, img2)
                result.success(sim)
            }
            else -> result.notImplemented()
        }
    }

    private fun compare(img1: String?, img2: String?): Double {
        if (img1.isNullOrEmpty() || img2.isNullOrEmpty()) {
            Log.d(TAG, "One of images is null or empty")
            return 0.0
        }

        val bmp1 = decode(img1) ?: return 0.0
        val bmp2 = decode(img2) ?: return 0.0

        perchEye.openTransaction()
        val add1 = perchEye.addImage(bmp1)
        if (add1 != ImageResult.SUCCESS) return 0.0
        val hash = perchEye.enroll()

        perchEye.openTransaction()
        val add2 = perchEye.addImage(bmp2)
        if (add2 != ImageResult.SUCCESS) return 0.0
        return perchEye.verify(hash).toDouble()
    }

    private fun decode(b64: String?): Bitmap? {
        return try {
            val bytes = Base64.decode(b64, Base64.DEFAULT)
            BitmapFactory.decodeByteArray(bytes, 0, bytes.size)
        } catch (e: Exception) {
            Log.e(TAG, "Failed to decode image", e)
            null
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
        perchEye.destroy()
    }
}