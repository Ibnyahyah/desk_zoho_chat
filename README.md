# desk_zoho_chat

A flutter implementation of desk.zoho.com In-app support. You need desk.zoho.com widget code to use this plugin


Screenshots


## Getting Started
copy the your appId from the generated code gotten from desk.zoho.com dashboard

This plugin is depended on [InappWebView!](https://pub.dev/packages/flutter_inappwebview) so you'll need to set the necessary permissions 

For Android, in your Manifest.xml add :
```
<uses-permission android:name="android.permission.INTERNET"/>
```

```
<application
        android:label="desk_zoho_chat_example"
        android:icon="@mipmap/ic_launcher"
        android:usesCleartextTraffic="true"> //add this line
```



For iOS, in your Info.plist add:

```
<key>NSAppTransportSecurity</key>
    <dict>
      <key>NSAllowsArbitraryLoads</key>
      <true/>
      <key>NSAllowsArbitraryLoadsInWebContent</key>
      <true/>
    </dict>
    <key>NSAllowsLocalNetworking</key>
    <true/>
    <key>NSAllowsArbitraryLoadsInWebContent</key>
    <true/>
```


Get Your AppID From the desk.zoho.com
Assuming the widget code here is ** xxxxx **, copy it and use desk_desk_zoho_chat this way

```
        DeskZohoChat(
          zohoAppID: "xxxxx", //desk.zoho.com chat widget code
          preloaderSize: 100.0, //preloader size
          preloaderWidth: 3, //preloader border size
          preloaderColorHexString: "#2196f3", //preloader color code
        )

```