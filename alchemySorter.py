# -*- coding: utf-8 -*-
import json
import shutil
import os
from getText import *

from alchemyapi import AlchemyAPI
alchemyapi = AlchemyAPI()

myList = ["Documents/Carmen", "Documents", "Documents/Music Humanities",  "Documents/Econometrics", "Documents/Computer Science Theory"]

myText2 = get_docx_text("Listening+assignment+4+-+Liszt%2C+Nuages+Gris.docx")
response = alchemyapi.concepts("text", myText2)

for concept in response['concepts']:
       for thing in myList:
	  thing1 = thing.replace("*/", "")
          if float(concept['relevance']) > 0.4 and (concept['text'] in thing1
		or thing1 in concept):
                print('text: ', concept['text'])
                print(thing)
                print('relevance: ', concept['relevance'])
#		shutil.move(os.path.abspath(os.path.join(os.getcwd(), "Listening+assignment+4+-+Liszt%2C+Nuages+Gris.docx"),
#			os.path.abspath(os.path.join(os.getcwd(), os.path.pardir), os.pardir)))
print ("Sentiment: " + response['status'])
