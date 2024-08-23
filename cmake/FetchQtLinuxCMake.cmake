include(${CMAKE_CURRENT_LIST_DIR}/CPM.cmake)

set(QTLINUXCMAKE_REPOSITORY "https://github.com/OlivierLDff/QtLinuxCMake.git" CACHE STRING "QtLinuxCMake repository, can be a local URL")
set(QTLINUXCMAKE_TAG "main" CACHE STRING "QtLinuxCMake git tag")

CPMAddPackage(
  NAME QtLinuxCMake
  GIT_REPOSITORY ${QTLINUXCMAKE_REPOSITORY}
  GIT_TAG        ${QTLINUXCMAKE_TAG}
)
