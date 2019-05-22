library(dplyr)

#read the data from the raw_data file

log <- read.table("clipboard", sep="\t", header=T)
log$date <- as.Date(log$date, format = "%m/%d/%Y")

testdf <- data.frame(seq(min(log$date), max(log$date), by = "days"))
names(testdf) <- c("date")
test_join2 <- testdf

for(j in 1:length(unique(log$game))){
  
  game_subset <- subset(log, subset=(log$game == unique(log$game)[j]))
  test_join <- left_join(testdf, game_subset, by='date')
  
  for(i in 1:nrow(test_join)){
    if(!is.na(test_join[i,2]) && i==1){
      test_join[i,3] = 1
    }else if(is.na(test_join[i,2]) && i==1){
      test_join[i,3] = 0
    }else if(!is.na(test_join[i,2]) && i > 1){
      test_join[i,3] <- (test_join[i-1, 3]) + 1 #interest addition
    }else{
      test_join[i,3] <- (test_join[i-1, 3]) * 0.95 #decay
    }
  }
  result_join <- data.frame(test_join$date, test_join$V3)
  names(result_join) <- c("date", as.character(unique(log$game)[j]))
  test_join2 <- left_join(test_join2, result_join, by='date')
}

#write.table(test_join2, "clipboard", sep="\t", row.names = F, quote = F)


####
#### looking at the slopes
####

game_freq <- data.frame(table(log$game))

final <- data.frame(matrix(0, ncol=4))
colnames(final) <- c("game", "interest", "days on radar", "days of interest")

for(k in 2:ncol(test_join2)){
  
  model <- data.frame(test_join2$date, test_join2[,k])
  model_subset <- subset(model, subset=(model[,2] > 0))
  coef <- (lm(model_subset$test_join2...k. ~ model_subset$test_join2.date))$coefficients[2]
  
  days_of_interest <- subset(game_freq, subset=(Var1 == colnames(test_join2)[k]))[2]
  
  final_1 <- data.frame(colnames(test_join2)[k], coef, nrow(model_subset), days_of_interest)
  colnames(final_1) <- c("game", "interest", "days on radar", "days of interest")
  
  final <- rbind(final, final_1)
}

###
### current interest level join
###

current_interest <- as.data.frame(t(subset(test_join2, date==Sys.Date())))
current_interest$game <- row.names(current_interest) 

final_join <- left_join(final, current_interest, by="game")

#write.table(model_subset, "clipboard", quote = F, row.names = F, sep="\t")
