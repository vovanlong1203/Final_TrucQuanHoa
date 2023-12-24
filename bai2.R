library(shiny)
library(wordcloud2)
library(tm)
library(tokenizers)

# Đọc dữ liệu từ file CSV
data <- read.csv('E:/Nam4/TrucQuanHoaDuLieu/Final_trucquanhoa/data_detail.csv')

data$TITLE <- sapply(data$TITLE, function(x) tokenize_words(x))

data$DESCRIPTION <- sapply(data$DESCRIPTION, function(x) tokenize_words(x))

data$CONTENT <- sapply(data$CONTENT, function(x) tokenize_words(x))

n <- 1
vi_stopword <- tolower(readLines('vietnamese-stopwords.txt'))

#Define the UI
ui <- bootstrapPage(
  numericInput('size', 'size of  wordcloud', n),
  wordcloud2Output('wordcloud2')
)


#Define the server
server <- function(input, output){
  title <- data$DESCRIPTION
  # title <- data$CONTENT
  text <- lapply(title, function(x){
    unlist(strsplit(x, ','))
  })
  text <- unlist(text)
  
  corpus <- tolower(text) #lower character
  corpus <- removePunctuation(corpus) #remove Punctuation
  corpus <- removeNumbers(corpus) #remove nunmber
  corpus <- removeWords(corpus, vi_stopword) #remove stopword
  corpus <- stripWhitespace(corpus)
  
  list_vocab <- lapply(corpus, function(x){
    x <- trimws(x)
    if (nchar(x) > 0){
      return (x)
    } else {
      return (NULL)
    }
  })
  
  list_vocab <- list_vocab[!sapply(list_vocab, is.null)]
  list_vocab <- unlist(list_vocab)
  
  table_word <- table(list_vocab)
  
  vocab <- names(table_word)
  word_freq <- as.vector(table_word)
  
  word_data <- data.frame(word = vocab, freq = word_freq)
  
  output$wordcloud2 <- renderWordcloud2({
    wordcloud2(word_data, size = input$size)
  })
}

#Create application
shinyApp(ui = ui, server = server)