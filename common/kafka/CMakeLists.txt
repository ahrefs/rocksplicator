cmake_minimum_required(VERSION 3.1)

# Build common library
AUX_SOURCE_DIRECTORY(./ KAFKA_FILES)

add_library(kafka_consumer ${KAFKA_FILES})

target_include_directories(
  kafka_consumer
  PUBLIC
  ${FOLLY_INCLUDE_DIR}
  RdKafka::rdkafka++
  )

target_link_libraries(kafka_consumer RdKafka::rdkafka++)
add_subdirectory(tests)

