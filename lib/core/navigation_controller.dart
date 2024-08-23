import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutterwave_standard/core/TransactionCallBack.dart';
import 'package:flutterwave_standard/view/FlutterwaveWebView.dart';
import 'package:flutterwave_standard/view/flutterwave_style.dart';
import 'package:http/http.dart';

import '../models/TransactionError.dart';
import '../models/requests/standard_request.dart';
import '../models/responses/standard_response.dart';

class NavigationController {
  Client client;
  final FlutterwaveStyle? style;
  final TransactionCallBack _callBack;

  NavigationController(this.client, this.style, this._callBack);

  /// Initiates initial transaction to get web url
  startTransaction(final StandardRequest request) async {
    try {
      final StandardResponse standardResponse =
          await request.execute(this.client);
      if (standardResponse.status == "error") {
        throw (TransactionError(standardResponse.message!));
      }
      openBrowser(standardResponse.data?.link ?? "", request.redirectUrl);
    } catch (error) {
      print("error is $error");
      throw (error);
    }
  }

  /// Opens browser with URL returned from startTransaction()

  openBrowser(
    String url,
    String redirectUrl, [
    bool isTestMode = false,
  ]) async {
    final FlutterwaveInAppBrowser browser =
        FlutterwaveInAppBrowser(callBack: _callBack);

    // Convert the URL to WebUri
    WebUri webUri = WebUri(url);

    // Define browser settings and web view settings
    var browserSettings = InAppBrowserSettings(
      hideUrlBar: true,
    );

    var webViewSettings = InAppWebViewSettings(
      javaScriptEnabled: true,
    );

    // Combine settings into InAppBrowserClassSettings
    var settings = InAppBrowserClassSettings(
      browserSettings: browserSettings,
      webViewSettings: webViewSettings,
    );

    // Open the URL using the combined settings
    await browser.openUrlRequest(
      urlRequest: URLRequest(url: webUri),
      settings: settings,
    );
  }
}
