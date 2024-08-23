// Copyright Olivier Le Doeuff 2020 (C)

import QtCore
import QtQuick 2.0

import Qaterial as Qaterial
import Qaterial.HotReload as HR

Qaterial.SplashScreenApplication
{
  id: root

  property int appTheme: Qaterial.Style.theme

  splashScreen: HR.SplashScreenWindow {}
  window: HR.HotReloadWindow {}

  Settings { property alias appTheme: root.appTheme }

  Component.onCompleted: function()
  {
    Qaterial.Style.theme = root.appTheme
  }
}
