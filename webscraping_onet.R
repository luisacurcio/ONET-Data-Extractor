library(httr)
library(rvest)
library(purrr)
library(stringr)
library(tidyverse)
library(httr)
library(zoo)

setwd("~/Trabalho/ENADE/dados_onet")

###############################################################################
############################### Abilities #####################################
###############################################################################
#fazer a requisição para acessar a página com expand all
url <- 'https://www.onetonline.org/find/descriptor/browse/1.A/1.A.1/1.A.1.g/1.A.1.b/1.A.1.d/1.A.1.e/1.A.1.c/1.A.1.f/1.A.1.a/1.A.3/1.A.3.b/1.A.3.c/1.A.3.a/1.A.2/1.A.2.b/1.A.2.a/1.A.2.c/1.A.4/1.A.4.b/1.A.4.a'
page <- read_html(url)

# extrair a div com id "cmtop": só a divisão que tem os links para os csv's
cmtop <- html_nodes(page, '#cmtop')
cat(as.character(cmtop))


# Extrair todos os links com tag "a" da div com id "cmtop"
# A Tag "a" define uma âncora: uma referência ou um link que leva 
# o usuário a uma determinada seção ou trecho específico de uma página web
links <- html_nodes(cmtop, "a")

# Extrair apenas os links sem classe (para simplificar o código pq a classe já 
# vem indicada no csv)
links_sem_classe <- links[is.na(html_attr(links, "class"))]

# Extrair os atributos href dos links
# O atributo href define o endereço direcionado quando clicar no link
# Cada href define o complemento do site original (tudo que vem depois de .org)
# E leva na página que queremos abrir (cada uma das subclassificações)
hrefs <- html_attr(links_sem_classe, "href")

# Imprimir as urls
print(hrefs)

# Cria uma losta vazia pra guardar os csvs
csv_list <- list()

for (link in hrefs) {
  # Fazer a requisição para o link
  response <- GET(paste0("https://www.onetonline.org", link))
  
  # Obter o conteúdo da resposta como texto
  html <- read_html(content(response, "text"))
  
  temp_links <- html_nodes(html, "a")
  temp_hrefs <- html_attr(temp_links, "href")
  csv_list <- append(csv_list, temp_hrefs[grep(".csv", temp_hrefs)])
  
}


# Pegar dados dos csvs 
dados_acumulados <- data.frame()

for (caminho_csv in csv_list) {
  # Ler o arquivo CSV
  dados <- read.csv(paste0("https://www.onetonline.org",caminho_csv))
  
  # Realizar as operações no dataframe 'dados'
  dados <- dados[, c(1, 4, 5)]
  hierarquia <- sub(".*/(.*)\\.csv.*", "\\1", caminho_csv)
  dados <- dados %>% mutate(hierarquia = hierarquia)
  
  # Append dos dados ao dataframe acumulado
  dados_acumulados <- rbind(dados_acumulados, dados)
}

write.csv(dados_acumulados, file = "abilities.csv", row.names = FALSE)



###############################################################################
############################### Interests #####################################
###############################################################################

url <- 'https://www.onetonline.org/find/descriptor/browse/1.B.1'
page <- read_html(url)


cmtop <- html_nodes(page, '#cmtop')
cat(as.character(cmtop))
links <- html_nodes(cmtop, "a")
links_sem_classe <- links[is.na(html_attr(links, "class"))]
hrefs <- html_attr(links_sem_classe, "href")
hrefs <- tail(hrefs, -1)  # Desconsiderar a primeira observação
csv_list <- list()

for (link in hrefs) {
  response <- GET(paste0("https://www.onetonline.org", link))
  html <- read_html(content(response, as = "text"))  
  temp_links <- html_nodes(html, "a")
  temp_hrefs <- html_attr(temp_links, "href")
  csv_list <- append(csv_list, temp_hrefs[grep(".csv", temp_hrefs)])
  
}

dados_acumulados <- data.frame()

