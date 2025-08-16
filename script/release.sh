#!/bin/bash

set -euo pipefail

# main.goファイルのパス
MAIN_GO_FILE="../main.go"

# バージョン取得関数
get_current_version() {
    grep -o 'const version = "[^"]*"' "$MAIN_GO_FILE" | sed 's/const version = "\(.*\)"/\1/'
}

# バージョン更新関数
update_version() {
    local new_version="$1"
    sed -i.bak "s/const version = \"[^\"]*\"/const version = \"$new_version\"/" "$MAIN_GO_FILE"
    rm -f "${MAIN_GO_FILE}.bak"
    echo "Version updated to: $new_version"
}

# バージョンをパースする関数
parse_version() {
    local version="$1"
    echo "$version" | tr '.' ' '
}

# メジャーバージョンをインクリメント
increment_major() {
    local current_version
    current_version=$(get_current_version)
    
    read -r major minor patch <<< "$(parse_version "$current_version")"
    
    major=$((major + 1))
    minor=0
    patch=0
    
    new_version="$major.$minor.$patch"
    update_version "$new_version"
}

# マイナーバージョンをインクリメント
increment_minor() {
    local current_version
    current_version=$(get_current_version)
    
    read -r major minor patch <<< "$(parse_version "$current_version")"
    
    minor=$((minor + 1))
    patch=0
    
    new_version="$major.$minor.$patch"
    update_version "$new_version"
}

# パッチバージョンをインクリメント
increment_patch() {
    local current_version
    current_version=$(get_current_version)
    
    read -r major minor patch <<< "$(parse_version "$current_version")"
    
    patch=$((patch + 1))
    
    new_version="$major.$minor.$patch"
    update_version "$new_version"
}

# 現在のバージョンを表示
show_current_version() {
    local current_version
    current_version=$(get_current_version)
    echo "Current version: $current_version"
}

# ヘルプメッセージ
show_help() {
    echo "Usage: $0 [major|minor|patch|show|help]"
    echo ""
    echo "Commands:"
    echo "  major    Increment major version (x.0.0)"
    echo "  minor    Increment minor version (x.y.0)"
    echo "  patch    Increment patch version (x.y.z)"
    echo "  show     Show current version"
    echo "  help     Show this help message"
    echo ""
    echo "Example:"
    echo "  $0 patch   # 1.0.0 -> 1.0.1"
    echo "  $0 minor   # 1.0.1 -> 1.1.0"
    echo "  $0 major   # 1.1.0 -> 2.0.0"
}

# メイン処理
main() {
    # scriptディレクトリからの相対パスでmain.goにアクセスするため、
    # スクリプトのディレクトリに移動
    cd "$(dirname "$0")"
    
    # main.goファイルが存在するかチェック
    if [[ ! -f "$MAIN_GO_FILE" ]]; then
        echo "Error: $MAIN_GO_FILE not found"
        exit 1
    fi
    
    # 引数をチェック
    if [[ $# -eq 0 ]]; then
        show_help
        exit 1
    fi
    
    case "$1" in
        "major")
            echo "Incrementing major version..."
            increment_major
            ;;
        "minor")
            echo "Incrementing minor version..."
            increment_minor
            ;;
        "patch")
            echo "Incrementing patch version..."
            increment_patch
            ;;
        "show")
            show_current_version
            ;;
        "help"|"-h"|"--help")
            show_help
            ;;
        *)
            echo "Error: Unknown command '$1'"
            echo ""
            show_help
            exit 1
            ;;
    esac
}

# スクリプトが直接実行された場合のみmain関数を呼び出す
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
