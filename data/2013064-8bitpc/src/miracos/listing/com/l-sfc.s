ca65 V2.16 - Ubuntu 2.16-2
Main file   : ./com/sfc.s
Current file: ./com/sfc.s

000000r 1               ; -------------------------------------------------------------------
000000r 1               ;                           RDSFCコマンド
000000r 1               ; -------------------------------------------------------------------
000000r 1               ; パッド状態表示テスト
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
000000r 1               ;                             ZP領域
000000r 1               ; -------------------------------------------------------------------
000000r 1               .ZEROPAGE
000000r 1  xx xx        ZP_PADSTAT:               .RES 2
000002r 1  xx xx        ZP_PRE_PADSTAT:           .RES 2
000004r 1  xx           ZP_SHIFTER:               .RES 1
000005r 1                 ; キャラクタ表示モジュール
000005r 1  xx xx        ZP_TXTVRAM768_16:         .RES 2  ; カーネルのワークエリアを借用するためのアドレス
000007r 1  xx xx        ZP_FONT2048_16:           .RES 2  ; カーネルのワークエリアを借用するためのアドレス
000009r 1  xx xx        ZP_TRAM_VEC16:            .RES 2  ; TRAM操作用ベクタ
00000Br 1  xx xx        ZP_FONT_VEC16:            .RES 2  ; フォント読み取りベクタ
00000Dr 1  xx           ZP_FONT_SR:               .RES 1  ; FONT_OFST
00000Er 1  xx           ZP_DRAWTMP_X:             .RES 1  ; 描画用
00000Fr 1  xx           ZP_DRAWTMP_Y:             .RES 1  ; 描画用
000010r 1               
000010r 1               ; -------------------------------------------------------------------
000010r 1               ;                             実行領域
000010r 1               ; -------------------------------------------------------------------
000010r 1               .CODE
000000r 1               START:
000000r 1                 ; 初期化
000000r 1  64 rr          STZ ZP_PRE_PADSTAT+1                ; 変化前の状態をありえない値にして、初回強制上書き
000002r 1                 ; アドレス類を取得
000002r 1  A0 02          LDY #BCOS::BHY_GET_ADDR_txtvram768  ; TRAM
000004r 1  A2 28 20 03    syscall GET_ADDR
000008r 1  06           
000009r 1  85 rr 84 rr    storeAY16 ZP_TXTVRAM768_16
00000Dr 1  A0 04          LDY #BCOS::BHY_GET_ADDR_font2048    ; FONT
00000Fr 1  A2 28 20 03    syscall GET_ADDR
000013r 1  06           
000014r 1  85 rr 84 rr    storeAY16 ZP_FONT2048_16
000018r 1                 ; ボタン値位置参考を表示
000018r 1  20 rr rr       JSR PRT_LF
00001Br 1  A2 01          LDX #1
00001Dr 1  A0 16          LDY #22
00001Fr 1  A9 rr 85 00    loadmem16 ZR0,STR_BUTTON_NAMES
000023r 1  A9 rr 85 01  
000027r 1  20 rr rr       JSR XY_PRT_STR
00002Ar 1  20 rr rr       JSR DRAW_LINE
00002Dr 1                 ; ポートの設定
00002Dr 1  AD 02 E2       LDA VIA::PAD_DDR         ; 0で入力、1で出力
000030r 1  09 06          ORA #(VIA::PAD_CLK|VIA::PAD_PTS)
000032r 1  29 FE          AND #<~(VIA::PAD_DAT)
000034r 1  8D 02 E2       STA VIA::PAD_DDR
000037r 1               READ:
000037r 1  A9 01          LDA #BCOS::BHA_CON_RAWIN_NoWaitNoEcho  ; キー入力チェック
000039r 1  A2 06 20 03    syscall CON_RAWIN
00003Dr 1  06           
00003Er 1  F0 01          BEQ @SKP_RTS
000040r 1  60             RTS
000041r 1               @SKP_RTS:
000041r 1                 ; P/S下げる
000041r 1  AD 00 E2       LDA VIA::PAD_REG
000044r 1  09 02          ORA #VIA::PAD_PTS
000046r 1  8D 00 E2       STA VIA::PAD_REG
000049r 1                 ; P/S下げる
000049r 1  AD 00 E2       LDA VIA::PAD_REG
00004Cr 1  29 FD          AND #<~VIA::PAD_PTS
00004Er 1  8D 00 E2       STA VIA::PAD_REG
000051r 1                 ; 読み取りループ
000051r 1  A2 10          LDX #16
000053r 1               LOOP:
000053r 1  AD 00 E2       LDA VIA::PAD_REG        ; データ読み取り
000056r 1                 ; クロック下げる
000056r 1  29 FB          AND #<~VIA::PAD_CLK
000058r 1  8D 00 E2       STA VIA::PAD_REG
00005Br 1                 ; 16bit値として格納
00005Br 1  6A             ROR
00005Cr 1  26 rr          ROL ZP_PADSTAT+1
00005Er 1  26 rr          ROL ZP_PADSTAT
000060r 1                 ; クロック上げる
000060r 1  AD 00 E2       LDA VIA::PAD_REG        ; データ読み取り
000063r 1  09 04          ORA #VIA::PAD_CLK
000065r 1  8D 00 E2       STA VIA::PAD_REG
000068r 1  CA             DEX
000069r 1  D0 E8          BNE LOOP
00006Br 1                 ; 変化はあったか
00006Br 1  A5 rr          LDA ZP_PADSTAT
00006Dr 1  C5 rr          CMP ZP_PRE_PADSTAT
00006Fr 1  D0 06          BNE PRINT
000071r 1  A5 rr          LDA ZP_PRE_PADSTAT+1
000073r 1  C5 rr          CMP ZP_PADSTAT+1
000075r 1  F0 C0          BEQ READ
000077r 1               
000077r 1               ; 状態表示
000077r 1               PRINT:
000077r 1  A5 rr 85 rr    mem2mem16 ZP_PRE_PADSTAT,ZP_PADSTAT ; 表示するときすなわち状態変化があったとき、前回状態更新
00007Br 1  A5 rr 85 rr  
00007Fr 1                 ; 下位8bit、上位4bitに分けて文字列を生成
00007Fr 1                 ; 下位8bit
00007Fr 1  A5 rr          LDA ZP_PADSTAT
000081r 1  85 rr          STA ZP_SHIFTER
000083r 1               LOW:
000083r 1  A0 00          LDY #0
000085r 1               @ATTRLOOP:
000085r 1  06 rr          ASL ZP_SHIFTER           ; C=ビット情報
000087r 1  90 04          BCC @ATTR_CHR
000089r 1  A9 2D          LDA #'-'                 ; そのビットが立っていないときはハイフンを表示
00008Br 1  80 03          BRA @SKP_ATTR_CHR
00008Dr 1               @ATTR_CHR:
00008Dr 1  B9 rr rr       LDA STR_BUTTON_NAMES,Y   ; 属性文字を表示
000090r 1               @SKP_ATTR_CHR:
000090r 1  99 rr rr       STA STR_WORK,Y           ; 属性文字/-を格納
000093r 1  C8             INY
000094r 1  C0 08          CPY #8
000096r 1  D0 ED          BNE @ATTRLOOP
000098r 1                 ; 上位4bit
000098r 1  A5 rr          LDA ZP_PADSTAT+1
00009Ar 1  85 rr          STA ZP_SHIFTER
00009Cr 1               HIGH:
00009Cr 1  A0 00          LDY #0
00009Er 1               @ATTRLOOP:
00009Er 1  06 rr          ASL ZP_SHIFTER                ; C=ビット情報
0000A0r 1  90 04          BCC @ATTR_CHR
0000A2r 1  A9 2D          LDA #'-'                      ; そのビットが立っていないときはハイフンを表示
0000A4r 1  80 03          BRA @SKP_ATTR_CHR
0000A6r 1               @ATTR_CHR:
0000A6r 1  B9 rr rr       LDA STR_BUTTON_NAMES+8,Y      ; 属性文字を表示
0000A9r 1               @SKP_ATTR_CHR:
0000A9r 1  99 rr rr       STA STR_WORK+8,Y
0000ACr 1  C8             INY
0000ADr 1  C0 04          CPY #4
0000AFr 1  D0 ED          BNE @ATTRLOOP
0000B1r 1               
0000B1r 1                 ; 格納された文字列の表示
0000B1r 1  A2 01          LDX #1
0000B3r 1  A0 17          LDY #23
0000B5r 1  A9 rr 85 00    loadmem16 ZR0,STR_WORK
0000B9r 1  A9 rr 85 01  
0000BDr 1  20 rr rr       JSR XY_PRT_STR
0000C0r 1  20 rr rr       JSR DRAW_LINE
0000C3r 1  4C rr rr       JMP READ
0000C6r 1               
0000C6r 1               ; -------------------------------------------------------------------
0000C6r 1               ;                            文字列を表示
0000C6r 1               ; -------------------------------------------------------------------
0000C6r 1               XY_PRT_STR:
0000C6r 1  B2 00          LDA (ZR0)
0000C8r 1  F0 0C          BEQ @EXT
0000CAr 1  20 rr rr       JSR XY_PUT
0000CDr 1  E8             INX
0000CEr 1  E6 00          INC ZR0
0000D0r 1  D0 02          BNE @SKP_INCH
0000D2r 1  E6 01          INC ZR0+1
0000D4r 1               @SKP_INCH:
0000D4r 1  80 F0          BRA XY_PRT_STR
0000D6r 1               @EXT:
0000D6r 1  60             RTS
0000D7r 1               
0000D7r 1               ; -------------------------------------------------------------------
0000D7r 1               ;                         XY位置に書き込み
0000D7r 1               ; -------------------------------------------------------------------
0000D7r 1               XY_PUT:
0000D7r 1  DA             PHX
0000D8r 1  5A             PHY
0000D9r 1                 ; --- 書き込み
0000D9r 1  48             PHA
0000DAr 1  20 rr rr       JSR XY2TRAM_VEC
0000DDr 1  68             PLA
0000DEr 1  91 rr          STA (ZP_TRAM_VEC16),Y
0000E0r 1  7A             PLY
0000E1r 1  FA             PLX
0000E2r 1  60             RTS
0000E3r 1               
0000E3r 1               ; -------------------------------------------------------------------
0000E3r 1               ;                    XY位置に書き込み、描画込み
0000E3r 1               ; -------------------------------------------------------------------
0000E3r 1               XY_PUT_DRAW:
0000E3r 1  DA             PHX
0000E4r 1  5A             PHY
0000E5r 1                 ; --- 書き込み
0000E5r 1  48             PHA
0000E6r 1  20 rr rr       JSR XY2TRAM_VEC
0000E9r 1  68             PLA
0000EAr 1  91 rr          STA (ZP_TRAM_VEC16),Y
0000ECr 1  20 rr rr       JSR DRAW_LINE_RAW    ; 呼び出し側の任意
0000EFr 1  7A             PLY
0000F0r 1  FA             PLX
0000F1r 1  60             RTS
0000F2r 1               
0000F2r 1               ; -------------------------------------------------------------------
0000F2r 1               ;                 カーソル位置に書き込み、描画込み
0000F2r 1               ; -------------------------------------------------------------------
0000F2r 1               XY2TRAM_VEC:
0000F2r 1  64 rr          STZ ZP_FONT_SR        ; シフタ初期化
0000F4r 1  64 rr          STZ ZP_TRAM_VEC16     ; TRAMポインタ初期化
0000F6r 1  98             TYA
0000F7r 1  4A             LSR
0000F8r 1  66 rr          ROR ZP_FONT_SR
0000FAr 1  4A             LSR
0000FBr 1  66 rr          ROR ZP_FONT_SR
0000FDr 1  4A             LSR
0000FEr 1  66 rr          ROR ZP_FONT_SR
000100r 1  65 rr          ADC ZP_TXTVRAM768_16+1
000102r 1  85 rr          STA ZP_TRAM_VEC16+1
000104r 1  8A             TXA
000105r 1  05 rr          ORA ZP_FONT_SR
000107r 1  A8             TAY
000108r 1  60             RTS
000109r 1               
000109r 1               ; -------------------------------------------------------------------
000109r 1               ;                     Yで指定された行を反映する
000109r 1               ; -------------------------------------------------------------------
000109r 1               DRAW_LINE:
000109r 1  20 rr rr       JSR XY2TRAM_VEC
00010Cr 1               DRAW_LINE_RAW:
00010Cr 1                 ; 行を描画する
00010Cr 1                 ; TRAM_VEC16を上位だけ設定しておき、そのなかのインデックスもYで持っておく
00010Cr 1                 ; 連続実行すると次の行を描画できる
00010Cr 1  98             TYA                       ; インデックスをAに
00010Dr 1  29 E0          AND #%11100000            ; 行として意味のある部分を抽出
00010Fr 1  AA             TAX                       ; しばらく使わないXに保存
000110r 1                 ; HVの初期化
000110r 1  64 rr          STZ ZP_DRAWTMP_X
000112r 1                 ; 0~2のページオフセットを取得
000112r 1  A5 rr          LDA ZP_TRAM_VEC16+1
000114r 1  38             SEC
000115r 1                 ;SBC #>TXTVRAM768
000115r 1  E5 rr          SBC ZP_TXTVRAM768_16+1
000117r 1  85 rr          STA ZP_DRAWTMP_Y
000119r 1                 ; インデックスの垂直部分3bitを挿入
000119r 1  98             TYA
00011Ar 1  0A             ASL
00011Br 1  26 rr          ROL ZP_DRAWTMP_Y
00011Dr 1  0A             ASL
00011Er 1  26 rr          ROL ZP_DRAWTMP_Y
000120r 1  0A             ASL
000121r 1  26 rr          ROL ZP_DRAWTMP_Y
000123r 1                 ; 8倍
000123r 1  A5 rr          LDA ZP_DRAWTMP_Y
000125r 1  0A             ASL
000126r 1  0A             ASL
000127r 1  0A             ASL
000128r 1  85 rr          STA ZP_DRAWTMP_Y
00012Ar 1                 ; --- フォント参照ベクタ作成
00012Ar 1               DRAW_TXT_LOOP:
00012Ar 1                 ;LDA #>FONT2048
00012Ar 1  A5 rr          LDA ZP_FONT2048_16+1
00012Cr 1  85 rr          STA ZP_FONT_VEC16+1
00012Er 1                 ; フォントあぶれ初期化
00012Er 1  A0 00          LDY #0
000130r 1  84 rr          STY ZP_FONT_SR
000132r 1                 ; アスキーコード読み取り
000132r 1  8A             TXA                       ; 保存していたページ内行を復帰してインデックスに
000133r 1  A8             TAY
000134r 1  B1 rr          LDA (ZP_TRAM_VEC16),Y
000136r 1  0A             ASL                       ; 8倍してあぶれた分をアドレス上位に加算
000137r 1  26 rr          ROL ZP_FONT_SR
000139r 1  0A             ASL
00013Ar 1  26 rr          ROL ZP_FONT_SR
00013Cr 1  0A             ASL
00013Dr 1  26 rr          ROL ZP_FONT_SR
00013Fr 1  85 rr          STA ZP_FONT_VEC16
000141r 1  A5 rr          LDA ZP_FONT_SR
000143r 1  65 rr          ADC ZP_FONT_VEC16+1       ; キャリーは最後のROLにより0
000145r 1  85 rr          STA ZP_FONT_VEC16+1
000147r 1                 ; --- フォント書き込み
000147r 1                 ; カーソルセット
000147r 1  A5 rr          LDA ZP_DRAWTMP_X
000149r 1  8D 02 E6       STA CRTC::VMAH
00014Cr 1                 ; 一文字表示ループ
00014Cr 1  A0 00          LDY #0
00014Er 1               CHAR_LOOP:
00014Er 1  A5 rr          LDA ZP_DRAWTMP_Y
000150r 1  8D 03 E6       STA CRTC::VMAV
000153r 1                 ; フォントデータ読み取り
000153r 1  B1 rr          LDA (ZP_FONT_VEC16),Y
000155r 1  8D 04 E6       STA CRTC::WDBF
000158r 1  E6 rr          INC ZP_DRAWTMP_Y
00015Ar 1  C8             INY
00015Br 1  C0 08          CPY #8
00015Dr 1  D0 EF          BNE CHAR_LOOP
00015Fr 1                 ; --- 次の文字へアドレス類を更新
00015Fr 1                 ; テキストVRAM読み取りベクタ
00015Fr 1  E8             INX
000160r 1  D0 02          BNE SKP_TXTNP
000162r 1  E6 rr          INC ZP_TRAM_VEC16+1
000164r 1               SKP_TXTNP:
000164r 1                 ; H
000164r 1  E6 rr          INC ZP_DRAWTMP_X
000166r 1  A5 rr          LDA ZP_DRAWTMP_X
000168r 1  29 1F          AND #%00011111  ; 左端に戻るたびゼロ
00016Ar 1  D0 03          BNE SKP_EXT_DRAWLINE
00016Cr 1  8A             TXA
00016Dr 1  A8             TAY
00016Er 1  60             RTS
00016Fr 1               SKP_EXT_DRAWLINE:
00016Fr 1                 ; V
00016Fr 1  38             SEC
000170r 1  A5 rr          LDA ZP_DRAWTMP_Y
000172r 1  E9 08          SBC #8
000174r 1  85 rr          STA ZP_DRAWTMP_Y
000176r 1  80 B2          BRA DRAW_TXT_LOOP
000178r 1               
000178r 1               
000178r 1               ; -------------------------------------------------------------------
000178r 1               ;                          汎用関数群
000178r 1               ; -------------------------------------------------------------------
000178r 1               BCOS_ERROR:
000178r 1  20 rr rr       JSR PRT_LF
00017Br 1  A2 1A 20 03    syscall ERR_GET
00017Fr 1  06           
000180r 1  A2 1C 20 03    syscall ERR_MES
000184r 1  06           
000185r 1  60             RTS
000186r 1               
000186r 1               PRT_LF:
000186r 1                 ; 改行
000186r 1  A9 0A          LDA #$A
000188r 1  4C rr rr       JMP PRT_C_CALL
00018Br 1               
00018Br 1               PRT_S:
00018Br 1                 ; スペース
00018Br 1  A9 20          LDA #' '
00018Dr 1                 ;JMP PRT_C_CALL
00018Dr 1               PRT_C_CALL:
00018Dr 1  A2 04 20 03    syscall CON_OUT_CHR
000191r 1  06           
000192r 1  60             RTS
000193r 1               
000193r 1               UE      = $C2
000193r 1               SHITA   = $C3
000193r 1               LEFT    = $C1
000193r 1               RIGHT   = $C0
000193r 1               
000193r 1  42 59 23 24  STR_BUTTON_NAMES: .BYT  "BY#$",UE,SHITA,LEFT,RIGHT,"AXLR",0
000197r 1  C2 C3 C1 C0  
00019Br 1  41 58 4C 52  
0001A0r 1  42 59 23 24  STR_WORK: .BYT  "BY#$",UE,SHITA,LEFT,RIGHT,"AXLR",0
0001A4r 1  C2 C3 C1 C0  
0001A8r 1  41 58 4C 52  
0001ADr 1               
0001ADr 1               
