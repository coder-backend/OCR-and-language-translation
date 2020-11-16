import re
import tensorflow as tf
import numpy as np
import time
import os
import pickle
import model
from model import Encoder,Decoder

# BATCH_SIZE = 64
# units = 512
# embedding_dim = 256
# vocab_inp_size = len(input_lang.word2index)+1
# vocab_tar_size = len(output_lang.word2index)+1
# optimizer = tf.keras.optimizers.Adam()
# decoder = Decoder(vocab_tar_size, embedding_dim, units, BATCH_SIZE)
# encoder = Encoder(vocab_inp_size, embedding_dim, units, BATCH_SIZE)
# checkpoint = tf.train.Checkpoint(optimizer=optimizer,
#                                  encoder=encoder,
#                                  decoder=decoder)

class Lang:
    def __init__(self,name):
      #Here we are maintaining three dictionaries, one to convert word into index,another index into word and count.
      #Also we are maintaining global count of distinct words.
      self.name=name
      self.word2index={"<start>":1,"<end>":2}
      self.word2count={"<start>":0,"<end>":0}
      self.index2word={1:"<start>",2:"<end>"}
      self.n_count=3
    def addsentence(self,sent):
      s=sent.split(" ")
      for i in s:
        self.addword(i)

    #preprocessing the data. Seperating the words into dictionary
    def addword(self,word):
      if word not in self.word2index:
        self.word2index[word]=self.n_count
        self.word2count[word]=1
        self.index2word[self.n_count]=word
        self.n_count+=1
      else:
        self.word2count[word]+=1


def unicode_to_ascii(s):
  return ''.join(c for c in unicodedata.normalize('NFD', s)
      if unicodedata.category(c) != 'Mn')

def clean(w):
    # s=unicode_to_ascii(s)
    w = re.sub(r"([?.!,¿])", r" \1 ", w) # creating a space between words and punctation following it
    w = re.sub(r'[" "]+', " ", w)
    w = w.rstrip().strip()
    w = "<start> " + w + " <end>"     # so that the model know when to start and stop predicting
    return w
def read(source,target,links,limit,reverse=False):
  MAX_len=30
  with open(links[source]) as f1,open(links[target]) as f2:
    pairs=[]
    count=0
    for x,y in zip(f1,f2):
      if count>limit:
        break
      x,y=x.strip(),y.strip()
      count+=1
#Because all the other tensors will be padded according to max word length we have to keep an upper cap on max word to limit.
      if len(x)<MAX_len and len(y)<MAX_len:
        pairs.append([clean(x),clean(y)] )
    input_lang=Lang(source)
    output_lang=Lang(target)
    if reverse:
      pairs=[list(reversed(l)) for l in pairs]
      input_lang,output_lang=output_lang,input_lang
    for pair in pairs:
      input_lang.addsentence(pair[0])
      output_lang.addsentence(pair[1])
    print(input_lang.n_count)
    return pairs,input_lang,output_lang

def tokenize(pairs,input_lang,output_lang):
  input_tensor=list([])
  output_tensor=list([])
  print(len(pairs))
  input_tensor=[[input_lang.word2index[word] for word in i[0].split(" ")] for i in pairs]
  output_tensor=[[output_lang.word2index[word] for word in i[1].split(" ")] for i in pairs]
  # input_tensor=tf.keras.preprocessing.sequence.pad_sequences(input_tensor,padding='post')
  # output_tensor=tf.keras.preprocessing.sequence.pad_sequences(output_tensor,padding='post')
  
  return input_tensor,output_tensor
def pad(tensor):
  tensor=tf.keras.preprocessing.sequence.pad_sequences(tensor,padding='post')
  return tensor


    
def evaluate(sentence):
  attention_plot = np.zeros((30 , 30))
  sentence =clean(sentence)
  inputs=[]
  for i in sentence.split(' '):
    if i in input_lang.word2index:
      inputs.append(input_lang.word2index[i])
  inputs = tf.keras.preprocessing.sequence.pad_sequences([inputs],
                                                         maxlen=30,
                                                         padding='post')
  inputs = tf.convert_to_tensor(inputs)

  result = ''

  hidden = [tf.zeros((1, units))]
  enc_out, enc_hidden = encoder(inputs, hidden)

  dec_hidden = enc_hidden
  dec_input = tf.expand_dims([output_lang.word2index['<start>']], 0)

  for t in range(30):
    predictions, dec_hidden, attention_weights = decoder(dec_input,
                                                         dec_hidden,
                                                         enc_out)

    # storing the attention weights to plot later on
    attention_weights = tf.reshape(attention_weights, (-1, ))
    attention_plot[t] = attention_weights.numpy()

    predicted_id = tf.argmax(predictions[0]).numpy()

    result += output_lang.index2word[predicted_id] + ' '

    if output_lang.index2word[predicted_id] == '<end>':
      return result, sentence, attention_plot

    # the predicted ID is fed back into the model
    dec_input = tf.expand_dims([predicted_id], 0)

  return result, sentence

# def plot_attention(attention, sentence, predicted_sentence):
#   fig = plt.figure(figsize=(10,10))
#   ax = fig.add_subplot(1, 1, 1)
#   ax.matshow(attention, cmap='viridis')

#   fontdict = {'fontsize': 14}

#   ax.set_xticklabels([''] + sentence, fontdict=fontdict, rotation=90)
#   ax.set_yticklabels([''] + predicted_sentence, fontdict=fontdict)

#   ax.xaxis.set_major_locator(ticker.MultipleLocator(1))
#   ax.yaxis.set_major_locator(ticker.MultipleLocator(1))

#   plt.show()

def translate(sentence):
  result, sentence = evaluate(sentence)

  print('Input: %s' % (sentence))
  return result

  # attention_plot = attention_plot[:len(result.split(' ')), :len(sentence.split(' '))]
  # plot_attention(attention_plot, sentence.split(' '), result.split(' '))

def transform(sentence,l1,l2):
  global input_lang,output_lang
  input_lang=l1
  output_lang=l2

  vocab_inp_size = len(input_lang.word2index)+1
  vocab_tar_size = len(output_lang.word2index)+1
  optimizer = tf.keras.optimizers.Adam()
  decoder = Decoder(vocab_tar_size, embedding_dim, units, BATCH_SIZE)
  encoder = Encoder(vocab_inp_size, embedding_dim, units, BATCH_SIZE)
  checkpoint = tf.train.Checkpoint(optimizer=optimizer,
                                 encoder=encoder,
                                 decoder=decoder)

  print(encoder)
  curr= os.path.abspath(__file__)
  temp=os.path.join(curr,"available_models")
  checkpoint_dir=os.path.join(temp,"training_checkpoints")
  checkpoint.restore(tf.train.latest_checkpoint(checkpoint_dir))
  print(encoder)
  return translate(sentence)


