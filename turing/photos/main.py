from tkinter import *
from tkinter import filedialog
from PIL import Image,ImageTk
from pathlib import Path

import glob
import os
import datetime

root = Tk()
root.geometry("800x500")
root.title("Turing Spousers")
root.config(background="Teal")

team_image=("team/default.jpg")

global my_team

def myclick():

    current_datetime=datetime.datetime.now()
    today = current_datetime.strftime("%d-%m-%Y")

 
    logofiles =glob.glob("logos/*.png")

    for logo in logofiles:
        team =  Image.open(team_image)
        sponsor = Image.open(logo)
        location_x = int((float(xdim.get())))
        location_y = int((float(ydim.get())))
        width = int((float(imagexdim.get())))
        height = int((float(imageydim.get())))
        area = (location_x,location_y,(location_x + width),(location_y + height))
        newsize =(width,height)
       
        sponsor = Image.open(logo)
        sponsor_resized = sponsor.resize(newsize)

        team.paste(sponsor_resized, area)
        file_name =  os.path.basename(logo)
        file_path =(Path(file_name).stem)
        try:
            os.mkdir(file_path.lower())
        except:
            test = "tt"
        file_name2 = today + "-" + file_name
        export_image = os.path.join(file_path, file_name2.lower())
        common="common/"
        export_image_common = os.path.join(common, file_name.lower())
        print("Exporting : " + file_name.lower() + " : " +  file_name2.lower())

        team.save(export_image)
        team.save(export_image_common)
        update_image


        
def update_image():
        global my_team
        tkimg1 = ImageTk.PhotoImage(Image.open("team/default.jpg").resize((500,300)))
        my_team =Label(root, image=tkimg1)
        my_team.image = tkimg1 
        print("Updated")


def select_picture():
     
    mydrive = filedialog.askopenfilename(initialdir="./team", title="Select a file")
    newdefault = Image.open(mydrive)
    newdefault.save(team_image)
    root.after(10,update_image)

def refresh(self):
    self.destroy()
    self.__init__()
   

team =  Image.open(team_image)
team_display = ImageTk.PhotoImage(team.resize((500,300)))
my_team =Label(root, image=team_display).place(x=280,y=50)
my_label =Label(root, text="Current Team Photo being used",font=("Ariel",18),background="Teal").place(x=340,y=10)

x = Label(root,text = "Logo X Dim :",font=("Arial",12),background="Teal")
x.place(x=30,y=52)
xdim = Entry(root,width=4,bg="black",fg="red",font=("Arial",20))
xdim.place(x=200,y=50)
xdim.insert(0, 2000)

y = Label(root,text = "Logo Y Dim :",font=("Arial",12),background="Teal")
y.place(x=30,y=92)
ydim = Entry(root,width=4,bg="black",fg="red",font=("Arial",20))
ydim.place(x=200,y=90)
ydim.insert(0, 1300)

imagex = Label(root,text = "Logo width :",font=("Arial",12),background="Teal")
imagex.place(x=30,y=153)
imagexdim = Entry(root,width=4,bg="black",fg="red",font=("Arial",20))
imagexdim.place(x=200,y=150)
imagexdim.insert(0, 500)

imagey = Label(root,text = "Logo height :",font=("Arial",12),background="Teal")
imagey.place(x=30,y=193)
imageydim = Entry(root,width=4,bg="black",fg="red",font=("Arial",20))
imageydim.place(x=200,y=190)
imageydim.insert(0, 300)
 
myteamphoto = Button(root, text="Team Photo",height=4,width=45,command=select_picture).place(x=350,y=390)
myrunbutton = Button(root, text="Run Script",height=4,width=10,command=myclick).place(x=100,y=270)

root.mainloop()


