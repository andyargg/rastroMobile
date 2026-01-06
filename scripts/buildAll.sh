#!/bin/bash
set -e  # si hay error, corta la ejecución

echo "▶ Executing build_runner"

# Usamos fvm para asegurar la versión de flutter
flutter pub global run fvm:main dart run build_runner build --delete-conflicting-outputs

echo "✅ Build completed successfully!"
