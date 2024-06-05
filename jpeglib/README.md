## jpeg lib

Install NASM compiler needed by the build: https://www.nasm.us/pub/nasm/releasebuilds/2.16.03/win64/

Static archives compiled with the following commands:
```bat
git clone --branch=3.0.3 https://github.com/ko4life-net/libjpeg-turbo
cd libjpeg-turbo
mkdir build
cd build

cmake .. -G "Visual Studio 17 2022" -A Win32 -DENABLE_SHARED=OFF -DWITH_TURBOJPEG=OFF -DJPEG_STATIC_OUTPUT_NAME=jpeg -DCMAKE_INSTALL_PREFIX=pkg -DCMAKE_MSVC_RUNTIME_LIBRARY="MultiThreaded$<$<CONFIG:Debug>:Debug>" -DCMAKE_MSVC_DEBUG_INFORMATION_FORMAT="$<$<CONFIG:Debug,RelWithDebInfo>:Embedded>" -DCMAKE_POLICY_DEFAULT_CMP0141=NEW

cmake --build . --config Debug --target jpeg-static install
cmake --build . --config Release --target jpeg-static install
```

Then I just remove the `bin` and `share` directories and also the shared libraries from the build and copy it to ko-vendor.

cmake flags explained:
- `-DENABLE_SHARED=OFF` - disables dynamic library build
- `-DWITH_TURBOJPEG=OFF` - turns off building turbojpeg
- `-DJPEG_STATIC_OUTPUT_NAME=jpeg` - set the output name of the static archive to be jpeg
- `-DCMAKE_MSVC_RUNTIME_LIBRARY="MultiThreaded$<$<CONFIG:Debug>:Debug>"` - tell the linker that we would like to statically link windows libs, so that redists are not required
- `-DCMAKE_MSVC_DEBUG_INFORMATION_FORMAT="$<$<CONFIG:Debug,RelWithDebInfo>:Embedded>"` - instead of using pdb, embed the symbols into every *.obj file in the static archive. This effectively adds /Z7 to the linker
- `-DCMAKE_POLICY_DEFAULT_CMP0141=NEW` - since setting the property above is new, to make it work, we have to enforce this policy
