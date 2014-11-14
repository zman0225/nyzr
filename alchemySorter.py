# -*- coding: utf-8 -*-
import json
import shutil
import os
from getText import *

from alchemyapi import AlchemyAPI
alchemyapi = AlchemyAPI()

folderList = ["Documents/Carmen", "Documents", "Documents/Music Humanities",  "Documents/Econometrics", "Documents/Computer Science Theory"]

fileName = "Homework #3 CS Theory.docx"
myDoc = get_docx_text(fileName)
response = alchemyapi.concepts("text", myDoc)
response1 = alchemyapi.taxonomy("text", myDoc)

for concept in response['concepts']:
       for pathName in folderList:
	  folderName = pathName.replace("*/", "").lower()
	  conceptL = concept['text'].lower()
          if float(concept['relevance']) > 0.4 and (conceptL in folderName
		or folderName in conceptL):
                print('text: ', concept['text'])
                print("file should be in " + pathName)
                print('relevance: ', concept['relevance'])
	  print(conceptL)
#		shutil.move(os.path.abspath(os.path.join(os.getcwd(), "Listening+assignment+4+-+Liszt%2C+Nuages+Gris.docx"),
#			os.path.abspath(os.path.join(os.getcwd(), os.path.pardir), os.pardir)))

for taxonomy in response1['taxonomy']:
      category = taxonomy['label'].replace("*/", "").lower()	
      category = (category.rsplit('/', 1))[-1].lower()
#      print(category)
      for pathName in folderList:
	   folderName = pathName.replace("*/", "").lower()
	   if (category in folderName or folderName in category):
		print("file should be in " + pathName)

#print ("Sentiment: " + response['status'])
