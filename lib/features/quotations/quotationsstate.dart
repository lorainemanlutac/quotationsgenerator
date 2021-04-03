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
        backgroundColor: secondarySwatch,
        child: addIcon,
        elevation: 0,
        key: key,
        onPressed: () => _pushQuotationForm(context),
      );

  Widget _buildQuotations() {
    final length = _quotations.length;

    return ListView.builder(
      itemBuilder: (context, i) {
        final index = i ~/ 2;

        if (i.isOdd) {
          return Divider();
        }

        return Dismissible(
          key: UniqueKey(),
          background: Container(
            alignment: AlignmentDirectional.centerEnd,
            child: Icon(
              Icons.delete,
              color: Colors.white,
            ),
            color: Colors.red,
            padding: EdgeInsets.symmetric(horizontal: 20),
          ),
          child: _buildRow(_quotations[index]),
          confirmDismiss: (direction) => _promptUser(direction),
          direction: DismissDirection.endToStart,
          dismissThresholds: {DismissDirection.endToStart: 0.1},
          onDismissed: (direction) {
            return _handleDismiss(direction, index);
          },
        );
      },
      itemCount: length == 1 ? length : length * 2,
      padding: padding,
    );
  }

  Widget _buildRow(quotation) {
    final dateTime = convertDateTime(quotation.timestamp);
    final location = quotation.location;
    final subject = quotation.subject;

    return ListTile(
      leading: Icon(
        Icons.article_outlined,
        color: secondarySwatch,
        size: iconSize,
      ),
      onTap: () {
        _pushQuotation(subject);
      },
      subtitle: Text('$dateTime\n$location'),
      title: Text(subject),
      trailing: Icon(
        Icons.arrow_right,
        color: secondarySwatch,
        size: iconSize,
      ),
    );
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

    final offset = offsetTween.evaluate(animation);
    final radius = borderTween.evaluate(easeInAnimation);
    final size = sizeTween.evaluate(easeInAnimation);

    final transitionFab = Opacity(
      child: _buildFAB(context),
      opacity: 1 - easeAnimation.value,
    );

    Widget positionedClippedChild(Widget child) => Positioned(
          child: ClipRRect(
            borderRadius: radius,
            child: child,
          ),
          height: size!.height,
          left: offset.dx,
          top: offset.dy,
          width: size.width,
        );

    return Stack(
      children: [
        positionedClippedChild(page),
        positionedClippedChild(transitionFab),
      ],
    );
  }

  void _handleDismiss(direction, index) {
    final swipedQuotation = _quotations[index];

    _quotations.removeAt(index);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            final copiedEmail = QuotationsModel.copy(swipedQuotation);

            setState(() => _quotations.insert(index, copiedEmail));
          },
          textColor: Colors.yellow,
        ),
        content: Text(deleted),
        duration: Duration(seconds: 5),
      ),
    );
  }

  Future<bool> _promptUser(DismissDirection direction) async {
    return await showCupertinoDialog<bool>(
          builder: (context) => CupertinoAlertDialog(
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text(ok),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
              CupertinoDialogAction(
                child: Text(cancel),
                onPressed: () {
                  return Navigator.of(context).pop(false);
                },
              )
            ],
            content: Text(areYouSure),
          ),
          context: context,
        ) ??
        false;
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
    final fabOffset = fabRenderBox.localToGlobal(Offset.zero);
    final fabSize = fabRenderBox.size;

    Navigator.of(context).push(PageRouteBuilder(
      pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) =>
          Quotation(title: formTitle),
      transitionsBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation, Widget child) =>
          _buildTransition(child, animation, fabSize, fabOffset),
      transitionDuration: duration,
    ));
  }
}
