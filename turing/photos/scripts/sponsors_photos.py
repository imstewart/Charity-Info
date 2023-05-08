#!/usr/bin/env python3

from PIL import Image
from pathlib import Path

import glob
import os

import datetime

os.chdir('/var/www/html/photos')

current_datetime=datetime.datetime.now()
today = current_datetime.strftime("%d-%m-%Y")

team =  Image.open("turing_staff.jpg")

area = (2000,1300, 2500,1600)
newsize =(500,300)

logofiles =glob.glob("logos/*.png")

for logo in logofiles:
     sponsor = Image.open(logo)
     sponsor_resized = sponsor.resize(newsize)
     team.paste(sponsor_resized, area)
     file_name =  os.path.basename(logo)
     file_path =(Path(file_name).stem)
     try:
          os.mkdir(file_path.lower())
     except:
          test = "tt"
          # print("Folder already created")
#    print(export)
     file_name2 = today + "-" + file_name
     export_image = os.path.join(file_path, file_name2.lower())
     common="common/"
     export_image_common = os.path.join(common, file_name.lower())
     print("Exporting : " + file_name.lower() + " : " +  file_name2.lower())

     team.save(export_image)
     team.save(export_image_common)





