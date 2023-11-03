import pygame
from pygame.locals import*
import sys
import random as rd

def my_randint(start,end,skip_s,skip_e):
    a = rd.randint(start,end)
    while a >= skip_s and a <= skip_e:
        a = rd.randint(start,end)
    return a

SCREEN = Rect(0,0,800,600)

class After(pygame.sprite.Sprite):   #課題とぶつかった後のターゲット
    def __init__(self,filename,x,y,V):
        pygame.sprite.Sprite.__init__(self,self.containers)
        self.image = pygame.image.load(filename).convert_alpha()
        self.image = pygame.transform.scale(self.image,(V,V))
        w = self.image.get_width()
        h = self.image.get_height()
        self.rect = Rect(x,y,w,h)

class Player(pygame.sprite.Sprite):   #課題の生成
    def __init__(self,filename,x,y,vx,vy,V,Targets,screen):
        pygame.sprite.Sprite.__init__(self,self.containers)
        self.image = pygame.image.load(filename).convert_alpha()
        self.image = pygame.transform.scale(self.image,(V,V-10))
        w = self.image.get_width()
        h = self.image.get_height()
        self.screen = screen
        self.rect = Rect(x,y,w,h)
        self.Targets = Targets
        self.vx = vx
        self.vy = vy
        self.first = True
        self.update = self.move
        
    def move(self): 
        if pygame.key.get_pressed()[K_LSHIFT] or pygame.key.get_pressed()[K_RSHIFT]:   #シフトを押すとfirstがFalseになる。
            self.first = False
        if self.rect.right < SCREEN.right:
            if pygame.key.get_pressed()[K_d]:
                self.rect.move_ip(self.vx,0)
                self.rect.clamp(SCREEN)
        if self.rect.left > 0:
            if pygame.key.get_pressed()[K_a]:
                self.rect.move_ip(-self.vx,0)
                self.rect.clamp(SCREEN)
        if self.rect.top > 0 - 5:
            if pygame.key.get_pressed()[K_w]:
                self.rect.move_ip(0,-self.vy)
                self.rect.clamp(SCREEN)
        if self.rect.bottom < SCREEN.bottom + 5:
            if pygame.key.get_pressed()[K_s]:
                self.rect.move_ip(0,self.vy)
                self.rect.clamp(SCREEN)  
        if self.first:    #最初にShiftを押されるまで
            text1 = big_font.render("Press 'Shift'",True,(255,255,255))
            text2 = font.render("まず、初期位置を設定してください",True,(0,0,0))
            self.screen.blit(text1,(100,300))
            self.screen.blit(text2,(50,100))
        else:    #Shiftが押された後
            taegets_collided = pygame.sprite.spritecollide(self,self.Targets,True)
            if taegets_collided and score.score < 20 and left_time > 0:
                
                after = After(".\Pygame\school_tani_otosu_boy.png",taegets_collided[0].rect.x,taegets_collided[0].rect.y,100)
                target = Target(".\Pygame\school_tani_get_boy.png",rd.randint(1,SCREEN.width-80),rd.randint(1,SCREEN.height-80),my_randint(-velo,velo,-low,low),my_randint(-velo,velo,-low,low),80,False)
                score.add_score(touch)
                pygame.mixer.music.load(".\Pygame\デデドン.mp3")
                pygame.mixer.music.play()  
                pygame.mixer.music.set_volume(0.07)

