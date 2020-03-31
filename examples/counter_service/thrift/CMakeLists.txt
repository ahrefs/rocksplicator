cmake_minimum_required(VERSION 3.1)

# Build thrift file
set(GEN_FILES
    "gen-cpp2/counter_constants.cpp"
    "gen-cpp2/counter_data.cpp"
    "gen-cpp2/counter_types.tcc"
    "gen-cpp2/counter_types.cpp"
    "gen-cpp2/counter_metadata.cpp"
    "gen-cpp2/Counter.tcc"
    "gen-cpp2/Counter.cpp"
    "gen-cpp2/CounterAsyncClient.cpp"
    )

add_custom_command(
  OUTPUT ${GEN_FILES}
  COMMAND
  ${FBTHRIFT_COMPILER} --gen mstch_cpp2:include_prefix=".."
  -I ${CMAKE_CURRENT_SOURCE_DIR}/../../..
  ${CMAKE_CURRENT_SOURCE_DIR}/counter.thrift
  DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/counter.thrift
  DEPENDS rocksdb_admin
)
INCLUDE_DIRECTORIES( ${CMAKE_BINARY_DIR}/rocksdb_admin/gen-cpp2 )
add_library(counter_thrift ${GEN_FILES})
target_include_directories(counter_thrift PUBLIC ${FBTHRIFT_INCLUDE_DIR} ${WANGLE_INCLUDE_DIR})
target_link_libraries(counter_thrift FBThrift::thriftprotocol)
