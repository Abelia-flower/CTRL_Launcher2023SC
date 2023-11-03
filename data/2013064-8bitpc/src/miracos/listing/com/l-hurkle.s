ca65 V2.16 - Ubuntu 2.16-2
Main file   : ./com/hurkle.s
Current file: ./com/hurkle.s

000000r 1               ; -------------------------------------------------------------------
000000r 1               ; テキストベースゲーム
000000r 1               ; -------------------------------------------------------------------
000000r 1               ; -------------------------------------------------------------------
000000r 1               .INCLUDE "../FXT65.inc"
000000r 2               ; FxT65のハードウェア構成を定義する
000000r 2               
000000r 2               .PC02 ; CMOS命令を許可
000000r 2               
000000r 2               RAMBASE = $0000
000000r 2               UARTBASE = $E000
000000r 2               VIABASE = $E200
000000r 2               YMZBASE = $E400
000000r 2               CRTCBASE = $E600
000000r 2               ROMBASE = $F000
000000r 2               
000000r 2               ; UART
000000r 2               .PROC UART
000000r 2                 RX = UARTBASE
000000r 2                 TX = UARTBASE
000000r 2                 STATUS = UARTBASE+1
000000r 2                 COMMAND = UARTBASE+2
000000r 2                 CONTROL = UARTBASE+3
000000r 2                 .PROC CMD
000000r 2                   ; PMC1/PMC0/PME/REM/TIC1/TIC0/IRD/DTR
000000r 2                   ; 全てゼロだと「エコーオフ、RTSオフ、割り込み有効、DTRオフ」
000000r 2                   RTS_ON =    %00001000
000000r 2                   ECHO_ON =   %00010000
000000r 2                   RIRQ_OFF =  %00000010
000000r 2                   DTR_ON =    %00000001
000000r 2                 .ENDPROC
000000r 2                 XON = $11
000000r 2                 XOFF = $13
000000r 2               .ENDPROC
000000r 2               
000000r 2               ; VIA
000000r 2               .PROC VIA
000000r 2                 PORTB = VIABASE
000000r 2                 PORTA = VIABASE+1
000000r 2                 DDRB = VIABASE+2
000000r 2                 DDRA = VIABASE+3
000000r 2                 T1CL = VIABASE+4
000000r 2                 T1CH = VIABASE+5
000000r 2                 T1LL = VIABASE+6
000000r 2                 T1LH = VIABASE+7
000000r 2                 SR = VIABASE+$A
000000r 2                 ACR = VIABASE+$B
000000r 2                 PCR = VIABASE+$C
000000r 2                 IFR = VIABASE+$D
000000r 2                 IER = VIABASE+$E
000000r 2                 IFR_IRQ = %10000000
000000r 2                 IER_SET = %10000000
000000r 2                 IFR_T1  = %01000000
000000r 2                 IFR_T2  = %00100000
000000r 2                 IFR_CB1 = %00010000
000000r 2                 IFR_CB2 = %00001000
000000r 2                 IFR_SR  = %00000100
000000r 2                 IFR_CA1 = %00000010
000000r 2                 IFR_CA2 = %00000001
000000r 2                 ; 新式
000000r 2                 SPI_REG    = PORTB
000000r 2                 SPI_DDR    = DDRB
000000r 2                 SPI_INOUT  = %10000000  ; 1=in, 0=out
000000r 2                 SPI_CS0    = %01000000
000000r 2                 PS2_REG    = PORTB
000000r 2                 PS2_DDR    = DDRB
000000r 2                 PS2_CLK    = %00100000
000000r 2                 PS2_DAT    = %00010000
000000r 2                 PAD_REG    = PORTB
000000r 2                 PAD_DDR    = DDRB
000000r 2                 PAD_CLK    = %00000100
000000r 2                 PAD_PTS    = %00000010
000000r 2                 PAD_DAT    = %00000001
000000r 2               .ENDPROC
000000r 2               
000000r 2               ; ChDz
000000r 2               .PROC CRTC
000000r 2                 CFG = CRTCBASE+$1   ; コンフィグ
000000r 2                                         ;   MD0 MD1 MD2 MD3 - - - WCUE
000000r 2                                         ;   MD : 色モード選択（各フレーム）
000000r 2                                         ;   WCUE  : 書き込みカウントアップ有効化
000000r 2               
000000r 2                 VMAH = CRTCBASE+$2  ; VRAM書き込みアドレス下位
000000r 2                                         ;   - 6 5 4 3 2 1 0
000000r 2               
000000r 2                 VMAV = CRTCBASE+$3  ; VRAM書き込みアドレス上位
000000r 2                                     ;   7 6 5 4 3 2 1 0
000000r 2               
000000r 2                 WDBF = CRTCBASE+$4  ; 書き込みデータ
000000r 2               
000000r 2                 RF  = CRTCBASE+$5   ; 出力フレーム選択
000000r 2                                     ;   (0) 1 0 | (1) 1 0 | (2) 1 0 | (3) 1 0
000000r 2               
000000r 2                 WF  = CRTCBASE+$6   ; 書き込みフレーム選択
000000r 2                                     ;   - - - - - - WF1 WF0
000000r 2               
000000r 2                 TCP  = CRTCBASE+$7  ; 2色モード色選択
000000r 2                                         ;   (0) 3 2 1 0 | (1) 3 2 1 0
000000r 2               .ENDPROC
000000r 2               
000000r 2               ; YMZ
000000r 2               .PROC YMZ
000000r 2                 ADDR = YMZBASE
000000r 2                 DATA = YMZBASE+1
000000r 2                 ; IR:Internal Address
000000r 2                 IA_FRQ = $00        ; 各チャンネル周波数
000000r 2                 IA_NOISE_FRQ = $06  ; ノイズ音周波数
000000r 2                 IA_MIX = $07        ; ミキサ設定
000000r 2                 IA_VOL = $08        ; 各チャンネル音量
000000r 2                 IA_EVLP_FRQ = $0B   ; エンベロープ周波数
000000r 2                 IA_EVLP_SHAPE = $0D ; エンベロープ形状
000000r 2               .ENDPROC
000000r 2               
000000r 2               
000000r 1               .INCLUDE "../generic.mac"
000000r 2               ; --- マクロ定義 ---
000000r 2               
000000r 2               ; loadmem16 T1_IRQ_VEC16,T1_IRQ
000000r 2               ; メモリに16bit定数をロードする
000000r 2               .macro loadmem16 mem,cons
000000r 2                 LDA #<(cons)
000000r 2                 STA mem
000000r 2                 LDA #>(cons)
000000r 2                 STA mem+1
000000r 2               .endmac
000000r 2               
000000r 2               .macro loadmem8l mem,cons
000000r 2                 LDA #<(cons)
000000r 2                 STA mem
000000r 2               .endmac
000000r 2               
000000r 2               ; regload16 T1_IRQ_VEC
000000r 2               ; Aに低位、Xに上位をロードする
000000r 2               .macro loadreg16 cons
000000r 2                 LDA #<(cons)
000000r 2                 LDX #>(cons)
000000r 2               .endmac
000000r 2               
000000r 2               ; Aに低位、Yに上位をロードする
000000r 2               .macro loadAY16 cons
000000r 2                 LDA #<(cons)
000000r 2                 LDY #>(cons)
000000r 2               .endmac
000000r 2               
000000r 2               .macro print  str_p
000000r 2                 loadreg16 str_p
000000r 2                 JSR MON::PRT_STR
000000r 2               .endmac
000000r 2               
000000r 2               ; AYをメモリに格納する
000000r 2               .macro storeAY16 dst
000000r 2                 STA dst
000000r 2                 STY dst+1
000000r 2               .endmac
000000r 2               
000000r 2               .macro mem2mem16 dst,src
000000r 2                 LDA src
000000r 2                 STA dst
000000r 2                 LDA src+1
000000r 2                 STA dst+1
000000r 2               .endmac
000000r 2               
000000r 2               .macro mem2AY16 src
000000r 2                 LDA src
000000r 2                 LDY src+1
000000r 2               .endmac
000000r 2               
000000r 2               .macro pushAY16
000000r 2                 PHA
000000r 2                 PHY
000000r 2               .endmac
000000r 2               
000000r 2               .macro pullAY16
000000r 2                 PLY
000000r 2                 PLA
000000r 2               .endmac
000000r 2               
000000r 2               .macro pushmem16 src
000000r 2                 LDA src
000000r 2                 PHA
000000r 2                 LDA src+1
000000r 2                 PHA
000000r 2               .endmac
000000r 2               
000000r 2               .macro pullmem16 src
000000r 2                 PLA
000000r 2                 STA src+1
000000r 2                 PLA
000000r 2                 STA src
000000r 2               .endmac
000000r 2               
000000r 2               
000000r 1               .INCLUDE "../fs/structfs.s"
000000r 2               ; ------------------
000000r 2               ; --- 構造体定義 ---
000000r 2               ; ------------------
000000r 2               .STRUCT DINFO
000000r 2                 ; 各ドライブ用変数
000000r 2                 BPB_SECPERCLUS    .RES 1
000000r 2                 PT_LBAOFS         .RES 4  ; セクタ番号
000000r 2                 FATSTART          .RES 4  ; セクタ番号
000000r 2                 DATSTART          .RES 4  ; セクタ番号
000000r 2                 BPB_ROOTCLUS      .RES 4  ; クラスタ番号
000000r 2               .ENDSTRUCT
000000r 2               
000000r 2               .STRUCT FCTRL
000000r 2                 ; 内部的FCB
000000r 2                 DRV_NUM           .RES 1  ; ドライブ番号
000000r 2                 HEAD              .RES 4  ; 先頭クラスタ
000000r 2                 CUR_CLUS          .RES 4  ; 現在クラスタ
000000r 2                 CUR_SEC           .RES 1  ; クラスタ内セクタ
000000r 2                 SIZ               .RES 4  ; サイズ
000000r 2                 SEEK_PTR          .RES 4  ; シーケンシャルアクセス用ポインタ
000000r 2               .ENDSTRUCT
000000r 2               
000000r 2               .STRUCT FINFO
000000r 2                 ; FIB、ファイル詳細情報を取得し、検索などに利用
000000r 2                 SIG               .RES 1  ; $FFシグネチャ、フルパス指定と区別
000000r 2                 NAME              .RES 13 ; 8.3ヌル終端
000000r 2                 ATTR              .RES 1  ; 属性
000000r 2                 WRTIME            .RES 2  ; 最終更新時刻
000000r 2                 WRDATE            .RES 2  ; 最終更新日時
000000r 2                 HEAD              .RES 4  ; 先頭クラスタ番号
000000r 2                 SIZ               .RES 4  ; ファイルサイズ
000000r 2                 ; 次を検索するためのデータ
000000r 2                 DRV_NUM           .RES 1  ; ドライブ番号
000000r 2                 DIR_CLUS          .RES 4  ; 親ディレクトリ現在クラスタ
000000r 2                 DIR_SEC           .RES 1  ; 親ディレクトリ現在クラスタ内セクタ
000000r 2                 DIR_ENT           .RES 1  ; セクタ内エントリ番号（SDSEEKの下位を右に1シフトしてMSBが後半フラグ
000000r 2               .ENDSTRUCT
000000r 2               
000000r 2               
000000r 1               .INCLUDE "../fscons.inc"
000000r 2               SD_STBITS = %01000000
000000r 2               SDCMD0_CRC = $95
000000r 2               SDCMD8_CRC = $87
000000r 2               
000000r 2               ; MBRオフセット
000000r 2               OFS_MBR_PARTBL = 446
000000r 2               ; 区画テーブルオフセット
000000r 2               OFS_PT_SYSTEMID = 4
000000r 2               OFS_PT_LBAOFS = 8
000000r 2               ; BIOSパラメータブロックオフセット
000000r 2               OFS_BPB_SECPERCLUS = 13 ; 1
000000r 2               OFS_BPB_RSVDSECCNT = 14 ; 2
000000r 2               OFS_BPB_FATSZ32 = 36    ; 4
000000r 2               OFS_BPB_ROOTCLUS = 44   ; 4
000000r 2               ; ディレクトリエントリオフセット
000000r 2               OFS_DIR_ATTR = 11       ; 1
000000r 2               OFS_DIR_FSTCLUSHI = 20  ; 2
000000r 2               OFS_DIR_WRTTIME = 22    ; 2
000000r 2               OFS_DIR_WRTDATE = 24    ; 2
000000r 2               OFS_DIR_FSTCLUSLO = 26  ; 2
000000r 2               OFS_DIR_FILESIZE = 28   ; 4
000000r 2               ; システム標識
000000r 2               SYSTEMID_FAT32 = $0B
000000r 2               SYSTEMID_FAT32NOCHS = $0C
000000r 2               ; ディレクトリエントリアトリビュート
000000r 2               DIRATTR_DIRECTORY = $10
000000r 2               DIRATTR_LONGNAME = $0F
000000r 2               
000000r 2               
000000r 1               .INCLUDE "../zr.inc"
000000r 2               ZR0 = $0000
000000r 2               ZR1 = $0002
000000r 2               ZR2 = $0004
000000r 2               ZR3 = $0006
000000r 2               ZR4 = $0008
000000r 2               ZR5 = $000A
000000r 2               
000000r 2               
000000r 1               .PROC BCOS
000000r 1                 .INCLUDE "../syscall.inc"  ; システムコール番号
000000r 2               ; コール場所
000000r 2               SYSCALL             = $0603
000000r 2               ; システムコールテーブル
000000r 2               RESET               = 0
000000r 2               CON_IN_CHR          = 1
000000r 2               CON_OUT_CHR         = 2
000000r 2               CON_RAWIN           = 3
000000r 2                 BHA_CON_RAWIN_GetState      = 0
000000r 2                 BHA_CON_RAWIN_NoWaitNoEcho  = 1
000000r 2                 BHA_CON_RAWIN_WaitAndNoEcho = 2
000000r 2               CON_OUT_STR         = 4
000000r 2               FS_OPEN             = 5
000000r 2               FS_CLOSE            = 6
000000r 2               CON_IN_STR          = 7
000000r 2               GCHR_COL            = 8
000000r 2               FS_FIND_FST         = 9
000000r 2               FS_PURSE            = 10
000000r 2               FS_CHDIR            = 11
000000r 2               FS_FPATH            = 12
000000r 2               ERR_GET             = 13
000000r 2               ERR_MES             = 14
000000r 2               UPPER_CHR           = 15
000000r 2               UPPER_STR           = 16
000000r 2               FS_FIND_NXT         = 17
000000r 2               FS_READ_BYTS        = 18
000000r 2               IRQ_SETHNDR_VB      = 19
000000r 2               GET_ADDR            = 20
000000r 2                 BHY_GET_ADDR_zprand16       = 0
000000r 2                 BHY_GET_ADDR_txtvram768     = 1*2
000000r 2                 BHY_GET_ADDR_font2048       = 2*2
000000r 2                 BHY_GET_ADDR_condevcfg      = 3*2
000000r 2               CON_INTERRUPT_CHR   = 21
000000r 2               TIMEOUT             = 22
000000r 2               
000000r 2               
000000r 1               .ENDPROC
000000r 1               .INCLUDE "../syscall.mac"
000000r 2               .macro syscall func
000000r 2                 LDX #(BCOS::func)*2
000000r 2                 JSR BCOS::SYSCALL
000000r 2               .endmac
000000r 2               
000000r 2               
000000r 1               
000000r 1               ; -------------------------------------------------------------------
000000r 1               ;                             定数宣言
000000r 1               ; -------------------------------------------------------------------
000000r 1               MAP_OFST = 10
000000r 1               
000000r 1               ; -------------------------------------------------------------------
000000r 1               ;                            ZP変数領域
000000r 1               ; -------------------------------------------------------------------
000000r 1               .ZEROPAGE
000000r 1  xx           ZX:       .RES 1  ; スペクトラム？
000001r 1  xx           ZY:       .RES 1
000002r 1  xx           HOME_X:   .RES 1
000003r 1  xx           HOME_Y:   .RES 1
000004r 1  xx           INPUT_X:  .RES 1
000005r 1  xx           INPUT_Y:  .RES 1
000006r 1  xx           HKL_X:    .RES 1
000007r 1  xx           HKL_Y:    .RES 1
000008r 1  xx           TIMES:    .RES 1
000009r 1  xx xx        ZP_RND_ADDR16:         .RES 2
00000Br 1               
00000Br 1               ; -------------------------------------------------------------------
00000Br 1               ;                             変数領域
00000Br 1               ; -------------------------------------------------------------------
00000Br 1               .BSS
000000r 1               
000000r 1               ; -------------------------------------------------------------------
000000r 1               ;                             実行領域
000000r 1               ; -------------------------------------------------------------------
000000r 1               .CODE
000000r 1               START:
000000r 1  A0 00          LDY #0
000002r 1  A2 28 20 03    syscall GET_ADDR
000006r 1  06           
000007r 1  85 rr 84 rr    storeAY16 ZP_RND_ADDR16
00000Br 1                 ; 変数初期化
00000Br 1  64 rr          STZ HOME_X
00000Dr 1  64 rr          STZ HOME_Y
00000Fr 1                 ; イントロ
00000Fr 1  A9 rr A0 rr    loadAY16 STR_INTRO
000013r 1  A2 08 20 03    syscall CON_OUT_STR
000017r 1  06           
000018r 1  20 rr rr       JSR PRT_MAP                 ; イントロ専用マップ
00001Br 1               GAME:
00001Br 1               @GAME:
00001Br 1                 ; 区切り線
00001Br 1  A9 rr A0 rr    loadAY16 STR_DOUBLE_LINE
00001Fr 1  A2 08 20 03    syscall CON_OUT_STR
000023r 1  06           
000024r 1                 ; コンティニュー選択
000024r 1  20 rr rr       JSR CONTINUE
000027r 1  90 01          BCC @SKP_EXT
000029r 1  60             RTS
00002Ar 1               @SKP_EXT:
00002Ar 1                 ; 変数初期化
00002Ar 1  20 rr rr       JSR GET_RND_D
00002Dr 1  85 rr          STA HKL_X
00002Fr 1  20 rr rr       JSR GET_RND_D
000032r 1  85 rr          STA HKL_Y
000034r 1  A9 01          LDA #1
000036r 1  85 rr          STA TIMES
000038r 1               @NEXT:
000038r 1                 ; 回数表示
000038r 1  A9 23          LDA #'#'
00003Ar 1  20 rr rr       JSR PRT_CHR
00003Dr 1  A5 rr          LDA TIMES
00003Fr 1  20 rr rr       JSR PRT_NUM
000042r 1  20 rr rr       JSR PRT_S
000045r 1                 ; 入力
000045r 1  20 rr rr       JSR INPUT
000048r 1  20 rr rr       JSR PRT_MAP
00004Br 1                 ; 正解判定
00004Br 1  A5 rr          LDA HOME_X
00004Dr 1  C5 rr          CMP HKL_X
00004Fr 1  D0 09          BNE @NE
000051r 1  A5 rr          LDA HOME_Y
000053r 1  C5 rr          CMP HKL_Y
000055r 1  D0 03          BNE @NE
000057r 1                 ; 正解
000057r 1  4C rr rr       JMP GAMECLEAR
00005Ar 1               @NE:
00005Ar 1                 ; 不正解
00005Ar 1  A9 rr A0 rr    loadAY16 STR_GO
00005Er 1  A2 08 20 03    syscall CON_OUT_STR         ; "Go "まで表示
000062r 1  06           
000063r 1                 ; North/South
000063r 1  A5 rr          LDA HOME_Y
000065r 1  C5 rr          CMP HKL_Y                   ; INPUT-HKL
000067r 1  F0 11          BEQ @SKP_ADVY
000069r 1                 ; Yが不正解
000069r 1  90 06          BCC @GO_NORTH               ; ボロー発生つまりHKLのほうがNにいる
00006Br 1               @GO_SOUTH:
00006Br 1  A9 rr A0 rr    loadAY16 STR_SOUTH
00006Fr 1  80 04          BRA @PRT_N_S
000071r 1               @GO_NORTH:
000071r 1  A9 rr A0 rr    loadAY16 STR_NORTH
000075r 1               @PRT_N_S:
000075r 1  A2 08 20 03    syscall CON_OUT_STR         ; "North"か"South"を出力
000079r 1  06           
00007Ar 1               @SKP_ADVY:
00007Ar 1                 ; West/East
00007Ar 1  A5 rr          LDA HOME_X
00007Cr 1  C5 rr          CMP HKL_X                   ; INPUT-HKL
00007Er 1  F0 11          BEQ @SKP_ADVX
000080r 1                 ; Xが不正解
000080r 1  90 06          BCC @GO_EAST               ; ボロー発生つまりHKLのほうがNにいる
000082r 1               @GO_WEST:
000082r 1  A9 rr A0 rr    loadAY16 STR_WEST
000086r 1  80 04          BRA @PRT_W_E
000088r 1               @GO_EAST:
000088r 1  A9 rr A0 rr    loadAY16 STR_EAST
00008Cr 1               @PRT_W_E:
00008Cr 1  A2 08 20 03    syscall CON_OUT_STR         ; "North"か"South"を出力
000090r 1  06           
000091r 1               @SKP_ADVX:
000091r 1  20 rr rr       JSR PRT_LF
000094r 1                 ; 更新
000094r 1  A5 rr          LDA TIMES
000096r 1  C9 05          CMP #5
000098r 1  D0 03          BNE @SKP_GAMEOVER
00009Ar 1  4C rr rr       JMP GAMEOVER
00009Dr 1               @SKP_GAMEOVER:
00009Dr 1  1A             INC
00009Er 1  85 rr          STA TIMES
0000A0r 1                 ; 区切り線
0000A0r 1  A9 rr A0 rr    loadAY16 STR_SINGLE_LINE
0000A4r 1  A2 08 20 03    syscall CON_OUT_STR
0000A8r 1  06           
0000A9r 1  80 8D          BRA @NEXT
0000ABr 1               @EXT:
0000ABr 1  60             RTS
0000ACr 1               
0000ACr 1               STR_INTRO:
0000ACr 1  0A           .BYT $A
0000ADr 1  3D 3D 3D 3D  .BYT "========THE HURKLE GAME=========",$A
0000B1r 1  3D 3D 3D 3D  
0000B5r 1  54 48 45 20  
0000CEr 1  20 20 20 41  .BYT "   A HURKLE is hiding on",$A
0000D2r 1  20 48 55 52  
0000D6r 1  4B 4C 45 20  
0000E7r 1  20 20 61 20  .BYT "  a 10x10 grid.",$A
0000EBr 1  31 30 78 31  
0000EFr 1  30 20 67 72  
0000F7r 1  20 20 20 47  .BYT "   Gridpoint is (0,0)...(9,9).",$A
0000FBr 1  72 69 64 70  
0000FFr 1  6F 69 6E 74  
000116r 1  20 20 20 48  .BYT "   Homebase is (0,0).",$A
00011Ar 1  6F 6D 65 62  
00011Er 1  61 73 65 20  
00012Cr 1  20 20 20 54  .BYT "   Try to guess the HURKLE's",$A
000130r 1  72 79 20 74  
000134r 1  6F 20 67 75  
000149r 1  20 20 67 72  .BYT "  gridpoint.",$A
00014Dr 1  69 64 70 6F  
000151r 1  69 6E 74 2E  
000156r 1  20 20 20 59  .BYT "   You can only try 5 times!",$A,$0
00015Ar 1  6F 75 20 63  
00015Er 1  61 6E 20 6F  
000174r 1               
000174r 1               STR_GO:
000174r 1  47 6F 20 00  .BYT "Go ",$0
000178r 1               STR_NORTH:
000178r 1  4E 6F 72 74  .BYT "North",$0
00017Cr 1  68 00        
00017Er 1               STR_SOUTH:
00017Er 1  53 6F 75 74  .BYT "South",$0
000182r 1  68 00        
000184r 1               STR_WEST:
000184r 1  57 65 73 74  .BYT "West",$0
000188r 1  00           
000189r 1               STR_EAST:
000189r 1  45 61 73 74  .BYT "East",$0
00018Dr 1  00           
00018Er 1               
00018Er 1               ; -------------------------------------------------------------------
00018Er 1               ;                          ゲームクリア
00018Er 1               ; -------------------------------------------------------------------
00018Er 1               GAMECLEAR:
00018Er 1  A9 rr A0 rr    loadAY16 STR_GAMECLEAR1
000192r 1  A2 08 20 03    syscall CON_OUT_STR
000196r 1  06           
000197r 1  A5 rr          LDA TIMES
000199r 1  20 rr rr       JSR PRT_NUM
00019Cr 1  A9 rr A0 rr    loadAY16 STR_GAMECLEAR2
0001A0r 1  A2 08 20 03    syscall CON_OUT_STR
0001A4r 1  06           
0001A5r 1  4C rr rr       JMP GAME
0001A8r 1               
0001A8r 1               STR_GAMECLEAR1:
0001A8r 1  0A           .BYT $A
0001A9r 1  2A 2A 2A 2A  .BYT "********************************"
0001ADr 1  2A 2A 2A 2A  
0001B1r 1  2A 2A 2A 2A  
0001C9r 1  2A 20 20 20  .BYT "*                              *"
0001CDr 1  20 20 20 20  
0001D1r 1  20 20 20 20  
0001E9r 1  2A 20 20 20  .BYT "*          GAME CLEAR!         *"
0001EDr 1  20 20 20 20  
0001F1r 1  20 20 20 47  
000209r 1  2A 20 20 59  .BYT "*  YOU FOUND HIM IN ",$0
00020Dr 1  4F 55 20 46  
000211r 1  4F 55 4E 44  
00021Er 1               
00021Er 1               STR_GAMECLEAR2:
00021Er 1  20 47 55 45  .BYT " GUESSES. *"
000222r 1  53 53 45 53  
000226r 1  2E 20 2A     
000229r 1  2A 20 20 20  .BYT "*                              *"
00022Dr 1  20 20 20 20  
000231r 1  20 20 20 20  
000249r 1  2A 2A 2A 2A  .BYT "********************************",$A,$0
00024Dr 1  2A 2A 2A 2A  
000251r 1  2A 2A 2A 2A  
00026Br 1               
00026Br 1               ; -------------------------------------------------------------------
00026Br 1               ;                          ゲームオーバー
00026Br 1               ; -------------------------------------------------------------------
00026Br 1               GAMEOVER:
00026Br 1  A9 rr A0 rr    loadAY16 STR_GAMEOVER
00026Fr 1  A2 08 20 03    syscall CON_OUT_STR
000273r 1  06           
000274r 1  A5 rr          LDA HKL_X
000276r 1  85 rr          STA HOME_X
000278r 1  A5 rr          LDA HKL_Y
00027Ar 1  85 rr          STA HOME_Y
00027Cr 1  20 rr rr       JSR PRT_MAP
00027Fr 1  4C rr rr       JMP GAME
000282r 1               
000282r 1               STR_GAMEOVER:
000282r 1  0A           .BYT $A
000283r 1  2A 2A 2A 2A  .BYT "********************************"
000287r 1  2A 2A 2A 2A  
00028Br 1  2A 2A 2A 2A  
0002A3r 1  2A 20 20 20  .BYT "*                              *"
0002A7r 1  20 20 20 20  
0002ABr 1  20 20 20 20  
0002C3r 1  2A 20 47 41  .BYT "* GAME OVER! 5 GUESSES FAILED. *"
0002C7r 1  4D 45 20 4F  
0002CBr 1  56 45 52 21  
0002E3r 1  2A 20 20 20  .BYT "*                              *"
0002E7r 1  20 20 20 20  
0002EBr 1  20 20 20 20  
000303r 1  2A 2A 2A 2A  .BYT "********************************",$A
000307r 1  2A 2A 2A 2A  
00030Br 1  2A 2A 2A 2A  
000324r 1  54 68 65 20  .BYT "The HURKLE is at",$A,$0
000328r 1  48 55 52 4B  
00032Cr 1  4C 45 20 69  
000336r 1               
000336r 1               ; -------------------------------------------------------------------
000336r 1               ;                           コンチヌー
000336r 1               ; -------------------------------------------------------------------
000336r 1               ; ESCならC=1
000336r 1               ; -------------------------------------------------------------------
000336r 1               CONTINUE:
000336r 1  A9 rr A0 rr    loadAY16 STR_CONTINUE
00033Ar 1  A2 08 20 03    syscall CON_OUT_STR
00033Er 1  06           
00033Fr 1               @CONTINUE_IN:
00033Fr 1  A9 01          LDA #$1                   ; エコーなし入力
000341r 1  A2 06 20 03    syscall CON_RAWIN
000345r 1  06           
000346r 1  C9 1B          CMP #$1B                  ; ESC
000348r 1  D0 02          BNE @SKP_ESC
00034Ar 1  38             SEC
00034Br 1  60             RTS
00034Cr 1               @SKP_ESC:
00034Cr 1  C9 0A          CMP #$A                   ; Enter
00034Er 1  D0 EF          BNE @CONTINUE_IN
000350r 1  20 rr rr       JSR PRT_LF
000353r 1  18             CLC
000354r 1  60             RTS
000355r 1               
000355r 1               STR_CONTINUE:
000355r 1  3E 43 6F 6E  .BYT ">Continue or Quit? (Enter/ESC)",$0
000359r 1  74 69 6E 75  
00035Dr 1  65 20 6F 72  
000374r 1               
000374r 1               ; -------------------------------------------------------------------
000374r 1               ;                              入力
000374r 1               ; -------------------------------------------------------------------
000374r 1               INPUT:
000374r 1  A9 rr A0 rr    loadAY16 STR_INPUT
000378r 1  A2 08 20 03    syscall CON_OUT_STR       ; 入力プロンプト
00037Cr 1  06           
00037Dr 1  20 rr rr       JSR INPUT_NUM             ; 数字のみ受け付け
000380r 1  B0 1F          BCS LF_INPUT
000382r 1  85 rr          STA INPUT_X
000384r 1  A9 2C          LDA #','
000386r 1  20 rr rr       JSR PRT_CHR
000389r 1  20 rr rr       JSR INPUT_NUM             ; 数字のみ受け付け
00038Cr 1  B0 13          BCS LF_INPUT
00038Er 1  85 rr          STA INPUT_Y
000390r 1  A9 29          LDA #')'
000392r 1  20 rr rr       JSR PRT_CHR
000395r 1  20 rr rr       JSR PRT_LF
000398r 1                 ; 入力を現在地に
000398r 1  A5 rr          LDA INPUT_X
00039Ar 1  85 rr          STA HOME_X
00039Cr 1  A5 rr          LDA INPUT_Y
00039Er 1  85 rr          STA HOME_Y
0003A0r 1  60             RTS
0003A1r 1               
0003A1r 1               LF_INPUT:
0003A1r 1  20 rr rr       JSR PRT_LF
0003A4r 1  80 CE          BRA INPUT
0003A6r 1               
0003A6r 1               ; -------------------------------------------------------------------
0003A6r 1               ;                         10進一桁の入力
0003A6r 1               ; -------------------------------------------------------------------
0003A6r 1               INPUT_NUM:
0003A6r 1  A9 01          LDA #$1                   ; エコーなし入力
0003A8r 1  A2 06 20 03    syscall CON_RAWIN
0003ACr 1  06           
0003ADr 1  C9 1B          CMP #$1B                  ; ESC
0003AFr 1  D0 02          BNE @SKP_ESC
0003B1r 1  38             SEC
0003B2r 1  60             RTS
0003B3r 1               @SKP_ESC:
0003B3r 1  C9 30          CMP #'0'
0003B5r 1  90 EF          BCC INPUT_NUM             ; A<'0'
0003B7r 1  C9 3A          CMP #'9'+1
0003B9r 1  B0 EB          BCS INPUT_NUM             ; A>='9'+1
0003BBr 1  48             PHA
0003BCr 1  A2 04 20 03    syscall CON_OUT_CHR
0003C0r 1  06           
0003C1r 1  68             PLA
0003C2r 1  29 0F          AND #$0F                  ; 内部表現に
0003C4r 1  18             CLC
0003C5r 1  60             RTS
0003C6r 1               
0003C6r 1               STR_INPUT:
0003C6r 1  3E 57 68 61  .BYT ">What is your guess? (",$0
0003CAr 1  74 20 69 73  
0003CEr 1  20 79 6F 75  
0003DDr 1               
0003DDr 1               ; -------------------------------------------------------------------
0003DDr 1               ;                          グリッドの表示
0003DDr 1               ; -------------------------------------------------------------------
0003DDr 1               PRT_MAP:
0003DDr 1                 ; N
0003DDr 1  20 rr rr       JSR PRT_MAP_OFST
0003E0r 1  A9 rr A0 rr    loadAY16 STR_N
0003E4r 1  A2 08 20 03    syscall CON_OUT_STR
0003E8r 1  06           
0003E9r 1                 ; グリッドYループ
0003E9r 1  A9 09          LDA #9
0003EBr 1  85 rr          STA ZY
0003EDr 1               @GY_LOOP:
0003EDr 1  20 rr rr       JSR PRT_MAP_OFST        ; オフセット表示
0003F0r 1  A5 rr          LDA ZY                  ; Yの値を取得
0003F2r 1  C9 04          CMP #4                  ; 中心であるところの4か
0003F4r 1  D0 0B          BNE @SKP_W
0003F6r 1  A9 rr A0 rr    loadAY16 STR_W
0003FAr 1  A2 08 20 03    syscall CON_OUT_STR
0003FEr 1  06           
0003FFr 1  A5 rr          LDA ZY                  ; Yの値を取得
000401r 1               @SKP_W:
000401r 1  20 rr rr       JSR PRT_NUM             ; Yの値を10進表示
000404r 1                 ; グリッドXループ
000404r 1  A2 00          LDX #0                  ; X初期化
000406r 1               @GX_LOOP:
000406r 1  E4 rr          CPX HOME_X              ; 座標Xチェック
000408r 1  D0 0A          BNE @SKP_HIT
00040Ar 1  A5 rr          LDA ZY
00040Cr 1  C5 rr          CMP HOME_Y              ; 座標Yチェック
00040Er 1  D0 04          BNE @SKP_HIT
000410r 1                 ; 現在座標である
000410r 1  A9 2A          LDA #'*'
000412r 1  80 02          BRA @SKP_PLUS
000414r 1               @SKP_HIT:
000414r 1  A9 2B          LDA #'+'                ; グリッド文字
000416r 1               @SKP_PLUS:
000416r 1  DA             PHX
000417r 1  20 rr rr       JSR PRT_CHR             ; グリッド文字を出力
00041Ar 1  FA             PLX
00041Br 1  E8             INX
00041Cr 1  E0 0A          CPX #$A
00041Er 1  D0 E6          BNE @GX_LOOP
000420r 1  A5 rr          LDA ZY                  ; Yの値を取得
000422r 1  C9 04          CMP #4                  ; 中心であるところの4か
000424r 1  D0 09          BNE @SKP_E
000426r 1  A9 rr A0 rr    loadAY16 STR_E
00042Ar 1  A2 08 20 03    syscall CON_OUT_STR
00042Er 1  06           
00042Fr 1               @SKP_E:
00042Fr 1  20 rr rr       JSR PRT_LF              ; 改行
000432r 1  C6 rr          DEC ZY
000434r 1  10 B7          BPL @GY_LOOP
000436r 1  20 rr rr       JSR PRT_S               ; 空白を表示
000439r 1                 ; 目盛りXループ
000439r 1  20 rr rr       JSR PRT_MAP_OFST        ; オフセット表示
00043Cr 1  A9 00          LDA #0
00043Er 1               @MX_LOOP:
00043Er 1  48             PHA
00043Fr 1  20 rr rr       JSR PRT_NUM
000442r 1  68             PLA
000443r 1  1A             INC
000444r 1  C9 0A          CMP #$A
000446r 1  D0 F6          BNE @MX_LOOP
000448r 1  20 rr rr       JSR PRT_LF
00044Br 1                 ; S
00044Br 1  20 rr rr       JSR PRT_MAP_OFST
00044Er 1  A9 rr A0 rr    loadAY16 STR_S
000452r 1  A2 08 20 03    syscall CON_OUT_STR
000456r 1  06           
000457r 1  60             RTS
000458r 1               
000458r 1               STR_N:
000458r 1  20 20 20 20  .BYT "    (N)",$A,$0
00045Cr 1  28 4E 29 0A  
000460r 1  00           
000461r 1               STR_S:
000461r 1  20 20 20 20  .BYT "    (S)",$A,$0
000465r 1  28 53 29 0A  
000469r 1  00           
00046Ar 1               STR_W:
00046Ar 1  08 08 08 28  .BYT $8,$8,$8,"(W)",$0
00046Er 1  57 29 00     
000471r 1               STR_E:
000471r 1  28 45 29 00  .BYT "(E)",$0
000475r 1               
000475r 1               STR_SINGLE_LINE:
000475r 1  2D 2D 2D 2D  .BYT "--------------------------------",$0
000479r 1  2D 2D 2D 2D  
00047Dr 1  2D 2D 2D 2D  
000496r 1               STR_DOUBLE_LINE:
000496r 1  3D 3D 3D 3D  .BYT "================================",$0
00049Ar 1  3D 3D 3D 3D  
00049Er 1  3D 3D 3D 3D  
0004B7r 1               
0004B7r 1               ; -------------------------------------------------------------------
0004B7r 1               ;                     グリッド左オフセットの表示
0004B7r 1               ; -------------------------------------------------------------------
0004B7r 1               PRT_MAP_OFST:
0004B7r 1  A9 rr A0 rr    loadAY16 STR_OFST
0004BBr 1  A2 08 20 03    syscall CON_OUT_STR
0004BFr 1  06           
0004C0r 1  60             RTS
0004C1r 1               
0004C1r 1               STR_OFST:
0004C1r 1  20 20 20 20  .REPEAT MAP_OFST
0004C5r 1  20 20 20 20  
0004C9r 1  20 20        
0004CBr 1                 .BYT " "
0004CBr 1               .ENDREPEAT
0004CBr 1  00           .BYT $0
0004CCr 1               
0004CCr 1               ; -------------------------------------------------------------------
0004CCr 1               ;                             10進1桁表示
0004CCr 1               ; -------------------------------------------------------------------
0004CCr 1               PRT_NUM:
0004CCr 1  29 0F          AND #$0F
0004CEr 1  09 30          ORA #$30
0004D0r 1               PRT_CHR:
0004D0r 1  A2 04 20 03    syscall CON_OUT_CHR
0004D4r 1  06           
0004D5r 1  60             RTS
0004D6r 1               
0004D6r 1               ; -------------------------------------------------------------------
0004D6r 1               ;                              改行表示
0004D6r 1               ; -------------------------------------------------------------------
0004D6r 1               PRT_LF:
0004D6r 1  A9 0A          LDA #$A
0004D8r 1  80 F6          BRA PRT_CHR
0004DAr 1               
0004DAr 1               ; -------------------------------------------------------------------
0004DAr 1               ;                              空白表示
0004DAr 1               ; -------------------------------------------------------------------
0004DAr 1               PRT_S:
0004DAr 1  A9 20          LDA #' '
0004DCr 1  80 F2          BRA PRT_CHR
0004DEr 1               
0004DEr 1               ; -------------------------------------------------------------------
0004DEr 1               ;                           10進1桁乱数取得
0004DEr 1               ; -------------------------------------------------------------------
0004DEr 1               GET_RND_D:
0004DEr 1               X5PLUS1RETRY:
0004DEr 1  B2 rr          LDA (ZP_RND_ADDR16)
0004E0r 1  0A             ASL
0004E1r 1  0A             ASL
0004E2r 1  38             SEC ;+1
0004E3r 1  72 rr          ADC (ZP_RND_ADDR16)
0004E5r 1  92 rr          STA (ZP_RND_ADDR16)
0004E7r 1  29 0F          AND #$0F
0004E9r 1  C9 0F          CMP #$0F
0004EBr 1  F0 F1          BEQ X5PLUS1RETRY    ;ハイ次！
0004EDr 1  C9 0A          CMP #$0A
0004EFr 1  30 11          BMI SKIP_DECIMALIZE ;Aが比較する値よりも小さい場合はNが立ち
0004F1r 1  0A             ASL
0004F2r 1  48             PHA
0004F3r 1  B2 rr          LDA (ZP_RND_ADDR16)
0004F5r 1  0A             ASL
0004F6r 1  92 rr          STA (ZP_RND_ADDR16)
0004F8r 1  68             PLA
0004F9r 1  E9 13          SBC #$13            ;深遠なる理由で$13of$14を引くとよい
0004FBr 1  48             PHA
0004FCr 1  B2 rr          LDA (ZP_RND_ADDR16)
0004FEr 1  6A             ROR
0004FFr 1  92 rr          STA (ZP_RND_ADDR16)
000501r 1  68             PLA
000502r 1               SKIP_DECIMALIZE:
000502r 1  29 0F          AND #$0F
000504r 1  60             RTS
000505r 1               
000505r 1               ; -------------------------------------------------------------------
000505r 1               ;                             データ領域
000505r 1               ; -------------------------------------------------------------------
000505r 1               .DATA
000000r 1               
000000r 1               
