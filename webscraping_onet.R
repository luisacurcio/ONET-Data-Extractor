library(httr)
library(rvest)
library(purrr)
library(stringr)
library(tidyverse)
library(httr)
library(zoo)
library(here)
#install.packages("openxlsx")
library(openxlsx)

#Use here() for working directory

###############################################################################
############################### Abilities #####################################
###############################################################################

# Make the request to access the page with "expand all" option
url <- 'https://www.onetonline.org/find/descriptor/browse/1.A/1.A.1/1.A.1.g/1.A.1.b/1.A.1.d/1.A.1.e/1.A.1.c/1.A.1.f/1.A.1.a/1.A.3/1.A.3.b/1.A.3.c/1.A.3.a/1.A.2/1.A.2.b/1.A.2.a/1.A.2.c/1.A.4/1.A.4.b/1.A.4.a'
page <- read_html(url)

# Extract the div with id "cmtop": only the division that contains links to the CSV files
cmtop <- html_nodes(page, '#cmtop')
cat(as.character(cmtop))

# Extract all links with tag "a" from the div with id "cmtop"
# The "a" tag defines an anchor: a reference or a link that takes 
# the user to a specific section or part of a web page
links <- html_nodes(cmtop, "a")

# Extract only the links without class (to simplify the code because the class is already 
# indicated in the CSV)
links_without_class <- links[is.na(html_attr(links, "class"))]

# Extract the href attributes of the links
# The href attribute defines the address to go to when clicking the link
# Each href defines the complement of the original site (everything that comes after .org)
# And takes us to the page we want to open (each of the sub-classifications)
hrefs <- html_attr(links_without_class, "href")

# Print the URLs
print(hrefs)

# Create an empty list to store the CSVs
csv_list <- list()

for (link in hrefs) {
  # Make the request to the link
  response <- GET(paste0("https://www.onetonline.org", link))
  
  # Get the content of the response as text
  html <- read_html(content(response, "text"))
  
  temp_links <- html_nodes(html, "a")
  temp_hrefs <- html_attr(temp_links, "href")
  csv_list <- append(csv_list, temp_hrefs[grep(".csv", temp_hrefs)])
  
}

# Get data from the CSVs
accumulated_data <- data.frame()

for (csv_path in csv_list) {
  # Read the CSV file
  data <- read.csv(paste0("https://www.onetonline.org", csv_path))
  
  # Perform operations on the 'data' dataframe
  data <- data[, c(1, 4, 5)]
  hierarchy <- sub(".*/(.*)\\.csv.*", "\\1", csv_path)
  data <- data %>% mutate(hierarchy = hierarchy)
  
  # Append the data to the accumulated dataframe
  accumulated_data <- rbind(accumulated_data, data)
}

write.csv(accumulated_data, file = "abilities.csv", row.names = FALSE)


###############################################################################
############################### Interests #####################################
###############################################################################

url <- 'https://www.onetonline.org/find/descriptor/browse/1.B.1'
page <- read_html(url)


cmtop <- html_nodes(page, '#cmtop')
cat(as.character(cmtop))
links <- html_nodes(cmtop, "a")
links_without_class <- links[is.na(html_attr(links, "class"))]
hrefs <- html_attr(links_without_class, "href")
hrefs <- tail(hrefs, -1)  # Drop first observation
csv_list <- list()

for (link in hrefs) {
  response <- GET(paste0("https://www.onetonline.org", link))
  html <- read_html(content(response, as = "text"))  
  temp_links <- html_nodes(html, "a")
  temp_hrefs <- html_attr(temp_links, "href")
  csv_list <- append(csv_list, temp_hrefs[grep(".csv", temp_hrefs)])
  
}

accumulated_data <- data.frame()

#path_csv  <- "https://www.onetonline.org/explore/interests/Social/Social.csv?fmt=csv"
#data <- read.csv(path_csv)

for (path_csv in csv_list) {
  data <- read.csv(paste0("https://www.onetonline.org",path_csv))
  data <- data[, c(1, 3, 4)]
  hierarchy <- sub(".*/(.*)\\.csv.*", "\\1", path_csv)
  data <- data %>% mutate(hierarchy = hierarchy)
  accumulated_data <- rbind(accumulated_data, data)
}

write.csv(accumulated_data, file = "interests.csv", row.names = FALSE)


