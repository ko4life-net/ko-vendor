## simpleini

Header only library packed with the following commands:
```bat
git clone --branch=v4.23 --depth=1 https://github.com/ko4life-net/simpleini
cd simpleini
mkdir build
cd build

cmake .. -G "Visual Studio 17 2022" -A Win32 -DCMAKE_INSTALL_PREFIX=pkg
cmake --build . --config Release --target install
```
