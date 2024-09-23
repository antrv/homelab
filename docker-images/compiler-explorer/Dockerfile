FROM debian:bookworm-slim

RUN DEBIAN_FRONTEND=noninteractive \
    && apt-get update \
    && apt-get upgrade \
    && apt-get install -y curl wget ca-certificates make git gnupg \
    && curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg \
    && echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_20.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list \
    && curl -fsSL https://apt.llvm.org/llvm-snapshot.gpg.key | tee /etc/apt/trusted.gpg.d/apt.llvm.org.asc \
    && echo "deb http://apt.llvm.org/bookworm/ llvm-toolchain-bookworm-16 main" | tee /etc/apt/sources.list.d/llvm-toolchain-16.list \
    && echo "deb http://apt.llvm.org/bookworm/ llvm-toolchain-bookworm-17 main" | tee /etc/apt/sources.list.d/llvm-toolchain-17.list \
    && echo "deb http://apt.llvm.org/bookworm/ llvm-toolchain-bookworm main" | tee /etc/apt/sources.list.d/llvm-toolchain.list \
    && apt-get update \
    && apt-get install -y nodejs \
    && apt-get install -y g++ g++-11 g++12 g++13 \
    && apt-get install -y clang-16 clang-tools-16 clang-16-doc clang-format-16 clang-tidy-16 lldb-16 lld-16 \
    && apt-get install -y clang-17 clang-tools-17 clang-17-doc clang-format-17 clang-tidy-17 lldb-17 lld-17 \
    && apt-get install -y clang-18 clang-tools-18 clang-18-doc clang-format-18 clang-tidy-18 lldb-18 lld-18 \
    && git clone --depth=1 https://github.com/compiler-explorer/compiler-explorer.git /compiler-explorer \
    && rm -rf /compiler-explorer/.git \
    && cd /compiler-explorer

ADD cpp.properties /compiler-explorer/etc/config/c++.local.properties

WORKDIR /compiler-explorer
RUN DEBIAN_FRONTEND=noninteractive \
    make prebuild \
    && apt-get remove -y gnupg \
    && apt-get autoremove --purge -y \
    && apt-get autoclean -y \
    && rm -rf /var/cache/apt/* /tmp/*

EXPOSE 10240
ENTRYPOINT ["make"]
CMD ["run-only"]
