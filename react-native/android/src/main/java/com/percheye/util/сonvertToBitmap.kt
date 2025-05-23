package com.percheye.util

import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.graphics.Matrix
import android.util.Base64
import androidx.exifinterface.media.ExifInterface
import java.io.ByteArrayInputStream
import java.io.IOException

private const val TARGET_SIZE = 160

fun convertToBitmap(base64String: String): Bitmap? {
    try {
        val decodedBytes = Base64.decode(base64String, Base64.DEFAULT)
        val bitmap = BitmapFactory.decodeStream(ByteArrayInputStream(decodedBytes))

        val exif = ExifInterface(ByteArrayInputStream(decodedBytes))
        val orientation = exif.getAttributeInt(ExifInterface.TAG_ORIENTATION, ExifInterface.ORIENTATION_UNDEFINED)

        if (orientation == ExifInterface.ORIENTATION_UNDEFINED || orientation == ExifInterface.ORIENTATION_NORMAL) {
            return resizeBitmap(bitmap, TARGET_SIZE)
        }

        val matrix = Matrix()

        when (orientation) {
            ExifInterface.ORIENTATION_ROTATE_180 -> {
                matrix.postRotate(180f)
            }
            ExifInterface.ORIENTATION_ROTATE_90 -> {
                matrix.postRotate(90f)
            }
            ExifInterface.ORIENTATION_ROTATE_270 -> {
                matrix.postRotate(-90f)
            }
            ExifInterface.ORIENTATION_TRANSVERSE -> {
                matrix.postScale(-1f, 1f)
                matrix.postRotate(90f)
            }
            ExifInterface.ORIENTATION_FLIP_HORIZONTAL -> {
                matrix.postScale(-1f, 1f)
            }
            ExifInterface.ORIENTATION_FLIP_VERTICAL -> {
                matrix.postScale(1f, -1f)
            }
            ExifInterface.ORIENTATION_TRANSPOSE -> {
                matrix.postScale(-1f, 1f)
                matrix.postRotate(-90f)
            }
            else -> {
                return resizeBitmap(bitmap, TARGET_SIZE)
            }
        }

        val rotatedBitmap = Bitmap.createBitmap(bitmap, 0, 0, bitmap.width, bitmap.height, matrix, true)
        return resizeBitmap(rotatedBitmap, TARGET_SIZE)
    } catch (e: IOException) {
        e.printStackTrace()
        return null
    }
}

fun resizeBitmap(bitmap: Bitmap, size: Int): Bitmap {
  return Bitmap.createScaledBitmap(bitmap, size, size, true)
}
