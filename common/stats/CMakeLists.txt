cmake_minimum_required(VERSION 2.8)

AUX_SOURCE_DIRECTORY(./ SRC_FILES)
add_library(stats ${SRC_FILES})
target_include_directories(
  stats
  PUBLIC
  ${FOLLY_INCLUDE_DIR}
  ${MICROHTTPD_INCLUDE_DIRS}
  )
target_link_directories(stats PRIVATE ${MICROHTTPD_LIBRARY_DIRS})
# message(FATAL_ERROR  ${MICROHTTPD_LIBRARY_DIRS})
target_link_libraries(
  stats
  glog
  # ${MICROHTTPD_LIBRARIES}
  ${MICROHTTPD_LINK_LIBRARIES}
  gflags
  ${FOLLY_LIBRARIES}
  )

add_subdirectory(tests)

