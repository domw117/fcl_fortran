################################################################################

include(DownloadProject)

# With CMake 3.8 and above, we can hide warnings about git being in a
# detached head by passing an extra GIT_CONFIG option
if(NOT (${CMAKE_VERSION} VERSION_LESS "3.8.0"))
    set(FCL_FORT_EXTRA_OPTIONS "GIT_CONFIG advice.detachedHead=false")
else()
    set(FCL_FORT_EXTRA_OPTIONS "")
endif()

# Shortcut function
function(FCL_FORT_download_project name)
    download_project(
        PROJ         ${name}
        SOURCE_DIR   ${FCL_FORT_EXTERNAL}/${name}
        DOWNLOAD_DIR ${FCL_FORT_EXTERNAL}/.cache/${name}
        QUIET
        ${FCL_FORT_EXTRA_OPTIONS}
        ${ARGN}
    )
endfunction()

################################################################################

## libccd
function(FCL_FORT_download_libccd)
    FCL_FORT_download_project(libccd
        GIT_REPOSITORY https://github.com/danfis/libccd.git
        GIT_TAG        7931e764a19ef6b21b443376c699bbc9c6d4fba8
    )
endfunction()

## flexible-collision-library
function(FCL_FORT_download_fcl)
    FCL_FORT_download_project(fcl
        GIT_REPOSITORY https://github.com/flexible-collision-library/fcl.git
        GIT_TAG        97455a46de121fb7c0f749e21a58b1b54cd2c6be
    )
endfunction()
