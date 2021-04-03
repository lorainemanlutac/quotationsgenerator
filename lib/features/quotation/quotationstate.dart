import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:quotationsgenerator/assets/translations/en.dart';
import 'package:quotationsgenerator/helpers/utils.dart';
import 'package:quotationsgenerator/styles/css.dart';
import 'package:quotationsgenerator/features/quotation/quotation.dart';
import 'package:quotationsgenerator/helpers/extensions.dart';

class QuotationState extends State<Quotation> {
  double _formHeight = 80.0;
  final _formKey = GlobalKey<FormState>();
  int index = 0;
  List error = [];
  List<TextEditingController> itemTECs = [];
  List<TextEditingController> legendTECs = [];
  List<TextEditingController> quantityTECs = [];
  List<TextEditingController> totalPriceTECs = [];
  List<TextEditingController> unitPriceTECs = [];
  List<Widget> items = <Widget>[];
  String dropdown = 'UNIT';

  @override
  void initState() {
    super.initState();
    postInit(() {
      setState(() {
        items.add(_createForm(0));
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
                      .showSnackBar(SnackBar(content: Text(sendingEmail)));
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
    final date = convertDate(DateTime.now().toString());

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
                      return validator('email', value, '');
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
                      return validator('text', value, '');
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
                    'MLKJ Sash and Upholstery Furniture Shop\nAguinaldo Hi-way, Trece Martires Cavite 4109\nContact No.: +63 936 938 8505\nE-mail: theresa_manlutac@yahoo.com',
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
                    'Date: $date',
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
                      return validator('text', value, '');
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
                          return items[index];
                        },
                        itemCount: items.length,
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
                            index += 1;
                            _formHeight += 80.0;
                            items.add(_createForm(index));
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
                    'Total Price ₱\nOthers (Discount) \nGrand Total Price ',
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
                    'If you have any questions regarding the quotation, please feel free to contact us.\nTHANK YOU FOR YOUR BUSINESS!',
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

  Widget _createForm(i) {
    TextEditingController itemController = TextEditingController();
    TextEditingController legendController = TextEditingController();
    TextEditingController quantityController = TextEditingController();
    TextEditingController totalPriceController = TextEditingController();
    TextEditingController unitPriceController = TextEditingController();

    itemTECs.add(itemController);
    legendTECs.add(legendController);
    quantityTECs.add(quantityController);
    totalPriceTECs.add(totalPriceController);
    unitPriceTECs.add(unitPriceController);

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
              return _validator('text', value, '', i);
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
            items: <String>['UNIT', 'Set', 'Pc']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                child: Text(value),
                value: value,
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                dropdown = newValue!;
              });
            },
            validator: (value) {
              return _validator('select', value, 'UNIT', i);
            },
            value: dropdown,
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
              return _validator('text', value, '', i);
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
              return _validator('text', value, '', i);
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
            controller: totalPriceTECs[i],
            readOnly: true,
            textAlign: TextAlign.right,
          ),
          padding: formPadding,
          width: MediaQuery.of(context).size.width * .19,
        ),
      ],
    );
  }

  void _calculateFormHeight() {
    final errCount = error.length.toDouble();
    final itemCount = items.length.toDouble();

    _formHeight = (errCount * 110.0) + ((itemCount - errCount) * 80.0);
  }

  _onChange() {
    for (int i = 0; i < items.length; i++) {
      final price = unitPriceTECs[i].text;
      final qty = quantityTECs[i].text;
      var quantity = qty.isNotEmpty ? int.parse(qty) : 0;
      var unitPrice = price.isNotEmpty ? double.parse(price) : 0.0;
      var totalPrice = (quantity * unitPrice).toStringAsFixed(2);

      totalPrice = totalPrice == '0.00' ? '-' : totalPrice;
      totalPriceTECs[i] = TextEditingController(text: '₱ $totalPrice');
      items[i] = _createForm(i);
    }
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