class Target(pygame.sprite.Sprite):   #動き回る課題の生成
    def __init__(self,filename,x,y,vx,vy,V,first):
        pygame.sprite.Sprite.__init__(self,self.containers)
        self.image = pygame.image.load(filename).convert_alpha()
        self.image = pygame.transform.scale(self.image,(V-15,V))
        self.first = first
        w = self.image.get_width()
        h = self.image.get_height()
        self.rect = Rect(x,y,w,h)
        self.vx = vx
        self.vy = vy
        if self.first:
            self.update = self.start   #start関数が 毎回updateされる。
        else:   #firstをFalseにすると、Shiftを押さずに動き始める。
            self.Vx = self.vx
            self.Vy = self.vy
            self.update = self.move

    def start(self):
        if pygame.key.get_pressed()[K_LSHIFT] or pygame.key.get_pressed()[K_RSHIFT]:   #Shiftを押したらゲームがスタート
            self.Vx = self.vx
            self.Vy = self.vy
            self.update = self.move   #move関数がupdateに変更
    
    def move(self):
        self.rect.move_ip(self.Vx,self.Vy)
        if self.rect.left < 0 or self.rect.right > SCREEN.right:
            self.Vx = -self.Vx
        if self.rect.top < 0 or self.rect.bottom > SCREEN.bottom:
            self.Vy = -self.Vy
        self.rect.clamp(SCREEN)
        global timer
        if left_time == 0 or score.score == 20:
            timer = False
        else:
            timer = True

class Score:   #スコアの表示
    def __init__(self,x,y,screen):
        self.score = 0
        self.x = x 
        self.y = y
        self.screen = screen

    def draw(self):
        img = font.render("落単"+str(self.score)+"/20",True,(255,255,255))
        self.screen.blit(img,(self.x,self.y))

    def add_score(self,touch):
        self.score += touch

    def add_stop(self):
        global touch
        touch = 0

    def count_time(self,left_time):
        img = font.render("残り"+str(left_time)+"秒",True,(255,255,255))
        self.screen.blit(img,(self.x+600,self.y))

class Difficulty:   #難易度を設定するクラス
    def __init__(self,x,y,screen,color1,color2,color3):
        self.x = x
        self.y = y
        self.color1 = color1
        self.color2 = color2
        self.color3 = color3
        self.screen = screen
        global button1,button2,button3
        button1 = pygame.Rect(190,200,170,50)
        button2 = pygame.Rect(190,300,170,50)
        button3 = pygame.Rect(190,400,170,50)

    def show(self):   #ボタンの生成
        pygame.draw.rect(self.screen,(self.color1,self.color1,self.color1),button1)
        pygame.draw.rect(self.screen,(self.color2,self.color2,self.color2),button2)
        pygame.draw.rect(self.screen,(self.color3,self.color3,self.color3),button3)
        text2 = font.render("Easy",True,(50,150,50))
        text3 = font.render("Normal",True,(50,50,150))
        text4 = font.render("Hard",True,(180,50,50))
        self.screen.blit(text2,(self.x+20,self.y+100))
        self.screen.blit(text3,(self.x,self.y+200))
        self.screen.blit(text4,(self.x+20,self.y+300))

    def choice(self,difficulty):   #難易度の内容設定
        if difficulty == "EASY":
            global num,velo,low,v_play   #num:一度に出現するターゲットの数   velo,low:ターゲットの速度の最高値と最低値   v_play:プレイヤーの速度
            num = 5
            velo = 6
            low = 3
            v_play = 10
        if difficulty == "NORMAL":
            num = 8  
            velo = 6
            low = 3
            v_play = 10
        if difficulty == "HARD":
            num = 10
            velo = 8
            low = 4
            v_play = 12
        if difficulty == "MASTER":
            num = 20
            velo = 15
            low = 5
            v_play = 20

