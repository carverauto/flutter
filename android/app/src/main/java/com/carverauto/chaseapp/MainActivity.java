package com.carverauto.chaseapp;

import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
// import io.nodle.sdk.android.Nodle;

// import static io.nodle.sdk.android.Nodle.Nodle;


public class MainActivity extends FlutterActivity {
    // static final String CHANNEL = "com.carverauto.chaseapp/nodle";

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        // new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
        //         .setMethodCallHandler(
        //             (call, result) -> {
        //                 if (call.method.equals("init")) {
        //                     Nodle.init(this);
        //                     result.success("Nodle - init");
        //                 }
        //                 if (call.method.equals("start")) {
        //                     Nodle().start("ss58:4kvnUb3K4gBqVVJGmfb7ZzanjtCMDJ7N4ekVvXHRH4Kvx6Mi");
        //                     if (Nodle().isStarted()) {
        //                         if (Nodle().isScanning()) {
        //                             result.success("Nodle started, scanning..");
        //                         } else {
        //                             result.error("Error", "Nodle started, No scanning", Nodle().showConfig());
        //                         }
        //                     } else {
        //                         result.error("Error", "Nodle not started", Nodle().showConfig());
        //                     }
        //                 }
        //                 if (call.method.equals("isScanning")) {
        //                     result.success(String.valueOf(Nodle().isScanning()));
        //                 }
        //                 if (call.method.equals("isStarted")) {
        //                     result.success(String.valueOf(Nodle().isStarted()));
        //                 }
        //                 if (call.method.equals("showConfig")) {
        //                     result.success(Nodle().showConfig());
        //                 }
        //         }
        // );
    }
}