#caminho_csv <- "https://www.onetonline.org/explore/interests/Social/Social.csv?fmt=csv"
#dados <- read.csv(caminho_csv)

for (caminho_csv in csv_list) {
  dados <- read.csv(paste0("https://www.onetonline.org",caminho_csv))
  dados <- dados[, c(1, 3, 4)]
  hierarquia <- sub(".*/(.*)\\.csv.*", "\\1", caminho_csv)
  dados <- dados %>% mutate(hierarquia = hierarquia)
  dados_acumulados <- rbind(dados_acumulados, dados)
}

write.csv(dados_acumulados, file = "interests.csv", row.names = FALSE)


###############################################################################
############################### Knowledge #####################################
###############################################################################

url <- 'https://www.onetonline.org/find/descriptor/browse/2.C/2.C.7/2.C.1/2.C.9/2.C.3/2.C.5/2.C.8/2.C.2/2.C.4'
page <- read_html(url)


cmtop <- html_nodes(page, '#cmtop')
links <- html_nodes(cmtop, "a")
links_sem_classe <- links[is.na(html_attr(links, "class"))]
hrefs <- html_attr(links_sem_classe, "href")
csv_list <- list()

for (link in hrefs) {
  response <- GET(paste0("https://www.onetonline.org", link))
  html <- read_html(content(response, as = "text"))  
  temp_links <- html_nodes(html, "a")
  temp_hrefs <- html_attr(temp_links, "href")
  csv_list <- append(csv_list, temp_hrefs[grep(".csv", temp_hrefs)])
  
}

dados_acumulados <- data.frame()

#caminho_csv <- "https://www.onetonline.org/find/descriptor/result/2.C.10/Transportation.csv?fmt=csv"
#dados <- read.csv(caminho_csv)


for (caminho_csv in csv_list) {
  dados <- read.csv(paste0("https://www.onetonline.org",caminho_csv))
  dados <- dados[, c(1, 4, 5)]
  hierarquia <- sub(".*/(.*)\\.csv.*", "\\1", caminho_csv)
  dados <- dados %>% mutate(hierarquia = hierarquia)
  dados_acumulados <- rbind(dados_acumulados, dados)
}

write.csv(dados_acumulados, file = "knowledge.csv", row.names = FALSE)


###############################################################################
############################### Basic Skills ##################################
###############################################################################

url <- 'https://www.onetonline.org/find/descriptor/browse/2.A/2.A.1/2.A.2'
page <- read_html(url)


cmtop <- html_nodes(page, '#cmtop')
links <- html_nodes(cmtop, "a")
links_sem_classe <- links[is.na(html_attr(links, "class"))]
hrefs <- html_attr(links_sem_classe, "href")
csv_list <- list()

for (link in hrefs) {
  response <- GET(paste0("https://www.onetonline.org", link))
  html <- read_html(content(response, as = "text"))  
  temp_links <- html_nodes(html, "a")
  temp_hrefs <- html_attr(temp_links, "href")
  csv_list <- append(csv_list, temp_hrefs[grep(".csv", temp_hrefs)])
  
}

dados_acumulados <- data.frame()


for (caminho_csv in csv_list) {
  dados <- read.csv(paste0("https://www.onetonline.org",caminho_csv))
  dados <- dados[, c(1, 4, 5)]
  hierarquia <- sub(".*/(.*)\\.csv.*", "\\1", caminho_csv)
  dados <- dados %>% mutate(hierarquia = hierarquia)
  dados_acumulados <- rbind(dados_acumulados, dados)
}

write.csv(dados_acumulados, file = "basic_skills.csv", row.names = FALSE)



###############################################################################
#################### Work Activities ##########################################
###############################################################################

url <- 'https://www.onetonline.org/find/descriptor/browse/4.A/4.A.1/4.A.1.b/4.A.1.a/4.A.4/4.A.4.c/4.A.4.a/4.A.4.b/4.A.2/4.A.2.a/4.A.2.b/4.A.3/4.A.3.b/4.A.3.a'
page <- read_html(url)