class Strings:   #文を表示するクラス
    def __init__(self,size,filename):
        self.bigfont = pygame.font.Font(".\Pygame\shippori3\ShipporiMincho-Medium.otf",int(size*2.5))
        self.titlefont = pygame.font.Font("pygame\shippori3\ShipporiMincho-ExtraBold.otf",int(size*1.6))
        self.font = pygame.font.Font(filename,size)
        self.middlefont = pygame.font.Font(filename,int(size*0.8))
        self.minifont = pygame.font.Font(filename,int(size*0.5))

    def gameover(self,screen,x,y):
        text1 = self.bigfont.render("YOU DIED",False,(255,0,0))
        text2 = self.font.render("'SPACE'を押してもう一年",True,(255,255,255))
        screen.blit(text1,(x+10,y))
        screen.blit(text2,(x+20,y+170))

    def clear(self,screen,x,y):
        text1 = self.titlefont.render("YOU SURVIVED",False,(0,0,255))
        text2 = self.font.render("'SPACE'を押してもう一度",True,(255,255,255))
        text3 = self.titlefont.render(f"取得単位数:{20 - score.score}",True,(100,0,255))
        text4 = self.titlefont.render("！！！フル単！！！",True,(230,105,80))
        text5 = self.minifont.render("難易度選択画面で'M'キーを押してみよう！",True,(255,255,255))
        screen.blit(text1,(x,y))
        screen.blit(text2,(x+30,y+260))
        screen.blit(text3,(x+90,y+130))
        if score.score == 0:
            screen.blit(text4,(30,50))
            screen.blit(text5,(300,570))

