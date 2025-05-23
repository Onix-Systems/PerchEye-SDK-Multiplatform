package com.percheye.android.demo

import android.graphics.Bitmap
import androidx.activity.compose.rememberLauncherForActivityResult
import androidx.activity.result.PickVisualMediaRequest
import androidx.activity.result.contract.ActivityResultContracts
import androidx.activity.result.launch
import androidx.compose.foundation.Image
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.Button
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.asImageBitmap
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.onix.faceauth.sdk.ImageResult
import com.onix.faceauth.sdk.PerchEye
import com.percheye.android.demo.utils.uriToBitmap
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import java.util.Locale

@Composable
fun FaceCompareScreen(perchEye: PerchEye, modifier: Modifier) {
    var img1 by remember { mutableStateOf<Bitmap?>(null) }
    var img2 by remember { mutableStateOf<Bitmap?>(null) }
    var similarity by remember { mutableStateOf<Float?>(null) }
    val context = LocalContext.current
    val coroutineScope = rememberCoroutineScope()
    var loading by remember { mutableStateOf(false) }

    val launcherCamera1 =
        rememberLauncherForActivityResult(ActivityResultContracts.TakePicturePreview()) {
            img1 = it
            similarity = null
        }
    val launcherCamera2 =
        rememberLauncherForActivityResult(ActivityResultContracts.TakePicturePreview()) {
            img2 = it
            similarity = null
        }
    val launcherGallery =
        rememberLauncherForActivityResult(ActivityResultContracts.PickMultipleVisualMedia(2)) { uris ->
            if (uris.size == 2) {
                img1 = uriToBitmap(context, uris[0])
                img2 = uriToBitmap(context, uris[1])
                similarity = null
            }
        }

    Column(
        modifier = modifier
            .fillMaxSize()
            .padding(16.dp),
        verticalArrangement = Arrangement.spacedBy(20.dp),
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        Text("👁️ Face Similarity Check", fontWeight = FontWeight.Bold, fontSize = 20.sp)
        Text("Please upload or take two face photos to compare.", fontSize = 14.sp)

        Row(horizontalArrangement = Arrangement.spacedBy(12.dp)) {
            Button(onClick = { launcherCamera1.launch() }) { Text("📸 First Photo") }
            Button(onClick = { launcherCamera2.launch() }) { Text("📸 Second Photo") }
        }

        Button(onClick = {
            launcherGallery.launch(
                PickVisualMediaRequest(ActivityResultContracts.PickVisualMedia.ImageOnly)
            )
        }) {
            Text("🖼️ Pick 2 Photos from Gallery")
        }

        Row(horizontalArrangement = Arrangement.spacedBy(16.dp)) {
            img1?.let {
                Image(
                    bitmap = it.asImageBitmap(),
                    contentDescription = "First image",
                    modifier = Modifier
                        .size(120.dp)
                        .clip(RoundedCornerShape(8.dp))
                )
            }

            img2?.let {
                Image(
                    bitmap = it.asImageBitmap(),
                    contentDescription = "Second image",
                    modifier = Modifier
                        .size(120.dp)
                        .clip(RoundedCornerShape(8.dp))
                )
            }
        }

        if (img1 != null && img2 != null) {
            Button(
                onClick = {
                    coroutineScope.launch(Dispatchers.IO) {
                        loading = true
                        perchEye.openTransaction()
                        if (perchEye.addImage(img1!!) == ImageResult.SUCCESS) {
                            val hash = perchEye.enroll()
                            perchEye.openTransaction()
                            if (perchEye.addImage(img2!!) == ImageResult.SUCCESS) {
                                similarity = perchEye.verify(hash)
                            }
                        }
                        loading = false
                    }
                },
                enabled = similarity == null
            ) {
                Text("🔍 Compare Faces")
            }

            Button(onClick = {
                img1 = null
                img2 = null
                similarity = null
            }) {
                Text("🔄 Start Over")
            }
        }

        if(loading) {
            CircularProgressIndicator()
        }

        similarity?.let {
            Text(
                "Similarity: ${String.format(Locale.US, "%.2f", it * 100)}%",
                fontSize = 16.sp,
                fontWeight = FontWeight.Medium
            )
        }
    }
}