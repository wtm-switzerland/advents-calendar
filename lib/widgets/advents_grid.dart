import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';

import '../actions/user_actions.dart';
import '../data/christmas_data.dart';
import '../views/advent_view.dart';
import '../widgets/animation/blink_animation.dart';
import '../widgets/animation/image_rotate.dart';
import '../widgets/animation/rotation_transition.dart';
import 'advent_special_button.dart';
import 'advent_star_button.dart';

typedef WidgetWrapper = Widget Function(Widget);

class AdventsGridWidget extends StatelessWidget {
  const AdventsGridWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => GridView.count(
        crossAxisCount:
            MediaQuery.of(context).orientation == Orientation.portrait ? 4 : 6,
        children: List.generate(24, (index) {
          String image;
          var contentType = ChristmasDataType.wish;
          WidgetWrapper wrapper;

          switch (index) {
            case 3:
              image = 'images/icons/icons8-ball-96.png';
              contentType = ChristmasDataType.poem;
              break;
            case 6:
              image = 'images/icons/icons8-stocking-96.png';
              contentType = ChristmasDataType.story;
              wrapper = (w) => ImageRotateWidget(child: w);
              break;
            case 12:
              image = 'images/icons/icons8-tree-96.png';
              contentType = ChristmasDataType.poem;
              wrapper = (w) => BlinkAnimationWidget(child: w);
              break;
            case 18:
              image = 'images/icons/icons8-jingle-bell-48.png';
              contentType = ChristmasDataType.story;
              break;
            case 21:
              image = 'images/icons/icons8-santa-48.png';
              contentType = ChristmasDataType.story;
              break;
            case 23:
              image = 'images/icons/icons8-santa-claus-bag-96.png';
              contentType = ChristmasDataType.poem;
              wrapper = (w) => RotationTransitionWidget(child: w);
              break;
            default:
              return AdventStarButtonWidget(
                text: (index + 1).toString(),
                buttonHandler: () {
                  if (((index + 1) == 1) || _isDateToShow(index)) {
                    FirebaseAnalytics().logEvent(
                        name: 'advent_star',
                        parameters: {'advent_number': index + 1});
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            settings: const RouteSettings(name: '/advent_star'),
                            builder: (context) => AdventView(
                                  adventNumber: index + 1,
                                  christmasDataType: contentType,
                                )));
                  } else {
                    FirebaseAnalytics().logEvent(
                        name: 'advent_star_early_try',
                        parameters: {'advent_number': index + 1});
                    UserActions.adventNotAvailableSnackBar(context, index);
                  }
                },
              );
          }
          var widget = AdventSpecialIconButtonWidget(
              image: image,
              buttonHandler: () {
                if (((index + 1) == 1) || _isDateToShow(index)) {
                  FirebaseAnalytics().logEvent(
                      name: 'advent_special',
                      parameters: {'advent_number': index + 1});
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          settings:
                              const RouteSettings(name: '/advent_special'),
                          builder: (context) => AdventView(
                                adventNumber: index + 1,
                                christmasDataType: contentType,
                              )));
                } else {
                  UserActions.adventNotAvailableSnackBar(context, index);
                  FirebaseAnalytics().logEvent(
                      name: 'advent_speacial_early_try',
                      parameters: {'advent_number': index + 1});
                }
              });
          if (wrapper != null) {
            return wrapper(widget);
          }
          return widget;
        }),
      );

  bool _isDateToShow(int index) =>
      DateTime.now().isAfter(DateTime.utc(2018, 12, index + 1));
}
