library(rvest)

# Mở trang web và lấy HTML
url <- "https://vnexpress.net/bong-da"
page <- read_html(url)

# Số trang cần crawl
numpage <- 10
data <- data.frame(link = character())

for (i in 2:numpage) {
  # Lấy các phần tử HTML chứa thông tin bài viết
  div_list_article <- page %>%
    html_nodes(xpath = '//article[@class="item-news item-news-common thumb-left"]')
  
  # Trích xuất đường link từ mỗi bài viết
  links <- div_list_article %>% 
    html_node(xpath = './/a') %>%
    html_attr("href")
  
  print(links)
  data <- rbind(data, data.frame(link = links))
  
  page <- read_html(paste0("https://vnexpress.net/bong-da-p", i)) 
  print(page)
  Sys.sleep(3)
}

write.csv(data, "E:/Nam4/TrucQuanHoaDuLieu/Final_trucquanhoa/link_bong_da.csv", row.names = FALSE)
