#!/bin/bash

# Thư mục lưu ảnh
stats_dir="stats"
mkdir -p "$stats_dir"

# Cấu hình username
MY_GITHUB_USER="ngnsusinn"
MY_CODEFORCES_USER="ngnsusinn"
MY_LEETCODE_USER="ngnsusinn" 

# Danh sách API (Đã chỉnh về style giống Ảnh 1: github_dark, bỏ viền, background trong suốt để đẹp hơn trên nền đen)
declare -A image_api_endpoints=(
    # 1. GitHub Stats (Dùng lại cái cũ để nó nhỏ gọn, nằm bên trái)
    ["github_stats.svg"]="https://github-readme-stats.vercel.app/api?username=${MY_GITHUB_USER}&show_icons=true&hide=contribs&theme=github_dark&bg_color=0D1117&hide_border=true"
    
    # 2. Top Langs (Dạng thanh ngang compact, nằm bên phải)
    ["top_langs.svg"]="https://github-readme-stats.vercel.app/api/top-langs/?username=${MY_GITHUB_USER}&layout=compact&langs_count=6&theme=github_dark&bg_color=0D1117&hide_border=true&hide=css,html"
    
    # 3. Codeforces (Giữ nguyên)
    ["codeforces_stats.svg"]="https://codeforces-readme-stats.vercel.app/api/card?username=${MY_CODEFORCES_USER}&theme=github_dark&force_username=true&bg_color=0D1117&hide_border=true"
    
    # 4. LeetCode (Giữ nguyên)
    ["leetcode_stats.svg"]="https://leetcard.jacoblin.cool/${MY_LEETCODE_USER}?theme=dark&font=noto_sans&ext=contest"
)

# Hàm tải ảnh
download_image() {
    local image_name="$1"
    local url="$2"
    local temp_file="$(mktemp)"

    # Tải ảnh về file tạm
    http_code=$(curl -o "$temp_file" -s -w "%{http_code}" "$url")
    
    if [ "$http_code" == "200" ]; then
        mv "$temp_file" "${stats_dir}/${image_name}"
        echo "✅ Downloaded ${image_name}"
    else
        echo "❌ Failed to download ${image_name}. HTTP status: $http_code"
        rm -f "$temp_file"
    fi
}

# Chạy vòng lặp
for image_name in "${!image_api_endpoints[@]}"; do
    download_image "$image_name" "${image_api_endpoints[$image_name]}"
done