@echo off
setlocal

cd /d "%~dp0"

echo.
echo [1/5] Checking repository...
git rev-parse --is-inside-work-tree >nul 2>nul
if errorlevel 1 (
  echo No git repository found. Initializing one now...
  git init
  if errorlevel 1 (
    echo Failed to initialize git repository.
    exit /b 1
  )
)

echo.
echo [2/5] Switching branch to main...
git branch -M main
if errorlevel 1 (
  echo Failed to switch branch to main.
  exit /b 1
)

echo.
echo [3/6] Creating commit if needed...
git status --porcelain >nul 2>nul
for /f %%i in ('git status --porcelain ^| find /c /v ""') do set CHANGE_COUNT=%%i

if "%CHANGE_COUNT%"=="0" (
  echo No local changes to commit.
) else (
  git add .
  if errorlevel 1 (
    echo Failed to stage files.
    exit /b 1
  )

  git diff --cached --quiet >nul 2>nul
  if errorlevel 1 (
    git commit -m "Update GitHub profile homepage"
    if errorlevel 1 (
      echo Failed to create commit.
      exit /b 1
    )
  ) else (
    echo Nothing new to commit.
  )
)

echo.
echo [4/6] Configuring GitHub remote...
git remote get-url origin >nul 2>nul
if errorlevel 1 (
  git remote add origin https://github.com/PureDevGo/PureDevGo.git
) else (
  git remote set-url origin https://github.com/PureDevGo/PureDevGo.git
)
if errorlevel 1 (
  echo Failed to configure GitHub remote.
  exit /b 1
)

echo.
echo [5/6] Configuring Gitee remote...
git remote get-url gitee >nul 2>nul
if errorlevel 1 (
  git remote add gitee https://gitee.com/PureDevGo/PureDevGo.git
) else (
  git remote set-url gitee https://gitee.com/PureDevGo/PureDevGo.git
)
if errorlevel 1 (
  echo Failed to configure Gitee remote.
  exit /b 1
)

echo.
echo [6/6] Pushing to GitHub...
git push -u origin main
if errorlevel 1 (
  echo GitHub push failed.
  echo You may need to sign in and run the script again.
  exit /b 1
)

echo.
echo Pushing to Gitee...
git push -u gitee main
if errorlevel 1 (
  echo Gitee push failed.
  echo You may need to sign in and run the script again.
  exit /b 1
)

echo.
echo Done. Pushed main to:
echo   GitHub: https://github.com/PureDevGo/PureDevGo.git
echo   Gitee:  https://gitee.com/PureDevGo/PureDevGo.git
exit /b 0
