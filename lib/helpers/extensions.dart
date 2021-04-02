import 'package:flutter/material.dart';

extension StateExtension<T extends StatefulWidget> on State<T> {
  Stream waitForStateLoading() async* {
    while (!mounted) {
      yield false;
    }
    yield true;
  }

  Future<void> postInit(VoidCallback action) async {
    // ignore: unused_local_variable
    await for (var isLoaded in waitForStateLoading()) {}
    action();
  }
}
