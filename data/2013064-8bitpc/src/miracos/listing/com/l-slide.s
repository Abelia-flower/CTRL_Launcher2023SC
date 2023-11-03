ca65 V2.16 - Ubuntu 2.16-2
Main file   : ./com/slide.s
Current file: ./com/slide.s

000000r 1               ; -------------------------------------------------------------------
000000r 1               ;                           MOVIEコマンド
000000r 1               ; -------------------------------------------------------------------
000000r 1               ; 連番画像連続表示
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
000000r 1               IMAGE_BUFFER_SECS = 32 ; 何セクタをバッファに使うか？ 48の約数
000000r 1               
000000r 1               ; -------------------------------------------------------------------
000000r 1               ;                               ZP領域
000000r 1               ; -------------------------------------------------------------------
000000r 1               .ZEROPAGE
000000r 1  xx             ZP_TMP_X:         .RES 1
000001r 1  xx             ZP_TMP_Y:         .RES 1
000002r 1  xx             ZP_TMP_X_DEST:    .RES 1
000003r 1  xx             ZP_TMP_Y_DEST:    .RES 1
000004r 1  xx xx          ZP_READ_VEC16:    .RES 2
000006r 1  xx             ZP_VMAV:          .RES 1
000007r 1  xx             ZP_VISIBLE_FLAME: .RES 1  ; 可視フレーム
000008r 1  xx xx          ZP_IMAGE_NUM16:   .RES 2  ; いま何枚目？1..
00000Ar 1               
00000Ar 1               ; -------------------------------------------------------------------
00000Ar 1               ;                              変数領域
00000Ar 1               ; -------------------------------------------------------------------
00000Ar 1               .BSS
000000r 1  xx xx xx xx    TEXT:           .RES 512*IMAGE_BUFFER_SECS
000004r 1  xx xx xx xx  
000008r 1  xx xx xx xx  
004000r 1  xx             FD_SAV:         .RES 1  ; ファイル記述子
004001r 1  xx xx          FINFO_SAV:      .RES 2  ; FINFO
004003r 1               
004003r 1               ; -------------------------------------------------------------------
004003r 1               ;                             実行領域
004003r 1               ; -------------------------------------------------------------------
004003r 1               .macro init_crtc
004003r 1                 ; CRTCを初期化
004003r 1                 ; コンフィグレジスタの設定
004003r 1                 LDA #%00000001            ; 全内部行を16色モード、書き込みカウントアップ有効、16色モード座標
004003r 1                 STA CRTC::CFG
004003r 1                 ; 塗りつぶし
004003r 1                 ; f0
004003r 1                 STZ CRTC::WF
004003r 1                 LDA #$FF
004003r 1                 JSR FILL
004003r 1                 ; f1
004003r 1                 LDA #$1
004003r 1                 STA CRTC::WF
004003r 1                 LDA #$FF
004003r 1                 JSR FILL
004003r 1                 ; 表示フレーム
004003r 1                 LDA #%01010101
004003r 1                 STA ZP_VISIBLE_FLAME
004003r 1                 STA CRTC::RF
004003r 1                 ; 書き込みフレーム
004003r 1                 LDA #%10101010
004003r 1                 STA CRTC::WF
004003r 1               .endmac
004003r 1               
004003r 1               .CODE
000000r 1               START:
000000r 1                 ; コマンドライン引数を受け付けない
000000r 1                 ; 初期化
000000r 1  A9 01 8D 01    init_crtc                       ; crtcの初期化
000004r 1  E6 9C 06 E6  
000008r 1  A9 FF 20 rr  
000023r 1               @MOVIE_LOOP:
000023r 1  A9 01 85 rr    loadmem16 ZP_IMAGE_NUM16,0001   ; 0001から始める
000027r 1  A9 00 85 rr  
00002Br 1  A9 30          LDA #'0'
00002Dr 1  8D rr rr       STA PATH_FNAME
000030r 1  8D rr rr       STA PATH_FNAME+1
000033r 1  8D rr rr       STA PATH_FNAME+2
000036r 1  1A             INC
000037r 1  8D rr rr       STA PATH_FNAME+3
00003Ar 1                 ; ファイルオープン
00003Ar 1               @NEXT_IMAGE:
00003Ar 1  A9 rr A0 rr    loadAY16 PATH_FNAME
00003Er 1  A2 12 20 03    syscall FS_FIND_FST             ; 検索
000042r 1  06           
000043r 1  90 0B          BCC @SKP_NOTFOUND2
000045r 1               @NOTFOUND2:
000045r 1                 ; 画像ファイルが見つからない！
000045r 1  C6 rr          DEC ZP_IMAGE_NUM16              ; 一桁目をデクリメント
000047r 1  A5 rr          LDA ZP_IMAGE_NUM16
000049r 1  05 rr          ORA ZP_IMAGE_NUM16+1            ; 二桁目とOR
00004Br 1  D0 D6          BNE @MOVIE_LOOP                 ; 途中で途切れたのであればループする
00004Dr 1  4C rr rr       JMP NOTFOUND                    ; 0001が見つからないのであればこの世の終わり
000050r 1               @SKP_NOTFOUND2:
000050r 1                 ; 画像ファイルが存在する！
000050r 1  8D rr rr 8C    storeAY16 FINFO_SAV             ; FINFOを格納
000054r 1  rr rr        
000056r 1  A2 0A 20 03    syscall FS_OPEN                 ; ファイルをオープン
00005Ar 1  06           
00005Br 1  B0 E8          BCS @NOTFOUND2                  ; オープンできなかったらあきらめる
00005Dr 1  8D rr rr       STA FD_SAV                      ; ファイル記述子をセーブ
000060r 1  64 rr          STZ ZP_VMAV
000062r 1               @IMAGE_LOOP:
000062r 1                 ; ロード
000062r 1  AD rr rr       LDA FD_SAV
000065r 1  85 02          STA ZR1                         ; 規約、ファイル記述子はZR1！
000067r 1  A9 rr 85 00    loadmem16 ZR0,TEXT              ; 書き込み先
00006Br 1  A9 rr 85 01  
00006Fr 1  A9 00 A0 40    loadAY16 512*IMAGE_BUFFER_SECS  ; 数セクタをバッファに読み込み
000073r 1  A2 24 20 03    syscall FS_READ_BYTS            ; ロード
000077r 1  06           
000078r 1  B0 37          BCS @CLOSE
00007Ar 1                 ; 読み取ったセクタ数をバッファ出力ループのイテレータに
00007Ar 1  98             TYA
00007Br 1  4A             LSR
00007Cr 1  AA             TAX
00007Dr 1                 ; バッファ出力
00007Dr 1                 ; 書き込み座標リセット
00007Dr 1  A5 rr          LDA ZP_VMAV
00007Fr 1  8D 03 E6       STA CRTC::VMAV
000082r 1  9C 02 E6       STZ CRTC::VMAH
000085r 1  A9 rr 85 rr    loadmem16 ZP_READ_VEC16, TEXT
000089r 1  A9 rr 85 rr  
00008Dr 1                 ; バッファ出力ループ
00008Dr 1                 ;LDX #IMAGE_BUFFER_SECS
00008Dr 1               @BUFFER_LOOP:
00008Dr 1                 ; 256バイト出力ループx2
00008Dr 1                 ; 前編
00008Dr 1  A0 00          LDY #0
00008Fr 1               @PAGE_LOOP:
00008Fr 1  B1 rr          LDA (ZP_READ_VEC16),Y
000091r 1  8D 04 E6       STA CRTC::WDBF
000094r 1  C8             INY
000095r 1  D0 F8          BNE @PAGE_LOOP
000097r 1  E6 rr          INC ZP_READ_VEC16+1             ; 読み取りポイント更新
000099r 1                 ; 後編
000099r 1  A0 00          LDY #0
00009Br 1               @PAGE_LOOP2:
00009Br 1  B1 rr          LDA (ZP_READ_VEC16),Y
00009Dr 1  8D 04 E6       STA CRTC::WDBF
0000A0r 1  C8             INY
0000A1r 1  D0 F8          BNE @PAGE_LOOP2
0000A3r 1  E6 rr          INC ZP_READ_VEC16+1             ; 読み取りポイント更新
0000A5r 1                 ; 512バイト出力終了
0000A5r 1  CA             DEX
0000A6r 1  D0 E5          BNE @BUFFER_LOOP
0000A8r 1                 ; バッファ出力終了
0000A8r 1                 ; 垂直アドレスの更新
0000A8r 1                 ; 512バイトは4行に相当する
0000A8r 1  18             CLC
0000A9r 1  A5 rr          LDA ZP_VMAV
0000ABr 1  69 80          ADC #4*IMAGE_BUFFER_SECS
0000ADr 1  85 rr          STA ZP_VMAV
0000AFr 1  80 B1          BRA @IMAGE_LOOP
0000B1r 1                 ; 最終バイトがあるとき
0000B1r 1                 ; クローズ
0000B1r 1               @CLOSE:
0000B1r 1  AD rr rr       LDA FD_SAV
0000B4r 1  A2 0C 20 03    syscall FS_CLOSE                ; クローズ
0000B8r 1  06           
0000B9r 1  B0 43          BCS BCOS_ERROR
0000BBr 1                 ; キー待機
0000BBr 1                 ;LDA #BCOS::BHA_CON_RAWIN_WaitAndNoEcho  ; キー入力待機
0000BBr 1                 ;syscall CON_RAWIN
0000BBr 1                 ;RTS
0000BBr 1               @PICINC:
0000BBr 1                 ; 探す画像の番号を増やす
0000BBr 1  E6 rr          INC ZP_IMAGE_NUM16
0000BDr 1  D0 02          BNE @SKP_IMAGENUMH
0000BFr 1  E6 rr          INC ZP_IMAGE_NUM16+1
0000C1r 1               @SKP_IMAGENUMH:
0000C1r 1  A0 04          LDY #4
0000C3r 1  A9 rr 85 00    loadmem16 ZR0,(PATH_FNAME-1)
0000C7r 1  A9 rr 85 01  
0000CBr 1  A9 01          LDA #1
0000CDr 1  20 rr rr       JSR D_ADD_BYT
0000D0r 1               @SWAP_FLAME:
0000D0r 1                 ; フレーム交換
0000D0r 1  A5 rr          LDA ZP_VISIBLE_FLAME
0000D2r 1  8D 06 E6       STA CRTC::WF
0000D5r 1  18             CLC
0000D6r 1  2A             ROL ; %01010101と%10101010を交換する
0000D7r 1  69 00          ADC #0
0000D9r 1  85 rr          STA ZP_VISIBLE_FLAME
0000DBr 1  8D 05 E6       STA CRTC::RF
0000DEr 1  4C rr rr       JMP @NEXT_IMAGE
0000E1r 1               
0000E1r 1               D_ADD_BYT:
0000E1r 1                 ; Y桁の十進数にアキュムレータを足す
0000E1r 1  18             CLC
0000E2r 1               @LOOP:
0000E2r 1  71 00          ADC (ZR0),Y
0000E4r 1  18             CLC
0000E5r 1  C9 3A          CMP #'9'+1
0000E7r 1  D0 03          BNE @skpyon
0000E9r 1  38             SEC
0000EAr 1  A9 30          LDA #'0'
0000ECr 1               @skpyon:
0000ECr 1  91 00          STA (ZR0),Y
0000EEr 1  A9 00          LDA #0
0000F0r 1  88             DEY
0000F1r 1  D0 EF          BNE @LOOP
0000F3r 1  60             RTS
0000F4r 1               
0000F4r 1               NOTFOUND:
0000F4r 1  A9 rr A0 rr    loadAY16 STR_NOTFOUND
0000F8r 1  A2 08 20 03    syscall CON_OUT_STR
0000FCr 1  06           
0000FDr 1  60             RTS
0000FEr 1               
0000FEr 1               BCOS_ERROR:
0000FEr 1  20 rr rr       JSR PRT_LF
000101r 1  A2 1A 20 03    syscall ERR_GET
000105r 1  06           
000106r 1  A2 1C 20 03    syscall ERR_MES
00010Ar 1  06           
00010Br 1  60             RTS
00010Cr 1               
00010Cr 1               ;PRT_BYT:
00010Cr 1               ;  JSR BYT2ASC
00010Cr 1               ;  PHY
00010Cr 1               ;  JSR PRT_C_CALL
00010Cr 1               ;  PLA
00010Cr 1               PRT_C_CALL:
00010Cr 1  A2 04 20 03    syscall CON_OUT_CHR
000110r 1  06           
000111r 1  60             RTS
000112r 1               
000112r 1               PRT_LF:
000112r 1                 ; 改行
000112r 1  A9 0A          LDA #$A
000114r 1  4C rr rr       JMP PRT_C_CALL
000117r 1               
000117r 1               ; 画面全体をAの値で埋め尽くす
000117r 1               FILL:
000117r 1  A0 00          LDY #$00
000119r 1  8C 03 E6       STY CRTC::VMAV
00011Cr 1  8C 02 E6       STY CRTC::VMAH
00011Fr 1  A0 C0          LDY #$C0
000121r 1               FILL_LOOP_V:
000121r 1  A2 80          LDX #$80
000123r 1               FILL_LOOP_H:
000123r 1  8D 04 E6       STA CRTC::WDBF
000126r 1  CA             DEX
000127r 1  D0 FA          BNE FILL_LOOP_H
000129r 1  88             DEY
00012Ar 1  D0 F5          BNE FILL_LOOP_V
00012Cr 1  60             RTS
00012Dr 1               
00012Dr 1               STR_NOTFOUND:
00012Dr 1  4D 6F 76 69    .BYT "Movie Images Not Found.",$A,$0
000131r 1  65 20 49 6D  
000135r 1  61 67 65 73  
000146r 1               
000146r 1               PATH_FNAME:
000146r 1  30 30 30 31    .BYT "0001.???",$0
00014Ar 1  2E 3F 3F 3F  
00014Er 1  00           
00014Fr 1               
00014Fr 1               