cmtop <- html_nodes(page, '#cmtop')
links <- html_nodes(cmtop, "a")
links_sem_classe <- links[is.na(html_attr(links, "class"))]
hrefs <- html_attr(links_sem_classe, "href")
csv_list <- list()

for (link in hrefs) {
  response <- GET(paste0("https://www.onetonline.org", link))
  html <- read_html(content(response, as = "text"))  
  temp_links <- html_nodes(html, "a")
  temp_hrefs <- html_attr(temp_links, "href")
  csv_list <- append(csv_list, temp_hrefs[grep(".csv", temp_hrefs)])
  
}

dados_acumulados <- data.frame()


for (caminho_csv in csv_list) {
  dados <- read.csv(paste0("https://www.onetonline.org",caminho_csv))
  dados <- dados[, c(1, 4, 5)]
  hierarquia <- sub(".*/(.*)\\.csv.*", "\\1", caminho_csv)
  dados <- dados %>% mutate(hierarquia = hierarquia)
  dados_acumulados <- rbind(dados_acumulados, dados)
}

write.csv(dados_acumulados, file = "work_activities.csv", row.names = FALSE)


###############################################################################
#################### Work Context #############################################
###############################################################################

url <- 'https://www.onetonline.org/find/descriptor/browse/4.C/4.C.1/4.C.1.a/4.C.1.a.2/4.C.1.d/4.C.1.c/4.C.1.b/4.C.1.b.1/4.C.2/4.C.2.d/4.C.2.d.1/4.C.2.b/4.C.2.b.1/4.C.2.c/4.C.2.c.1/4.C.2.e/4.C.2.e.1/4.C.2.a/4.C.2.a.1/4.C.3/4.C.3.c/4.C.3.a/4.C.3.a.2/4.C.3.d/4.C.3.b'
page <- read_html(url)


cmtop <- html_nodes(page, '#cmtop')
links <- html_nodes(cmtop, "a")
links_sem_classe <- links[is.na(html_attr(links, "class"))]
hrefs <- html_attr(links_sem_classe, "href")
csv_list <- list()

for (link in hrefs) {
  response <- GET(paste0("https://www.onetonline.org", link))
  html <- read_html(content(response, as = "text"))  
  temp_links <- html_nodes(html, "a")
  temp_hrefs <- html_attr(temp_links, "href")
  csv_list <- append(csv_list, temp_hrefs[grep(".csv", temp_hrefs)])
  
}

dados_acumulados <- data.frame()

#caminho_csv <- "https://www.onetonline.org/find/descriptor/result/4.C.1.a.2.h/Electronic_Mail.csv?fmt=csv"
#dados <- read.csv(caminho_csv)

for (caminho_csv in csv_list) {
  dados <- read.csv(paste0("https://www.onetonline.org",caminho_csv))
  dados <- dados[, c(1, 3, 4)]
  hierarquia <- sub(".*/(.*)\\.csv.*", "\\1", caminho_csv)
  dados <- dados %>% mutate(hierarquia = hierarquia)
  dados_acumulados <- rbind(dados_acumulados, dados)
}

write.csv(dados_acumulados, file = "work_context.csv", row.names = FALSE)


###############################################################################
#################### Work Styles ###############################################
###############################################################################

url <- 'https://www.onetonline.org/find/descriptor/browse/1.C/1.C.1/1.C.4/1.C.5/1.C.3/1.C.7/1.C.2'
page <- read_html(url)


cmtop <- html_nodes(page, '#cmtop')
links <- html_nodes(cmtop, "a")
links_sem_classe <- links[is.na(html_attr(links, "class"))]
hrefs <- html_attr(links_sem_classe, "href")
csv_list <- list()

for (link in hrefs) {
  response <- GET(paste0("https://www.onetonline.org", link))
  html <- read_html(content(response, as = "text"))  
  temp_links <- html_nodes(html, "a")
  temp_hrefs <- html_attr(temp_links, "href")
  csv_list <- append(csv_list, temp_hrefs[grep(".csv", temp_hrefs)])
  
}