###############################################################################
############################### Knowledge #####################################
###############################################################################

url <- 'https://www.onetonline.org/find/descriptor/browse/2.C/2.C.7/2.C.1/2.C.9/2.C.3/2.C.5/2.C.8/2.C.2/2.C.4'
page <- read_html(url)


cmtop <- html_nodes(page, '#cmtop')
links <- html_nodes(cmtop, "a")
links_without_class <- links[is.na(html_attr(links, "class"))]
hrefs <- html_attr(links_without_class, "href")
csv_list <- list()

for (link in hrefs) {
  response <- GET(paste0("https://www.onetonline.org", link))
  html <- read_html(content(response, as = "text"))  
  temp_links <- html_nodes(html, "a")
  temp_hrefs <- html_attr(temp_links, "href")
  csv_list <- append(csv_list, temp_hrefs[grep(".csv", temp_hrefs)])
  
}

accumulated_data <- data.frame()

#path_csv <- "https://www.onetonline.org/find/descriptor/result/2.C.10/Transportation.csv?fmt=csv"
#data <- read.csv(path_csv)


for (path_csv in csv_list) {
  data <- read.csv(paste0("https://www.onetonline.org",path_csv))
  data <- data[, c(1, 4, 5)]
  hierarchy <- sub(".*/(.*)\\.csv.*", "\\1", path_csv)
  data <- data %>% mutate(hierarchy = hierarchy)
  accumulated_data <- rbind(accumulated_data, data)
}

write.csv(accumulated_data, file = "knowledge.csv", row.names = FALSE)


###############################################################################
############################### Basic Skills ##################################
###############################################################################

url <- 'https://www.onetonline.org/find/descriptor/browse/2.A/2.A.1/2.A.2'
page <- read_html(url)


cmtop <- html_nodes(page, '#cmtop')
links <- html_nodes(cmtop, "a")
links_without_class <- links[is.na(html_attr(links, "class"))]
hrefs <- html_attr(links_without_class, "href")
csv_list <- list()

for (link in hrefs) {
  response <- GET(paste0("https://www.onetonline.org", link))
  html <- read_html(content(response, as = "text"))  
  temp_links <- html_nodes(html, "a")
  temp_hrefs <- html_attr(temp_links, "href")
  csv_list <- append(csv_list, temp_hrefs[grep(".csv", temp_hrefs)])
  
}

accumulated_data <- data.frame()


for (path_csv in csv_list) {
  data <- read.csv(paste0("https://www.onetonline.org",path_csv))
  data <- data[, c(1, 4, 5)]
  hierarchy <- sub(".*/(.*)\\.csv.*", "\\1", path_csv)
  data <- data %>% mutate(hierarchy = hierarchy)
  accumulated_data <- rbind(accumulated_data, data)
}

write.csv(accumulated_data, file = "basic_skills.csv", row.names = FALSE)



###############################################################################
#################### Work Activities ##########################################
###############################################################################

url <- 'https://www.onetonline.org/find/descriptor/browse/4.A/4.A.1/4.A.1.b/4.A.1.a/4.A.4/4.A.4.c/4.A.4.a/4.A.4.b/4.A.2/4.A.2.a/4.A.2.b/4.A.3/4.A.3.b/4.A.3.a'
page <- read_html(url)


cmtop <- html_nodes(page, '#cmtop')
links <- html_nodes(cmtop, "a")
links_without_class <- links[is.na(html_attr(links, "class"))]
hrefs <- html_attr(links_without_class, "href")
csv_list <- list()

for (link in hrefs) {
  response <- GET(paste0("https://www.onetonline.org", link))
  html <- read_html(content(response, as = "text"))  
  temp_links <- html_nodes(html, "a")
  temp_hrefs <- html_attr(temp_links, "href")
  csv_list <- append(csv_list, temp_hrefs[grep(".csv", temp_hrefs)])
  
}

accumulated_data <- data.frame()


for (path_csv in csv_list) {
  data <- read.csv(paste0("https://www.onetonline.org",path_csv))
  data <- data[, c(1, 4, 5)]
  hierarchy <- sub(".*/(.*)\\.csv.*", "\\1", path_csv)
  data <- data %>% mutate(hierarchy = hierarchy)
  accumulated_data <- rbind(accumulated_data, data)
}

