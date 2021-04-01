import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:quotationsgenerator/helpers/utils.dart';
import 'package:quotationsgenerator/styles/css.dart';
import 'package:quotationsgenerator/widgets/quotation.dart';

class QuotationState extends State<Quotation> {
  final _formKey = GlobalKey<FormState>();
  String dropdownValue = 'Unit';
  String quantityValue = '0';
  String unitPriceValue = '0';

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
                onTap: () {},
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
    String totalPriceValue = '';

    return Form(
      key: _formKey,
      child: Container(
        padding: EdgeInsets.all(8.0),
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(children: <Widget>[
                Container(
                  padding: formPadding,
                  width: MediaQuery.of(context).size.width,
                  child: TextFormField(
                    cursorColor: Colors.white,
                    decoration: InputDecoration(
                      labelText: 'To',
                      focusedBorder: fieldBorder,
                    ),
                    validator: (value) {
                      return validator('text', value);
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
                  width: MediaQuery.of(context).size.width,
                  child: TextFormField(
                    cursorColor: Colors.white,
                    decoration: InputDecoration(
                      labelText: 'Subject',
                      focusedBorder: fieldBorder,
                    ),
                    validator: (value) {
                      return validator('text', value);
                    },
                  ),
                ),
              ]),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: <Widget>[
                  Container(
                    padding: formPadding,
                    width: MediaQuery.of(context).size.width * .03,
                    child: Text('1'),
                  ),
                  Container(
                    padding: formPadding,
                    width: MediaQuery.of(context).size.width * .14,
                    child: TextFormField(
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                        labelText: 'Quantity',
                        focusedBorder: fieldBorder,
                      ),
                      textAlign: TextAlign.right,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        return validator('text', value);
                      },
                      onChanged: (String? newValue) {
                        setState(() {
                          quantityValue = newValue!;
                        });
                        // ignore: unnecessary_null_comparison
                        if (quantityValue != null && unitPriceValue != null) {
                          totalPriceValue =
                              quantityValue * int.parse(unitPriceValue);
                        }
                      },
                    ),
                  ),
                  DropdownButton<String>(
                    value: dropdownValue,
                    icon: const Icon(Icons.arrow_drop_down),
                    iconSize: 24,
                    elevation: 16,
                    underline: Container(
                      height: 2,
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownValue = newValue!;
                      });
                    },
                    items: <String>['Unit', 'Set', 'Pc']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  Container(
                    padding: formPadding,
                    width: MediaQuery.of(context).size.width * .39,
                    child: TextFormField(
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                          labelText: 'Description', focusedBorder: fieldBorder),
                      validator: (value) {
                        return validator('text', value);
                      },
                    ),
                  ),
                  Container(
                    padding: formPadding,
                    width: MediaQuery.of(context).size.width * .16,
                    child: TextFormField(
                      cursorColor: Colors.white,
                      textAlign: TextAlign.right,
                      decoration: InputDecoration(
                          labelText: 'Unit Price', focusedBorder: fieldBorder),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        return validator('text', value);
                      },
                      onChanged: (String? newValue) {
                        setState(() {
                          unitPriceValue = newValue!;
                        });
                        // ignore: unnecessary_null_comparison
                        if (unitPriceValue != null && quantityValue != null) {
                          totalPriceValue =
                              quantityValue * int.parse(unitPriceValue);
                        }
                      },
                    ),
                  ),
                  Container(
                      padding: formPadding,
                      width: MediaQuery.of(context).size.width * .16,
                      child: Text(
                        'Total Price\n1',
                        textAlign: TextAlign.right,
                      )),
                ],
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(children: <Widget>[
                Container(
                  padding: formPadding,
                  child: IconButton(icon: Icon(Icons.add), onPressed: _onAdd),
                )
              ]),
            ),
          ],
        ),
      ),
    );
  }

  void _onAdd() {}
}
