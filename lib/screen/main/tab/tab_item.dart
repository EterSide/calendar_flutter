import 'package:fast_app_base/common/common.dart';
import 'package:fast_app_base/screen/main/tab/aclist/f_aclist.dart';
import 'package:fast_app_base/screen/main/tab/alarm/f_alarm.dart';
import 'package:fast_app_base/screen/main/tab/calendar/f_calendar.dart';
import 'package:fast_app_base/screen/main/tab/favorite/f_favorite.dart';
import 'package:fast_app_base/screen/main/tab/home/f_home.dart';
import 'package:flutter/material.dart';

enum TabItem {
  home(Icons.home, '홈', HomeFragment()),
  favorite(Icons.star, '즐겨찾기', FavoriteFragment(isShowBackButton: false)),
  calendar(Icons.calendar_month, '달력', CalendarFragment()),
  alarm(Icons.alarm, '알람', AlarmFragment()),
  aclist(Icons.list, '목록', ACFragment());

  final IconData activeIcon;
  final IconData inActiveIcon;
  final String tabName;
  final Widget firstPage;

  const TabItem(this.activeIcon, this.tabName, this.firstPage, {IconData? inActiveIcon})
      : inActiveIcon = inActiveIcon ?? activeIcon;

  BottomNavigationBarItem toNavigationBarItem(BuildContext context, {required bool isActivated}) {
    return BottomNavigationBarItem(
        icon: Icon(
          key: ValueKey(tabName),
          isActivated ? activeIcon : inActiveIcon,
          color:
              isActivated ? context.appColors.iconButton : context.appColors.iconButtonInactivate,
        ),
        label: tabName);
  }
}
