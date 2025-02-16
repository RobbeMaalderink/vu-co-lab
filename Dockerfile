FROM ubuntu:24.04

RUN apt-get update && apt-get install -y --no-install-recommends \
    cmake clang make llvm libclang-rt-dev \
    && rm -rf /var/lib/apt/lists/*
WORKDIR /co-lab
COPY .cmake/ .cmake/
COPY CMakeLists.txt .
COPY build-run .

ENTRYPOINT ["./build-run"]