write.csv(accumulated_data, file = "work_activities.csv", row.names = FALSE)


###############################################################################
#################### Work Context #############################################
###############################################################################

url <- 'https://www.onetonline.org/find/descriptor/browse/4.C/4.C.1/4.C.1.a/4.C.1.a.2/4.C.1.d/4.C.1.c/4.C.1.b/4.C.1.b.1/4.C.2/4.C.2.d/4.C.2.d.1/4.C.2.b/4.C.2.b.1/4.C.2.c/4.C.2.c.1/4.C.2.e/4.C.2.e.1/4.C.2.a/4.C.2.a.1/4.C.3/4.C.3.c/4.C.3.a/4.C.3.a.2/4.C.3.d/4.C.3.b'
page <- read_html(url)


cmtop <- html_nodes(page, '#cmtop')
links <- html_nodes(cmtop, "a")
links_without_class <- links[is.na(html_attr(links, "class"))]
hrefs <- html_attr(links_without_class, "href")
csv_list <- list()

for (link in hrefs) {
  response <- GET(paste0("https://www.onetonline.org", link))
  html <- read_html(content(response, as = "text"))  
  temp_links <- html_nodes(html, "a")
  temp_hrefs <- html_attr(temp_links, "href")
  csv_list <- append(csv_list, temp_hrefs[grep(".csv", temp_hrefs)])
  
}

accumulated_data <- data.frame()

#path_csv <- "https://www.onetonline.org/find/descriptor/result/4.C.1.a.2.h/Electronic_Mail.csv?fmt=csv"
#data <- read.csv(path_csv)

for (path_csv in csv_list) {
  data <- read.csv(paste0("https://www.onetonline.org",path_csv))
  data <- data[, c(1, 3, 4)]
  hierarchy <- sub(".*/(.*)\\.csv.*", "\\1", path_csv)
  data <- data %>% mutate(hierarchy = hierarchy)
  accumulated_data <- rbind(accumulated_data, data)
}

write.csv(accumulated_data, file = "work_context.csv", row.names = FALSE)


###############################################################################
#################### Work Styles ###############################################
###############################################################################

url <- 'https://www.onetonline.org/find/descriptor/browse/1.C/1.C.1/1.C.4/1.C.5/1.C.3/1.C.7/1.C.2'
page <- read_html(url)


cmtop <- html_nodes(page, '#cmtop')
links <- html_nodes(cmtop, "a")
links_without_class <- links[is.na(html_attr(links, "class"))]
hrefs <- html_attr(links_without_class, "href")
csv_list <- list()

for (link in hrefs) {
  response <- GET(paste0("https://www.onetonline.org", link))
  html <- read_html(content(response, as = "text"))  
  temp_links <- html_nodes(html, "a")
  temp_hrefs <- html_attr(temp_links, "href")
  csv_list <- append(csv_list, temp_hrefs[grep(".csv", temp_hrefs)])
  
}

accumulated_data <- data.frame()

#path_csv <- "https://www.onetonline.org/find/descriptor/result/1.C.5.c/Integrity.csv?fmt=csv"
#data <- read.csv(path_csv)

for (path_csv in csv_list) {
  data <- read.csv(paste0("https://www.onetonline.org",path_csv))
  data <- data[, c(1, 3, 4)]
  hierarchy <- sub(".*/(.*)\\.csv.*", "\\1", path_csv)
  data <- data %>% mutate(hierarchy = hierarchy)
  accumulated_data <- rbind(accumulated_data, data)
}

write.csv(accumulated_data, file = "work_styles.csv", row.names = FALSE)


###############################################################################
#################### Work Values ##############################################
###############################################################################

url <- 'https://www.onetonline.org/find/descriptor/browse/1.B.2'
page <- read_html(url)


cmtop <- html_nodes(page, '#cmtop')
links <- html_nodes(cmtop, "a")
links_without_class <- links[is.na(html_attr(links, "class"))]
hrefs <- html_attr(links_without_class, "href")
csv_list <- list()

for (link in hrefs) {
  response <- GET(paste0("https://www.onetonline.org", link))
  html <- read_html(content(response, as = "text"))  
  temp_links <- html_nodes(html, "a")
  temp_hrefs <- html_attr(temp_links, "href")
  csv_list <- append(csv_list, temp_hrefs[grep(".csv", temp_hrefs)])
  csv_list <- gsub(" ", "_", csv_list)
}

