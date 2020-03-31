cmake_minimum_required(VERSION 3.1)

# Build common library
AUX_SOURCE_DIRECTORY(./ COMMON_FILES)

add_library(common ${COMMON_FILES})

target_include_directories(
  common
  PUBLIC
  ${FOLLY_INCLUDE_DIR}
  ${FBTHRIFT_INCLUDE_DIR}
  ${WANGLE_INCLUDE_DIR}
  ${FIZZ_INCLUDE_DIR}
  )

target_link_libraries(
  common

  FBThrift::thrift
  FBThrift::thriftcpp2
  Folly::folly
  aws-cpp-sdk-core
  aws-cpp-sdk-s3
  boost_filesystem
  boost_system
  gflags
  glog
  jemalloc
  jsoncpp_lib_static
  ssl
  wangle::wangle
  zstd
  )

add_subdirectory(rocksdb_glogger)
add_subdirectory(stats)
add_subdirectory(tests)
add_subdirectory(jsoncpp)
add_subdirectory(kafka)

