ca65 V2.16 - Ubuntu 2.16-2
Main file   : ./com/snake.s
Current file: ./com/snake.s

000000r 1               ; -------------------------------------------------------------------
000000r 1               ;                           SNAKEゲーム
000000r 1               ; -------------------------------------------------------------------
000000r 1               ; 蛇のゲーム
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
000000r 1               .INCLUDE "../zr.inc"
000000r 2               ZR0 = $0000
000000r 2               ZR1 = $0002
000000r 2               ZR2 = $0004
000000r 2               ZR3 = $0006
000000r 2               ZR4 = $0008
000000r 2               ZR5 = $000A
000000r 2               
000000r 2               
000000r 1               
000000r 1               ; -------------------------------------------------------------------
000000r 1               ;                            定数定義
000000r 1               ; -------------------------------------------------------------------
000000r 1               LEFT  =%0001
000000r 1               BUTTOM=%0010
000000r 1               TOP   =%0100
000000r 1               RIGHT =%1000
000000r 1               CHR_BLANK =' '
000000r 1               CHR_HEAD  ='O'
000000r 1               CHR_TAIL  ='o'
000000r 1               CHR_WALL  =$1F
000000r 1               CHR_APPLE ='@'
000000r 1               CHR_YOKOBO=$10
000000r 1               CHR_TATEBO=$11
000000r 1               CHR_HIDARI_UE=$12
000000r 1               CHR_MIGI_UE=$13
000000r 1               CHR_HIDARI_SITA=$15
000000r 1               CHR_MIGI_SITA=$14
000000r 1               CHR_ALLOWL=$C1
000000r 1               CHR_ALLOWR=$C0
000000r 1               
000000r 1               ; -------------------------------------------------------------------
000000r 1               ;                             ZP領域
000000r 1               ; -------------------------------------------------------------------
000000r 1               .ZEROPAGE
000000r 1  xx xx        ZP_TXTVRAM768_16:         .RES 2  ; カーネルのワークエリアを借用するためのアドレス
000002r 1  xx xx        ZP_FONT2048_16:           .RES 2  ; カーネルのワークエリアを借用するためのアドレス
000004r 1  xx xx        ZP_TRAM_VEC16:            .RES 2  ; TRAM操作用ベクタ
000006r 1  xx xx        ZP_FONT_VEC16:            .RES 2  ; フォント読み取りベクタ
000008r 1  xx           ZP_FONT_SR:               .RES 1  ; FONT_OFST
000009r 1  xx           ZP_DRAWTMP_X:             .RES 1  ; 描画用
00000Ar 1  xx           ZP_DRAWTMP_Y:             .RES 1  ; 描画用
00000Br 1  xx           ZP_ITR:                   .RES 1  ; 汎用イテレータ
00000Cr 1  xx           ZP_SNK_HEAD_X:            .RES 1  ; 頭の座標
00000Dr 1  xx           ZP_SNK_HEAD_Y:            .RES 1
00000Er 1  xx           ZP_SNK_TAIL_X:            .RES 1  ; 尾の座標
00000Fr 1  xx           ZP_SNK_TAIL_Y:            .RES 1
000010r 1  xx           ZP_SNK_HEAD_PTR8:         .RES 1  ; 向きキューの頭のインデックス
000011r 1  xx           ZP_SNK_TAIL_PTR8:         .RES 1  ; 向きキューの尾のインデックス
000012r 1  xx           ZP_SNK_LENGTH:            .RES 1  ; 蛇の長さ 1...
000013r 1  xx           ZP_SNK_LENGTHR:           .RES 1  ; 蛇の長さ 1...レコード
000014r 1  xx           ZP_SNK_DIREC:             .RES 1  ; 次の向き
000015r 1  xx           ZP_INPUT:                 .RES 1  ; キー入力バッファ
000016r 1  xx xx        ZP_RND_ADDR16:            .RES 2  ; カーネルが乱数をくれるはずのアドレス
000018r 1  xx           ZP_APPLE_X:               .RES 1  ; リンゴの座標
000019r 1  xx           ZP_APPLE_Y:               .RES 1
00001Ar 1  xx xx        ZP_VB_STUB:               .RES 2  ; 割り込み終了処理
00001Cr 1  xx           ZP_VB_PAR_TICK:           .RES 1  ; ティック当たり垂直同期割込み数。難易度を担う。
00001Dr 1  xx           ZP_GEAR_FOR_TICK:         .RES 1  ; TICK生成
00001Er 1  xx           ZP_GEAR_FOR_SEC:          .RES 1  ; 秒生成
00001Fr 1  xx           ZP_MM:                    .RES 1  ; 経過分数（デシマル
000020r 1  xx           ZP_SS:                    .RES 1  ; 経過秒数（デシマル
000021r 1  xx           ZP_MMR:                   .RES 1  ; レコード経過分数（デシマル
000022r 1  xx           ZP_SSR:                   .RES 1  ; レコード経過秒数（デシマル
000023r 1  xx           ZP_TICK_FLAG:             .RES 1  ; 0=ティック待機期間 非0=ティック発生
000024r 1  xx           ZP_SELECTOR_STATE:        .RES 1  ; メニュー状態
000025r 1  xx           ZP_SP:                    .RES 1
000026r 1               ; SNESPAD
000026r 1  xx xx        ZP_PADSTAT:         .RES 2        ; ゲームパッドの状態が収まる
000028r 1  xx           ZP_SHIFTER:         .RES 1        ; ゲームパッド読み取り処理用
000029r 1  xx xx        ZP_PRE_PADSTAT:     .RES 2
00002Br 1  xx           ZP_VB_ON:           .RES 1
00002Cr 1               
00002Cr 1               ; -------------------------------------------------------------------
00002Cr 1               ;                             実行領域
00002Cr 1               ; -------------------------------------------------------------------
00002Cr 1               .CODE
000000r 1               START:
000000r 1  BA             TSX
000001r 1  86 rr          STX ZP_SP
000003r 1  A5 rr 85 rr    mem2mem16 ZP_PRE_PADSTAT,ZP_PADSTAT ; 表示するときすなわち状態変化があったとき、前回状態更新
000007r 1  A5 rr 85 rr  
00000Br 1                 ; 汎用ポートの設定
00000Br 1  AD 02 E2       LDA VIA::PAD_DDR          ; 0で入力、1で出力
00000Er 1  09 06          ORA #(VIA::PAD_CLK|VIA::PAD_PTS)
000010r 1  29 FE          AND #<~(VIA::PAD_DAT)
000012r 1  8D 02 E2       STA VIA::PAD_DDR
000015r 1                 ; アドレス類を取得
000015r 1  A0 02          LDY #BCOS::BHY_GET_ADDR_txtvram768  ; TRAM
000017r 1  A2 28 20 03    syscall GET_ADDR
00001Br 1  06           
00001Cr 1  85 rr 84 rr    storeAY16 ZP_TXTVRAM768_16
000020r 1  A0 04          LDY #BCOS::BHY_GET_ADDR_font2048    ; FONT
000022r 1  A2 28 20 03    syscall GET_ADDR
000026r 1  06           
000027r 1  85 rr 84 rr    storeAY16 ZP_FONT2048_16
00002Br 1  A0 00          LDY #BCOS::BHY_GET_ADDR_zprand16    ; RND
00002Dr 1  A2 28 20 03    syscall GET_ADDR
000031r 1  06           
000032r 1  85 rr 84 rr    storeAY16 ZP_RND_ADDR16
000036r 1                 ; レコード記録リセット
000036r 1  64 rr          STZ ZP_MMR
000038r 1  64 rr          STZ ZP_SSR
00003Ar 1  64 rr          STZ ZP_SNK_LENGTHR
00003Cr 1  64 rr          STZ ZP_VB_ON                        ; VB処理オフ（PAD除く
00003Er 1                 ; 割り込みハンドラの登録
00003Er 1  78             SEI
00003Fr 1  A9 rr A0 rr    loadAY16 VBLANK
000043r 1  A2 26 20 03    syscall IRQ_SETHNDR_VB
000047r 1  06           
000048r 1  85 rr 84 rr    storeAY16 ZP_VB_STUB
00004Cr 1  58             CLI
00004Dr 1  20 rr rr       JSR TITLE
000050r 1               GAME:
000050r 1  20 rr rr       JSR CLEAR_TXTVRAM                   ; 画面クリア
000053r 1                 ; 速度メータ表示
000053r 1  A9 5D          LDA #']'
000055r 1  A2 07          LDX #7
000057r 1  A0 17          LDY #23
000059r 1  20 rr rr       JSR XY_PUT
00005Cr 1  A9 5B          LDA #'['
00005Er 1  A2 00          LDX #0
000060r 1  20 rr rr       JSR XY_PUT
000063r 1  A5 rr          LDA ZP_VB_PAR_TICK
000065r 1  85 rr          STA ZP_ITR
000067r 1               @SPEED_LOOP:
000067r 1  A9 3E          LDA #'>'
000069r 1  E8             INX
00006Ar 1  20 rr rr       JSR XY_PUT
00006Dr 1  A5 rr          LDA ZP_ITR
00006Fr 1  1A             INC
000070r 1  85 rr          STA ZP_ITR
000072r 1  C9 08          CMP #8
000074r 1  D0 F1          BNE @SPEED_LOOP
000076r 1  A9 01          LDA #1
000078r 1  85 rr          STA ZP_VB_ON                        ; VB処理オン
00007Ar 1                 ; ゲーム情報の初期化
00007Ar 1  64 rr          STZ ZP_TICK_FLAG
00007Cr 1                 ; 長さ
00007Cr 1  A9 01          LDA #1
00007Er 1  85 rr          STA ZP_SNK_LENGTH
000080r 1                 ; 向きリングキューのポインタ初期化
000080r 1  64 rr          STZ ZP_SNK_TAIL_PTR8
000082r 1  64 rr          STZ ZP_SNK_HEAD_PTR8
000084r 1                 ; 向きリングキューの内容初期化
000084r 1  A9 08          LDA #RIGHT          ; 右を向いている
000086r 1  85 rr          STA ZP_SNK_DIREC
000088r 1  8D rr rr       STA SNAKE_DATA256
00008Br 1                 ; 実座標データの初期化
00008Br 1  A9 0A          LDA #10             ; 10,10がちょうどよかろうか
00008Dr 1  85 rr          STA ZP_SNK_HEAD_X
00008Fr 1  85 rr          STA ZP_SNK_HEAD_Y
000091r 1  85 rr          STA ZP_SNK_TAIL_X
000093r 1  85 rr          STA ZP_SNK_TAIL_Y
000095r 1                 ; Length
000095r 1  A9 rr 85 00    loadmem16 ZR0,STR_LENGTH
000099r 1  A9 rr 85 01  
00009Dr 1  A2 0A          LDX #10
00009Fr 1  A0 16          LDY #22
0000A1r 1  20 rr rr       JSR XY_PRT_STR
0000A4r 1                 ; Record
0000A4r 1  A9 rr 85 00    loadmem16 ZR0,STR_RECORD
0000A8r 1  A9 rr 85 01  
0000ACr 1  A2 0A          LDX #10
0000AEr 1  C8             INY
0000AFr 1  20 rr rr       JSR XY_PRT_STR
0000B2r 1                 ; RecordTime
0000B2r 1  A5 rr          LDA ZP_MMR
0000B4r 1  85 rr          STA ZP_MM
0000B6r 1  A5 rr          LDA ZP_SSR
0000B8r 1  85 rr          STA ZP_SS
0000BAr 1  A2 1B          LDX #27
0000BCr 1  A0 17          LDY #23
0000BEr 1  20 rr rr       JSR XY_PRT_TIME
0000C1r 1                 ; Time
0000C1r 1  64 rr          STZ ZP_MM
0000C3r 1  64 rr          STZ ZP_SS
0000C5r 1  A2 1B          LDX #27
0000C7r 1  A0 16          LDY #22
0000C9r 1  20 rr rr       JSR XY_PRT_TIME
0000CCr 1  20 rr rr       JSR DRAW_LENGTH                     ; LENGTH描画
0000CFr 1  20 rr rr       JSR DRAW_LENGTHR                    ; LENGTHR描画
0000D2r 1  20 rr rr       JSR DRAW_FRAME                      ; 枠の描画
0000D5r 1  20 rr rr       JSR DRAW_ALLLINE                    ; 全部描画
0000D8r 1                 ; 初期リンゴ
0000D8r 1  20 rr rr       JSR GEN_APPLE
0000DBr 1               @LOOP:
0000DBr 1                 ; wasd
0000DBr 1  A9 01          LDA #BCOS::BHA_CON_RAWIN_NoWaitNoEcho
0000DDr 1  A2 06 20 03    syscall CON_RAWIN
0000E1r 1  06           
0000E2r 1  F0 2C          BEQ @END_WASD
0000E4r 1  85 rr          STA ZP_INPUT
0000E6r 1  A5 rr          LDA ZP_SNK_DIREC
0000E8r 1  89 09          BIT #LEFT|RIGHT
0000EAr 1  F0 12          BEQ @V
0000ECr 1               @H:
0000ECr 1               @W:
0000ECr 1  A5 rr          LDA ZP_INPUT
0000EEr 1  C9 77          CMP #'w'
0000F0r 1  D0 04          BNE @S
0000F2r 1  A9 04          LDA #TOP
0000F4r 1  85 rr          STA ZP_SNK_DIREC
0000F6r 1               @S:
0000F6r 1  C9 73          CMP #'s'
0000F8r 1  D0 16          BNE @END_WASD
0000FAr 1  A9 02          LDA #BUTTOM
0000FCr 1  85 rr          STA ZP_SNK_DIREC
0000FEr 1               @V:
0000FEr 1               @A:
0000FEr 1  A5 rr          LDA ZP_INPUT
000100r 1  C9 61          CMP #'a'
000102r 1  D0 04          BNE @D
000104r 1  A9 01          LDA #LEFT
000106r 1  85 rr          STA ZP_SNK_DIREC
000108r 1               @D:
000108r 1  C9 64          CMP #'d'
00010Ar 1  D0 04          BNE @END_WASD
00010Cr 1  A9 08          LDA #RIGHT
00010Er 1  85 rr          STA ZP_SNK_DIREC
000110r 1               @END_WASD:
000110r 1  20 rr rr       JSR MOVE_HEAD
000113r 1  B0 03          BCS @SKP_TAIL
000115r 1  20 rr rr       JSR MOVE_TAIL
000118r 1               @SKP_TAIL:
000118r 1               @TICK_WAIT:
000118r 1  A5 rr          LDA ZP_TICK_FLAG
00011Ar 1  F0 FC          BEQ @TICK_WAIT
00011Cr 1  64 rr          STZ ZP_TICK_FLAG
00011Er 1  80 BB          BRA @LOOP
000120r 1               
000120r 1               ; -------------------------------------------------------------------
000120r 1               ;                             タイトル
000120r 1               ; -------------------------------------------------------------------
000120r 1               TITLE_Y=(24/2)-2
000120r 1               TITLE_DIF_Y=TITLE_Y+3
000120r 1               TITLE_DIF_X=12
000120r 1               TITLE_PROMPT_Y=23-3
000120r 1               TITLE_PROMPT_EXIT_X=9
000120r 1               TITLE_PROMPT_START_X=18
000120r 1               TITLE_MENU_SPEED=0
000120r 1               TITLE_MENU_EXIT=1
000120r 1               TITLE_MENU_START=2
000120r 1               TITLE:
000120r 1                 ; STARTにポイント
000120r 1  A9 02          LDA #TITLE_MENU_START
000122r 1  85 rr          STA ZP_SELECTOR_STATE
000124r 1                 ; 速度難易度のデフォ値
000124r 1  A9 05          LDA #5
000126r 1  85 rr          STA ZP_VB_PAR_TICK
000128r 1                 ; タイトル画面の描画
000128r 1  20 rr rr       JSR CLEAR_TXTVRAM                   ; 画面クリア
00012Br 1                 ; ヘヒ゛ ケ゛ーム (8)
00012Br 1  A9 rr 85 00    loadmem16 ZR0,STR_TITLE_SNAKEGAME
00012Fr 1  A9 rr 85 01  
000133r 1  A2 0C          LDX #12             ; 中央寄せ
000135r 1  A0 0A          LDY #TITLE_Y        ; 中央寄せ
000137r 1  20 rr rr       JSR XY_PRT_STR
00013Ar 1                 ; 難易度の調整ウィンドウ
00013Ar 1                 ; 0
00013Ar 1  A9 rr 85 00    loadmem16 ZR0,STR_TITLE_DIF0
00013Er 1  A9 rr 85 01  
000142r 1  A2 0C          LDX #TITLE_DIF_X
000144r 1  A0 0E          LDY #TITLE_DIF_Y+1
000146r 1  20 rr rr       JSR XY_PRT_STR
000149r 1                 ; 1
000149r 1  A9 rr 85 00    loadmem16 ZR0,STR_TITLE_DIF1
00014Dr 1  A9 rr 85 01  
000151r 1  A2 0C          LDX #TITLE_DIF_X
000153r 1  A0 0F          LDY #TITLE_DIF_Y+2
000155r 1  20 rr rr       JSR XY_PRT_STR
000158r 1                 ; 2
000158r 1  A9 rr 85 00    loadmem16 ZR0,STR_TITLE_DIF2
00015Cr 1  A9 rr 85 01  
000160r 1  A2 0C          LDX #TITLE_DIF_X
000162r 1  A0 10          LDY #TITLE_DIF_Y+3
000164r 1  20 rr rr       JSR XY_PRT_STR
000167r 1                 ; 3
000167r 1  A9 rr 85 00    loadmem16 ZR0,STR_TITLE_DIF3
00016Br 1  A9 rr 85 01  
00016Fr 1  A2 0C          LDX #TITLE_DIF_X
000171r 1  A0 11          LDY #TITLE_DIF_Y+4
000173r 1  20 rr rr       JSR XY_PRT_STR
000176r 1                 ; EXIT
000176r 1  A9 rr 85 00    loadmem16 ZR0,STR_TITLE_EXIT
00017Ar 1  A9 rr 85 01  
00017Er 1  A2 09          LDX #TITLE_PROMPT_EXIT_X
000180r 1  A0 14          LDY #TITLE_PROMPT_Y
000182r 1  20 rr rr       JSR XY_PRT_STR
000185r 1                 ; START
000185r 1  A9 rr 85 00    loadmem16 ZR0,STR_TITLE_START
000189r 1  A9 rr 85 01  
00018Dr 1  A2 12          LDX #TITLE_PROMPT_START_X
00018Fr 1  A0 14          LDY #TITLE_PROMPT_Y
000191r 1  20 rr rr       JSR XY_PRT_STR
000194r 1                 ; 描画
000194r 1  20 rr rr       JSR DRAW_ALLLINE
000197r 1               @LOOP:
000197r 1                 ; キー入力駆動
000197r 1  A9 02          LDA #BCOS::BHA_CON_RAWIN_WaitAndNoEcho  ; キー入力待機
000199r 1  A2 06 20 03    syscall CON_RAWIN
00019Dr 1  06           
00019Er 1                 ; キーごとの処理
00019Er 1               @W:
00019Er 1                 ; Wキー
00019Er 1                 ; EXIT/STARTにあるとき、SPEEDに移動する
00019Er 1                 ; それ以外では何もしない
00019Er 1  C9 77          CMP #'w'
0001A0r 1  D0 2A          BNE @S
0001A2r 1  A5 rr          LDA ZP_SELECTOR_STATE
0001A4r 1  C9 00          CMP #TITLE_MENU_SPEED         ; SPEEDか？
0001A6r 1  F0 EF          BEQ @LOOP                     ; SPEEDなら無視
0001A8r 1                 ; SPEEDに移動
0001A8r 1  A9 00          LDA #TITLE_MENU_SPEED
0001AAr 1  85 rr          STA ZP_SELECTOR_STATE         ; 状態のセット
0001ACr 1  A9 20          LDA #' '                      ; *の塗りつぶし
0001AEr 1  A0 14          LDY #TITLE_PROMPT_Y
0001B0r 1  A2 09          LDX #TITLE_PROMPT_EXIT_X
0001B2r 1  20 rr rr       JSR XY_PUT
0001B5r 1                 ;LDA #' '                      ; *の塗りつぶし
0001B5r 1  A2 12          LDX #TITLE_PROMPT_START_X
0001B7r 1  20 rr rr       JSR XY_PUT_DRAW
0001BAr 1  A9 C1          LDA #CHR_ALLOWL               ; ←
0001BCr 1  A2 0B          LDX #TITLE_DIF_X-1
0001BEr 1  A0 10          LDY #TITLE_DIF_Y+3
0001C0r 1  20 rr rr       JSR XY_PUT
0001C3r 1  A9 C0          LDA #CHR_ALLOWR               ; →
0001C5r 1  A2 14          LDX #TITLE_DIF_X+2+6
0001C7r 1  20 rr rr       JSR XY_PUT_DRAW
0001CAr 1  80 CB          BRA @LOOP
0001CCr 1               @S:
0001CCr 1                 ; Sキー
0001CCr 1                 ; SPEEDにあるとき、STARTに移動する
0001CCr 1  C9 73          CMP #'s'
0001CEr 1  D0 25          BNE @A
0001D0r 1  A5 rr          LDA ZP_SELECTOR_STATE
0001D2r 1  C9 00          CMP #TITLE_MENU_SPEED         ; SPEEDか？
0001D4r 1  D0 C1          BNE @LOOP                     ; EXIT/STARTなら無視
0001D6r 1                 ; STARTに移動
0001D6r 1  A9 02          LDA #TITLE_MENU_START
0001D8r 1  85 rr          STA ZP_SELECTOR_STATE         ; 状態のセット
0001DAr 1  A9 20          LDA #' '                      ; ←
0001DCr 1  A2 0B          LDX #TITLE_DIF_X-1
0001DEr 1  A0 10          LDY #TITLE_DIF_Y+3
0001E0r 1  20 rr rr       JSR XY_PUT
0001E3r 1  A9 20          LDA #' '                      ; →
0001E5r 1  A2 14          LDX #TITLE_DIF_X+2+6
0001E7r 1  20 rr rr       JSR XY_PUT_DRAW
0001EAr 1  A9 2A          LDA #'*'                      ; *START
0001ECr 1  A0 14          LDY #TITLE_PROMPT_Y
0001EEr 1  A2 12          LDX #TITLE_PROMPT_START_X
0001F0r 1  20 rr rr       JSR XY_PUT_DRAW
0001F3r 1  80 A2          BRA @LOOP
0001F5r 1               @A:
0001F5r 1                 ; Aキー
0001F5r 1                 ; STARTにあるとき、EXITにする
0001F5r 1                 ; SPEEDにあるとき、臓側する
0001F5r 1  C9 61          CMP #'a'
0001F7r 1  D0 40          BNE @D
0001F9r 1  A5 rr          LDA ZP_SELECTOR_STATE
0001FBr 1  C9 02          CMP #TITLE_MENU_START         ; STARTか？
0001FDr 1  D0 16          BNE @A_NOT_START
0001FFr 1                 ; STARTをEXITに
0001FFr 1  A9 01          LDA #TITLE_MENU_EXIT
000201r 1  85 rr          STA ZP_SELECTOR_STATE         ; 状態のセット
000203r 1  A9 2A          LDA #'*'                      ; *EXIT
000205r 1  A0 14          LDY #TITLE_PROMPT_Y
000207r 1  A2 09          LDX #TITLE_PROMPT_EXIT_X
000209r 1  20 rr rr       JSR XY_PUT
00020Cr 1  A9 20          LDA #' '                      ; *STARTの塗りつぶし
00020Er 1  A2 12          LDX #TITLE_PROMPT_START_X
000210r 1  20 rr rr       JSR XY_PUT_DRAW
000213r 1  80 82          BRA @LOOP
000215r 1               @A_NOT_START:
000215r 1  A5 rr          LDA ZP_SELECTOR_STATE
000217r 1  C9 00          CMP #TITLE_MENU_SPEED         ; SPEEDか？
000219r 1  D0 60          BNE @LOOP2
00021Br 1                 ; 減速
00021Br 1  A5 rr          LDA ZP_VB_PAR_TICK            ; 速度基準のチェック
00021Dr 1  C9 07          CMP #7
00021Fr 1  F0 5A          BEQ @LOOP2                    ; 最低速度の7[/TICK]なら中断
000221r 1  1A             INC                           ; ++
000222r 1  85 rr          STA ZP_VB_PAR_TICK            ; 速度格納
000224r 1                 ; ヘビが一つ引っ込む
000224r 1  A9 14          LDA #TITLE_DIF_X+2+6
000226r 1  38             SEC
000227r 1  E5 rr          SBC ZP_VB_PAR_TICK            ; 減算により、新しい頭の座標が求まるはず
000229r 1  AA             TAX
00022Ar 1  A0 10          LDY #TITLE_DIF_Y+3
00022Cr 1  A9 4F          LDA #CHR_HEAD
00022Er 1  20 rr rr       JSR XY_PUT
000231r 1  E8             INX                           ; 古い頭を削除
000232r 1  A9 20          LDA #' '
000234r 1  20 rr rr       JSR XY_PUT_DRAW
000237r 1  80 42          BRA @LOOP2
000239r 1               @D:
000239r 1                 ; Dキー
000239r 1                 ; EXITにあるとき、STARTにする
000239r 1                 ; SPEEDにあるとき、減速する
000239r 1  C9 64          CMP #'d'
00023Br 1  D0 41          BNE @SKP_WASD
00023Dr 1  A5 rr          LDA ZP_SELECTOR_STATE
00023Fr 1  C9 01          CMP #TITLE_MENU_EXIT         ; EXITか？
000241r 1  D0 16          BNE @D_NOT_EXIT
000243r 1                 ; START
000243r 1  A9 02          LDA #TITLE_MENU_START
000245r 1  85 rr          STA ZP_SELECTOR_STATE         ; 状態のセット
000247r 1  A9 2A          LDA #'*'                      ; *EXIT
000249r 1  A0 14          LDY #TITLE_PROMPT_Y
00024Br 1  A2 12          LDX #TITLE_PROMPT_START_X
00024Dr 1  20 rr rr       JSR XY_PUT
000250r 1  A9 20          LDA #' '                      ; *STARTの塗りつぶし
000252r 1  A2 09          LDX #TITLE_PROMPT_EXIT_X
000254r 1  20 rr rr       JSR XY_PUT_DRAW
000257r 1  80 22          BRA @LOOP2
000259r 1               @D_NOT_EXIT:
000259r 1  A5 rr          LDA ZP_SELECTOR_STATE
00025Br 1  C9 00          CMP #TITLE_MENU_SPEED         ; SPEEDか？
00025Dr 1  D0 1C          BNE @LOOP2
00025Fr 1                 ; 増速
00025Fr 1  A5 rr          LDA ZP_VB_PAR_TICK            ; 速度基準のチェック
000261r 1  C9 02          CMP #2
000263r 1  F0 16          BEQ @LOOP2                    ; 最高速度の2[/TICK]なら中断
000265r 1  3A             DEC                           ; --
000266r 1  85 rr          STA ZP_VB_PAR_TICK            ; 速度格納
000268r 1                 ; ヘビが一つ引っ込む
000268r 1  A9 14          LDA #TITLE_DIF_X+2+6
00026Ar 1  38             SEC
00026Br 1  E5 rr          SBC ZP_VB_PAR_TICK            ; 減算により、新しい頭の座標が求まるはず
00026Dr 1  AA             TAX
00026Er 1  A0 10          LDY #TITLE_DIF_Y+3
000270r 1  A9 4F          LDA #CHR_HEAD
000272r 1  20 rr rr       JSR XY_PUT
000275r 1  CA             DEX                           ; 胴を設置
000276r 1  A9 6F          LDA #CHR_TAIL
000278r 1  20 rr rr       JSR XY_PUT_DRAW
00027Br 1                 ;BRA @LOOP2
00027Br 1               
00027Br 1               @SKP_START:
00027Br 1               @SKP_ENTER:
00027Br 1               @LOOP2:
00027Br 1  4C rr rr       JMP @LOOP
00027Er 1               
00027Er 1               @SKP_WASD:
00027Er 1                 ; エンターキー
00027Er 1               @ENTER:
00027Er 1  C9 0A          CMP #10
000280r 1  D0 F9          BNE @SKP_ENTER
000282r 1  A5 rr          LDA ZP_SELECTOR_STATE
000284r 1  C9 01          CMP #TITLE_MENU_EXIT
000286r 1  D0 0F          BNE @SKP_EXIT
000288r 1                 ; 大政奉還コード
000288r 1                 ; 割り込みハンドラの登録抹消
000288r 1  78             SEI
000289r 1  A5 rr A4 rr    mem2AY16 ZP_VB_STUB
00028Dr 1  A2 26 20 03    syscall IRQ_SETHNDR_VB
000291r 1  06           
000292r 1  58             CLI
000293r 1  A6 rr          LDX ZP_SP
000295r 1  9A             TXS
000296r 1  60             RTS
000297r 1               @SKP_EXIT:
000297r 1  C9 02          CMP #TITLE_MENU_START
000299r 1  D0 E0          BNE @SKP_START
00029Br 1  60             RTS
00029Cr 1               
00029Cr 1               ; -------------------------------------------------------------------
00029Cr 1               ;                        垂直同期割り込み
00029Cr 1               ; -------------------------------------------------------------------
00029Cr 1               VBLANK:
00029Cr 1                 ; パッド状態反映
00029Cr 1  20 rr rr       JSR PAD_READ            ; パッドを読む
00029Fr 1  0F rr 34       BBR0 ZP_VB_ON,@SKP_SEC  ; ゲーム中以外はパッド処理だけで切り上げ
0002A2r 1                 ; ギアを回す
0002A2r 1  C6 rr          DEC ZP_GEAR_FOR_TICK
0002A4r 1  D0 06          BNE @SKP_TICK
0002A6r 1  A5 rr          LDA ZP_VB_PAR_TICK
0002A8r 1  85 rr          STA ZP_GEAR_FOR_TICK
0002AAr 1  85 rr          STA ZP_TICK_FLAG
0002ACr 1               @SKP_TICK:
0002ACr 1  C6 rr          DEC ZP_GEAR_FOR_SEC
0002AEr 1  D0 26          BNE @SKP_SEC
0002B0r 1  A9 3C          LDA #60
0002B2r 1  85 rr          STA ZP_GEAR_FOR_SEC
0002B4r 1                 ; 一秒ごとの処理
0002B4r 1  F8             SED
0002B5r 1  A5 rr          LDA ZP_SS
0002B7r 1  18             CLC
0002B8r 1  69 01          ADC #1
0002BAr 1  C9 60          CMP #$60
0002BCr 1  D0 09          BNE @SKP_NEXT_MM
0002BEr 1  A5 rr          LDA ZP_MM
0002C0r 1  18             CLC
0002C1r 1  69 01          ADC #1
0002C3r 1  85 rr          STA ZP_MM
0002C5r 1  A9 00          LDA #0
0002C7r 1               @SKP_NEXT_MM:
0002C7r 1  85 rr          STA ZP_SS
0002C9r 1  A2 1B          LDX #27
0002CBr 1  A0 16          LDY #22
0002CDr 1  20 rr rr       JSR XY_PRT_TIME
0002D0r 1  A0 16          LDY #22
0002D2r 1  20 rr rr       JSR DRAW_LINE
0002D5r 1  D8             CLD
0002D6r 1               @SKP_SEC:
0002D6r 1  6C rr rr       JMP (ZP_VB_STUB)           ; 片付けはBCOSにやらせる
0002D9r 1               
0002D9r 1               ; -------------------------------------------------------------------
0002D9r 1               ;                          リンゴを生成
0002D9r 1               ; -------------------------------------------------------------------
0002D9r 1               GEN_APPLE:
0002D9r 1                 ; X
0002D9r 1               @RETRY_X:
0002D9r 1  20 rr rr       JSR GET_RND   ; $00...$FF
0002DCr 1  29 1F          AND #31
0002DEr 1                 ; 00...31
0002DEr 1  C9 02          CMP #2
0002E0r 1  30 F7          BMI @RETRY_X
0002E2r 1  C9 1E          CMP #30
0002E4r 1  10 F3          BPL @RETRY_X
0002E6r 1                 ; 02...29
0002E6r 1  85 rr          STA ZP_APPLE_X
0002E8r 1                 ; Y
0002E8r 1               @RETRY_Y:
0002E8r 1  20 rr rr       JSR GET_RND   ; $00...$FF
0002EBr 1  29 1F          AND #31
0002EDr 1                 ; 00...31
0002EDr 1  C9 02          CMP #2
0002EFr 1  30 F7          BMI @RETRY_Y
0002F1r 1  C9 14          CMP #20
0002F3r 1  10 F3          BPL @RETRY_Y
0002F5r 1                 ; 02...29
0002F5r 1  85 rr          STA ZP_APPLE_Y
0002F7r 1                 ; 蛇と被ってないかチェック
0002F7r 1  A6 rr          LDX ZP_APPLE_X
0002F9r 1  A4 rr          LDY ZP_APPLE_Y
0002FBr 1  20 rr rr       JSR XY_GET
0002FEr 1  C9 20          CMP #CHR_BLANK
000300r 1  D0 D7          BNE @RETRY_X
000302r 1                 ; 描画する
000302r 1  A9 40          LDA #CHR_APPLE
000304r 1  20 rr rr       JSR XY_PUT_DRAW
000307r 1  60             RTS
000308r 1               
000308r 1               ; -------------------------------------------------------------------
000308r 1               ;                           頭を動かす
000308r 1               ; -------------------------------------------------------------------
000308r 1               MOVE_HEAD:
000308r 1  18             CLC
000309r 1  08             PHP
00030Ar 1                 ; 頭を胴にする
00030Ar 1  A9 6F          LDA #CHR_TAIL
00030Cr 1  A6 rr          LDX ZP_SNK_HEAD_X
00030Er 1  A4 rr          LDY ZP_SNK_HEAD_Y
000310r 1  20 rr rr       JSR XY_PUT_DRAW
000313r 1                 ; 次の頭の座標を取得する
000313r 1  A5 rr          LDA ZP_SNK_DIREC
000315r 1  20 rr rr       JSR NEXT_XY
000318r 1                 ; そこを調べる
000318r 1  20 rr rr       JSR XY_GET
00031Br 1  C9 1F          CMP #CHR_WALL
00031Dr 1  F0 49          BEQ GAMEOVER
00031Fr 1  C9 6F          CMP #CHR_TAIL
000321r 1  F0 45          BEQ GAMEOVER
000323r 1  C9 40          CMP #CHR_APPLE
000325r 1  D0 19          BNE @SKP_APPLE
000327r 1                 ; 成長処理
000327r 1  F8             SED
000328r 1  18             CLC
000329r 1  A5 rr          LDA ZP_SNK_LENGTH
00032Br 1  69 01          ADC #1
00032Dr 1  85 rr          STA ZP_SNK_LENGTH
00032Fr 1  D8             CLD
000330r 1  DA             PHX
000331r 1  5A             PHY
000332r 1  20 rr rr       JSR DRAW_LENGTH
000335r 1  20 rr rr       JSR DRAW_LINE
000338r 1  20 rr rr       JSR GEN_APPLE
00033Br 1  7A             PLY
00033Cr 1  FA             PLX
00033Dr 1  28             PLP
00033Er 1  38             SEC
00033Fr 1  08             PHP
000340r 1               @SKP_APPLE:
000340r 1                 ; 大丈夫そうだ
000340r 1                 ; 頭の座標を更新
000340r 1  A9 4F          LDA #CHR_HEAD
000342r 1  86 rr          STX ZP_SNK_HEAD_X
000344r 1  84 rr          STY ZP_SNK_HEAD_Y
000346r 1  20 rr rr       JSR XY_PUT_DRAW
000349r 1                 ; 向きリングキューの更新
000349r 1  A5 rr          LDA ZP_SNK_DIREC        ; 使った向き
00034Br 1  A6 rr          LDX ZP_SNK_HEAD_PTR8    ; 更新すべき場所のポインタ
00034Dr 1  9D rr rr       STA SNAKE_DATA256,X     ; 向きを登録
000350r 1  E6 rr          INC ZP_SNK_HEAD_PTR8    ; 進める
000352r 1  28             PLP
000353r 1  60             RTS
000354r 1               
000354r 1               DRAW_LENGTH:
000354r 1  A5 rr          LDA ZP_SNK_LENGTH
000356r 1  A0 16          LDY #22
000358r 1  A2 12          LDX #15+3
00035Ar 1  20 rr rr       JSR XY_PRT_BYT
00035Dr 1  60             RTS
00035Er 1               
00035Er 1               DRAW_LENGTHR:
00035Er 1  A5 rr          LDA ZP_SNK_LENGTHR
000360r 1  A0 17          LDY #23
000362r 1  A2 12          LDX #15+3
000364r 1  20 rr rr       JSR XY_PRT_BYT
000367r 1  60             RTS
000368r 1               
000368r 1               ; -------------------------------------------------------------------
000368r 1               ;                                衝突
000368r 1               ; -------------------------------------------------------------------
000368r 1               GAMEOVER:
000368r 1  64 rr          STZ ZP_VB_ON                        ; VB処理オフ（PAD除く
00036Ar 1  A9 rr 85 00    loadmem16 ZR0,STR_GAMEOVER
00036Er 1  A9 rr 85 01  
000372r 1  A2 0B          LDX #11                             ; 中央寄せ
000374r 1  A0 0A          LDY #TITLE_Y                        ; 中央寄せ
000376r 1  20 rr rr       JSR XY_PRT_STR
000379r 1  A9 rr 85 00    loadmem16 ZR0,STR_GAMEOVER_PROM
00037Dr 1  A9 rr 85 01  
000381r 1  A2 02          LDX #2                              ; 中央寄せ
000383r 1  A0 0C          LDY #TITLE_Y+2                      ; 中央寄せ
000385r 1  20 rr rr       JSR XY_PRT_STR
000388r 1                 ; レコード処理
000388r 1  A5 rr          LDA ZP_SNK_LENGTH
00038Ar 1  C5 rr          CMP ZP_SNK_LENGTHR
00038Cr 1  30 0A          BMI @SKP_NEWRECORD                  ; 記録-レコード=負なら更新ならず
00038Er 1  85 rr          STA ZP_SNK_LENGTHR
000390r 1  A5 rr          LDA ZP_MM
000392r 1  85 rr          STA ZP_MMR
000394r 1  A5 rr          LDA ZP_SS
000396r 1  85 rr          STA ZP_SSR
000398r 1               @SKP_NEWRECORD:
000398r 1  20 rr rr       JSR DRAW_ALLLINE                    ; 全部描画
00039Br 1               @LOOP:
00039Br 1                 ; キー入力駆動
00039Br 1  A9 02          LDA #BCOS::BHA_CON_RAWIN_WaitAndNoEcho  ; キー入力待機
00039Dr 1  A2 06 20 03    syscall CON_RAWIN
0003A1r 1  06           
0003A2r 1  C9 0A          CMP #10
0003A4r 1  D0 03          BNE @SKP_GAME
0003A6r 1  4C rr rr       JMP GAME
0003A9r 1               @SKP_GAME:
0003A9r 1  C9 1B          CMP #$1B
0003ABr 1  D0 06          BNE @SKP_ESC
0003ADr 1  A6 rr          LDX ZP_SP
0003AFr 1  9A             TXS
0003B0r 1  4C rr rr       JMP START
0003B3r 1               @SKP_ESC:
0003B3r 1  80 E6          BRA @LOOP
0003B5r 1               
0003B5r 1               ; -------------------------------------------------------------------
0003B5r 1               ;                             尾を動かす
0003B5r 1               ; -------------------------------------------------------------------
0003B5r 1               MOVE_TAIL:
0003B5r 1                 ; 現在の尾を消す
0003B5r 1  A9 20          LDA #CHR_BLANK
0003B7r 1  A6 rr          LDX ZP_SNK_TAIL_X
0003B9r 1  A4 rr          LDY ZP_SNK_TAIL_Y
0003BBr 1  20 rr rr       JSR XY_PUT_DRAW
0003BEr 1                 ; 尾の座標を更新
0003BEr 1  DA             PHX
0003BFr 1  A6 rr          LDX ZP_SNK_TAIL_PTR8
0003C1r 1  BD rr rr       LDA SNAKE_DATA256,X   ; 尾の持つ次の胴体へのDIRECを取得
0003C4r 1  FA             PLX
0003C5r 1  20 rr rr       JSR NEXT_XY           ; 次の尾となる胴体の座標を取得
0003C8r 1                 ; 次の尾の座標とする
0003C8r 1  86 rr          STX ZP_SNK_TAIL_X
0003CAr 1  84 rr          STY ZP_SNK_TAIL_Y
0003CCr 1                 ; 向きリングキューの尾ポインタを移動
0003CCr 1  E6 rr          INC ZP_SNK_TAIL_PTR8
0003CEr 1  60             RTS
0003CFr 1               
0003CFr 1               ; -------------------------------------------------------------------
0003CFr 1               ;                 XY座標のDIREC方向に隣接するXY座標
0003CFr 1               ; -------------------------------------------------------------------
0003CFr 1               NEXT_XY:
0003CFr 1               @RIGHT:
0003CFr 1  C9 08          CMP #RIGHT
0003D1r 1  D0 02          BNE @LEFT
0003D3r 1  E8             INX
0003D4r 1  60             RTS
0003D5r 1               @LEFT:
0003D5r 1  C9 01          CMP #LEFT
0003D7r 1  D0 02          BNE @TOP
0003D9r 1  CA             DEX
0003DAr 1  60             RTS
0003DBr 1               @TOP:
0003DBr 1  C9 04          CMP #TOP
0003DDr 1  D0 02          BNE @BUTTOM
0003DFr 1  88             DEY
0003E0r 1  60             RTS
0003E1r 1               @BUTTOM:
0003E1r 1  C8             INY
0003E2r 1  60             RTS
0003E3r 1               
0003E3r 1               ; -------------------------------------------------------------------
0003E3r 1               ;                           ワクを描画
0003E3r 1               ; -------------------------------------------------------------------
0003E3r 1               DRAW_FRAME:
0003E3r 1                 ; 上
0003E3r 1  A0 00          LDY #0
0003E5r 1  20 rr rr       JSR DRAW_HLINE
0003E8r 1                 ; 下
0003E8r 1  A0 15          LDY #24-1-2
0003EAr 1  20 rr rr       JSR DRAW_HLINE
0003EDr 1                 ; 左右
0003EDr 1  88             DEY
0003EEr 1               @LOOP_SIDE:
0003EEr 1  A2 00          LDX #0
0003F0r 1  A9 1F          LDA #CHR_WALL
0003F2r 1  20 rr rr       JSR XY_PUT
0003F5r 1  A2 1F          LDX #32-1
0003F7r 1  A9 1F          LDA #CHR_WALL
0003F9r 1  20 rr rr       JSR XY_PUT
0003FCr 1  88             DEY
0003FDr 1  D0 EF          BNE @LOOP_SIDE
0003FFr 1  60             RTS
000400r 1               
000400r 1               ; -------------------------------------------------------------------
000400r 1               ;                           横棒を描画
000400r 1               ; -------------------------------------------------------------------
000400r 1               DRAW_HLINE:
000400r 1  A2 00          LDX #0
000402r 1  A9 20          LDA #32
000404r 1  85 rr          STA ZP_ITR
000406r 1               @LOOP:
000406r 1  A9 1F          LDA #CHR_WALL
000408r 1  20 rr rr       JSR XY_PUT
00040Br 1  E8             INX
00040Cr 1  C6 rr          DEC ZP_ITR
00040Er 1  D0 F6          BNE @LOOP
000410r 1                 ;JSR DRAW_LINE_RAW
000410r 1  60             RTS
000411r 1               
000411r 1               ; -------------------------------------------------------------------
000411r 1               ;                         XY位置から読み取り
000411r 1               ; -------------------------------------------------------------------
000411r 1               XY_GET:
000411r 1  DA             PHX
000412r 1  5A             PHY
000413r 1                 ; --- 読み取り
000413r 1  20 rr rr       JSR XY2TRAM_VEC
000416r 1  B1 rr          LDA (ZP_TRAM_VEC16),Y
000418r 1  7A             PLY
000419r 1  FA             PLX
00041Ar 1  60             RTS
00041Br 1               
00041Br 1               ; -------------------------------------------------------------------
00041Br 1               ;                         XY位置に書き込み
00041Br 1               ; -------------------------------------------------------------------
00041Br 1               XY_PUT:
00041Br 1  DA             PHX
00041Cr 1  5A             PHY
00041Dr 1                 ; --- 書き込み
00041Dr 1  48             PHA
00041Er 1  20 rr rr       JSR XY2TRAM_VEC
000421r 1  68             PLA
000422r 1  91 rr          STA (ZP_TRAM_VEC16),Y
000424r 1  7A             PLY
000425r 1  FA             PLX
000426r 1  60             RTS
000427r 1               
000427r 1               ; -------------------------------------------------------------------
000427r 1               ;                    XY位置に書き込み、描画込み
000427r 1               ; -------------------------------------------------------------------
000427r 1               XY_PUT_DRAW:
000427r 1  DA             PHX
000428r 1  5A             PHY
000429r 1                 ; --- 書き込み
000429r 1  48             PHA
00042Ar 1  20 rr rr       JSR XY2TRAM_VEC
00042Dr 1  68             PLA
00042Er 1  91 rr          STA (ZP_TRAM_VEC16),Y
000430r 1  20 rr rr       JSR DRAW_LINE_RAW    ; 呼び出し側の任意
000433r 1  7A             PLY
000434r 1  FA             PLX
000435r 1  60             RTS
000436r 1               
000436r 1               ; -------------------------------------------------------------------
000436r 1               ;                 カーソル位置に書き込み、描画込み
000436r 1               ; -------------------------------------------------------------------
000436r 1               XY2TRAM_VEC:
000436r 1  64 rr          STZ ZP_FONT_SR        ; シフタ初期化
000438r 1  64 rr          STZ ZP_TRAM_VEC16     ; TRAMポインタ初期化
00043Ar 1  98             TYA
00043Br 1  4A             LSR
00043Cr 1  66 rr          ROR ZP_FONT_SR
00043Er 1  4A             LSR
00043Fr 1  66 rr          ROR ZP_FONT_SR
000441r 1  4A             LSR
000442r 1  66 rr          ROR ZP_FONT_SR
000444r 1  65 rr          ADC ZP_TXTVRAM768_16+1
000446r 1  85 rr          STA ZP_TRAM_VEC16+1
000448r 1  8A             TXA
000449r 1  05 rr          ORA ZP_FONT_SR
00044Br 1  A8             TAY
00044Cr 1  60             RTS
00044Dr 1               
00044Dr 1               ; -------------------------------------------------------------------
00044Dr 1               ;                       TRAMをスペースで埋める
00044Dr 1               ; -------------------------------------------------------------------
00044Dr 1               CLEAR_TXTVRAM:
00044Dr 1  A5 rr 85 00    mem2mem16 ZR0,ZP_TXTVRAM768_16
000451r 1  A5 rr 85 01  
000455r 1  A9 20          LDA #' '
000457r 1  A0 00          LDY #0
000459r 1  A2 03          LDX #3
00045Br 1               CLEAR_TXTVRAM_LOOP:
00045Br 1  91 00          STA (ZR0),Y
00045Dr 1  C8             INY
00045Er 1  D0 FB          BNE CLEAR_TXTVRAM_LOOP
000460r 1  E6 01          INC ZR0+1
000462r 1  CA             DEX
000463r 1  D0 F6          BNE CLEAR_TXTVRAM_LOOP
000465r 1  60             RTS
000466r 1               
000466r 1               ; -------------------------------------------------------------------
000466r 1               ;                       TRAMの全行を反映する
000466r 1               ; -------------------------------------------------------------------
000466r 1               DRAW_ALLLINE:
000466r 1  A5 rr 85 rr    mem2mem16 ZP_TRAM_VEC16,ZP_TXTVRAM768_16
00046Ar 1  A5 rr 85 rr  
00046Er 1  A0 00          LDY #0
000470r 1  A2 06          LDX #6
000472r 1               DRAW_ALLLINE_LOOP:
000472r 1  DA             PHX
000473r 1  20 rr rr       JSR DRAW_LINE_RAW
000476r 1  20 rr rr       JSR DRAW_LINE_RAW
000479r 1  20 rr rr       JSR DRAW_LINE_RAW
00047Cr 1  20 rr rr       JSR DRAW_LINE_RAW
00047Fr 1  FA             PLX
000480r 1  CA             DEX
000481r 1  D0 EF          BNE DRAW_ALLLINE_LOOP
000483r 1  60             RTS
000484r 1               
000484r 1               ; -------------------------------------------------------------------
000484r 1               ;                     Yで指定された行を反映する
000484r 1               ; -------------------------------------------------------------------
000484r 1               DRAW_LINE:
000484r 1  20 rr rr       JSR XY2TRAM_VEC
000487r 1               DRAW_LINE_RAW:
000487r 1                 ; 行を描画する
000487r 1                 ; TRAM_VEC16を上位だけ設定しておき、そのなかのインデックスもYで持っておく
000487r 1                 ; 連続実行すると次の行を描画できる
000487r 1  98             TYA                       ; インデックスをAに
000488r 1  29 E0          AND #%11100000            ; 行として意味のある部分を抽出
00048Ar 1  AA             TAX                       ; しばらく使わないXに保存
00048Br 1                 ; HVの初期化
00048Br 1  64 rr          STZ ZP_DRAWTMP_X
00048Dr 1                 ; 0~2のページオフセットを取得
00048Dr 1  A5 rr          LDA ZP_TRAM_VEC16+1
00048Fr 1  38             SEC
000490r 1                 ;SBC #>TXTVRAM768
000490r 1  E5 rr          SBC ZP_TXTVRAM768_16+1
000492r 1  85 rr          STA ZP_DRAWTMP_Y
000494r 1                 ; インデックスの垂直部分3bitを挿入
000494r 1  98             TYA
000495r 1  0A             ASL
000496r 1  26 rr          ROL ZP_DRAWTMP_Y
000498r 1  0A             ASL
000499r 1  26 rr          ROL ZP_DRAWTMP_Y
00049Br 1  0A             ASL
00049Cr 1  26 rr          ROL ZP_DRAWTMP_Y
00049Er 1                 ; 8倍
00049Er 1  A5 rr          LDA ZP_DRAWTMP_Y
0004A0r 1  0A             ASL
0004A1r 1  0A             ASL
0004A2r 1  0A             ASL
0004A3r 1  85 rr          STA ZP_DRAWTMP_Y
0004A5r 1                 ; --- フォント参照ベクタ作成
0004A5r 1               DRAW_TXT_LOOP:
0004A5r 1                 ;LDA #>FONT2048
0004A5r 1  A5 rr          LDA ZP_FONT2048_16+1
0004A7r 1  85 rr          STA ZP_FONT_VEC16+1
0004A9r 1                 ; フォントあぶれ初期化
0004A9r 1  A0 00          LDY #0
0004ABr 1  84 rr          STY ZP_FONT_SR
0004ADr 1                 ; アスキーコード読み取り
0004ADr 1  8A             TXA                       ; 保存していたページ内行を復帰してインデックスに
0004AEr 1  A8             TAY
0004AFr 1  B1 rr          LDA (ZP_TRAM_VEC16),Y
0004B1r 1  0A             ASL                       ; 8倍してあぶれた分をアドレス上位に加算
0004B2r 1  26 rr          ROL ZP_FONT_SR
0004B4r 1  0A             ASL
0004B5r 1  26 rr          ROL ZP_FONT_SR
0004B7r 1  0A             ASL
0004B8r 1  26 rr          ROL ZP_FONT_SR
0004BAr 1  85 rr          STA ZP_FONT_VEC16
0004BCr 1  A5 rr          LDA ZP_FONT_SR
0004BEr 1  65 rr          ADC ZP_FONT_VEC16+1       ; キャリーは最後のROLにより0
0004C0r 1  85 rr          STA ZP_FONT_VEC16+1
0004C2r 1                 ; --- フォント書き込み
0004C2r 1                 ; カーソルセット
0004C2r 1  A5 rr          LDA ZP_DRAWTMP_X
0004C4r 1  8D 02 E6       STA CRTC::VMAH
0004C7r 1                 ; 一文字表示ループ
0004C7r 1  A0 00          LDY #0
0004C9r 1               CHAR_LOOP:
0004C9r 1  A5 rr          LDA ZP_DRAWTMP_Y
0004CBr 1  8D 03 E6       STA CRTC::VMAV
0004CEr 1                 ; フォントデータ読み取り
0004CEr 1  B1 rr          LDA (ZP_FONT_VEC16),Y
0004D0r 1  8D 04 E6       STA CRTC::WDBF
0004D3r 1  E6 rr          INC ZP_DRAWTMP_Y
0004D5r 1  C8             INY
0004D6r 1  C0 08          CPY #8
0004D8r 1  D0 EF          BNE CHAR_LOOP
0004DAr 1                 ; --- 次の文字へアドレス類を更新
0004DAr 1                 ; テキストVRAM読み取りベクタ
0004DAr 1  E8             INX
0004DBr 1  D0 02          BNE SKP_TXTNP
0004DDr 1  E6 rr          INC ZP_TRAM_VEC16+1
0004DFr 1               SKP_TXTNP:
0004DFr 1                 ; H
0004DFr 1  E6 rr          INC ZP_DRAWTMP_X
0004E1r 1  A5 rr          LDA ZP_DRAWTMP_X
0004E3r 1  29 1F          AND #%00011111  ; 左端に戻るたびゼロ
0004E5r 1  D0 03          BNE SKP_EXT_DRAWLINE
0004E7r 1  8A             TXA
0004E8r 1  A8             TAY
0004E9r 1  60             RTS
0004EAr 1               SKP_EXT_DRAWLINE:
0004EAr 1                 ; V
0004EAr 1  38             SEC
0004EBr 1  A5 rr          LDA ZP_DRAWTMP_Y
0004EDr 1  E9 08          SBC #8
0004EFr 1  85 rr          STA ZP_DRAWTMP_Y
0004F1r 1  80 B2          BRA DRAW_TXT_LOOP
0004F3r 1               
0004F3r 1               ; -------------------------------------------------------------------
0004F3r 1               ;                             乱数取得
0004F3r 1               ; -------------------------------------------------------------------
0004F3r 1               GET_RND:
0004F3r 1               X5PLUS1RETRY:
0004F3r 1  B2 rr          LDA (ZP_RND_ADDR16)
0004F5r 1  0A             ASL
0004F6r 1  0A             ASL
0004F7r 1  38             SEC ;+1
0004F8r 1  72 rr          ADC (ZP_RND_ADDR16)
0004FAr 1  92 rr          STA (ZP_RND_ADDR16)
0004FCr 1  60             RTS
0004FDr 1               
0004FDr 1               BYT2ASC:
0004FDr 1                 ; Aで与えられたバイト値をASCII値AYにする
0004FDr 1                 ; Aから先に表示すると良い
0004FDr 1  48             PHA           ; 下位のために保存
0004FEr 1  29 0F          AND #$0F
000500r 1  20 rr rr       JSR NIB2ASC
000503r 1  A8             TAY
000504r 1  68             PLA
000505r 1  4A             LSR           ; 右シフトx4で上位を下位に持ってくる
000506r 1  4A             LSR
000507r 1  4A             LSR
000508r 1  4A             LSR
000509r 1               NIB2ASC:
000509r 1                 ; #$0?をアスキー一文字にする
000509r 1  09 30          ORA #$30
00050Br 1  C9 3A          CMP #$3A
00050Dr 1  90 02          BCC @SKP_ADC  ; Aが$3Aより小さいか等しければ分岐
00050Fr 1  69 06          ADC #$06
000511r 1               @SKP_ADC:
000511r 1  60             RTS
000512r 1               
000512r 1               ; -------------------------------------------------------------------
000512r 1               ;                      バイト値を16進2ケタで表示
000512r 1               ; -------------------------------------------------------------------
000512r 1               XY_PRT_BYT:
000512r 1  5A             PHY
000513r 1  20 rr rr       JSR BYT2ASC
000516r 1  84 00          STY ZR0
000518r 1  7A             PLY
000519r 1  20 rr rr       JSR XY_PUT
00051Cr 1  E8             INX
00051Dr 1  A5 00          LDA ZR0
00051Fr 1  20 rr rr       JSR XY_PUT
000522r 1  60             RTS
000523r 1               
000523r 1               ; -------------------------------------------------------------------
000523r 1               ;                            文字列を表示
000523r 1               ; -------------------------------------------------------------------
000523r 1               XY_PRT_STR:
000523r 1  B2 00          LDA (ZR0)
000525r 1  F0 0C          BEQ @EXT
000527r 1  20 rr rr       JSR XY_PUT
00052Ar 1  E8             INX
00052Br 1  E6 00          INC ZR0
00052Dr 1  D0 02          BNE @SKP_INCH
00052Fr 1  E6 01          INC ZR0+1
000531r 1               @SKP_INCH:
000531r 1  80 F0          BRA XY_PRT_STR
000533r 1               @EXT:
000533r 1  60             RTS
000534r 1               
000534r 1               ; -------------------------------------------------------------------
000534r 1               ;                            時間を表示
000534r 1               ; -------------------------------------------------------------------
000534r 1               XY_PRT_TIME:
000534r 1  DA             PHX
000535r 1  5A             PHY
000536r 1  A5 rr          LDA ZP_MM
000538r 1  20 rr rr       JSR XY_PRT_BYT
00053Br 1  7A             PLY
00053Cr 1  FA             PLX
00053Dr 1  E8             INX
00053Er 1  E8             INX
00053Fr 1  A9 3A          LDA #':'
000541r 1  20 rr rr       JSR XY_PUT
000544r 1  E8             INX
000545r 1  A5 rr          LDA ZP_SS
000547r 1  20 rr rr       JSR XY_PRT_BYT
00054Ar 1  60             RTS
00054Br 1               
00054Br 1               PAD_READ:
00054Br 1                 ; P/S下げる
00054Br 1  AD 00 E2       LDA VIA::PAD_REG
00054Er 1  09 02          ORA #VIA::PAD_PTS
000550r 1  8D 00 E2       STA VIA::PAD_REG
000553r 1                 ; P/S下げる
000553r 1  AD 00 E2       LDA VIA::PAD_REG
000556r 1  29 FD          AND #<~VIA::PAD_PTS
000558r 1  8D 00 E2       STA VIA::PAD_REG
00055Br 1                 ; 読み取りループ
00055Br 1  A2 10          LDX #16
00055Dr 1               @LOOP:
00055Dr 1  AD 00 E2       LDA VIA::PAD_REG        ; データ読み取り
000560r 1                 ; クロック下げる
000560r 1  29 FB          AND #<~VIA::PAD_CLK
000562r 1  8D 00 E2       STA VIA::PAD_REG
000565r 1                 ; 16bit値として格納
000565r 1  6A             ROR
000566r 1  26 rr          ROL ZP_PADSTAT+1
000568r 1  26 rr          ROL ZP_PADSTAT
00056Ar 1                 ; クロック上げる
00056Ar 1  AD 00 E2       LDA VIA::PAD_REG        ; データ読み取り
00056Dr 1  09 04          ORA #VIA::PAD_CLK
00056Fr 1  8D 00 E2       STA VIA::PAD_REG
000572r 1  CA             DEX
000573r 1  D0 E8          BNE @LOOP
000575r 1                 ; 変化はあったか
000575r 1  A5 rr          LDA ZP_PADSTAT
000577r 1  C5 rr          CMP ZP_PRE_PADSTAT
000579r 1  D0 06          BNE CHANGED
00057Br 1  A5 rr          LDA ZP_PRE_PADSTAT+1
00057Dr 1  C5 rr          CMP ZP_PADSTAT+1
00057Fr 1  F0 2B          BEQ NONE
000581r 1               CHANGED:
000581r 1                 ; LOW   : 7|B,Y,SEL,STA,↑,↓,←,→|0
000581r 1                 ; HIGH  : 7|A,X,L,R            |0
000581r 1  A5 rr 85 rr    mem2mem16 ZP_PRE_PADSTAT,ZP_PADSTAT ; 表示するときすなわち状態変化があったとき、前回状態更新
000585r 1  A5 rr 85 rr  
000589r 1  A5 rr          LDA ZP_PADSTAT
00058Br 1  85 rr          STA ZP_SHIFTER
00058Dr 1  A2 FF          LDX #$FF                            ; 対照インデックス
00058Fr 1               @LOOP:
00058Fr 1  E8             INX
000590r 1  E0 08          CPX #8
000592r 1  D0 04          BNE @SKP_LD_HIGH
000594r 1                 ; highの処理に移行
000594r 1  A5 rr          LDA ZP_PADSTAT+1
000596r 1  85 rr          STA ZP_SHIFTER
000598r 1               @SKP_LD_HIGH:
000598r 1  E0 0C          CPX #12
00059Ar 1  F0 10          BEQ NONE
00059Cr 1  BD rr rr       LDA BUTTON2CHAR_LIST,X              ; 対応する文字を取得
00059Fr 1  26 rr          ROL ZP_SHIFTER
0005A1r 1  B0 EC          BCS @LOOP
0005A3r 1                 ; 突っ込むべき文字を入手
0005A3r 1  C9 00          CMP #0
0005A5r 1  F0 05          BEQ NONE
0005A7r 1  A2 2A 20 03    syscall CON_INTERRUPT_CHR
0005ABr 1  06           
0005ACr 1                 ;syscall CON_OUT_CHR
0005ACr 1               NONE:
0005ACr 1  60             RTS
0005ADr 1               
0005ADr 1               ASCII_ENTER = $0A
0005ADr 1               ASCII_ESC   = $1B
0005ADr 1               BUTTON2CHAR_LIST:
0005ADr 1  1B             .BYT ASCII_ESC    ; B
0005AEr 1  00             .BYT 0            ; Y
0005AFr 1  00             .BYT 0            ; SELECT
0005B0r 1  0A             .BYT ASCII_ENTER  ; START
0005B1r 1  77             .BYT 'w'          ; ↑
0005B2r 1  73             .BYT 's'          ; ↓
0005B3r 1  61             .BYT 'a'          ; ←
0005B4r 1  64             .BYT 'd'          ; →
0005B5r 1  0A             .BYT ASCII_ENTER  ; A
0005B6r 1  00             .BYT 0            ; X
0005B7r 1  61             .BYT 'a'          ; L
0005B8r 1  64             .BYT 'd'          ; R
0005B9r 1               
0005B9r 1  4C 65 6E 67  STR_LENGTH: .ASCIIZ         "Length:"
0005BDr 1  74 68 3A 00  
0005C1r 1  52 65 63 6F  STR_RECORD: .ASCIIZ         "Record:"
0005C5r 1  72 64 3A 00  
0005C9r 1  AD EB BE 20  STR_TITLE_SNAKEGAME: .BYT   $AD,$EB,$BE,' ',$D9,$BE,$90,$F1,$0
0005CDr 1  D9 BE 90 F1  
0005D1r 1  00           
0005D2r 1               ;STR_TITLE_DIFNUMS: .ASCIIZ  "123456"
0005D2r 1               ;STR_TITLE_DIFSNK:  .ASCIIZ  "ooO"
0005D2r 1               ;  ********     0
0005D2r 1               ;  *123456*     1
0005D2r 1               ; ←*ooO   *→    2
0005D2r 1               ;  ********     3
0005D2r 1               STR_TITLE_DIF0:
0005D2r 1  12             .BYT CHR_HIDARI_UE
0005D3r 1  10 10 10 10    .REPEAT 6
0005D7r 1  10 10        
0005D9r 1                   .BYT CHR_YOKOBO
0005D9r 1                 .ENDREPEAT
0005D9r 1  13             .BYT CHR_MIGI_UE
0005DAr 1  00             .BYT 0
0005DBr 1               STR_TITLE_DIF1:
0005DBr 1  11 31 32 33    .BYT CHR_TATEBO,"123456",CHR_TATEBO
0005DFr 1  34 35 36 11  
0005E3r 1  00             .BYT 0
0005E4r 1               STR_TITLE_DIF2:
0005E4r 1                 ;.BYT CHR_ALLOWL,CHR_TATEBO,"ooO   ",CHR_TATEBO,CHR_ALLOWR
0005E4r 1  11 6F 6F 4F    .BYT CHR_TATEBO,"ooO   ",CHR_TATEBO
0005E8r 1  20 20 20 11  
0005ECr 1  00             .BYT 0
0005EDr 1               STR_TITLE_DIF3:
0005EDr 1  15             .BYT CHR_HIDARI_SITA
0005EEr 1  10 10 10 10    .REPEAT 6
0005F2r 1  10 10        
0005F4r 1                   .BYT CHR_YOKOBO
0005F4r 1                 .ENDREPEAT
0005F4r 1  14             .BYT CHR_MIGI_SITA
0005F5r 1  00             .BYT 0
0005F6r 1               
0005F6r 1               STR_TITLE_EXIT:
0005F6r 1  20 45 58 49    .ASCIIZ " EXIT"
0005FAr 1  54 00        
0005FCr 1               STR_TITLE_START:
0005FCr 1  2A 53 54 41    .ASCIIZ "*START"
000600r 1  52 54 00     
000603r 1               STR_GAMEOVER:
000603r 1  47 41 4D 45    .ASCIIZ "GAME OVER"
000607r 1  20 4F 56 45  
00060Br 1  52 00        
00060Dr 1               STR_GAMEOVER_PROM:
00060Dr 1  20 28 42 29    .ASCIIZ " (B) to Quit / (A) to Retry"
000611r 1  20 74 6F 20  
000615r 1  51 75 69 74  
000629r 1               
000629r 1  xx xx xx xx  SNAKE_DATA256:  .RES 256
00062Dr 1  xx xx xx xx  
000631r 1  xx xx xx xx  
000729r 1               
000729r 1               
