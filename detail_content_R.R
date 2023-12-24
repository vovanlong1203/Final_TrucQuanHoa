library(rvest)
library(dplyr)

# Đọc dữ liệu từ file CSV
data <- read.csv("E:/Nam4/TrucQuanHoaDuLieu/Final_trucquanhoa/link_bong_da.csv") # Thay đổi đường dẫn tới file data1.csv

data_content <- data.frame(TITLE = character(), DESCRIPTION = character(), CONTENT = character(), stringsAsFactors = FALSE)

for (link in data$link) {
  # Đọc HTML từ mỗi liên kết
  page <- read_html(link)
  #print(page)
  # Lấy thông tin về tiêu đề, mô tả và nội dung
  title <- page %>% html_node(xpath = './/h1[@class="title-detail"]') %>% html_text()
  print(title)
  desc <- page %>% html_node(xpath = './/p[@class="description"]') %>% html_text()
  print(desc)
  list_normal <- page %>% html_nodes(xpath = './/p[@class="Normal"]') %>% html_text()
  print(length(list_normal))
  list_part <- list_normal[0:(length(list_normal) - 1)]
  
  # Kết hợp các thành phần trong list_normal thành một chuỗi duy nhất
  content_combined <- paste0(list_part, collapse = "")
  print(content_combined)
  
  # Thêm thông tin vào DataFrame data_content
  data_content <- rbind(data_content, data.frame(TITLE = title, DESCRIPTION = desc, CONTENT = content_combined, stringsAsFactors = FALSE))
  Sys.sleep(2)
}
# Hiển thị kết quả hoặc lưu vào file CSV
print(data_content)
write.csv(data_content, "E:/Nam4/TrucQuanHoaDuLieu/Final_trucquanhoa/data_detail.csv", row.names = FALSE) # Lưu dữ liệu vào file CSV
