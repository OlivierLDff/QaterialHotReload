# Copyright 2019-2020 Olivier Le Doeuff
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation
# files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy,
# modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software
# is furnished to do so, subject to the following conditions:
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
# DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
# OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

qt_add_library(${QATERIALHOTRELOAD_LIB}Ui STATIC ${QATERIALHOTRELOAD_QML_RES})
add_library(Qaterial::HotReload::Ui ALIAS ${QATERIALHOTRELOAD_LIB}Ui)

set(SINGLETON_FILES
  Images.qml
)

set_source_files_properties(${SINGLETON_FILES} PROPERTIES QT_QML_SINGLETON_TYPE TRUE)

qt_add_qml_module(${QATERIALHOTRELOAD_LIB}Ui
    URI "Qaterial.HotReload"
    RESOURCE_PREFIX "/"
    QML_FILES
      HotReload.qml
      HotReloadWindow.qml
      IconsMenu.qml
      Images.qml
      ImportPathMenu.qml
      Main.qml
      MaterialPaletteMenu.qml
      SplashScreenApplication.qml
      SplashScreenWindow.qml
      StatusView.qml
      TypoMenu.qml
    RESOURCES
      Images/code.svg
      Images/icon.svg
      Images/material-icons-light.svg
      Images/material-palette.png
      Images/qaterial-hotreload-black.png
      Images/qaterial-hotreload-white.png
    OUTPUT_TARGETS QATERIAL_HR_QML_TARGETS
    NO_PLUGIN
  )

target_link_libraries(${QATERIALHOTRELOAD_LIB}Ui PRIVATE
  Qt::Core
  Qt::Gui
  Qt::Svg
  Qt::Xml
  Qt::Qml
  Qt::Quick
  Qt::QuickControls2
)

if(QATERIALHOTRELOAD_FOLDER_PREFIX)
  set_target_properties(${QATERIALHOTRELOAD_LIB}Ui PROPERTIES FOLDER ${QATERIALHOTRELOAD_FOLDER_PREFIX})
endif()
