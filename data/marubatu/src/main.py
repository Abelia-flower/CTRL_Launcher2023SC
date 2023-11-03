import tkinter as tk
import tkinter.ttk as ttk
import pygame.mixer as pgm
import PLAY as P
from time import sleep
import g

g.val1=0
pgm.init()

while True:
	pgm.stop()
	def p():
		bgm.stop()
		se.play(0)
		sleep(1)
		root.destroy()
		P.play()
		
	
	def e():
		
		bgm.stop()
		se.play(0)
		sleep(1)
		root.destroy()
		bgm2.play(0)
		rootE=tk.Tk()
		rootE.configure(bg="black")
		rootE.title('おしまい')
		rootE.geometry("500x600+400+100")
		labela=tk.Label(rootE,text='バイバイ\nなのじゃ',font=("HGP創英角ポップ体","50","bold"),bg='black',fg='white')
		labela.grid(row=0,column=0)
		
		I=tk.PhotoImage(file='ending_ilust.png',master=rootE)
		ILUST=tk.Label(rootE,image=I,relief='solid')
		ILUST.grid(row=1,column=0)
		rootE.after(5000,lambda: rootE.destroy())
		rootE.mainloop()
		import sys
		sys.exit()
	
	bgm=pgm.Sound('maou_bgm_8bit29.wav')
	bgm.set_volume(0.2)
	bgm.play(-1)
	se=pgm.Sound('maou_se_system49.wav')
	se.set_volume(0.3)
	bgm2=pgm.Sound('maou_game_jingle10.wav')
	
	root = tk.Tk()
	root.geometry("1015x750+200+100")
	root.configure(bg="black")
	root.title('クイズ')
	
	
	
	label=tk.Label(root,text="　たのしい〇×クイズ",font=("HGP創英角ポップ体","70","bold"),fg='white',bg='black')
	label.grid(row=0,column=0,columnspan=3)
	frame0=tk.Frame(root,bg='black')
	frame0.grid(row=1,column=0)
	
	button2=tk.Button(frame0,text="あそぶ",font=("HGP創英角ポップ体","50","bold"),fg='red',bg='white',command=p)
	button2.grid(row=0,column=0)
	
	imag1e=tk.PhotoImage(file='home1.png',master=root)
	imag1e=imag1e.subsample(1)
	IM=tk.Label(root,image=imag1e,relief='solid')
	IM.grid(row=1,column=1,columnspan=2)
	imag2e=tk.PhotoImage(file='s_0.png',master=frame0)
	imag2e=imag2e.subsample(2)
	IM2=tk.Label(frame0,image=imag2e,relief='solid')
	IM2.grid(row=1,column=0)
	button3=tk.Button(frame0,text="おしまい",font=("HGP創英角ポップ体","30","bold"),command=e,bg='white')
	button3.grid(row=2,column=0)
	
	
	
	root.mainloop()
	