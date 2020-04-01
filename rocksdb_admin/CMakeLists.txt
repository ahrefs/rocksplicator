cmake_minimum_required(VERSION 3.1)

set(GEN_FILES
    "gen-cpp2/Admin.cpp"
    "gen-cpp2/Admin.tcc"
    "gen-cpp2/AdminAsyncClient.cpp"
    "gen-cpp2/Admin_processmap_binary.cpp"
    "gen-cpp2/Admin_processmap_compact.cpp"
    "gen-cpp2/rocksdb_admin_constants.cpp"
    "gen-cpp2/rocksdb_admin_data.cpp"
    "gen-cpp2/rocksdb_admin_metadata.cpp"
    "gen-cpp2/rocksdb_admin_types.cpp"
    "gen-cpp2/rocksdb_admin_types.tcc"
    )

add_custom_command(
  OUTPUT ${GEN_FILES}
  COMMAND
  ${FBTHRIFT_COMPILER} --gen mstch_cpp2:include_prefix=".."
  ${CMAKE_CURRENT_SOURCE_DIR}/rocksdb_admin.thrift
  DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/rocksdb_admin.thrift
)

AUX_SOURCE_DIRECTORY(./ SRC_FILES)

add_library(rocksdb_admin ${GEN_FILES} ${SRC_FILES})

target_include_directories(
  rocksdb_admin
  PUBLIC
  ${FOLLY_INCLUDE_DIR}
  )

target_link_libraries(
  rocksdb_admin

  ${JNI_LIBRARIES}
  FBThrift::thriftcpp2
  FBThrift::thrift
  Folly::folly
  RdKafka::rdkafka++
  RocksDB::rocksdb
  boost_filesystem
  common
  glog
  kafka_consumer
  pthread
  rocksdb_admin_detail
  rocksdb_replicator
  rocksdb_glogger
  )

add_subdirectory(tests)
add_subdirectory(detail)
