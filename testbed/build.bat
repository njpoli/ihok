REM Build script for testbed
@ECHO OFF
SetLocal EnableDelayedExpansion

REM Get a list of all the .c files
SET cFilenames=
FOR /R %%f in (*.c) do (
  SET cFilenames=!cFilenames! %%f
)

REM echo "Files:" %cFilenames%

REM Name of the file "testbed"
SET assembly=testbed
REM -g (exports debug info) 
SET compilerFlags=-g
REM -Isrc (include the source directory) -I../engine/src (include the engine source directory)
SET includeFlags=-Isrc -I../engine/src/
REM Link with user32, vulkan-1, and vulkan sdk library
SET linkerFlags=-L../bin/ -lengine.lib
SET defines=-D_DEBUG -DKIMPORT

ECHO "Building %assembly%%..."
REM Outputs to a bin file executable
clang %cFilenames% %compilerFlags% -o ../bin/%assembly%.exe %defines% %includeFlags% %linkerFlags%