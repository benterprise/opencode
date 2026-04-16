@echo off
:: llama-vulkan server settings for gpt-oss 20b with opencode
:: Download model from HuggingFace, update MODEL path below
:: Requires llama.cpp built with Vulkan support

set MODEL=C:\path\to\gpt-oss-20b-Q4_K_M.gguf

:: Reduce --ctx-size or --n-gpu-layers if you run out of VRAM
:: Q4_K_M at 16k ctx needs ~12GB VRAM

llama-server.exe ^
  --model %MODEL% ^
  --host 127.0.0.1 ^
  --port 8000 ^
  --ctx-size 16384 ^
  --n-gpu-layers 99 ^
  --threads 8 ^
  --batch-size 512 ^
  --ubatch-size 512 ^
  --flash-attn ^
  --no-mmap ^
  --api-key local ^
  --chat-template chatml ^
  --parallel 1 ^
  --cont-batching

:: Notes:
::   --n-gpu-layers 99   offload all layers to Vulkan GPU
::   --flash-attn        reduces VRAM significantly, important for 20B
::   --no-mmap           more stable on Windows with Vulkan
::   --ctx-size 16384    context window size
::   --chat-template     fixes <|channel|> parse errors by applying correct template
::                       try omitting this if the model ships its own template in the GGUF
::   --parallel 1        single inference slot for single-user local use
::   --cont-batching     allows streaming responses to complete cleanly