accumulated_data <- data.frame()

for (path_csv in csv_list) {
  data <- read.csv(paste0("https://www.onetonline.org",path_csv))
  data <- data[, c(1, 3, 4)]
  hierarchy <- sub(".*/(.*)\\.csv.*", "\\1", path_csv)
  data <- data %>% mutate(hierarchy = hierarchy)
  accumulated_data <- rbind(accumulated_data, data)
}

write.csv(accumulated_data, file = "work_values.csv", row.names = FALSE)






##Now I extract hierarchy levels

###############################################################################
############################### Abilities #####################################
###############################################################################
url <- 'https://www.onetonline.org/find/descriptor/browse/1.A/1.A.1/1.A.1.g/1.A.1.b/1.A.1.d/1.A.1.e/1.A.1.c/1.A.1.f/1.A.1.a/1.A.3/1.A.3.b/1.A.3.c/1.A.3.a/1.A.2/1.A.2.b/1.A.2.a/1.A.2.c/1.A.4/1.A.4.b/1.A.4.a'
page <- read_html(url)

cmtop <- html_nodes(page, '#cmtop')

# Extract <li> elements
li_elements <- html_nodes(cmtop, "li")

# Extract text and hierarchy level of <li> elements
levels_li <- html_attr(li_elements, "id")  # or "id" or another attribute
description <- html_text(html_nodes(li_elements, "div[class*='cm-desc']"))
text_li <- html_text(li_elements)

# Create a dataframe with two columns
df <- data.frame(Text = text_li, Descriptions = description, Level = levels_li)

# New column with the size of the levels
df$level_size <- nchar(df$Level) - 12

# Adjust levels
df$hierarchy <- ifelse(df$level_size == 1, 1,
                       ifelse(df$level_size == 3, 2, 3))

df <- df[, c(1, 2, ncol(df))]
df$major_skill <- "Abilities"
df$Text <- gsub("\n  \n  Folder (closedopen)\n    ", "", df$Text, fixed = TRUE)
df$Text <- ifelse(df$hierarchy %in% c(1, 2),
                  sapply(strsplit(df$Text, "\n"), function(x) x[1]),
                  df$Text)

df$Text <- ifelse(df$hierarchy %in% c(1, 2),
                  df$Text,
                  sapply(strsplit(df$Text, "\n  \n    \n    "), function(x) x[2]))

df$Text <- ifelse(df$hierarchy %in% c(1, 2),
                  df$Text,
                  sapply(strsplit(df$Text, "\n"), function(x) x[1]))

###############################################################################
############################### Interests #####################################
###############################################################################
url2 <- 'https://www.onetonline.org/find/descriptor/browse/1.B.1'
page2 <- read_html(url2)
cmtop2 <- html_nodes(page2, '#cmtop')

elements_li2 <- html_nodes(cmtop2, "li")
levels_li2 <- html_attr(elements_li2, "id")  
description2 <- html_text(html_nodes(elements_li2, "div[class*='cm-desc']"))
text_li2 <- html_text(elements_li2)
df2 <- data.frame(Text = text_li2, Descriptions = description2, Level = levels_li2)
df2$level_size <- nchar(df2$Level) - 14
df2$hierarchy <- df2$level_size
df2 <- df2[, c(1, 2, ncol(df2))]
df2$major_skill <- "Interests"
df2$Text <- ifelse(df2$hierarchy %in% c(1) ,
                   sapply(strsplit(df2$Text, "\n  \n    \n    "), function(x) x[2]),
                   df2$Text)
df2$Text <- ifelse(df2$hierarchy %in% c(1) ,
                   sapply(strsplit(df2$Text, "\n"), function(x) x[1]),
                   df2$Text)


###############################################################################
############################### Knowledge #####################################
###############################################################################

url3 <- 'https://www.onetonline.org/find/descriptor/browse/2.C/2.C.7/2.C.1/2.C.9/2.C.3/2.C.5/2.C.8/2.C.2/2.C.4'
page3 <- read_html(url3)
cmtop3 <- html_nodes(page3, '#cmtop')


