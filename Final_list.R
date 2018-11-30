pacman::p_load("ggplot2","knitr","arm","foreign","eply", "noquote", "car", "textclean", "Cairo","data.table","readxl","dplyr","tidyverse","kableExtra","maps","plotly","esquisse","gridExtra","viridis", "stringr", "summarytools", "readr", "rvest", "writexl", "readxl", update=FALSE)

# look at the list
# what is the frequency of appearance for each of the movies?
# is it common for any single movie to be mentioned more than once?
# if not, what do i do?

# import file and set variables as factors
setwd("~/Documents/Maysa_Documents/3_learn/BU_MSSP/MA678_Modeling/Midterm_Project/source_data/cults")

cult <- read_excel("Cult_lists_for_me.xlsx")
cult <- cult[,c(1:4)]
names(cult) <- c("movie", "source", "type", "url")

# examine the initial results
#View(cult)
str(cult)
length(cult$movie) #1,078 rows
length(unique(cult$movie)) #808 unique movies
length(cult$movie) / length(unique(cult$movie)) # on average, each movie mentioned 1.3 times 
hist(table(cult$movie))

# as we can see, there are nearly 100 movies mentioned 2 times
# and then we have a handful mentioned 3-8 times as cults
# it's unlikely that there are 800 cult hits in the history of cinema
# cults are supposed to be really special 
# so i would recommend going with the movies mentioned 2+ times
# i can always change this decision later on but i don't think i should... :-)

# add a "mentions" column
# this captures the number of times the movie was mentioned in the sites i sourced
counts <- as.data.frame(table(cult$movie))
#View(counts)
names(counts) <- c("movie", "mentions")
#View(counts)
cult <- left_join(cult, counts, by = c("movie"))
#View(cult)

# pull out only movies with 2+ mentions
# want to create a new dataframe of only movies where mention >= 2
final_cult <- cult[cult$mentions>=2,]
#View(final_cult)

# now, remove duplicate rows
final_cult <- as.tibble(final_cult)
final_cult2 <- final_cult %>% distinct(movie, .keep_all = TRUE)

# now, compare the distinct version to the original
# should have the exact same number of unique movies!
length(unique(final_cult$movie)) == length(unique(final_cult2$movie))

# maybe we don't factor the original so that we don't have 808 levels?
str(final_cult2)
summary(final_cult2)
final_cult2$movie <- as.factor(final_cult2$movie)
plot(final_cult2$movie, final_cult2$mentions)

cults <- final_cult2

# brief exploration
#View(cults)

write_csv(cults, "cults.csv")
