import tkinter as tk
from tkinter import ttk
from tkinter import messagebox
import random as rd
import json
import os

#jsonファイルの作成
def create_json(sub_window,t_name,names):     #t_name:タイトル, names:名前のリスト, TFs:"True or False"のリスト

    if not os.path.exists("datasets.json"):     #datasets.jsonが存在しなかったら作成する
        with open("datasets.json","w") as f:
            pass

    with open("datasets.json","r",encoding="utf-8") as f:  
        try:
            data = json.load(f)
        except:                             #jsonファイルが空だったら
            data = {}                       #dataという辞書を作成

    with open("datasets.json","w",encoding="utf-8") as f:
        if t_name:
            try:
                a = data[t_name]         #t_nameが無かったら新規に作成
            except:
                if not names[0] == "":   #namesリストは空白でないかをチェック
                    data[t_name] = {}
                else:
                    messagebox.showerror("エラー","最低１つは登録してください")
                    sub_window.lift()     #サブウィンドウを最前面に移動

        try:
            if not names[0] == "":       #namesリストが空白でなければ
                for name in names:       #辞書リストに追加
                    data[t_name][name] = True
            
                sub_window.destroy()

        except:
            messagebox.showerror("エラー","タイトルをつけてください")
            sub_window.lift()     #サブウィンドウを最前面に移動

        json.dump(data,f,indent=4)        #jsonファイルにdataを出力

def create_file():     
    global sub_window                    #サブウィンドウ
    if (sub_window == None or not sub_window.winfo_exists()) and (sub_window2 == None or not sub_window2.winfo_exists()):              #他のサブウィンドウが無かったら
        sub_window = tk.Toplevel()
        sub_window.geometry("550x300")
        sub_window.title("新規ファイルの生成")

        entry_title_lbl = tk.Label(sub_window,text="・ タイトル名をつけてください。(既存のタイトルを指定すると追加になります)",font=("",12))
        entry_title = tk.Entry(sub_window,width=54 ,font=("",13,""))

        entry_lbl = tk.Label(sub_window,text="・ 登録したい文字（数字以外も可）をカンマ（ , ）区切りで入力してください。",font=("",12))
        entry = tk.Entry(sub_window,width=54 ,font=("",13,""))
        entryScrollbar = tk.Scrollbar(sub_window, orient=tk.HORIZONTAL, command=entry.xview)   #スクロールバーの設置
        entry["xscrollcommand"] = entryScrollbar.set        #スクロールバーを結びつける　

        #create_json関数を呼び出すボタン
        btn = tk.Button(sub_window,text="生成する",font=("",15),height=2,width=10,bg="white",command = lambda: create_json(sub_window,entry_title.get(),entry.get().split(",")))

        entry_title_lbl.place(x=10,y=20)
        entry_title.place(x=25,y=60,)
        entry_lbl.place(x=10,y=120)
        entry.place(x=25,y=160)
        entryScrollbar.place(x=20,y=180,width=500)
        btn.place(x=250,y=210)

def select_check(judge):    #チェックを一括変更する関数
    if judge == "select":       #すべて選択
        for i in var_check:
            i.set(True)
    if judge == "remove":       #すべて解除
        for i in var_check:
            i.set(False)

def output_data(name,key,TF):        #チェックのついた値をメインウィンドウに書き込む関数
    product_num.delete(0, tk.END)
    d_list = []
    for i in zip(key,TF):
        datas = list(i)
        if datas[1]:
            d_list.append(i[0])
    
    product_num.insert(tk.END,",".join(d_list))

    with open("datasets.json","r",encoding="utf-8") as f:      #jsonファイルを読み込む 
        data = json.load(f)

    for k,tf in zip(key,TF):              #変更されたTFを反映
        data[name][k] = tf
    
    with open("datasets.json","w",encoding="utf-8") as f:
        json.dump(data,f,indent=4)        #jsonファイルにdataを出力

    sub_window2.destroy()
    sub_window3.destroy()

