@echo off
:: llama-vulkan server settings for gpt-oss 20b with opencode
:: Download model from HuggingFace, update the two paths below
:: Requires llama.cpp built with Vulkan support

:: Full path to llama-server.exe
set LLAMA_SERVER=C:\path\to\llama-vulkan\llama-server.exe

:: Full path to the model file
set MODEL=C:\path\to\gpt-oss-20b-Q4_K_M.gguf

:: Reduce --ctx-size or --n-gpu-layers if you run out of VRAM
:: Q4_K_M at 32k ctx needs ~15-16GB VRAM, 16k ctx needs ~12GB VRAM

if not exist "%LLAMA_SERVER%" (
    echo ERROR: llama-server.exe not found at:
    echo   %LLAMA_SERVER%
    echo.
    echo Update the LLAMA_SERVER path at the top of this file.
    pause
    exit /b 1
)

if not exist "%MODEL%" (
    echo ERROR: Model file not found at:
    echo   %MODEL%
    echo.
    echo Update the MODEL path at the top of this file.
    pause
    exit /b 1
)

echo Starting llama-server...
echo Model: %MODEL%
echo Listening on http://127.0.0.1:8000
echo.

"%LLAMA_SERVER%" ^
  --model "%MODEL%" ^
  --host 127.0.0.1 ^
  --port 8000 ^
  --ctx-size 32768 ^
  --n-gpu-layers 99 ^
  --threads 8 ^
  --batch-size 512 ^
  --ubatch-size 512 ^
  -fa on ^
  --no-mmap ^
  --api-key local ^
  --parallel 1 ^
  --cont-batching

:: If we reach here the server exited - pause so you can read any error output
echo.
echo Server exited.
pause

:: Notes:
::   --n-gpu-layers 99   offload all layers to Vulkan GPU
::   -fa on              reduces VRAM significantly, important for 20B
::   --no-mmap           more stable on Windows with Vulkan
::   --ctx-size 32768    context window size (reduce to 16384 if VRAM limited)
::   (no --chat-template) uses the template embedded in the GGUF file, required for
::                       correct <|channel|> tool call parsing with gpt-oss 20b
::   --parallel 1        single inference slot for single-user local use
::   --cont-batching     allows streaming responses to complete cleanly
