import 'dart:async';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'pay_settings.dart';

///App Store (on iOS)
///and Google Play (on Android) 内购
class InAppPurchase {
  StreamSubscription _purchaseUpdatedSubscription;
  StreamSubscription _purchaseErrorSubscription;

  // 工厂模式
  factory InAppPurchase() => _getInstance();

  static InAppPurchase get instance => _getInstance();
  static InAppPurchase _instance;

  String paySource = 'Premium';

  ///保存获取应用商品列表
  List<IAPItem> purchaseItems;

  ///选择支付的商品信息
  IAPItem purchase;

  InAppPurchase._internal() {
    // 初始化
  }

  static InAppPurchase _getInstance() {
    if (_instance == null) {
      _instance = new InAppPurchase._internal();
    }
    return _instance;
  }

  ///初始化应用内购买
  ///list 应用商店配置的productId
  Future<void> initPlatformState(context, list) async {
    try {
      // prepare
      var result = await FlutterInappPurchase.instance.initConnection;
      print("initPlatformStateinitPlatformState = " + result);
    } on Exception {
      print('请检查您的Google或apple store账号是否登陆！');
    }

    ///监听google或appstore支付成功回调
    _purchaseUpdatedSubscription =
        FlutterInappPurchase.purchaseUpdated.listen((productItem) {
      ///如果没有选中商品，不执行后面的验证请求
      if (purchase == null) return;

      ///订单终结的问题，在完成订单时终结订单
      if (Platform.isIOS) {
        FlutterInappPurchase.instance
            .finishTransactionIOS(productItem.purchaseToken);
      }

      /// google订单确认操作，
      /// 如果再3天内没有确认购买交易，则用户自动收到退款，同时
      /// Google Play会撤销该购买交易
      if (Platform.isAndroid) {
        FlutterInappPurchase.instance
            .acknowledgePurchaseAndroid(productItem.purchaseToken);
      }

      PaySettings.instance.onUpdatedPurchase(context,productItem);
    });

    ///监听失败回调
    _purchaseErrorSubscription =
        FlutterInappPurchase.purchaseError.listen((purchaseError) {
          PaySettings.instance.onPurchaseError(context);
    });

    _getProduct(list);
  }

  ///请求后端接口
  requestAppStoreOrGoogle(context,userId,productItem){

  }

  ///获取订阅商品详情列表
  Future _getProduct(list) async {
    List<IAPItem> items =
        await FlutterInappPurchase.instance.getSubscriptions(list);
    print(items);

    purchaseItems = items;
  }

  ///购买商品
  requestPurchase(int paySelectIndex, source) {
    paySource = source;
    purchase = InAppPurchase.instance.purchaseItems[paySelectIndex];
    FlutterInappPurchase.instance.requestPurchase(purchase.productId);

    /// 保存信息备用
    PaySettings.instance.onRequestPurchase(purchase,paySource);
  }

  /// 展示商品信息的逻辑
  showProductList(BuildContext context, String source, String toastMsg) {
    /// 如果商品信息没有获取成功，则重新获取商品信息
    if (InAppPurchase.instance.purchaseItems == null ||
        InAppPurchase.instance.purchaseItems.isEmpty) {
      PaySettings.instance.onShowProgress(context);
      try {
        FlutterInappPurchase.instance
            .getSubscriptions(PaySettings.instance.productList)
            .then((list) {
          InAppPurchase.instance.purchaseItems = list;

          ///商品列表信息获取成功之后才展示列表
          PaySettings.instance.onShowGcPay(context,source);
          if (toastMsg != null && toastMsg.isNotEmpty) {
            PaySettings.instance.onShowToast(context,toastMsg);
          }
          PaySettings.instance.onDismissProgress(context);
        }).catchError((error) {
          PaySettings.instance.onShowToast(context,'networkError');
          PaySettings.instance.onDismissProgress(context);
        }).whenComplete(() {
          PaySettings.instance.onDismissProgress(context);
        });
      } catch (error) {
        PaySettings.instance.onShowToast(context,'networkError');
        PaySettings.instance.onDismissProgress(context);
      }
    } else {
      if (toastMsg != null && toastMsg.isNotEmpty) {
        PaySettings.instance.onShowToast(context,toastMsg);
      }
      ///展示列表
      PaySettings.instance.onShowGcPay(context,source);
      PaySettings.instance.onDismissProgress(context);
    }
  }

  /// 获取购买历史
  Future getPurchaseHistory() async {
    List<PurchasedItem> itemList =
        await FlutterInappPurchase.instance.getPurchaseHistory();
    return itemList;
  }

  /// 恢复购买 ios的
  Future<void> restorePurchase(BuildContext context) async {
    PaySettings.instance.onShowProgress(context);

    List<PurchasedItem> items = await getPurchaseHistory();
    if (items != null && items.isNotEmpty) {
      PaySettings.instance.onRestorePurchase(context,items.last);
    } else {
      restoredSuccessfully(context);
    }
  }

  ///恢复购买请求后台
  restoreHistoryPurchase(context,item, lastIAPItem, userId){
    /// 提交
  }

  restoredSuccessfully(context){
    PaySettings.instance.onDismissProgress(context);
    PaySettings.instance.onShowToast(context,PaySettings.RESTORED_SUCCESSFULLY);
  }

  failedToRestore(context){
    PaySettings.instance.onDismissProgress(context);
    PaySettings.instance.onShowToast(context,PaySettings.FAILED_TO_RESTORE);
  }

  ///关闭连接
  Future cancelPurchase() async {
    await FlutterInappPurchase.instance.endConnection;
    if (_purchaseErrorSubscription != null &&
        _purchaseUpdatedSubscription != null) {
      _purchaseUpdatedSubscription.cancel();
      _purchaseUpdatedSubscription = null;
      _purchaseErrorSubscription.cancel();
      _purchaseErrorSubscription = null;
    }
  }
}
