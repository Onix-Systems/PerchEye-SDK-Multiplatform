package com.percheye.android.demo.utils

import android.content.Context
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.net.Uri

fun uriToBitmap(context: Context, uri: Uri): Bitmap? {
    return runCatching {
        val stream = context.contentResolver.openInputStream(uri)
        BitmapFactory.decodeStream(stream)
    }.getOrNull()
}
