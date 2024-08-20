include(${CMAKE_CURRENT_LIST_DIR}/CPM.cmake)

set(QTSTATICCMAKE_REPOSITORY "https://github.com/OlivierLDff/QtStaticCMake.git" CACHE STRING "QtStaticCMake repository, can be a local URL")
set(QTSTATICCMAKE_TAG "master" CACHE STRING "QtStaticCMake git tag")

CPMAddPackage(
  NAME QtStaticCMake
  GIT_REPOSITORY ${QTSTATICCMAKE_REPOSITORY}
  GIT_TAG        ${QTSTATICCMAKE_TAG}
)