elements_li3 <- html_nodes(cmtop3, "li")
levels_li3 <- html_attr(elements_li3, "id")
description3 <- html_text(html_nodes(elements_li3, "div[class*='cm-desc']"))
text_li3 <- html_text(elements_li3)
df3 <- data.frame(Text = text_li3, Descriptions = description3,Level = levels_li3)
df3$size_levels <- nchar(df3$Level)-12
df3$hierarchy <- ifelse(df3$size_levels == 1, 1,
                        ifelse(df3$size_levels == 3, 2, 3))
df3 <- df3[, c(1,2, ncol(df3))]
df3$major_skill <- "Knowledge"
df3$Text <- gsub("\n  \n  Folder (closedopen)\n    ", "", df3$Text, fixed = TRUE)
df3$Text <- ifelse(df3$hierarchy %in% c(1, 2) ,
                   sapply(strsplit(df3$Text, "\n"), function(x) x[1]),
                   df3$Text)
df3$Text <- ifelse(df3$hierarchy %in% c(1, 2) ,
                   df3$Text,
                   sapply(strsplit(df3$Text, "\n  \n    \n    "), function(x) x[2]))

df3$Text <- ifelse(df3$hierarchy %in% c(1, 2),
                   df3$Text,
                   sapply(strsplit(df3$Text, "\n"), function(x) x[1]))



###############################################################################
############################### Basic Skills ##################################
###############################################################################

url4 <- 'https://www.onetonline.org/find/descriptor/browse/2.A/2.A.1/2.A.2'
page4 <- read_html(url4)
cmtop4 <- html_nodes(page4, '#cmtop')

elements_li4 <- html_nodes(cmtop4, "li")
levels_li4 <- html_attr(elements_li4, "id")  
description4 <- html_text(html_nodes(elements_li4, "div[class*='cm-desc']"))
text_li4 <- html_text(elements_li4)
df4 <- data.frame(Text = text_li4, Descriptions = description4,Level = levels_li4)
df4$size_levels <- nchar(df4$Level)-12
df4$hierarchy <- ifelse(df4$size_levels == 1, 1,
                         ifelse(df4$size_levels == 3, 2, 3))

df4 <- df4[, c(1,2, ncol(df4))]
df4$major_skill <- "Basic Skills"
df4$Text <- gsub("\n  \n  Folder (closedopen)\n    ", "", df4$Text, fixed = TRUE)
df4$Text <- ifelse(df4$hierarchy %in% c(1) ,
                    sapply(strsplit(df4$Text, "\n"), function(x) x[1]),
                    df4$Text)

df4$Text <- ifelse(df4$hierarchy %in% c(1) ,
                    df4$Text,
                    sapply(strsplit(df4$Text, "\n  \n    \n    "), function(x) x[2]))

df4$Text <- ifelse(df4$hierarchy %in% c(1),
                    df4$Text,
                    sapply(strsplit(df4$Text, "\n"), function(x) x[1]))



###############################################################################
#################### Cross Functional Skills ##################################
###############################################################################

url5 <- 'https://www.onetonline.org/find/descriptor/browse/2.B/2.B.2/2.B.5/2.B.1/2.B.4/2.B.3'
page5 <- read_html(url5)
cmtop5 <- html_nodes(page5, '#cmtop')

elements_li5 <- html_nodes(cmtop5, "li")
levels_li5 <- html_attr(elements_li5, "id") 
description5 <- html_text(html_nodes(elements_li5, "div[class*='cm-desc']"))
text_li5 <- html_text(elements_li5)
df5 <- data.frame(Text = text_li5, Descriptions = description5,Level = levels_li5)
df5$size_levels <- nchar(df5$Level)-12
df5$hierarchy <- ifelse(df5$size_levels == 1, 1,
                         ifelse(df5$size_levels == 3, 2, 3))
df5 <- df5[, c(1,2, ncol(df5))]
df5$major_skill <- "Cross Functional Skills"
df5$Text <- gsub("\n  \n  Folder (closedopen)\n    ", "", df5$Text, fixed = TRUE)

df5$Text <- ifelse(df5$hierarchy %in% c(1) ,
                    sapply(strsplit(df5$Text, "\n"), function(x) x[1]),
                    df5$Text)

df5$Text <- ifelse(df5$hierarchy %in% c(1) ,
                    df5$Text,
                    sapply(strsplit(df5$Text, "\n  \n    \n    "), function(x) x[2]))

