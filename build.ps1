param (
  # comma separated
  [string[]][Parameter(Mandatory)]
  $projects,

  # The drive that is not a system drive, so no difficulties with permissions and such
  # to simply build the project. a temporary directory will be created in the provided
  # drive for building the dependencies as the working dir.
  [string][Parameter(Mandatory)]
  $drive = "D"
)

$WORK_DIR = $null

# Versions
$VER_JPEGLIB = "3.0.3"
$VER_ZLIB = "v1.3.1"
$VER_SPDLOG = "v1.14.1"
$VER_IMGUI = "v1.90.7"
$VER_SIMPLEINI = "v4.23"


function build_jpeglib {
  Write-Host "Building jpeglib..."
  git clone --branch=$VER_JPEGLIB --depth=1 https://github.com/ko4life-net/libjpeg-turbo
  cd libjpeg-turbo
  mkdir build
  cd build

  cmake .. -G "Visual Studio 17 2022" -A Win32 `
    -DENABLE_SHARED=OFF `
    -DWITH_TURBOJPEG=OFF `
    -DJPEG_STATIC_OUTPUT_NAME=jpeg `
    -DCMAKE_INSTALL_PREFIX=pkg `
    -DCMAKE_MSVC_RUNTIME_LIBRARY="MultiThreaded$<$<CONFIG:Debug>:Debug>" `
    -DCMAKE_MSVC_DEBUG_INFORMATION_FORMAT="$<$<CONFIG:Debug,RelWithDebInfo>:Embedded>" `
    -DCMAKE_POLICY_DEFAULT_CMP0141=NEW

  cmake --build . --config Debug --target jpeg-static install
  cmake --build . --config Release --target jpeg-static install

  Remove-Item $PSScriptRoot\jpeglib\include, $PSScriptRoot\jpeglib\lib -Recurse -Force -ErrorAction SilentlyContinue
  Copy-Item .\pkg\include $PSScriptRoot\jpeglib\ -Recurse
  Copy-Item .\pkg\lib $PSScriptRoot\jpeglib\ -Recurse

  cd $WORK_DIR
}

function build_zlib {
  Write-Host "Building zlib..."
  git clone --branch=$VER_ZLIB --depth=1 https://github.com/ko4life-net/zlib
  cd zlib
  mkdir build
  cd build

  cmake .. -G "Visual Studio 17 2022" -A Win32 `
    -DZLIB_SHARED_PROJECT_NAME="zlib-shared" `
    -DZLIB_STATIC_PROJECT_NAME="zlib" `
    -DZLIB_BUILD_EXAMPLES=OFF `
    -DCMAKE_INSTALL_PREFIX=pkg `
    -DCMAKE_MSVC_RUNTIME_LIBRARY="MultiThreaded$<$<CONFIG:Debug>:Debug>" `
    -DCMAKE_MSVC_DEBUG_INFORMATION_FORMAT="$<$<CONFIG:Debug,RelWithDebInfo>:Embedded>" `
    -DCMAKE_POLICY_DEFAULT_CMP0141=NEW

  cmake --build . --config Debug --target zlib install
  cmake --build . --config Release --target zlib install

  Remove-Item $PSScriptRoot\zlib\include, $PSScriptRoot\zlib\lib -Recurse -Force -ErrorAction SilentlyContinue
  Remove-Item .\pkg\lib\zlib-*.lib -Force -ErrorAction SilentlyContinue # remove shared libs. TODO: I should probably update their cmake file.
  Copy-Item .\pkg\include $PSScriptRoot\zlib\ -Recurse
  Copy-Item .\pkg\lib $PSScriptRoot\zlib\ -Recurse

  cd $WORK_DIR
}

