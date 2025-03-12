import 'dart:collection';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:flutter_inappwebview/flutter_inappwebview.dart';

final InAppLocalhostServer localhostServer =
    new InAppLocalhostServer(port: 2021, shared: true);

class DeskZohoChat extends StatefulWidget {
  ///the generated appID copied from the deck.zoho.com chat script.
  final String zohoAppID;

  const DeskZohoChat({
    required this.zohoAppID,
  });

  @override
  _DeskZohoChatState createState() {
    return _DeskZohoChatState(
      zohoAppID,
    );
  }
}

class _DeskZohoChatState extends State<DeskZohoChat> {
  final String zohoAppID;

  _DeskZohoChatState(
    this.zohoAppID,
  );

  final GlobalKey webViewKey = GlobalKey();

  InAppWebViewController? webViewController;

  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
    crossPlatform: InAppWebViewOptions(
      javaScriptEnabled: true,
      clearCache: true,
      cacheEnabled: false,
      useOnLoadResource: true,
    ),
    ios: IOSInAppWebViewOptions(
      allowsInlineMediaPlayback: true,
      allowsAirPlayForMediaPlayback: true,
      allowsPictureInPictureMediaPlayback: true,
    ),
  );

  bool showErrorPage = false;
  String errorMessage = '';
  bool startedServer = false;

  void init() async {
    try {
      print("---- Start Server");
      await localhostServer.start();
      print("---- Done Start Server");
      setState(() {
        startedServer = true;
      });
      print("----- Done With Server");
    } catch (e) {
      print("---- Error Server");
      print(e);
      print("----- Down With Error Server");
    }
  }

  @override
  void initState() {
    init();

    super.initState();
  }

  @override
  void dispose() {
    if (localhostServer.isRunning()) localhostServer.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String functionBody = """
      // Initialize the ZOHOIM object if it doesn't already exist
      window.ZOHOIM = window.ZOHOIM || function(a,b){
        ZOHOIM[a]=b;
      };
      window.ZOHOIM.prefilledMessage="";

     (function(){
        var d = document; 
        var s = d.createElement('script');
        s.type='text/javascript';

        // Set the nonce attribute, if needed
        s.nonce='{place_your_nonce_value_here}';
        console.log("----Loading Script");
        // Defer the loading of the script to prevent it from blocking page rendering
        s.defer=true;

        // The source URL for the Zoho IM widget script
        s.src=`https://im.zoho.com/api/v1/public/channel/${zohoAppID}/widget`;
        // Append the script to the document's head
        d.getElementsByTagName('head')[0].appendChild(s);
        console.log("----Done Script");
     })()

      // Function to automatically click the button after the widget loads
      function tryClickButton() {
          // Select the element using its class name
          var chatButton = document.querySelector('.zd_imc40443ffa5');

          // Simulate a click on the button if it exists
          if (chatButton) {
             localStorage.setItem('buttonClicked', 'false');
              chatButton.click();
          }
      }
      // Add an event listener to try clicking the button every second until it succeeds
      var intervalId = setInterval(function() {
          tryClickButton();
          // Clear the interval if the button was found and clicked
          if (document.querySelector('.zd_imc40443ffa5')) {
              clearInterval(intervalId);
              localStorage.setItem('buttonClicked', 'opened');
          }
      }, 1000);
""";

    print("startedServer $startedServer");
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
              child: Stack(
            children: <Widget>[
              Column(children: <Widget>[
                startedServer == true
                    ? Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: InAppWebView(
                          key: webViewKey,
                          initialOptions: options,
                          initialUrlRequest: URLRequest(
                            url: Platform.isIOS
                                ? WebUri.uri(Uri.parse(
                                    "http://localhost:2021/packages/desk_zoho_chat/assets/index2.html"))
                                : WebUri.uri(Uri.parse(
                                    "http://localhost:2021/packages/desk_zoho_chat/assets/index.html")),
                          ),
                          // initialFile: Platform.isIOS
                          //     ? "http://localhost:2021/packages/desk_zoho_chat/assets/index2.html"
                          //     : "http://localhost:2021/packages/desk_zoho_chat/assets/index.html",
                          initialUserScripts: UnmodifiableListView<UserScript>([
                            UserScript(
                              source: functionBody,
                              injectionTime:
                                  UserScriptInjectionTime.AT_DOCUMENT_END,
                            ),
                          ]),

                          shouldOverrideUrlLoading:
                              (controller, navigationAction) async {
                            debugPrint("shouldOverrideUrlLoading");
                            return NavigationActionPolicy.ALLOW;
                          },
                          onWebViewCreated: (controller) {
                            webViewController = controller;

                            // Add JavaScript handler for communication
                            webViewController?.addJavaScriptHandler(
                              handlerName: 'onChatButtonClick',
                              callback: (args) {
                                // Close the Screen onCancel
                                Navigator.of(context).pop();
                              },
                            );
                          },
                          onLoadStart: (controller, url) async {
                            debugPrint("onLoadStart console url: $url");
                          },
                          onLoadResource: (controller, resource) {
                            print("Loading resource: ${resource.url}");
                          },
                          onLoadStop: (controller, url) async {
                            debugPrint("onLoadStop console url: $url");

                            await controller.evaluateJavascript(
                              source: """
                                      // Wait for the DOM to be fully loaded
                                      document.addEventListener('click', function(event) {
                                          if (event.target.classList.contains('zd_imc40443ffa5')||event.target.classList.contains('zd_im3465592150')) {
                                            console.log(localStorage.getItem('buttonClicked') === 'opened');
                                            if (localStorage.getItem('buttonClicked') === 'opened') {
                                              localStorage.setItem('buttonClicked', 'false');
                                              window.flutter_inappwebview.callHandler('onChatButtonClick');
                                            }else{
                                              localStorage.setItem('buttonClicked', 'opened');
                                            }
                                          }
                                      });
                                      """,
                            );
                          },
                          onLoadError: (controller, url, code, message) async {
                            showError(message);
                            debugPrint("console url: $url");
                            debugPrint("console message: $message");
                            debugPrint("console code: $code");
                          },
                          onConsoleMessage: (controller, message) {
                            debugPrint("console message: $message");
                          },
                        ),
                      )
                    : Center(child: CircularProgressIndicator())
              ]),
              showErrorPage
                  ? Center(
                      child: Text("$errorMessage"),
                    )
                  : Container(),
            ],
          )),
        ),
      ),
    );
  }

  void showError(String error) {
    setState(() {
      errorMessage = error;
      showErrorPage = true;
    });
  }

  void hideError() {
    setState(() {
      errorMessage = '';
      showErrorPage = false;
    });
  }

  void reload() {
    webViewController?.reload();
  }
}
