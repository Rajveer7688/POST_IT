import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class NoAction extends StatefulWidget {
  const NoAction({super.key});

  @override
  State<NoAction> createState() => _NoActionState();
}

class _NoActionState extends State<NoAction> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        forceMaterialTransparency: true,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Padding(
              padding: EdgeInsets.only(left: 6),
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.black45,
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AutoSizeText(
              'No action available!',
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 16,
                fontWeight: FontWeight.w500,
                fontFamily: 'OpenSans',
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 40),
              child: TextButton(
                  onPressed: () { Navigator.of(context).pop(); },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(36),
                    ),
                  ),
                  child: const AutoSizeText(
                    'Go Back',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'OpenSans',
                    ),
              )),
            )
          ],
        ),
      ),
    );
  }
}