dados_acumulados <- data.frame()

#caminho_csv <- "https://www.onetonline.org/find/descriptor/result/1.C.5.c/Integrity.csv?fmt=csv"
#dados <- read.csv(caminho_csv)

for (caminho_csv in csv_list) {
  dados <- read.csv(paste0("https://www.onetonline.org",caminho_csv))
  dados <- dados[, c(1, 3, 4)]
  hierarquia <- sub(".*/(.*)\\.csv.*", "\\1", caminho_csv)
  dados <- dados %>% mutate(hierarquia = hierarquia)
  dados_acumulados <- rbind(dados_acumulados, dados)
}

write.csv(dados_acumulados, file = "work_styles.csv", row.names = FALSE)


###############################################################################
#################### Work Values ##############################################
###############################################################################

url <- 'https://www.onetonline.org/find/descriptor/browse/1.B.2'
page <- read_html(url)


cmtop <- html_nodes(page, '#cmtop')
links <- html_nodes(cmtop, "a")
links_sem_classe <- links[is.na(html_attr(links, "class"))]
hrefs <- html_attr(links_sem_classe, "href")
csv_list <- list()

for (link in hrefs) {
  response <- GET(paste0("https://www.onetonline.org", link))
  html <- read_html(content(response, as = "text"))  
  temp_links <- html_nodes(html, "a")
  temp_hrefs <- html_attr(temp_links, "href")
  csv_list <- append(csv_list, temp_hrefs[grep(".csv", temp_hrefs)])
  csv_list <- gsub(" ", "_", csv_list)
}

dados_acumulados <- data.frame()

for (caminho_csv in csv_list) {
  dados <- read.csv(paste0("https://www.onetonline.org",caminho_csv))
  dados <- dados[, c(1, 3, 4)]
  hierarquia <- sub(".*/(.*)\\.csv.*", "\\1", caminho_csv)
  dados <- dados %>% mutate(hierarquia = hierarquia)
  dados_acumulados <- rbind(dados_acumulados, dados)
}

write.csv(dados_acumulados, file = "work_values.csv", row.names = FALSE)










##Nesta parte do código vou extrair os níveis de hierarquia

###############################################################################
############################### Abilities #####################################
###############################################################################

url <- 'https://www.onetonline.org/find/descriptor/browse/1.A/1.A.1/1.A.1.g/1.A.1.b/1.A.1.d/1.A.1.e/1.A.1.c/1.A.1.f/1.A.1.a/1.A.3/1.A.3.b/1.A.3.c/1.A.3.a/1.A.2/1.A.2.b/1.A.2.a/1.A.2.c/1.A.4/1.A.4.b/1.A.4.a'
page <- read_html(url)

cmtop <- html_nodes(page, '#cmtop')

# Extrair os elementos <li>
elementos_li <- html_nodes(cmtop, "li")

# Extrair o texto e o nível de hierarquia dos elementos <li>
niveis_li <- html_attr(elementos_li, "id")  # ou "id" ou outro atributo
descricoes <- html_text(html_nodes(elementos_li, "div[class*='cm-desc']"))
textos_li <- html_text(elementos_li)


# Criar o dataframe com duas colunas
df <- data.frame(Texto = textos_li, Descricoes= descricoes,Nivel = niveis_li)

# Nova coluna com tamanho dos níveis 
df$tamanho_niveis <- nchar(df$Nivel)-12

# Ajeitar níveis
df$hierarquia <- ifelse(df$tamanho_niveis == 1, 1,
                         ifelse(df$tamanho_niveis == 3, 2, 3))

df <- df[, c(1,2, ncol(df))]
df$major_skill <- "Abilities"
df$Texto <- gsub("\n  \n  Folder (closedopen)\n    ", "", df$Texto, fixed = TRUE)
df$Texto <- ifelse(df$hierarquia %in% c(1, 2) ,
                  sapply(strsplit(df$Texto, "\n"), function(x) x[1]),
                   df$Texto)

