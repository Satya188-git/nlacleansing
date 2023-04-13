

# from collections import Counter # for sentence wise sentiment and aggregation
# GENERATE_PER_SENTENCE_SENTIMENT=True

# ------------------------------------------------------------------------------------#
# combine sentence level predicted labels and scores to generate overall label, score
label_dict = {'pos': 'POSITIVE', 'neg': 'NEGATIVE', 'neutral': 'NEUTRAL'}


def get_overall_label_score(pred_sent_dict, method, label_dict=label_dict):
    '''
    pred_sent_dict - dictionary containing predicted_label('positive', 'neutral' or 'negative') and predicted_score for each sentence (keys)
    label_dict - mapping of labels from 'pos', 'neg', 'neutral' to model recognized labels
    method - 'majority-neg': majority voting, tie is broken by assigning the overall label as negative. 
                             An average of the scores of the majority label is returned. In case of a tie, negative label score is returned
             'majority-neu': majority voting, tie is broken by assigning the overall label as neutral. 
                             An average of the scores of the majority label is returned. In case of a tie, neutral label score is returned
             'strict': assign positive only if all positive, assign negative if even one is negative, else assign neutral 
                       avg scores of the assigned label is returned. In case of a tie, negative label score is returned
    '''
    all_sent_labels = [sent_dict['label']
                       for sent_dict in pred_sent_dict.values()]
    if method == 'strict':
        # If all sentences predicted positive -- assign pos
        if all([label == label_dict['pos'] for label in all_sent_labels]):
            overall_sentiment = label_dict['pos']
        # If any sentence is predicted negative -- assign neg
        elif any([label == label_dict['neg'] for label in all_sent_labels]):
            overall_sentiment = label_dict['neg']
        else:
            overall_sentiment = label_dict['neutral']
        scores = [sent_dict['score'] for sent_dict in pred_sent_dict.values(
        ) if sent_dict['label'] == overall_sentiment]
        overall_score = np.mean(scores)
    elif 'majority' in method:
        counter = Counter(all_sent_labels)
        if counter[label_dict['pos']] == counter[label_dict['neg']] == counter[label_dict['neutral']]:  # tie
            if method == 'majority-neg':
                overall_sentiment = label_dict['neg']
            elif method == 'majority-neu':
                overall_sentiment = label_dict['neutral']
        else:
            overall_sentiment = max(counter, key=counter.get)
        scores = [sent_dict['score'] for sent_dict in pred_sent_dict.values(
        ) if sent_dict['label'] == overall_sentiment]
        overall_score = np.mean(scores)
    return overall_sentiment, overall_score


# ------------------------------------------------------------------------------------#
# function to generate average sentiment per sentences

def generate_average_sentiments_per_sentences(comprehend, content):

    # generating per sentence sentiments
    aggregated_sentiment_label = 'NEUTRAL'
    aggregated_sentiment_score = '55'
    if GENERATE_PER_SENTENCE_SENTIMENT:
        # split_line_data=content.split()
        split_line_data = nltk.sent_tokenize(content)

        if split_line_data and len(split_line_data) > 1:
            pred_sent_dict = {}
            idx = 0
            for sentence in split_line_data:
                sentiment_value, sentiment_score = comprehend_content_sentiment(
                    comprehend, sentence)
                pred_sent_dict[idx] = {
                    'label': sentiment_value, 'score': sentiment_score}
                # print("partial")
                idx += 1
            if pred_sent_dict:
                method = 'majority-neu'  # 'majority-neg' 'strict'
                aggregated_sentiment_value, aggregated_sentiment_score = get_overall_label_score(
                    pred_sent_dict, method)

    return aggregated_sentiment_value, aggregated_sentiment_score
