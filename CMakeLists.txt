cmake_minimum_required(VERSION 3.10)

project(rocksplicator)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_FLAGS "-gdwarf-2 -O3 -Wall -fPIC -fno-omit-frame-pointer")

find_package(PkgConfig REQUIRED)
find_package(Java COMPONENTS Development Runtime REQUIRED)
if(DEFINED $ENV{JAVA_HOME})
  message(FATAL_ERROR "Please designate $JAVA_HOME, pointing to the system root of JDK of your choice")
else()
  set(_JAVA_HOME ENV{JAVA_HOME})
endif()
find_package(JNI)
# message(FATAL_ERROR ${JAVA_JVM_LIBRARY} ${JNI_LIBRARIES})
find_package(glog REQUIRED)
find_package(folly REQUIRED)
find_package(wangle REQUIRED)
find_package(yarpl REQUIRED)
find_package(rsocket REQUIRED)
find_package(FBThrift REQUIRED)
find_package(fizz REQUIRED)
find_package(aws-cpp-sdk-core REQUIRED)
find_package(aws-cpp-sdk-s3 REQUIRED)
find_dependency(RdKafka REQUIRED)
find_package(RocksDB REQUIRED)
include_directories(
  "${_JAVA_HOME}/include"
  "${_JAVA_HOME}/include/linux"
  "${JNI_INCLUDE_DIRS}"
  "${FOLLY_INCLUDE_DIR}"
  )

pkg_check_modules(MICROHTTPD REQUIRED libmicrohttpd)

include_directories(${CMAKE_CURRENT_SOURCE_DIR})
include_directories("${CMAKE_CURRENT_SOURCE_DIR}/build")

# link_directories("/usr/local/lib/linux/intel64/Release/")
# link_directories("/usr/lib/jvm/java-8-openjdk-amd64/jre/lib/amd64/server/")

enable_testing()

# submodules
add_subdirectory(googletest)

# Sub-projects
add_subdirectory(common)
add_subdirectory(examples)
add_subdirectory(rocksdb_admin)
add_subdirectory(rocksdb_replicator)
add_subdirectory(tgrep)
