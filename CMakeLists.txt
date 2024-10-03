cmake_minimum_required(VERSION 3.11)

project(emacs-gl)

find_package(OpenGL REQUIRED COMPONENTS GLX)
find_package(PkgConfig REQUIRED)
pkg_check_modules(STB REQUIRED stb)
pkg_check_modules(GLM REQUIRED glm)

include_directories(
        ${PROJECT_SOURCE_DIR}/glad/include
        ${STB_INCLUDE_DIRS}
        # ${GLM_INCLUDE_DIRS}
        # ${OPENGL_INCLUDE_DIR}
        # ${PROJECT_BINARY_DIR}/imgui
        )

add_definitions(-DIMGUI_IMPL_OPENGL_LOADER_GLAD)

set(GL_MODULE_SRCLIST
        gl-module.c
        emacs-module-helpers.c
        glenums.c
        glfuncs.c
        # texture.c
        # gui.cpp
        # glm.cpp
        ${PROJECT_SOURCE_DIR}/glad/src/glad.c
        # ${PROJECT_BINARY_DIR}/imgui/imgui_impl_opengl3.cpp
        )

add_library(gl-module MODULE ${GL_MODULE_SRCLIST})
set_target_properties(gl-module PROPERTIES
  C_STANDARD 99
  POSITION_INDEPENDENT_CODE ON
  PREFIX ""
  LIBRARY_OUTPUT_DIRECTORY ${CMAKE_SOURCE_DIR}
  )

target_link_libraries(gl-module
                       # OpenGL::GLX
                       # ${STB_LIBRARIES}
                       # ${GLM_LIBRARIES}
                       # imgui
                      )
