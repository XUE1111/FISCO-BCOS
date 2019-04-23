include(ExternalProject)

ExternalProject_Add(rocksdb
    PREFIX ${CMAKE_SOURCE_DIR}/deps
    DOWNLOAD_NAME rocksdb_6.0.1.tar.gz
    DOWNLOAD_NO_PROGRESS 1
    URL https://codeload.github.com/facebook/rocksdb/tar.gz/v6.0.1
    URL_HASH SHA256=9a9aca15bc3617729d976ceb98f6cbd64c6c25c4d92f374b4897aa2d2faa07cf
    CMAKE_COMMAND ${CMAKE_COMMAND}
    CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=<INSTALL_DIR>
    -DCMAKE_POSITION_INDEPENDENT_CODE=${BUILD_SHARED_LIBS}
    ${_only_release_configuration}
    # TODO: not compile dynamic lib
    -DWITH_LZ4=off
    -DWITH_SNAPPY=on
    -DWITH_GFLAGS=off
    -DWITH_TESTS=off
    -DWITH_TOOLS=off
    -DBUILD_SHARED_LIBS=Off
    -DCMAKE_C_COMPILER=${CMAKE_C_COMPILER}
    -DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER}
    BUILD_COMMAND ""
    UPDATE_DISCONNECTED 1
    ${_overwrite_install_command}
    BUILD_IN_SOURCE 1
    LOG_CONFIGURE 1
    LOG_DOWNLOAD 1
    LOG_UPDATE 1
    LOG_BUILD 1
    LOG_INSTALL 1
    BUILD_BYPRODUCTS <INSTALL_DIR>/${CMAKE_INSTALL_LIBDIR}/librocksdb.a
)

ExternalProject_Get_Property(rocksdb INSTALL_DIR)
add_library(RocksDB STATIC IMPORTED GLOBAL)

set(ROCKSDB_INCLUDE_DIR ${INSTALL_DIR}/include/)
set(ROCKSDB_LIBRARY ${INSTALL_DIR}/${CMAKE_INSTALL_LIBDIR}/librocksdb.a)
file(MAKE_DIRECTORY ${ROCKSDB_INCLUDE_DIR})  # Must exist.

set_property(TARGET RocksDB PROPERTY IMPORTED_LOCATION ${ROCKSDB_LIBRARY})
set_property(TARGET RocksDB PROPERTY INTERFACE_INCLUDE_DIRECTORIES ${ROCKSDB_INCLUDE_DIR})
set_property(TARGET RocksDB PROPERTY INTERFACE_LINK_LIBRARIES Snappy)

add_dependencies(RocksDB rocksdb)
unset(INSTALL_DIR)