def main():
    pygame.init()
    screen = pygame.display.set_mode(SCREEN.size)   #スクリーンの作成
    pygame.display.set_caption("単位を落とすな！")   #ウィンドウネームの作製
    global font,big_font
    font = pygame.font.Font(".\Pygame\shippori3\ShipporiMincho-ExtraBold.otf",40)
    big_font = pygame.font.Font(".\Pygame\shippori3\ShipporiMincho-ExtraBold.otf",100)

    strings = Strings(50,".\Pygame\shippori3\ShipporiMincho-Bold.otf")
    title_image = pygame.image.load(".\Pygame\TITLE.jpg").convert_alpha()
    illust_image = pygame.image.load(".\Pygame\ILLUST.jpg").convert_alpha()
    difficulty_image = pygame.image.load(".\Pygame\DIFFICULTY.jpg").convert_alpha()

    pygame.mixer.init(frequency = 44100)   #音楽の再生
    death_BGM = pygame.mixer.Sound(".\Pygame\8bitBGM.mp3")
    death_BGM.set_volume(0.03)
    TITLE = pygame.mixer.Sound(".\Pygame\8bitTown.mp3")
    TITLE.set_volume(0.03)
    PLAYING = pygame.mixer.Sound(".\Pygame\Endurance_Game.mp3")
    PLAYING.set_volume(0.03)
    celemony = pygame.mixer.Sound(".\Pygame\楽しく面白く.mp3")
    celemony.set_volume(0.03)
    clear = pygame.mixer.Sound(".\Pygame\きこりの森.mp3")
    clear.set_volume(0.04)
 
    global group
    global Targets
    group = pygame.sprite.RenderUpdates()   #groupの作成
    group2 = pygame.sprite.RenderUpdates() 
    Targets = pygame.sprite.Group() 
    Target.containers = group,Targets   #一括挿入
    After.containers = group
    Player.containers = group2 

    targets = []
    targets_rect = []

    global touch
    touch = 1
    global score
    score = Score(13,8,screen)

    touching = False
    easy_touch = False
    normal_touch = False
    hard_touch = False
    tick = False

    clock = pygame.time.Clock()

    TIME = 0
    global left_time
    left_time = 30

    running = False
    title = True
    illust = False

    while title:   #タイトル画面
        clock.tick(30)   #fps(frames per second)  

        if not illust: 
            screen.blit(title_image,(0,0))   #タイトル
        else:
            screen.blit(illust_image,(0,0))   #操作説明

        global timer
        timer = False
        TITLE.play(-1)
        pygame.display.update()

        for event in pygame.event.get():
            if event.type == QUIT:
                pygame.quit()
                sys.exit()
            if event.type == KEYDOWN:
                if event.key == K_ESCAPE:
                    pygame.quit()
                    sys.exit()
                if event.key == K_SPACE:
                    if not illust:
                        illust = True
                    else:
                        difficulty = None 
                        touching = False  
                        difficult = True   #難易度選択のループへ移動
                        title = False   #タイトルループの終了

    while difficult:   #難易度選択画面
        clock.tick(30)
        screen.blit(difficulty_image,(0,0))

        if not touching:   #触れたボタンの色を変える
            color1,color2,color3 = 255,255,255
        else:
            if easy_touch:
                color1 = 160
            elif normal_touch:
                color2 = 160
            elif hard_touch:
                color3 = 160

        dif = Difficulty(200,100,screen,color1,color2,color3)
        dif.show()

        pygame.display.update()

        for event in pygame.event.get():
            if event.type == QUIT:
                pygame.quit()
                sys.exit()
            if event.type == pygame.MOUSEMOTION:   #ボタンとの当たり判定
                if button1.collidepoint(event.pos):
                    touching = True
                    easy_touch = True
                elif button2.collidepoint(event.pos):
                    touching = True
                    normal_touch = True
                elif button3.collidepoint(event.pos):
                    touching = True
                    hard_touch = True
                else:
                    touching = False
                    easy_touch = False
                    normal_touch = False
                    hard_touch = False
            if event.type == pygame.MOUSEBUTTONDOWN:   #難易度選択
                if button1.collidepoint(event.pos):
                    difficulty = "EASY"
                elif button2.collidepoint(event.pos):
                    difficulty = "NORMAL"
                elif button3.collidepoint(event.pos):
                    difficulty = "HARD"
                
                if type(difficulty) == str:   #難易度が選ばれたら...
                    dif.choice(difficulty)
                    running = True
                    for i in range(num):
                        target = Target(".\Pygame\school_tani_get_boy.png",rd.randint(1,SCREEN.width-80),rd.randint(1,SCREEN.height-80),my_randint(-velo,velo,-low,low),my_randint(-velo,velo,-low,low),80,True)  #ターゲットの生成
                        targets.append(target)
                        targets_rect.append(target.rect)
                        TITLE.stop()
                    global player
                    player = Player(".\Pygame\Text_kadai2.png",200,200,v_play,v_play,80,Targets,screen) #課題の生成
                    difficult = False
            if event.type == KEYDOWN:
                if event.key == K_ESCAPE:
                    pygame.quit()
                    sys.exit()
                if event.key == K_m:   #もしMが押されたら(隠し要素)
                    difficulty = "MASTER"                        
                    dif.choice(difficulty)
                    running = True 
                    for i in range(20):
                        target = Target(".\Pygame\school_tani_get_boy.png",rd.randint(1,SCREEN.width-80),rd.randint(1,SCREEN.height-80),my_randint(-velo,velo,-low,low),my_randint(-velo,velo,-low,low),80,True)
                        targets.append(target)
                        targets_rect.append(target.rect)
                        TITLE.stop()
                    player = Player(".\Pygame\Text_kadai2.png",200,200,v_play,v_play,80,Targets,screen)
                    difficult = False

    while running:
        clock.tick(30)   #fps(frames per second)
        screen.fill((67,200,175))   #塗りつぶし

        PLAYING.play(-1) 
        group.update()
        group.draw(screen)
        group2.update()
        group2.draw(screen)
        score.draw()  

        score.count_time(left_time)
        if timer:
            TIME += 1
            if not tick:
                if TIME % 29 == 0:
                    left_time -= 1

        if left_time <= 0:
            score.add_stop()
            strings.clear(screen,50,170)
            PLAYING.stop()
            clear.play(-1)


        if score.score == 20:
            score.add_stop()
            strings.gameover(screen,50,170)
            PLAYING.stop()
            death_BGM.play(-1)   

        if score.score == 0 and left_time <= 0:
            celemony.play(-1)

        pygame.display.update()

        for event in pygame.event.get():
            if event.type == QUIT:
                pygame.quit()
                sys.exit()
            if event.type == KEYDOWN:
                if event.key == K_ESCAPE:
                    pygame.quit()
                    sys.exit()
                if score.score == 20 or left_time <= 0:
                    if event.key == K_SPACE:
                        death_BGM.stop()    
                        celemony.stop()
                        clear.stop()
                        main()
                        
if __name__ == "__main__":
    main()