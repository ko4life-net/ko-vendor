## spdlog

Static archives compiled with the following commands:
```bat
git clone https://github.com/gabime/spdlog.git --branch=1.10.0
cd spdlog
mkdir _build
cd _build
cmake .. -G "Visual Studio 17 2022" -A Win32 -DCMAKE_INSTALL_PREFIX=pkg
cmake --build . --config Debug --target install
cmake --build . --config Release --target install
```

Note that I had to modify CMake code after add_library call to add this:
```cmake
set_property(TARGET spdlog PROPERTY MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>")
```
