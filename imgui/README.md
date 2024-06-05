## imgui

ImGui static archives compiled and packaged with the following commands:
```bat
git clone --branch=v1.90.7 --recursive --shallow-submodules https://github.com/ko4life-net/imgui-cmake.git
cd imgui-cmake
mkdir build
cd build

cmake .. -G "Visual Studio 17 2022" -A Win32 -DIMGUI_WITH_BACKEND=ON -DIMGUI_BACKEND_PLATFORM=WIN32 -DIMGUI_BACKEND_DX9=ON -DCMAKE_INSTALL_PREFIX=pkg -DCMAKE_MSVC_RUNTIME_LIBRARY="MultiThreaded$<$<CONFIG:Debug>:Debug>" -DCMAKE_MSVC_DEBUG_INFORMATION_FORMAT="$<$<CONFIG:Debug,RelWithDebInfo>:Embedded>" -DCMAKE_POLICY_DEFAULT_CMP0141=NEW

cmake --build . --config Debug --target install
cmake --build . --config Release --target install
```

Special thanks to @giladreich for suggesting to use this and helping out in the background.
