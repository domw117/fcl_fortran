################################################################################
# Prepare dependencies
################################################################################

# Download external dependencies
include(FCLFortDownloadExternal)

################################################################################
# Required libraries
################################################################################


# libccd
if(NOT TARGET libccd::libccd)
	FCL_FORT_download_libccd()

	# Set libccd options
	SET(BUILD_SHARED_LIBS OFF CACHE BOOL      "Build static libs")
	SET(ENABLE_DOUBLE_PRECISION ON CACHE BOOL "Enable double precision")

	add_subdirectory(${FCL_FORT_EXTERNAL}/libccd)
endif()

# fcl
if(NOT TARGET fcl::fcl)
	FCL_FORT_download_fcl()

	# Set libccd options
	SET(IS_ICPC ON CACHE BOOL      "Build static libs")
	SET(CCD_INCLUDE_DIR ${FCL_FORT_EXTERNAL}/libccd/src CACHE BOOL "Enable double precision")
	SET(CCD_LIBRARY ${FCL_FORT_EXTERNAL}/libccd/src ON CACHE BOOL "Enable double precision")

	add_subdirectory(${FCL_FORT_EXTERNAL}/fcl)
endif()

