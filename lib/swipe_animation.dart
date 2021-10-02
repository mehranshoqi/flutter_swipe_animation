// @dart=2.9

import 'package:flutter/material.dart';

import 'package:swipe_animation_blog/constant/string.dart';

import 'constant/colors.dart';
import 'constant/styles.dart';

class SwipeAnimation extends StatefulWidget {
  @override
  _SwipeAnimationState createState() => _SwipeAnimationState();
}

class _SwipeAnimationState extends State<SwipeAnimation> {
  Size s;
  ValueNotifier<double> _valueNotifier = ValueNotifier(0.0);


  final _button = GlobalKey();
  final _pageController = PageController();
  bool isBlack = false, isLastPage = false;

  @override
  void initState() {
    _pageController.addListener(() => _valueNotifier.value = _pageController.page);
    super.initState();
  }







  @override
  void dispose() {
    _pageController.dispose();
    _valueNotifier.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    s = MediaQuery.of(context).size;
    return Scaffold(
      body: _buildBody(),
    );
  }







  _buildBody() {
    return Stack(
      children: [
        // first child
        AnimatedBuilder(
          animation: _valueNotifier,
          builder: (_, __) => CustomPaint(
            painter: FlowPainter(
              context: context,
              notifier: _valueNotifier,
              target: _button,
              colors: AppColors.welcomeScreenColors,
            ),
          ),
        ),

        // second child
        PageView.builder(
          controller: _pageController,
          itemCount: AppColors.welcomeScreenColors.length,
          itemBuilder: (c, i) {
            isLastPage = i == 3;
            isBlack = i % 2 != 0;
            return Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // if (i == 2) _buildBubbles(),
                  Spacer(flex: 4),
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 24,
                        left: 32,
                        right: 32,
                      ),
                      child: Column(
                        children: [
                          if (i != 4) _buildBeforeNavigate(i),
                          const SizedBox(height: 8),
                          if (i == 3)
                            Container(
                              width: double.infinity,
                              height: 100,
                              color: Colors.transparent,
                              child: FlatButton(
                                onPressed: () {},
                                child: Text(
                                  'Go!',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline5
                                      .copyWith(color: Colors.blue),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  if (i == 0)
                    const Text(
                      'swipe',
                      style: TextStyle(fontSize: 14, color: Colors.black45),
                    ),
                  const SizedBox(height: 4),
                ],
              ),
            );
          },
        ),
        
        // third child
        IgnorePointer(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 42),
              child: ClipOval(
                child: AnimatedBuilder(
                  animation: _valueNotifier,
                  builder: (_, __) {
                    final animatorVal =
                        _valueNotifier.value - _valueNotifier.value.floor();
                    double opacity = 0, iconPos = 0;
                    int colorIndex;
                    if (animatorVal < 0.5) {
                      opacity = (animatorVal - 0.5) * -2;
                      iconPos = 90 * -animatorVal;
                      colorIndex = _valueNotifier.value.floor() + 1;
                    } else {
                      colorIndex = _valueNotifier.value.floor() + 2;
                      iconPos = -90;
                    }
                    if (animatorVal > 0.9) {
                      iconPos = -250 * (1 - animatorVal) * 10;
                      opacity = (animatorVal - 0.9) * 10;
                    }
                    colorIndex =
                        colorIndex % AppColors.welcomeScreenColors.length;

                    return SizedBox(
                      key: _button,
                      width: 90,
                      height: 90,
                      child: Transform.translate(
                        offset: Offset(iconPos, 0),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isLastPage
                                ? AppColors.welcomeScreenColors.last
                                : AppColors.welcomeScreenColors[colorIndex],
                          ),
                          child: Icon(
                            Icons.chevron_right,
                            color: isLastPage
                                ? AppColors.welcomeScreenColors.last
                                : Colors.blue.withOpacity(opacity),
                            size: 30,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  _buildBeforeNavigate(int i) => Container(
        width: S.w(s) - 48,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              STR.greetTitles[i],
              style: Theme.of(context).textTheme.headline3.copyWith(
                    color: i % 2 == 0 ? AppColors.black : AppColors.white,
                    fontFamily: 'lilita',
                  ),
            ),
            SizedBox(height: S.h(s) * .016),
            Text(
              STR.greetMessages[i],
              style: Theme.of(context).textTheme.headline6.copyWith(
                  color: i % 2 == 0 ? AppColors.black : AppColors.white,
                  // fontWeight: FontWeight.bold,
                  letterSpacing: .2),
            ),
          ],
        ),
      );
}

class FlowPainter extends CustomPainter {
  final BuildContext context;
  final ValueNotifier<double> notifier;
  final GlobalKey target;
  final List<Color> colors;

  RenderBox _renderBox;

  FlowPainter({this.context, this.notifier, this.target, this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    final screen = MediaQuery.of(context).size;
    if (_renderBox == null)
      _renderBox = target.currentContext.findRenderObject();
    if (_renderBox == null || notifier == null) return;
    final page = notifier.value.floor();
    final animatorVal = notifier.value - page;
    final targetPos = _renderBox.localToGlobal(Offset.zero);
    final xScale = screen.height * 8, yScale = xScale / 2;
    var curvedVal = Curves.easeInOut.transformInternal(animatorVal);
    final reverseVal = 1 - curvedVal;

    Paint buttonPaint = Paint(), bgPaint = Paint();
    Rect buttonRect, bgRect = Rect.fromLTWH(0, 0, screen.width, screen.height);

    if (animatorVal < 0.5) {
      bgPaint..color = colors[page % colors.length];
      buttonPaint..color = colors[(page + 1) % colors.length];
      buttonRect = Rect.fromLTRB(
        targetPos.dx - (xScale * curvedVal), //left
        targetPos.dy - (yScale * curvedVal), //top
        targetPos.dx + _renderBox.size.width * reverseVal, //right
        targetPos.dy + _renderBox.size.height + (yScale * curvedVal), //bottom
      );
    } else {
      bgPaint..color = colors[(page + 1) % colors.length];
      buttonPaint..color = colors[page % colors.length];
      buttonRect = Rect.fromLTRB(
        targetPos.dx + _renderBox.size.width * reverseVal, //left
        targetPos.dy - yScale * reverseVal, //top
        targetPos.dx + _renderBox.size.width + xScale * reverseVal, //right
        targetPos.dy + _renderBox.size.height + yScale * reverseVal, //bottom
      );
    }

    canvas.drawRect(bgRect, bgPaint);
    canvas.drawRRect(
      RRect.fromRectAndRadius(buttonRect, Radius.circular(screen.height)),
      buttonPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
