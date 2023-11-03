ca65 V2.16 - Ubuntu 2.16-2
Main file   : ./com/test/chr-gra.s
Current file: ./com/test/chr-gra.s

000000r 1               ; -------------------------------------------------------------------
000000r 1               ; -------------------------------------------------------------------
000000r 1               ; SNAKEゲームのおこぼれ
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
000000r 1  xx xx        ZP_TXTVRAM768_16:         .RES 2
000002r 1  xx xx        ZP_FONT2048_16:           .RES 2
000004r 1  xx xx        ZP_TRAM_VEC16:            .RES 2  ; TRAM操作用ベクタ
000006r 1  xx xx        ZP_FONT_VEC16:            .RES 2  ; フォント読み取りベクタ
000008r 1  xx           ZP_FONT_SR:               .RES 1  ; FONT_OFST
000009r 1  xx           ZP_X:                     .RES 1
00000Ar 1  xx           ZP_Y:                     .RES 1
00000Br 1  xx           ZP_CURSOR_X:              .RES 1
00000Cr 1  xx           ZP_CURSOR_Y:              .RES 1
00000Dr 1               
00000Dr 1               ; -------------------------------------------------------------------
00000Dr 1               ;                             実行領域
00000Dr 1               ; -------------------------------------------------------------------
00000Dr 1               .CODE
000000r 1               START:
000000r 1                 ; アドレス類を取得
000000r 1  A0 02          LDY #BCOS::BHY_GET_ADDR_txtvram768  ; TRAM
000002r 1  A2 28 20 03    syscall GET_ADDR
000006r 1  06           
000007r 1  85 rr 84 rr    storeAY16 ZP_TXTVRAM768_16
00000Br 1  A0 04          LDY #BCOS::BHY_GET_ADDR_font2048    ; FONT
00000Dr 1  A2 28 20 03    syscall GET_ADDR
000011r 1  06           
000012r 1  85 rr 84 rr    storeAY16 ZP_FONT2048_16
000016r 1                 ; 画面をいじってみる
000016r 1                 ; 初期化
000016r 1  20 rr rr       JSR CLEAR_TXTVRAM                   ; 画面クリア
000019r 1  20 rr rr       JSR DRAW_ALLLINE
00001Cr 1  A9 0A          LDA #10
00001Er 1  85 rr          STA ZP_CURSOR_X
000020r 1  85 rr          STA ZP_CURSOR_Y                     ; カーソルの初期化
000022r 1                 ; 本処理
000022r 1  A9 40          LDA #'@'
000024r 1  20 rr rr       JSR CURSOR_PUT
000027r 1               @LOOP:
000027r 1  A9 02          LDA #BCOS::BHA_CON_RAWIN_WaitAndNoEcho
000029r 1  A2 06 20 03    syscall CON_RAWIN                   ; 入力待機
00002Dr 1  06           
00002Er 1  48             PHA
00002Fr 1  A9 20          LDA #' '
000031r 1  20 rr rr       JSR CURSOR_PUT
000034r 1  68             PLA
000035r 1                 ; wasd
000035r 1               @W:
000035r 1  C9 77          CMP #'w'
000037r 1  D0 02          BNE @S
000039r 1  C6 rr          DEC ZP_CURSOR_Y
00003Br 1               @S:
00003Br 1  C9 73          CMP #'s'
00003Dr 1  D0 02          BNE @A
00003Fr 1  E6 rr          INC ZP_CURSOR_Y
000041r 1               @A:
000041r 1  C9 61          CMP #'a'
000043r 1  D0 02          BNE @D
000045r 1  C6 rr          DEC ZP_CURSOR_X
000047r 1               @D:
000047r 1  C9 64          CMP #'d'
000049r 1  D0 02          BNE @END_WASD
00004Br 1  E6 rr          INC ZP_CURSOR_X
00004Dr 1               @END_WASD:
00004Dr 1  A9 40          LDA #'@'
00004Fr 1  20 rr rr       JSR CURSOR_PUT
000052r 1  80 D3          BRA @LOOP
000054r 1               EXIT:
000054r 1                 ; 大政奉還コード
000054r 1  60             RTS
000055r 1               
000055r 1               CURSOR_GET:
000055r 1                 ; --- 読み取り
000055r 1  20 rr rr       JSR CUR2TRAM_VEC
000058r 1  B1 rr          LDA (ZP_TRAM_VEC16),Y
00005Ar 1  60             RTS
00005Br 1               
00005Br 1               CURSOR_PUT:
00005Br 1                 ; --- 書き込み
00005Br 1  48             PHA
00005Cr 1  20 rr rr       JSR CUR2TRAM_VEC
00005Fr 1  68             PLA
000060r 1  91 rr          STA (ZP_TRAM_VEC16),Y
000062r 1  20 rr rr       JSR DRAW_LINE_RAW
000065r 1  60             RTS
000066r 1               
000066r 1               CUR2TRAM_VEC:
000066r 1  64 rr          STZ ZP_FONT_SR        ; シフタ初期化
000068r 1  64 rr          STZ ZP_TRAM_VEC16     ; TRAMポインタ初期化
00006Ar 1  A5 rr          LDA ZP_CURSOR_Y
00006Cr 1  4A             LSR
00006Dr 1  66 rr          ROR ZP_FONT_SR
00006Fr 1  4A             LSR
000070r 1  66 rr          ROR ZP_FONT_SR
000072r 1  4A             LSR
000073r 1  66 rr          ROR ZP_FONT_SR
000075r 1  65 rr          ADC ZP_TXTVRAM768_16+1
000077r 1  85 rr          STA ZP_TRAM_VEC16+1
000079r 1  A5 rr          LDA ZP_CURSOR_X
00007Br 1  05 rr          ORA ZP_FONT_SR
00007Dr 1  A8             TAY
00007Er 1  60             RTS
00007Fr 1               
00007Fr 1               CLEAR_TXTVRAM:
00007Fr 1  A5 rr 85 00    mem2mem16 ZR0,ZP_TXTVRAM768_16
000083r 1  A5 rr 85 01  
000087r 1  A9 20          LDA #' '
000089r 1  A0 00          LDY #0
00008Br 1  A2 03          LDX #3
00008Dr 1               CLEAR_TXTVRAM_LOOP:
00008Dr 1  91 00          STA (ZR0),Y
00008Fr 1  C8             INY
000090r 1  D0 FB          BNE CLEAR_TXTVRAM_LOOP
000092r 1  E6 01          INC ZR0+1
000094r 1  CA             DEX
000095r 1  D0 F6          BNE CLEAR_TXTVRAM_LOOP
000097r 1  60             RTS
000098r 1               
000098r 1               DRAW_ALLLINE:
000098r 1                 ; TRAMから全行を反映する
000098r 1  A5 rr 85 rr    mem2mem16 ZP_TRAM_VEC16,ZP_TXTVRAM768_16
00009Cr 1  A5 rr 85 rr  
0000A0r 1  A0 00          LDY #0
0000A2r 1  A2 06          LDX #6
0000A4r 1               DRAW_ALLLINE_LOOP:
0000A4r 1  DA             PHX
0000A5r 1  20 rr rr       JSR DRAW_LINE_RAW
0000A8r 1  20 rr rr       JSR DRAW_LINE_RAW
0000ABr 1  20 rr rr       JSR DRAW_LINE_RAW
0000AEr 1  20 rr rr       JSR DRAW_LINE_RAW
0000B1r 1  FA             PLX
0000B2r 1  CA             DEX
0000B3r 1  D0 EF          BNE DRAW_ALLLINE_LOOP
0000B5r 1  60             RTS
0000B6r 1               
0000B6r 1               DRAW_LINE:
0000B6r 1                 ; Yで指定された行を描画する
0000B6r 1  98             TYA                       ; 行数をAに
0000B7r 1  64 rr          STZ ZP_Y                  ; シフト先をクリア
0000B9r 1  0A             ASL                       ; 行数を右にシフト
0000BAr 1  66 rr          ROR ZP_Y                  ; おこぼれをインデックスとするx3
0000BCr 1  0A             ASL
0000BDr 1  66 rr          ROR ZP_Y
0000BFr 1  0A             ASL
0000C0r 1  66 rr          ROR ZP_Y                  ; A:ページ数0~2 ZP_Y:ページ内インデックス行頭
0000C2r 1  18             CLC
0000C3r 1                 ;ADC #>TXTVRAM768          ; TXTVRAM上位に加算
0000C3r 1  65 rr          ADC ZP_TXTVRAM768_16+1    ; TXTVRAM上位に加算
0000C5r 1  85 rr          STA ZP_TRAM_VEC16+1       ; ページ数登録
0000C7r 1  A4 rr          LDY ZP_Y                  ; インデックスをYにロード
0000C9r 1               DRAW_LINE_RAW:
0000C9r 1                 ; 行を描画する
0000C9r 1                 ; TRAM_VEC16を上位だけ設定しておき、そのなかのインデックスもYで持っておく
0000C9r 1                 ; 連続実行すると次の行を描画できる
0000C9r 1  98             TYA                       ; インデックスをAに
0000CAr 1  29 E0          AND #%11100000            ; 行として意味のある部分を抽出
0000CCr 1  AA             TAX                       ; しばらく使わないXに保存
0000CDr 1                 ; HVの初期化
0000CDr 1  64 rr          STZ ZP_X
0000CFr 1                 ; 0~2のページオフセットを取得
0000CFr 1  A5 rr          LDA ZP_TRAM_VEC16+1
0000D1r 1  38             SEC
0000D2r 1                 ;SBC #>TXTVRAM768
0000D2r 1  E5 rr          SBC ZP_TXTVRAM768_16+1
0000D4r 1  85 rr          STA ZP_Y
0000D6r 1                 ; インデックスの垂直部分3bitを挿入
0000D6r 1  98             TYA
0000D7r 1  0A             ASL
0000D8r 1  26 rr          ROL ZP_Y
0000DAr 1  0A             ASL
0000DBr 1  26 rr          ROL ZP_Y
0000DDr 1  0A             ASL
0000DEr 1  26 rr          ROL ZP_Y
0000E0r 1                 ; 8倍
0000E0r 1  A5 rr          LDA ZP_Y
0000E2r 1  0A             ASL
0000E3r 1  0A             ASL
0000E4r 1  0A             ASL
0000E5r 1  85 rr          STA ZP_Y
0000E7r 1                 ; --- フォント参照ベクタ作成
0000E7r 1               DRAW_TXT_LOOP:
0000E7r 1                 ;LDA #>FONT2048
0000E7r 1  A5 rr          LDA ZP_FONT2048_16+1
0000E9r 1  85 rr          STA ZP_FONT_VEC16+1
0000EBr 1                 ; フォントあぶれ初期化
0000EBr 1  A0 00          LDY #0
0000EDr 1  84 rr          STY ZP_FONT_SR
0000EFr 1                 ; アスキーコード読み取り
0000EFr 1  8A             TXA                       ; 保存していたページ内行を復帰してインデックスに
0000F0r 1  A8             TAY
0000F1r 1  B1 rr          LDA (ZP_TRAM_VEC16),Y
0000F3r 1  0A             ASL                       ; 8倍してあぶれた分をアドレス上位に加算
0000F4r 1  26 rr          ROL ZP_FONT_SR
0000F6r 1  0A             ASL
0000F7r 1  26 rr          ROL ZP_FONT_SR
0000F9r 1  0A             ASL
0000FAr 1  26 rr          ROL ZP_FONT_SR
0000FCr 1  85 rr          STA ZP_FONT_VEC16
0000FEr 1  A5 rr          LDA ZP_FONT_SR
000100r 1  65 rr          ADC ZP_FONT_VEC16+1       ; キャリーは最後のROLにより0
000102r 1  85 rr          STA ZP_FONT_VEC16+1
000104r 1                 ; --- フォント書き込み
000104r 1                 ; カーソルセット
000104r 1  A5 rr          LDA ZP_X
000106r 1  8D 02 E6       STA CRTC::VMAH
000109r 1                 ; 一文字表示ループ
000109r 1  A0 00          LDY #0
00010Br 1               CHAR_LOOP:
00010Br 1  A5 rr          LDA ZP_Y
00010Dr 1  8D 03 E6       STA CRTC::VMAV
000110r 1                 ; フォントデータ読み取り
000110r 1  B1 rr          LDA (ZP_FONT_VEC16),Y
000112r 1  8D 04 E6       STA CRTC::WDBF
000115r 1  E6 rr          INC ZP_Y
000117r 1  C8             INY
000118r 1  C0 08          CPY #8
00011Ar 1  D0 EF          BNE CHAR_LOOP
00011Cr 1                 ; --- 次の文字へアドレス類を更新
00011Cr 1                 ; テキストVRAM読み取りベクタ
00011Cr 1  E8             INX
00011Dr 1  D0 02          BNE SKP_TXTNP
00011Fr 1  E6 rr          INC ZP_TRAM_VEC16+1
000121r 1               SKP_TXTNP:
000121r 1                 ; H
000121r 1  E6 rr          INC ZP_X
000123r 1  A5 rr          LDA ZP_X
000125r 1  29 1F          AND #%00011111  ; 左端に戻るたびゼロ
000127r 1  D0 03          BNE SKP_EXT_DRAWLINE
000129r 1  8A             TXA
00012Ar 1  A8             TAY
00012Br 1  60             RTS
00012Cr 1               SKP_EXT_DRAWLINE:
00012Cr 1                 ; V
00012Cr 1  38             SEC
00012Dr 1  A5 rr          LDA ZP_Y
00012Fr 1  E9 08          SBC #8
000131r 1  85 rr          STA ZP_Y
000133r 1  80 B2          BRA DRAW_TXT_LOOP
000135r 1               
000135r 1               
