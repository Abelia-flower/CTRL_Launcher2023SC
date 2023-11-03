ca65 V2.16 - Ubuntu 2.16-2
Main file   : ./com/test/t-kb-dec.s
Current file: ./com/test/t-kb-dec.s

000000r 1               ; -------------------------------------------------------------------
000000r 1               ;                         T_KB_DECコマンド
000000r 1               ; -------------------------------------------------------------------
000000r 1               ; PS2のデコードを試すテストプログラム
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
000000r 1               ; -------------------------------------------------------------------
000000r 1               ;                              定数
000000r 1               ; -------------------------------------------------------------------
000000r 1               VB_DEV  = 2        ; 垂直同期をこれで分周した周期でスキャンする
000000r 1               _VB_DEV_ENABLE = VB_DEV-1
000000r 1               
000000r 1               ; -------------------------------------------------------------------
000000r 1               ;                        ゼロページ変数領域
000000r 1               ; -------------------------------------------------------------------
000000r 1               .ZEROPAGE
000000r 1               .IF _VB_DEV_ENABLE
000000r 1  xx             VB_COUNT:           .RES 1
000001r 1               .ENDIF
000001r 1  xx           ZP_PS2SCAN_Q_WR_P:  .RES 1
000002r 1  xx           ZP_PS2SCAN_Q_RD_P:  .RES 1
000003r 1  xx           ZP_PS2SCAN_Q_LEN:   .RES 1
000004r 1  xx           ZP_DECODE_STATE:    .RES 1        ; SPECIALと共用できないか検討
000005r 1               ; +-------+-------+-------+-------+-------+-------+-------+-------+
000005r 1               ; |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
000005r 1               ; +-------+-------+-------+-------+-------+-------+-------+-------+
000005r 1               ; |   -   |   -   |  BRK  | SHIFT | CTRL  | CAPS  | NUM   |SCROLL |
000005r 1               ; +-------+-------+-------+-------+-------+-------+-------+-------+
000005r 1               ; |                                       |      L    E    D      |
000005r 1               ; +---------------------------------------+-----------------------+
000005r 1                 STATE_BRK           = %00100000
000005r 1               
000005r 1               ; -------------------------------------------------------------------
000005r 1               ;                             変数領域
000005r 1               ; -------------------------------------------------------------------
000005r 1               .BSS
000000r 1  xx xx        VB_STUB:          .RES 2
000002r 1  xx xx xx xx  PS2SCAN_Q32:      .RES 32
000006r 1  xx xx xx xx  
00000Ar 1  xx xx xx xx  
000022r 1               
000022r 1               ; -------------------------------------------------------------------
000022r 1               ;                             実行領域
000022r 1               ; -------------------------------------------------------------------
000022r 1               .CODE
000000r 1  4C rr rr       JMP INIT          ; PS2スコープをコードの前で定義したいが、セグメントを増やしたくないためジャンプで横着
000003r 1                                   ; まったくアセンブラの都合で増えた余計なジャンプ命令
000003r 1               
000003r 1               .PROC PS2
000003r 1                 .ZEROPAGE
000005r 1                   .INCLUDE "../ps2/zpps2.s"
000005r 2               ; PS/2キーボードドライバZP変数宣言
000005r 2  xx           ZP_DECODE_STATE:    .RES 1        ; SPECIALと共用できないか検討
000006r 2               ; +-------+-------+-------+-------+-------+-------+-------+-------+
000006r 2               ; |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
000006r 2               ; +-------+-------+-------+-------+-------+-------+-------+-------+
000006r 2               ; |   -   |   -   |  BRK  | SHIFT | CTRL  | CAPS  | NUM   |SCROLL |
000006r 2               ; +-------+-------+-------+-------+-------+-------+-------+-------+
000006r 2               ; |                                       |      L    E    D      |
000006r 2               ; +---------------------------------------+-----------------------+
000006r 2                 STATE_CTRL          = %00001000
000006r 2                 STATE_SHIFT         = %00010000
000006r 2                 STATE_BRK           = %00100000
000006r 2               
000006r 2               
000006r 1                 .BSS
000022r 1                   .INCLUDE "../ps2/varps2.s"
000022r 2               ; PS/2キーボードドライバ変数宣言
000022r 2               ; コードと徹底分離のこころみ
000022r 2               
000022r 2  xx           BYTSAV:           .RES 1  ; 送受信するバイト
000023r 2  xx           PARITY:           .RES 1  ; パリティ保持
000024r 2  xx           LASTBYT:          .RES 1  ; 受信した最後のバイト
000025r 2               ;SCANCODE_STATE32: .RES 32
000025r 2               
000025r 2               
000025r 1                 .CODE
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
00015Fr 1               .ENDPROC
00015Fr 1               
00015Fr 1               .CODE
00015Fr 1               INIT:
00015Fr 1                 ; 初期化
00015Fr 1  20 rr rr       JSR PS2::INIT
000162r 1                 .IF _VB_DEV_ENABLE
000162r 1  A9 02            LDA #VB_DEV
000164r 1  85 rr            STA VB_COUNT
000166r 1                 .ENDIF
000166r 1  64 rr          STZ ZP_PS2SCAN_Q_WR_P
000168r 1  64 rr          STZ ZP_PS2SCAN_Q_RD_P
00016Ar 1  64 rr          STZ ZP_PS2SCAN_Q_LEN
00016Cr 1                 ; 割り込みハンドラの登録
00016Cr 1  78             SEI
00016Dr 1  A9 rr A0 rr    loadAY16 VBLANK
000171r 1  A2 26 20 03    syscall IRQ_SETHNDR_VB
000175r 1  06           
000176r 1  8D rr rr 8C    storeAY16 VB_STUB
00017Ar 1  rr rr        
00017Cr 1  58             CLI
00017Dr 1               
00017Dr 1               ; メインループ
00017Dr 1               LOOP:
00017Dr 1  A9 01          LDA #1            ; 待ちなしエコーなし
00017Fr 1  A2 06 20 03    syscall CON_RAWIN
000183r 1  06           
000184r 1  C9 71          CMP #'q'
000186r 1  F0 21          BEQ EXIT          ; UART入力があれば終わる
000188r 1  A6 rr          LDX ZP_PS2SCAN_Q_LEN ; キュー長さ
00018Ar 1  F0 F1          BEQ LOOP          ; キューが空ならやることなし
00018Cr 1                 ; 排他的キュー操作
00018Cr 1  78             SEI
00018Dr 1  CA             DEX                    ; キュー長さデクリメント
00018Er 1  86 rr          STX ZP_PS2SCAN_Q_LEN   ; キュー長さ更新
000190r 1  A6 rr          LDX ZP_PS2SCAN_Q_RD_P  ; 読み取りポイント取得
000192r 1  BD rr rr       LDA PS2SCAN_Q32,X   ; データ読み取り
000195r 1  E8             INX                    ; 読み取りポイント前進
000196r 1  E0 20          CPX #32
000198r 1  D0 02          BNE @SKP_RDLOOP
00019Ar 1  A2 00          LDX #0
00019Cr 1               @SKP_RDLOOP:
00019Cr 1  86 rr          STX ZP_PS2SCAN_Q_RD_P
00019Er 1  58             CLI
00019Fr 1               @GET:
00019Fr 1  20 rr rr       JSR DECODE
0001A2r 1  F0 D9          BEQ LOOP
0001A4r 1  20 rr rr       JSR PRT_C_CALL   ; バイト表示
0001A7r 1                 ;JSR PRT_LF      ; 改行
0001A7r 1  80 D4          BRA LOOP
0001A9r 1               
0001A9r 1               EXIT:
0001A9r 1                 ; 割り込みハンドラの登録抹消
0001A9r 1  78             SEI
0001AAr 1  AD rr rr AC    mem2AY16 VB_STUB
0001AEr 1  rr rr        
0001B0r 1  A2 26 20 03    syscall IRQ_SETHNDR_VB
0001B4r 1  06           
0001B5r 1  58             CLI
0001B6r 1  60             RTS
0001B7r 1               
0001B7r 1               ; スキャンコードを順に受け取る
0001B7r 1               DECODE:
0001B7r 1                 ; ブレイクコード状態をチェック
0001B7r 1  5F rr 06       BBR5 ZP_DECODE_STATE,@PLAIN     ; ブレイク状態ビットが立っていなかったら普通
0001BAr 1                 ; ブレイクコード
0001BAr 1               @BREAK:
0001BAr 1  57 rr          RMB5 ZP_DECODE_STATE
0001BCr 1  A9 00          LDA #0
0001BEr 1  80 0C          BRA @EXT
0001C0r 1                 ; 曇りなき目
0001C0r 1               @PLAIN:
0001C0r 1  C9 F0          CMP #$F0
0001C2r 1  D0 04          BNE @SKP_SETBREAK
0001C4r 1  D7 rr          SMB5 ZP_DECODE_STATE            ; ブレイク状態ビットセット
0001C6r 1  80 04          BRA @EXT
0001C8r 1               @SKP_SETBREAK:
0001C8r 1                 ; $F0ではない
0001C8r 1  AA             TAX
0001C9r 1  BD rr rr       LDA ASCIITBL,X                  ; ASCII変換
0001CCr 1               @EXT:
0001CCr 1  60             RTS
0001CDr 1               
0001CDr 1               ;*************************************************************
0001CDr 1               ;
0001CDr 1               ; Unshifted table for scancodes to ascii conversion
0001CDr 1               ;                                      Scan|Keyboard
0001CDr 1               ;                                      Code|Key
0001CDr 1               ;                                      ----|----------
0001CDr 1  00           ASCIITBL:      .byte $00               ; 00 no key pressed
0001CEr 1  89                          .byte $89               ; 01 F9
0001CFr 1  87                          .byte $87               ; 02 relocated F7
0001D0r 1  85                          .byte $85               ; 03 F5
0001D1r 1  83                          .byte $83               ; 04 F3
0001D2r 1  81                          .byte $81               ; 05 F1
0001D3r 1  82                          .byte $82               ; 06 F2
0001D4r 1  8C                          .byte $8C               ; 07 F12
0001D5r 1  00                          .byte $00               ; 08
0001D6r 1  8A                          .byte $8A               ; 09 F10
0001D7r 1  88                          .byte $88               ; 0A F8
0001D8r 1  86                          .byte $86               ; 0B F6
0001D9r 1  84                          .byte $84               ; 0C F4
0001DAr 1  09                          .byte $09               ; 0D tab
0001DBr 1  60                          .byte $60               ; 0E `~
0001DCr 1  8F                          .byte $8F               ; 0F relocated Print Screen key
0001DDr 1  03                          .byte $03               ; 10 relocated Pause/Break key
0001DEr 1  A0                          .byte $A0               ; 11 left alt (right alt too)
0001DFr 1  00                          .byte $00               ; 12 left shift
0001E0r 1  E0                          .byte $E0               ; 13 relocated Alt release code
0001E1r 1  00                          .byte $00               ; 14 left ctrl (right ctrl too)
0001E2r 1  71                          .byte $71               ; 15 qQ
0001E3r 1  31                          .byte $31               ; 16 1!
0001E4r 1  00                          .byte $00               ; 17
0001E5r 1  00                          .byte $00               ; 18
0001E6r 1  00                          .byte $00               ; 19
0001E7r 1  7A                          .byte $7A               ; 1A zZ
0001E8r 1  73                          .byte $73               ; 1B sS
0001E9r 1  61                          .byte $61               ; 1C aA
0001EAr 1  77                          .byte $77               ; 1D wW
0001EBr 1  32                          .byte $32               ; 1E 2@
0001ECr 1  A1                          .byte $A1               ; 1F Windows 98 menu key (left side)
0001EDr 1  02                          .byte $02               ; 20 relocated ctrl-break key
0001EEr 1  63                          .byte $63               ; 21 cC
0001EFr 1  78                          .byte $78               ; 22 xX
0001F0r 1  64                          .byte $64               ; 23 dD
0001F1r 1  65                          .byte $65               ; 24 eE
0001F2r 1  34                          .byte $34               ; 25 4$
0001F3r 1  33                          .byte $33               ; 26 3#
0001F4r 1  A2                          .byte $A2               ; 27 Windows 98 menu key (right side)
0001F5r 1  00                          .byte $00               ; 28
0001F6r 1  20                          .byte $20               ; 29 space
0001F7r 1  76                          .byte $76               ; 2A vV
0001F8r 1  66                          .byte $66               ; 2B fF
0001F9r 1  74                          .byte $74               ; 2C tT
0001FAr 1  72                          .byte $72               ; 2D rR
0001FBr 1  35                          .byte $35               ; 2E 5%
0001FCr 1  A3                          .byte $A3               ; 2F Windows 98 option key (right click, right side)
0001FDr 1  00                          .byte $00               ; 30
0001FEr 1  6E                          .byte $6E               ; 31 nN
0001FFr 1  62                          .byte $62               ; 32 bB
000200r 1  68                          .byte $68               ; 33 hH
000201r 1  67                          .byte $67               ; 34 gG
000202r 1  79                          .byte $79               ; 35 yY
000203r 1  36                          .byte $36               ; 36 6^
000204r 1  00                          .byte $00               ; 37
000205r 1  00                          .byte $00               ; 38
000206r 1  00                          .byte $00               ; 39
000207r 1  6D                          .byte $6D               ; 3A mM
000208r 1  6A                          .byte $6A               ; 3B jJ
000209r 1  75                          .byte $75               ; 3C uU
00020Ar 1  37                          .byte $37               ; 3D 7&
00020Br 1  38                          .byte $38               ; 3E 8*
00020Cr 1  00                          .byte $00               ; 3F
00020Dr 1  00                          .byte $00               ; 40
00020Er 1  2C                          .byte $2C               ; 41 ,<
00020Fr 1  6B                          .byte $6B               ; 42 kK
000210r 1  69                          .byte $69               ; 43 iI
000211r 1  6F                          .byte $6F               ; 44 oO
000212r 1  30                          .byte $30               ; 45 0)
000213r 1  39                          .byte $39               ; 46 9(
000214r 1  00                          .byte $00               ; 47
000215r 1  00                          .byte $00               ; 48
000216r 1  2E                          .byte $2E               ; 49 .>
000217r 1  2F                          .byte $2F               ; 4A /?
000218r 1  6C                          .byte $6C               ; 4B lL
000219r 1  3B                          .byte $3B               ; 4C ;:
00021Ar 1  70                          .byte $70               ; 4D pP
00021Br 1  2D                          .byte $2D               ; 4E -_
00021Cr 1  00                          .byte $00               ; 4F
00021Dr 1  00                          .byte $00               ; 50
00021Er 1  00                          .byte $00               ; 51
00021Fr 1  27                          .byte $27               ; 52 '"
000220r 1  00                          .byte $00               ; 53
000221r 1  5B                          .byte $5B               ; 54 [{
000222r 1  3D                          .byte $3D               ; 55 =+
000223r 1  00                          .byte $00               ; 56
000224r 1  00                          .byte $00               ; 57
000225r 1  00                          .byte $00               ; 58 caps
000226r 1  00                          .byte $00               ; 59 r shift
000227r 1  0A                          .byte $0A               ; 5A <Enter>
000228r 1  5D                          .byte $5D               ; 5B ]}
000229r 1  00                          .byte $00               ; 5C
00022Ar 1  5C                          .byte $5C               ; 5D \|
00022Br 1  00                          .byte $00               ; 5E
00022Cr 1  00                          .byte $00               ; 5F
00022Dr 1  00                          .byte $00               ; 60
00022Er 1  00                          .byte $00               ; 61
00022Fr 1  00                          .byte $00               ; 62
000230r 1  00                          .byte $00               ; 63
000231r 1  00                          .byte $00               ; 64
000232r 1  00                          .byte $00               ; 65
000233r 1  08                          .byte $08               ; 66 bkspace
000234r 1  00                          .byte $00               ; 67
000235r 1  00                          .byte $00               ; 68
000236r 1  31                          .byte $31               ; 69 kp 1
000237r 1  2F                          .byte $2f               ; 6A kp / converted from E04A in code
000238r 1  34                          .byte $34               ; 6B kp 4
000239r 1  37                          .byte $37               ; 6C kp 7
00023Ar 1  00                          .byte $00               ; 6D
00023Br 1  00                          .byte $00               ; 6E
00023Cr 1  00                          .byte $00               ; 6F
00023Dr 1  30                          .byte $30               ; 70 kp 0
00023Er 1  2E                          .byte $2E               ; 71 kp .
00023Fr 1  32                          .byte $32               ; 72 kp 2
000240r 1  35                          .byte $35               ; 73 kp 5
000241r 1  36                          .byte $36               ; 74 kp 6
000242r 1  38                          .byte $38               ; 75 kp 8
000243r 1  1B                          .byte $1B               ; 76 esc
000244r 1  00                          .byte $00               ; 77 num lock
000245r 1  8B                          .byte $8B               ; 78 F11
000246r 1  2B                          .byte $2B               ; 79 kp +
000247r 1  33                          .byte $33               ; 7A kp 3
000248r 1  2D                          .byte $2D               ; 7B kp -
000249r 1  2A                          .byte $2A               ; 7C kp *
00024Ar 1  39                          .byte $39               ; 7D kp 9
00024Br 1  8D                          .byte $8D               ; 7E scroll lock
00024Cr 1  00                          .byte $00               ; 7F
00024Dr 1               ;
00024Dr 1               ; Table for shifted scancodes
00024Dr 1               ;
00024Dr 1  00                          .byte $00               ; 80
00024Er 1  C9                          .byte $C9               ; 81 F9
00024Fr 1  C7                          .byte $C7               ; 82 relocated F7
000250r 1  C5                          .byte $C5               ; 83 F5 (F7 actual scancode=83)
000251r 1  C3                          .byte $C3               ; 84 F3
000252r 1  C1                          .byte $C1               ; 85 F1
000253r 1  C2                          .byte $C2               ; 86 F2
000254r 1  CC                          .byte $CC               ; 87 F12
000255r 1  00                          .byte $00               ; 88
000256r 1  CA                          .byte $CA               ; 89 F10
000257r 1  C8                          .byte $C8               ; 8A F8
000258r 1  C6                          .byte $C6               ; 8B F6
000259r 1  C4                          .byte $C4               ; 8C F4
00025Ar 1  09                          .byte $09               ; 8D tab
00025Br 1  7E                          .byte $7E               ; 8E `~
00025Cr 1  CF                          .byte $CF               ; 8F relocated Print Screen key
00025Dr 1  03                          .byte $03               ; 90 relocated Pause/Break key
00025Er 1  A0                          .byte $A0               ; 91 left alt (right alt)
00025Fr 1  00                          .byte $00               ; 92 left shift
000260r 1  E0                          .byte $E0               ; 93 relocated Alt release code
000261r 1  00                          .byte $00               ; 94 left ctrl (and right ctrl)
000262r 1  51                          .byte $51               ; 95 qQ
000263r 1  21                          .byte $21               ; 96 1!
000264r 1  00                          .byte $00               ; 97
000265r 1  00                          .byte $00               ; 98
000266r 1  00                          .byte $00               ; 99
000267r 1  5A                          .byte $5A               ; 9A zZ
000268r 1  53                          .byte $53               ; 9B sS
000269r 1  41                          .byte $41               ; 9C aA
00026Ar 1  57                          .byte $57               ; 9D wW
00026Br 1  40                          .byte $40               ; 9E 2@
00026Cr 1  E1                          .byte $E1               ; 9F Windows 98 menu key (left side)
00026Dr 1  02                          .byte $02               ; A0 relocated ctrl-break key
00026Er 1  43                          .byte $43               ; A1 cC
00026Fr 1  58                          .byte $58               ; A2 xX
000270r 1  44                          .byte $44               ; A3 dD
000271r 1  45                          .byte $45               ; A4 eE
000272r 1  24                          .byte $24               ; A5 4$
000273r 1  23                          .byte $23               ; A6 3#
000274r 1  E2                          .byte $E2               ; A7 Windows 98 menu key (right side)
000275r 1  00                          .byte $00               ; A8
000276r 1  20                          .byte $20               ; A9 space
000277r 1  56                          .byte $56               ; AA vV
000278r 1  46                          .byte $46               ; AB fF
000279r 1  54                          .byte $54               ; AC tT
00027Ar 1  52                          .byte $52               ; AD rR
00027Br 1  25                          .byte $25               ; AE 5%
00027Cr 1  E3                          .byte $E3               ; AF Windows 98 option key (right click, right side)
00027Dr 1  00                          .byte $00               ; B0
00027Er 1  4E                          .byte $4E               ; B1 nN
00027Fr 1  42                          .byte $42               ; B2 bB
000280r 1  48                          .byte $48               ; B3 hH
000281r 1  47                          .byte $47               ; B4 gG
000282r 1  59                          .byte $59               ; B5 yY
000283r 1  5E                          .byte $5E               ; B6 6^
000284r 1  00                          .byte $00               ; B7
000285r 1  00                          .byte $00               ; B8
000286r 1  00                          .byte $00               ; B9
000287r 1  4D                          .byte $4D               ; BA mM
000288r 1  4A                          .byte $4A               ; BB jJ
000289r 1  55                          .byte $55               ; BC uU
00028Ar 1  26                          .byte $26               ; BD 7&
00028Br 1  2A                          .byte $2A               ; BE 8*
00028Cr 1  00                          .byte $00               ; BF
00028Dr 1  00                          .byte $00               ; C0
00028Er 1  3C                          .byte $3C               ; C1 ,<
00028Fr 1  4B                          .byte $4B               ; C2 kK
000290r 1  49                          .byte $49               ; C3 iI
000291r 1  4F                          .byte $4F               ; C4 oO
000292r 1  29                          .byte $29               ; C5 0)
000293r 1  28                          .byte $28               ; C6 9(
000294r 1  00                          .byte $00               ; C7
000295r 1  00                          .byte $00               ; C8
000296r 1  3E                          .byte $3E               ; C9 .>
000297r 1  3F                          .byte $3F               ; CA /?
000298r 1  4C                          .byte $4C               ; CB lL
000299r 1  3A                          .byte $3A               ; CC ;:
00029Ar 1  50                          .byte $50               ; CD pP
00029Br 1  5F                          .byte $5F               ; CE -_
00029Cr 1  00                          .byte $00               ; CF
00029Dr 1  00                          .byte $00               ; D0
00029Er 1  00                          .byte $00               ; D1
00029Fr 1  22                          .byte $22               ; D2 '"
0002A0r 1  00                          .byte $00               ; D3
0002A1r 1  7B                          .byte $7B               ; D4 [{
0002A2r 1  2B                          .byte $2B               ; D5 =+
0002A3r 1  00                          .byte $00               ; D6
0002A4r 1  00                          .byte $00               ; D7
0002A5r 1  00                          .byte $00               ; D8 caps
0002A6r 1  00                          .byte $00               ; D9 r shift
0002A7r 1  0D                          .byte $0D               ; DA <Enter>
0002A8r 1  7D                          .byte $7D               ; DB ]}
0002A9r 1  00                          .byte $00               ; DC
0002AAr 1  7C                          .byte $7C               ; DD \|
0002ABr 1  00                          .byte $00               ; DE
0002ACr 1  00                          .byte $00               ; DF
0002ADr 1  00                          .byte $00               ; E0
0002AEr 1  00                          .byte $00               ; E1
0002AFr 1  00                          .byte $00               ; E2
0002B0r 1  00                          .byte $00               ; E3
0002B1r 1  00                          .byte $00               ; E4
0002B2r 1  00                          .byte $00               ; E5
0002B3r 1  08                          .byte $08               ; E6 bkspace
0002B4r 1  00                          .byte $00               ; E7
0002B5r 1  00                          .byte $00               ; E8
0002B6r 1  91                          .byte $91               ; E9 kp 1
0002B7r 1  2F                          .byte $2f               ; EA kp / converted from E04A in code
0002B8r 1  94                          .byte $94               ; EB kp 4
0002B9r 1  97                          .byte $97               ; EC kp 7
0002BAr 1  00                          .byte $00               ; ED
0002BBr 1  00                          .byte $00               ; EE
0002BCr 1  00                          .byte $00               ; EF
0002BDr 1  90                          .byte $90               ; F0 kp 0
0002BEr 1  7F                          .byte $7F               ; F1 kp .
0002BFr 1  92                          .byte $92               ; F2 kp 2
0002C0r 1  95                          .byte $95               ; F3 kp 5
0002C1r 1  96                          .byte $96               ; F4 kp 6
0002C2r 1  98                          .byte $98               ; F5 kp 8
0002C3r 1  1B                          .byte $1B               ; F6 esc
0002C4r 1  00                          .byte $00               ; F7 num lock
0002C5r 1  CB                          .byte $CB               ; F8 F11
0002C6r 1  2B                          .byte $2B               ; F9 kp +
0002C7r 1  93                          .byte $93               ; FA kp 3
0002C8r 1  2D                          .byte $2D               ; FB kp -
0002C9r 1  2A                          .byte $2A               ; FC kp *
0002CAr 1  99                          .byte $99               ; FD kp 9
0002CBr 1  CD                          .byte $CD               ; FE scroll lock
0002CCr 1               ; NOT USED     .byte $00               ; FF
0002CCr 1               ; end
0002CCr 1               
0002CCr 1               ; -------------------------------------------------------------------
0002CCr 1               ;                          垂直同期割り込み
0002CCr 1               ; -------------------------------------------------------------------
0002CCr 1               VBLANK:
0002CCr 1                 ; 分周
0002CCr 1                 .IF _VB_DEV_ENABLE
0002CCr 1  C6 rr            DEC VB_COUNT
0002CEr 1  D0 19            BNE @EXT
0002D0r 1  A9 02            LDA #VB_DEV
0002D2r 1  85 rr            STA VB_COUNT
0002D4r 1                 .ENDIF
0002D4r 1                 ; スキャン
0002D4r 1  20 rr rr       JSR PS2::SCAN
0002D7r 1  F0 10          BEQ @EXT                    ; スキャンして0が返ったらデータなし
0002D9r 1                 ; データが返った
0002D9r 1                 ; キューに追加
0002D9r 1  A6 rr          LDX ZP_PS2SCAN_Q_WR_P       ; 書き込みポイントを取得（破綻のないことは最後に保証
0002DBr 1  9D rr rr       STA PS2SCAN_Q32,X           ; 値を格納
0002DEr 1  E8             INX
0002DFr 1  E0 20          CPX #32
0002E1r 1  D0 02          BNE @SKP_WRLOOP
0002E3r 1  A2 00          LDX #0
0002E5r 1               @SKP_WRLOOP:
0002E5r 1  86 rr          STX ZP_PS2SCAN_Q_WR_P       ; 書き込みポイント更新
0002E7r 1  E6 rr          INC ZP_PS2SCAN_Q_LEN        ; バッファ長さを更新
0002E9r 1               @EXT:
0002E9r 1  6C rr rr       JMP (VB_STUB)               ; 片付けはBCOSにやらせる
0002ECr 1               
0002ECr 1               ; -------------------------------------------------------------------
0002ECr 1               ;                           汎用ルーチン
0002ECr 1               ; -------------------------------------------------------------------
0002ECr 1               PRT_BYT:
0002ECr 1  20 rr rr       JSR BYT2ASC
0002EFr 1  5A             PHY
0002F0r 1  20 rr rr       JSR PRT_C_CALL
0002F3r 1  68             PLA
0002F4r 1               PRT_C_CALL:
0002F4r 1  A2 04 20 03    syscall CON_OUT_CHR
0002F8r 1  06           
0002F9r 1  60             RTS
0002FAr 1               
0002FAr 1               PRT_LF:
0002FAr 1                 ; 改行
0002FAr 1  A9 0A          LDA #$A
0002FCr 1  4C rr rr       JMP PRT_C_CALL
0002FFr 1               
0002FFr 1               PRT_S:
0002FFr 1                 ; スペース
0002FFr 1  A9 20          LDA #' '
000301r 1  4C rr rr       JMP PRT_C_CALL
000304r 1               
000304r 1               BYT2ASC:
000304r 1                 ; Aで与えられたバイト値をASCII値AYにする
000304r 1                 ; Aから先に表示すると良い
000304r 1  48             PHA           ; 下位のために保存
000305r 1  29 0F          AND #$0F
000307r 1  20 rr rr       JSR NIB2ASC
00030Ar 1  A8             TAY
00030Br 1  68             PLA
00030Cr 1  4A             LSR           ; 右シフトx4で上位を下位に持ってくる
00030Dr 1  4A             LSR
00030Er 1  4A             LSR
00030Fr 1  4A             LSR
000310r 1  20 rr rr       JSR NIB2ASC
000313r 1  60             RTS
000314r 1               
000314r 1               NIB2ASC:
000314r 1                 ; #$0?をアスキー一文字にする
000314r 1  09 30          ORA #$30
000316r 1  C9 3A          CMP #$3A
000318r 1  90 02          BCC @SKP_ADC  ; Aが$3Aより小さいか等しければ分岐
00031Ar 1  69 06          ADC #$06
00031Cr 1               @SKP_ADC:
00031Cr 1  60             RTS
00031Dr 1               
00031Dr 1               
