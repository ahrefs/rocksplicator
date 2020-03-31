cmake_minimum_required(VERSION 2.8)

# Build thrift file
set(GEN_FILES
    "gen-cpp2/dummy_service_types.tcc"
    "gen-cpp2/dummy_service_types.cpp"
    "gen-cpp2/dummy_service_constants.cpp"
    "gen-cpp2/dummy_service_data.cpp"
    "gen-cpp2/dummy_service_metadata.cpp"
    "gen-cpp2/DummyService.tcc"
    "gen-cpp2/DummyService.cpp"
    "gen-cpp2/DummyServiceAsyncClient.cpp"
    "gen-cpp2/DummyService_processmap_binary.cpp"
    "gen-cpp2/DummyService_processmap_compact.cpp"
    )


add_custom_command(
  OUTPUT ${GEN_FILES}
  COMMAND
  ${FBTHRIFT_COMPILER} --gen mstch_cpp2:include_prefix=".."
  ${CMAKE_CURRENT_SOURCE_DIR}/dummy_service.thrift
  DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/dummy_service.thrift
  )

add_library(dummy_service_thrift ${GEN_FILES})
target_include_directories(dummy_service_thrift PUBLIC ${FBTHRIFT_INCLUDE_DIR} ${WANGLE_INCLUDE_DIR})
target_link_libraries(dummy_service_thrift gtest ssl stats FBThrift::thriftprotocol)
