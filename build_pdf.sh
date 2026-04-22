chromium --headless \
  --disable-gpu \
  --print-to-pdf=guide.pdf \
  --no-pdf-header-footer \
  --run-all-compositor-stages-before-draw \
  --disable-pdf-tagging \
  --force-color-profile=srgb \
  git-reference/book/index.html
