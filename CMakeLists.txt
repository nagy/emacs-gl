cmake_minimum_required(VERSION 3.16)

project(emacs-gl C CXX)

# Dependencies (from a nix devshell or system packages):
#   imgui >= 1.91 with CMake config (imgui::imgui)
#   glm with CMake config (glm::glm)
#   stb headers
#   glad2-generated OpenGL loader (see gen-glad.sh), by default expected in
#   ${CMAKE_BINARY_DIR}/glad (override with -DGLAD_DIR=/path/to/glad).

find_package(imgui CONFIG REQUIRED)
find_package(glm CONFIG REQUIRED)
find_package(OpenGL REQUIRED COMPONENTS GLX)

find_path(STB_INCLUDE_DIR NAMES stb_image.h stb_truetype.h PATH_SUFFIXES stb)
if(NOT STB_INCLUDE_DIR)
  message(FATAL_ERROR "stb headers not found (set STB_INCLUDE_DIR)")
endif()

set(GLAD_DIR "${CMAKE_BINARY_DIR}/glad" CACHE PATH
  "Directory containing the glad2 output (include/ and src/).")
if(NOT EXISTS "${GLAD_DIR}/src/glad.c")
  message(FATAL_ERROR
    "glad loader not found in ${GLAD_DIR}. Run ./gen-glad.sh ${GLAD_DIR} first.")
endif()

add_library(gl-module MODULE
        gl-module.c
        emacs-module-helpers.c
        glenums.c
        glfuncs.c
        texture.c
        gui.cpp
        glm.cpp
        third_party/imgui-backend/imgui_impl_opengl3.cpp
        "${GLAD_DIR}/src/glad.c"
        )

target_include_directories(gl-module PRIVATE
        "${GLAD_DIR}/include"
        ${STB_INCLUDE_DIR}
        third_party/imgui-backend
        )

set_target_properties(gl-module PROPERTIES
  C_STANDARD 99
  CXX_STANDARD 17
  POSITION_INDEPENDENT_CODE ON
  PREFIX ""
  LIBRARY_OUTPUT_DIRECTORY ${CMAKE_SOURCE_DIR}
  )

target_link_libraries(gl-module PRIVATE
  imgui::imgui
  glm::glm
  OpenGL::GLX
  )
