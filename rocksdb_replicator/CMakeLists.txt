cmake_minimum_required(VERSION 3.1)


AUX_SOURCE_DIRECTORY(./ SRC_FILES)
list(REMOVE_ITEM SRC_FILES ${CMAKE_CURRENT_SOURCE_DIR}/performance.cpp)

add_library(rocksdb_replicator ${SRC_FILES})

target_include_directories(
  rocksdb_replicator
  PUBLIC
  ${FOLLY_INCLUDE_DIR}
  )

target_link_libraries(
  rocksdb_replicator

  RocksDB::rocksdb
  FBThrift::thriftcpp2
  FBThrift::thrift
  FBThrift::thriftprotocol
  Folly::folly
  gflags
  glog
  jemalloc
  pthread
  boost_system
  ssl

  common
  stats
  replicator_thrift
  rocksdb_glogger
  )

# Build performance
add_executable(performance ./performance.cpp)

target_link_libraries(performance rocksdb_replicator)

add_subdirectory(thrift)
add_subdirectory(tests)
