# Setup suitesparse

# LINUX: Function adds suitesparse lib target and add it to all if found
function(linux_suitesparse_lib name lib)
  if(${${name}_FOUND})
    add_library(suitesparse::${lib} INTERFACE IMPORTED)
    target_include_directories(suitesparse::${lib} INTERFACE ${${name}_INCLUDE_DIR})
    target_link_libraries(suitesparse::${lib} INTERFACE ${${name}_LIBRARY})

    target_link_libraries(suitesparse::all INTERFACE suitesparse::${lib})

  else()
    message(SEND_ERROR "Failed finding lib ${name}")
  endif()
endfunction()

# MAC: Function adds suitesparse lib target and add it to all
function(mac_suitesparse_lib name lib)
  add_library(suitesparse::${lib} INTERFACE IMPORTED)
  target_include_directories(suitesparse::${lib} INTERFACE ${CMAKE_SOURCE_DIR}/include/suitesparse)
  target_link_libraries(suitesparse::${lib} INTERFACE ${CMAKE_SOURCE_DIR}/lib/mac/lib${name}.a)
  target_link_libraries(suitesparse::all INTERFACE suitesparse::${lib})
endfunction()

# All library
add_library(suitesparse::all INTERFACE IMPORTED)

if(${CMAKE_SYSTEM_NAME} MATCHES "Windows") # Windows
  messages(SEND_ERROR "Suitesparse cmake integration not yet implemented for windows!")
elseif(${CMAKE_SYSTEM_NAME} MATCHES "Darwin") # OSX
  mac_suitesparse_lib(amd amd)
  mac_suitesparse_lib(btf btf)
  mac_suitesparse_lib(camd camd)
  mac_suitesparse_lib(ccolamd ccolamd)
  mac_suitesparse_lib(cholmod cholmod)
  mac_suitesparse_lib(colamd colamd)
  mac_suitesparse_lib(klu klu)
  mac_suitesparse_lib(ldl ldl)
  mac_suitesparse_lib(suitesparseconfig config)
  mac_suitesparse_lib(umfpack umfpack)

elseif(${CMAKE_SYSTEM_NAME} MATCHES "Linux") # Linux
  include (lib/linux/FindSuiteSparse.cmake)

  if(NOT ${SUITESPARSE_FOUND})
    message(SEND_ERROR "Failed finding suitesparse!")
  endif(NOT ${SUITESPARSE_FOUND})

  linux_suitesparse_lib("AMD" amd)
  linux_suitesparse_lib("BTF" btf)
  linux_suitesparse_lib("CAMD" camd)
  linux_suitesparse_lib("CCOLAMD" ccolamd)
  linux_suitesparse_lib("CHOLMOD" cholmod)
  linux_suitesparse_lib("COLAMD" colamd)
  linux_suitesparse_lib("CXPARSE" cxparse)
  linux_suitesparse_lib("KLU" klu)
  linux_suitesparse_lib("LDL" ldl)
  linux_suitesparse_lib("SUITESPARSE_CONFIG" config)
  linux_suitesparse_lib("UMFPACK" umfpack)
else()
  messages(SEND_ERROR "Unsupported platform!")
endif()
