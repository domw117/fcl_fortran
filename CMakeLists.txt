################################################################################
cmake_minimum_required(VERSION 3.8)
project(fcl_fortran)
################################################################################

if(INPUT_THIRD_PARTY_DIR)
	set(FCL_FORT_EXTERNAL ${CMAKE_CURRENT_SOURCE_DIR}/${INPUT_THIRD_PARTY_DIR}/)
else()
	set(FCL_FORT_EXTERNAL ${CMAKE_CURRENT_SOURCE_DIR}/3rdparty/)
endif()

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake)

# Sort projects inside the solution
#set_property(GLOBAL PROPERTY USE_FOLDERS ON)

# Generate position independent code by default
set(CMAKE_POSITION_INDEPENDENT_CODE ON)


################################################################################

# FCL_Fort options
#option()

# libccd options
SET(BUILD_SHARED_LIBS OFF CACHE BOOL      "Build static libs")
SET(ENABLE_DOUBLE_PRECISION ON CACHE BOOL "Enable double precision")

# Setup dependencies
include(FCLFortDependencies)
find_package (Eigen3 3.3 REQUIRED NO_MODULE)

################################################################################
# FCL_Fortran library
################################################################################

# Extra warnings
target_link_libraries(${PROJECT_NAME} PRIVATE warnings::all)

# Use C++11
target_compile_features(${PROJECT_NAME} PUBLIC cxx_std_11)

################################################################################
# Required libraries
################################################################################


#target_include_directories(${PROJECT_NAME} PUBLIC)

target_link_libraries(${PROJECT_NAME}
	PUBLIC
		Eigen3::Eigen
)


################################################################################
# Subdirectories
################################################################################

# Other sources
add_subdirectory(src)