function build_spdlog {
  Write-Host "Building spdlog..."
  git clone --branch=$VER_SPDLOG --depth=1 https://github.com/ko4life-net/spdlog.git
  cd spdlog
  mkdir build
  cd build

  cmake .. -G "Visual Studio 17 2022" -A Win32 `
    -DCMAKE_INSTALL_PREFIX=pkg `
    -DSPDLOG_USE_STD_FORMAT=ON `
    -DSPDLOG_BUILD_EXAMPLE=OFF `
    -DCMAKE_MSVC_RUNTIME_LIBRARY="MultiThreaded$<$<CONFIG:Debug>:Debug>" `
    -DCMAKE_POLICY_DEFAULT_CMP0091=NEW

  cmake --build . --config Debug --target install
  cmake --build . --config Release --target install

  Remove-Item $PSScriptRoot\spdlog\include, $PSScriptRoot\spdlog\lib -Recurse -Force -ErrorAction SilentlyContinue
  Copy-Item .\pkg\include $PSScriptRoot\spdlog\ -Recurse
  Copy-Item .\pkg\lib $PSScriptRoot\spdlog\ -Recurse

  cd $WORK_DIR
}

function build_imgui {
  Write-Host "Building imgui..."
  git clone --branch=$VER_IMGUI --depth=1 --recursive --shallow-submodules https://github.com/ko4life-net/imgui-cmake.git
  cd imgui-cmake
  mkdir build
  cd build

  cmake .. -G "Visual Studio 17 2022" -A Win32 `
    -DIMGUI_WITH_BACKEND=ON `
    -DIMGUI_BACKEND_PLATFORM=WIN32 `
    -DIMGUI_BACKEND_DX9=ON `
    -DCMAKE_INSTALL_PREFIX=pkg `
    -DCMAKE_MSVC_RUNTIME_LIBRARY="MultiThreaded$<$<CONFIG:Debug>:Debug>" `
    -DCMAKE_MSVC_DEBUG_INFORMATION_FORMAT="$<$<CONFIG:Debug,RelWithDebInfo>:Embedded>" `
    -DCMAKE_POLICY_DEFAULT_CMP0141=NEW

  cmake --build . --config Debug --target install
  cmake --build . --config Release --target install

  Remove-Item $PSScriptRoot\imgui\include, $PSScriptRoot\imgui\lib, $PSScriptRoot\imgui\misc -Recurse -Force -ErrorAction SilentlyContinue
  Copy-Item .\pkg\include $PSScriptRoot\imgui\ -Recurse
  Copy-Item .\pkg\lib $PSScriptRoot\imgui\ -Recurse
  Copy-Item .\pkg\misc $PSScriptRoot\imgui\ -Recurse

  cd $WORK_DIR
}

function build_simpleini {
  Write-Host "Building simpleini..."
  git clone --branch=$VER_SIMPLEINI --depth=1 https://github.com/ko4life-net/simpleini
  cd simpleini
  mkdir build
  cd build

  # There is no actual lib here, since it is a header only library
  cmake .. -G "Visual Studio 17 2022" -A Win32 -DCMAKE_INSTALL_PREFIX=pkg
  cmake --build . --config Release --target install

  Remove-Item $PSScriptRoot\simpleini\include, $PSScriptRoot\simpleini\lib -Recurse -Force -ErrorAction SilentlyContinue
  Copy-Item .\pkg\include $PSScriptRoot\simpleini\include\simpleini\ -Recurse
  Copy-Item .\pkg\lib $PSScriptRoot\simpleini\ -Recurse

  cd $WORK_DIR
}

function build_projects {
  if ($projects -contains "all") {
    build_jpeglib
    build_zlib
    build_spdlog
    build_imgui
    build_simpleini
  } else {
    foreach ($project in $projects) {
      switch ($project.ToLower()) {
        "jpeglib" { build_jpeglib }
        "zlib" { build_zlib }
        "spdlog" { build_spdlog }
        "imgui" { build_imgui }
        "simpleini" { build_simpleini }
        default { Write-Host "Unknown project: [$project]" }
      }
    }
  }

  Write-Host "Succesfully built and installed [$($projects -join ", ")] projects!"
}

function create_work_dir {
  if (-not (Get-PSDrive $drive -ErrorAction SilentlyContinue)) {
    Write-Host "Invalid drive [$drive]. Use one of the available below:"
    Get-PSDrive
    exit 1
  }

  $wd = $null
  foreach ($i in 0..10) {
    $_wd = $drive + ":\_ko" + ((New-Guid) -split '-')[0]
    if (-not (Test-Path $_wd)) {
      $wd = (mkdir $_wd).FullName
      break
    }
  }
  if (-not $wd) {
    Write-Host "Failed to create working directory..."
    exit 1
  }

  return $wd
}

function Main {
  $drive = $drive.ToUpper()
  $WORK_DIR = create_work_dir
  Write-Host "Building projects working directory: [$WORK_DIR]"
  pushd $WORK_DIR
  $start_time = Get-Date
  try {
    build_projects
  } catch {
    MessageError "An error occurred: $_"
    exit 1
  } finally {
    $end_time = Get-Date
    $elapsed_time = $end_time - $start_time
    Write-Host "Time taken: $($elapsed_time.ToString('hh\:mm\:ss\.ffff'))"
    popd
  }
}

Main
