import 'package:flutter/material.dart';
import 'package:quotationsgenerator/helpers/utils.dart';
import 'package:quotationsgenerator/styles/css.dart';
import 'package:quotationsgenerator/widgets/quotation.dart';
import 'package:quotationsgenerator/widgets/quotationform.dart';
import 'package:quotationsgenerator/widgets/quotations.dart';

final routeObserver = RouteObserver<PageRoute>();
final duration = const Duration(milliseconds: 300);

void main() => runApp(MaterialApp(
      home: Quotations(),
      navigatorObservers: [routeObserver],
    ));

class QuotationsState extends State<Quotations> with RouteAware {
  var _quotations = [];
  GlobalKey _fabKey = GlobalKey();

  @override
  didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context));
  }

  @override
  dispose() {
    super.dispose();
    routeObserver.unsubscribe(this);
  }

  @override
  Widget build(BuildContext context) {
    _quotations = [
      {
        'fileName': 'Music Box',
        'timestamp': '2021-03-08T17:44:00.000Z',
        'client': 'Daruma Corporation'
      },
      {
        'fileName': 'QC Condo',
        'timestamp': '2021-03-08T17:44:00.000Z',
        'client': 'Isay Ramos'
      },
    ];

    return Scaffold(
      body: _buildQuotations(),
      floatingActionButton: _buildFAB(context, key: _fabKey),
    );
  }

  Widget _buildFAB(context, {key}) => FloatingActionButton(
        elevation: 0,
        backgroundColor: secondarySwatch,
        key: key,
        onPressed: () => _pushQuotationForm(context),
        child: addIcon,
      );

  Widget _buildQuotations() {
    return ListView.builder(
        padding: EdgeInsets.all(padding),
        itemBuilder: (context, i) {
          final index = i ~/ 2;

          if (i.isOdd) {
            return Divider();
          }

          return index >= _quotations.length
              ? null
              : _buildRow(_quotations[index]);
        });
  }

  Widget _buildRow(quotation) {
    final fileName = quotation['fileName'];
    var dateTime = convertDate(quotation['timestamp']);

    return ListTile(
      leading: Icon(
        Icons.article_outlined,
        color: secondarySwatch,
        size: iconSize,
      ),
      title: Text(fileName),
      subtitle: Text(dateTime + '\n' + quotation['client']),
      onTap: () {
        _pushQuotation(fileName);
      },
      trailing: Icon(
        Icons.arrow_right,
        color: secondarySwatch,
        size: iconSize,
      ),
    );
  }

  void _pushQuotation(String fileName) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return Quotation(title: fileName);
        },
      ),
    );
  }

  void _pushQuotationForm(BuildContext context) {
    final RenderBox fabRenderBox = _fabKey.currentContext.findRenderObject();
    final fabSize = fabRenderBox.size;
    final fabOffset = fabRenderBox.localToGlobal(Offset.zero);

    Navigator.of(context).push(PageRouteBuilder(
      transitionDuration: duration,
      pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) =>
          QuotationForm(),
      transitionsBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation, Widget child) =>
          _buildTransition(child, animation, fabSize, fabOffset),
    ));
  }

  Widget _buildTransition(
    Widget page,
    Animation<double> animation,
    Size fabSize,
    Offset fabOffset,
  ) {
    if (animation.value == 1) return page;

    final borderTween = BorderRadiusTween(
      begin: BorderRadius.circular(fabSize.width / 2),
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
        width: size.width,
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