df$Texto <- ifelse(df$hierarquia %in% c(1, 2) ,
                   df$Texto,
                   sapply(strsplit(df$Texto, "\n  \n    \n    "), function(x) x[2]))

df$Texto <- ifelse(df$hierarquia %in% c(1, 2),
                   df$Texto,
                   sapply(strsplit(df$Texto, "\n"), function(x) x[1]))



###############################################################################
############################### Interests #####################################
###############################################################################

url2 <- 'https://www.onetonline.org/find/descriptor/browse/1.B.1'
page2 <- read_html(url2)
cmtop2 <- html_nodes(page2, '#cmtop')

elementos_li2 <- html_nodes(cmtop2, "li")
niveis_li2 <- html_attr(elementos_li2, "id")  
descricoes2 <- html_text(html_nodes(elementos_li2, "div[class*='cm-desc']"))
textos_li2 <- html_text(elementos_li2)
df2 <- data.frame(Texto = textos_li2, Descricoes= descricoes2,Nivel = niveis_li2)
df2$tamanho_niveis <- nchar(df2$Nivel)-14
df2$hierarquia <- df2$tamanho_niveis
df2 <- df2[, c(1,2, ncol(df2))]
df2$major_skill <- "Interests"
df2$Texto <- ifelse(df2$hierarquia %in% c(1) ,
                   sapply(strsplit(df2$Texto, "\n  \n    \n    "), function(x) x[2]),
                   df2$Texto)
df2$Texto <- ifelse(df2$hierarquia %in% c(1) ,
                   sapply(strsplit(df2$Texto, "\n"), function(x) x[1]),
                   df2$Texto)


###############################################################################
############################### Knowledge #####################################
###############################################################################

url3 <- 'https://www.onetonline.org/find/descriptor/browse/2.C/2.C.7/2.C.1/2.C.9/2.C.3/2.C.5/2.C.8/2.C.2/2.C.4'
page3 <- read_html(url3)
cmtop3 <- html_nodes(page3, '#cmtop')


elementos_li3 <- html_nodes(cmtop3, "li")
niveis_li3 <- html_attr(elementos_li3, "id")
descricoes3 <- html_text(html_nodes(elementos_li3, "div[class*='cm-desc']"))
textos_li3 <- html_text(elementos_li3)
df3 <- data.frame(Texto = textos_li3, Descricoes= descricoes3,Nivel = niveis_li3)
df3$tamanho_niveis <- nchar(df3$Nivel)-12
df3$hierarquia <- ifelse(df3$tamanho_niveis == 1, 1,
                        ifelse(df3$tamanho_niveis == 3, 2, 3))
df3 <- df3[, c(1,2, ncol(df3))]
df3$major_skill <- "Knowledge"
df3$Texto <- gsub("\n  \n  Folder (closedopen)\n    ", "", df3$Texto, fixed = TRUE)
df3$Texto <- ifelse(df3$hierarquia %in% c(1, 2) ,
                   sapply(strsplit(df3$Texto, "\n"), function(x) x[1]),
                   df3$Texto)
df3$Texto <- ifelse(df3$hierarquia %in% c(1, 2) ,
                   df3$Texto,
                   sapply(strsplit(df3$Texto, "\n  \n    \n    "), function(x) x[2]))

df3$Texto <- ifelse(df3$hierarquia %in% c(1, 2),
                   df3$Texto,
                   sapply(strsplit(df3$Texto, "\n"), function(x) x[1]))



###############################################################################
############################### Basic Skills ##################################
###############################################################################

url4 <- 'https://www.onetonline.org/find/descriptor/browse/2.A/2.A.1/2.A.2'
page4 <- read_html(url4)
cmtop4 <- html_nodes(page4, '#cmtop')

