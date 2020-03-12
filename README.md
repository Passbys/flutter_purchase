# flutterpurchase

A new Flutter package.

## Getting Started

This project is a starting point for a Dart
[package](https://flutter.dev/developing-packages/),
a library module containing code that can be shared easily across
multiple Flutter or Dart projects.

For help getting started with Flutter, view our 
[online documentation](https://flutter.dev/docs), which offers tutorials, 
samples, guidance on mobile development, and a full API reference.

## Third-party libraries for payment references：
   https://pub.dev/packages/flutter_inapp_purchase#-example-tab-

## Integration steps
1、Add a reference to the main program pubspec.yaml file as follows:

   flutterpurchase:
     
     git:
      url: 'https://github.com/Passbys/flutter_purchase.git'
      ref: 'v0.0.1'
      
2、Add the following listeners needed to initialize the purchase in the main program (the following optional override methods):

 static setupPay(){   

    ///请求购买商品成功返回
    PaySettings.instance.onUpdatedPurchase = (context,productItem){
    
    };
    ///监听支付失败回调
    PaySettings.instance.onPurchaseError = (context){
     
    };

    ///支付后请求后端接口返回成功
    PaySettings.instance.onRequestAppStoreOrGoogle = (context,code,paySource,transactionId){
    
    };
    ///支付后请求后端接口返回失败 
    PaySettings.instance.onRequestAppStoreOrGoogleError = (context,paySource,transactionId){
     
    };
    ///发起请求购买商品后回调
    PaySettings.instance.onRequestPurchase = (purchase,source){
      
    };
    ///显示购买页面
    PaySettings.instance.onShowGcPay = (context,source){
      
    };
    ///显示加载圈
    PaySettings.instance.onShowProgress = (context){
      //showProgressDialog();
    };
    ///toast提示弹框
    PaySettings.instance.onShowToast = (context,toastMsg){
      if(toastMsg == 'networkError'){
        toastMsg = localized.networkError;
      }else if (toastMsg == PaySettings.FAILED_TO_RESTORE){
        toastMsg = localized.failedToRestore;
      }else if (toastMsg == PaySettings.RESTORED_SUCCESSFULLY){
        toastMsg = localized.restoredSuccessfully;
      }
      Toast.show(toastMsg, context);
    };
    
    ///销毁加载圈
    PaySettings.instance.onDismissProgress = (context){
      dismissProgressDialog();
    };
    
    ///恢复购买
    PaySettings.instance.onRestorePurchase = (context,item) {
      
    };
    PaySettings.instance.version = ParamUtil.instance.packageInfo.version;
    PaySettings.instance.deviceId = deviceId;
    PaySettings.instance.isDebug = isDebug;
    ///设置应用商店配置的有效商品id列表
    PaySettings.instance.productList = productLists;
  }
 
 
