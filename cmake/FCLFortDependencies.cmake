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
	add_subdirectory(${FCL_FORT_EXTERNAL}/libccd)
endif()

# fcl
if(NOT TARGET fcl::fcl)
	FCL_FORT_download_fcl()
	add_subdirectory(${FCL_FORT_EXTERNAL}/fcl)
endif()