elementos_li4 <- html_nodes(cmtop4, "li")
niveis_li4 <- html_attr(elementos_li4, "id")  
descricoes4 <- html_text(html_nodes(elementos_li4, "div[class*='cm-desc']"))
textos_li4 <- html_text(elementos_li4)
df4 <- data.frame(Texto = textos_li4, Descricoes= descricoes4,Nivel = niveis_li4)
df4$tamanho_niveis <- nchar(df4$Nivel)-12
df4$hierarquia <- ifelse(df4$tamanho_niveis == 1, 1,
                         ifelse(df4$tamanho_niveis == 3, 2, 3))

df4 <- df4[, c(1,2, ncol(df4))]
df4$major_skill <- "Basic Skills"
df4$Texto <- gsub("\n  \n  Folder (closedopen)\n    ", "", df4$Texto, fixed = TRUE)
df4$Texto <- ifelse(df4$hierarquia %in% c(1) ,
                    sapply(strsplit(df4$Texto, "\n"), function(x) x[1]),
                    df4$Texto)

df4$Texto <- ifelse(df4$hierarquia %in% c(1) ,
                    df4$Texto,
                    sapply(strsplit(df4$Texto, "\n  \n    \n    "), function(x) x[2]))

df4$Texto <- ifelse(df4$hierarquia %in% c(1),
                    df4$Texto,
                    sapply(strsplit(df4$Texto, "\n"), function(x) x[1]))



###############################################################################
#################### Cross Functional Skills ##################################
###############################################################################

url5 <- 'https://www.onetonline.org/find/descriptor/browse/2.B/2.B.2/2.B.5/2.B.1/2.B.4/2.B.3'
page5 <- read_html(url5)
cmtop5 <- html_nodes(page5, '#cmtop')

elementos_li5 <- html_nodes(cmtop5, "li")
niveis_li5 <- html_attr(elementos_li5, "id") 
descricoes5 <- html_text(html_nodes(elementos_li5, "div[class*='cm-desc']"))
textos_li5 <- html_text(elementos_li5)
df5 <- data.frame(Texto = textos_li5, Descricoes= descricoes5,Nivel = niveis_li5)
df5$tamanho_niveis <- nchar(df5$Nivel)-12
df5$hierarquia <- ifelse(df5$tamanho_niveis == 1, 1,
                         ifelse(df5$tamanho_niveis == 3, 2, 3))
df5 <- df5[, c(1,2, ncol(df5))]
df5$major_skill <- "Cross Functional Skills"
df5$Texto <- gsub("\n  \n  Folder (closedopen)\n    ", "", df5$Texto, fixed = TRUE)

df5$Texto <- ifelse(df5$hierarquia %in% c(1) ,
                    sapply(strsplit(df5$Texto, "\n"), function(x) x[1]),
                    df5$Texto)

df5$Texto <- ifelse(df5$hierarquia %in% c(1) ,
                    df5$Texto,
                    sapply(strsplit(df5$Texto, "\n  \n    \n    "), function(x) x[2]))

df5$Texto <- ifelse(df5$hierarquia %in% c(1),
                    df5$Texto,
                    sapply(strsplit(df5$Texto, "\n"), function(x) x[1]))

###############################################################################
#################### Work Activities ##########################################
###############################################################################

url6 <- 'https://www.onetonline.org/find/descriptor/browse/4.A/4.A.1/4.A.1.b/4.A.1.a/4.A.4/4.A.4.c/4.A.4.a/4.A.4.b/4.A.2/4.A.2.a/4.A.2.b/4.A.3/4.A.3.b/4.A.3.a'
page6 <- read_html(url6)
cmtop6 <- html_nodes(page6, '#cmtop')

elementos_li6 <- html_nodes(cmtop6, "li")
niveis_li6 <- html_attr(elementos_li6, "id") 
descricoes6 <- html_text(html_nodes(elementos_li6, "div[class*='cm-desc']"))
textos_li6 <- html_text(elementos_li6)
df6 <- data.frame(Texto = textos_li6, Descricoes= descricoes6,Nivel = niveis_li6)
df6$tamanho_niveis <- nchar(df6$Nivel)-12
df6$hierarquia <- ifelse(df6$tamanho_niveis == 1, 1,
                         ifelse(df6$tamanho_niveis == 3, 2, 3))
