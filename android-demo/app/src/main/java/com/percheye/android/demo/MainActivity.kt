package com.percheye.android.demo

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.Scaffold
import androidx.compose.ui.Modifier
import com.onix.faceauth.sdk.PerchEye
import com.percheye.android.demo.ui.theme.AndroidDemoTheme

class MainActivity : ComponentActivity() {

    private lateinit var perchEye: PerchEye

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()

        perchEye = PerchEye(this)
        perchEye.init()

        setContent {
            AndroidDemoTheme {
                Scaffold(modifier = Modifier.fillMaxSize()) { innerPadding ->
                    FaceCompareScreen(perchEye, Modifier.padding(innerPadding))
                }
            }
        }
    }

    override fun onDestroy() {
        perchEye.destroy()
        super.onDestroy()
    }
}