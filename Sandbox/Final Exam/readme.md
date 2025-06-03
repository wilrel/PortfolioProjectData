# Employee Sentiment Analysis Project

## Project Overview
This project aims to analyze an internal dataset of employee messages to gain insights into sentiment, engagement, and potential risks. By leveraging Natural Language Processing (NLP) and statistical analysis techniques, this project transforms raw, unlabeled data into actionable insights for management and HR.

## Methodology
The analysis was conducted in six main stages:

1.  Sentiment Labeling: Each message was analyzed and labeled as 'Positive', 'Negative', or 'Neutral' using the NLTK library with its VADER model, which is effective for analyzing short, informal text.

2.  Exploratory Data Analysis (EDA): Visualizations were created to understand the overall sentiment distribution, communication volume over time, and the most common keywords associated with positive and negative sentiments via word clouds.

3.  Monthly Sentiment Scoring: Qualitative sentiment labels were converted into numerical scores (Positive=1, Neutral=0, Negative=-1) and averaged per month to track sentiment trends over time.

4.  Employee Ranking: Employees were ranked based on their average sentiment score to identify the most positive and negative individuals in their communications.

5.  Flight Risk Identification: A simple model was developed to identify employees at risk of leaving. A risk score was calculated based on three factors: sentiment trend (is sentiment declining?), average sentiment, and changes in communication volume.

6.  Linear Regression Model: A linear regression model (scikit-learn) was built to model the overall sentiment trend at the organizational level, providing a quantitative view of whether general sentiment is improving or deteriorating.

## Setup and Installation
1.  Ensure you have Python 3.8 or newer.
2.  Create a virtual environment (optional but recommended).
3.  Install all required libraries using the requirements.txt file:
    bash
    pip install -r requirements.txt
    
4.  Run the NLTK Downloader in Python to get the 'vader_lexicon' corpus:
    python
    import nltk
    nltk.download('vader_lexicon')
    

## How to Run
1.  Place the test(in).csv file inside the data folder.
2.  Run the main script from your terminal:
    bash
    python main.py
    
3.  The script will process the data and save all outputs (CSV files and visualization images) into the outputs folder.

## Summary of Results

### Employee Rankings
 Top 3 Most Positive Employees:
    1.  C*** S****** (Average Score: 0.58)
    2.  J*** M******* (Average Score: 0.47)
    3.  A**** B*** (Average Score: 0.45)
 Top 3 Most Negative Employees:
    1.  J**** H*** (Average Score: -0.38)
    2.  J****** D** (Average Score: -0.29)
    3.  C******** L** (Average Score: -0.27)

### Flight Risk Analysis
The following employees were flagged as having the highest flight risk score based on a combination of a declining sentiment trend, low average sentiment, and a potential decrease in communication volume:
 Employees with Highest Risk Score:
    1.  J**** H*** (Risk Score: 0.95)
    2.  M***** S**** (Risk Score: 0.81)
    3.  J****** D** (Risk Score: 0.79)

### Key Insights and Recommendations

1.  Insight: The overall organizational sentiment trend shows a slight decline over time, as indicated by the linear regression model. Although the decline is minor, it signals the need for continuous monitoring.
     Recommendation: Use the monthly sentiment score as a Key Performance Indicator (KPI) for organizational health and discuss any significant dips in management meetings.

2.  Insight: The negative word cloud analysis highlights words like "problem", "help", "error", and "late". This suggests that much of the negative sentiment is rooted in technical or project-related challenges.
     Recommendation: Share these insights with technical department heads and project managers to identify and address the bottlenecks teams are facing.

3.  Insight: There is a clear group of consistently positive employees who act as morale boosters, while others are consistently negative and at risk of leaving.
     Recommendation: Engage the most positive employees in mentorship programs or ask for their input on maintaining a good work culture. For employees flagged as flight risks, approach them with empathy. Use this data as a basis to start a one-on-one conversation to understand their concerns and offer support.