import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:quotationsgenerator/assets/translations/en.dart';
import 'package:quotationsgenerator/helpers/utils.dart';
import 'package:quotationsgenerator/styles/css.dart';
import 'package:quotationsgenerator/features/quotation/quotation.dart';
import 'package:quotationsgenerator/helpers/extensions.dart';

class QuotationState extends State<Quotation> {
  final _formKey = GlobalKey<FormState>();
  String dropdownValue = 'Unit';
  int quantityValue = 0;
  double unitPriceValue = 0.0;
  double totalPriceValue = 0.0;
  List<Widget> items = <Widget>[];
  double _formHeight = 80.0;
  int index = 0;
  List error = [];

  @override
  void initState() {
    super.initState();
    postInit(() {
      setState(() => items.add(_createForm(0)));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: formAppBarBackground,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: secondarySwatch,
        title: Text(widget.title),
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  final valid = _formKey.currentState!.validate();

                  _calculateFormHeight();
                  if (valid) {
                    // If the form is valid, display a snackbar. In the real world,
                    // you'd often call a server or save the information in a database.
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Sending email...')));
                  }
                },
                child: Icon(
                  Icons.send,
                  size: 26.0,
                ),
              )),
        ],
      ),
      body: SingleChildScrollView(child: Container(child: _buildForm(context))),
    );
  }

  Widget _buildForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        padding: formPadding,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: <Widget>[
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(children: <Widget>[
                Container(
                  padding: formPadding,
                  width: fullWidth(context),
                  child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    cursorColor: Colors.white,
                    decoration: InputDecoration(
                      labelText: to,
                      focusedBorder: fieldBorder,
                    ),
                    validator: (value) {
                      return validator('email', value, '');
                    },
                  ),
                ),
              ]),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(children: <Widget>[
                Container(
                  padding: formPadding,
                  width: fullWidth(context),
                  child: TextFormField(
                    cursorColor: Colors.white,
                    decoration: InputDecoration(
                      labelText: subject,
                      focusedBorder: fieldBorder,
                    ),
                    validator: (value) {
                      return validator('text', value, '');
                    },
                  ),
                ),
              ]),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(children: <Widget>[
                Container(
                  height: _formHeight,
                  width: fullWidth(context),
                  child: Column(
                    children: [
                      ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: items.length,
                        itemBuilder: (BuildContext context, int index) {
                          return items[index];
                        },
                      )
                    ],
                  ),
                ),
              ]),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(width: 2, color: Colors.black26)),
                  margin: boxing,
                  padding: formPadding,
                  child: IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () => setState(() {
                            index += 1;
                            _formHeight += 80.0;
                            items.add(_createForm(index));
                          })),
                )
              ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _createForm(i) {
    return Row(
      key: UniqueKey(),
      children: [
        Container(
            padding: formPadding,
            width: MediaQuery.of(context).size.width * .09,
            child: TextFormField(
              initialValue: (i + 1).toString(),
              readOnly: true,
              textAlign: TextAlign.right,
              decoration:
                  InputDecoration(labelText: no, focusedBorder: fieldBorder),
            )),
        Container(
          padding: formPadding,
          width: MediaQuery.of(context).size.width * .09,
          child: TextFormField(
            cursorColor: Colors.white,
            decoration: InputDecoration(
              labelText: 'Qty',
              focusedBorder: fieldBorder,
            ),
            textAlign: TextAlign.right,
            keyboardType: TextInputType.number,
            validator: (value) {
              return _validator('text', value, '', i);
            },
            onChanged: (newValue) {
              setState(() {
                quantityValue = int.parse(newValue);
                totalPriceValue = quantityValue * unitPriceValue;
              });
            },
          ),
        ),
        Container(
          padding: boxing,
          width: MediaQuery.of(context).size.width * .1,
          child: DropdownButtonFormField<String>(
            value: dropdownValue,
            icon: const Icon(Icons.arrow_drop_down),
            iconSize: 24,
            elevation: 16,
            onChanged: (String? newValue) {
              setState(() {
                dropdownValue = newValue!;
              });
            },
            validator: (value) {
              return _validator('select', value, 'Unit', i);
            },
            items: <String>['Unit', 'Set', 'Pc']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
        Container(
          padding: formPadding,
          width: MediaQuery.of(context).size.width * .36,
          child: TextFormField(
            cursorColor: Colors.white,
            decoration:
                InputDecoration(labelText: desc, focusedBorder: fieldBorder),
            validator: (value) {
              return _validator('text', value, '', i);
            },
          ),
        ),
        Container(
          padding: formPadding,
          width: MediaQuery.of(context).size.width * .17,
          child: TextFormField(
            cursorColor: Colors.white,
            textAlign: TextAlign.right,
            decoration:
                InputDecoration(labelText: price, focusedBorder: fieldBorder),
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            validator: (value) {
              return _validator('text', value, '', i);
            },
            onChanged: (newValue) {
              setState(() {
                unitPriceValue = double.parse(newValue);
                totalPriceValue = quantityValue * unitPriceValue;
              });
            },
          ),
        ),
        Container(
            padding: formPadding,
            width: MediaQuery.of(context).size.width * .17,
            child: TextFormField(
              readOnly: true,
              controller: TextEditingController(
                  text: totalPriceValue.toStringAsFixed(2)),
              textAlign: TextAlign.right,
              decoration:
                  InputDecoration(labelText: total, focusedBorder: fieldBorder),
            )),
      ],
    );
  }

  void _calculateFormHeight() {
    final itemCount = items.length.toDouble();
    final errCount = error.length.toDouble();

    _formHeight = (errCount * 110.0) + ((itemCount - errCount) * 80.0);
  }

  _validator(type, val, defaultVal, i) {
    final message = validator(type, val, defaultVal);

    setState(() {
      if (message == null) {
        error.remove(i);
      } else {
        if (!error.contains(i)) {
          error.add(i);
        }
      }
    });
    return message;
  }
}
