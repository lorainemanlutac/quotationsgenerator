import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quotationsgenerator/assets/translations/en.dart';
import 'package:quotationsgenerator/helpers/utils.dart';
import 'package:quotationsgenerator/models/QuotationsModel.dart';
import 'package:quotationsgenerator/styles/css.dart';
import 'package:quotationsgenerator/features/quotation/quotation.dart';
import 'package:quotationsgenerator/features/quotations/quotations.dart';

final routeObserver = RouteObserver<PageRoute>();
final duration = const Duration(milliseconds: 300);

void main() => runApp(MaterialApp(
      home: Quotations(),
      navigatorObservers: [routeObserver],
    ));

class QuotationsState extends State<Quotations> with RouteAware {
  final _quotations = <QuotationsModel>[
    QuotationsModel(
      'Music Box',
      '2021-03-08T17:44:00.000Z',
      'Daruma Corporation',
    ),
    QuotationsModel(
      'QC Condo',
      '2021-03-08T17:44:00.000Z',
      'Isay Ramos',
    ),
  ];
  GlobalKey _fabKey = GlobalKey();

  @override
  dispose() {
    super.dispose();
    routeObserver.unsubscribe(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildQuotations(),
      floatingActionButton: _buildFAB(context, key: _fabKey),
    );
  }

  Widget _buildFAB(BuildContext context, {key}) => FloatingActionButton(
        elevation: 0,
        backgroundColor: secondarySwatch,
        key: key,
        onPressed: () => _pushQuotationForm(context),
        child: addIcon,
      );

  Widget _buildQuotations() {
    final length = _quotations.length;

    return ListView.builder(
        padding: padding,
        itemCount: length == 1 ? length : length * 2,
        itemBuilder: (context, i) {
          final index = i ~/ 2;

          if (i.isOdd) {
            return Divider();
          }

          return Dismissible(
            key: UniqueKey(),
            background: Container(
              color: Colors.red,
              padding: EdgeInsets.symmetric(horizontal: 20),
              alignment: AlignmentDirectional.centerEnd,
              child: Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
            direction: DismissDirection.endToStart,
            dismissThresholds: {DismissDirection.endToStart: 0.1},
            onDismissed: (direction) {
              return handleDismiss(direction, index);
            },
            child: _buildRow(_quotations[index]),
            confirmDismiss: (direction) => promptUser(direction),
          );
        });
  }

  void handleDismiss(direction, index) {
    final swipedQuotation = _quotations[index];

    _quotations.removeAt(index);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Deleted. Do you want to undo?'),
        duration: Duration(seconds: 5),
        action: SnackBarAction(
            label: 'Undo',
            textColor: Colors.yellow,
            onPressed: () {
              final copiedEmail = QuotationsModel.copy(swipedQuotation);
              setState(() => _quotations.insert(index, copiedEmail));
            }),
      ),
    );
  }

  Future<bool> promptUser(DismissDirection direction) async {
    return await showCupertinoDialog<bool>(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            content: Text('Are you sure you want to delete?'),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
              CupertinoDialogAction(
                child: Text('Cancel'),
                onPressed: () {
                  return Navigator.of(context).pop(false);
                },
              )
            ],
          ),
        ) ??
        false;
  }

  Widget _buildRow(quotation) {
    final subject = quotation.subject;
    final dateTime = convertDateTime(quotation.timestamp);
    final location = quotation.location;

    return ListTile(
      leading: Icon(
        Icons.article_outlined,
        color: secondarySwatch,
        size: iconSize,
      ),
      title: Text(subject),
      subtitle: Text('$dateTime\n$location'),
      onTap: () {
        _pushQuotation(subject);
      },
      trailing: Icon(
        Icons.arrow_right,
        color: secondarySwatch,
        size: iconSize,
      ),
    );
  }

  void _pushQuotation(String subject) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return Quotation(title: subject);
        },
      ),
    );
  }

  void _pushQuotationForm(BuildContext context) {
    final RenderBox fabRenderBox =
        _fabKey.currentContext!.findRenderObject() as RenderBox;
    final fabSize = fabRenderBox.size;
    final fabOffset = fabRenderBox.localToGlobal(Offset.zero);

    Navigator.of(context).push(PageRouteBuilder(
      transitionDuration: duration,
      pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) =>
          Quotation(title: formTitle),
      transitionsBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation, Widget child) =>
          _buildTransition(child, animation, fabSize, fabOffset),
    ));
  }

  Widget _buildTransition(
    Widget page,
    Animation<double> animation,
    Size? fabSize,
    Offset fabOffset,
  ) {
    if (animation.value == 1) return page;

    final borderTween = BorderRadiusTween(
      begin: BorderRadius.circular(fabSize!.width / 2),
      end: BorderRadius.circular(0.0),
    );
    final sizeTween = SizeTween(
      begin: fabSize,
      end: MediaQuery.of(context).size,
    );
    final offsetTween = Tween<Offset>(
      begin: fabOffset,
      end: Offset.zero,
    );

    final easeInAnimation = CurvedAnimation(
      parent: animation,
      curve: Curves.easeIn,
    );
    final easeAnimation = CurvedAnimation(
      parent: animation,
      curve: Curves.easeOut,
    );

    final radius = borderTween.evaluate(easeInAnimation);
    final offset = offsetTween.evaluate(animation);
    final size = sizeTween.evaluate(easeInAnimation);

    final transitionFab = Opacity(
      opacity: 1 - easeAnimation.value,
      child: _buildFAB(context),
    );

    Widget positionedClippedChild(Widget child) => Positioned(
        width: size!.width,
        height: size.height,
        left: offset.dx,
        top: offset.dy,
        child: ClipRRect(
          borderRadius: radius,
          child: child,
        ));

    return Stack(
      children: [
        positionedClippedChild(page),
        positionedClippedChild(transitionFab),
      ],
    );
  }
}