df5$Text <- ifelse(df5$hierarchy %in% c(1),
                    df5$Text,
                    sapply(strsplit(df5$Text, "\n"), function(x) x[1]))

###############################################################################
#################### Work Activities ##########################################
###############################################################################

url6 <- 'https://www.onetonline.org/find/descriptor/browse/4.A/4.A.1/4.A.1.b/4.A.1.a/4.A.4/4.A.4.c/4.A.4.a/4.A.4.b/4.A.2/4.A.2.a/4.A.2.b/4.A.3/4.A.3.b/4.A.3.a'
page6 <- read_html(url6)
cmtop6 <- html_nodes(page6, '#cmtop')

elements_li6 <- html_nodes(cmtop6, "li")
levels_li6 <- html_attr(elements_li6, "id") 
description6 <- html_text(html_nodes(elements_li6, "div[class*='cm-desc']"))
text_li6 <- html_text(elements_li6)
df6 <- data.frame(Text = text_li6, Descriptions = description6,Level = levels_li6)
df6$size_levels <- nchar(df6$Level)-12
df6$hierarchy <- ifelse(df6$size_levels == 1, 1,
                         ifelse(df6$size_levels == 3, 2, 3))
df6 <- df6[, c(1,2, ncol(df6))]
df6$major_skill <- "Work Activities"
df6$Text <- gsub("\n  \n  Folder (closedopen)\n    ", "", df6$Text, fixed = TRUE)

df6$Text <- ifelse(df6$hierarchy %in% c(1) ,
                    sapply(strsplit(df6$Text, "\n"), function(x) x[1]),
                    df6$Text)

df6$Text <- ifelse(df6$hierarchy %in% c(1) ,
                    df6$Text,
                    sapply(strsplit(df6$Text, "\n  \n    \n    "), function(x) x[2]))

df6$Text <- ifelse(df6$hierarchy %in% c(1),
                    df6$Text,
                    sapply(strsplit(df6$Text, "\n"), function(x) x[1]))



###############################################################################
#################### Work Context #############################################
###############################################################################

url7 <- 'https://www.onetonline.org/find/descriptor/browse/4.C/4.C.1/4.C.1.a/4.C.1.a.2/4.C.1.d/4.C.1.c/4.C.1.b/4.C.1.b.1/4.C.2/4.C.2.d/4.C.2.d.1/4.C.2.b/4.C.2.b.1/4.C.2.c/4.C.2.c.1/4.C.2.e/4.C.2.e.1/4.C.2.a/4.C.2.a.1/4.C.3/4.C.3.c/4.C.3.a/4.C.3.a.2/4.C.3.d/4.C.3.b'
page7 <- read_html(url7)
cmtop7 <- html_nodes(page7, '#cmtop')

elements_li7 <- html_nodes(cmtop7, "li")
levels_li7 <- html_attr(elements_li7, "id") 
description7 <- html_text(html_nodes(elements_li7, "div[class*='cm-desc']"))
text_li7 <- html_text(elements_li7)
df7 <- data.frame(Text = text_li7, Descriptions = description7,Level = levels_li7)
df7$size_levels <- nchar(df7$Level)-12
df7$hierarchy <- ifelse(df7$size_levels == 1, 1,
                         ifelse(df7$size_levels == 3, 2, 3))
df7 <- df7[, c(1,2, ncol(df7))]
df7$major_skill <- "Work Activities"
df7$Text <- gsub("\n  \n  Folder (closedopen)\n    ", "", df7$Text, fixed = TRUE)

df7$Text <- ifelse(df7$hierarchy %in% c(1) ,
                    sapply(strsplit(df7$Text, "\n"), function(x) x[1]),
                    df7$Text)

df7$Text <- ifelse(df7$hierarchy %in% c(1) ,
                    df7$Text,
                    sapply(strsplit(df7$Text, "\n  \n    \n    "), function(x) x[2]))

df7$Text <- ifelse(df7$hierarchy %in% c(1),
                    df7$Text,
                    sapply(strsplit(df7$Text, "\n"), function(x) x[1]))


###############################################################################
#################### Work Styles ###############################################
###############################################################################