df6 <- df6[, c(1,2, ncol(df6))]
df6$major_skill <- "Work Activities"
df6$Texto <- gsub("\n  \n  Folder (closedopen)\n    ", "", df6$Texto, fixed = TRUE)

df6$Texto <- ifelse(df6$hierarquia %in% c(1) ,
                    sapply(strsplit(df6$Texto, "\n"), function(x) x[1]),
                    df6$Texto)

df6$Texto <- ifelse(df6$hierarquia %in% c(1) ,
                    df6$Texto,
                    sapply(strsplit(df6$Texto, "\n  \n    \n    "), function(x) x[2]))

df6$Texto <- ifelse(df6$hierarquia %in% c(1),
                    df6$Texto,
                    sapply(strsplit(df6$Texto, "\n"), function(x) x[1]))



###############################################################################
#################### Work Context #############################################
###############################################################################

url7 <- 'https://www.onetonline.org/find/descriptor/browse/4.C/4.C.1/4.C.1.a/4.C.1.a.2/4.C.1.d/4.C.1.c/4.C.1.b/4.C.1.b.1/4.C.2/4.C.2.d/4.C.2.d.1/4.C.2.b/4.C.2.b.1/4.C.2.c/4.C.2.c.1/4.C.2.e/4.C.2.e.1/4.C.2.a/4.C.2.a.1/4.C.3/4.C.3.c/4.C.3.a/4.C.3.a.2/4.C.3.d/4.C.3.b'
page7 <- read_html(url7)
cmtop7 <- html_nodes(page7, '#cmtop')

elementos_li7 <- html_nodes(cmtop7, "li")
niveis_li7 <- html_attr(elementos_li7, "id") 
descricoes7 <- html_text(html_nodes(elementos_li7, "div[class*='cm-desc']"))
textos_li7 <- html_text(elementos_li7)
df7 <- data.frame(Texto = textos_li7, Descricoes= descricoes7,Nivel = niveis_li7)
df7$tamanho_niveis <- nchar(df7$Nivel)-12
df7$hierarquia <- ifelse(df7$tamanho_niveis == 1, 1,
                         ifelse(df7$tamanho_niveis == 3, 2, 3))
df7 <- df7[, c(1,2, ncol(df7))]
df7$major_skill <- "Work Activities"
df7$Texto <- gsub("\n  \n  Folder (closedopen)\n    ", "", df7$Texto, fixed = TRUE)

df7$Texto <- ifelse(df7$hierarquia %in% c(1) ,
                    sapply(strsplit(df7$Texto, "\n"), function(x) x[1]),
                    df7$Texto)

df7$Texto <- ifelse(df7$hierarquia %in% c(1) ,
                    df7$Texto,
                    sapply(strsplit(df7$Texto, "\n  \n    \n    "), function(x) x[2]))

df7$Texto <- ifelse(df7$hierarquia %in% c(1),
                    df7$Texto,
                    sapply(strsplit(df7$Texto, "\n"), function(x) x[1]))


###############################################################################
#################### Work Styles ###############################################
###############################################################################

url8 <- 'https://www.onetonline.org/find/descriptor/browse/1.C/1.C.1/1.C.4/1.C.5/1.C.3/1.C.7/1.C.2'
page8 <- read_html(url8)
cmtop8 <- html_nodes(page8, '#cmtop')

elementos_li8 <- html_nodes(cmtop8, "li")
niveis_li8 <- html_attr(elementos_li8, "id") 
descricoes8 <- html_text(html_nodes(elementos_li8, "div[class*='cm-desc']"))
textos_li8 <- html_text(elementos_li8)
df8 <- data.frame(Texto = textos_li8, Descricoes= descricoes8,Nivel = niveis_li8)
df8$tamanho_niveis <- nchar(df8$Nivel)-12
df8$hierarquia <- ifelse(df8$tamanho_niveis == 1, 1,
                         ifelse(df8$tamanho_niveis == 3, 2, 3))
