cmake_minimum_required(VERSION 3.1)

project(tgrep)

AUX_SOURCE_DIRECTORY(./ SRC_FILES)

add_executable(tgrep ${SRC_FILES})

target_include_directories(
  tgrep
  PUBLIC
  ${FOLLY_INCLUDE_DIR}
  ${FBTHRIFT_INCLUDE_DIR}
  )
target_link_libraries(
  tgrep
  ${FOLLY_LIBRARIES}
  FBThrift::thrift
  FBThrift::thriftcpp2
  FBThrift::thriftprotocol
  jemalloc
  pthread
  gflags
  glog
  pcap
  zstd
  )
