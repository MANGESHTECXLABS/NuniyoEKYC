package com.we3.nuniyoekyc;

import android.app.Activity;
import android.content.Intent;
import static android.content.ContentValues.TAG;
import io.flutter.embedding.android.FlutterActivity;
import androidx.annotation.NonNull;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import android.util.Log;


public class MainActivity extends FlutterActivity{
    private static final String CHANNEL = "samples.flutter.dev/battery";

    boolean esignSuccessfull = false;

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler(
                        (call, result) -> {
                            // Note: this method is invoked on the main thread.
                            // TODO
                            if (call.method.equals("esignThisDocument")) {
                                ///Getting the Doc Id From Flutter
                                String docID = call.argument("docID");
                                Intent intent = new Intent(this, DigioActivity.class);
                                intent.putExtra("docID",docID);
                                Log.d(TAG, "Started Digio Activity to get Result");
                                ///Request code is to IDentity what Results we want from another activity if the
                                //Activity gives back multiple results.
                                startActivityForResult(intent,1);
                                ///Maybe have to implement Something Here!
                                Log.d(TAG, "Don know if we waited!");
                                result.success(esignSuccessfull);
                                finish();
                            }
                            else {
                                result.notImplemented();
                                finish();
                            }
                        }
                );
    }

    @Override
    public void onActivityResult(int requestCode,int resultCode, Intent data) {
        super.onActivityResult(requestCode,resultCode, data);
        if (resultCode == Activity.RESULT_OK) {
            ///Set the Value
            esignSuccessfull = true;
            Log.d(TAG, "Esign Successful");
        }
        else if(resultCode == Activity.RESULT_CANCELED){
            esignSuccessfull = false;
            Log.d(TAG, "Esign Failed");
        }
    }

}
