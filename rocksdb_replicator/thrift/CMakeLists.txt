cmake_minimum_required(VERSION 3.1)

# Build thrift file
set(GEN_FILES
    "gen-cpp2/Replicator.cpp"
    "gen-cpp2/Replicator.tcc"
    "gen-cpp2/ReplicatorAsyncClient.cpp"
    "gen-cpp2/Replicator_processmap_binary.cpp"
    "gen-cpp2/Replicator_processmap_compact.cpp"
    "gen-cpp2/replicator_constants.cpp"
    "gen-cpp2/replicator_data.cpp"
    "gen-cpp2/replicator_metadata.cpp"
    "gen-cpp2/replicator_types.cpp"
    "gen-cpp2/replicator_types.tcc"
    )

add_custom_command(
  OUTPUT ${GEN_FILES}
  COMMAND
  ${FBTHRIFT_COMPILER} --gen mstch_cpp2:include_prefix=".."
  ${CMAKE_CURRENT_SOURCE_DIR}/replicator.thrift
  DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/replicator.thrift
  )

add_library(replicator_thrift ${GEN_FILES})

target_include_directories(
  replicator_thrift
  PUBLIC
  ${FOLLY_INCLUDE_DIR}
  ${FBTHRIFT_INCLUDE_DIR}
  ${WANGLE_INCLUDE_DIR}
  )
target_link_libraries(
  replicator_thrift

  FBThrift::thriftcpp2
  FBThrift::thrift
  FBThrift::thriftprotocol
  )
