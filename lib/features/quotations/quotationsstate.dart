import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quotationsgenerator/assets/translations/en.dart';
import 'package:quotationsgenerator/helpers/utils.dart';
import 'package:quotationsgenerator/models/QuotationsModel.dart';
import 'package:quotationsgenerator/styles/css.dart';
import 'package:quotationsgenerator/features/quotation/quotation.dart';
import 'package:quotationsgenerator/features/quotations/quotations.dart';

RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();
Duration duration = const Duration(milliseconds: 300);

void main() => runApp(MaterialApp(
      home: Quotations(),
      navigatorObservers: [routeObserver],
    ));

class QuotationsState extends State<Quotations> with RouteAware {
  List<QuotationsModel> _quotations = <QuotationsModel>[
    QuotationsModel(
      'Music Zone',
      '2021-03-08T17:44:00.000Z',
      'ABC Corporation',
    ),
    QuotationsModel(
      'QC Condo',
      '2021-03-08T17:44:00.000Z',
      'Juan dela Cruz',
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

  /// The floating add button at the lower right corner of the home page.
  Widget _buildFAB(BuildContext context, {key}) => FloatingActionButton(
        backgroundColor: secondarySwatch,
        child: addIcon,
        elevation: 0,
        key: key,
        onPressed: () => _pushQuotationForm(context),
      );

  /// Returns the list of quotations that are saved in the application.
  Widget _buildQuotations() {
    int length = _quotations.length;

    return ListView.builder(
      itemBuilder: (context, i) {
        int index = i ~/ 2;

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

  /// Returns the tappable [quotation] details.
  Widget _buildRow(quotation) {
    String dateTime = convertDateTime(quotation.timestamp);
    String location = quotation.location;

    return ListTile(
      leading: Icon(
        Icons.article_outlined,
        color: secondarySwatch,
        size: iconSize,
      ),
      onTap: () {
        _pushQuotation(project);
      },
      subtitle: Text('$dateTime\n$location'),
      title: Text(quotation.project),
      trailing: Icon(
        Icons.arrow_right,
        color: secondarySwatch,
        size: iconSize,
      ),
    );
  }

  /// Adds animation upon opening the create form page.
  Widget _buildTransition(
    Widget page,
    Animation<double> animation,
    Size? fabSize,
    Offset fabOffset,
  ) {
    if (animation.value == 1) return page;

    BorderRadiusTween borderTween = BorderRadiusTween(
      begin: BorderRadius.circular(fabSize!.width / 2),
      end: BorderRadius.circular(0.0),
    );
    CurvedAnimation easeAnimation = CurvedAnimation(
      parent: animation,
      curve: Curves.easeOut,
    );
    CurvedAnimation easeInAnimation = CurvedAnimation(
      parent: animation,
      curve: Curves.easeIn,
    );
    Tween<Offset> offsetTween = Tween<Offset>(
      begin: fabOffset,
      end: Offset.zero,
    );
    Offset offset = offsetTween.evaluate(animation);
    BorderRadius radius = borderTween.evaluate(easeInAnimation);
    SizeTween sizeTween = SizeTween(
      begin: fabSize,
      end: MediaQuery.of(context).size,
    );
    Size? size = sizeTween.evaluate(easeInAnimation);
    Opacity transitionFab = Opacity(
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

  /// Triggered when a quotation item swipe [direction] is left.
  void _handleDismiss(direction, index) {
    QuotationsModel swipedQuotation = _quotations[index];

    _quotations.removeAt(index);
    showSnackBar(context, () {
      QuotationsModel copiedQuotation = QuotationsModel.copy(swipedQuotation);

      setState(() => _quotations.insert(index, copiedQuotation));
    });
  }

  /// Asks user to confirm removal of swiped quotation item.
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

  /// Shows the quotation details with [project] as page title.
  void _pushQuotation(String project) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return Quotation(title: project);
        },
      ),
    );
  }

  /// Shows the create quotation form page in the current page [context].
  void _pushQuotationForm(BuildContext context) {
    RenderBox fabRenderBox =
        _fabKey.currentContext!.findRenderObject() as RenderBox;
    Offset fabOffset = fabRenderBox.localToGlobal(Offset.zero);
    Size fabSize = fabRenderBox.size;

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
