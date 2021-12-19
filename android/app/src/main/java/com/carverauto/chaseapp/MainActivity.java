package com.carverauto.chaseapp;

import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import io.nodle.sdk.android.Nodle;

import static io.nodle.sdk.android.Nodle.Nodle;


public class MainActivity extends FlutterActivity {
    static final String CHANNEL = "com.carverauto.chaseapp/nodle";

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler(
                    (call, result) -> {
                        Nodle.init(this);
                        Nodle().start("5CYDxNUNrRJU3s6fb1VPhNpNPwyTcFLQuTzmJg5mioBe2eN1");
                        if (Nodle().isStarted()) {
                            // result.success("Nodled");
                            result.success(Nodle().showConfig());
                        } else {
                            result.error("Error", "No noddles", Nodle().showConfig());
                        }
                }
        );
    }
}
