include(${CMAKE_CURRENT_LIST_DIR}/CPM.cmake)

set(QTMACCMAKE_REPOSITORY "https://github.com/OlivierLDff/QtMacCMake.git" CACHE STRING "QtMacCMake repository, can be a local URL")
set(QTMACCMAKE_TAG "main" CACHE STRING "QtMacCMake git tag")

CPMAddPackage(
  QtMacCMake
  GIT_REPOSITORY ${QTMACCMAKE_REPOSITORY}
  GIT_TAG        ${QTMACCMAKE_TAG}
)

FetchContent_MakeAvailable(QtMacCMake)
