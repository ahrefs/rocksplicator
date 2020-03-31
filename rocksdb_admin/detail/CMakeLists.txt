cmake_minimum_required(VERSION 3.1)

# Build common library
AUX_SOURCE_DIRECTORY(./ DETAIL_FILES)

add_library(
  rocksdb_admin_detail ${DETAIL_FILES})
target_include_directories(
  rocksdb_admin_detail
  PUBLIC
  ${FOLLY_INCLUDE_DIR}
  )
