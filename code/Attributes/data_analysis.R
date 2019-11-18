data = read.csv('~/Documents/Python_Scripts/Stat628_Module3/csv/total_count.csv')

library(wordcloud2)


data$X = NULL
wordcloud2(data,size = 0.5,shape = 'circle',color = 'random-dark')

data[data$word == 'cashier',]
data$word


####  data description

data = read.csv('~/Documents/Python_Scripts/Stat628_Module3/csv/word_count_label.csv')

###  flavor vs stars
# Chocolate, strawberry, vanilla, mango, caramel, banana, coconut, raspberry
chocolate = data[data$chocolate == 1,]
chocolate = table(chocolate$stars)

strawberry = data[data$strawberry == 1,]
strawberry = table(strawberry$stars)

vanilla = data[data$vanilla == 1,]
vanilla = table(vanilla$stars)

mango = data[data$mango == 1,]
mango = table(mango$stars)

caramel = data[data$caramel == 1,]
caramel = table(caramel$stars)

banana = data[data$banana == 1,]
banana = table(banana$stars)

coconut = data[data$coconut == 1,]
coconut = table(coconut$stars)

raspberry = data[data$raspberry == 1,]
raspberry = table(raspberry$stars)

flavor_stars = rbind(chocolate,strawberry, vanilla, mango, caramel, banana, coconut, raspberry)

###  flavor vs stars
# Chocolate, strawberry, vanilla, mango, caramel, banana, coconut, raspberry
chocolate = data[data$chocolate == 1,]
chocolate = table(chocolate$state)

strawberry = data[data$strawberry == 1,]
strawberry = table(strawberry$state)

vanilla = data[data$vanilla == 1,]
vanilla = table(vanilla$state)

mango = data[data$mango == 1,]
mango = table(mango$state)

caramel = data[data$caramel == 1,]
caramel = table(caramel$state)

banana = data[data$banana == 1,]
banana = table(banana$state)

coconut = data[data$coconut == 1,]
coconut = table(coconut$state)

raspberry = data[data$raspberry == 1,]
raspberry = table(raspberry$state)

flavor_state = rbind(chocolate,strawberry, vanilla, mango, caramel, banana, coconut, raspberry)


## states vs stars
# AB AZ BAS IL NC NV OH ON PA QC SC WI
library(dplyr)
long = data %>% group_by(state,stars) %>% summarise(count = n())

library(reshape2)
state_stars = dcast(long, state ~ stars, value.var="count")




### test
library(MASS)
friedman.test(flavor_stars)
chisq.test(flavor_stars)

friedman.test(flavor_state)
a = chisq.test(flavor_state)
a
a$expected

rownames(state_stars) = state_stars[,1]
state_stars = state_stars[,-1]
friedman.test(as.matrix(state_stars))
chisq.test(as.matrix(state_stars[-3,]))

## generalized linear regression
library(MASS)
att = read.csv('~/Documents/Python_Scripts/Stat628_Module3/csv/final_att.csv')
att$WiFi[att$WiFi == ''] = 'no'
att$stars = as.factor(att$stars)
apply(att == '',2,sum)
att = att[att$BusinessAcceptsCreditCards != '',]
att = att[is.na(att$RestaurantsPriceRange2) == FALSE,]
att = att[att$RestaurantsTakeOut != '',]
att = att[att$BikeParking != '',]
att = att[att$BusinessParking != '',]

apply(is.na(att),2,sum)


# att$Morn = 0
# att$Morn[att$Morning == 'True'] = 1
# att$Aft = 0
# att$Aft[att$Afternoon== 'True'] = 1
# att$Even = 0
# att$ven[att$Evening == 'True'] = 1


plr=polr(stars ~ .-business_id-stars-review_count ,   data=att, Hess = TRUE)
summary(plr)

predict(plr)


library(dplyr)
# predictors = select(att,-c(business_id, stars, review_count))
predictors = model.matrix(plr)
colnames(predictors)
coe = coef(plr)
predictors = select(as.data.frame(predictors),names(coef(plr)))

predict = as.matrix(predictors)%*%coe
bar = plr$zeta
#predict = exp(predict)/(1 + exp(predict))

#bar = exp(plr$zeta)/(1 + exp(plr$zeta))
plot(sort(predict))
pre = as.data.frame(sort(predict))
pre = unique(pre$`sort(predict)`)
latent_score = as.data.frame(pre)
latent_score$observations = 1:140
colnames(latent_score) = c('latent_score','observations')
library(ggplot2)
ggplot(latent_score, aes(x=observations, y=latent_score)) + geom_point(cex = 2) + 
  geom_hline(yintercept=bar[4:8], linetype=c("dashed"), color = "navyblue", size=1.5) + 
  annotate("text", x = 5, y = bar[4:8] + 0.2, label = paste(seq(3,5,0.5)),size = 7) + 
  theme(axis.text.x = element_text(size = 20), axis.text.y = element_text(size = 20))+
  theme(axis.title.y = element_text(size = rel(1.8), angle = 90))+
  theme(axis.title.x = element_text(size = rel(1.8), angle = 00)) + 
  labs(title = 'Predicted Rating',size = 5) + 
  theme(plot.title = element_text(hjust = 0.5,size = 28))
  


data  = read.csv('~/Documents/Python_Scripts/Stat628_Module3/csv/ice_shop.csv')
library(dplyr)
grouped = group_by(data,name, address) %>% summarise(count = n()) 
grouped[grouped$count != 1,]

check = data[data$name == 'Dairy Queen' & data$city == 'Gilbert' & data$address == '1696 N Higley Rd',]
