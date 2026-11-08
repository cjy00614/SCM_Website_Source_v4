@echo off
cd /d "%~dp0"
echo Open http://localhost:8000/data/ in Chrome or Edge.
echo Keep this window open. Press Ctrl+C to stop.
where py >nul 2>nul
if errorlevel 1 (
  python -m http.server 8000 --bind 127.0.0.1 --directory dist
) else (
  py -m http.server 8000 --bind 127.0.0.1 --directory dist
)
pause
