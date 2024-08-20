include(${CMAKE_CURRENT_LIST_DIR}/CPM.cmake)

set(QTWINDOWSCMAKE_REPOSITORY "https://github.com/OlivierLDff/QtWindowsCMake" CACHE STRING "Repository of QtWindowsCMake")
set(QTWINDOWSCMAKE_TAG "master" CACHE STRING "Git Tag of QtWindowsCMake")

set(QBC_REPOSITORY "https://github.com/OlivierLdff/QBCInstaller.git" CACHE STRING "QBC repository, can be a local URL")
set(QBC_TAG master CACHE STRING "QBC git tag")

CPMAddPackage(
  NAME QtWindowsCMake
  GIT_REPOSITORY ${QTWINDOWSCMAKE_REPOSITORY}
  GIT_TAG        ${QTWINDOWSCMAKE_TAG}
)
