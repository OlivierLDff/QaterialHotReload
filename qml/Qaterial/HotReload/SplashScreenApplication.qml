// Copyright Olivier Le Doeuff 2020 (C)

import QtQuick 2.0
import Qt.labs.settings as QLab

import Qaterial as Qaterial
import Qaterial.HotReload as HR

Qaterial.SplashScreenApplication
{
  id: root

  property int appTheme: Qaterial.Style.theme

  splashScreen: HR.SplashScreenWindow {}
  window: HR.HotReloadWindow {}

  QLab.Settings { property alias appTheme: root.appTheme }

  Component.onCompleted: function()
  {
    Qaterial.Style.theme = root.appTheme
  }
}
