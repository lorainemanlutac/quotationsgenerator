import 'dart:async';

import 'package:quotationsgenerator/models/QuotationModel.dart';

import 'Database.dart';

class QuotationsModelBloc {
  QuotationsModelBloc() {
    getQuotationsModel();
  }
  final _quotationModelController =
      StreamController<List<QuotationModel>>.broadcast();
  get quotationsModel => _quotationModelController.stream;

  dispose() {
    _quotationModelController.close();
  }

  add(QuotationModel quotationModel) {
    DBProvider.db.newQuotationModel(quotationModel);
    getQuotationsModel();
  }

  getQuotationsModel() async {
    _quotationModelController.sink
        .add(await DBProvider.db.getAllQuotationsModel());
  }
}