df8 <- df8[, c(1,2, ncol(df8))]
df8$major_skill <- "Work Styles"
df8$Texto <- gsub("\n  \n  Folder (closedopen)\n    ", "", df8$Texto, fixed = TRUE)

df8$Texto <- ifelse(df8$hierarquia %in% c(1) ,
                    df8$Texto,
                    sapply(strsplit(df8$Texto, "\n  \n    \n    "), function(x) x[2]))

df8$Texto <- ifelse(df8$hierarquia %in% c(1) & grepl("Independence", df8$Texto),
                    sapply(strsplit(df8$Texto, "\n  \n    \n    "), function(x) x[2]),
                    df8$Texto)

df8$Texto <- ifelse(df8$hierarquia %in% c(1,2),
                    sapply(strsplit(df8$Texto, "\n"), function(x) x[1]))



###############################################################################
#################### Work Values ##############################################
###############################################################################

url9 <- 'https://www.onetonline.org/find/descriptor/browse/1.B.2'
page9 <- read_html(url9)
cmtop9 <- html_nodes(page9, '#cmtop')

elementos_li9 <- html_nodes(cmtop9, "li")
niveis_li9 <- html_attr(elementos_li9, "id") 
descricoes9 <- html_text(html_nodes(elementos_li9, "div[class*='cm-desc']"))
textos_li9 <- html_text(elementos_li9)
df9 <- data.frame(Texto = textos_li9, Descricoes= descricoes9,Nivel = niveis_li9)
df9$tamanho_niveis <- nchar(df9$Nivel)-14
df9$hierarquia <- ifelse(df9$tamanho_niveis == 1, 1,
                         ifelse(df9$tamanho_niveis == 3, 2, 3))
df9 <- df9[, c(1,2, ncol(df9))]
df9$major_skill <- "Work Values"


df9$Texto <- ifelse(df9$hierarquia %in% c(1),
                    sapply(strsplit(df9$Texto, "\n  \n    \n    "), function(x) x[2]),
                    df9$Texto)

df9$Texto <- ifelse(df9$hierarquia %in% c(1,2),
                    sapply(strsplit(df9$Texto, "\n"), function(x) x[1]))


df_appended <- rbind(df, df2,df3, df4, df5, df6,df7,df8,df9)
View(df_appended)


# pivotar e preencher com as categorias corretas
df10 <- df_appended[, c(1,3)]
pivoted_df <- df10 %>%
  mutate(index = row_number()) %>%
  pivot_wider(names_from = hierarquia, values_from = Texto)


# Concatenate the data frames horizontally (column-wise)
pivoted_df <- bind_cols(df_appended, pivoted_df)

pivoted_df$`1` <- zoo::na.locf(pivoted_df$`1`)
pivoted_df<- pivoted_df %>%
  group_by_at("1") %>%
  tidyr::fill(., `2`)


pivoted_df <- rename(pivoted_df, hierarquia_1= `1`,hierarquia_2= `2`,hierarquia_3= `3`)
pivoted_df<-pivoted_df[, -c(5)]


write.csv(pivoted_df, file = "arvore_hierarquica.csv", row.names = FALSE)


install.packages("openxlsx")

# Carregue o pacote openxlsx
library(openxlsx)

csv_files <- c("abilities.csv", "arvore_hierarquica.csv", "basic_skills.csv",
               "interests.csv", "knowledge.csv", "work_activities.csv",
               "work_context.csv", "work_styles.csv", "work_values.csv")

wb <- createWorkbook()

for (csv_file in csv_files) {
  dados <- read.csv(csv_file)
  nome_pagina <- gsub(".csv", "", csv_file)
  
  addWorksheet(wb, sheetName = nome_pagina)
  writeData(wb, sheet = nome_pagina, x = dados)
}

saveWorkbook(wb, "dados.xlsx")













