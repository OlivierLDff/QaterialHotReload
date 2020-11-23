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

include(cmake/Configuration.cmake)

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
  spdlog
  Qaterial
  SortFilterProxyModel
)
target_link_libraries(${QATERIALHOTRELOAD_LIB} PRIVATE
  Qaterial::HotReload::Ui
)

function(target_link_quiet_libraries TARGET)
  foreach(LIB ${ARGN})
    if(TARGET ${LIB})
      target_link_libraries(${TARGET} PUBLIC ${LIB})
    endif()
  endforeach(LIB)
endfunction()

# Optionnal Qt libs that might be interessant to have packaged with hotreloader
find_package(Qt5 QUIET COMPONENTS
  Charts
  DataVisualization
  VirtualKeyboard
  WebChannel
  WebSockets
  #WebEngine

  3DCore
  3DRender
  3DInput
  3DLogic
  3DExtras
  3DAnimation

  Quick3D
  Quick3DAssetImport
  Quick3DRender
  Quick3DRuntimeRender
  Quick3DUtils)

target_link_quiet_libraries(${QATERIALHOTRELOAD_LIB}
  Qt::Charts
  Qt::DataVisualization
  Qt::VirtualKeyboard
  Qt::WebChannel
  Qt::WebSockets
  Qt::WebEngine

  Qt::3DCore
  Qt::3DRender
  Qt::3DInput
  Qt::3DLogic
  Qt::3DExtras
  Qt::3DAnimation

  Qt::Quick3D
  Qt::Quick3DAssetImport
  Qt::Quick3DRender
  Qt::Quick3DRuntimeRender
  Qt::Quick3DUtils)

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

  add_subdirectory(qml/Qaterial/HotReloadApp)

  if(QATERIALHOTRELOAD_BUILD_SHARED)
    add_library(${QATERIALHOTRELOAD_APP} SHARED ${QATERIALHOTRELOAD_APP_SRCS})
  else()
    add_executable(${QATERIALHOTRELOAD_APP} ${QATERIALHOTRELOAD_APP_SRCS})
  endif()

  target_link_libraries(${QATERIALHOTRELOAD_APP} PRIVATE
    Qaterial::HotReload::AppUi
    Qaterial::HotReload
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
