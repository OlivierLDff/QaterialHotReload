MESSAGE(STATUS "Platform deploy to ${CMAKE_SYSTEM_NAME}")

set(QATERIALHOTRELOAD_PLATFORMS_DIR ${PROJECT_SOURCE_DIR}/platforms)

# ──── WINDOWS ────

if(${CMAKE_SYSTEM_NAME} STREQUAL "Windows")

  if(NOT QATERIALHOTRELOAD_BUILD_SHARED)

    include(${PROJECT_SOURCE_DIR}/cmake/FetchQtWindowsCMake.cmake)

    add_qt_windows_exe(QaterialHotReloadApp
      NAME "QaterialHotReload"
      PUBLISHER "OlivierLdff"
      PRODUCT_URL "https://github.com/OlivierLdff/QaterialHotReload"
      PACKAGE "com.qaterial.hotreload"
      ICON ${QATERIALHOTRELOAD_PLATFORMS_DIR}/windows/icon.ico
      ICON_RC ${QATERIALHOTRELOAD_PLATFORMS_DIR}/windows/icon.rc
      QML_DIR ${PROJECT_SOURCE_DIR}/qml
      NO_TRANSLATIONS
      NO_OPENGL_SW
      VERBOSE_LEVEL_DEPLOY 1
      VERBOSE_INSTALLER
    )

    if(MSVC)
      set_property(DIRECTORY ${PROJECT_SOURCE_DIR} PROPERTY VS_STARTUP_PROJECT QaterialHotReloadApp)
    endif()

  endif()
endif()

# ──── LINUX ────

if(${CMAKE_SYSTEM_NAME} STREQUAL "Linux")

  if(NOT QATERIALHOTRELOAD_BUILD_SHARED)

    include(${PROJECT_SOURCE_DIR}/cmake/FetchQtLinuxCMake.cmake)

    if(NOT QATERIALHOTRELOAD_IGNORE_ENV)
      set(QATERIALHOTRELOAD_ALLOW_ENVIRONMENT_VARIABLE "ALLOW_ENVIRONMENT_VARIABLE")
    endif()

    add_qt_linux_appimage(QaterialHotReloadApp
      APP_DIR ${QATERIALHOTRELOAD_PLATFORMS_DIR}/linux/AppDir
      QML_DIR ${PROJECT_SOURCE_DIR}/qml
      NO_TRANSLATIONS
      ${QATERIALHOTRELOAD_ALLOW_ENVIRONMENT_VARIABLE}
      VERBOSE_LEVEL 1
    )

  endif()

endif()

# ──── MACOS ────

if(${CMAKE_SYSTEM_NAME} STREQUAL "Darwin")

  if(NOT QATERIALHOTRELOAD_BUILD_SHARED)

    include(${PROJECT_SOURCE_DIR}/cmake/FetchQtMacCMake.cmake)

    # Deeplabel isn't compatible with mac app store due to disable sandbox mode.
    add_qt_mac_app(QaterialHotReloadApp
      NAME "QaterialHotReload"
      BUNDLE_IDENTIFIER "com.qaterial.hotreload"
      LONG_VERSION ${QATERIALHOTRELOAD_VERSION}.${QATERIALHOTRELOAD_VERSION_TAG}
      COPYRIGHT "Copyright OlivierLdff 2020"
      APPLICATION_CATEGORY_TYPE "public.app-category.developer-tools"
      QML_DIR ${PROJECT_SOURCE_DIR}/qml
      RESOURCES
        "${QATERIALHOTRELOAD_PLATFORMS_DIR}/macos/Assets.xcassets"
      CUSTOM_ENTITLEMENTS "${QATERIALHOTRELOAD_PLATFORMS_DIR}/macos/Entitlements.entitlements"
      CUSTOM_PLIST "${QATERIALHOTRELOAD_PLATFORMS_DIR}/macos/Info.plist.in"
      DMG
      VERBOSE
      VERBOSE_LEVEL 3
    )

  endif()

endif()
