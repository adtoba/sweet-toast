library sweet_toast;

import 'package:flutter/material.dart';

class SweetToast {
  // Specifies the duration in which the toast will be displayed
  static final int LENGTH_SHORT = 1;
  static final int LENGTH_LONG = 2;

  static final int CENTER = 0;
  static final int BOTTOM = 1;
  static final int TOP = 2;

  static final int SUCCESS_TOAST = 0;
  static final int DEFAULT_TOAST = 1;
  static final int ERROR_TOAST = 2;
  static final int INFO_TOAST = 3;

  static void display(
      {BuildContext context,
      String message,
      int duration = 1,
      int gravity = 0,
      Color textColor,
      Color backgroundColor,
      Icon icon,
      int toastType}) {
    SweetToastView.dismiss();
    SweetToastView.create(context, message, duration, gravity, textColor,
        backgroundColor, icon, toastType);
  }
}

class SweetToastView {
  static final SweetToastView _singleton = new SweetToastView._internal();

  factory SweetToastView() {
    return _singleton;
  }

  SweetToastView._internal();

  static OverlayEntry _overlayEntry;
  static OverlayState _overlayState;
  static bool _isVisible = false;

  static void create(
      BuildContext context,
      String message,
      int duration,
      int gravity,
      Color textColor,
      Color backgroundColor,
      Icon icon,
      int toastType) async {
    _overlayState = Overlay.of(context);

    

    _overlayEntry = new OverlayEntry(
        builder: (BuildContext context) => SweetToastWidget(
              gravity: gravity,
              widget: Wrap(
                children: <Widget>[
                  Container(
                    height: 50.0,
                    width: MediaQuery.of(context).size.width / 1.2,

                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(20.0),
                      color: toastType == 0
                          ? Colors.green
                          : toastType == 1
                              ? Colors.black
                              : toastType == 2
                                  ? Colors.red
                                  : toastType == 3
                                      ? Colors.blue
                                      : backgroundColor == null
                                          ? Colors.black.withOpacity(0.8)
                                          : backgroundColor,
                    ),
                    // margin: EdgeInsets.symmetric(horizontal: 20.0),
                    padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        toastType == 0
                            ? Icon(Icons.check, color: Colors.white)
                            : toastType == 1
                                ? SizedBox(
                                    width: 0,
                                  )
                                : toastType == 2
                                    ? Icon(Icons.cancel, color: Colors.white)
                                    : toastType == 3
                                        ? Icon(
                                            Icons.info,
                                            color: Colors.white,
                                          )
                                        : icon == null
                                            ? SizedBox(
                                                width: 0,
                                              )
                                            : icon,
                        SizedBox(
                          width: 20.0,
                        ),
                        Expanded(
                          child: Text(
                            message,
                            textAlign: TextAlign.start,
                            softWrap: true,
                            style: TextStyle(
                                fontSize: 15,
                                color: textColor == null
                                    ? Colors.white
                                    : textColor),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ));
    _isVisible = true;
    _overlayState.insert(_overlayEntry);
    await Future.delayed(Duration(
        seconds: duration == null ? SweetToast.LENGTH_SHORT : duration));
    dismiss();
  }

  static dismiss() async {
    if (!_isVisible) {
      return;
    }
    _isVisible = false;
    _overlayEntry?.remove();
  }
}

class SweetToastWidget extends StatelessWidget {
  SweetToastWidget({@required this.widget, @required this.gravity});

  final Widget widget;
  final int gravity;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: gravity == 0
          ? Alignment.center
          : gravity == 1 ? Alignment.bottomCenter : Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Material(
          child: widget,
        ),
      ),
    );
  }
}
