#!/bin/bash

# Thư mục lưu ảnh
stats_dir="stats"
mkdir -p "$stats_dir"

# Cấu hình username của bạn ở đây
MY_GITHUB_USER="ngnsusinn"
MY_CODEFORCES_USER="ngnsusinn"
MY_LEETCODE_USER="ngnsusinn"

# Danh sách các API và tên file ảnh tương ứng
declare -A image_api_endpoints=(
    # Thống kê GitHub tổng quan
    ["github_stats.svg"]="https://github-readme-stats.vercel.app/api?username=${MY_GITHUB_USER}&show_icons=true&hide=contribs&theme=github_dark&border_color=30363d"
    
    # Thống kê ngôn ngữ lập trình
    ["top_langs.svg"]="https://github-readme-stats.vercel.app/api/top-langs/?username=${MY_GITHUB_USER}&layout=compact&langs_count=6&theme=github_dark&border_color=30363d&size_weight=0.5&count_weight=0.5&hide=css"
    
    # Thống kê Codeforces
    ["codeforces_stats.svg"]="https://codeforces-readme-stats.vercel.app/api/card?username=${MY_CODEFORCES_USER}&theme=github_dark&force_username=true&border_color=30363d"
    
    # Thống kê LeetCode (Lưu ý: CSS custom từ repo gốc có thể không hoạt động với bạn, mình đã đưa về default theme dark)
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

# Chạy vòng lặp tải tất cả ảnh
for image_name in "${!image_api_endpoints[@]}"; do
    download_image "$image_name" "${image_api_endpoints[$image_name]}"
done