

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
class InAppWebPag extends StatefulWidget {
  const InAppWebPag({Key? key}) : super(key: key);

  @override
  State<InAppWebPag> createState() => _InAppWebPagState();
}

class _InAppWebPagState extends State<InAppWebPag> {
   _onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Are you sure?'),
        content: new Text('Do you want to exit an App'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text('No'),
          ),
          TextButton(
            onPressed: () => SystemNavigator.pop(),
            child: new Text('Yes'),
          ),
        ],
      ),
    )) ?? false;
  }
  late InAppWebViewController webView;
  double _progress=0;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
       body: Stack(
         children: [
           WillPopScope(
             onWillPop: () async {
               if(await webView.canGoBack()){
                 webView.goBack();
                 return false;
               }else{
                 return _onWillPop();
               }
             },

             child: InAppWebView(
               initialUrlRequest: URLRequest(url: Uri.parse("https://www.walmart.com/")),
               onWebViewCreated: (InAppWebViewController cotroller){
                 webView=cotroller;
               },
               onProgressChanged: (InAppWebViewController controller,int progress){
                 setState(() {
                   _progress=progress/100;
                 });
               },
             ),
           ),

           _progress<1?Padding(
             padding: const EdgeInsets.all(8.0),
             child: SizedBox(height: 4,child: LinearProgressIndicator(
               value: _progress,
               backgroundColor: Colors.blueAccent.withOpacity(0.2),
             ),),
           ):SizedBox(),

         ],
       ),
      ),
    );
  }
}
