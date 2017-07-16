#!/usr/bin/env python

from tkinter import *
import os

class TextChanger(Frame):
    
    def updateDictionary(self, Dictionary):
        OptionsArray = []
        for line in os.listdir():
            if line.endswith('_dic.py'):
                line = line[:-3]
                OptionsArray.append(line)
        Dictionary = (OptionsArray)
        Dictionary.sort()
        return(Dictionary)

    def processButton(self, opt, msg):
        RT=__import__(str(opt.get()))
        self.clipboard_clear()
        self.clipboard_append(RT.RT3(msg.get()))
        msg.set("")
        return(msg)

    def createWidgets(self):
        OpenPreferences = open("Preferences.txt", mode='r')
        Default = int(OpenPreferences.read())
        OpenPreferences.close()
        Options = ()
        Options = self.updateDictionary(Options)
        msg = StringVar()
        msg.set("")
        opt = StringVar()
        opt.set(Options[Default])
        self.OptMenu = OptionMenu(self, opt, *Options)
        self.EntLabel = Entry(self, textvariable = msg)
        self.EntLabel.focus_set()
        self.EntLabel.bind("<Return>",
                           lambda x: self.processButton(opt,msg))
        self.QUIT = Button(self)
        self.QUIT["text"] = "QUIT"
        self.QUIT["command"] =  self.quit
        self.EntLabel.pack({"side": "left"})
        self.OptMenu.pack({"side": "left"})
        self.QUIT.pack({"side": "right"})
    def __init__(self, master=None):
        Frame.__init__(self, master)
        self
        self.pack()
        self.createWidgets()
root = Tk()
app = TextChanger(master=root)
app.mainloop()
root.destroy()
