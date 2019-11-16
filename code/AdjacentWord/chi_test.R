rm(list=ls())
setwd("~/Desktop/M3")
flavour = read.csv("pos_neg_flavour.csv", header = T)
price = read.csv("pos_neg_price.csv", header = T)
service = read.csv("pos_neg_service.csv", header = T)
wordcount = rbind(flavour,price,service)
bus = read.csv('business_pos_neg.csv', header = T)

chiTestBus = function(word, busid){
  t1 = as.matrix(bus[bus$word==word&bus$business_id==busid,c(2,3)])
  t2 = as.matrix(wordcount[wordcount$word==word,c(2,3)])
  re = chisq.test(rbind(t1,t2))
  return (re$p.value)
}
chiTestBus('taste','irft4YkdNsww4DNf_Aftew')

chiTestState = function(word,state){
  t1 = t(as.matrix(colSums(bus[bus$state==state&bus$word==word,c(2,3)])))
  t2 = as.matrix(wordcount[wordcount$word==word,c(2,3)])
  re = chisq.test(rbind(t1,t2))
  return (re$p.value)
}
chiTestState('taste','NC')

fisherTestBus = function(word, busid){
  t1 = as.matrix(bus[bus$word==word&bus$business_id==busid,c(2,3)])
  t2 = as.matrix(wordcount[wordcount$word==word,c(2,3)])
  re = fisher.test(rbind(t1,t2))
  return (re$p.value)
}
fisherTestBus('taste','irft4YkdNsww4DNf_Aftew')

fisherTestState = function(word,state){
  t1 = t(as.matrix(colSums(bus[bus$state==state&bus$word==word,c(2,3)])))
  t2 = as.matrix(wordcount[flavour$word==word,c(2,3)])
  re = fisher.test(rbind(t1,t2))
  return (re$p.value)
}
fisherTestState('taste','NC')


sub.bus = bus[bus$review_num>50,] 
states = unique(bus$state)
wordlist = unique(wordcount$word)
busID = unique(sub.bus$business_id)

words = c()
for (word in wordlist){
  words = c(words,word)
}
busid = c()
for (id in busID){
  busid = c(busid,id)
}

wordCountPvalue = function(){
  result = c()
  col.names = c()
  for (id in busid){
    p.values = c()
    for (word in wordlist){
      p = chiTestBus(word, id)
      p.values = c(p.values, p)
    }
    col.names = c(col.names, id)
    result = cbind(result,p.values)
  }
  return (list(result, col.names))
}
re = wordCountPvalue()
pValueDf = data.frame(word = words,
                      pvalues = re[[1]])
names(pValueDf) <- c('Word',re[[2]])
write.csv(pValueDf, "wordBusPvalue.csv", row.names=FALSE)
wordp = read.csv('wordBusPvalue.csv')

suggestOrNot = function(){
  p.result = re[[1]]
  suggestion = c()
  for (id in busid){
    p.value.id = p.result[,which(busid==id)]
    sub.word = words[which(p.value.id < 0.05)]
    word = sub.word[1]
    use.word = c()
    for (word in sub.word){
      t1 = bus[bus$word==word&bus$business_id==id,c(2,3)]
      t2 = wordcount[wordcount$word==word,c(2,3)]
      if(t1$pos_num/t1$neg_num < t2$pos_num/t2$neg_num)
        use.word = c(use.word,word)
    }
    norm.suggest = rep(FALSE,33)
    norm.suggest[which(words %in% use.word)]=TRUE
    suggestion = cbind(suggestion,norm.suggest)
  }
  rownames(suggestion) = wordlist
  colnames(suggestion) = busid
  return (suggestion)
}
sug = suggestOrNot()
write.csv(sug, "suggestOrNot.csv")