#読み込んだjsonファイルの中身を表示して☑した要素をセットして保存する関数
def set_data(name):                #サブウィンドウその３
    with open("datasets.json","r",encoding="utf-8") as f:      #jsonファイルを読み込む 
        data = json.load(f)
    key_list = list(data[name].keys())

    global sub_window3
    if sub_window3 == None or not sub_window3.winfo_exists():              #サブウィンドウが無かったら
        sub_window3 = tk.Toplevel()
        sub_window3.geometry("400x420")
        sub_window3.title(f"{name}の書き出し")
        frame = ttk.Frame(sub_window3)
        frame.pack(anchor=tk.N)

        canvas = tk.Canvas(frame,width=400-25,height=300)     #canvasの作成   #スクロールバーの分小さくする
        canvas.grid(row=1,column=0,columnspan=2)                               #canvasの設置
        scrollbar = tk.Scrollbar(frame, orient=tk.VERTICAL, command=canvas.yview)
        canvas["yscrollcommand"] = scrollbar.set        #スクロールバーを結びつける
        scrollbar.grid(row=1, column=2, sticky=(tk.N, tk.S))     #スクロールバーの設
        size_y = len(key_list) * 33
        canvas.config(scrollregion=(0,0,0,size_y))       #スクロール範囲の設定
        canvas_frame = tk.Frame(canvas,bg="white")
        canvas.create_window((0,0), window=canvas_frame, anchor=tk.NW, width=canvas.cget('width'))

        main_lbl = tk.Label(canvas_frame,text=f"{name}のデータリスト",font=("",20,"bold"),bg="white")
        main_lbl.grid(row=0,column=0,columnspan=3,pady=10)

        global var_check
        var_check = []

        num = 1
        for key_name in key_list:
            var = tk.BooleanVar()             #True or False
            var.set(data[name][key_name])     #チェックボックスに初期値を設定
            if num % 2 == 0:              #偶奇で色分け
                color = "white"
            else:
                color = main_bg
            check_btn = ttk.Checkbutton(canvas_frame,text="",style="main.TCheckbutton",variable=var)
            btn_text = tk.Label(canvas_frame,bg=color,width=28,text=key_name,font=("",15,"bold"))
            var_check.append(var)
            check_btn.grid(row=num,column=0,padx=10)
            btn_text.grid(row=num,column=1)
            num += 1
        
        def get_data():               #生成ボタンを押したら起動し、チェックボックスの状態を取得してoutput_dataに渡す
            TFdata = []
            for i in var_check:
                TFdata.append(i.get())
            output_data(name,key_list,TFdata)

        all_select = tk.Button(frame,text="全てを選択",font=("",13),height=1,width=15,bg="white",command= lambda:select_check("select"))
        all_select.grid(row=2,column=0,sticky=tk.W,padx=10,pady=10)

        all_remove = tk.Button(frame,text="全てを解除",font=("",13),height=1,width=15,bg="white",command= lambda:select_check("remove"))
        all_remove.grid(row=2,column=1,columnspan=2,padx=10,pady=10)

        create_btn = tk.Button(frame,text="生成する",font=("",15),height=2,width=15,bg="white",command=get_data)
        create_btn.grid(row=3,column=0,columnspan=2)
    
    def click_close():
        sub_window3.destroy()
        if sub_window2.winfo_exists():                 #sub_window2が先に消された時の対策
            b_event.widget["style"] = "main.TButton"

    sub_window3.protocol("WM_DELETE_WINDOW", click_close)     #sub_window3が閉じられたときに実行される関数を変更

#jsonファイルを読み込んで表示する関数
def open_file():               #サブウィンドウその２
    global sub_window2
    if (sub_window2 == None or not sub_window2.winfo_exists()) and (sub_window == None or not sub_window.winfo_exists()):              #他のサブウィンドウが無かったら
        sub_window2 = tk.Toplevel()
        sub_window2.geometry("450x400")
        sub_window2.title("既存データから開く")
        frame = tk.Frame(sub_window2)

        canvas = tk.Canvas(frame,width=280,height=300,bg="white",)     #canvasの作成
        canvas.grid(row=0,column=0)                                    #canvasの設置
        scrollbar = tk.Scrollbar(frame, orient=tk.VERTICAL, command=canvas.yview)
        canvas["yscrollcommand"] = scrollbar.set        #スクロールバーを結びつける
        scrollbar.grid(row=0, column=1, sticky=(tk.N, tk.S))    #スクロールバーの設置

        try:
            with open("datasets.json","r",encoding="utf-8") as f:      #jsonファイルを読み込む 
                data = json.load(f)

            key_list = list(data.keys())                     #jsonファイルのnameのキーを取得

            size_y = len(key_list) * 52
            canvas.config(scrollregion=(0,0,0,size_y))       #スクロール範囲の設定
            canvas_frame = tk.Frame(canvas)
            canvas.create_window((0,0), window=canvas_frame, anchor=tk.NW, width=canvas.cget('width'))   #anchor=tk.NW は左上に固定

            def check_text(event):
                global button_text,b_event
                button_text = event.widget["text"]         #ボタンのテキストを取得
                event.widget["style"] = "after.TButton"
                b_event = event

            for i in key_list:        #ボタンの設置
                button = ttk.Button(canvas_frame,text=i,width=50,padding=(0,8),style="main.TButton",command = lambda: set_data(button_text))
                button.bind("<1>", check_text)            #ボタンの情報をcheck_textへ渡す
                button.pack(pady=2)

            frame.pack(pady=20)
        except:
            messagebox.showerror("エラー","'datasets.json'が見つかりません")
            sub_window2.destroy()

