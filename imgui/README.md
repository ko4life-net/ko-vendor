## imgui

ImGui static archives compiled and packaged with the following commands:
```bat
git clone --recursive https://github.com/giladreich/cmake-imgui.git
cd imgui && mkdir build && cd build
cmake .. -A "Win32" -DIMGUI_WITH_BACKEND=ON -DIMGUI_BACKEND_PLATFORM=WIN32 -DIMGUI_BACKEND_DX9=ON
cmake --build . --config debug --target install
cmake --build . --config release --target install
```

Special thanks to @giladreich for suggesting to use this and helping in the background.
