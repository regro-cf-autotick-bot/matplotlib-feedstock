@echo on

<<<<<<< HEAD
set "MESON_ARGS=%MESON_ARGS% --buildtype=release --prefix=%LIBRARY_PREFIX% --pkg-config-path=%LIBRARY_LIB%\pkgconfig -Dlibdir=lib -Dsystem-freetype=false -Dsystem-qhull=true"

if "%CI%" == "azure" (
    :: Hack to try removing problematic Python from Azure CI image
    :: Replace with conda-smithy solution when available
    :: xref: https://github.com/conda-forge/conda-smithy/pull/1966
    mkdir C:\empty
    robocopy /purge /r:0 /w:0 /mt /ns /nc /np /nfl /ndl /njh /njs C:\empty C:\hostedtoolcache\windows\Python > nul 2>&1
    rmdir /q C:\hostedtoolcache\windows\Python
    rmdir /q C:\empty
)

=======
>>>>>>> main
mkdir builddir

%PYTHON% -m mesonbuild.mesonmain setup builddir %MESON_ARGS% ^
    -Dsystem-freetype=true -Dsystem-libraqm=true -Dsystem-qhull=true
if %ERRORLEVEL% NEQ 0 (type builddir\meson-logs\meson-log.txt && exit 1)

%PYTHON% -m build --wheel ^
         --no-isolation --skip-dependency-check -Cbuilddir=builddir -Ccompile-args=-v
if %ERRORLEVEL% NEQ 0 exit 1

%PYTHON% -m pip install --find-links dist matplotlib
if %ERRORLEVEL% NEQ 0 exit 1
