#!/bin/bash

set -euo pipefail

# main.goからversion定数の値を抽出
VERSION=$(grep -E 'const version = ".*"' main.go | sed -E 's/.*const version = "(.*)".*/\1/')

if [ -z "$VERSION" ]; then
    echo "Error: Could not extract version from main.go"
    exit 1
fi

echo "Extracted version: v$VERSION"

# 現在のブランチを確認
CURRENT_BRANCH=$(git branch --show-current)
echo "Current branch: $CURRENT_BRANCH"

# mainブランチに切り替え（既にmainブランチの場合はスキップ）
if [ "$CURRENT_BRANCH" != "main" ]; then
    echo "Switching to main branch..."
    git checkout main
    git pull origin main
fi

# タグが既に存在するかチェック
if git tag | grep -q "^v$VERSION$"; then
    echo "Tag v$VERSION already exists"
    exit 1
fi

# タグを作成
echo "Creating tag: v$VERSION"
git tag -a "v$VERSION" -m "Release version v$VERSION"

# タグをリモートにプッシュ
echo "Pushing tag to remote..."
git push origin "v$VERSION"

echo "Successfully created and pushed tag: v$VERSION"
