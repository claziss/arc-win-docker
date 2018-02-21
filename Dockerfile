FROM claziss/arc-gnu:latest

# Put the arc compiler in the path
ENV PATH $PATH:/usr/src/arc/INSTALL/bin

RUN buildDeps='texinfo byacc flex libncurses5-dev zlib1g-dev libexpat1-dev wget mingw-w64' \
    && set -x \
    && apt-get update && apt-get install -y $buildDeps --no-install-recommends \
    && rm -r /var/lib/apt/lists/* \
    && dir="$(mktemp -d)" \
    && cd /usr/src/arc/toolchain \
    && mkdir /usr/src/arc/INSTALL_WIN \
    && ./build-all.sh --no-uclibc --no-multilib --no-auto-checkout \
       --no-auto-pull --cpu em --host i686-w64-mingw32 --no-system-expat \
       --target-cflags \"-mno-sdata\" --jobs "$(nproc)" --no-pdf \
       --build-dir "$dir" --install-dir /usr/src/arc/INSTALL_WIN \
        --no-optsize-newlib  --no-optsize-libstdc++ \
    && rm -rf "$dir" \
    && apt-get purge -y --auto-remove $buildDeps
