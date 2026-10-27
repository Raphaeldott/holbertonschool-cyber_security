#!/usr/bin/env bash
echo "=== python PIL ==="; python3 -c "import PIL, PIL.Image; print('PIL', PIL.__version__)" 2>&1
echo "=== ffmpeg ==="; command -v ffmpeg || echo ABSENT
echo "=== convert (imagemagick) ==="; command -v convert || echo ABSENT
echo "=== chromium headless version ==="; chromium-browser --version 2>/dev/null
