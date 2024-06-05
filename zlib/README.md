# zlib compression library

Static archives compiled with the following commands:
```bat
git clone --branch=v1.3.1 https://github.com/ko4life-net/zlib
cd zlib
mkdir build
cd build

cmake .. -G "Visual Studio 17 2022" -A Win32 -DZLIB_SHARED_PROJECT_NAME="zlib-shared" -DZLIB_STATIC_PROJECT_NAME="zlib" -DZLIB_BUILD_EXAMPLES=OFF -DCMAKE_INSTALL_PREFIX=pkg -DCMAKE_MSVC_RUNTIME_LIBRARY="MultiThreaded$<$<CONFIG:Debug>:Debug>" -DCMAKE_MSVC_DEBUG_INFORMATION_FORMAT="$<$<CONFIG:Debug,RelWithDebInfo>:Embedded>" -DCMAKE_POLICY_DEFAULT_CMP0141=NEW

cmake --build . --config Debug --target zlib install
cmake --build . --config Release --target zlib install
```

Then I just remove the `bin` and `share` directories and also the shared libraries from the build and copy it to ko-vendor.

cmake flags explained:
- `-DZLIB_SHARED_PROJECT_NAME="zlib-shared"` - renames main target zlib to zlib-shared, so that we can name out static library as zlib instead of zlibstatic
- `-DZLIB_STATIC_PROJECT_NAME="zlib"` - renames zlibstatic to zlib
- `-DZLIB_BUILD_EXAMPLES=OFF` - don't build zlib examples
- `-DCMAKE_MSVC_RUNTIME_LIBRARY="MultiThreaded$<$<CONFIG:Debug>:Debug>"` - tell the linker that we would like to statically link windows libs, so that redists are not required
- `-DCMAKE_MSVC_DEBUG_INFORMATION_FORMAT="$<$<CONFIG:Debug,RelWithDebInfo>:Embedded>"` - instead of using pdb, embed the symbols into every *.obj file in the static archive. This effectively adds /Z7 to the linker
- `-DCMAKE_POLICY_DEFAULT_CMP0141=NEW` - since setting the property above is new, to make it work, we have to enforce this policy
