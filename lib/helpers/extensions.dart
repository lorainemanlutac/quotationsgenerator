import 'package:flutter/material.dart';

extension StateExtension<T extends StatefulWidget> on State<T> {
  Future<void> postInit(VoidCallback action) async {
    // ignore: unused_local_variable
    await for (bool isLoaded in waitForStateLoading()) {}

    action();
  }

  Stream waitForStateLoading() async* {
    while (!mounted) {
      yield false;
    }

    yield true;
  }
}
