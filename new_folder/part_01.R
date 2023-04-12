# PART ONE: Getting the data from reddit 

if (!require(RedditExtractoR)) {
  devtools::install_version("RedditExtractoR", version = "2.1.5", repos = "http://cran.us.r-project.org")
}
library(RedditExtractoR)


# get the top posts from the chatGPT subreddit
top_chatGPT_urls = find_thread_urls(subreddit = "chatGPT", sort_by="top",period='all')

# Filter the data
top_chatGPT_urls_latest = subset(top_chatGPT_urls, date_utc >= '2022-12-01' & date_utc < '2023-04-01')

# set some containers(list) to store the data
date_utc = c()
url = c()
title = c()
comment = c()
title_text = c()

# choose the number of posts
nrow(top_chatGPT_urls_latest)
# OUTPUT: 988(too much)


#just choose top 100 posts
for (i in 1:nrow(top_chatGPT_urls_latest)){
  
  c1 = get_thread_content(top_chatGPT_urls_latest$url[i])
  df1 = data.frame(c1$comments)
  
  
  date_utc = append(date_utc,df1$date)
  url = append(url,df1$url)
  comment = append(comment,df1$comment)
  
  title = append(title,rep(top_chatGPT_urls_latest$title[i], times = nrow(df1)))
  title_text = append(title_text,rep(top_chatGPT_urls_latest$text[i], times = nrow(df1)))

}

# store the data to dataframe
data = data.frame(date_utc = date_utc,
                  url = url,
                  title = title,
                  title_text = title_text,
                  comment = comment
                  )

# the number of data
nrow(data)

# Store as an offline file

library(openxlsx)
write.csv(data, file = "/Users/siheng_huang/Desktop/data.csv", row.names = FALSE)

# Part2:

# 接口
df = read.csv('/Part_One/data.csv', header = TRUE)

head(df)
colnames(df)
