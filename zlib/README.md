## zlib

Static archives compiled with the following commands:
```bat
git clone https://github.com/madler/zlib
cd zlib
mkdir _build
cd _build
cmake .. -G "Visual Studio 17 2022" -A Win32 -DCMAKE_INSTALL_PREFIX=.
cmake --build . --config Debug --target install
cmake --build . --config Release --target install
```

Version details can be found in zlib.h file.
