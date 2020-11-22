# Machine Translation
We did machine translation for 3 languages: Hindi to English, Punajbi to English and Nepali to English. Several steps were done during machine translation.

### Data Collection.
The hardest challenge was data collection without which machine translation was impossible. For the hindi we used IIT Bombay's corpus that used 1M set of corpuses. Due to the GPU 
limitation we could only train it for 7 epochs and hence couldn't get the results as we expected to.
However for low resource languages ie Hindi and Punjabi finding the dataset was very hard because while they existed individually we couldn't find the dataset where one was translated
from another. Ultimately we resorted to using the corpus from bible in each languages to prepare the datasets since bible was widely sold book and had both the trasnlation.
However we didn't took into account of the fact that Bible is a religious book and it doesn't cover the area that we try to aim for. Adding this to the fact that our target set would 
likely come from some banners, whose words aren't distantly related or mentioned in bible. Despite having a decent vocabulary of around 17 thousand we haven't been able to achieve a 
usable translator for either of these languages/

### Training:
For training we used an Encoder Decoder network with attention. For hindi we trained the model till 7 epochs while 15 for both the other models. We used attention plots to find out
the words the model was specifically focused on.
