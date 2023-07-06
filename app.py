import gradio as gr
from GoogleNews import GoogleNews
import pandas as pd
import nltk
from nltk.sentiment.vader import SentimentIntensityAnalyzer
nltk.download('vader_lexicon')
nltk.download('punkt')
from newspaper import Article
import datetime as dt


googlenews = GoogleNews()

# Perform sentiment analysis on the headlines using NLTK's VADER
sia = SentimentIntensityAnalyzer()

# Define a function to calculate the sentiment scores for a given text
def get_sentiment_scores(text):
    return sia.polarity_scores(text)

def get_sentiment(sentiment_scores):
    compound_score = sentiment_scores['compound']
    if compound_score >= 0.05:
        return 'positive'
    elif compound_score <= -0.05:
        return 'negative'
    else:
        return 'neutral'

def convertToNews(df1):
    list1=[]
    for ind in df1.index:
        try:
            dict1={}
            article = Article(df1['link'][ind])
            article.download()
            article.parse()
            article.nlp()
            dict1['Date']=df1['date'][ind]
            dict1['Link'] = df1['link'][ind]
            dict1['Media']=df1['media'][ind]
            dict1['Title']=article.title
            dict1['Article']=article.text
            dict1['Summary']=article.summary

            list1.append(dict1)
        except:
            print('error occurred')
    news_df=pd.DataFrame(list1)
    return news_df

def getSentiment(keyword):
    googlenews.clear()
# Set Current Date and Yesterday's Date
    now = dt.date.today()
    now = now.strftime('%m-%d-%Y')
    yesterday = dt.date.today() - dt.timedelta(days = 1)
    yesterday = yesterday.strftime('%m-%d-%Y')

    googlenews.set_time_range(yesterday, now)

    keyword1 = keyword
    googlenews.search(keyword1)
    results = googlenews.results()
    df=pd.DataFrame(results)

    for i in range(2,4):
        googlenews.getpage(i)
        result=googlenews.result()
        df=pd.DataFrame(result)

    news = convertToNews(df)

    # Apply the sentiment analyzer to the article column and store the scores in a new column
    news['sentiment_scores'] = news['Summary'].apply(get_sentiment_scores)

    # Apply the get_sentiment function to the sentiment_scores column and store the results in a new column
    news['sentiment'] = news['sentiment_scores'].apply(get_sentiment)

    # Get the value with the highest count
    max_value = news['sentiment'].value_counts().idxmax()

    counts = list(news['sentiment'].value_counts())

    news['compound'] = news['sentiment_scores'].apply(lambda x: x['compound'])
    news['compound_abs'] = news['compound'].abs()
    toppers = news.sort_values(by='compound_abs', ascending=False)
    title_list = list(news.Title.head(3))
    summary_list = list(news.Summary.head(3))
    positive_count = news[news['sentiment']=='positive'].shape[0]
    neutral_count = news[news['sentiment']=='neutral'].shape[0]
    negative_count = news[news['sentiment']=='negative'].shape[0]

    # Print the value with the highest count
    return max_value.title(), title_list[0], title_list[1], title_list[2], summary_list[0], summary_list[1], summary_list[2], positive_count, neutral_count, negative_count


iface = gr.Interface(fn=getSentiment, inputs="text", outputs=["text","text", "text", "text","text", "text", "text", "number", "number", "number"], theme=gr.themes.Soft())
iface.launch()