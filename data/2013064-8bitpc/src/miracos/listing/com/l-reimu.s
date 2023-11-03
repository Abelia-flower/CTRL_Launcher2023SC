ca65 V2.16 - Ubuntu 2.16-2
Main file   : ./com/reimu.s
Current file: ./com/reimu.s

000000r 1               ; -------------------------------------------------------------------
000000r 1               ; reimu
000000r 1               ; -------------------------------------------------------------------
000000r 1               ; ChDzUtlのanim.s
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
000000r 2                 SR = VIABASE+$A
000000r 2                 ACR = VIABASE+$B
000000r 2                 PCR = VIABASE+$C
000000r 2                 IFR = VIABASE+$D
000000r 2                 IER = VIABASE+$E
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
000000r 1               ; --- 定数定義 ---
000000r 1               BGC = $00
000000r 1               DEBUG_BGC = $88
000000r 1               PLAYER_SPEED = 1
000000r 1               PLAYER_SHOOTRATE = 8
000000r 1               PLBLT_SPEED = 8
000000r 1               PLAYER_X = 31 ; 30だと現象が起こるが表示は同じ
000000r 1               
000000r 1               ; -------------------------------------------------------------------
000000r 1               ;                               ZP領域
000000r 1               ; -------------------------------------------------------------------
000000r 1               .ZEROPAGE
000000r 1  xx             ZP_TMP_X:           .RES 1        ; X座標汎用
000001r 1  xx             ZP_TMP_Y:           .RES 1        ; Y座標汎用
000002r 1  xx             ZP_VISIBLE_FLAME:   .RES 1        ; 可視フレームバッファ
000003r 1  xx xx          ZP_BLACKLIST_PTR:   .RES 2        ; 塗りつぶしリスト用のポインタ
000005r 1  xx xx          ZP_CHAR_PTR:        .RES 2        ; キャラクタデータ用のポインタ
000007r 1  xx             ZP_PLAYER_X:        .RES 1        ; プレイヤ座標
000008r 1  xx             ZP_PLAYER_Y:        .RES 1
000009r 1  xx             ZP_ANT_NZ_Y:        .RES 1        ; アンチ・ノイズY座標
00000Ar 1  xx             ZP_DX:              .RES 1        ; プレイヤX軸速度
00000Br 1  xx             ZP_DY:              .RES 1        ; プレイヤY軸速度
00000Cr 1  xx             ZP_PL_COOLDOWN:     .RES 1
00000Dr 1  xx             ZP_BL_INDEX:        .RES 1        ; ブラックリストのYインデックス退避
00000Er 1  xx             ZP_PLBLT_TERMPTR:   .RES 1        ; BLT_PL_LSTの終端を指す
00000Fr 1  xx             ZP_ENEM1_TERMPTR:   .RES 1        ; BLT_PL_LSTの終端を指す
000010r 1                 ; SNESPAD
000010r 1  xx xx          ZP_PADSTAT:         .RES 2        ; ゲームパッドの状態が収まる
000012r 1  xx             ZP_SHIFTER:         .RES 1        ; ゲームパッド読み取り処理用
000013r 1                 ; VBLANK
000013r 1  xx xx          ZP_VB_STUB:         .RES 2        ; 割り込み終了処理
000015r 1                 ; SOUND
000015r 1  xx             ZP_SE_STATE:        .RES 1        ; 効果音の状態
000016r 1  xx             ZP_SE_TIMER:        .RES 1
000017r 1               
000017r 1               ; -------------------------------------------------------------------
000017r 1               ;                              変数領域
000017r 1               ; -------------------------------------------------------------------
000017r 1               .BSS
000000r 1  xx             FD_SAV:         .RES 1  ; ファイル記述子
000001r 1  xx xx          FINFO_SAV:      .RES 2  ; FINFO
000003r 1               
000003r 1                 ; ブラックに塗りつぶすべき座標のリスト（命名がわるい
000003r 1                 ; 2バイトで座標が表現され、それを原点に8x8が黒で塗られる
000003r 1                 ; $FFが番人
000003r 1                 ; X,Y,X,Y,..,$FF
000003r 1                 ; 二つのリストは、アライメントせずとも隣接すべし
000003r 1  xx xx xx xx    BLACKLIST1:     .RES 256
000007r 1  xx xx xx xx  
00000Br 1  xx xx xx xx  
000103r 1  xx xx xx xx    BLACKLIST2:     .RES 256
000107r 1  xx xx xx xx  
00010Br 1  xx xx xx xx  
000203r 1                 ; プレイヤの発射した弾丸
000203r 1                 ; 位置だけを保持する
000203r 1  xx xx xx xx    BLT_PL_LST:     .RES 32
000207r 1  xx xx xx xx  
00020Br 1  xx xx xx xx  
000223r 1  xx xx xx xx    ENEM1_LST:      .RES 32
000227r 1  xx xx xx xx  
00022Br 1  xx xx xx xx  
000243r 1               
000243r 1               ; -------------------------------------------------------------------
000243r 1               ;                             実行領域
000243r 1               ; -------------------------------------------------------------------
000243r 1               .CODE
000000r 1               START:
000000r 1  64 00          STZ ZR0
000002r 1                 ; ポートの設定
000002r 1  AD 02 E2       LDA VIA::PAD_DDR          ; 0で入力、1で出力
000005r 1  09 06          ORA #(VIA::PAD_CLK|VIA::PAD_PTS)
000007r 1  29 FE          AND #<~(VIA::PAD_DAT)
000009r 1  8D 02 E2       STA VIA::PAD_DDR
00000Cr 1  A9 FF          LDA #$FF                  ; ブラックリスト用番人
00000Er 1  8D rr rr       STA BLACKLIST1            ; 番人設定
000011r 1  8D rr rr       STA BLACKLIST2
000014r 1  64 rr          STZ ZP_PLBLT_TERMPTR      ; PLBLT終端ポインタ
000016r 1  64 rr          STZ ZP_ENEM1_TERMPTR      ; ENEM1終端ポインタ
000018r 1  A9 00          LDA #0                    ; プレイヤ速度初期値
00001Ar 1  85 rr          STA ZP_DX
00001Cr 1  85 rr          STA ZP_DY
00001Er 1  A9 08          LDA #PLAYER_SHOOTRATE
000020r 1  85 rr          STA ZP_PL_COOLDOWN
000022r 1                 ; コンフィグレジスタの初期化
000022r 1  A9 01          LDA #%00000001  ; 全フレーム16色モード、16色モード座標書き込み、書き込みカウントアップ有効
000024r 1  8D 01 E6       STA CRTC::CFG
000027r 1                 ; 2色モードの色を白黒に初期化
000027r 1  A9 0F          LDA #$0F
000029r 1  8D 07 E6       STA CRTC::TCP
00002Cr 1                 ; 出力も書き込みも全部ゼロに初期化
00002Cr 1  9C 03 E6       STZ CRTC::VMAV
00002Fr 1  9C 02 E6       STZ CRTC::VMAH
000032r 1  A9 55          LDA #%01010101  ; フレームバッファ1
000034r 1  85 rr          STA ZP_VISIBLE_FLAME
000036r 1  8D 05 E6       STA CRTC::RF    ; FB1を表示
000039r 1  8D 06 E6       STA CRTC::WF    ; FB1を書き込み先に
00003Cr 1                 ; 背景色で塗りつぶしておく
00003Cr 1  A9 00          LDA #BGC
00003Er 1  20 rr rr       JSR FILL        ; FB1塗りつぶし
000041r 1  A9 02          LDA #2          ; FB2を書き込み先に
000043r 1  8D 06 E6       STA CRTC::WF
000046r 1  A9 00          LDA #BGC
000048r 1  20 rr rr       JSR FILL        ; FB2塗りつぶし
00004Br 1  A9 1F          LDA #PLAYER_X
00004Dr 1  85 rr          STA ZP_PLAYER_X ; プレイヤー初期座標
00004Fr 1  64 rr          STZ ZP_PLAYER_Y
000051r 1                 ; サウンドの初期化
000051r 1  64 rr          STZ ZP_SE_STATE
000053r 1                 ; 割り込みハンドラの登録
000053r 1  78             SEI
000054r 1  A9 rr A0 rr    loadAY16 VBLANK
000058r 1  A2 26 20 03    syscall IRQ_SETHNDR_VB
00005Cr 1  06           
00005Dr 1  85 rr 84 rr    storeAY16 ZP_VB_STUB
000061r 1  58             CLI
000062r 1                 ; 完全垂直同期割り込み駆動？
000062r 1               MAIN:
000062r 1                 ; 無限ループ
000062r 1                 ; 実際には下記の割り込みが走る
000062r 1  80 FE          BRA MAIN
000064r 1               
000064r 1                 ; ---------------------------------------------------------------
000064r 1                 ;   LENGTHの算出
000064r 1               
000064r 1               ; -------------------------------------------------------------------
000064r 1               ;                             マクロ
000064r 1               ; -------------------------------------------------------------------
000064r 1               ; ブラックリストポインタ作成
000064r 1               .macro make_blacklist_ptr
000064r 1                 .local @F1
000064r 1                 .local @F2
000064r 1                 .local @SKP_F2
000064r 1                 .local @BL_DEL_LOOP
000064r 1                 .local @BL_END
000064r 1                 STZ ZP_BLACKLIST_PTR
000064r 1                 LDA ZP_VISIBLE_FLAME
000064r 1                 CMP #$AA
000064r 1                 BNE @F2
000064r 1               @F1:
000064r 1                 LDA #>BLACKLIST1
000064r 1                 BRA @SKP_F2
000064r 1               @F2:
000064r 1                 LDA #>BLACKLIST2
000064r 1               @SKP_F2:
000064r 1                 STA ZP_BLACKLIST_PTR+1 ; $0800 or $0900 昔の話
000064r 1                 LDA #<BLACKLIST1
000064r 1                 STA ZP_BLACKLIST_PTR   ; アライメントしないので下位も設定
000064r 1                 ; ブラックリストに沿って画面上エンティティ削除
000064r 1                 LDY #0
000064r 1               @BL_DEL_LOOP:
000064r 1                 LDA (ZP_BLACKLIST_PTR),Y  ; X座標取得
000064r 1                 CMP #$FF
000064r 1                 BEQ @BL_END
000064r 1                 LSR
000064r 1                 TAX
000064r 1                 INY
000064r 1                 LDA (ZP_BLACKLIST_PTR),Y  ; Y座標取得
000064r 1                 PHY
000064r 1                 TAY
000064r 1                 JSR DEL_SQ8               ; 塗りつぶす
000064r 1                 PLY
000064r 1                 INY
000064r 1                 BRA @BL_DEL_LOOP
000064r 1               @BL_END:
000064r 1                 STY ZP_BL_INDEX
000064r 1               .endmac
000064r 1               
000064r 1               ; アンチノイズ水平消去
000064r 1               .macro anti_noise
000064r 1                 .local @ANLLOOP
000064r 1                 LDA #0
000064r 1                 STA CRTC::VMAH
000064r 1                 LDA ZP_ANT_NZ_Y
000064r 1                 STA CRTC::VMAV
000064r 1                 LDX #$20
000064r 1                 LDA #BGC
000064r 1               @ANLLOOP:
000064r 1                 STA CRTC::WDBF
000064r 1                 STA CRTC::WDBF
000064r 1                 STA CRTC::WDBF
000064r 1                 STA CRTC::WDBF
000064r 1                 STA CRTC::WDBF
000064r 1                 STA CRTC::WDBF
000064r 1                 STA CRTC::WDBF
000064r 1                 STA CRTC::WDBF
000064r 1                 DEX
000064r 1                 BNE @ANLLOOP
000064r 1                 INC ZP_ANT_NZ_Y
000064r 1               .endmac
000064r 1               
000064r 1               ; フレーム交換
000064r 1               .macro exchange_frame
000064r 1                 LDA ZP_VISIBLE_FLAME
000064r 1                 STA CRTC::WF
000064r 1                 CLC
000064r 1                 ROL ; %01010101と%10101010を交換する
000064r 1                 ADC #0
000064r 1                 STA ZP_VISIBLE_FLAME
000064r 1                 STA CRTC::RF
000064r 1               .endmac
000064r 1               
000064r 1               ; PL弾生成
000064r 1               .macro make_pl_blt
000064r 1                 LDY ZP_PLBLT_TERMPTR
000064r 1                 LDA ZP_PLAYER_X
000064r 1                 STA BLT_PL_LST,Y      ; X
000064r 1                 LDA ZP_PLAYER_Y
000064r 1                 STA BLT_PL_LST+1,Y    ; Y
000064r 1                 INY
000064r 1                 INY
000064r 1                 STY ZP_PLBLT_TERMPTR
000064r 1               .endmac
000064r 1               
000064r 1               ; 敵生成
000064r 1               .macro make_enem1
000064r 1                 LDY ZP_ENEM1_TERMPTR
000064r 1                 LDA #200
000064r 1                 STA ENEM1_LST,Y      ; X
000064r 1                 LDA ZP_PLAYER_Y
000064r 1                 STA ENEM1_LST+1,Y    ; Y
000064r 1                 INY
000064r 1                 INY
000064r 1                 STY ZP_ENEM1_TERMPTR
000064r 1               .endmac
000064r 1               
000064r 1               ; PL弾削除
000064r 1               ; 対象インデックスはXで与えられる
000064r 1               DEL_ENEM1:
000064r 1  A4 rr          LDY ZP_ENEM1_TERMPTR  ; Y:終端インデックス
000066r 1  B9 rr rr       LDA ENEM1_LST-2,Y    ; 終端部データX取得
000069r 1  9D rr rr       STA ENEM1_LST,X      ; 対象Xに格納
00006Cr 1  B9 rr rr       LDA ENEM1_LST-1,Y    ; 終端部データY取得
00006Fr 1  9D rr rr       STA ENEM1_LST+1,X    ; 対象Yに格納
000072r 1  88             DEY
000073r 1  88             DEY
000074r 1  84 rr          STY ZP_ENEM1_TERMPTR  ; 縮小した終端インデックス
000076r 1  60             RTS
000077r 1               
000077r 1               ; PL弾削除
000077r 1               ; 対象インデックスはXで与えられる
000077r 1               DEL_PL_BLT:
000077r 1  A4 rr          LDY ZP_PLBLT_TERMPTR  ; Y:終端インデックス
000079r 1  B9 rr rr       LDA BLT_PL_LST-2,Y    ; 終端部データX取得
00007Cr 1  9D rr rr       STA BLT_PL_LST,X      ; 対象Xに格納
00007Fr 1  B9 rr rr       LDA BLT_PL_LST-1,Y    ; 終端部データY取得
000082r 1  9D rr rr       STA BLT_PL_LST+1,X    ; 対象Yに格納
000085r 1  88             DEY
000086r 1  88             DEY
000087r 1  84 rr          STY ZP_PLBLT_TERMPTR  ; 縮小した終端インデックス
000089r 1  60             RTS
00008Ar 1               
00008Ar 1               ; エンティティティック処理
00008Ar 1               ; プレイヤティック
00008Ar 1               .macro tick_player
00008Ar 1                 ; プレイヤ移動
00008Ar 1                 LDA ZP_PLAYER_X
00008Ar 1                 CLC
00008Ar 1                 ADC ZP_DX
00008Ar 1                 STA ZP_PLAYER_X
00008Ar 1                 LDA ZP_PLAYER_Y
00008Ar 1                 CLC
00008Ar 1                 ADC ZP_DY
00008Ar 1                 STA ZP_PLAYER_Y
00008Ar 1                 ; プレイヤ描画
00008Ar 1                 loadmem16 ZP_CHAR_PTR,CHAR_DAT_ZIKI
00008Ar 1                 LDA ZP_PLAYER_X
00008Ar 1                 STA ZP_TMP_X
00008Ar 1                 STA (ZP_BLACKLIST_PTR)
00008Ar 1                 LDA ZP_PLAYER_Y
00008Ar 1                 STA ZP_TMP_Y
00008Ar 1                 LDY #1
00008Ar 1                 STA (ZP_BLACKLIST_PTR),Y
00008Ar 1                 JSR DRAW_CHAR8
00008Ar 1               .endmac
00008Ar 1               
00008Ar 1               ; ENEM1
00008Ar 1               .macro tick_enem1
00008Ar 1               TICK_ENEM1:
00008Ar 1                 .local @DRAWPLBL
00008Ar 1                 .local @END_DRAWPLBL
00008Ar 1                 .local @SKP_Hamburg
00008Ar 1                 LDX #$0                   ; X:敵リスト用インデックス
00008Ar 1               @DRAWPLBL:
00008Ar 1                 CPX ZP_ENEM1_TERMPTR
00008Ar 1                 BCS @END_DRAWPLBL         ; 敵をすべて処理したなら敵処理終了
00008Ar 1                 PHY
00008Ar 1                 LDY #$FE                  ; PL弾インデックス
00008Ar 1               @COL_PLBLT_LOOP:
00008Ar 1                 INY
00008Ar 1                 INY
00008Ar 1                 CPY ZP_PLBLT_TERMPTR
00008Ar 1                 BEQ @END_COL_PLBLT
00008Ar 1                 ; X
00008Ar 1                 LDA ENEM1_LST,X           ; 敵X座標取得
00008Ar 1                 SEC
00008Ar 1                 SBC BLT_PL_LST,Y          ; PL弾X座標を減算
00008Ar 1                 ADC #8                    ; -8が0に
00008Ar 1                 CMP #16
00008Ar 1                 BCS @COL_PLBLT_LOOP
00008Ar 1                 ; Y
00008Ar 1                 LDA ENEM1_LST+1,X
00008Ar 1                 SEC
00008Ar 1                 SBC BLT_PL_LST+1,Y
00008Ar 1                 ADC #8                    ; -8が0に
00008Ar 1                 CMP #16
00008Ar 1                 BCS @COL_PLBLT_LOOP
00008Ar 1               @DEL:
00008Ar 1                 ; 敵削除
00008Ar 1                 PHX
00008Ar 1                 JSR DEL_ENEM1             ; 敵削除
00008Ar 1                 LDA #SE2_NUMBER
00008Ar 1                 JSR PLAY_SE               ; 撃破効果音
00008Ar 1                 PLX
00008Ar 1                 PLY
00008Ar 1                 BRA @DRAWPLBL
00008Ar 1               @END_COL_PLBLT:
00008Ar 1                 PLY
00008Ar 1                 LDA ENEM1_LST,X
00008Ar 1                 STA ZP_TMP_X              ; 描画用座標
00008Ar 1                 STA (ZP_BLACKLIST_PTR),Y  ; BL格納
00008Ar 1                 INX                       ; Y座標へ
00008Ar 1                 INY
00008Ar 1                 LDA ENEM1_LST,X          ; Y座標取得（信頼している
00008Ar 1                 STA ZP_TMP_Y              ; 描画用座標
00008Ar 1                 STA (ZP_BLACKLIST_PTR),Y  ; BL格納
00008Ar 1                 INX                       ; 次のデータにインデックスを合わせる
00008Ar 1                 INY
00008Ar 1                 PHY
00008Ar 1                 PHX
00008Ar 1                 loadmem16 ZP_CHAR_PTR,CHAR_DAT_TEKI1
00008Ar 1                 JSR DRAW_CHAR8            ; 描画する
00008Ar 1                 PLX
00008Ar 1                 PLY
00008Ar 1                 BRA @DRAWPLBL             ; PL弾処理ループ
00008Ar 1               @END_DRAWPLBL:
00008Ar 1               .endmac
00008Ar 1               
00008Ar 1               ; PL弾ティック処理
00008Ar 1               .macro tick_pl_blt
00008Ar 1               TICK_PL_BLT:
00008Ar 1                 .local @DRAWPLBL
00008Ar 1                 .local @END_DRAWPLBL
00008Ar 1                 .local @SKP_Hamburg
00008Ar 1                 LDX #$0                   ; X:PL弾リスト用インデックス
00008Ar 1                 STZ ZR0;dbg
00008Ar 1               @DRAWPLBL:
00008Ar 1                 CPX ZP_PLBLT_TERMPTR
00008Ar 1                 BCS @END_DRAWPLBL         ; PL弾をすべて処理したならPL弾処理終了
00008Ar 1                 LDA BLT_PL_LST,X
00008Ar 1                 ADC #PLBLT_SPEED          ; 新しい弾の位置
00008Ar 1                 BCC @SKP_Hamburg          ; 右にオーバーしたか
00008Ar 1               @DEL:
00008Ar 1                 ; 弾丸削除
00008Ar 1                 PHY
00008Ar 1                 JSR DEL_PL_BLT
00008Ar 1                 LDA #$FF;dbg
00008Ar 1                 STA ZR0;dbg
00008Ar 1                 PLY
00008Ar 1                 BRA @DRAWPLBL
00008Ar 1               @SKP_Hamburg:
00008Ar 1                 STA BLT_PL_LST,X          ; リストに格納
00008Ar 1                 STA ZP_TMP_X              ; 描画用座標
00008Ar 1                 STA (ZP_BLACKLIST_PTR),Y  ; BL格納
00008Ar 1                 INX                       ; Y座標へ
00008Ar 1                 INY
00008Ar 1                 LDA BLT_PL_LST,X          ; Y座標取得（信頼している
00008Ar 1                 STA ZP_TMP_Y              ; 描画用座標
00008Ar 1                 STA (ZP_BLACKLIST_PTR),Y  ; BL格納
00008Ar 1                 INX                       ; 次のデータにインデックスを合わせる
00008Ar 1                 INY
00008Ar 1                 PHY
00008Ar 1                 PHX
00008Ar 1                 loadmem16 ZP_CHAR_PTR,CHAR_DAT_ZITAMA1
00008Ar 1                 JSR DRAW_CHAR8            ; 描画する
00008Ar 1                 PLX
00008Ar 1                 PLY
00008Ar 1                 BRA @DRAWPLBL             ; PL弾処理ループ
00008Ar 1               @END_DRAWPLBL:
00008Ar 1               .endmac
00008Ar 1               
00008Ar 1               .macro term_blacklist
00008Ar 1                 LDA #$FF
00008Ar 1                 STA (ZP_BLACKLIST_PTR),Y
00008Ar 1               .endmac
00008Ar 1               
00008Ar 1               ; 内部レジスタに値を格納する
00008Ar 1               .macro set_ymzreg addr,dat
00008Ar 1                 LDA addr
00008Ar 1                 STA YMZ::ADDR
00008Ar 1                 LDA dat
00008Ar 1                 STA YMZ::DATA
00008Ar 1               .endmac
00008Ar 1               
00008Ar 1               ; Aで与えられた番号のSEを鳴らす
00008Ar 1               PLAY_SE:
00008Ar 1  85 rr          STA ZP_SE_STATE
00008Cr 1  4A             LSR
00008Dr 1  AA             TAX
00008Er 1  BD rr rr       LDA SE_LENGTH_TABLE-1,X
000091r 1  85 rr          STA ZP_SE_TIMER
000093r 1               @END:
000093r 1  60             RTS
000094r 1               
000094r 1               ; 効果音ティック処理
000094r 1               .macro tick_se
000094r 1               TICK_SE:
000094r 1                 LDX ZP_SE_STATE       ; 効果音状態
000094r 1                 BEQ TICK_SE_END       ; 何も鳴ってないなら無視
000094r 1                 JMP (SE_TICK_JT-2,X)  ; 鳴っているので効果音種類ごとの処理に跳ぶ
000094r 1               TICK_SE_RETURN:         ; ここに帰ってくる
000094r 1                 DEC ZP_SE_TIMER       ; タイマー減算
000094r 1                 BNE TICK_SE_END
000094r 1                 ; 0になった
000094r 1                 set_ymzreg #YMZ::IA_MIX,#%00111111
000094r 1                 STZ ZP_SE_STATE
000094r 1               TICK_SE_END:
000094r 1               .endmac
000094r 1               
000094r 1               SE_LENGTH_TABLE:
000094r 1  05             .BYTE SE1_LENGTH      ; 1
000095r 1  05             .BYTE SE2_LENGTH      ; 2
000096r 1               
000096r 1               SE_TICK_JT:
000096r 1  rr rr          .WORD SE1_TICK
000098r 1  rr rr          .WORD SE2_TICK
00009Ar 1               
00009Ar 1               SE1_TICK:
00009Ar 1  A5 rr          LDA ZP_SE_TIMER
00009Cr 1  C9 05          CMP #SE1_LENGTH
00009Er 1  D0 2B          BNE @a
0000A0r 1  A9 07 8D 00    set_ymzreg #YMZ::IA_MIX,#%00111110
0000A4r 1  E4 A9 3E 8D  
0000A8r 1  01 E4        
0000AAr 1  A9 01 8D 00    set_ymzreg #YMZ::IA_FRQ+1,#>(125000/800)
0000AEr 1  E4 A9 00 8D  
0000B2r 1  01 E4        
0000B4r 1  A9 00 8D 00    set_ymzreg #YMZ::IA_FRQ,#<(125000/800)
0000B8r 1  E4 A9 9C 8D  
0000BCr 1  01 E4        
0000BEr 1  A9 08 8D 00    set_ymzreg #YMZ::IA_VOL,#$0F
0000C2r 1  E4 A9 0F 8D  
0000C6r 1  01 E4        
0000C8r 1  4C rr rr       JMP TICK_SE_RETURN
0000CBr 1               @a:
0000CBr 1  A2 08          LDX #YMZ::IA_VOL
0000CDr 1  8E 00 E4       STX YMZ::ADDR
0000D0r 1  0A             ASL                       ; タイマーの左シフト、最大8
0000D1r 1  69 04          ADC #4
0000D3r 1  8D 01 E4       STA YMZ::DATA
0000D6r 1  4C rr rr       JMP TICK_SE_RETURN
0000D9r 1               
0000D9r 1               SE2_TICK:
0000D9r 1  A9 07 8D 00    set_ymzreg #YMZ::IA_MIX,#%00110111
0000DDr 1  E4 A9 37 8D  
0000E1r 1  01 E4        
0000E3r 1  A9 06 8D 00    set_ymzreg #YMZ::IA_NOISE_FRQ,#>(125000/400)
0000E7r 1  E4 A9 01 8D  
0000EBr 1  01 E4        
0000EDr 1  A9 08 8D 00    set_ymzreg #YMZ::IA_VOL,#$0F
0000F1r 1  E4 A9 0F 8D  
0000F5r 1  01 E4        
0000F7r 1  4C rr rr       JMP TICK_SE_RETURN
0000FAr 1               
0000FAr 1               SE1_LENGTH = 5
0000FAr 1               SE1_NUMBER = 1*2
0000FAr 1               SE2_LENGTH = 5
0000FAr 1               SE2_NUMBER = 2*2
0000FAr 1               
0000FAr 1               ; -------------------------------------------------------------------
0000FAr 1               ;                        垂直同期割り込み
0000FAr 1               ; -------------------------------------------------------------------
0000FAr 1               VBLANK:
0000FAr 1  A5 00          LDA ZR0
0000FCr 1  F0 0F          BEQ @TRUE_END
0000FEr 1                 ; 割り込みハンドラの登録
0000FEr 1  78             SEI
0000FFr 1  A5 rr A4 rr    mem2AY16 ZP_VB_STUB
000103r 1  A2 26 20 03    syscall IRQ_SETHNDR_VB
000107r 1  06           
000108r 1  85 rr 84 rr    storeAY16 ZP_VB_STUB
00010Cr 1  58             CLI
00010Dr 1               @TRUE_END:
00010Dr 1               TICK:
00010Dr 1                 ; 塗りつぶし
00010Dr 1  64 rr A5 rr    make_blacklist_ptr          ; ブラックリストポインタ作成
000111r 1  C9 AA D0 04  
000115r 1  A9 rr 80 02  
000139r 1  A9 00 8D 02    anti_noise                  ; ノイズ対策に行ごと消去
00013Dr 1  E6 A5 rr 8D  
000141r 1  03 E6 A2 20  
000164r 1                 ; キー操作
000164r 1  20 rr rr       JSR PAD_READ                ; パッド状態更新
000167r 1  64 rr          STZ ZP_DY
000169r 1  64 rr          STZ ZP_DX
00016Br 1  A2 FF          LDX #256-PLAYER_SPEED
00016Dr 1  A0 01          LDY #PLAYER_SPEED
00016Fr 1  BF rr 02       BBS3 ZP_PADSTAT,@SKP_UP     ; up
000172r 1  86 rr          STX ZP_DY
000174r 1               @SKP_UP:
000174r 1  AF rr 02       BBS2 ZP_PADSTAT,@SKP_DOWN   ; down
000177r 1  84 rr          STY ZP_DY
000179r 1               @SKP_DOWN:
000179r 1  9F rr 02       BBS1 ZP_PADSTAT,@SKP_LEFT   ; left
00017Cr 1  86 rr          STX ZP_DX
00017Er 1               @SKP_LEFT:
00017Er 1  8F rr 02       BBS0 ZP_PADSTAT,@SKP_RIGHT  ; right
000181r 1  84 rr          STY ZP_DX
000183r 1               @SKP_RIGHT:
000183r 1  FF rr 1D       BBS7 ZP_PADSTAT,@SKP_B      ; B button
000186r 1  C6 rr          DEC ZP_PL_COOLDOWN          ; クールダウンチェック
000188r 1  D0 19          BNE @SKP_B
00018Ar 1  A9 08          LDA #PLAYER_SHOOTRATE
00018Cr 1  85 rr          STA ZP_PL_COOLDOWN          ; クールダウン更新
00018Er 1  A4 rr A5 rr    make_pl_blt                 ; PL弾生成
000192r 1  99 rr rr A5  
000196r 1  rr 99 rr rr  
00019Er 1  A9 02          LDA #SE1_NUMBER
0001A0r 1  20 rr rr       JSR PLAY_SE                 ; 発射音再生
0001A3r 1               @SKP_B:
0001A3r 1  EF rr 18       BBS6 ZP_PADSTAT,@SKP_Y      ; B button
0001A6r 1  C6 rr          DEC ZP_PL_COOLDOWN          ; クールダウンチェック
0001A8r 1  D0 14          BNE @SKP_Y
0001AAr 1  A9 08          LDA #PLAYER_SHOOTRATE
0001ACr 1  85 rr          STA ZP_PL_COOLDOWN          ; クールダウン更新
0001AEr 1  A4 rr A9 C8    make_enem1                 ; PL弾生成
0001B2r 1  99 rr rr A5  
0001B6r 1  rr 99 rr rr  
0001BEr 1               @SKP_Y:
0001BEr 1                 ; ティック処理
0001BEr 1  A5 rr 18 65    tick_player                 ; プレイヤ処理
0001C2r 1  rr 85 rr A5  
0001C6r 1  rr 18 65 rr  
0001E5r 1  A0 02          LDY #2
0001E7r 1  A2 00 E4 rr    tick_enem1
0001EBr 1  B0 54 5A A0  
0001EFr 1  FE C8 C8 C4  
000241r 1  A2 00 64 00    tick_pl_blt                 ; PL弾移動と描画
000245r 1  E4 rr B0 35  
000249r 1  BD rr rr 69  
00027Er 1  A9 FF 91 rr    term_blacklist              ; ブラックリスト終端
000282r 1  A6 rr F0 13    tick_se                     ; 効果音
000286r 1  7C rr rr C6  
00028Ar 1  rr D0 0C A9  
000299r 1  A5 rr 8D 06    exchange_frame              ; フレーム交換
00029Dr 1  E6 18 2A 69  
0002A1r 1  00 85 rr 8D  
0002A7r 1                 ; ティック終端
0002A7r 1  6C rr rr       JMP (ZP_VB_STUB)            ; 片付けはBCOSにやらせる
0002AAr 1               
0002AAr 1               ; 背景色で正方形領域を塗りつぶす
0002AAr 1               ; 妙に汎用的にすると重そうなので8x8固定
0002AAr 1               ; X,Yがそのまま座標
0002AAr 1               DEL_SQ8:
0002AAr 1  98             TYA
0002ABr 1  18             CLC
0002ACr 1  69 08          ADC #8
0002AEr 1  85 rr          STA ZP_TMP_Y
0002B0r 1                 ;LDA #BGC
0002B0r 1  A9 88          LDA #DEBUG_BGC              ; どこを四角く塗りつぶしたかがわかる
0002B2r 1               DRAW_SQ_LOOP:
0002B2r 1  8E 02 E6       STX CRTC::VMAH
0002B5r 1  8C 03 E6       STY CRTC::VMAV
0002B8r 1  8D 04 E6       STA CRTC::WDBF
0002BBr 1  8D 04 E6       STA CRTC::WDBF
0002BEr 1  8D 04 E6       STA CRTC::WDBF
0002C1r 1  8D 04 E6       STA CRTC::WDBF
0002C4r 1  C8             INY
0002C5r 1  C4 rr          CPY ZP_TMP_Y
0002C7r 1  D0 E9          BNE DRAW_SQ_LOOP
0002C9r 1  60             RTS
0002CAr 1               
0002CAr 1               ; 8x8キャラクタを表示する
0002CAr 1               ; キャラデータの先頭座標がZP_CHAR_PTRで与えられる
0002CAr 1               DRAW_CHAR8:
0002CAr 1  46 rr          LSR ZP_TMP_X
0002CCr 1  A5 rr          LDA ZP_TMP_X
0002CEr 1  C9 7C          CMP #$7F-3
0002D0r 1  B0 31          BCS @END            ; 左右をまたぎそうならキャンセル
0002D2r 1  8D 02 E6       STA CRTC::VMAH
0002D5r 1  A0 00          LDY #0
0002D7r 1  A2 20          LDX #32
0002D9r 1               @DRAW_CHAR8_LOOP0:
0002D9r 1  A5 rr          LDA ZP_TMP_Y
0002DBr 1  8D 03 E6       STA CRTC::VMAV
0002DEr 1  A5 rr          LDA ZP_TMP_X
0002E0r 1  8D 02 E6       STA CRTC::VMAH
0002E3r 1  B1 rr          LDA (ZP_CHAR_PTR),Y
0002E5r 1  8D 04 E6       STA CRTC::WDBF
0002E8r 1  C8             INY
0002E9r 1  B1 rr          LDA (ZP_CHAR_PTR),Y
0002EBr 1  8D 04 E6       STA CRTC::WDBF
0002EEr 1  C8             INY
0002EFr 1  B1 rr          LDA (ZP_CHAR_PTR),Y
0002F1r 1  8D 04 E6       STA CRTC::WDBF
0002F4r 1  C8             INY
0002F5r 1  B1 rr          LDA (ZP_CHAR_PTR),Y
0002F7r 1  8D 04 E6       STA CRTC::WDBF
0002FAr 1  C8             INY
0002FBr 1               @DRAW_CHAR8_SKP_9:
0002FBr 1  E6 rr          INC ZP_TMP_Y
0002FDr 1  86 02          STX ZR1
0002FFr 1  C4 02          CPY ZR1
000301r 1  D0 D6          BNE @DRAW_CHAR8_LOOP0
000303r 1               @END:
000303r 1  60             RTS
000304r 1               
000304r 1               ; 画面全体をAの値で埋め尽くす
000304r 1               FILL:
000304r 1  A0 00          LDY #$00
000306r 1  8C 03 E6       STY CRTC::VMAV
000309r 1  8C 02 E6       STY CRTC::VMAH
00030Cr 1  A0 C0          LDY #$C0
00030Er 1               FILL_LOOP_V:
00030Er 1  A2 80          LDX #$80
000310r 1               FILL_LOOP_H:
000310r 1  8D 04 E6       STA CRTC::WDBF
000313r 1  CA             DEX
000314r 1  D0 FA          BNE FILL_LOOP_H
000316r 1  88             DEY
000317r 1  D0 F5          BNE FILL_LOOP_V
000319r 1  60             RTS
00031Ar 1               
00031Ar 1               PAD_READ:
00031Ar 1  A9 01          LDA #BCOS::BHA_CON_RAWIN_NoWaitNoEcho  ; キー入力チェック
00031Cr 1  A2 06 20 03    syscall CON_RAWIN
000320r 1  06           
000321r 1  F0 01          BEQ @SKP_RTS
000323r 1  60             RTS
000324r 1               @SKP_RTS:
000324r 1                 ; P/S下げる
000324r 1  AD 00 E2       LDA VIA::PAD_REG
000327r 1  09 02          ORA #VIA::PAD_PTS
000329r 1  8D 00 E2       STA VIA::PAD_REG
00032Cr 1                 ; P/S下げる
00032Cr 1  AD 00 E2       LDA VIA::PAD_REG
00032Fr 1  29 FD          AND #<~VIA::PAD_PTS
000331r 1  8D 00 E2       STA VIA::PAD_REG
000334r 1                 ; 読み取りループ
000334r 1  A2 10          LDX #16
000336r 1               @LOOP:
000336r 1  AD 00 E2       LDA VIA::PAD_REG        ; データ読み取り
000339r 1                 ; クロック下げる
000339r 1  29 FB          AND #<~VIA::PAD_CLK
00033Br 1  8D 00 E2       STA VIA::PAD_REG
00033Er 1                 ; 16bit値として格納
00033Er 1  6A             ROR
00033Fr 1  26 rr          ROL ZP_PADSTAT+1
000341r 1  26 rr          ROL ZP_PADSTAT
000343r 1                 ; クロック上げる
000343r 1  AD 00 E2       LDA VIA::PAD_REG        ; データ読み取り
000346r 1  09 04          ORA #VIA::PAD_CLK
000348r 1  8D 00 E2       STA VIA::PAD_REG
00034Br 1  CA             DEX
00034Cr 1  D0 E8          BNE @LOOP
00034Er 1  60             RTS
00034Fr 1               
00034Fr 1               ;CHAR_DAT:
00034Fr 1               ;  .INCBIN "../../ChDzUtl/images/reimu88.bin"
00034Fr 1               
00034Fr 1               CHAR_DAT_ZIKI:
00034Fr 1  0F F0 00 00    .INCBIN "../../ChDzUtl/images/ziki1-88.bin"
000353r 1  00 FF AA A9  
000357r 1  83 33 FF 00  
00036Fr 1               
00036Fr 1               CHAR_DAT_ZITAMA1:
00036Fr 1  00 00 00 00    .INCBIN "../../ChDzUtl/images/zitama88.bin"
000373r 1  00 00 AA AF  
000377r 1  00 00 00 00  
00038Fr 1               
00038Fr 1               CHAR_DAT_TEKI1:
00038Fr 1  00 00 DD 00    .INCBIN "../../ChDzUtl/images/teki1-88.bin"
000393r 1  00 0D D0 00  
000397r 1  00 88 D0 0D  
0003AFr 1               
0003AFr 1               