url8 <- 'https://www.onetonline.org/find/descriptor/browse/1.C/1.C.1/1.C.4/1.C.5/1.C.3/1.C.7/1.C.2'
page8 <- read_html(url8)
cmtop8 <- html_nodes(page8, '#cmtop')

elements_li8 <- html_nodes(cmtop8, "li")
levels_li8 <- html_attr(elements_li8, "id") 
description8 <- html_text(html_nodes(elements_li8, "div[class*='cm-desc']"))
text_li8 <- html_text(elements_li8)
df8 <- data.frame(Text = text_li8, Descriptions = description8,Level = levels_li8)
df8$size_levels <- nchar(df8$Level)-12
df8$hierarchy <- ifelse(df8$size_levels == 1, 1,
                         ifelse(df8$size_levels == 3, 2, 3))
df8 <- df8[, c(1,2, ncol(df8))]
df8$major_skill <- "Work Styles"
df8$Text <- gsub("\n  \n  Folder (closedopen)\n    ", "", df8$Text, fixed = TRUE)

df8$Text <- ifelse(df8$hierarchy %in% c(1) ,
                    df8$Text,
                    sapply(strsplit(df8$Text, "\n  \n    \n    "), function(x) x[2]))

df8$Text <- ifelse(df8$hierarchy %in% c(1) & grepl("Independence", df8$Text),
                    sapply(strsplit(df8$Text, "\n  \n    \n    "), function(x) x[2]),
                    df8$Text)

df8$Text <- ifelse(df8$hierarchy %in% c(1,2),
                    sapply(strsplit(df8$Text, "\n"), function(x) x[1]))



###############################################################################
#################### Work Values ##############################################
###############################################################################

url9 <- 'https://www.onetonline.org/find/descriptor/browse/1.B.2'
page9 <- read_html(url9)
cmtop9 <- html_nodes(page9, '#cmtop')

elements_li9 <- html_nodes(cmtop9, "li")
levels_li9 <- html_attr(elements_li9, "id") 
description9 <- html_text(html_nodes(elements_li9, "div[class*='cm-desc']"))
text_li9 <- html_text(elements_li9)
df9 <- data.frame(Text = text_li9, Descriptions = description9,Level = levels_li9)
df9$size_levels <- nchar(df9$Level)-14
df9$hierarchy <- ifelse(df9$size_levels == 1, 1,
                         ifelse(df9$size_levels == 3, 2, 3))
df9 <- df9[, c(1,2, ncol(df9))]
df9$major_skill <- "Work Values"


df9$Text <- ifelse(df9$hierarchy %in% c(1),
                    sapply(strsplit(df9$Text, "\n  \n    \n    "), function(x) x[2]),
                    df9$Text)

df9$Text <- ifelse(df9$hierarchy %in% c(1,2),
                    sapply(strsplit(df9$Text, "\n"), function(x) x[1]))


df_appended <- rbind(df, df2,df3, df4, df5, df6,df7,df8,df9)
View(df_appended)


# Pivot and fill in the right categories
df10 <- df_appended[, c(1,3)]
pivoted_df <- df10 %>%
  mutate(index = row_number()) %>%
  pivot_wider(names_from = hierarchy, values_from = Text)


# Concatenate the data frames horizontally (column-wise)
pivoted_df <- bind_cols(df_appended, pivoted_df)

pivoted_df$`1` <- zoo::na.locf(pivoted_df$`1`)
pivoted_df<- pivoted_df %>%
  group_by_at("1") %>%
  tidyr::fill(., `2`)


pivoted_df <- rename(pivoted_df, hierarchy_1= `1`,hierarchy_2= `2`,hierarchy_3= `3`)
pivoted_df<-pivoted_df[, -c(5)]


write.csv(pivoted_df, file = "hierarchy_tree.csv", row.names = FALSE)


csv_files <- c("abilities.csv", "hierarchy_tree.csv", "basic_skills.csv",
               "interests.csv", "knowledge.csv", "work_activities.csv",
               "work_context.csv", "work_styles.csv", "work_values.csv")

wb <- createWorkbook()

for (csv_file in csv_files) {
  data <- read.csv(csv_file)
  nome_pagina <- gsub(".csv", "", csv_file)
  
  addWorksheet(wb, sheetName = nome_pagina)
  writeData(wb, sheet = nome_pagina, x = data)
}

saveWorkbook(wb, "data.xlsx")

