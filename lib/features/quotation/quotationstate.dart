import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:quotationsgenerator/assets/translations/en.dart';
import 'package:quotationsgenerator/helpers/constants.dart';
import 'package:quotationsgenerator/helpers/utils.dart';
import 'package:quotationsgenerator/styles/css.dart';
import 'package:quotationsgenerator/features/quotation/quotation.dart';
import 'package:quotationsgenerator/helpers/extensions.dart';

class QuotationState extends State<Quotation> {
  List totalPriceTECs = [];
  List unitTECs = [];
  List<TextEditingController> itemTECs = [];
  List<TextEditingController> legendTECs = [];
  List<TextEditingController> quantityTECs = [];
  List<TextEditingController> unitPriceTECs = [];
  List<Widget> _items = <Widget>[];
  double _formHeight = defaultFormHeight;
  String _grandTotalPrice = '0.00';
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int _index = 0;
  List _error = [];
  List<String> _units = units;
  String _date = convertDate(DateTime.now().toString());

  @override
  void initState() {
    super.initState();
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
                final valid = _formKey.currentState!.validate();

                _calculateFormHeight();
                if (valid) {
                  // If the form is valid, display a snackbar. In the real world,
                  // you'd often call a server or save the information in a database.
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(sendingEmail)))
                      .closed
                      .then((value) => Navigator.pop(context));
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
                    cursorColor: Colors.white,
                    decoration: InputDecoration(
                      focusedBorder: fieldBorder,
                      labelText: subject,
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
                    templateHeader,
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
                    '$dateLabel $_date',
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
                    '$grandTotalPrice ₱ $_grandTotalPrice',
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

  Widget _createForm({i = 0}) {
    double totalPriceController = 0.0;
    String unitController = 'UNIT';
    TextEditingController itemController = TextEditingController();
    TextEditingController legendController = TextEditingController();
    TextEditingController quantityController = TextEditingController();
    TextEditingController unitPriceController = TextEditingController();

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

  void _calculateFormHeight() {
    final errCount = _error.length.toDouble();
    final itemCount = _items.length.toDouble();

    _formHeight = (errCount * 110.0) + ((itemCount - errCount) * 80.0);
  }

  _onChange() {
    for (int i = 0; i < _items.length; i++) {
      final price = unitPriceTECs[i].text;
      final qty = quantityTECs[i].text;
      var quantity = qty.isNotEmpty ? int.parse(qty) : 0;
      var unitPrice = price.isNotEmpty ? double.parse(price) : 0.0;

      totalPriceTECs[i] = quantity * unitPrice;
      _grandTotalPrice = totalPriceTECs
          .reduce((value, element) => value + element)
          .toStringAsFixed(2);
      _items[i] = _createForm(i: i);
    }
  }

  _validator(field, val, i, {defaultVal = '', min = 0, max = 0}) {
    final message = validator(val, defaultVal: defaultVal, min: min, max: max);
    final obj = {
      [field]: message == null
    };

    setState(() {
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
