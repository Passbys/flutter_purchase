
import 'package:flutter/cupertino.dart';
import 'package:flutter_inapp_purchase/modules.dart';

typedef ContextCallback = void Function(BuildContext context);
typedef RestorePurchaseCallback = void Function(BuildContext context,PurchasedItem item);
typedef RequestPurchaseCallback = void Function(IAPItem purchase,String paySource);
typedef PurchaseUpdatedCallback = void Function(BuildContext context,PurchasedItem purchase);
typedef ShowProgressDialog = void Function(BuildContext context);
typedef DismissProgressDialog = void Function(BuildContext context);
typedef ShowGcPayDialog = void Function(BuildContext context,String source);
typedef ShowToast = void Function(BuildContext context,String text);
typedef RequestAppStoreOrGoogle = void Function(BuildContext context,int code,String paySource,String transactionId);
typedef RequestAppStoreOrGoogleError = void Function(BuildContext context,String paySource,String transactionId);

///支付模块设置
class PaySettings{

  static PaySettings _instance;
  PaySettings._();
  static PaySettings get instance {
    if (_instance == null) {
      _instance = PaySettings._();
    }

    return _instance;
  }

  static final String FAILED_TO_RESTORE = 'failedToRestore';
  static final String RESTORED_SUCCESSFULLY = 'restoredSuccessfully';

  ///监听支付失败回调
  ContextCallback onPurchaseError = (context) {

  };

  ShowProgressDialog onShowProgress = (context) {

  };

  DismissProgressDialog onDismissProgress = (context) {

  };

  ///显示购买页面
  ShowGcPayDialog onShowGcPay = (context,source) {

  };

  ShowToast onShowToast = (context,text) {

  };

  ///请求购买商品
  RequestPurchaseCallback onRequestPurchase = (purchase,paySource) {

  };

  ///请求购买商品成功返回
  PurchaseUpdatedCallback onUpdatedPurchase = (context,purchase) {

  };

  ///恢复购买
  RestorePurchaseCallback onRestorePurchase = (purchase,item) {

  };

  ///支付后请求后端接口返回成功
  RequestAppStoreOrGoogle onRequestAppStoreOrGoogle = (context,code,paySource,transactionId) {

  };

  ///支付后请求后端接口返回失败
  RequestAppStoreOrGoogleError onRequestAppStoreOrGoogleError = (context,paySource,transactionId) {

  };

  bool isDebug = false;

  List<String> productList;

  String deviceId = '';

  String version = '';

  String cookie = '';

}