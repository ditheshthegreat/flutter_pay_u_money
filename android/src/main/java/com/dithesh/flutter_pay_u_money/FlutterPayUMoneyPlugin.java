package com.dithesh.flutter_pay_u_money;

import android.app.Activity;
import android.content.Intent;

import androidx.annotation.NonNull;

import com.payumoney.core.PayUmoneySdkInitializer;
import com.payumoney.core.entity.TransactionResponse;
import com.payumoney.sdkui.ui.utils.PayUmoneyFlowManager;
import com.payumoney.sdkui.ui.utils.ResultModel;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.List;

import io.flutter.Log;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;

import static android.app.Activity.RESULT_OK;

/**
 * FlutterPayUMoneyPlugin
 */
public class FlutterPayUMoneyPlugin implements FlutterPlugin, MethodCallHandler, ActivityAware, PluginRegistry.ActivityResultListener {
    private static final String TAG = "FlutterPayUMoneyPlugin";
    private MethodChannel channel;
    private Activity activity;
    private MethodChannel.Result wholeResult;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "flutter_pay_u_money");
        channel.setMethodCallHandler(this);
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        switch (call.method) {
            case "hashIt":
                generateHashKey(String.valueOf(call.arguments), result);
                break;
            case "testPay":
                System.out.println("arguments :: " + call.arguments);
                wholeResult = result;
                launchPayUMoneyFlow(call, true);
                break;
            case "livePay":
                System.out.println("arguments :: " + call.arguments);
                wholeResult = result;
                launchPayUMoneyFlow(call, false);
                break;
            default:
                result.notImplemented();
                break;
        }
    }


    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
    }


    @Override
    public void onAttachedToActivity(ActivityPluginBinding binding) {
        activity = binding.getActivity();
        binding.addActivityResultListener(this);

    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {

    }

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {

    }

    @Override
    public void onDetachedFromActivity() {

    }


    private void launchPayUMoneyFlow(MethodCall call, boolean environment) {
        String udf1 = "",
                udf2 = "",
                udf3 = "",
                udf4 = "",
                udf5 = "",
                udf6 = "",
                udf7 = "",
                udf8 = "",
                udf9 = "",
                udf10 = "";
        PayUmoneySdkInitializer.PaymentParam.Builder builder = new PayUmoneySdkInitializer.PaymentParam.Builder();
        List<String> udfs = call.argument("udf");
        String merchantKey = call.argument("merchantKey");
        String merchantId = call.argument("merchantId");
        String sUrl = call.argument("sUrl") != null ? (String) call.argument("sUrl") : "https ://www.payumoney.com/mobileapp/payumoney/success.php";
        String fUrl = call.argument("fUrl") != null ? (String) call.argument("fUrl") : "https://www.payumoney.com/mobileapp/payumoney/failure.php";
        String firstName = call.argument("firstName");
        String email = call.argument("email");
        String phone = call.argument("phone");
        String productName = call.argument("productName");
        String amount = call.argument("amount");
        String txnId = call.argument("txnId");
        if (udfs != null) {
            udf1 = udfs.get(0);
            udf2 = udfs.get(1);
            udf3 = udfs.get(2);
            udf4 = udfs.get(3);
            udf5 = udfs.get(4);
            udf6 = udfs.get(5);
            udf7 = udfs.get(6);
            udf8 = udfs.get(7);
            udf9 = udfs.get(8);
            udf10 = udfs.get(9);
        }
        String hash = call.argument("hash");

        builder.setAmount(amount)
                .setTxnId(txnId)
                .setPhone(phone)
                .setProductName(productName)
                .setFirstName(firstName)
                .setEmail(email)
                .setIsDebug(environment)
                .setsUrl(sUrl)
                .setfUrl(fUrl)
                .setUdf1(udf1)
                .setUdf2(udf2)
                .setUdf3(udf3)
                .setUdf4(udf4)
                .setUdf5(udf5)
                .setUdf6(udf6)
                .setUdf7(udf7)
                .setUdf8(udf8)
                .setUdf9(udf9)
                .setUdf10(udf10)
                .setKey(merchantKey)
                .setMerchantId(merchantId);

        try {
            PayUmoneySdkInitializer.PaymentParam mPaymentParams = builder.build();
            mPaymentParams.setMerchantHash(hash);
            PayUmoneyFlowManager.startPayUMoneyFlow(mPaymentParams, activity, R.style.AppTheme_default, false);
        } catch (Exception e) {
            e.printStackTrace();

        }
    }


    // String hashSequence = "key|txnid|amount|productinfo|firstname|email|udf1|udf2|udf3|udf4|udf5||||||salt";
    private void generateHashKey(String hashString, Result result) {
        StringBuilder hash = new StringBuilder();
        MessageDigest messageDigest;
        try {
            messageDigest = MessageDigest.getInstance("SHA-512");
            messageDigest.update(hashString.getBytes());
            byte[] mdbytes = messageDigest.digest();
            for (byte hashByte : mdbytes) {
                hash.append(Integer.toString((hashByte & 0xff) + 0x100, 16).substring(1));
            }
            result.success(hash.toString());
        } catch (NoSuchAlgorithmException e) {
            result.error("400", "hashing error", e);
            e.printStackTrace();

        }
    }

    @Override
    public boolean onActivityResult(int requestCode, int resultCode, Intent data) {
        // Result Code is -1 send from Payumoney activity
        Log.d(FlutterPayUMoneyPlugin.TAG, "request code " + requestCode + " resultcode " + resultCode);
        if (requestCode == PayUmoneyFlowManager.REQUEST_CODE_PAYMENT && resultCode == RESULT_OK && data !=
                null) {
            TransactionResponse transactionResponse = data.getParcelableExtra(PayUmoneyFlowManager
                    .INTENT_EXTRA_TRANSACTION_RESPONSE);

            ResultModel resultModel = data.getParcelableExtra(PayUmoneyFlowManager.ARG_RESULT);
            // Check which object is non-null
            if (transactionResponse != null && transactionResponse.getPayuResponse() != null) {
                if (transactionResponse.getTransactionStatus().equals(TransactionResponse.TransactionStatus.SUCCESSFUL)) {
                    //Success Transaction
                    wholeResult.success(transactionResponse.getPayuResponse());
                } else {
                    //Failure Transaction
                    wholeResult.error("400", "Payment Failed", transactionResponse.getPayuResponse());
                }

            } else if (resultModel != null && resultModel.getError() != null) {
                Log.d(TAG, "Error response : " + resultModel.getError().getTransactionResponse());
            } else {
                Log.d(TAG, "Both objects are null!");
            }
        } else {
            if (requestCode == PayUmoneyFlowManager.REQUEST_CODE_PAYMENT)
                wholeResult.error("405","User Cancelled Payment",null);
        }
        return true;
    }
}