def select(num_list):                   #ランダムにリストからチョイスする関数
    if len(num_list) > 0:
        r_num = rd.choice(num_list)        #ランダムに選出
        disp_num.configure(text=r_num)     #結果を表示
        num_list.remove(r_num)
        product_num.delete(0, tk.END)                               #product_numにinsertされている文を１回全消しして
        product_num.insert(tk.END,",".join(num_list))               #新たにremoveした後のリストを表示する
    else:
        pass

def create():              #数値を自動入力する関数
    try:
        minimum = int(min_num.get())
        maximum = int(max_num.get())
        num = [str(i) for i in range(minimum,maximum+1)]
        global product_num
        product_num.delete(0, tk.END)
        product_num.insert(tk.END,",".join(num))
    except:
        messagebox.showerror("エラー","自動入力欄には数字のみを入力してください")

main_bg = "light blue"

root = tk.Tk()                       #メインウィンドウ
root.title("抽選くん")
root.geometry("650x500")
root.configure(bg=main_bg)          #ウィンドウの背景色を設定

sub_window = None       #ウィンドウが表示されていない時の初期値
sub_window2 = None
sub_window3 = None

style = ttk.Style()
style.theme_use("xpnative")
style.configure("main.TButton",font=("",15,"bold"))         #ボタンの細かい設定
style.configure("after.TButton",font=("",15,"bold"),background="red",foreground="red")       #押された後のボタンの設定

style.configure("main.TCheckbutton",font=("",15,"bold"),background="white")     #チェックボックスの細かな設定

#数値自動入力欄の枠
frame_num = tk.Frame(root,relief=tk.GROOVE,width=630,height=100, bd=2,bg=main_bg)

#抽選結果を表示する大きなラベル
disp_num = tk.Label(text="",font=("",100,"bold"),bg=main_bg)    

#tk.Button()内のcommand引数には関数名のみを渡すことができ、引数ありの関数を普通に渡すことは出来ないので、ラムダ式を用いて無理やり渡している。
btn = tk.Button(text="抽選をする",font=("",15),height=1,width=15,bg="white",cursor="exchange",command = lambda: select(product_num.get().split(",")))

#自動入力欄の説明とボタン
btn2 = tk.Button(frame_num,text="生成する",font=("",15),height=2,width=10,bg="white",command = create)
input_exp = tk.Label(frame_num,text="・ 数値の自動入力(設定された範囲内で昇順に入力されます)",font=("",12),bg=main_bg)

#最大値の設定部分
max_lbl = tk.Label(frame_num,text="最大値",font=("MSゴシック",16,"bold"),bg=main_bg)
max_num = tk.Entry(frame_num,width=10,font=("",13,""))      #テキストボックス
max_num.insert(tk.END,"10")        #あらかじめ文字を配置

#最小値の設定部分
min_lbl = tk.Label(frame_num,text="最小値",font=("MSゴシック",16,"bold"),bg=main_bg)
min_num = tk.Entry(frame_num,width=10,font=("",13,""))      #テキストボックス
min_num.insert(tk.END,"1")        #あらかじめ文字を配置

#生成された数字の出力or手打ちの文字の入力欄
product_exp = tk.Label(text="・ 抽選したい文字（数字以外も可）をカンマ（ , ）区切りで入力してください。",font=("",12),bg=main_bg)
product_num = tk.Entry(font=("",13,""))  
entry_scrollbar = tk.Scrollbar(root, orient=tk.HORIZONTAL, command=product_num.xview)   #スクロールバーの設置
product_num["xscrollcommand"] = entry_scrollbar.set        #スクロールバーを結びつける　

#リボンの追加
men = tk.Menu(root)
menu_file = tk.Menu(root,tearoff=0) 
men.add_cascade(label='ファイル', menu=menu_file)      #リボン名の設定   
root.config(menu=men)

#リボン内のメニューの設定
menu_file.add_command(label='開く', command=open_file) 
menu_file.add_command(label='作成する', command=create_file) 
menu_file.add_separator() 

#ボタンなどの配置
input_exp.place(x=15,y=15)
disp_num.place(x=0,y=220,width=650)        
max_lbl.place(x=240, y=50)
max_num.place(x=320, y=50,height=30)    
min_lbl.place(x=30, y=50)
min_num.place(x=110, y=50,height=30)
btn.place(x=230, y=430)
btn2.place(x=470, y=28)
product_exp.place(x=15,y=140)
product_num.place(x=50,y=170,width=540,height=30)
entry_scrollbar.place(x=50,y=200,width=540)

frame_num.place(x=10,y=10)

tk.mainloop()