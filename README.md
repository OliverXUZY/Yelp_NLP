# Yelp_NLP
This is the final project of Data science project course STAT628 in 2019 fall intructed by Prof. Hyunseung Kang. The institute is UW-Madison.

## Introduction
“Yelp connects people with great local businesses.” It is of great convenience for people to obtain information from the YELP app as well as share their own experience. An increasing number of business owners begin to use Yelp as an efficient feedback mechanism to achieve greater success.

In this project, we mainly focus on the businesses whose categories contain ice-cream. The optimal goal for this project is to give some specific advice to those ice-cream business owners.

## Methodology
- **Score prediction based on recurrent neural network:** Since the overall rating for a certain business is hard to make interpretation, we tried to predict some scores from three perspective: flavor, price, service&environment. Consider the scores is calculated from user's rating, we try to predict the scores in different aspects based on user's review. Under this situation, the Recurrent Neural Netword especially the LSTM(Long Short-Term Memory) has a well-known performance in text analysis, which drives us to employ this methods as part of our model.
- **Ordered Logit Model:** Under the hypothesis that attributes of business may contributes to their ratings, we tried make some analysis between the properties of a business and its rating. Since the properties about the business are mostly categorical variables especially boolean variables. We thought that the ordered logit model is an idealt one to make such analysis.

## Conclusion
We achieved our ultimate goal of making recommendations to the business owner in two aspects.
- We proposed several hypotheses on business and validated them.
- We made general recommendations to all business owners like: provide chocolate flavor, ensure opening hours contain afternoon, provide free WiFi, and provide parking lots.
- We also made recommendations to certain business owners regard specific aspect **food**, **price**, **service and environment** based on predicted ratings.

We came up with two models, **Ordered Logit Model** and **Recurrent Neural Network**. 
- The **Ordered Logit Model** had nice interpretation on all business owners. 
- The **Recurrent Neural Network** had reasonable accuracy while lacking interpretations. We can make recommendations based on new predictions.

## Contributor
- Yue Wu (ywu494@wisc.edu) implemented the NLP preprocessing. She also conducted preprocessing on the business json file. She conducted the word counting and statistical tests based on text. 
- Chenghui Li(cli539@wisc.edu) came up the shiny app part. He developed fansy and user-friendly user interface.
- Zhuoyan Xu(zxu444@wisc.edu) applied the main models: order logit model and upgraded RNN.

## Acknowledgement
We are glad to acknowledge Prof. Hyunseung Kang and Mr.Yu Peng, without whose instruction we will not be able to establish and finish this project.

## Reference
- Minqing Hu and Bing Liu. "Mining and Summarizing Customer Reviews." Proceedings of the ACM SIGKDD International Conference on Knowledge Discovery and Data Mining (KDD-2004), Aug 22-25, 2004, Seattle, Washington, USA.
- Bing Liu, Minqing Hu and Junsheng Cheng. "Opinion Observer: Analyzing and Comparing Opinions on the Web." Proceedings of the 14th International World Wide Web conference (WWW-2005), May 10-14, 2005, Chiba, Japan.
- [Pytorch implementation](https://github.com/bentrevett/pytorch-sentiment-analysis)
