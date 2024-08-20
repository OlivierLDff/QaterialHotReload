if(TARGET Qaterial)
  return()
endif()

include(${CMAKE_CURRENT_LIST_DIR}/CPM.cmake)

set(QATERIAL_REPOSITORY "https://github.com/OlivierLDff/Qaterial.git" CACHE STRING "Qaterial repository url")
set(QATERIAL_TAG master CACHE STRING "Qaterial git tag")

CPMAddPackage(
  NAME Qaterial
  GIT_REPOSITORY ${QATERIAL_REPOSITORY}
  GIT_TAG        ${QATERIAL_TAG}
)
