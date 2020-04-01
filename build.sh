#!/bin/bash
set -euo pipefail
mkdir -p external
export SRCDIR=`pwd`

mkdir -p workdir
pushd workdir

wget https://files.pythonhosted.org/packages/73/fb/00a976f728d0d1fecfe898238ce23f502a721c0ac0ecfedb80e0d88c64e9/six-1.12.0-py2.py3-none-any.whl -O six.zip
mkdir python-six
pushd python-six
unzip ../six.zip
popd

wget https://s3.amazonaws.com/aws-cli/awscli-bundle.zip
unzip awscli-bundle.zip
./awscli-bundle/install -i $SRCDIR/external/aws -b $SRCDIR/external/aws/bin/aws

git clone https://github.com/lz4/lz4.git
pushd lz4
git reset --hard c10863b98e1503af90616ae99725ecd120265dfb
make
make install prefix=$SRCDIR/external/lz4
popd

wget https://github.com/google/glog/archive/v0.3.4.zip
unzip v0.3.4.zip
pushd glog-0.3.4
./configure CPPFLAGS="-gdwarf-2 -O3 -fno-omit-frame-pointer" --prefix=$SRCDIR/external/glog
make -j
make install
popd

export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64

wget https://github.com/numactl/numactl/archive/v2.0.12.zip
unzip v2.0.12.zip
pushd numactl-2.0.12
./autogen.sh
./configure --prefix=$SRCDIR/external/numactl
make -j
make install
popd

# RUN: apt-get install libxslt-dev xsltproc docbook-xsl
git clone https://github.com/jemalloc/jemalloc -b 5.2.1 --single-branch
pushd jemalloc
autoconf
./configure \
    --enable-prof \
    --with-xslroot=/usr/share/xml/docbook/stylesheet/docbook-xsl \
    --prefix=$SRCDIR/external/jemalloc \
    --with-version=5.2.1-0-g0
make -j
make -j build_doc
make install
popd

wget http://ftp.gnu.org/gnu/libmicrohttpd/libmicrohttpd-0.9.42.tar.gz
tar -zxvf libmicrohttpd-0.9.42.tar.gz
pushd libmicrohttpd-0.9.42
./configure CPPFLAGS="-gdwarf-2 -O3 -fno-omit-frame-pointer" --prefix=$SRCDIR/external/libmicrohttpd
make -j
make install
popd

git clone https://github.com/facebook/zstd.git -b v1.4.4 --single-branch
pushd zstd
cd build/cmake
cmake . -DCMAKE_INSTALL_PREFIX=$SRCDIR/external/zstd
make install -j
popd

# RUN: apt-get install libdouble-conversion-dev libgoogle-glog-dev libfmt-dev libboost-context-dev
git clone https://github.com/facebook/folly -b v2020.03.23.00 --single-branch
pushd folly
git apply $SRCDIR/folly.patch
mkdir build_
cd build_
(
    export CXXFLAGS="-gdwarf-2 -O3 -fno-omit-frame-pointer -I$SRCDIR/external/jemalloc/include";
    export LDFLAGS="-L$SRCDIR/external/jemalloc/lib -ljemalloc";
    export LD_LIBRARY_PATH="-L$SRCDIR/external/jemalloc/lib";
    export PKG_CONFIG_PATH="-L$SRCDIR/external/jemalloc/lib/pkgconfig";
    cmake .. -DCMAKE_INSTALL_PREFIX=$SRCDIR/external/folly
)
make install -j 6
popd

git clone https://github.com/no1msd/mstch
pushd mstch
git reset --hard 0fde1cf94c26ede7fa267f4b64c0efe5da81a77a
mkdir build
cd build
cmake .. -DCMAKE_INSTALL_PREFIX=$SRCDIR/external/mstch
make -j
make install
popd

git clone https://github.com/rsocket/rsocket-cpp
pushd rsocket-cpp
mkdir build_
cd build_
cmake .. -DCMAKE_INSTALL_PREFIX=$SRCDIR/external/rsocket -DFOLLY_INSTALL_DIR=$SRCDIR/external/folly/lib/cmake
make install -j
popd

git clone https://github.com/facebookincubator/fizz -b v2020.03.23.00 --single-branch
pushd fizz
git apply $SRCDIR/fizz.patch
mkdir build_
cd build_
(
    export CXXFLAGS="-gdwarf-2 -O3 -fno-omit-frame-pointer -I$SRCDIR/external/jemalloc/include";
    export LDFLAGS="-L$SRCDIR/external/jemalloc/lib -levent -ljemalloc -lz";
    export LD_LIBRARY_PATH="-L$SRCDIR/external/jemalloc/lib";
    cmake \
        ../fizz \
        -DCMAKE_INSTALL_PREFIX=$SRCDIR/external/fizz \
        -DFOLLY_LIBRARYDIR=$SRCDIR/external/folly/lib \
        -DFOLLY_INCLUDEDIR=$SRCDIR/external/folly/include
)
make -j
make install
popd

git clone https://github.com/facebook/wangle -b v2020.03.23.00 --single-branch
pushd wangle
git apply $SRCDIR/wangle.patch
mkdir build_
cd build_
cmake \
    ../wangle \
    -DCMAKE_INSTALL_PREFIX=$SRCDIR/external/wangle \
    -DFOLLY_LIBRARYDIR=$SRCDIR/external/folly/lib \
    -DFOLLY_INCLUDEDIR=$SRCDIR/external/folly/include \
    -DCMAKE_PREFIX_PATH="$SRCDIR/external/fizz/lib/cmake"
make install -j
popd

