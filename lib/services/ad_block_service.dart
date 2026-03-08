import 'dart:typed_data';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class AdBlockService {
  static final List<String> _adDomains = [
    'doubleclick.net',
    'googleadservices.com',
    'googlesyndication.com',
    'facebook.com/tr',
    'ads.youtube.com',
    'adnxs.com',
    'pubmatic.com',
    'rubiconproject.com',
    'openx.net',
    'taboola.com',
    'outbrain.com',
    'criteo.com',
    'adroll.com',
    'media.net',
    'quantserve.com',
    'scorecardresearch.com',
    'zedo.com',
    'adzerk.net',
    'advertising.com',
    '2mdn.net',
    'yieldmanager.com',
    'adtechus.com',
    'atdmt.com',
    'bluekai.com',
    'contextweb.com',
    'exponential.com',
    'imrworldwide.com',
    'invitemedia.com',
    'mathtag.com',
    'media6degrees.com',
    'nexac.com',
    'omtrdc.net',
    'pointroll.com',
    'serving-sys.com',
    'sharethrough.com',
    'smartadserver.com',
    'sonobi.com',
    'spotxchange.com',
    'tremormedia.com',
    'turn.com',
    'videohub.tv',
    'vizury.com',
    'w55c.net',
    'xaxis.com',
    'yumenetworks.com',
    'ads.pubmatic.com',
    'ads.rubiconproject.com',
    'ads.openx.net',
    'ads.taboola.com',
    'ads.outbrain.com',
    'ads.criteo.com',
    'ads.adroll.com',
    'ads.media.net',
    'ads.quantserve.com',
    'ads.scorecardresearch.com',
    'ads.zedo.com',
  ];

  static Future<WebResourceResponse?> shouldInterceptRequest(InAppWebViewController controller, WebResourceRequest request) async {
    final url = request.url?.toString() ?? '';
    
    for (final adDomain in _adDomains) {
      if (url.contains(adDomain)) {
        return WebResourceResponse(
          statusCode: 204,
          headers: {},
          data: Uint8List(0),
        );
      }
    }
    
    return null;
  }
}
