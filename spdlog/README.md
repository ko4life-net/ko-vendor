## spdlog

Static archives compiled with the following commands:
```bat
git clone --branch=v1.14.1 https://github.com/ko4life-net/spdlog.git
cd spdlog
mkdir build
cd build

cmake .. -G "Visual Studio 17 2022" -A Win32 -DCMAKE_INSTALL_PREFIX=pkg -DSPDLOG_USE_STD_FORMAT=ON -DSPDLOG_BUILD_EXAMPLE=OFF -DCMAKE_MSVC_RUNTIME_LIBRARY="MultiThreaded$<$<CONFIG:Debug>:Debug>" -DCMAKE_POLICY_DEFAULT_CMP0091=NEW

cmake --build . --config Debug --target install
cmake --build . --config Release --target install
```

Note that with the existing spdlog cmake project files, setting `MSVC_RUNTIME_LIBRARY` is completely ignored unless we tell `CMP0091` cmake policy to use the new behavior. Read more here: https://discourse.cmake.org/t/msvc-runtime-library-completely-ignored/10004

Also note that using turning `SPDLOG_USE_STD_FORMAT` to `ON` requires C++20, which the ko codebase uses.