git clone https://github.com/facebook/fbthrift -b v2020.03.23.00 --single-branch
pushd fbthrift
git apply $SRCDIR/fbthrift.patch
mkdir build_
cd build_
(
    export CXXFLAGS="-gdwarf-2 -O3 -fno-omit-frame-pointer -I$SRCDIR/external/jemalloc/include";
    export LDFLAGS="-L$SRCDIR/external/jemalloc/lib -levent";
    export LD_LIBRARY_PATH="-L$SRCDIR/external/jemalloc/lib";
    export PKG_CONFIG_PATH="-L$SRCDIR/external/jemalloc/lib/pkgconfig";
    cmake \
        .. \
        -DCMAKE_INSTALL_PREFIX=$SRCDIR/external/fbthrift \
        -DCMAKE_PREFIX_PATH="$SRCDIR/external/folly/lib/cmake;$SRCDIR/external/rsocket/lib/cmake;$SRCDIR/external/fizz/lib/cmake;$SRCDIR/external/wangle/lib/cmake"
)
make install -j
popd

git clone https://github.com/mavam/libbf
pushd libbf
./configure --prefix=$SRCDIR/external/libbf
make -j
make install
popd

git clone https://github.com/aws/aws-sdk-cpp -b 1.7.305 --single-branch
pushd aws-sdk-cpp
mkdir build
cd build
cmake \
    -DCMAKE_INSTALL_PREFIX=$SRCDIR/external/aws-sdk-cpp \
    -DCMAKE_BUILD_TYPE=Release \
    -DCUSTOM_MEMORY_MANAGEMENT=0 \
    -DSTATIC_LINKING=1 \
    -DBUILD_ONLY="s3" \
    ..
make -j
make install
popd

git clone https://github.com/jbeder/yaml-cpp -b yaml-cpp-0.6.3 --single-branch
pushd yaml-cpp
mkdir build
cd build
cmake \
    -DCMAKE_INSTALL_PREFIX=$SRCDIR/external/yaml-cpp \
    -DCMAKE_BUILD_TYPE=Release \
    ..
make -j
make install
popd

git clone https://github.com/edenhill/librdkafka -b v1.3.0 --single-branch
pushd librdkafka
mkdir build
cd build
cmake \
    -DCMAKE_INSTALL_PREFIX=$SRCDIR/external/librdkafka \
    -DCMAKE_BUILD_TYPE=Release \
    ..
make -j
make install
popd

git clone https://github.com/awslabs/aws-c-common -b v0.4.35 --single-branch
pushd aws-c-common
mkdir build
cd build
cmake .. -DCMAKE_INSTALL_PREFIX=$SRCDIR/external/aws-c-common
make install -j
popd

git clone https://github.com/awslabs/aws-checksums -b v0.1.5 --single-branch
pushd aws-checksums
mkdir build
cd build
cmake .. -DCMAKE_INSTALL_PREFIX=$SRCDIR/external/aws-checksums
make install -j
popd

git clone https://github.com/awslabs/aws-c-event-stream -b v0.1.4 --single-branch
pushd aws-c-event-stream
mkdir build
cd build
cmake \
    .. \
    -DCMAKE_INSTALL_PREFIX=$SRCDIR/external/aws-c-event-stream \
    -DCMAKE_PREFIX_PATH="$SRCDIR/external/aws-c-common/lib/aws-c-common/cmake;$SRCDIR/external/aws-checksums/lib/aws-checksums/cmake" \
    -DCMAKE_MODULE_PATH="$SRCDIR/external/aws-c-common/lib/cmake;"
make install -j
popd

git clone https://github.com/facebook/rocksdb -b v5.14.3 --single-branch
pushd rocksdb
git apply $SRCDIR/rocksdb.patch
mkdir build
cd build
(
    export LDFLAGS="-L$SRCDIR/external/jemalloc/lib -ljemalloc";
    export LD_LIBRARY_PATH="-L$SRCDIR/external/jemalloc/lib";
    cmake \
        .. \
        -DCMAKE_INSTALL_PREFIX=$SRCDIR/external/rocksdb \
        -DUSE_RTTI=1 \
        -DCMAKE_BUILD_TYPE=Release \
        -DWITH_TESTS=0 \
        -DWITH_GFLAGS=0
)
make install DEBUG_LEVEL=0 -j 4
popd

popd
#build:
mkdir build
cd build
cmake_prefix_path=(
    $SRCDIR/external/librdkafka/lib/cmake
    $SRCDIR/external/folly/lib/cmake
    $SRCDIR/external/rsocket/lib/cmake
    $SRCDIR/external/fizz/lib/cmake
    $SRCDIR/external/wangle/lib/cmake
    $SRCDIR/external/aws-sdk-cpp/lib/cmake
    $SRCDIR/external/aws-c-common/lib/aws-c-common/cmake
    $SRCDIR/external/aws-checksums/lib/aws-checksums/cmake
    $SRCDIR/external/aws-c-event-stream/lib/aws-c-event-stream/cmake
    $SRCDIR/external/fbthrift/lib/cmake
    $SRCDIR/external/rocksdb/lib/cmake
    $SRCDIR/external
    $SRCDIR/cmake
)
cmake_prefix_path=$(IFS=';'; echo "${cmake_prefix_path[*]}")
echo $cmake_prefix_path

export PKG_CONFIG_PATH="$SRCDIR/external/libmicrohttpd/lib/pkgconfig"
cmake \
    .. \
    -DCMAKE_PREFIX_PATH=$cmake_prefix_path \
    -DCMAKE_MODULE_PATH=$SRCDIR/external/librdkafka/lib/cmake/RdKafka
make -j
