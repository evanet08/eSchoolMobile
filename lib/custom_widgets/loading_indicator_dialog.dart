import 'package:flutter/material.dart';

class LoadingIndicatorDialog {
  static final LoadingIndicatorDialog _singleton =
      LoadingIndicatorDialog._internal();
  late BuildContext _context;
  bool isDisplayed = false;

  factory LoadingIndicatorDialog() {
    return _singleton;
  }
  LoadingIndicatorDialog._internal();
  show(BuildContext context, {String text = "Loading"}) {
    isDisplayed = false;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        _context = context;
        isDisplayed = true;
        return PopScope(
          child: SimpleDialog(
            backgroundColor: Colors.black.withOpacity(0.0),
            children: [
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 16.0, right: 16.0),
                      child: CircularProgressIndicator(
                        strokeWidth: 6.0,
                        color: Colors.white,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(text),
                    ),
                  ],
                ),
              ),
            ],
          ),
          onPopInvokedWithResult: (bool x, data) async => false,
        );
      },
    );
  }

  dismiss() {
    if (isDisplayed) {
      Navigator.of(_context).pop();
      isDisplayed = false;
    }
  }
}
