## jpeg lib

Static archives compiled with the following commands:
```bat
git clone https://github.com/libjpeg-turbo/libjpeg-turbo jpeglib --branch=2.1.3
cd jpeglib
mkdir _build
cd _build
cmake .. -G "Visual Studio 17 2022" -A Win32 -DCMAKE_INSTALL_PREFIX=pkg
cmake --build . --config Debug --target install
cmake --build . --config Release --target install
```

Then copied the include and static libraries in this direcotry structure.

Note that I removed the turbojpeg stuff, since we don't need it. Later we'll replace this library with something better.
