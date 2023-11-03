ca65 V2.16 - Ubuntu 2.16-2
Main file   : ./com/test/t-kb-ser.s
Current file: ./com/test/t-kb-ser.s

000000r 1               ; -------------------------------------------------------------------
000000r 1               ; T_KB_SER
000000r 1               ; -------------------------------------------------------------------
000000r 1               ; PS2KBのシリアル通信レベルのテストプログラム
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
000000r 1               
000000r 1               ; 定数
000000r 1               VB_DEV  = 2
000000r 1               
000000r 1               ; ゼロページ変数
000000r 1               .ZEROPAGE
000000r 1  xx           VB_COUNT:       .RES 1        ; 垂直同期をこれで分周した周期でスキャンする
000001r 1               
000001r 1               ; 変数
000001r 1               .BSS
000000r 1  xx xx xx xx  STACK:          .RES 16
000004r 1  xx xx xx xx  
000008r 1  xx xx xx xx  
000010r 1  xx           STACK_PTR:      .RES 1
000011r 1  xx xx        VB_STUB:        .RES 2
000013r 1               
000013r 1               .CODE
000000r 1  4C rr rr       JMP INIT          ; PS2スコープをコードの前で定義したいが、セグメントを増やしたくないためジャンプで横着
000003r 1                                   ; まったくアセンブラの都合で増えた余計なジャンプ命令
000003r 1               
000003r 1               .PROC PS2
000003r 1                 .ZEROPAGE
000001r 1                   .INCLUDE "../ps2/zpps2.s"
000001r 2               ; PS/2キーボードドライバZP変数宣言
000001r 2  xx           ZP_DECODE_STATE:    .RES 1        ; SPECIALと共用できないか検討
000002r 2               ; +-------+-------+-------+-------+-------+-------+-------+-------+
000002r 2               ; |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
000002r 2               ; +-------+-------+-------+-------+-------+-------+-------+-------+
000002r 2               ; |   -   |   -   |  BRK  | SHIFT | CTRL  | CAPS  | NUM   |SCROLL |
000002r 2               ; +-------+-------+-------+-------+-------+-------+-------+-------+
000002r 2               ; |                                       |      L    E    D      |
000002r 2               ; +---------------------------------------+-----------------------+
000002r 2                 STATE_CTRL          = %00001000
000002r 2                 STATE_SHIFT         = %00010000
000002r 2                 STATE_BRK           = %00100000
000002r 2               
000002r 2               
000002r 1                 .CODE
000003r 1                   .INCLUDE "../ps2/serial_ps2.s"
000003r 2               ; -------------------------------------------------------------------
000003r 2               ;               PS/2 キーボード シリアル信号ドライバ
000003r 2               ; -------------------------------------------------------------------
000003r 2               ; http://sbc.rictor.org/io/pckb6522.htmlの写経
000003r 2               ; FXT65.incにアクセスできること
000003r 2               ; -------------------------------------------------------------------
000003r 2               ; アセンブル設定スイッチ
000003r 2               TRUE = 1
000003r 2               FALSE = 0
000003r 2               PS2DEBUG = FALSE
000003r 2               
000003r 2               ; -------------------------------------------------------------------
000003r 2               ;                             定数
000003r 2               ; -------------------------------------------------------------------
000003r 2               CPUCLK = 4                ; 一定時間の待機ルーチンに使うCPUクロック[MHz]
000003r 2               INIT_TIMEOUT_MAX = $FF    ; 初期化タイムアウト期間
000003r 2               ; -------------------------------------------------------------------
000003r 2               ; ->KB コマンド
000003r 2               ; -------------------------------------------------------------------
000003r 2               KBCMD_ENABLE_SCAN   = $F4 ; キースキャンを開始する。res:ACK
000003r 2               KBCMD_RESEND_LAST   = $FE ; 再送要求。res:DATA
000003r 2               KBCMD_RESET         = $FF ; リセット。res:ACK
000003r 2               KBCMD_SETLED        = $ED ; LEDの状態を設定。res:ACK
000003r 2                 KBLED_CAPS          = %100
000003r 2                 KBLED_NUM           = %010
000003r 2                 KBLED_SCROLL        = %001
000003r 2               
000003r 2               ; -------------------------------------------------------------------
000003r 2               ; <-KB レスポンス
000003r 2               ; -------------------------------------------------------------------
000003r 2               KBRES_ACK           = $FA ; 通常応答
000003r 2               KBRES_BAT_COMPLET   = $AA ; BATが成功
000003r 2               
000003r 2               ; -------------------------------------------------------------------
000003r 2               ; PS2KBドライバルーチン群
000003r 2               ; -------------------------------------------------------------------
000003r 2               ; INIT: ドライバソフトウェア及びキーボードデバイスの初期化
000003r 2               ; SCAN: データの有無を取得  データなしでA=0、あるとA=非ゼロもしくはGET
000003r 2               ; GET : A=スキャンコード
000003r 2               ; -------------------------------------------------------------------
000003r 2               SCAN:
000003r 2                 ;LDX #(CPUCLK*$50) ; 実測で420usの受信待ち
000003r 2  A2 FF          LDX #$FF
000005r 2                 ; クロックを入力にセット（とあるが両方入力にしている
000005r 2  AD 02 E2       LDA VIA::PS2_DDR
000008r 2  29 CF          AND #<~(VIA::PS2_CLK|VIA::PS2_DAT)
00000Ar 2  8D 02 E2       STA VIA::PS2_DDR
00000Dr 2               @LOOP: ;kbscan1
00000Dr 2  A9 20          LDA #VIA::PS2_CLK ; クロックの                          | 2
00000Fr 2  2C 00 E2       BIT VIA::PS2_REG  ;     状態を取得                      | 4
000012r 2  F0 09          BEQ @READY        ; クロックの立下りつまりデータを検出  | 2
000014r 2  CA             DEX               ; タイマー減少                        | 2
000015r 2  D0 F6          BNE @LOOP         ;                                     | 3 | sum=13  | 13*$FF=3315
000017r 2                                   ;                                     | 0.125us*3315=414us
000017r 2                 ; データが結局ない
000017r 2  20 rr rr       JSR DIS           ; 無効化
00001Ar 2  A9 00          LDA #0            ; データなしを示す0
00001Cr 2  60             RTS
00001Dr 2               @READY: ;kbscan2
00001Dr 2                 ; データがある
00001Dr 2                 ;JSR DIS           ; 無効化
00001Dr 2                 ; 選べる終わり方の選択肢
00001Dr 2                 ;RTS               ; データの有無だけを返す
00001Dr 2                 ;JMP GET           ; 直接スキャンコードを取得
00001Dr 2  DA             PHX                ; 直接GETの途中に突入する
00001Er 2  5A             PHY
00001Fr 2                 ; バイトとパリティのクリア
00001Fr 2  9C rr rr       STZ BYTSAV
000022r 2  9C rr rr       STZ PARITY
000025r 2  A8             TAY
000026r 2  A2 08          LDX #$08            ; ビットカウンタ
000028r 2  4C rr rr       JMP GET_STARTBIT
00002Br 2               
00002Br 2               FLUSH:
00002Br 2                 ; バッファをフラッシュするらしいが実際にはスキャン開始コマンド？
00002Br 2  A9 F4          LDA #KBCMD_ENABLE_SCAN
00002Dr 2               SEND:
00002Dr 2                 ; --- バイトデータを送信する
00002Dr 2  8D rr rr       STA BYTSAV        ; 送信するデータを保存
000030r 2  DA             PHX               ; レジスタ退避
000031r 2  5A             PHY
000032r 2  8D rr rr       STA LASTBYT       ; 失敗に備える
000035r 2                 ; クロックを下げ、データを上げる
000035r 2  AD 00 E2       LDA VIA::PS2_REG
000038r 2  29 DF          AND #<~VIA::PS2_CLK
00003Ar 2  09 10          ORA #VIA::PS2_DAT
00003Cr 2  8D 00 E2       STA VIA::PS2_REG
00003Fr 2                 ; 両ピンを出力に設定
00003Fr 2  AD 02 E2       LDA VIA::PS2_DDR
000042r 2  09 30          ORA #VIA::PS2_CLK|VIA::PS2_DAT
000044r 2  8D 02 E2       STA VIA::PS2_DDR
000047r 2                 ; CPUクロックに応じた遅延64us
000047r 2                 ; NOTE: 割り込み化できないか？
000047r 2                 ;       もともと割込みで呼ばれるんだから無茶を言うな
000047r 2  A9 40          LDA #(CPUCLK*$10)
000049r 2               @WAIT:
000049r 2  3A             DEC
00004Ar 2  D0 FD          BNE @WAIT
00004Cr 2  A0 00          LDY #$00          ; パリティカウンタ
00004Er 2  A2 08          LDX #$08          ; bit カウンタ
000050r 2                 ; 両ピンを下げる
000050r 2  AD 00 E2       LDA VIA::PS2_REG
000053r 2  29 CF          AND #<~(VIA::PS2_CLK|VIA::PS2_DAT)
000055r 2  8D 00 E2       STA VIA::PS2_REG
000058r 2                 ; クロックを入力に設定
000058r 2  AD 02 E2       LDA VIA::PS2_DDR
00005Br 2  29 DF          AND #<~VIA::PS2_CLK
00005Dr 2  8D 02 E2       STA VIA::PS2_DDR
000060r 2  20 rr rr       JSR HL
000063r 2               SENDBIT:                ; シリアル送信
000063r 2  6E rr rr       ROR BYTSAV
000066r 2  B0 0A          BCS MARK
000068r 2                 ; データビットを下げる
000068r 2  AD 00 E2       LDA VIA::PS2_REG
00006Br 2  29 EF          AND #<~VIA::PS2_DAT
00006Dr 2  8D 00 E2       STA VIA::PS2_REG
000070r 2  80 09          BRA NEXT
000072r 2               MARK:
000072r 2                 ; データビットを上げる
000072r 2  AD 00 E2       LDA VIA::PS2_REG
000075r 2  09 10          ORA #VIA::PS2_DAT
000077r 2  8D 00 E2       STA VIA::PS2_REG
00007Ar 2  C8             INY                   ; パリティカウンタカウントアップ
00007Br 2               NEXT:
00007Br 2  20 rr rr       JSR HL
00007Er 2  CA             DEX
00007Fr 2  D0 E2          BNE SENDBIT           ; シリアル送信バイトループ
000081r 2  98             TYA                   ; パリティカウントを処理
000082r 2  29 01          AND #01
000084r 2  D0 0A          BNE PCLR              ; 偶数奇数で分岐
000086r 2                 ; 偶数なら1送信
000086r 2  AD 00 E2       LDA VIA::PS2_REG
000089r 2  09 10          ORA #VIA::PS2_DAT
00008Br 2  8D 00 E2       STA VIA::PS2_REG
00008Er 2  80 08          BRA BACK
000090r 2               PCLR:
000090r 2                 ; 奇数なら0送信
000090r 2  AD 00 E2       LDA VIA::PS2_REG
000093r 2  09 EF          ORA #<~VIA::PS2_DAT
000095r 2  8D 00 E2       STA VIA::PS2_REG
000098r 2               BACK:
000098r 2  20 rr rr       JSR HL
00009Br 2                 ; 両ピンを入力にセット
00009Br 2  AD 02 E2       LDA VIA::PS2_DDR
00009Er 2  29 CF          AND #<~(VIA::PS2_CLK|VIA::PS2_DAT)
0000A0r 2  8D 02 E2       STA VIA::PS2_DDR
0000A3r 2                 ; レジスタ復帰
0000A3r 2  7A             PLY
0000A4r 2  FA             PLX
0000A5r 2  20 rr rr       JSR HL                ; キーボードからのACKを待機
0000A8r 2  D0 75          BNE INIT              ; 0以外であるはずがない…もしそうなら初期化してまえ
0000AAr 2               @WAIT2:
0000AAr 2  AD 00 E2       LDA VIA::PS2_REG
0000ADr 2  29 20          AND #VIA::PS2_CLK
0000AFr 2  F0 F9          BEQ @WAIT2
0000B1r 2               DIS:
0000B1r 2                 ; 送信の無効化
0000B1r 2                 ; クロックを下げる
0000B1r 2  AD 00 E2       LDA VIA::PS2_REG
0000B4r 2  29 DF          AND #<~VIA::PS2_CLK
0000B6r 2  8D 00 E2       STA VIA::PS2_REG
0000B9r 2                 ; データを入力に、クロックを出力に
0000B9r 2  AD 02 E2       LDA VIA::PS2_DDR
0000BCr 2  29 CF          AND #<~(VIA::PS2_CLK|VIA::PS2_DAT)
0000BEr 2  09 20          ORA #VIA::PS2_CLK
0000C0r 2  8D 02 E2       STA VIA::PS2_DDR
0000C3r 2  60             RTS
0000C4r 2               
0000C4r 2               ERROR:
0000C4r 2  A9 FE          LDA #KBCMD_RESEND_LAST
0000C6r 2  20 rr rr       JSR SEND            ; 再送信要求
0000C9r 2               GET:
0000C9r 2  DA             PHX
0000CAr 2  5A             PHY
0000CBr 2                 ; バイトとパリティのクリア
0000CBr 2  A9 00          LDA #$00
0000CDr 2  9C rr rr       STZ BYTSAV
0000D0r 2  9C rr rr       STZ PARITY
0000D3r 2  A8             TAY
0000D4r 2  A2 08          LDX #$08            ; ビットカウンタ
0000D6r 2                 ; 両ピンを入力に
0000D6r 2  AD 02 E2       LDA VIA::PS2_DDR
0000D9r 2  29 CF          AND #<~(VIA::PS2_CLK|VIA::PS2_DAT)
0000DBr 2  8D 02 E2       STA VIA::PS2_DDR
0000DEr 2               WCLKH: ; kbget1
0000DEr 2                 ; クロックが高い間待つ
0000DEr 2  A9 20          LDA #VIA::PS2_CLK
0000E0r 2  2C 00 E2       BIT VIA::PS2_REG
0000E3r 2  D0 F9          BNE WCLKH
0000E5r 2                 ; スタートビットを取得
0000E5r 2               GET_STARTBIT:
0000E5r 2  AD 00 E2       LDA VIA::PS2_REG
0000E8r 2  29 10          AND #VIA::PS2_DAT
0000EAr 2  D0 F2          BNE WCLKH          ; 1だとスタートビットとして不適格なのでやり直し
0000ECr 2               @NEXTBIT:  ; kbget2
0000ECr 2  20 rr rr       JSR HL              ; 次の立下りを待つ
0000EFr 2  18             CLC
0000F0r 2  F0 01          BEQ @SKPSET
0000F2r 2                 ;LSR                ; 獲得したデータビットをキャリーに格納
0000F2r 2  38             SEC
0000F3r 2               @SKPSET:
0000F3r 2  6E rr rr       ROR BYTSAV          ; 変数に保存
0000F6r 2  10 01          BPL @SKPINP
0000F8r 2  C8             INY                 ; パリティ増加
0000F9r 2               @SKPINP: ; kbget3
0000F9r 2  CA             DEX                 ; バイトカウンタ減少
0000FAr 2  D0 F0          BNE @NEXTBIT        ; バイト内ループ
0000FCr 2                 ; バイト終わり
0000FCr 2  20 rr rr       JSR HL              ; パリティビットを取得
0000FFr 2  F0 03          BEQ @SKPINP2        ; パリティビットが0なら何もしない
000101r 2  EE rr rr       INC PARITY          ; 1なら増加
000104r 2               @SKPINP2:
000104r 2  98             TYA                 ; パリティカウントを取得
000105r 2  7A             PLY
000106r 2  FA             PLX
000107r 2  4D rr rr       EOR PARITY          ; パリティビットと比較
00010Ar 2  29 01          AND #$01            ; LSBのみ見る
00010Cr 2  F0 B6          BEQ ERROR           ; パリティエラー
00010Er 2  20 rr rr       JSR HL              ; ストップビットを待機
000111r 2  F0 B1          BEQ ERROR           ; ストップビットエラー
000113r 2  AD rr rr       LDA BYTSAV
000116r 2  F0 B1          BEQ GET             ; 受信バイトが0なら何も受信してないのでもう一度
000118r 2  20 rr rr       JSR DIS
00011Br 2  AD rr rr       LDA BYTSAV
00011Er 2  60             RTS
00011Fr 2               
00011Fr 2               ; -------------------------------------------------------------------
00011Fr 2               ; INIT:キーボードの初期化
00011Fr 2               ; -------------------------------------------------------------------
00011Fr 2               INIT:
00011Fr 2                 ; スペシャルキー状態初期化
00011Fr 2  A9 02          LDA #KBLED_NUM      ; NUMLOCKのみがオン
000121r 2  85 rr          STA ZP_DECODE_STATE
000123r 2               @RESET:
000123r 2                 ; リセットと自己診断
000123r 2  A9 FF          LDA #KBCMD_RESET
000125r 2  20 rr rr       JSR SEND            ; $FF リセットコマンド
000128r 2  20 rr rr       JSR GET
00012Br 2  C9 FA          CMP #KBRES_ACK
00012Dr 2  D0 F4          BNE @RESET          ; ACKが来るまででリセット
00012Fr 2  20 rr rr       JSR GET
000132r 2  C9 AA          CMP #KBRES_BAT_COMPLET
000134r 2  D0 ED          BNE @RESET          ; BATが成功するまでリセット
000136r 2                 ; LED状態更新
000136r 2               SETLED:
000136r 2  A9 ED          LDA #KBCMD_SETLED   ; 変数に従いLEDをセット
000138r 2  20 rr rr       JSR SEND
00013Br 2  20 rr rr       JSR GET
00013Er 2  C9 FA          CMP #KBRES_ACK
000140r 2  D0 F4          BNE SETLED          ; ack待機
000142r 2  A5 rr          LDA ZP_DECODE_STATE         ; スペシャルの下位3bitがLED状態に対応
000144r 2  29 07          AND #%00000111      ; bits 3-7 を0に 不要説あり
000146r 2  20 rr rr       JSR SEND
000149r 2  20 rr rr       JSR GET             ; ackか何かが返る
00014Cr 2                 ;CMP #KBRES_ACK
00014Cr 2                 ;BNE SETLED          ; ack待機
00014Cr 2  60             RTS
00014Dr 2               
00014Dr 2               HL:
00014Dr 2                 ; 次の立下りでのデータを返す
00014Dr 2  A9 20          LDA #VIA::PS2_CLK
00014Fr 2  2C 00 E2       BIT VIA::PS2_REG
000152r 2  F0 F9          BEQ HL              ; クロックがLの期間待つ
000154r 2               @H:
000154r 2  2C 00 E2       BIT VIA::PS2_REG
000157r 2  D0 FB          BNE @H              ; クロックがHの期間待つ
000159r 2  AD 00 E2       LDA VIA::PS2_REG
00015Cr 2  29 10          AND #VIA::PS2_DAT   ; データラインの状態を返す
00015Er 2  60             RTS
00015Fr 2               
00015Fr 2               
00015Fr 1                 .BSS
000013r 1                   .INCLUDE "../ps2/varps2.s"
000013r 2               ; PS/2キーボードドライバ変数宣言
000013r 2               ; コードと徹底分離のこころみ
000013r 2               
000013r 2  xx           BYTSAV:           .RES 1  ; 送受信するバイト
000014r 2  xx           PARITY:           .RES 1  ; パリティ保持
000015r 2  xx           LASTBYT:          .RES 1  ; 受信した最後のバイト
000016r 2               ;SCANCODE_STATE32: .RES 32
000016r 2               
000016r 2               
000016r 1               .ENDPROC
000016r 1               
000016r 1               .CODE
00015Fr 1               INIT:
00015Fr 1                 ; 初期化
00015Fr 1  20 rr rr       JSR PS2::INIT
000162r 1  9C rr rr       STZ STACK_PTR
000165r 1  64 rr          STZ VB_COUNT
000167r 1                 ; 割り込みハンドラの登録
000167r 1  78             SEI
000168r 1  A9 rr A0 rr    loadAY16 VBLANK
00016Cr 1  A2 26 20 03    syscall IRQ_SETHNDR_VB
000170r 1  06           
000171r 1  8D rr rr 8C    storeAY16 VB_STUB
000175r 1  rr rr        
000177r 1  58             CLI
000178r 1               
000178r 1               ; メインループ
000178r 1               LOOP:
000178r 1  A9 01          LDA #1          ; 待ちなしエコーなし
00017Ar 1  A2 06 20 03    syscall CON_RAWIN
00017Er 1  06           
00017Fr 1  C9 71          CMP #'q'
000181r 1  F0 12          BEQ EXIT        ; UART入力があれば終わる
000183r 1  AE rr rr       LDX STACK_PTR
000186r 1  F0 F0          BEQ LOOP        ; スタックが空ならやることなし
000188r 1                 ; 排他的スタック操作
000188r 1  78             SEI
000189r 1  BD rr rr       LDA STACK-1,X
00018Cr 1  CE rr rr       DEC STACK_PTR
00018Fr 1  58             CLI
000190r 1               @GET:
000190r 1  20 rr rr       JSR PRT_BYT     ; バイト表示
000193r 1                 ;JSR PRT_LF      ; 改行
000193r 1  80 E3          BRA LOOP
000195r 1               
000195r 1               EXIT:
000195r 1                 ; 割り込みハンドラの登録抹消
000195r 1  78             SEI
000196r 1  AD rr rr AC    mem2AY16 VB_STUB
00019Ar 1  rr rr        
00019Cr 1  A2 26 20 03    syscall IRQ_SETHNDR_VB
0001A0r 1  06           
0001A1r 1  58             CLI
0001A2r 1  60             RTS
0001A3r 1               
0001A3r 1               ; 垂直同期割り込み処理
0001A3r 1               VBLANK:
0001A3r 1                 ; 分周
0001A3r 1  C6 rr          DEC VB_COUNT
0001A5r 1  D0 12          BNE @EXT
0001A7r 1  A9 02          LDA #VB_DEV
0001A9r 1  85 rr          STA VB_COUNT
0001ABr 1                 ; スキャン
0001ABr 1  20 rr rr       JSR PS2::SCAN
0001AEr 1  F0 09          BEQ @EXT                ; スキャンして0が返ったらデータなし
0001B0r 1                 ; データが返った
0001B0r 1                 ; スタックに積む
0001B0r 1  AE rr rr       LDX STACK_PTR
0001B3r 1  9D rr rr       STA STACK,X
0001B6r 1  EE rr rr       INC STACK_PTR
0001B9r 1               @EXT:
0001B9r 1  6C rr rr       JMP (VB_STUB)           ; 片付けはBCOSにやらせる
0001BCr 1               
0001BCr 1               PRT_BYT:
0001BCr 1  20 rr rr       JSR BYT2ASC
0001BFr 1  5A             PHY
0001C0r 1  20 rr rr       JSR PRT_C_CALL
0001C3r 1  68             PLA
0001C4r 1               PRT_C_CALL:
0001C4r 1  A2 04 20 03    syscall CON_OUT_CHR
0001C8r 1  06           
0001C9r 1  60             RTS
0001CAr 1               
0001CAr 1               PRT_LF:
0001CAr 1                 ; 改行
0001CAr 1  A9 0A          LDA #$A
0001CCr 1  4C rr rr       JMP PRT_C_CALL
0001CFr 1               
0001CFr 1               PRT_S:
0001CFr 1                 ; スペース
0001CFr 1  A9 20          LDA #' '
0001D1r 1  4C rr rr       JMP PRT_C_CALL
0001D4r 1               
0001D4r 1               BYT2ASC:
0001D4r 1                 ; Aで与えられたバイト値をASCII値AYにする
0001D4r 1                 ; Aから先に表示すると良い
0001D4r 1  48             PHA           ; 下位のために保存
0001D5r 1  29 0F          AND #$0F
0001D7r 1  20 rr rr       JSR NIB2ASC
0001DAr 1  A8             TAY
0001DBr 1  68             PLA
0001DCr 1  4A             LSR           ; 右シフトx4で上位を下位に持ってくる
0001DDr 1  4A             LSR
0001DEr 1  4A             LSR
0001DFr 1  4A             LSR
0001E0r 1  20 rr rr       JSR NIB2ASC
0001E3r 1  60             RTS
0001E4r 1               
0001E4r 1               NIB2ASC:
0001E4r 1                 ; #$0?をアスキー一文字にする
0001E4r 1  09 30          ORA #$30
0001E6r 1  C9 3A          CMP #$3A
0001E8r 1  90 02          BCC @SKP_ADC  ; Aが$3Aより小さいか等しければ分岐
0001EAr 1  69 06          ADC #$06
0001ECr 1               @SKP_ADC:
0001ECr 1  60             RTS
0001EDr 1               
0001EDr 1               
