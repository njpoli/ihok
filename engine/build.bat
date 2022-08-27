REM Build script for engine
@ECHO OFF
SetLocal EnableDelayedExpansion

REM Get a list of all the .c files
SET cFilenames=
FOR /R %%f in (*.c) do (
  SET cFilenames=!cFilenames! %%f
)

REM echo "Files:" %cFilenames%

REM Name of the file "engine"
SET assembly=engine
REM -g (exports debug info) -shared (create a .dll)
SET compilerFlags=-g -shared -Wvarargs -Wall -Werror
REM -Isrc (include the source directory) -I%VULKAN_SDK%/Include (include the vulkan sdk directory)
SET includeFlags=-Isrc -I%VULKAN_SDK%/Include
REM Link with user32, vulkan-1, and vulkan sdk library
SET linkerFlags=-luser32 -lvulkan-1 -L%VULKAN_SDK%/Lib
SET defines=-D_DEBUG -DKEXPORT -D_CRT_SECURE_NO_WARNINGS

ECHO "Building %assembly%%..."
REM Outputs to a bin file
clang %cFilenames% %compilerFlags% -o ../bin/%assembly%.dll %defines% %includeFlags% %linkerFlags%