import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:quotationsgenerator/assets/translations/en.dart';
import 'package:quotationsgenerator/helpers/constants.dart';
import 'package:quotationsgenerator/helpers/utils.dart';
import 'package:quotationsgenerator/styles/css.dart';
import 'package:quotationsgenerator/features/quotation/quotation.dart';
import 'package:quotationsgenerator/helpers/extensions.dart';

class QuotationState extends State<Quotation> {
  final pdf = pw.Document();
  List totalPriceTECs = [];
  List unitTECs = [];
  List<TextEditingController> itemTECs = [];
  List<TextEditingController> legendTECs = [];
  List<TextEditingController> quantityTECs = [];
  List<TextEditingController> unitPriceTECs = [];
  List<Widget> _items = <Widget>[];
  double _formHeight = defaultFormHeight;
  String _grandTotalPrice = 'PHP 0.00';
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int _index = 0;
  List _error = [];
  List<String> _units = units;
  String _date = '$dateLabel ${convertDate(DateTime.now().toString())}';
  String _path = '';
  String _projectVal = '';
  TextEditingController _email = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  TextEditingController _noteController = TextEditingController();
  TextEditingController _projectController = TextEditingController();

  @override
  void initState() {
    super.initState();

    /// Sets state after load.
    postInit(() {
      setState(() {
        _items.add(_createForm());
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          Padding(
            child: GestureDetector(
              child: Icon(
                Icons.send,
                size: 26.0,
              ),
              onTap: () {
                bool valid = _formKey.currentState!.validate();

                _calculateFormHeight();
                if (valid) {
                  _generatePDF();
                }
              },
            ),
            padding: EdgeInsets.only(right: 20.0),
          ),
        ],
        elevation: 0,
        backgroundColor: secondarySwatch,
        title: Text(widget.title),
      ),
      backgroundColor: formAppBarBackground,
      body: SingleChildScrollView(child: Container(child: _buildForm(context))),
    );
  }

  /// Builds the whole form in the current [context].
  Widget _buildForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        child: Column(
          children: <Widget>[
            SingleChildScrollView(
              child: Row(children: <Widget>[
                Container(
                  child: TextFormField(
                    controller: _email,
                    cursorColor: Colors.white,
                    decoration: InputDecoration(
                      focusedBorder: fieldBorder,
                      labelText: to,
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      return validator(value, min: 5, max: 100);
                    },
                  ),
                  padding: formPadding,
                  width: fullFormWidth(context),
                ),
              ]),
              scrollDirection: Axis.horizontal,
            ),
            SingleChildScrollView(
              child: Row(children: <Widget>[
                Container(
                  child: TextFormField(
                    controller: _projectController,
                    cursorColor: Colors.white,
                    decoration: InputDecoration(
                      focusedBorder: fieldBorder,
                      labelText: project,
                    ),
                    validator: (value) {
                      return validator(value, min: 5, max: 100);
                    },
                  ),
                  padding: formPadding,
                  width: fullFormWidth(context),
                ),
              ]),
              scrollDirection: Axis.horizontal,
            ),
            SingleChildScrollView(
              child: Row(children: <Widget>[
                Container(
                  child: Text(
                    '$appTitle\n$templateHeader',
                    textAlign: TextAlign.center,
                  ),
                  padding: formPadding,
                  width: fullFormWidth(context),
                ),
              ]),
              scrollDirection: Axis.horizontal,
            ),
            SingleChildScrollView(
              child: Row(children: <Widget>[
                Container(
                  child: Text(
                    _date,
                    textAlign: TextAlign.right,
                  ),
                  padding: formPadding,
                  width: fullFormWidth(context),
                ),
              ]),
              scrollDirection: Axis.horizontal,
            ),
            SingleChildScrollView(
              child: Row(children: <Widget>[
                Container(
                  child: TextFormField(
                    controller: _locationController,
                    cursorColor: Colors.white,
                    decoration: InputDecoration(
                      focusedBorder: fieldBorder,
                      labelText: location,
                    ),
                    validator: (value) {
                      return validator(value, min: 5, max: 100);
                    },
                  ),
                  padding: formPadding,
                  width: fullFormWidth(context),
                ),
              ]),
              scrollDirection: Axis.horizontal,
            ),
            SingleChildScrollView(
              child: Row(children: <Widget>[
                Container(
                  child: Column(
                    children: [
                      ListView.builder(
                        itemBuilder: (BuildContext context, int index) {
                          return _items[index];
                        },
                        itemCount: _items.length,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                      )
                    ],
                  ),
                  height: _formHeight,
                  width: fullFormWidth(context),
                ),
              ]),
              scrollDirection: Axis.horizontal,
            ),
            SingleChildScrollView(
              child: Row(children: <Widget>[
                Container(
                  child: IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () => setState(() {
                            _index += 1;
                            _formHeight += defaultFormHeight;
                            _items.add(_createForm(i: _index));
                          })),
                  decoration: BoxDecoration(
                    border: Border.all(width: 2, color: Colors.black26),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  margin: boxing,
                  padding: formPadding,
                )
              ]),
              scrollDirection: Axis.horizontal,
            ),
            SingleChildScrollView(
              child: Row(children: <Widget>[
                Container(
                  child: Text(
                    _grandTotalPrice,
                    textAlign: TextAlign.right,
                  ),
                  padding: formPadding,
                  width: fullFormWidth(context),
                ),
              ]),
              scrollDirection: Axis.horizontal,
            ),
            SingleChildScrollView(
              child: Row(children: <Widget>[
                Container(
                  child: TextFormField(
                    controller: _noteController,
                    cursorColor: Colors.white,
                    decoration: InputDecoration(
                      focusedBorder: fieldBorder,
                      labelText: note,
                    ),
                  ),
                  padding: formPadding,
                  width: fullFormWidth(context),
                ),
              ]),
              scrollDirection: Axis.horizontal,
            ),
            SingleChildScrollView(
              child: Row(children: <Widget>[
                Container(
                  child: Text(
                    templateFooter,
                    textAlign: TextAlign.center,
                  ),
                  padding: formPadding,
                  width: fullFormWidth(context),
                ),
              ]),
              scrollDirection: Axis.horizontal,
            ),
          ],
        ),
        padding: formPadding,
        width: MediaQuery.of(context).size.width,
      ),
    );
  }

  /// Returns the String [_rows] list containing the items and its particulars.
  _buildItems() {
    List<List<String>> _rows = <List<String>>[];

    _rows.add(<String>[legend, qty, 'UNIT', item, price, total]);

    for (var indice = 0; indice < _index + 1; indice++) {
      List<String> row = <String>[
        legendTECs[indice].text,
        quantityTECs[indice].text,
        unitTECs[indice],
        itemTECs[indice].text,
        'PHP ${unitPriceTECs[indice].text}',
        'PHP ${totalPriceTECs[indice].toStringAsFixed(2)}',
      ];

      _rows.add(row);
    }

    return _rows;
  }

  /// Sets the form height based on how many sets of fields are there.
  void _calculateFormHeight() {
    double errCount = _error.length.toDouble();
    double itemCount = _items.length.toDouble();

    _formHeight = (errCount * 110.0) + ((itemCount - errCount) * 80.0);
  }

  /// Returns the additional set of fields for the form.
  Widget _createForm({i = 0}) {
    double totalPriceController = 0.0;
    String unitController = 'UNIT';
    TextEditingController itemController = TextEditingController();
    TextEditingController legendController = TextEditingController();
    TextEditingController quantityController = TextEditingController();
    TextEditingController unitPriceController = TextEditingController();

    /// Add controllers to avoid overwriting values.
    itemTECs.add(itemController);
    legendTECs.add(legendController);
    quantityTECs.add(quantityController);
    totalPriceTECs.add(totalPriceController);
    unitPriceTECs.add(unitPriceController);
    unitTECs.add(unitController);

    return Row(
      key: UniqueKey(),
      children: [
        Container(
          child: TextFormField(
            decoration: InputDecoration(
              focusedBorder: fieldBorder,
              labelText: legend,
            ),
            controller: legendTECs[i],
            textAlign: TextAlign.right,
            validator: (value) {
              return _validator('legend', value, i, max: 5);
            },
          ),
          padding: formPadding,
          width: MediaQuery.of(context).size.width * .14,
        ),
        Container(
          child: TextFormField(
            controller: quantityTECs[i],
            cursorColor: Colors.white,
            decoration: InputDecoration(
              focusedBorder: fieldBorder,
              labelText: qty,
            ),
            keyboardType: TextInputType.number,
            onChanged: (newValue) {
              _onChange();
            },
            textAlign: TextAlign.right,
            validator: (value) {
              return _validator('qty', value, i, max: 3);
            },
          ),
          padding: formPadding,
          width: MediaQuery.of(context).size.width * .1,
        ),
        Container(
          child: DropdownButtonFormField<String>(
            elevation: 16,
            icon: const Icon(Icons.arrow_drop_down),
            iconSize: 24,
            items: _units.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                child: Text(value),
                value: value,
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                unitTECs[i] = newValue!;
              });
            },
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            validator: (value) {
              return _validator('unit', value, i, defaultVal: 'UNIT');
            },
            value: unitTECs[i],
          ),
          padding: boxing,
          width: MediaQuery.of(context).size.width * .11,
        ),
        Container(
          child: TextFormField(
            controller: itemTECs[i],
            cursorColor: Colors.white,
            decoration: InputDecoration(
              focusedBorder: fieldBorder,
              labelText: item,
            ),
            validator: (value) {
              return _validator('item', value, i, min: 5, max: 100);
            },
          ),
          padding: formPadding,
          width: MediaQuery.of(context).size.width * .27,
        ),
        Container(
          child: TextFormField(
            controller: unitPriceTECs[i],
            cursorColor: Colors.white,
            decoration: InputDecoration(
              focusedBorder: fieldBorder,
              labelText: price,
            ),
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            onChanged: (newValue) {
              _onChange();
            },
            textAlign: TextAlign.right,
            validator: (value) {
              return _validator('price', value, i, min: 3, max: 15);
            },
          ),
          padding: formPadding,
          width: MediaQuery.of(context).size.width * .17,
        ),
        Container(
          child: TextFormField(
            decoration: InputDecoration(
              focusedBorder: fieldBorder,
              labelText: total,
            ),
            controller: TextEditingController(
                text: totalPriceTECs[i].toStringAsFixed(2)),
            readOnly: true,
            textAlign: TextAlign.right,
            validator: (value) {
              return _validator('total', value, i, min: 3, max: 15);
            },
          ),
          padding: formPadding,
          width: MediaQuery.of(context).size.width * .19,
        ),
      ],
    );
  }

  /// Generates the PDF file from form values.
  _generatePDF() async {
    String locationVal = _locationController.text;
    String noteVal = _noteController.text;

    _projectVal = _projectController.text;

    pdf.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      build: (pw.Context context) => <pw.Widget>[
        pw.Header(
            level: 0,
            child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: <pw.Widget>[
                  pw.Text(appTitle),
                ])),
        pw.Text(templateHeader),
        pw.SizedBox(height: 40),
        pw.Text(_date),
        pw.SizedBox(height: 20),
        pw.Text('$project: $_projectVal\n$location: $locationVal'),
        pw.SizedBox(height: 20),
        pw.Table.fromTextArray(context: context, data: _buildItems()),
        pw.SizedBox(height: 20),
        pw.Text(_grandTotalPrice),
        pw.SizedBox(height: 20),
        pw.Text('$note $noteVal'),
        pw.SizedBox(height: 48),
        pw.Text(templateFooter, textAlign: pw.TextAlign.center)
      ],
    ));

    _savePDF();
  }

  /// Computes the total prices.
  _onChange() {
    for (int i = 0; i < _items.length; i++) {
      String price = unitPriceTECs[i].text;
      String qty = quantityTECs[i].text;
      int quantity = qty.isNotEmpty ? int.parse(qty) : 0;
      double unitPrice = price.isNotEmpty ? double.parse(price) : 0.0;

      totalPriceTECs[i] = quantity * unitPrice;
      _grandTotalPrice =
          '$grandTotalPrice PHP ${totalPriceTECs.reduce((value, element) => value + element).toStringAsFixed(2)}';
      _items[i] = _createForm(i: i);
    }
  }

  /// Writes the PDF file into the device.
  _savePDF() async {
    final output = await getTemporaryDirectory();
    _path = '${output.path}/$_projectVal.pdf';

    File file = File(_path);
    await file.writeAsBytes(await pdf.save()).then((value) => _sendEmail());
  }

  /// Sends the form content.
  _sendEmail() async {
    final Email email = Email(
      body: emailBody,
      subject: '$subject ${_projectController.text}',
      recipients: [_email.text],
      attachmentPaths: [_path],
      isHTML: false,
    );

    await FlutterEmailSender.send(email)
        .then((value) => Navigator.pop(context));
  }

  /// Validates the form and determines how many sets of fields has error in it.
  _validator(field, val, i, {defaultVal = '', min = 0, max = 0}) {
    final message = validator(val, defaultVal: defaultVal, min: min, max: max);
    final obj = {
      // ignore: unnecessary_null_comparison
      [field]: message == null
    };

    setState(() {
      // ignore: unnecessary_null_comparison
      if (message == null) {
        if (!obj.containsValue(false)) {
          _error.remove(i);
        }
      } else {
        if (_error.asMap().containsKey(i)) {
          _error[i].add(obj);
        } else {
          _error.add([obj]);
        }
      }
    });

    return message;
  }
}
