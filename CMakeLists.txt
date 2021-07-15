# MIT License
#
# Copyright (c) 2020 Olivier Le Doeuff
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

cmake_minimum_required(VERSION 3.14.0 FATAL_ERROR)

# ───── PROJECT OPTIONS ─────

set(QATERIALHOTRELOAD_MAIN_PROJECT OFF)
if (CMAKE_CURRENT_SOURCE_DIR STREQUAL CMAKE_SOURCE_DIR)
  set(QATERIALHOTRELOAD_MAIN_PROJECT ON)
endif()

include(cmake/Version.cmake)

set(QATERIALHOTRELOAD_PROJECT "QaterialHotReload" CACHE STRING "Project Name")
set(QATERIALHOTRELOAD_FOLDER_PREFIX "Qaterial/HotReload" CACHE STRING "Prefix folder for all Qaterial generated targets in generated project (only decorative)")
set(QATERIALHOTRELOAD_BUILD_SHARED OFF CACHE BOOL "Build QaterialHotReloadApp as a shared library (for android)")
# Might be useful to disable if you only want the HotReload Gui to integrate into your project
set(QATERIALHOTRELOAD_ENABLE_HOTRELOAD_APP ${QATERIALHOTRELOAD_MAIN_PROJECT} CACHE BOOL "Build Qaterial HotReload application")
set(QATERIALHOTRELOAD_IGNORE_ENV OFF CACHE BOOL "Ignore qt environment variables")
set(QATERIALHOTRELOAD_ENABLE_PCH ON CACHE BOOL
 "Enable precompile headers support for 'QaterialHotReload'. \"
 Only work if CMake support 'target_precompile_headers'. \"
 This can speed up compilation time.")

set(QATERIALHOTRELOAD_ENABLE_CHARTS ON CACHE BOOL "Enable Qt::Charts")
set(QATERIALHOTRELOAD_ENABLE_DATAVIZ ON CACHE BOOL "Enable Qt::DataVisualization")
set(QATERIALHOTRELOAD_ENABLE_VIRTUALKEYBOARD ON CACHE BOOL "Enable Qt::VirtualKeyboard")
set(QATERIALHOTRELOAD_ENABLE_WEBCHANNEL ON CACHE BOOL "Enable Qt::WebChannel")
set(QATERIALHOTRELOAD_ENABLE_WEBSOCKET ON CACHE BOOL "Enable Qt::WebSockets")
set(QATERIALHOTRELOAD_ENABLE_WEBENGINE ON CACHE BOOL "Enable Qt::WebEngine")
set(QATERIALHOTRELOAD_ENABLE_QT3D ON CACHE BOOL "Enable Qt::3DCore")
set(QATERIALHOTRELOAD_ENABLE_QUICK3D ON CACHE BOOL "Enable Qt::Quick3D")

message(STATUS "------ ${QATERIALHOTRELOAD_PROJECT} Configuration ------")

message(STATUS "QATERIALHOTRELOAD_PROJECT                : ${QATERIALHOTRELOAD_PROJECT}")
message(STATUS "QATERIALHOTRELOAD_VERSION                : ${QATERIALHOTRELOAD_VERSION}")
message(STATUS "QATERIALHOTRELOAD_VERSION_TAG_HEX        : ${QATERIALHOTRELOAD_VERSION_TAG_HEX}")
message(STATUS "QATERIALHOTRELOAD_BUILD_SHARED           : ${QATERIALHOTRELOAD_BUILD_SHARED}")
message(STATUS "QATERIALHOTRELOAD_IGNORE_ENV             : ${QATERIALHOTRELOAD_IGNORE_ENV}")
message(STATUS "QATERIALHOTRELOAD_FOLDER_PREFIX          : ${QATERIALHOTRELOAD_FOLDER_PREFIX}")

message(STATUS "QATERIALHOTRELOAD_ENABLE_CHARTS          : ${QATERIALHOTRELOAD_ENABLE_CHARTS}")
message(STATUS "QATERIALHOTRELOAD_ENABLE_DATAVIZ         : ${QATERIALHOTRELOAD_ENABLE_DATAVIZ}")
message(STATUS "QATERIALHOTRELOAD_ENABLE_VIRTUALKEYBOARD : ${QATERIALHOTRELOAD_ENABLE_VIRTUALKEYBOARD}")
message(STATUS "QATERIALHOTRELOAD_ENABLE_WEBCHANNEL      : ${QATERIALHOTRELOAD_ENABLE_WEBCHANNEL}")
message(STATUS "QATERIALHOTRELOAD_ENABLE_WEBSOCKET       : ${QATERIALHOTRELOAD_ENABLE_WEBSOCKET}")
message(STATUS "QATERIALHOTRELOAD_ENABLE_WEBENGINE       : ${QATERIALHOTRELOAD_ENABLE_WEBENGINE}")
message(STATUS "QATERIALHOTRELOAD_ENABLE_QT3D            : ${QATERIALHOTRELOAD_ENABLE_QT3D}")
message(STATUS "QATERIALHOTRELOAD_ENABLE_QUICK3D         : ${QATERIALHOTRELOAD_ENABLE_QUICK3D}")

message(STATUS "QATERIALHOTRELOAD_ENABLE_HOTRELOAD_APP   : ${QATERIALHOTRELOAD_ENABLE_HOTRELOAD_APP}")

message(STATUS "------ ${QATERIALHOTRELOAD_PROJECT} End Configuration ------")


project(${QATERIALHOTRELOAD_PROJECT} VERSION ${QATERIALHOTRELOAD_VERSION} LANGUAGES CXX)
set_property(GLOBAL PROPERTY USE_FOLDERS ON)

# ───── FETCH DEPEDENCIES ─────

include(cmake/FetchDependencies.cmake)

# ───── HOTRELOAD LIBRARY ─────

set(QATERIALHOTRELOAD_LIB QaterialHotReload)
set(QATERIALHOTRELOAD_SRC_DIR ${CMAKE_CURRENT_SOURCE_DIR}/src/Qaterial/HotReload)

add_subdirectory(qml/Qaterial/HotReload)

add_library(${QATERIALHOTRELOAD_LIB} STATIC
  ${QATERIALHOTRELOAD_SRC_DIR}/HotReload.hpp
  ${QATERIALHOTRELOAD_SRC_DIR}/HotReload.cpp
  ${QATERIALHOTRELOAD_QML_RES}
)
add_library(Qaterial::HotReload ALIAS ${QATERIALHOTRELOAD_LIB})

target_link_libraries(${QATERIALHOTRELOAD_LIB} PUBLIC
  Qt::Core
  Qt::Qml
)
target_link_libraries(${QATERIALHOTRELOAD_LIB} PRIVATE
  Qaterial::HotReload::Ui
  Qaterial::Qaterial
)

function(target_link_quiet_libraries TARGET)
  foreach(LIB ${ARGN})
    if(TARGET ${LIB})
      target_link_libraries(${TARGET} PRIVATE ${LIB})
    endif()
  endforeach(LIB)
endfunction()

if(QATERIALHOTRELOAD_ENABLE_CHARTS)
  find_package(Qt5 QUIET COMPONENTS Charts)
  target_link_quiet_libraries(${QATERIALHOTRELOAD_LIB}
    Qt::Charts
  )
endif()

if(QATERIALHOTRELOAD_ENABLE_DATAVIZ)
  find_package(Qt5 QUIET COMPONENTS DataVisualization)
  target_link_quiet_libraries(${QATERIALHOTRELOAD_LIB}
    Qt::DataVisualization
  )
endif()

if(QATERIALHOTRELOAD_ENABLE_VIRTUALKEYBOARD)
  find_package(Qt5 QUIET COMPONENTS VirtualKeyboard)
  target_link_quiet_libraries(${QATERIALHOTRELOAD_LIB}
    Qt::VirtualKeyboard
  )
endif()

if(QATERIALHOTRELOAD_ENABLE_WEBCHANNEL)
  find_package(Qt5 QUIET COMPONENTS WebChannel)
  target_link_quiet_libraries(${QATERIALHOTRELOAD_LIB}
    Qt::WebChannel
  )
endif()

if(QATERIALHOTRELOAD_ENABLE_WEBSOCKET)
  find_package(Qt5 QUIET COMPONENTS WebSockets)
  target_link_quiet_libraries(${QATERIALHOTRELOAD_LIB}
    Qt::WebSockets
  )
endif()

#if(QATERIALHOTRELOAD_ENABLE_WEBENGINE)
#  find_package(Qt5 QUIET COMPONENTS WebEngine)
#  target_link_quiet_libraries(${QATERIALHOTRELOAD_LIB}
#    Qt::WebEngine
#  )
#endif()

if(QATERIALHOTRELOAD_ENABLE_QT3D)
  find_package(Qt5 QUIET COMPONENTS
    3DCore
    3DRender
    3DInput
    3DLogic
    3DExtras
    3DAnimation
  )
  target_link_quiet_libraries(${QATERIALHOTRELOAD_LIB}
    Qt::3DCore
    Qt::3DRender
    Qt::3DInput
    Qt::3DLogic
    Qt::3DExtras
    Qt::3DAnimation
  )
endif()

if(QATERIALHOTRELOAD_ENABLE_QUICK3D)
  target_link_quiet_libraries(${QATERIALHOTRELOAD_LIB}
    Qt::Quick3D
    Qt::Quick3DAssetImport
    Qt::Quick3DRender
    Qt::Quick3DRuntimeRender
    Qt::Quick3DUtils
  )
endif()

set_target_properties(${QATERIALHOTRELOAD_LIB} PROPERTIES
  FOLDER ${QATERIALHOTRELOAD_FOLDER_PREFIX}
  AUTORCC TRUE
  AUTOMOC TRUE)
target_include_directories(${QATERIALHOTRELOAD_LIB} PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/src)
target_compile_definitions(${QATERIALHOTRELOAD_LIB}
  PRIVATE -DQATERIALHOTRELOAD_VERSION_MAJOR=${QATERIALHOTRELOAD_VERSION_MAJOR}
  PRIVATE -DQATERIALHOTRELOAD_VERSION_MINOR=${QATERIALHOTRELOAD_VERSION_MINOR}
  PRIVATE -DQATERIALHOTRELOAD_VERSION_PATCH=${QATERIALHOTRELOAD_VERSION_PATCH}
  PRIVATE -DQATERIALHOTRELOAD_VERSION_TAG=${QATERIALHOTRELOAD_VERSION_TAG}
  PRIVATE -DQATERIALHOTRELOAD_VERSION_TAG_HEX=${QATERIALHOTRELOAD_VERSION_TAG_HEX}
)

if(QATERIALHOTRELOAD_ENABLE_PCH AND COMMAND target_precompile_headers)
  target_precompile_headers(${QATERIALHOTRELOAD_LIB} PRIVATE ${PROJECT_SOURCE_DIR}/src/Qaterial/HotReload/Pch/Pch.hpp)
endif()

get_target_property(QT_TARGET_TYPE Qt::Core TYPE)
if(${QT_TARGET_TYPE} STREQUAL "STATIC_LIBRARY")
  qt_generate_qml_plugin_import(${QATERIALHOTRELOAD_LIB} QML_SRC ${CMAKE_CURRENT_SOURCE_DIR})
  qt_generate_plugin_import(${QATERIALHOTRELOAD_LIB})
endif()

# ───── HOTRELOAD APPLICATION ─────

if(QATERIALHOTRELOAD_ENABLE_HOTRELOAD_APP)

  set(QATERIALHOTRELOAD_APP QaterialHotReloadApp)
  set(QATERIALHOTRELOAD_APP_SRC_DIR ${CMAKE_CURRENT_SOURCE_DIR}/src/Qaterial/HotReloadApp)
  set(QATERIALHOTRELOAD_APP_SRCS
    ${QATERIALHOTRELOAD_APP_SRC_DIR}/Main.cpp
  )

  if(QATERIALHOTRELOAD_BUILD_SHARED)
    add_library(${QATERIALHOTRELOAD_APP} SHARED ${QATERIALHOTRELOAD_APP_SRCS})
  else()
    add_executable(${QATERIALHOTRELOAD_APP} ${QATERIALHOTRELOAD_APP_SRCS})
  endif()

  target_link_libraries(${QATERIALHOTRELOAD_APP} PRIVATE
    Qaterial::Qaterial
    Qaterial::HotReload
    SortFilterProxyModel
    Qt::Widgets
  )

  if(QATERIALHOTRELOAD_ENABLE_PCH AND COMMAND target_precompile_headers)
    target_precompile_headers(${QATERIALHOTRELOAD_APP} PRIVATE ${PROJECT_SOURCE_DIR}/src/Qaterial/HotReload/Pch/Pch.hpp)
  endif()

  if(QATERIALHOTRELOAD_IGNORE_ENV)
    message(STATUS "The executable will discard every ")
    target_compile_definitions(${QATERIALHOTRELOAD_APP} PRIVATE -DQATERIALHOTRELOAD_IGNORE_ENV)
  endif()

  include(platforms/Deploy.cmake)

endif()
