ca65 V2.16 - Ubuntu 2.16-2
Main file   : ./bcos.s
Current file: ./bcos.s

000000r 1               ; -------------------------------------------------------------------
000000r 1               ;                           MIRACOS BCOS
000000r 1               ; -------------------------------------------------------------------
000000r 1               ; MIRACOSの本体
000000r 1               ; CP/MでいうところのBIOSとBDOSを混然一体としたもの
000000r 1               ; ファンクションコール・インタフェース（特に意味はない）
000000r 1               ; -------------------------------------------------------------------
000000r 1               ; アセンブル設定スイッチ
000000r 1               TRUE = 1
000000r 1               FALSE = 0
000000r 1               .IFDEF SRECBUILD
000000r 1               .ELSE
000000r 1                 SRECBUILD = FALSE  ; TRUEで、テスト用のUARTによるロードに適した形にする
000000r 1               .ENDIF
000000r 1               
000000r 1               .IF SRECBUILD
000000r 1                 .OUT "SREC TEST BUILD"
000000r 1               .ELSE
000000r 1                 .OUT "SD RELEASE BUILD"
000000r 1               .ENDIF
000000r 1               
000000r 1               .INCLUDE "FXT65.inc"
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
000000r 1               .INCLUDE "generic.mac"
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
000000r 1               .INCLUDE "fscons.inc"
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
000000r 1               
000000r 1               ; -------------------------------------------------------------------
000000r 1               ;                             定数宣言
000000r 1               ; -------------------------------------------------------------------
000000r 1               .PROC CONDEV
000000r 1                 ; ZP_CON_DEV_CFGでのコンソールデバイス
000000r 1                 UART_IN   = %00000001
000000r 1                 UART_OUT  = %00000010
000000r 1                 PS2       = %00000100
000000r 1                 GCON      = %00001000
000000r 1               .ENDPROC
000000r 1               TIMEOUT_T1H = %01000000
000000r 1               
000000r 1               ; -------------------------------------------------------------------
000000r 1               ;                             変数宣言
000000r 1               ; -------------------------------------------------------------------
000000r 1               ; 変数領域宣言（ZP）
000000r 1               .ZEROPAGE
000000r 1                 .PROC ROMZ
000000r 1                   .INCLUDE "zpmon.s"  ; モニタ用領域は確保するが、それ以外は無視
000000r 2               ; モニタRAM領域（ゼロページ）
000000r 2  xx xx        ZR0:               .RES 2  ; Apple][のA1Lをまねた汎用レジスタ
000002r 2  xx xx        ZR1:               .RES 2
000004r 2  xx xx        ZR2:               .RES 2
000006r 2  xx xx        ZR3:               .RES 2
000008r 2  xx xx        ZR4:               .RES 2
00000Ar 2  xx xx        ZR5:               .RES 2
00000Cr 2  xx           ADDR_INDEX_L:      .RES 1  ; 各所で使うので専用
00000Dr 2  xx           ADDR_INDEX_H:      .RES 1
00000Er 2  xx           ZP_INPUT_BF_WR_P:  .RES 1
00000Fr 2  xx           ZP_INPUT_BF_RD_P:  .RES 1
000010r 2  xx           ZP_INPUT_BF_LEN:   .RES 1
000011r 2  xx           ECHO_F:            .RES 1  ; エコーフラグ
000012r 2               
000012r 2               
000012r 1                 .ENDPROC
000012r 1                 .INCLUDE "gcon/zpgcon.s"
000012r 2               ; コンソール制御用ゼロページ変数
000012r 2  xx xx        ZP_TRAM_VEC16:  .RES 2  ; TRAM操作用ベクタ
000014r 2  xx xx        ZP_FONT_VEC16:  .RES 2  ; フォント読み取りベクタ
000016r 2  xx           ZP_FONT_SR:     .RES 1  ; FONT_OFST
000017r 2  xx           ZP_X:           .RES 1
000018r 2  xx           ZP_Y:           .RES 1
000019r 2               
000019r 2               
000019r 1                 .INCLUDE "fs/zpfs.s"
000019r 2               ; fsのゼロページワークエリア
000019r 2  xx xx        ZP_SDCMDPRM_VEC16:    .RES 2      ; コマンド引数4バイトを指す。アドレスであることが多いか。
00001Br 2  xx xx        ZP_SDSEEK_VEC16:      .RES 2      ; カードレベルのポインタ
00001Dr 2  xx xx        ZP_LSRC0_VEC16:       .RES 2      ; ソースとディスティネーション。32bit演算用
00001Fr 2  xx xx        ZP_LDST0_VEC16:       .RES 2
000021r 2  xx xx        ZP_SWORK0_VEC16:      .RES 2
000023r 2               
000023r 2               
000023r 1                 .INCLUDE "zpbcos.s"
000023r 2  xx           ZP_CON_DEV_CFG:  .RES 1  ; コンソール系デバイスが有効かのフラグ。LSBからUART-IN、UART-OUT、PS/2、GCON
000024r 2  xx xx        ZP_RND16:        .RES 2  ; 割込みなどランダムな要素で隙あらばインクリメントされる
000026r 2               
000026r 2               
000026r 1                 .INCLUDE "ps2/zpps2.s"
000026r 2               ; PS/2キーボードドライバZP変数宣言
000026r 2  xx           ZP_DECODE_STATE:    .RES 1        ; SPECIALと共用できないか検討
000027r 2               ; +-------+-------+-------+-------+-------+-------+-------+-------+
000027r 2               ; |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
000027r 2               ; +-------+-------+-------+-------+-------+-------+-------+-------+
000027r 2               ; |   -   |   -   |  BRK  | SHIFT | CTRL  | CAPS  | NUM   |SCROLL |
000027r 2               ; +-------+-------+-------+-------+-------+-------+-------+-------+
000027r 2               ; |                                       |      L    E    D      |
000027r 2               ; +---------------------------------------+-----------------------+
000027r 2                 STATE_CTRL          = %00001000
000027r 2                 STATE_SHIFT         = %00010000
000027r 2                 STATE_BRK           = %00100000
000027r 2               
000027r 2               
000027r 1               
000027r 1               ; 変数領域定義
000027r 1               .SEGMENT "MONVAR"
000000r 1                 .PROC ROM
000000r 1                   .INCLUDE "varmon.s"
000000r 2               ; モニタRAM領域
000000r 2  xx           SP_SAVE:      .RES 1  ; BRK時の各レジスタのセーブ領域。
000001r 2  xx           A_SAVE:       .RES 1
000002r 2  xx           X_SAVE:       .RES 1
000003r 2  xx           Y_SAVE:       .RES 1
000004r 2  xx xx        ZR0_SAVE:     .RES 2
000006r 2  xx xx        ZR1_SAVE:     .RES 2
000008r 2  xx xx        ZR2_SAVE:     .RES 2
00000Ar 2  xx xx        ZR3_SAVE:     .RES 2
00000Cr 2  xx xx        ZR4_SAVE:     .RES 2
00000Er 2  xx xx        ZR5_SAVE:     .RES 2
000010r 2  xx           LOAD_CKSM:    .RES 1
000011r 2  xx           LOAD_BYTCNT:  .RES 1
000012r 2  xx xx        IRQ_VEC16:    .RES 2  ; 割り込みベクタ
000014r 2               
000014r 2               
000014r 1                 .ENDPROC
000014r 1                 .INCLUDE "fs/structfs.s"
000014r 2               ; ------------------
000014r 2               ; --- 構造体定義 ---
000014r 2               ; ------------------
000014r 2               .STRUCT DINFO
000014r 2                 ; 各ドライブ用変数
000014r 2                 BPB_SECPERCLUS    .RES 1
000014r 2                 PT_LBAOFS         .RES 4  ; セクタ番号
000014r 2                 FATSTART          .RES 4  ; セクタ番号
000014r 2                 DATSTART          .RES 4  ; セクタ番号
000014r 2                 BPB_ROOTCLUS      .RES 4  ; クラスタ番号
000014r 2               .ENDSTRUCT
000014r 2               
000014r 2               .STRUCT FCTRL
000014r 2                 ; 内部的FCB
000014r 2                 DRV_NUM           .RES 1  ; ドライブ番号
000014r 2                 HEAD              .RES 4  ; 先頭クラスタ
000014r 2                 CUR_CLUS          .RES 4  ; 現在クラスタ
000014r 2                 CUR_SEC           .RES 1  ; クラスタ内セクタ
000014r 2                 SIZ               .RES 4  ; サイズ
000014r 2                 SEEK_PTR          .RES 4  ; シーケンシャルアクセス用ポインタ
000014r 2               .ENDSTRUCT
000014r 2               
000014r 2               .STRUCT FINFO
000014r 2                 ; FIB、ファイル詳細情報を取得し、検索などに利用
000014r 2                 SIG               .RES 1  ; $FFシグネチャ、フルパス指定と区別
000014r 2                 NAME              .RES 13 ; 8.3ヌル終端
000014r 2                 ATTR              .RES 1  ; 属性
000014r 2                 WRTIME            .RES 2  ; 最終更新時刻
000014r 2                 WRDATE            .RES 2  ; 最終更新日時
000014r 2                 HEAD              .RES 4  ; 先頭クラスタ番号
000014r 2                 SIZ               .RES 4  ; ファイルサイズ
000014r 2                 ; 次を検索するためのデータ
000014r 2                 DRV_NUM           .RES 1  ; ドライブ番号
000014r 2                 DIR_CLUS          .RES 4  ; 親ディレクトリ現在クラスタ
000014r 2                 DIR_SEC           .RES 1  ; 親ディレクトリ現在クラスタ内セクタ
000014r 2                 DIR_ENT           .RES 1  ; セクタ内エントリ番号（SDSEEKの下位を右に1シフトしてMSBが後半フラグ
000014r 2               .ENDSTRUCT
000014r 2               
000014r 2               
000014r 1                 .INCLUDE "fs/varfs.s"
000014r 2               ; --------------------
000014r 2               ; --- 変数領域定義 ---
000014r 2               ; --------------------
000014r 2               
000014r 2               ; $0514
000014r 2  xx xx xx xx  DRV0:               .TAG DINFO  ; ROMからの引継ぎ
000018r 2  xx xx xx xx  
00001Cr 2  xx xx xx xx  
000025r 2               
000025r 2  xx xx xx xx  RAW_SFN:            .RES 11     ; 11文字
000029r 2  xx xx xx xx  
00002Dr 2  xx xx xx     
000030r 2  xx xx xx xx  DOT_SFN:            .RES 13     ; .とEOTを含んで13文字
000034r 2  xx xx xx xx  
000038r 2  xx xx xx xx  
00003Dr 2  xx           SDCMD_CRC:          .RES 1
00003Er 2  xx xx xx xx  SECVEC32:           .RES 4      ; 4バイト セクタアドレス指定汎用
000042r 2               
000042r 2               ; ファイル記述子テーブル
000042r 2               ; 0=標準入力、1=標準出力、2=エラー出力を除いた3から
000042r 2               ; ゼロページにあるはずないので、上位バイトが0なら未使用
000042r 2               ;FD_TABLE:           .REPEAT FCTRL_ALLOC_SIZE
000042r 2               ; $0542
000042r 2  xx xx xx xx  FD_TABLE:           .REPEAT 4
000046r 2  xx xx xx xx  
00004Ar 2                                     .RES 2
00004Ar 2                                   .ENDREP
00004Ar 2               
00004Ar 2               ; ドライブテーブル
00004Ar 2               ; ドライブ番号0、A:のみ
00004Ar 2               ; $054A
00004Ar 2  xx xx        DRV_TABLE:          .RES 2
00004Cr 2               
00004Cr 2               ; FCTRL置き場の静的確保
00004Cr 2               ;FCTRL_RES:          .REPEAT FCTRL_ALLOC_SIZE
00004Cr 2               ; $054C
00004Cr 2  xx xx xx xx  FCTRL_RES:          .REPEAT 4
000050r 2  xx xx xx xx  
000054r 2  xx xx xx xx  
000094r 2                                     .TAG FCTRL
000094r 2                                   .ENDREP
000094r 2               
000094r 2               ; FINFOのデフォルトワークエリア
000094r 2               ; $0594
000094r 2  xx xx xx xx  FINFO_WK:           .TAG FINFO
000098r 2  xx xx xx xx  
00009Cr 2  xx xx xx xx  
0000B6r 2               
0000B6r 2               ; $05B6
0000B6r 2  xx xx xx xx  DWK:                .TAG DINFO  ; ドライブワークエリア
0000BAr 2  xx xx xx xx  
0000BEr 2  xx xx xx xx  
0000C7r 2  xx           DWK_CUR_DRV:        .RES 1      ; カレントドライブ（無駄リロード阻止用）
0000C8r 2               
0000C8r 2               ; $05C8
0000C8r 2  xx xx xx xx  FWK:                .TAG FCTRL  ; ファイルワークエリア
0000CCr 2  xx xx xx xx  
0000D0r 2  xx xx xx xx  
0000DAr 2               ; $05DA
0000DAr 2  xx xx xx xx  FWK_REAL_SEC:       .RES 4      ; 実際のセクタ
0000DEr 2               
0000DEr 2               
0000DEr 1                 .INCLUDE "varbcos.s"
0000DEr 2               ; bcosの変数定義
0000DEr 2  xx           LAST_ERROR:         .RES 1
0000DFr 2  xx xx        VBLANK_USER_VEC16:  .RES 2
0000E1r 2  xx           TIMEOUT_MS_CNT:     .RES 1
0000E2r 2  xx xx        TIMEOUT_EXIT_VEC16: .RES 2
0000E4r 2  xx           TIMEOUT_STACKPTR:   .RES 1
0000E5r 2               
0000E5r 2               
0000E5r 1                 .INCLUDE "gcon/vargcon.s"
0000E5r 2               ; グラフィックコンソールの非ゼロページ変数
0000E5r 2  xx           COL_BACK:  .RES 1  ; 背景色
0000E6r 2  xx           COL_MAIN:  .RES 1  ; 前面色
0000E7r 2  xx           CURSOR_X:  .RES 1  ; カーソル位置
0000E8r 2  xx           CURSOR_Y:  .RES 1  ; カーソル位置
0000E9r 2               
0000E9r 2               
0000E9r 1                 .INCLUDE "donki/vardonki.s"
0000E9r 2  xx           FLAG_SAVE:  .RES 1
0000EAr 2  xx xx        PC_SAVE:    .RES 2
0000ECr 2               
0000ECr 2               
0000ECr 1                 .INCLUDE "ps2/varps2.s"
0000ECr 2               ; PS/2キーボードドライバ変数宣言
0000ECr 2               ; コードと徹底分離のこころみ
0000ECr 2               
0000ECr 2  xx           BYTSAV:           .RES 1  ; 送受信するバイト
0000EDr 2  xx           PARITY:           .RES 1  ; パリティ保持
0000EEr 2  xx           LASTBYT:          .RES 1  ; 受信した最後のバイト
0000EFr 2               ;SCANCODE_STATE32: .RES 32
0000EFr 2               
0000EFr 2               
0000EFr 1               
0000EFr 1               ; OS側変数領域
0000EFr 1               .SEGMENT "COSVAR"
000000r 1                 .INCLUDE "fs/varfs2.s"
000000r 2               ; VARMONが狭いので分割する必要がある
000000r 2               ;CUR_DIR:            .RES 64     ; カレントディレクトリのパスが入る。二行分でアボン
000000r 2  xx xx xx xx  PATH_WK:            .RES 64
000004r 2  xx xx xx xx  
000008r 2  xx xx xx xx  
000040r 2               
000040r 2               
000040r 1               
000040r 1               ; ROMとの共通バッファ
000040r 1               .SEGMENT "ROMBF100"         ; $0200~
000000r 1  xx xx xx xx    CONINBF_BASE:   .RES 256  ; UART受信用リングバッファ
000004r 1  xx xx xx xx  
000008r 1  xx xx xx xx  
000100r 1  xx xx xx xx    SECBF512:       .RES 512  ; SDカード用セクタバッファ
000104r 1  xx xx xx xx  
000108r 1  xx xx xx xx  
000300r 1               
000300r 1               ; OS独自バッファ
000300r 1               .SEGMENT "COSBF100"
000000r 1  xx xx xx xx    TXTVRAM768:     .RES 768  ; テキストVRAM3ページ
000004r 1  xx xx xx xx  
000008r 1  xx xx xx xx  
000300r 1  xx xx xx xx    FONT2048:       .RES 2048 ; フォントグリフ8ページ
000304r 1  xx xx xx xx  
000308r 1  xx xx xx xx  
000B00r 1               
000B00r 1               ; ROMからのインポート
000B00r 1               ZR0 = ROMZ::ZR0
000B00r 1               ZR1 = ROMZ::ZR1
000B00r 1               ZR2 = ROMZ::ZR2
000B00r 1               ZR3 = ROMZ::ZR3
000B00r 1               ZR4 = ROMZ::ZR4
000B00r 1               ZR5 = ROMZ::ZR5
000B00r 1               ZP_CONINBF_WR_P = ROMZ::ZP_INPUT_BF_WR_P
000B00r 1               ZP_CONINBF_RD_P = ROMZ::ZP_INPUT_BF_RD_P
000B00r 1               ZP_CONINBF_LEN  = ROMZ::ZP_INPUT_BF_LEN
000B00r 1               
000B00r 1               .SCOPE
000B00r 1                 .INCLUDE "ccp.s"
000B00r 2               ; -------------------------------------------------------------------
000B00r 2               ; CCP
000B00r 2               ; -------------------------------------------------------------------
000B00r 2               ; 中国共産党
000B00r 2               ; COSアプリケーションはCCPを食いつぶすことがあり、ウォームブートでカードからリロードされる
000B00r 2               ; つまり特権的地位を持つかもしれないCOSアプリケーションである
000B00r 2               ; -------------------------------------------------------------------
000B00r 2               .INCLUDE "FXT65.inc"
000B00r 3               ; FxT65のハードウェア構成を定義する
000B00r 3               
000B00r 3               .PC02 ; CMOS命令を許可
000B00r 3               
000B00r 3               RAMBASE = $0000
000B00r 3               UARTBASE = $E000
000B00r 3               VIABASE = $E200
000B00r 3               YMZBASE = $E400
000B00r 3               CRTCBASE = $E600
000B00r 3               ROMBASE = $F000
000B00r 3               
000B00r 3               ; UART
000B00r 3               .PROC UART
000B00r 3                 RX = UARTBASE
000B00r 3                 TX = UARTBASE
000B00r 3                 STATUS = UARTBASE+1
000B00r 3                 COMMAND = UARTBASE+2
000B00r 3                 CONTROL = UARTBASE+3
000B00r 3                 .PROC CMD
000B00r 3                   ; PMC1/PMC0/PME/REM/TIC1/TIC0/IRD/DTR
000B00r 3                   ; 全てゼロだと「エコーオフ、RTSオフ、割り込み有効、DTRオフ」
000B00r 3                   RTS_ON =    %00001000
000B00r 3                   ECHO_ON =   %00010000
000B00r 3                   RIRQ_OFF =  %00000010
000B00r 3                   DTR_ON =    %00000001
000B00r 3                 .ENDPROC
000B00r 3                 XON = $11
000B00r 3                 XOFF = $13
000B00r 3               .ENDPROC
000B00r 3               
000B00r 3               ; VIA
000B00r 3               .PROC VIA
000B00r 3                 PORTB = VIABASE
000B00r 3                 PORTA = VIABASE+1
000B00r 3                 DDRB = VIABASE+2
000B00r 3                 DDRA = VIABASE+3
000B00r 3                 T1CL = VIABASE+4
000B00r 3                 T1CH = VIABASE+5
000B00r 3                 T1LL = VIABASE+6
000B00r 3                 T1LH = VIABASE+7
000B00r 3                 SR = VIABASE+$A
000B00r 3                 ACR = VIABASE+$B
000B00r 3                 PCR = VIABASE+$C
000B00r 3                 IFR = VIABASE+$D
000B00r 3                 IER = VIABASE+$E
000B00r 3                 IFR_IRQ = %10000000
000B00r 3                 IER_SET = %10000000
000B00r 3                 IFR_T1  = %01000000
000B00r 3                 IFR_T2  = %00100000
000B00r 3                 IFR_CB1 = %00010000
000B00r 3                 IFR_CB2 = %00001000
000B00r 3                 IFR_SR  = %00000100
000B00r 3                 IFR_CA1 = %00000010
000B00r 3                 IFR_CA2 = %00000001
000B00r 3                 ; 新式
000B00r 3                 SPI_REG    = PORTB
000B00r 3                 SPI_DDR    = DDRB
000B00r 3                 SPI_INOUT  = %10000000  ; 1=in, 0=out
000B00r 3                 SPI_CS0    = %01000000
000B00r 3                 PS2_REG    = PORTB
000B00r 3                 PS2_DDR    = DDRB
000B00r 3                 PS2_CLK    = %00100000
000B00r 3                 PS2_DAT    = %00010000
000B00r 3                 PAD_REG    = PORTB
000B00r 3                 PAD_DDR    = DDRB
000B00r 3                 PAD_CLK    = %00000100
000B00r 3                 PAD_PTS    = %00000010
000B00r 3                 PAD_DAT    = %00000001
000B00r 3               .ENDPROC
000B00r 3               
000B00r 3               ; ChDz
000B00r 3               .PROC CRTC
000B00r 3                 CFG = CRTCBASE+$1   ; コンフィグ
000B00r 3                                         ;   MD0 MD1 MD2 MD3 - - - WCUE
000B00r 3                                         ;   MD : 色モード選択（各フレーム）
000B00r 3                                         ;   WCUE  : 書き込みカウントアップ有効化
000B00r 3               
000B00r 3                 VMAH = CRTCBASE+$2  ; VRAM書き込みアドレス下位
000B00r 3                                         ;   - 6 5 4 3 2 1 0
000B00r 3               
000B00r 3                 VMAV = CRTCBASE+$3  ; VRAM書き込みアドレス上位
000B00r 3                                     ;   7 6 5 4 3 2 1 0
000B00r 3               
000B00r 3                 WDBF = CRTCBASE+$4  ; 書き込みデータ
000B00r 3               
000B00r 3                 RF  = CRTCBASE+$5   ; 出力フレーム選択
000B00r 3                                     ;   (0) 1 0 | (1) 1 0 | (2) 1 0 | (3) 1 0
000B00r 3               
000B00r 3                 WF  = CRTCBASE+$6   ; 書き込みフレーム選択
000B00r 3                                     ;   - - - - - - WF1 WF0
000B00r 3               
000B00r 3                 TCP  = CRTCBASE+$7  ; 2色モード色選択
000B00r 3                                         ;   (0) 3 2 1 0 | (1) 3 2 1 0
000B00r 3               .ENDPROC
000B00r 3               
000B00r 3               ; YMZ
000B00r 3               .PROC YMZ
000B00r 3                 ADDR = YMZBASE
000B00r 3                 DATA = YMZBASE+1
000B00r 3                 ; IR:Internal Address
000B00r 3                 IA_FRQ = $00        ; 各チャンネル周波数
000B00r 3                 IA_NOISE_FRQ = $06  ; ノイズ音周波数
000B00r 3                 IA_MIX = $07        ; ミキサ設定
000B00r 3                 IA_VOL = $08        ; 各チャンネル音量
000B00r 3                 IA_EVLP_FRQ = $0B   ; エンベロープ周波数
000B00r 3                 IA_EVLP_SHAPE = $0D ; エンベロープ形状
000B00r 3               .ENDPROC
000B00r 3               
000B00r 3               
000B00r 2               ;.INCLUDE "generic.mac"   ; BCOSと抱き合わせアセンブルするとダブる
000B00r 2               .INCLUDE "fs/structfs.s"
000B00r 3               ; ------------------
000B00r 3               ; --- 構造体定義 ---
000B00r 3               ; ------------------
000B00r 3               .STRUCT DINFO
000B00r 3                 ; 各ドライブ用変数
000B00r 3                 BPB_SECPERCLUS    .RES 1
000B00r 3                 PT_LBAOFS         .RES 4  ; セクタ番号
000B00r 3                 FATSTART          .RES 4  ; セクタ番号
000B00r 3                 DATSTART          .RES 4  ; セクタ番号
000B00r 3                 BPB_ROOTCLUS      .RES 4  ; クラスタ番号
000B00r 3               .ENDSTRUCT
000B00r 3               
000B00r 3               .STRUCT FCTRL
000B00r 3                 ; 内部的FCB
000B00r 3                 DRV_NUM           .RES 1  ; ドライブ番号
000B00r 3                 HEAD              .RES 4  ; 先頭クラスタ
000B00r 3                 CUR_CLUS          .RES 4  ; 現在クラスタ
000B00r 3                 CUR_SEC           .RES 1  ; クラスタ内セクタ
000B00r 3                 SIZ               .RES 4  ; サイズ
000B00r 3                 SEEK_PTR          .RES 4  ; シーケンシャルアクセス用ポインタ
000B00r 3               .ENDSTRUCT
000B00r 3               
000B00r 3               .STRUCT FINFO
000B00r 3                 ; FIB、ファイル詳細情報を取得し、検索などに利用
000B00r 3                 SIG               .RES 1  ; $FFシグネチャ、フルパス指定と区別
000B00r 3                 NAME              .RES 13 ; 8.3ヌル終端
000B00r 3                 ATTR              .RES 1  ; 属性
000B00r 3                 WRTIME            .RES 2  ; 最終更新時刻
000B00r 3                 WRDATE            .RES 2  ; 最終更新日時
000B00r 3                 HEAD              .RES 4  ; 先頭クラスタ番号
000B00r 3                 SIZ               .RES 4  ; ファイルサイズ
000B00r 3                 ; 次を検索するためのデータ
000B00r 3                 DRV_NUM           .RES 1  ; ドライブ番号
000B00r 3                 DIR_CLUS          .RES 4  ; 親ディレクトリ現在クラスタ
000B00r 3                 DIR_SEC           .RES 1  ; 親ディレクトリ現在クラスタ内セクタ
000B00r 3                 DIR_ENT           .RES 1  ; セクタ内エントリ番号（SDSEEKの下位を右に1シフトしてMSBが後半フラグ
000B00r 3               .ENDSTRUCT
000B00r 3               
000B00r 3               
000B00r 2               .INCLUDE "fscons.inc"
000B00r 3               SD_STBITS = %01000000
000B00r 3               SDCMD0_CRC = $95
000B00r 3               SDCMD8_CRC = $87
000B00r 3               
000B00r 3               ; MBRオフセット
000B00r 3               OFS_MBR_PARTBL = 446
000B00r 3               ; 区画テーブルオフセット
000B00r 3               OFS_PT_SYSTEMID = 4
000B00r 3               OFS_PT_LBAOFS = 8
000B00r 3               ; BIOSパラメータブロックオフセット
000B00r 3               OFS_BPB_SECPERCLUS = 13 ; 1
000B00r 3               OFS_BPB_RSVDSECCNT = 14 ; 2
000B00r 3               OFS_BPB_FATSZ32 = 36    ; 4
000B00r 3               OFS_BPB_ROOTCLUS = 44   ; 4
000B00r 3               ; ディレクトリエントリオフセット
000B00r 3               OFS_DIR_ATTR = 11       ; 1
000B00r 3               OFS_DIR_FSTCLUSHI = 20  ; 2
000B00r 3               OFS_DIR_WRTTIME = 22    ; 2
000B00r 3               OFS_DIR_WRTDATE = 24    ; 2
000B00r 3               OFS_DIR_FSTCLUSLO = 26  ; 2
000B00r 3               OFS_DIR_FILESIZE = 28   ; 4
000B00r 3               ; システム標識
000B00r 3               SYSTEMID_FAT32 = $0B
000B00r 3               SYSTEMID_FAT32NOCHS = $0C
000B00r 3               ; ディレクトリエントリアトリビュート
000B00r 3               DIRATTR_DIRECTORY = $10
000B00r 3               DIRATTR_LONGNAME = $0F
000B00r 3               
000B00r 3               
000B00r 2               .INCLUDE "zr.inc"
000B00r 3               ZR0 = $0000
000B00r 3               ZR1 = $0002
000B00r 3               ZR2 = $0004
000B00r 3               ZR3 = $0006
000B00r 3               ZR4 = $0008
000B00r 3               ZR5 = $000A
000B00r 3               
000B00r 3               
000B00r 2               .PROC BCOS
000B00r 2                 .INCLUDE "syscall.inc"  ; システムコール番号
000B00r 3               ; コール場所
000B00r 3               SYSCALL             = $0603
000B00r 3               ; システムコールテーブル
000B00r 3               RESET               = 0
000B00r 3               CON_IN_CHR          = 1
000B00r 3               CON_OUT_CHR         = 2
000B00r 3               CON_RAWIN           = 3
000B00r 3                 BHA_CON_RAWIN_GetState      = 0
000B00r 3                 BHA_CON_RAWIN_NoWaitNoEcho  = 1
000B00r 3                 BHA_CON_RAWIN_WaitAndNoEcho = 2
000B00r 3               CON_OUT_STR         = 4
000B00r 3               FS_OPEN             = 5
000B00r 3               FS_CLOSE            = 6
000B00r 3               CON_IN_STR          = 7
000B00r 3               GCHR_COL            = 8
000B00r 3               FS_FIND_FST         = 9
000B00r 3               FS_PURSE            = 10
000B00r 3               FS_CHDIR            = 11
000B00r 3               FS_FPATH            = 12
000B00r 3               ERR_GET             = 13
000B00r 3               ERR_MES             = 14
000B00r 3               UPPER_CHR           = 15
000B00r 3               UPPER_STR           = 16
000B00r 3               FS_FIND_NXT         = 17
000B00r 3               FS_READ_BYTS        = 18
000B00r 3               IRQ_SETHNDR_VB      = 19
000B00r 3               GET_ADDR            = 20
000B00r 3                 BHY_GET_ADDR_zprand16       = 0
000B00r 3                 BHY_GET_ADDR_txtvram768     = 1*2
000B00r 3                 BHY_GET_ADDR_font2048       = 2*2
000B00r 3                 BHY_GET_ADDR_condevcfg      = 3*2
000B00r 3               CON_INTERRUPT_CHR   = 21
000B00r 3               TIMEOUT             = 22
000B00r 3               
000B00r 3               
000B00r 2               .ENDPROC
000B00r 2               .INCLUDE "syscall.mac"
000B00r 3               .macro syscall func
000B00r 3                 LDX #(BCOS::func)*2
000B00r 3                 JSR BCOS::SYSCALL
000B00r 3               .endmac
000B00r 3               
000B00r 3               
000B00r 2               
000B00r 2               TPA = $0700
000B00r 2               
000B00r 2               ; -------------------------------------------------------------------
000B00r 2               ;                             変数領域
000B00r 2               ; -------------------------------------------------------------------
000B00r 2               .ZEROPAGE
000027r 2  xx           ZP_ATTR:          .RES 1  ; 属性バイトをシフトして遊ぶ
000028r 2               
000028r 2               .BSS
000000r 2  xx xx xx xx  COMMAND_BUF:      .RES 64 ; コマンド入力バッファ
000004r 2  xx xx xx xx  
000008r 2  xx xx xx xx  
000040r 2               
000040r 2               ; -------------------------------------------------------------------
000040r 2               ;                             実行領域
000040r 2               ; -------------------------------------------------------------------
000040r 2               .CODE
000000r 2               ; -------------------------------------------------------------------
000000r 2               ;                           シェルスタート
000000r 2               ; -------------------------------------------------------------------
000000r 2               START:
000000r 2  A9 rr A0 rr    loadAY16 STR_INITMESSAGE
000004r 2  A2 08 20 03    syscall CON_OUT_STR             ; タイトル表示
000008r 2  06           
000009r 2               
000009r 2               ; -------------------------------------------------------------------
000009r 2               ;                           シェルループ
000009r 2               ; -------------------------------------------------------------------
000009r 2               LOOP:
000009r 2  20 rr rr       JSR PRT_LF
00000Cr 2  A9 rr A0 rr    loadAY16 STR_DOT
000010r 2  A2 18 20 03    syscall FS_FPATH
000014r 2  06           
000015r 2  A2 08 20 03    syscall CON_OUT_STR             ; カレントディレクトリ表示
000019r 2  06           
00001Ar 2  A9 3E          LDA #'>'
00001Cr 2  A2 04 20 03    syscall CON_OUT_CHR             ; プロンプト表示
000020r 2  06           
000021r 2  A9 40          LDA #64                         ; バッファ長さ指定
000023r 2  85 00          STA ZR0
000025r 2  A9 rr A0 rr    loadAY16 COMMAND_BUF            ; バッファ指定
000029r 2  A2 0E 20 03    syscall CON_IN_STR              ; バッファ行入力
00002Dr 2  06           
00002Er 2  A9 rr A0 rr    loadAY16 COMMAND_BUF            ; バッファ指定
000032r 2  A2 20 20 03    syscall UPPER_STR               ; 大文字変換
000036r 2  06           
000037r 2               ; コマンドライン解析
000037r 2  AD rr rr       LDA COMMAND_BUF                 ; バッファ先頭を取得
00003Ar 2  F0 CD          BEQ LOOP                        ; バッファ長さ0ならとりやめ
00003Cr 2  20 rr rr       JSR PRT_LF                      ; コマンド入力後の改行は、無入力ではやらない
00003Fr 2               ; コマンド名と引数の分離
00003Fr 2  A2 FF          LDX #$FF
000041r 2               @CMDNAME_LOOP:
000041r 2  E8             INX
000042r 2  BD rr rr       LDA COMMAND_BUF,X
000045r 2  F0 09          BEQ @CMDNAME_0END               ; 引数がなかった
000047r 2  C9 20          CMP #' '                        ; 空白か？
000049r 2  D0 F6          BNE @CMDNAME_LOOP
00004Br 2  9E rr rr       STZ COMMAND_BUF,X               ; 空白をヌルに
00004Er 2  80 03          BRA @PUSH_ARG
000050r 2               @CMDNAME_0END:
000050r 2  9E rr rr       STZ COMMAND_BUF+1,X             ; ダブル0で引数がないことを示す
000053r 2               @PUSH_ARG:                        ; COMMAND_BUF+X+1=引数先頭を渡したい
000053r 2  8A             TXA
000054r 2  38             SEC
000055r 2  69 rr          ADC #<COMMAND_BUF
000057r 2  48             PHA                             ; 下位をプッシュ
000058r 2  A9 00          LDA #0
00005Ar 2  69 rr          ADC #>COMMAND_BUF
00005Cr 2  48             PHA                             ; 上位をプッシュ
00005Dr 2               @SEARCH_ICOM:
00005Dr 2  A2 00          LDX #0                          ; 内部コマンド番号初期化
00005Fr 2  A9 rr 85 00    loadmem16 ZR0,COMMAND_BUF       ; 入力されたコマンドをZR0に
000063r 2  A9 rr 85 01  
000067r 2  A9 rr 85 02    loadmem16 ZR1,ICOMNAMES         ; 内部コマンド名称配列をZR1に
00006Br 2  A9 rr 85 03  
00006Fr 2               @NEXT_ICOM:
00006Fr 2  20 rr rr       JSR M_EQ                        ; 両ポインタは等しいか？
000072r 2  F0 1A          BEQ EXEC_ICOM                   ; 等しければ実行する（Xが渡る
000074r 2  20 rr rr       JSR M_LEN_ZR1
000077r 2  C0 00          CPY #0
000079r 2  F0 1B          BEQ ICOM_NOTFOUND
00007Br 2  C8             INY                             ; 内部コマンド名称インデックスを次の先頭に
00007Cr 2  98             TYA
00007Dr 2  18             CLC
00007Er 2  65 02          ADC ZR1                         ; 内部コマンド名称インデックスをポインタに反映
000080r 2  85 02          STA ZR1
000082r 2  A9 00          LDA #0
000084r 2  65 03          ADC ZR1+1
000086r 2  85 03          STA ZR1+1
000088r 2  E8             INX                             ; 内部コマンド番号インデックスを増加
000089r 2  D0 E4          BNE @NEXT_ICOM                  ; Xが一周しないうちは周回
00008Br 2  4C rr rr       JMP ICOM_NOTFOUND               ; このジャンプはおそらく呼ばれえない
00008Er 2               EXEC_ICOM:                        ; Xで渡された内部コマンド番号を実行する
00008Er 2  8A             TXA                             ; Xを作業のためAに
00008Fr 2  0A             ASL                             ; Xをx2
000090r 2  AA             TAX                             ; Xを戻す
000091r 2  7A             PLY                             ; 引数をAYに渡す
000092r 2  68             PLA
000093r 2  7C rr rr       JMP (ICOMVECS,X)
000096r 2               
000096r 2               ; -------------------------------------------------------------------
000096r 2               ;                          内部コマンド
000096r 2               ; -------------------------------------------------------------------
000096r 2               
000096r 2               ; -------------------------------------------------------------------
000096r 2               ;                    内部コマンドが見つからない
000096r 2               ; -------------------------------------------------------------------
000096r 2               ICOM_NOTFOUND:
000096r 2                 ; 外部コマンド実行（引数がプッシュされている
000096r 2               FIND_CURDIRCOM:
000096r 2                 ; カレントディレクトリでの検索
000096r 2  A9 rr A0 rr    loadAY16 COMMAND_BUF            ; 元のコマンド行を（壊してないっけか？
00009Ar 2  A2 12 20 03    syscall FS_FIND_FST             ; 検索
00009Er 2  06           
00009Fr 2  90 3F          BCC OCOM_FOUND                  ; 見つかったらパス検索しない
0000A1r 2               FIND_INSTALLEDCOM:
0000A1r 2                 ; パスの通った部分での検索
0000A1r 2                 ; /チェック
0000A1r 2  A9 rr A0 rr    loadAY16 COMMAND_BUF            ; 元のコマンド行を
0000A5r 2  A2 14 20 03    syscall FS_PURSE                ; パース
0000A9r 2  06           
0000AAr 2  CF 02 66       BBS4 ZR1,COMMAND_NOTFOUND       ; /を含むパスならあきらめる
0000ADr 2                 ; 長さチェック
0000ADr 2  A9 rr A0 rr    loadAY16 COMMAND_BUF            ; 元のコマンド行を
0000B1r 2  20 rr rr       JSR M_LEN                       ; 長さ取得
0000B4r 2  C0 09          CPY #$9
0000B6r 2  B0 5B          BCS COMMAND_NOTFOUND            ; 8文字を超える（A>=9）ならあきらめる
0000B8r 2                 ; 検索に着手
0000B8r 2  A9 rr 85 02    loadmem16 ZR1,PATH_COM_DIREND   ; 固定パスの最後に
0000BCr 2  A9 rr 85 03  
0000C0r 2  A9 rr A0 rr    loadAY16 COMMAND_BUF            ; 元のコマンド行を
0000C4r 2  20 rr rr       JSR M_CP_AYS                    ; コピーして
0000C7r 2                 ; .COMを付ける
0000C7r 2  A2 00          LDX #0  ; ロード側インデックス
0000C9r 2               @LOOP:
0000C9r 2  BD rr rr       LDA PATH_DOTCOM,X
0000CCr 2  99 rr rr       STA PATH_COM_DIREND,Y
0000CFr 2  C8             INY     ; ストア側インデックス
0000D0r 2  E8             INX
0000D1r 2  E0 05          CPX #5
0000D3r 2  D0 F4          BNE @LOOP
0000D5r 2  A9 rr A0 rr    loadAY16 PATH_COM               ; 合体したパスを
0000D9r 2                 ; [DEBUG]
0000D9r 2                 ;syscall CON_OUT_STR             ; ひょうじ
0000D9r 2  A2 12 20 03    syscall FS_FIND_FST             ; 検索
0000DDr 2  06           
0000DEr 2  B0 33          BCS COMMAND_NOTFOUND            ; 見つからなかったらあきらめる
0000E0r 2               OCOM_FOUND:
0000E0r 2  85 06 84 07    storeAY16 ZR3                   ; FINFOをZR3に格納
0000E4r 2  A2 0A 20 03    syscall FS_OPEN                 ; コマンドファイルをオープン
0000E8r 2  06           
0000E9r 2  B0 28          BCS COMMAND_NOTFOUND            ; オープンできなかったらあきらめる
0000EBr 2  85 02          STA ZR1                         ; ファイル記述子をZR1に
0000EDr 2  DA             PHX                             ; READ_BYTSに渡す用、CLOSEに渡す用で二回プッシュ
0000EEr 2  A9 00 85 00    loadmem16 ZR0,TPA               ; 書き込み先
0000F2r 2  A9 07 85 01  
0000F6r 2  A0 17          LDY #FINFO::SIZ                 ; FINFOから長さ（下位2桁のみ）を取得
0000F8r 2  B1 06          LDA (ZR3),Y
0000FAr 2  48             PHA
0000FBr 2  C8             INY
0000FCr 2  B1 06          LDA (ZR3),Y
0000FEr 2  A8             TAY
0000FFr 2  68             PLA
000100r 2  A2 24 20 03    syscall FS_READ_BYTS            ; ロード
000104r 2  06           
000105r 2  68             PLA
000106r 2  A2 0C 20 03    syscall FS_CLOSE                ; クローズ
00010Ar 2  06           
00010Br 2  7A             PLY                             ; 引数をロード
00010Cr 2  68             PLA
00010Dr 2  20 00 07       JSR TPA                         ; コマンドを呼ぶ
000110r 2  4C rr rr       JMP LOOP
000113r 2               
000113r 2               COMMAND_NOTFOUND:
000113r 2               ; いよいよもってコマンドが見つからなかった
000113r 2  7A             PLY                             ; 引数を捨てる
000114r 2  68             PLA
000115r 2  A9 rr A0 rr    loadAY16 STR_COMNOTFOUND
000119r 2  A2 08 20 03    syscall CON_OUT_STR
00011Dr 2  06           
00011Er 2  4C rr rr       JMP LOOP
000121r 2               
000121r 2               ; -------------------------------------------------------------------
000121r 2               ;                        DONKIデバッガ起動
000121r 2               ; -------------------------------------------------------------------
000121r 2               ICOM_DONKI:
000121r 2  A9 01          LDA #$01
000123r 2  A2 23          LDX #$23
000125r 2  A0 45          LDY #$45            ; お飾り
000127r 2  00             BRK
000128r 2  EA             NOP
000129r 2  4C rr rr       JMP LOOP
00012Cr 2               
00012Cr 2               ; -------------------------------------------------------------------
00012Cr 2               ;                     カレントディレクトリ変更
00012Cr 2               ; -------------------------------------------------------------------
00012Cr 2               ICOM_CD:
00012Cr 2  A2 16 20 03    syscall FS_CHDIR          ; テーブルジャンプ前にコマンドライン引数を受け取った
000130r 2  06           
000131r 2  90 03          BCC @SKP_ERR
000133r 2  4C rr rr       JMP BCOS_ERROR
000136r 2               @SKP_ERR:
000136r 2  4C rr rr       JMP LOOP
000139r 2               
000139r 2               ; -------------------------------------------------------------------
000139r 2               ;                    ロードを省略してTPAを実行
000139r 2               ; -------------------------------------------------------------------
000139r 2               ; SREC読み込みでテスト実行するのに便利
000139r 2               ; -------------------------------------------------------------------
000139r 2               ICOM_TEST:
000139r 2  20 00 07       JSR TPA
00013Cr 2  4C rr rr       JMP LOOP
00013Fr 2               
00013Fr 2               ; -------------------------------------------------------------------
00013Fr 2               ;                          汎用関数群
00013Fr 2               ; -------------------------------------------------------------------
00013Fr 2               ; どうする？ライブラリ？システムコール？
00013Fr 2               ; -------------------------------------------------------------------
00013Fr 2               BCOS_ERROR:
00013Fr 2  20 rr rr       JSR PRT_LF
000142r 2  A2 1A 20 03    syscall ERR_GET
000146r 2  06           
000147r 2  A2 1C 20 03    syscall ERR_MES
00014Br 2  06           
00014Cr 2  4C rr rr       JMP LOOP
00014Fr 2               
00014Fr 2               ;PRT_BIN:
00014Fr 2               ;  LDX #8
00014Fr 2               ;@LOOP:
00014Fr 2               ;  ASL
00014Fr 2               ;  PHA
00014Fr 2               ;  LDA #'0'    ; キャリーが立ってなければ'0'
00014Fr 2               ;  BCC @SKP_ADD1
00014Fr 2               ;  INC         ; キャリーが立ってたら'1'
00014Fr 2               ;@SKP_ADD1:
00014Fr 2               ;  PHX
00014Fr 2               ;  syscall CON_OUT_CHR
00014Fr 2               ;  PLX
00014Fr 2               ;  PLA
00014Fr 2               ;  DEX
00014Fr 2               ;  BNE @LOOP
00014Fr 2               ;  RTS
00014Fr 2               
00014Fr 2               ;PRT_BYT:
00014Fr 2               ;  JSR BYT2ASC
00014Fr 2               ;  PHY
00014Fr 2               ;  JSR PRT_C_CALL
00014Fr 2               ;  PLA
00014Fr 2               ;PRT_C_CALL:
00014Fr 2               ;  syscall CON_OUT_CHR
00014Fr 2               ;  RTS
00014Fr 2               ;
00014Fr 2               PRT_LF:
00014Fr 2                 ; 改行
00014Fr 2  A9 0A          LDA #$A
000151r 2               ;  JMP PRT_C_CALL
000151r 2               
000151r 2               ;PRT_S:
000151r 2               ;  ; スペース
000151r 2               ;  LDA #' '
000151r 2               ;  ;JMP PRT_C_CALL
000151r 2               PRT_C_CALL:
000151r 2  A2 04 20 03    syscall CON_OUT_CHR
000155r 2  06           
000156r 2  60             RTS
000157r 2               
000157r 2               ;BYT2ASC:
000157r 2               ;  ; Aで与えられたバイト値をASCII値AYにする
000157r 2               ;  ; Aから先に表示すると良い
000157r 2               ;  PHA           ; 下位のために保存
000157r 2               ;  AND #$0F
000157r 2               ;  JSR NIB2ASC
000157r 2               ;  TAY
000157r 2               ;  PLA
000157r 2               ;  LSR           ; 右シフトx4で上位を下位に持ってくる
000157r 2               ;  LSR
000157r 2               ;  LSR
000157r 2               ;  LSR
000157r 2               ;  JSR NIB2ASC
000157r 2               ;  RTS
000157r 2               ;
000157r 2               ;NIB2ASC:
000157r 2               ;  ; #$0?をアスキー一文字にする
000157r 2               ;  ORA #$30
000157r 2               ;  CMP #$3A
000157r 2               ;  BCC @SKP_ADC  ; Aが$3Aより小さいか等しければ分岐
000157r 2               ;  ADC #$06
000157r 2               ;@SKP_ADC:
000157r 2               ;  RTS
000157r 2               
000157r 2               M_EQ_AY:
000157r 2                 ; AYとZR0が等しいかを返す
000157r 2  85 02          STA ZR1
000159r 2  84 03          STY ZR1+1
00015Br 2               M_EQ:
00015Br 2  A0 FF          LDY #$FF                ; インデックスはゼロから
00015Dr 2               @LOOP:
00015Dr 2  C8             INY
00015Er 2  B1 00          LDA (ZR0),Y
000160r 2  F0 06          BEQ @END                ; ヌル終端なら終端検査に入る
000162r 2  D1 02          CMP (ZR1),Y
000164r 2  F0 F7          BEQ @LOOP               ; 一致すればもう一文字
000166r 2               @NOT:
000166r 2  38             SEC
000167r 2  60             RTS
000168r 2               @END:
000168r 2  B1 02          LDA (ZR1),Y
00016Ar 2  D0 00          BNE @EQ
00016Cr 2               @EQ:
00016Cr 2  18             CLC
00016Dr 2  60             RTS
00016Er 2               
00016Er 2               M_LEN:
00016Er 2                 ; 文字列の長さを取得する
00016Er 2                 ; input:AY
00016Er 2                 ; output:Y
00016Er 2  85 02          STA ZR1
000170r 2  84 03          STY ZR1+1
000172r 2               M_LEN_ZR1:  ; ZR1入力
000172r 2  A0 FF          LDY #$FF
000174r 2               @LOOP:
000174r 2  C8             INY
000175r 2  B1 02          LDA (ZR1),Y
000177r 2  D0 FB          BNE @LOOP
000179r 2               M_LEN_RTS:
000179r 2  60             RTS
00017Ar 2               
00017Ar 2               M_CP_AYS:
00017Ar 2                 ; 文字列をコピーする
00017Ar 2                 ; DST=ZR1
00017Ar 2  85 00          STA ZR0
00017Cr 2  84 01          STY ZR0+1
00017Er 2  A0 FF          LDY #$FF
000180r 2               @LOOP:
000180r 2  C8             INY
000181r 2  B1 00          LDA (ZR0),Y
000183r 2  91 02          STA (ZR1),Y
000185r 2  F0 F2          BEQ M_LEN_RTS
000187r 2  80 F7          BRA @LOOP
000189r 2               
000189r 2               ; -------------------------------------------------------------------
000189r 2               ;                             データ領域
000189r 2               ; -------------------------------------------------------------------
000189r 2               STR_INITMESSAGE:  .INCLUDE "initmessage.s"                ; 起動時メッセージ
000189r 3  4D 49 52 41  .BYT "MIRACOS v1.1.4 for FxT-65",10,"    (build [aa7cc2]R40916-1418r)",0
00018Dr 3  43 4F 53 20  
000191r 3  76 31 2E 31  
0001C4r 3               
0001C4r 2  55 6E 6B 6E  STR_COMNOTFOUND:  .BYT "Unknown Command.",$A,$0
0001C8r 2  6F 77 6E 20  
0001CCr 2  43 6F 6D 6D  
0001D6r 2  47 6F 6F 64  STR_GOODBYE:      .BYT "Good Bye.",$A,$0
0001DAr 2  20 42 79 65  
0001DEr 2  2E 0A 00     
0001E1r 2  2E 00        STR_DOT:          .BYT ".",$0                             ; これの絶対パスを得ると、それはカレントディレクトリ
0001E3r 2  41 3A 2F 4D  PATH_COM:         .BYT "A:/MCOS/COM/"
0001E7r 2  43 4F 53 2F  
0001EBr 2  43 4F 4D 2F  
0001EFr 2  xx xx xx xx    PATH_COM_DIREND:  .RES 13
0001F3r 2  xx xx xx xx  
0001F7r 2  xx xx xx xx  
0001FCr 2  2E 43 4F 4D  PATH_DOTCOM:      .BYT ".COM",$0
000200r 2  00           
000201r 2               
000201r 2               ; -------------------------------------------------------------------
000201r 2               ;                        内部コマンドテーブル
000201r 2               ; -------------------------------------------------------------------
000201r 2               ICOMNAMES:        ;.ASCIIZ "EXIT"        ; 0
000201r 2  43 44 00                       .ASCIIZ "CD"          ; 1
000204r 2                                 ;.ASCIIZ "REBOOT"      ; 2
000204r 2                                 ;.ASCIIZ "COLOR"       ; 3
000204r 2                                 ;.ASCIIZ "DIR"         ; 4
000204r 2  54 45 53 54                    .ASCIIZ "TEST"        ; 5
000208r 2  00           
000209r 2                                 ;.ASCIIZ "LS"          ; 6
000209r 2  44 4F 4E 4B                    .ASCIIZ "DONKI"       ; 7
00020Dr 2  49 00        
00020Fr 2  00                             .BYT $0
000210r 2               
000210r 2               ICOMVECS:         ;.WORD ICOM_EXIT
000210r 2  rr rr                          .WORD ICOM_CD
000212r 2                                 ;.WORD ICOM_REBOOT
000212r 2                                 ;.WORD ICOM_COLOR
000212r 2                                 ;.WORD ICOM_DIR
000212r 2  rr rr                          .WORD ICOM_TEST
000214r 2                                 ;.WORD ICOM_LS
000214r 2  rr rr                          .WORD ICOM_DONKI
000216r 2               
000216r 2               
000216r 1               .ENDSCOPE
000216r 1               
000216r 1               ; -------------------------------------------------------------------
000216r 1               ;                             BCOS本体
000216r 1               ; -------------------------------------------------------------------
000216r 1               
000216r 1               ; -------------------------------------------------------------------
000216r 1               ;                           下位モジュール
000216r 1               ; -------------------------------------------------------------------
000216r 1               .SEGMENT "COSLIB"
000000r 1                 .INCLUDE "fs/fsmac.mac"
000000r 2               ; ファイルシステム関連（SD、SPI）のマクロ
000000r 2               ; どうせスコープ貫通する
000000r 2               .macro cs0high
000000r 2                 LDA VIA::PORTB
000000r 2                 ORA #VIA::SPI_CS0
000000r 2                 STA VIA::PORTB
000000r 2               .endmac
000000r 2               
000000r 2               .macro cs0low
000000r 2                 LDA VIA::PORTB
000000r 2                 AND #<~(VIA::SPI_CS0)
000000r 2                 STA VIA::PORTB
000000r 2               .endmac
000000r 2               
000000r 2               .macro spi_rdbyt
000000r 2                 .local @LOOP
000000r 2                 ; --- AにSPIで受信したデータを格納
000000r 2                 ; 高速化マクロ
000000r 2               @LOOP:
000000r 2                 LDA VIA::IFR
000000r 2                 AND #%00000100      ; シフトレジスタ割り込みを確認
000000r 2                 BEQ @LOOP
000000r 2                 LDA VIA::SR
000000r 2               .endmac
000000r 2               
000000r 2               .macro rdpage
000000r 2                 ; 高速化マクロ
000000r 2               .local @RDLOOP
000000r 2                 LDY #0
000000r 2               @RDLOOP:
000000r 2                 spi_rdbyt
000000r 2                 STA (ZP_SDSEEK_VEC16),Y
000000r 2                 INY
000000r 2                 BNE @RDLOOP
000000r 2               .endmac
000000r 2               
000000r 2               
000000r 1                 .PROC ERR
000000r 1                   .INCLUDE "error.s"
000000r 2               .INCLUDE "errorcode.inc"
000000r 3               ; エラーコード
000000r 3               DRV_NOT_FOUND         = 0   ; 存在しないドライブ文字が指定された
000000r 3               ILLEGAL_PATH          = 1   ; ヘンなパス
000000r 3               FILE_NOT_FOUND        = 2   ; そんなファイルはない
000000r 3               NOT_DIR               = 3   ; ディレクトリではない
000000r 3               FAILED_CLOSE          = 4
000000r 3               FAILED_OPEN           = 5
000000r 3               
000000r 3               
000000r 2               ; -------------------------------------------------------------------
000000r 2               ;                         エラーを報告
000000r 2               ; -------------------------------------------------------------------
000000r 2               ; input   : A=EC
000000r 2               ; エラーコードを受け取り、保存する。
000000r 2               ; ジャンプしてくればすぐに戻れる
000000r 2               ; デバッグ時にはここでトラップできる
000000r 2               ; -------------------------------------------------------------------
000000r 2               REPORT:
000000r 2  8D rr rr       STA LAST_ERROR
000003r 2  38             SEC
000004r 2  60             RTS
000005r 2               
000005r 2               ; -------------------------------------------------------------------
000005r 2               ;                         エラーを取得
000005r 2               ; -------------------------------------------------------------------
000005r 2               ; -------------------------------------------------------------------
000005r 2               FUNC_ERR_GET:
000005r 2  AD rr rr       LDA LAST_ERROR
000008r 2  60             RTS
000009r 2               
000009r 2               ; -------------------------------------------------------------------
000009r 2               ;                          エラーを表示
000009r 2               ; -------------------------------------------------------------------
000009r 2               ; input   : A=EC
000009r 2               ; エラーコードに対応するメッセージを表示する
000009r 2               ; -------------------------------------------------------------------
000009r 2               FUNC_ERR_MES:
000009r 2  0A             ASL
00000Ar 2  AA             TAX
00000Br 2  DA             PHX
00000Cr 2  A9 rr A0 rr    loadAY16 STR_ERROR
000010r 2  20 rr rr       JSR FUNC_CON_OUT_STR
000013r 2  FA             PLX
000014r 2  BD rr rr       LDA ERROR_MES_TABLE,X
000017r 2  BC rr rr       LDY ERROR_MES_TABLE+1,X
00001Ar 2  20 rr rr       JSR FUNC_CON_OUT_STR
00001Dr 2  A9 0A          LDA #$A
00001Fr 2  20 rr rr       JSR FUNC_CON_OUT_CHR
000022r 2  60             RTS
000023r 2               
000023r 2               ERROR_MES_TABLE:
000023r 2  rr rr          .WORD EM_DRV_NOT_FOUND
000025r 2  rr rr          .WORD EM_ILLEGAL_PATH
000027r 2  rr rr          .WORD EM_FILE_NOT_FOUND
000029r 2  rr rr          .WORD EM_NOT_DIR
00002Br 2               
00002Br 2               ERROR_MES:
00002Br 2  44 72 69 76  EM_DRV_NOT_FOUND:             .BYT "Drive Not Found.",$0
00002Fr 2  65 20 4E 6F  
000033r 2  74 20 46 6F  
00003Cr 2  49 6C 6C 65  EM_ILLEGAL_PATH:              .BYT "Illegal Path.",$0
000040r 2  67 61 6C 20  
000044r 2  50 61 74 68  
00004Ar 2  46 69 6C 65  EM_FILE_NOT_FOUND:            .BYT "File Not Found.",$0
00004Er 2  20 4E 6F 74  
000052r 2  20 46 6F 75  
00005Ar 2  4E 6F 74 20  EM_NOT_DIR:                   .BYT "Not Directory.",$0
00005Er 2  44 69 72 65  
000062r 2  63 74 6F 72  
000069r 2  46 61 69 6C  EM_FAILED_CLOSE:              .BYT "Failed to CLOSE.",$0
00006Dr 2  65 64 20 74  
000071r 2  6F 20 43 4C  
00007Ar 2  46 61 69 6C  EM_FAILED_OPEN:               .BYT "Failed to OPEN.",$0
00007Er 2  65 64 20 74  
000082r 2  6F 20 4F 50  
00008Ar 2               
00008Ar 2  5B 42 43 4F  STR_ERROR:                    .BYT "[BCOSERR] ",$0
00008Er 2  53 45 52 52  
000092r 2  5D 20 00     
000095r 2               
000095r 2               
000095r 1                 .ENDPROC
000095r 1                 .PROC SPI
000095r 1                   .INCLUDE "fs/spi.s"
000095r 2               ; SDカードドライバのSPI部分
000095r 2               ; しかし半二重である
000095r 2               .INCLUDE "../FXT65.inc"
000095r 3               ; FxT65のハードウェア構成を定義する
000095r 3               
000095r 3               .PC02 ; CMOS命令を許可
000095r 3               
000095r 3               RAMBASE = $0000
000095r 3               UARTBASE = $E000
000095r 3               VIABASE = $E200
000095r 3               YMZBASE = $E400
000095r 3               CRTCBASE = $E600
000095r 3               ROMBASE = $F000
000095r 3               
000095r 3               ; UART
000095r 3               .PROC UART
000095r 3                 RX = UARTBASE
000095r 3                 TX = UARTBASE
000095r 3                 STATUS = UARTBASE+1
000095r 3                 COMMAND = UARTBASE+2
000095r 3                 CONTROL = UARTBASE+3
000095r 3                 .PROC CMD
000095r 3                   ; PMC1/PMC0/PME/REM/TIC1/TIC0/IRD/DTR
000095r 3                   ; 全てゼロだと「エコーオフ、RTSオフ、割り込み有効、DTRオフ」
000095r 3                   RTS_ON =    %00001000
000095r 3                   ECHO_ON =   %00010000
000095r 3                   RIRQ_OFF =  %00000010
000095r 3                   DTR_ON =    %00000001
000095r 3                 .ENDPROC
000095r 3                 XON = $11
000095r 3                 XOFF = $13
000095r 3               .ENDPROC
000095r 3               
000095r 3               ; VIA
000095r 3               .PROC VIA
000095r 3                 PORTB = VIABASE
000095r 3                 PORTA = VIABASE+1
000095r 3                 DDRB = VIABASE+2
000095r 3                 DDRA = VIABASE+3
000095r 3                 T1CL = VIABASE+4
000095r 3                 T1CH = VIABASE+5
000095r 3                 T1LL = VIABASE+6
000095r 3                 T1LH = VIABASE+7
000095r 3                 SR = VIABASE+$A
000095r 3                 ACR = VIABASE+$B
000095r 3                 PCR = VIABASE+$C
000095r 3                 IFR = VIABASE+$D
000095r 3                 IER = VIABASE+$E
000095r 3                 IFR_IRQ = %10000000
000095r 3                 IER_SET = %10000000
000095r 3                 IFR_T1  = %01000000
000095r 3                 IFR_T2  = %00100000
000095r 3                 IFR_CB1 = %00010000
000095r 3                 IFR_CB2 = %00001000
000095r 3                 IFR_SR  = %00000100
000095r 3                 IFR_CA1 = %00000010
000095r 3                 IFR_CA2 = %00000001
000095r 3                 ; 新式
000095r 3                 SPI_REG    = PORTB
000095r 3                 SPI_DDR    = DDRB
000095r 3                 SPI_INOUT  = %10000000  ; 1=in, 0=out
000095r 3                 SPI_CS0    = %01000000
000095r 3                 PS2_REG    = PORTB
000095r 3                 PS2_DDR    = DDRB
000095r 3                 PS2_CLK    = %00100000
000095r 3                 PS2_DAT    = %00010000
000095r 3                 PAD_REG    = PORTB
000095r 3                 PAD_DDR    = DDRB
000095r 3                 PAD_CLK    = %00000100
000095r 3                 PAD_PTS    = %00000010
000095r 3                 PAD_DAT    = %00000001
000095r 3               .ENDPROC
000095r 3               
000095r 3               ; ChDz
000095r 3               .PROC CRTC
000095r 3                 CFG = CRTCBASE+$1   ; コンフィグ
000095r 3                                         ;   MD0 MD1 MD2 MD3 - - - WCUE
000095r 3                                         ;   MD : 色モード選択（各フレーム）
000095r 3                                         ;   WCUE  : 書き込みカウントアップ有効化
000095r 3               
000095r 3                 VMAH = CRTCBASE+$2  ; VRAM書き込みアドレス下位
000095r 3                                         ;   - 6 5 4 3 2 1 0
000095r 3               
000095r 3                 VMAV = CRTCBASE+$3  ; VRAM書き込みアドレス上位
000095r 3                                     ;   7 6 5 4 3 2 1 0
000095r 3               
000095r 3                 WDBF = CRTCBASE+$4  ; 書き込みデータ
000095r 3               
000095r 3                 RF  = CRTCBASE+$5   ; 出力フレーム選択
000095r 3                                     ;   (0) 1 0 | (1) 1 0 | (2) 1 0 | (3) 1 0
000095r 3               
000095r 3                 WF  = CRTCBASE+$6   ; 書き込みフレーム選択
000095r 3                                     ;   - - - - - - WF1 WF0
000095r 3               
000095r 3                 TCP  = CRTCBASE+$7  ; 2色モード色選択
000095r 3                                         ;   (0) 3 2 1 0 | (1) 3 2 1 0
000095r 3               .ENDPROC
000095r 3               
000095r 3               ; YMZ
000095r 3               .PROC YMZ
000095r 3                 ADDR = YMZBASE
000095r 3                 DATA = YMZBASE+1
000095r 3                 ; IR:Internal Address
000095r 3                 IA_FRQ = $00        ; 各チャンネル周波数
000095r 3                 IA_NOISE_FRQ = $06  ; ノイズ音周波数
000095r 3                 IA_MIX = $07        ; ミキサ設定
000095r 3                 IA_VOL = $08        ; 各チャンネル音量
000095r 3                 IA_EVLP_FRQ = $0B   ; エンベロープ周波数
000095r 3                 IA_EVLP_SHAPE = $0D ; エンベロープ形状
000095r 3               .ENDPROC
000095r 3               
000095r 3               
000095r 2               
000095r 2               SETIN:
000095r 2                 ; --- SPIシフトレジスタを入力（MISO）モードにする
000095r 2  AD 0B E2       LDA VIA::ACR      ; シフトレジスタ設定の変更
000098r 2  29 E3          AND #%11100011    ; bit 2-4がシフトレジスタの設定なのでそれをマスク
00009Ar 2  09 08          ORA #%00001000    ; PHI2制御下インプット
00009Cr 2  8D 0B E2       STA VIA::ACR
00009Fr 2  AD 00 E2       LDA VIA::PORTB
0000A2r 2  09 80          ORA #(VIA::SPI_INOUT) ; INOUT=1で入力モード
0000A4r 2  8D 00 E2       STA VIA::PORTB
0000A7r 2  60             RTS
0000A8r 2               
0000A8r 2               SETOUT:
0000A8r 2                 ; --- SPIシフトレジスタを出力（MOSI）モードにする
0000A8r 2  AD 0B E2       LDA VIA::ACR      ; シフトレジスタ設定の変更
0000ABr 2  29 E3          AND #%11100011    ; bit 2-4がシフトレジスタの設定なのでそれをマスク
0000ADr 2  09 18          ORA #%00011000    ; PHI2制御下出力
0000AFr 2  8D 0B E2       STA VIA::ACR
0000B2r 2  AD 00 E2       LDA VIA::PORTB
0000B5r 2  29 7F          AND #<~(VIA::SPI_INOUT)
0000B7r 2  8D 00 E2       STA VIA::PORTB
0000BAr 2  60             RTS
0000BBr 2               
0000BBr 2               WRBYT:
0000BBr 2                 ; --- Aを送信
0000BBr 2  8D 0A E2       STA VIA::SR
0000BEr 2               @WAIT:
0000BEr 2  AD 0D E2       LDA VIA::IFR
0000C1r 2  29 04          AND #%00000100      ; シフトレジスタ割り込みを確認
0000C3r 2  F0 F9          BEQ @WAIT
0000C5r 2  60             RTS
0000C6r 2               
0000C6r 2               RDBYT:
0000C6r 2                 ; --- AにSPIで受信したデータを格納
0000C6r 2  AD 0D E2 29    spi_rdbyt
0000CAr 2  04 F0 F9 AD  
0000CEr 2  0A E2        
0000D0r 2  60             RTS
0000D1r 2               
0000D1r 2               DUMMYCLK:
0000D1r 2                 ; --- X回のダミークロックを送信する
0000D1r 2  20 rr rr       JSR SETOUT
0000D4r 2               @LOOP:
0000D4r 2  A9 FF          LDA #$FF
0000D6r 2  20 rr rr       JSR WRBYT
0000D9r 2  CA             DEX
0000DAr 2  D0 F8          BNE @LOOP
0000DCr 2  60             RTS
0000DDr 2               
0000DDr 2               
0000DDr 1                 .ENDPROC
0000DDr 1                 .PROC SD
0000DDr 1                   .INCLUDE "fs/sd.s"
0000DDr 2               ;DEBUGBUILD = 1
0000DDr 2               ; SDカードドライバのSDカード固有部分
0000DDr 2               .INCLUDE "../FXT65.inc"
0000DDr 3               ; FxT65のハードウェア構成を定義する
0000DDr 3               
0000DDr 3               .PC02 ; CMOS命令を許可
0000DDr 3               
0000DDr 3               RAMBASE = $0000
0000DDr 3               UARTBASE = $E000
0000DDr 3               VIABASE = $E200
0000DDr 3               YMZBASE = $E400
0000DDr 3               CRTCBASE = $E600
0000DDr 3               ROMBASE = $F000
0000DDr 3               
0000DDr 3               ; UART
0000DDr 3               .PROC UART
0000DDr 3                 RX = UARTBASE
0000DDr 3                 TX = UARTBASE
0000DDr 3                 STATUS = UARTBASE+1
0000DDr 3                 COMMAND = UARTBASE+2
0000DDr 3                 CONTROL = UARTBASE+3
0000DDr 3                 .PROC CMD
0000DDr 3                   ; PMC1/PMC0/PME/REM/TIC1/TIC0/IRD/DTR
0000DDr 3                   ; 全てゼロだと「エコーオフ、RTSオフ、割り込み有効、DTRオフ」
0000DDr 3                   RTS_ON =    %00001000
0000DDr 3                   ECHO_ON =   %00010000
0000DDr 3                   RIRQ_OFF =  %00000010
0000DDr 3                   DTR_ON =    %00000001
0000DDr 3                 .ENDPROC
0000DDr 3                 XON = $11
0000DDr 3                 XOFF = $13
0000DDr 3               .ENDPROC
0000DDr 3               
0000DDr 3               ; VIA
0000DDr 3               .PROC VIA
0000DDr 3                 PORTB = VIABASE
0000DDr 3                 PORTA = VIABASE+1
0000DDr 3                 DDRB = VIABASE+2
0000DDr 3                 DDRA = VIABASE+3
0000DDr 3                 T1CL = VIABASE+4
0000DDr 3                 T1CH = VIABASE+5
0000DDr 3                 T1LL = VIABASE+6
0000DDr 3                 T1LH = VIABASE+7
0000DDr 3                 SR = VIABASE+$A
0000DDr 3                 ACR = VIABASE+$B
0000DDr 3                 PCR = VIABASE+$C
0000DDr 3                 IFR = VIABASE+$D
0000DDr 3                 IER = VIABASE+$E
0000DDr 3                 IFR_IRQ = %10000000
0000DDr 3                 IER_SET = %10000000
0000DDr 3                 IFR_T1  = %01000000
0000DDr 3                 IFR_T2  = %00100000
0000DDr 3                 IFR_CB1 = %00010000
0000DDr 3                 IFR_CB2 = %00001000
0000DDr 3                 IFR_SR  = %00000100
0000DDr 3                 IFR_CA1 = %00000010
0000DDr 3                 IFR_CA2 = %00000001
0000DDr 3                 ; 新式
0000DDr 3                 SPI_REG    = PORTB
0000DDr 3                 SPI_DDR    = DDRB
0000DDr 3                 SPI_INOUT  = %10000000  ; 1=in, 0=out
0000DDr 3                 SPI_CS0    = %01000000
0000DDr 3                 PS2_REG    = PORTB
0000DDr 3                 PS2_DDR    = DDRB
0000DDr 3                 PS2_CLK    = %00100000
0000DDr 3                 PS2_DAT    = %00010000
0000DDr 3                 PAD_REG    = PORTB
0000DDr 3                 PAD_DDR    = DDRB
0000DDr 3                 PAD_CLK    = %00000100
0000DDr 3                 PAD_PTS    = %00000010
0000DDr 3                 PAD_DAT    = %00000001
0000DDr 3               .ENDPROC
0000DDr 3               
0000DDr 3               ; ChDz
0000DDr 3               .PROC CRTC
0000DDr 3                 CFG = CRTCBASE+$1   ; コンフィグ
0000DDr 3                                         ;   MD0 MD1 MD2 MD3 - - - WCUE
0000DDr 3                                         ;   MD : 色モード選択（各フレーム）
0000DDr 3                                         ;   WCUE  : 書き込みカウントアップ有効化
0000DDr 3               
0000DDr 3                 VMAH = CRTCBASE+$2  ; VRAM書き込みアドレス下位
0000DDr 3                                         ;   - 6 5 4 3 2 1 0
0000DDr 3               
0000DDr 3                 VMAV = CRTCBASE+$3  ; VRAM書き込みアドレス上位
0000DDr 3                                     ;   7 6 5 4 3 2 1 0
0000DDr 3               
0000DDr 3                 WDBF = CRTCBASE+$4  ; 書き込みデータ
0000DDr 3               
0000DDr 3                 RF  = CRTCBASE+$5   ; 出力フレーム選択
0000DDr 3                                     ;   (0) 1 0 | (1) 1 0 | (2) 1 0 | (3) 1 0
0000DDr 3               
0000DDr 3                 WF  = CRTCBASE+$6   ; 書き込みフレーム選択
0000DDr 3                                     ;   - - - - - - WF1 WF0
0000DDr 3               
0000DDr 3                 TCP  = CRTCBASE+$7  ; 2色モード色選択
0000DDr 3                                         ;   (0) 3 2 1 0 | (1) 3 2 1 0
0000DDr 3               .ENDPROC
0000DDr 3               
0000DDr 3               ; YMZ
0000DDr 3               .PROC YMZ
0000DDr 3                 ADDR = YMZBASE
0000DDr 3                 DATA = YMZBASE+1
0000DDr 3                 ; IR:Internal Address
0000DDr 3                 IA_FRQ = $00        ; 各チャンネル周波数
0000DDr 3                 IA_NOISE_FRQ = $06  ; ノイズ音周波数
0000DDr 3                 IA_MIX = $07        ; ミキサ設定
0000DDr 3                 IA_VOL = $08        ; 各チャンネル音量
0000DDr 3                 IA_EVLP_FRQ = $0B   ; エンベロープ周波数
0000DDr 3                 IA_EVLP_SHAPE = $0D ; エンベロープ形状
0000DDr 3               .ENDPROC
0000DDr 3               
0000DDr 3               
0000DDr 2               
0000DDr 2               ; SDコマンド用固定引数
0000DDr 2               ; 共通部分を重ねて圧縮している
0000DDr 2               BTS_CMD8PRM:   ; 00 00 01 AA
0000DDr 2  AA 01          .BYTE $AA,$01
0000DFr 2               BTS_CMDPRM_ZERO:  ; 00 00 00 00
0000DFr 2  00             .BYTE $00
0000E0r 2               BTS_CMD41PRM:  ; 40 00 00 00
0000E0r 2  00 00 00 40    .BYTE $00,$00,$00,$40
0000E4r 2               
0000E4r 2               RDSEC:
0000E4r 2                 ; --- SDCMD_BF+1+2+3+4を引数としてCMD17を実行し、1セクタを読み取る
0000E4r 2                 ; --- 結果はZP_SDSEEK_VEC16の示す場所に保存される
0000E4r 2  20 rr rr       JSR RDINIT
0000E7r 2  F0 03          BEQ DUMPSEC
0000E9r 2  A9 01          LDA #1  ; EC1:RDINITError
0000EBr 2  60             RTS
0000ECr 2               DUMPSEC:
0000ECr 2                 ; 512バイト読み取り
0000ECr 2  A0 00 AD 0D    rdpage
0000F0r 2  E2 29 04 F0  
0000F4r 2  F9 AD 0A E2  
0000FDr 2  E6 rr          INC ZP_SDSEEK_VEC16+1
0000FFr 2  A0 00 AD 0D    rdpage
000103r 2  E2 29 04 F0  
000107r 2  F9 AD 0A E2  
000110r 2                 ; コマンド終了
000110r 2  AD 00 E2 09    cs0high
000114r 2  40 8D 00 E2  
000118r 2  A9 00          LDA #0
00011Ar 2  60             RTS
00011Br 2               
00011Br 2               INIT:
00011Br 2                 ; 成功:A=0
00011Br 2                 ; 失敗:A=エラーコード
00011Br 2                 ;  1:InIdleStateError
00011Br 2                 ;  2:
00011Br 2                 ; カードを選択しないままダミークロック
00011Br 2  A9 40          LDA #VIA::SPI_CS0
00011Dr 2  8D 00 E2       STA VIA::PORTB
000120r 2  A2 0A          LDX #10         ; 80回のダミークロック
000122r 2  20 rr rr       JSR SPI::DUMMYCLK
000125r 2               @CMD0:
000125r 2               ; GO_IDLE_STATE
000125r 2               ; ソフトウェアリセットをかけ、アイドル状態にする。SPIモードに突入する。
000125r 2               ; CRCが有効である必要がある
000125r 2  A9 rr 85 rr    loadmem16 ZP_SDCMDPRM_VEC16,BTS_CMDPRM_ZERO
000129r 2  A9 rr 85 rr  
00012Dr 2  A9 95          LDA #SDCMD0_CRC
00012Fr 2  8D rr rr       STA SDCMD_CRC
000132r 2  A9 40          LDA #0|SD_STBITS
000134r 2  20 rr rr       JSR SENDCMD
000137r 2  C9 01          CMP #$01        ; レスが1であると期待（In Idle Stateビット）
000139r 2  F0 03          BEQ @CMD8
00013Br 2  A9 01          LDA #$01        ; エラーコード1 CMD0Error
00013Dr 2  60             RTS
00013Er 2               @CMD8:
00013Er 2               ; SEND_IF_COND
00013Er 2               ; カードの動作電圧の確認
00013Er 2               ; CRCはまだ有効であるべき
00013Er 2               ; SDHC（SD Ver.2.00）以降追加されたコマンドらしい
00013Er 2  A9 rr 85 rr    loadmem16 ZP_SDCMDPRM_VEC16,BTS_CMD8PRM
000142r 2  A9 rr 85 rr  
000146r 2  A9 87          LDA #SDCMD8_CRC
000148r 2  8D rr rr       STA SDCMD_CRC
00014Br 2  A9 48          LDA #8|SD_STBITS
00014Dr 2  20 rr rr       JSR SENDCMD
000150r 2  48             PHA
000151r 2  20 rr rr       JSR RDR7        ; 読み捨て
000154r 2  68             PLA
000155r 2  C9 05          CMP #$05
000157r 2  D0 03          BNE @SKP_OLDSD
000159r 2                 ;print STR_OLDSD ; Ver.1.0カード
000159r 2  A9 02          LDA #$02        ; エラーコード2 OldCardError
00015Br 2  60             RTS
00015Cr 2               @SKP_OLDSD:
00015Cr 2  C9 01          CMP #$01
00015Er 2  F0 03          BEQ @CMD58
000160r 2  A9 03          LDA #$03        ; エラーコード3 CMD8Error
000162r 2  60             RTS
000163r 2               @CMD58:
000163r 2               ; READ_OCR
000163r 2               ; OCRレジスタを読み取る
000163r 2  A9 81          LDA #$81        ; 以降CRCは触れなくてよい
000165r 2  8D rr rr       STA SDCMD_CRC
000168r 2  A9 rr 85 rr    loadmem16 ZP_SDCMDPRM_VEC16,BTS_CMDPRM_ZERO
00016Cr 2  A9 rr 85 rr  
000170r 2  A9 7A          LDA #58|SD_STBITS
000172r 2  20 rr rr       JSR SENDCMD
000175r 2  20 rr rr       JSR RDR7
000178r 2               @CMD55:
000178r 2               ; APP_CMD
000178r 2               ; アプリケーション特化コマンド
000178r 2               ; ACMDコマンドのプレフィクス
000178r 2  A9 rr 85 rr    loadmem16 ZP_SDCMDPRM_VEC16,BTS_CMDPRM_ZERO
00017Cr 2  A9 rr 85 rr  
000180r 2  A9 77          LDA #55|SD_STBITS
000182r 2  20 rr rr       JSR SENDCMD
000185r 2  C9 01          CMP #$01
000187r 2  F0 03          BEQ @CMD41
000189r 2  A9 04          LDA #$04    ; エラーコード4 CMD55Error
00018Br 2  60             RTS
00018Cr 2               @CMD41:
00018Cr 2               ; APP_SEND_OP_COND
00018Cr 2               ; SDカードの初期化を実行する
00018Cr 2               ; 引数がSDのバージョンにより異なる
00018Cr 2  A9 rr 85 rr    loadmem16 ZP_SDCMDPRM_VEC16,BTS_CMD41PRM
000190r 2  A9 rr 85 rr  
000194r 2  A9 69          LDA #41|SD_STBITS
000196r 2  20 rr rr       JSR SENDCMD
000199r 2  C9 00          CMP #$00
00019Br 2  F0 0D          BEQ @INITIALIZED
00019Dr 2  C9 01          CMP #$01          ; レスが0なら初期化完了、1秒ぐらいかかるかも
00019Fr 2  F0 03          BEQ @SKP_CMD41ERROR
0001A1r 2  A9 05          LDA #$05          ; エラーコード5 CMD41Error
0001A3r 2  60             RTS
0001A4r 2               @SKP_CMD41ERROR:
0001A4r 2  20 rr rr       JSR DELAY         ; 再挑戦
0001A7r 2  4C rr rr       JMP @CMD55
0001AAr 2               @INITIALIZED:
0001AAr 2               OK:
0001AAr 2  A9 00          LDA #0  ; 成功コード
0001ACr 2  60             RTS
0001ADr 2               
0001ADr 2               RDPAGE:
0001ADr 2  A0 00 AD 0D    rdpage
0001B1r 2  E2 29 04 F0  
0001B5r 2  F9 AD 0A E2  
0001BEr 2  60             RTS
0001BFr 2               
0001BFr 2               RDINIT:
0001BFr 2                 ; 成功:A=0
0001BFr 2                 ; 失敗:A=エラーコード
0001BFr 2                 ; CMD17
0001BFr 2  A9 51          LDA #17|SD_STBITS
0001C1r 2  20 rr rr       JSR SENDCMD
0001C4r 2  C9 00          CMP #$00
0001C6r 2  F0 05          BEQ @RDSUCCESS
0001C8r 2  C9 04          CMP #$04          ; この例が多い
0001CAr 2                 ;JSR DELAY
0001CAr 2                 ;BEQ RDINIT
0001CAr 2                 ;BRK
0001CAr 2                 ;NOP
0001CAr 2  A9 01          LDA #$01         ; EC1:CMD17Error
0001CCr 2  60             RTS
0001CDr 2               @RDSUCCESS:
0001CDr 2                 ;print STR_S
0001CDr 2                 ;JSR SD_WAITRES  ; データを待つ
0001CDr 2  AD 00 E2 29    cs0low
0001D1r 2  BF 8D 00 E2  
0001D5r 2  A0 00          LDY #0
0001D7r 2               @WAIT_DAT:         ;  有効トークン$FEは、負数だ
0001D7r 2  20 rr rr       JSR SPI::RDBYT
0001DAr 2  C9 FF          CMP #$FF
0001DCr 2  D0 06          BNE @TOKEN
0001DEr 2  88             DEY
0001DFr 2  D0 F6          BNE @WAIT_DAT
0001E1r 2  A9 03          LDA #$03        ; EC3:TokenError2
0001E3r 2  60             RTS
0001E4r 2                 ;BRA @WAIT_DAT
0001E4r 2               @TOKEN:
0001E4r 2  C9 FE          CMP #$FE
0001E6r 2  F0 03          BEQ @RDGOTDAT
0001E8r 2  A9 02          LDA #$02        ; EC2:TokenError
0001EAr 2  60             RTS
0001EBr 2                 ;BRA @RDSUCCESS ; その後の推移を確認
0001EBr 2               @RDGOTDAT:
0001EBr 2  A9 00          LDA #0
0001EDr 2  60             RTS
0001EEr 2               
0001EEr 2               WAITRES:
0001EEr 2                 ; --- SDカードが負数を返すのを待つ
0001EEr 2                 ; --- 負数でエラー
0001EEr 2  20 rr rr       JSR SPI::SETIN
0001F1r 2  A2 08          LDX #8
0001F3r 2               @RETRY:
0001F3r 2  20 rr rr       JSR SPI::RDBYT ; なぜか、直前に送ったCRCが帰ってきてしまう
0001F6r 2               .IFDEF DEBUGBUILD
0001F6r 2                 PHA
0001F6r 2                 LDA #'w'
0001F6r 2                 JSR FUNC_CON_OUT_CHR
0001F6r 2                 PLA
0001F6r 2                 PHA
0001F6r 2                 JSR PRT_BYT_S
0001F6r 2                 PLA
0001F6r 2               .ENDIF
0001F6r 2  10 03          BPL @RETURN   ; bit7が0ならレス始まり
0001F8r 2  CA             DEX
0001F9r 2  D0 F8          BNE @RETRY
0001FBr 2               @RETURN:
0001FBr 2                 ;STA SD_CMD_DAT ; ?
0001FBr 2  60             RTS
0001FCr 2               
0001FCr 2               SENDCMD:
0001FCr 2                 ; ZP_SDCMD_VEC16の示すところに配置されたコマンド列を送信する
0001FCr 2                 ; Aのコマンド、ZP_SDCMDPRM_VEC16のパラメータ、SDCMD_CRCをコマンド列として送信する。
0001FCr 2  48             PHA
0001FDr 2                 .IFDEF DEBUGBUILD
0001FDr 2                   ; コマンド内容表示
0001FDr 2                   loadAY16 STR_CMD
0001FDr 2                   JSR FUNC_CON_OUT_STR
0001FDr 2                   PLA
0001FDr 2                   PHA
0001FDr 2                   AND #%00111111
0001FDr 2                   JSR PRT_BYT_S
0001FDr 2                 .ENDIF
0001FDr 2                 ; コマンド開始
0001FDr 2  AD 00 E2 29    cs0low
000201r 2  BF 8D 00 E2  
000205r 2  20 rr rr       JSR SPI::SETOUT
000208r 2                 ; コマンド送信
000208r 2  68             PLA
000209r 2  20 rr rr       JSR SPI::WRBYT
00020Cr 2                 ; 引数送信
00020Cr 2  A0 03          LDY #3
00020Er 2               @LOOP:
00020Er 2  B1 rr          LDA (ZP_SDCMDPRM_VEC16),Y
000210r 2  5A             PHY
000211r 2                 ; 引数表示
000211r 2                 .IFDEF DEBUGBUILD
000211r 2                   PHA
000211r 2                   JSR PRT_BYT_S
000211r 2                   PLA
000211r 2                 .ENDIF
000211r 2  20 rr rr       JSR SPI::WRBYT
000214r 2  7A             PLY
000215r 2  88             DEY
000216r 2  10 F6          BPL @LOOP
000218r 2                 ; CRC送信
000218r 2  AD rr rr       LDA SDCMD_CRC
00021Br 2                 .IFDEF DEBUGBUILD
00021Br 2                   PHA
00021Br 2                   JSR PRT_BYT_S     ; CRC表示
00021Br 2                   PLA
00021Br 2                 .ENDIF
00021Br 2  20 rr rr       JSR SPI::WRBYT
00021Er 2                 .IFDEF DEBUGBUILD
00021Er 2                   ; レス表示
00021Er 2                   LDA #'='
00021Er 2                   JSR FUNC_CON_OUT_CHR
00021Er 2                 .ENDIF
00021Er 2  20 rr rr       JSR SD::WAITRES
000221r 2  48             PHA
000222r 2                 .IFDEF DEBUGBUILD
000222r 2                   JSR PRT_BYT_S
000222r 2                   LDA #$A
000222r 2                   JSR FUNC_CON_OUT_CHR
000222r 2                 .ENDIF
000222r 2  AD 00 E2 09    cs0high
000226r 2  40 8D 00 E2  
00022Ar 2  A2 01          LDX #1
00022Cr 2  20 rr rr       JSR SPI::DUMMYCLK  ; ダミークロック1バイト
00022Fr 2  20 rr rr       JSR SPI::SETIN
000232r 2  68             PLA
000233r 2  60             RTS
000234r 2               
000234r 2               DELAY:
000234r 2  A2 00          LDX #0
000236r 2  A0 00          LDY #0
000238r 2               @LOOP:
000238r 2  88             DEY
000239r 2  D0 FD          BNE @LOOP
00023Br 2  CA             DEX
00023Cr 2  D0 FA          BNE @LOOP
00023Er 2  60             RTS
00023Fr 2               
00023Fr 2               RDR7:
00023Fr 2                 ; ダミークロックを入れた関係でうまく読めない
00023Fr 2  AD 00 E2 29    cs0low
000243r 2  BF 8D 00 E2  
000247r 2  20 rr rr       JSR SPI::RDBYT
00024Ar 2                 ;JSR PRT_BYT_S
00024Ar 2  20 rr rr       JSR SPI::RDBYT
00024Dr 2                 ;JSR PRT_BYT_S
00024Dr 2  20 rr rr       JSR SPI::RDBYT
000250r 2                 ;JSR PRT_BYT_S
000250r 2  20 rr rr       JSR SPI::RDBYT
000253r 2                 ;JSR MON::PRT_BYT
000253r 2  AD 00 E2 09    cs0high
000257r 2  40 8D 00 E2  
00025Br 2  60             RTS
00025Cr 2               
00025Cr 2               .IFDEF DEBUGBUILD
00025Cr 2                 PRT_BYT_S:  ;デバッグ用
00025Cr 2                   PHA
00025Cr 2                   LDA #' '
00025Cr 2                   JSR FUNC_CON_OUT_CHR
00025Cr 2                   PLA
00025Cr 2                   JSR BYT2ASC
00025Cr 2                   PHY
00025Cr 2                   JSR @CALL
00025Cr 2                   PLA
00025Cr 2                 @CALL:
00025Cr 2                   JSR FUNC_CON_OUT_CHR
00025Cr 2                   RTS
00025Cr 2               
00025Cr 2                 BYT2ASC:
00025Cr 2                   ; Aで与えられたバイト値をASCII値AYにする
00025Cr 2                   ; Aから先に表示すると良い
00025Cr 2                   PHA           ; 下位のために保存
00025Cr 2                   AND #$0F
00025Cr 2                   JSR NIB2ASC
00025Cr 2                   TAY
00025Cr 2                   PLA
00025Cr 2                   LSR           ; 右シフトx4で上位を下位に持ってくる
00025Cr 2                   LSR
00025Cr 2                   LSR
00025Cr 2                   LSR
00025Cr 2                   JSR NIB2ASC
00025Cr 2                   RTS
00025Cr 2               
00025Cr 2                 NIB2ASC:
00025Cr 2                   ; #$0?をアスキー一文字にする
00025Cr 2                   ORA #$30
00025Cr 2                   CMP #$3A
00025Cr 2                   BCC @SKP_ADC  ; Aが$3Aより小さいか等しければ分岐
00025Cr 2                   ADC #$06
00025Cr 2                 @SKP_ADC:
00025Cr 2                   RTS
00025Cr 2               
00025Cr 2                 STR_CMD:
00025Cr 2                   .ASCIIZ "CMD"
00025Cr 2               .ENDIF
00025Cr 2               
00025Cr 1                 .ENDPROC
00025Cr 1                 .PROC FS
00025Cr 1                   .INCLUDE "fs/fs.s"
00025Cr 2               ; -------------------------------------------------------------------
00025Cr 2               ;               MIRACOS BCOS ファイルシステムモジュール
00025Cr 2               ; -------------------------------------------------------------------
00025Cr 2               ; SDカードのFAT32ファイルシステムをサポートする
00025Cr 2               ; 1バイトのファイル記述子をオープンすることでファイルにアクセス可能
00025Cr 2               ; -------------------------------------------------------------------
00025Cr 2               .INCLUDE "FXT65.inc"
00025Cr 3               ; FxT65のハードウェア構成を定義する
00025Cr 3               
00025Cr 3               .PC02 ; CMOS命令を許可
00025Cr 3               
00025Cr 3               RAMBASE = $0000
00025Cr 3               UARTBASE = $E000
00025Cr 3               VIABASE = $E200
00025Cr 3               YMZBASE = $E400
00025Cr 3               CRTCBASE = $E600
00025Cr 3               ROMBASE = $F000
00025Cr 3               
00025Cr 3               ; UART
00025Cr 3               .PROC UART
00025Cr 3                 RX = UARTBASE
00025Cr 3                 TX = UARTBASE
00025Cr 3                 STATUS = UARTBASE+1
00025Cr 3                 COMMAND = UARTBASE+2
00025Cr 3                 CONTROL = UARTBASE+3
00025Cr 3                 .PROC CMD
00025Cr 3                   ; PMC1/PMC0/PME/REM/TIC1/TIC0/IRD/DTR
00025Cr 3                   ; 全てゼロだと「エコーオフ、RTSオフ、割り込み有効、DTRオフ」
00025Cr 3                   RTS_ON =    %00001000
00025Cr 3                   ECHO_ON =   %00010000
00025Cr 3                   RIRQ_OFF =  %00000010
00025Cr 3                   DTR_ON =    %00000001
00025Cr 3                 .ENDPROC
00025Cr 3                 XON = $11
00025Cr 3                 XOFF = $13
00025Cr 3               .ENDPROC
00025Cr 3               
00025Cr 3               ; VIA
00025Cr 3               .PROC VIA
00025Cr 3                 PORTB = VIABASE
00025Cr 3                 PORTA = VIABASE+1
00025Cr 3                 DDRB = VIABASE+2
00025Cr 3                 DDRA = VIABASE+3
00025Cr 3                 T1CL = VIABASE+4
00025Cr 3                 T1CH = VIABASE+5
00025Cr 3                 T1LL = VIABASE+6
00025Cr 3                 T1LH = VIABASE+7
00025Cr 3                 SR = VIABASE+$A
00025Cr 3                 ACR = VIABASE+$B
00025Cr 3                 PCR = VIABASE+$C
00025Cr 3                 IFR = VIABASE+$D
00025Cr 3                 IER = VIABASE+$E
00025Cr 3                 IFR_IRQ = %10000000
00025Cr 3                 IER_SET = %10000000
00025Cr 3                 IFR_T1  = %01000000
00025Cr 3                 IFR_T2  = %00100000
00025Cr 3                 IFR_CB1 = %00010000
00025Cr 3                 IFR_CB2 = %00001000
00025Cr 3                 IFR_SR  = %00000100
00025Cr 3                 IFR_CA1 = %00000010
00025Cr 3                 IFR_CA2 = %00000001
00025Cr 3                 ; 新式
00025Cr 3                 SPI_REG    = PORTB
00025Cr 3                 SPI_DDR    = DDRB
00025Cr 3                 SPI_INOUT  = %10000000  ; 1=in, 0=out
00025Cr 3                 SPI_CS0    = %01000000
00025Cr 3                 PS2_REG    = PORTB
00025Cr 3                 PS2_DDR    = DDRB
00025Cr 3                 PS2_CLK    = %00100000
00025Cr 3                 PS2_DAT    = %00010000
00025Cr 3                 PAD_REG    = PORTB
00025Cr 3                 PAD_DDR    = DDRB
00025Cr 3                 PAD_CLK    = %00000100
00025Cr 3                 PAD_PTS    = %00000010
00025Cr 3                 PAD_DAT    = %00000001
00025Cr 3               .ENDPROC
00025Cr 3               
00025Cr 3               ; ChDz
00025Cr 3               .PROC CRTC
00025Cr 3                 CFG = CRTCBASE+$1   ; コンフィグ
00025Cr 3                                         ;   MD0 MD1 MD2 MD3 - - - WCUE
00025Cr 3                                         ;   MD : 色モード選択（各フレーム）
00025Cr 3                                         ;   WCUE  : 書き込みカウントアップ有効化
00025Cr 3               
00025Cr 3                 VMAH = CRTCBASE+$2  ; VRAM書き込みアドレス下位
00025Cr 3                                         ;   - 6 5 4 3 2 1 0
00025Cr 3               
00025Cr 3                 VMAV = CRTCBASE+$3  ; VRAM書き込みアドレス上位
00025Cr 3                                     ;   7 6 5 4 3 2 1 0
00025Cr 3               
00025Cr 3                 WDBF = CRTCBASE+$4  ; 書き込みデータ
00025Cr 3               
00025Cr 3                 RF  = CRTCBASE+$5   ; 出力フレーム選択
00025Cr 3                                     ;   (0) 1 0 | (1) 1 0 | (2) 1 0 | (3) 1 0
00025Cr 3               
00025Cr 3                 WF  = CRTCBASE+$6   ; 書き込みフレーム選択
00025Cr 3                                     ;   - - - - - - WF1 WF0
00025Cr 3               
00025Cr 3                 TCP  = CRTCBASE+$7  ; 2色モード色選択
00025Cr 3                                         ;   (0) 3 2 1 0 | (1) 3 2 1 0
00025Cr 3               .ENDPROC
00025Cr 3               
00025Cr 3               ; YMZ
00025Cr 3               .PROC YMZ
00025Cr 3                 ADDR = YMZBASE
00025Cr 3                 DATA = YMZBASE+1
00025Cr 3                 ; IR:Internal Address
00025Cr 3                 IA_FRQ = $00        ; 各チャンネル周波数
00025Cr 3                 IA_NOISE_FRQ = $06  ; ノイズ音周波数
00025Cr 3                 IA_MIX = $07        ; ミキサ設定
00025Cr 3                 IA_VOL = $08        ; 各チャンネル音量
00025Cr 3                 IA_EVLP_FRQ = $0B   ; エンベロープ周波数
00025Cr 3                 IA_EVLP_SHAPE = $0D ; エンベロープ形状
00025Cr 3               .ENDPROC
00025Cr 3               
00025Cr 3               
00025Cr 2               .INCLUDE "errorcode.inc"
00025Cr 3               ; エラーコード
00025Cr 3               DRV_NOT_FOUND         = 0   ; 存在しないドライブ文字が指定された
00025Cr 3               ILLEGAL_PATH          = 1   ; ヘンなパス
00025Cr 3               FILE_NOT_FOUND        = 2   ; そんなファイルはない
00025Cr 3               NOT_DIR               = 3   ; ディレクトリではない
00025Cr 3               FAILED_CLOSE          = 4
00025Cr 3               FAILED_OPEN           = 5
00025Cr 3               
00025Cr 3               
00025Cr 2               
00025Cr 2               .INCLUDE "lib_fs.s"
00025Cr 3               ; fs.sのルーチンのうち、汎用性が高そうなものが押し込まれる
00025Cr 3               ; とはいえ再利用を考えているわけでない
00025Cr 3               PATTERNMATCH:                   ; http://www.6502.org/source/strings/patmatch.htm by Paul Guertin
00025Cr 3  A0 00          LDY #0                        ; ZR2パターンのインデックス
00025Er 3  A2 FF          LDX #$FF                      ; FINFO::NAMEのインデックス
000260r 3               @NEXT:
000260r 3  B1 rr          LDA (ZR2),Y                   ; 次のパターン文字を見る
000262r 3  C9 2A          CMP #'*'                      ; スターか？
000264r 3  F0 1F          BEQ @STAR
000266r 3  E8             INX
000267r 3  C9 3F          CMP #'?'                      ; ハテナか
000269r 3  D0 09          BNE @REG                      ; スターでもはてなでもないので普通の文字
00026Br 3  BD rr rr       LDA FINFO_WK+FINFO::NAME,X    ; ハテナなのでなんにでもマッチする（同じ文字をロードしておいて比較する）
00026Er 3  F0 2D          BEQ @FAIL                     ; 終了ならマッチしない
000270r 3  C9 2F          CMP #'/'
000272r 3  F0 29          BEQ @FAIL
000274r 3               @REG:
000274r 3  DD rr rr       CMP FINFO_WK+FINFO::NAME,X    ; 文字が等しいか？
000277r 3  F0 06          BEQ @EQ
000279r 3  C9 2F          CMP #'/'                      ; これらは終端か2
00027Br 3  F0 07          BEQ @FOUND
00027Dr 3  80 1E          BRA @FAIL
00027Fr 3               @EQ:
00027Fr 3  C8             INY                           ; 合っている、続けよう
000280r 3  C9 00          CMP #0                        ; これらは終端か
000282r 3  D0 DC          BNE @NEXT
000284r 3               @FOUND:
000284r 3  60             RTS                           ; 成功したのでC=1を返す（SECしなくてよいのか）
000285r 3               @STAR:
000285r 3  C8             INY                           ; ZR2パターンの*をスキップ
000286r 3  D1 rr          CMP (ZR2),Y                   ; 連続する*は一つの*に等しい
000288r 3  F0 FB          BEQ @STAR                     ; のでスキップする
00028Ar 3               @STLOOP:
00028Ar 3  5A             PHY
00028Br 3  DA             PHX
00028Cr 3  20 rr rr       JSR @NEXT
00028Fr 3  FA             PLX
000290r 3  7A             PLY
000291r 3  B0 F1          BCS @FOUND                    ; マッチしたらC=1が帰る
000293r 3  E8             INX                           ; マッチしなかったら*を成長させる
000294r 3  BD rr rr       LDA FINFO_WK+FINFO::NAME,X    ; 終端か
000297r 3  F0 04          BEQ @FAIL
000299r 3  C9 2F          CMP #'/'
00029Br 3  D0 ED          BNE @STLOOP
00029Dr 3               @FAIL:
00029Dr 3  18             CLC                           ; マッチしなかったらC=0が帰る
00029Er 3  60             RTS
00029Fr 3               
00029Fr 3               L_LD_AXS:
00029Fr 3  86 rr          STX ZP_LSRC0_VEC16+1
0002A1r 3               L_LD_AS:
0002A1r 3  85 rr          STA ZP_LSRC0_VEC16
0002A3r 3               L_LD:
0002A3r 3                 ; 値の輸入
0002A3r 3                 ; DSTは設定済み
0002A3r 3  A0 00          LDY #0
0002A5r 3               @LOOP:
0002A5r 3  B1 rr          LDA (ZP_LSRC0_VEC16),Y
0002A7r 3  91 rr          STA (ZP_LDST0_VEC16),Y
0002A9r 3  C8             INY
0002AAr 3  C0 04          CPY #4
0002ACr 3  D0 F7          BNE @LOOP
0002AEr 3  60             RTS
0002AFr 3               
0002AFr 3               AX_SRC:
0002AFr 3                 ; AXからソース作成
0002AFr 3  85 rr          STA ZP_LSRC0_VEC16
0002B1r 3  86 rr          STX ZP_LSRC0_VEC16+1
0002B3r 3  60             RTS
0002B4r 3               
0002B4r 3               AX_DST:
0002B4r 3                 ; AXからデスティネーション作成
0002B4r 3  85 rr          STA ZP_LDST0_VEC16
0002B6r 3  86 rr          STX ZP_LDST0_VEC16+1
0002B8r 3  60             RTS
0002B9r 3               
0002B9r 3               L_X2_AXD:
0002B9r 3  20 rr rr       JSR AX_DST
0002BCr 3               L_X2:
0002BCr 3                 ; 32bit値を二倍にシフト
0002BCr 3  A0 00          LDY #0
0002BEr 3  18             CLC
0002BFr 3  08             PHP
0002C0r 3               @LOOP:
0002C0r 3  28             PLP
0002C1r 3  B1 rr          LDA (ZP_LDST0_VEC16),Y
0002C3r 3  2A             ROL
0002C4r 3  91 rr          STA (ZP_LDST0_VEC16),Y
0002C6r 3  C8             INY
0002C7r 3  08             PHP
0002C8r 3  C0 04          CPY #4
0002CAr 3  D0 F4          BNE @LOOP
0002CCr 3  28             PLP
0002CDr 3  60             RTS
0002CEr 3               
0002CEr 3               L_ADD_AXS:
0002CEr 3  20 rr rr       JSR AX_SRC
0002D1r 3               L_ADD:
0002D1r 3                 ; 32bit値同士を加算
0002D1r 3  18             CLC
0002D2r 3  A0 00          LDY #0
0002D4r 3  08             PHP
0002D5r 3               @LOOP:
0002D5r 3  28             PLP
0002D6r 3  B1 rr          LDA (ZP_LSRC0_VEC16),Y
0002D8r 3  71 rr          ADC (ZP_LDST0_VEC16),Y
0002DAr 3  08             PHP
0002DBr 3  91 rr          STA (ZP_LDST0_VEC16),Y
0002DDr 3  C8             INY
0002DEr 3  C0 04          CPY #4
0002E0r 3  D0 F3          BNE @LOOP
0002E2r 3  28             PLP
0002E3r 3  60             RTS
0002E4r 3               
0002E4r 3               L_ADD_BYT:
0002E4r 3                 ; 32bit値に8bit値（アキュムレータ）を加算
0002E4r 3  18             CLC
0002E5r 3               @C:
0002E5r 3  08             PHP
0002E6r 3  A0 00          LDY #0
0002E8r 3               @LOOP:
0002E8r 3  28             PLP
0002E9r 3  71 rr          ADC (ZP_LDST0_VEC16),Y
0002EBr 3  08             PHP
0002ECr 3  91 rr          STA (ZP_LDST0_VEC16),Y
0002EEr 3  A9 00          LDA #0
0002F0r 3  C8             INY
0002F1r 3  C0 04          CPY #4
0002F3r 3  D0 F3          BNE @LOOP
0002F5r 3  28             PLP
0002F6r 3  60             RTS
0002F7r 3               
0002F7r 3               L_CMP:
0002F7r 3                 ; 32bit値同士が等しいか否かをゼロフラグで返す
0002F7r 3  A0 00          LDY #0
0002F9r 3               @LOOP:
0002F9r 3  B1 rr          LDA (ZP_LSRC0_VEC16),Y
0002FBr 3  D1 rr          CMP (ZP_LDST0_VEC16),Y
0002FDr 3  D0 05          BNE @NOTEQ                  ; 違ってたら抜ける…フラグをそのまま
0002FFr 3  C8             INY
000300r 3  C0 04          CPY #4
000302r 3  D0 F5          BNE @LOOP                   ; 全部見たなら抜ける…フラグをそのまま
000304r 3               @NOTEQ:
000304r 3  60             RTS
000305r 3               
000305r 3               S_ADD_BYT:
000305r 3                 ; AXにYを加算
000305r 3  85 rr          STA ZR0
000307r 3  86 rr          STX ZR0+1
000309r 3  98             TYA
00030Ar 3  18             CLC
00030Br 3  65 rr          ADC ZR0
00030Dr 3  85 rr          STA ZR0
00030Fr 3  A9 00          LDA #0
000311r 3  65 rr          ADC ZR0+1
000313r 3  85 rr          STA ZR0+1
000315r 3  A5 rr          LDA ZR0
000317r 3  A6 rr          LDX ZR0+1
000319r 3  60             RTS
00031Ar 3               
00031Ar 3               L_SB_BYT:
00031Ar 3                 ; 32bit値から8bit値（アキュムレータ）を減算
00031Ar 3  38             SEC
00031Br 3               @C:
00031Br 3  85 rr          STA ZR0
00031Dr 3  08             PHP
00031Er 3  A0 00          LDY #0
000320r 3               @LOOP:
000320r 3  28             PLP
000321r 3  B1 rr          LDA (ZP_LDST0_VEC16),Y
000323r 3  E5 rr          SBC ZR0
000325r 3  08             PHP
000326r 3  91 rr          STA (ZP_LDST0_VEC16),Y
000328r 3  64 rr          STZ ZR0
00032Ar 3  C8             INY
00032Br 3  C0 04          CPY #4
00032Dr 3  D0 F1          BNE @LOOP
00032Fr 3  28             PLP
000330r 3  60             RTS
000331r 3               
000331r 3               M_SFN_DOT2RAW_WS:
000331r 3                 ; 専用ワークエリアを使う
000331r 3                 ; 文字列操作系はSRC固定のほうが多そう？
000331r 3  A9 rr A2 rr    loadreg16 DOT_SFN
000335r 3               M_SFN_DOT2RAW_AXS:
000335r 3  20 rr rr       JSR AX_SRC
000338r 3  A9 rr A2 rr    loadreg16 RAW_SFN
00033Cr 3               M_SFN_DOT2RAW_AXD:
00033Cr 3  20 rr rr       JSR AX_DST
00033Fr 3               M_SFN_DOT2RAW:
00033Fr 3                 ; ドット入り形式のSFNを生形式に変換する
00033Fr 3  64 rr          STZ ZR0   ; SRC
000341r 3  64 rr          STZ ZR0+1 ; DST
000343r 3               @NAMELOOP:
000343r 3                 ; 固定8ループ DST
000343r 3  A4 rr          LDY ZR0
000345r 3  B1 rr          LDA (ZP_LSRC0_VEC16),Y
000347r 3  C9 2E          CMP #'.'
000349r 3  F0 04          BEQ @SPACE
00034Br 3                 ; 次のソース
00034Br 3  E6 rr          INC ZR0
00034Dr 3  80 02          BRA @STORE
00034Fr 3                 ; スペースをロード
00034Fr 3               @SPACE:
00034Fr 3  A9 20          LDA #' '
000351r 3               @STORE:
000351r 3  A4 rr          LDY ZR0+1
000353r 3  91 rr          STA (ZP_LDST0_VEC16),Y
000355r 3  E6 rr          INC ZR0+1
000357r 3  C0 07          CPY #7
000359r 3  D0 02          BNE @CKEXEND
00035Br 3               @NAMEEND:
00035Br 3                 ; 拡張子
00035Br 3  E6 rr          INC ZR0     ; ソースを一つ進める
00035Dr 3               @CKEXEND:
00035Dr 3  C0 0C          CPY #12
00035Fr 3  D0 E2          BNE @NAMELOOP
000361r 3                 ; 結果のポインタを返す
000361r 3  A5 rr          LDA ZP_LDST0_VEC16
000363r 3  A6 rr          LDX ZP_LDST0_VEC16+1
000365r 3  60             RTS
000366r 3               
000366r 3               M_SFN_RAW2DOT_WS:
000366r 3                 ; 専用ワークエリアを使う
000366r 3  A9 rr A2 rr    loadreg16 RAW_SFN
00036Ar 3               M_SFN_RAW2DOT_AXS:
00036Ar 3  20 rr rr       JSR AX_SRC
00036Dr 3  A9 rr A2 rr    loadreg16 DOT_SFN
000371r 3               M_SFN_RAW2DOT_AXD:
000371r 3  20 rr rr       JSR AX_DST
000374r 3               M_SFN_RAW2DOT:
000374r 3                 ; 生形式のSFNをドット入り形式に変換する
000374r 3  A0 00          LDY #0
000376r 3               @NAMELOOP:
000376r 3  B1 rr          LDA (ZP_LSRC0_VEC16),Y
000378r 3  C9 20          CMP #' '
00037Ar 3  F0 07          BEQ @NAMEEND
00037Cr 3  91 rr          STA (ZP_LDST0_VEC16),Y
00037Er 3  C8             INY
00037Fr 3  C0 08          CPY #8
000381r 3  D0 F3          BNE @NAMELOOP
000383r 3               @NAMEEND:
000383r 3                 ; 最終文字がスペースかどうかで拡張子の有無を判別
000383r 3  84 rr          STY ZR0 ; DSTのインデックス
000385r 3  A0 08          LDY #8
000387r 3  B1 rr          LDA (ZP_LSRC0_VEC16),Y
000389r 3  84 rr          STY ZR0+1 ;SRCのインデックス
00038Br 3  A4 rr          LDY ZR0
00038Dr 3  C9 20          CMP #' '
00038Fr 3  F0 1B          BEQ @NOEX
000391r 3                 ; 拡張子あり
000391r 3               @EX:
000391r 3  A9 2E          LDA #'.'
000393r 3  91 rr          STA (ZP_LDST0_VEC16),Y
000395r 3  C8             INY
000396r 3  84 rr          STY ZR0
000398r 3               @EXTLOOP:
000398r 3  A4 rr          LDY ZR0+1
00039Ar 3  B1 rr          LDA (ZP_LSRC0_VEC16),Y
00039Cr 3  C8             INY
00039Dr 3  C0 0C          CPY #12
00039Fr 3  F0 0B          BEQ @NOEX
0003A1r 3  84 rr          STY ZR0+1
0003A3r 3  A4 rr          LDY ZR0
0003A5r 3  91 rr          STA (ZP_LDST0_VEC16),Y
0003A7r 3  C8             INY
0003A8r 3  84 rr          STY ZR0
0003AAr 3  80 EC          BRA @EXTLOOP
0003ACr 3                 ; 終端
0003ACr 3               @NOEX:
0003ACr 3  A4 rr          LDY ZR0
0003AEr 3  A9 00          LDA #0
0003B0r 3  91 rr          STA (ZP_LDST0_VEC16),Y
0003B2r 3                 ; 結果のポインタを返す
0003B2r 3  A5 rr          LDA ZP_LDST0_VEC16
0003B4r 3  A6 rr          LDX ZP_LDST0_VEC16+1
0003B6r 3  60             RTS
0003B7r 3               
0003B7r 3               M_CP_AYS:
0003B7r 3                 ; 文字列をコピーする
0003B7r 3  85 rr          STA ZR0
0003B9r 3  84 rr          STY ZR0+1
0003BBr 3  A0 FF          LDY #$FF
0003BDr 3               @LOOP:
0003BDr 3  C8             INY
0003BEr 3  B1 rr          LDA (ZR0),Y
0003C0r 3  91 rr          STA (ZR1),Y
0003C2r 3  F0 0D          BEQ M_LEN_RTS
0003C4r 3  80 F7          BRA @LOOP
0003C6r 3               
0003C6r 3               M_LEN:
0003C6r 3                 ; 文字列の長さを取得する
0003C6r 3                 ; input:AY
0003C6r 3                 ; output:Y
0003C6r 3  85 rr          STA ZR1
0003C8r 3  84 rr          STY ZR1+1
0003CAr 3               M_LEN_ZR1:  ; ZR1入力
0003CAr 3  A0 FF          LDY #$FF
0003CCr 3               @LOOP:
0003CCr 3  C8             INY
0003CDr 3  B1 rr          LDA (ZR1),Y
0003CFr 3  D0 FB          BNE @LOOP
0003D1r 3               M_LEN_RTS:
0003D1r 3  60             RTS
0003D2r 3               
0003D2r 3               CUR_DIR:
0003D2r 3  41 3A 00     .ASCIIZ "A:"
0003D5r 3  xx xx xx xx  .RES 61     ; カレントディレクトリのパスが入る。二行分でアボン
0003D9r 3  xx xx xx xx  
0003DDr 3  xx xx xx xx  
000412r 3               
000412r 3               
000412r 2               ;.PROC FAT
000412r 2                 .INCLUDE "fat.s"
000412r 3               ; -------------------------------------------------------------------
000412r 3               ;             MIRACOS BCOS FATファイルシステムモジュール
000412r 3               ; -------------------------------------------------------------------
000412r 3               ; SDカードのFAT32ファイルシステムをサポートする
000412r 3               ; 1バイトのファイル記述子をオープンすることでファイルにアクセス可能
000412r 3               ; 特殊ファイルの扱いをfs.sと分離
000412r 3               ; fs.sに直接インクルードされ、fs.sに直接アクセスできる。
000412r 3               ; -------------------------------------------------------------------
000412r 3               ;.INCLUDE "FXT65.inc"
000412r 3               ;.INCLUDE "errorcode.inc"
000412r 3               
000412r 3               INTOPEN_DRV:
000412r 3                 ; input:A=DRV
000412r 3  CD rr rr       CMP DWK_CUR_DRV       ; カレントドライブと比較
000415r 3  F0 06          BEQ @SKP_LOAD         ; 変わらないならスキップ
000417r 3  8D rr rr       STA DWK_CUR_DRV       ; カレントドライブ更新
00041Ar 3  20 rr rr       JSR LOAD_DWK
00041Dr 3               @SKP_LOAD:
00041Dr 3  60             RTS
00041Er 3               
00041Er 3               INTOPEN_FILE:
00041Er 3                 ; 内部的ファイルオープン（バッファに展開する）
00041Er 3  AD rr rr       LDA FINFO_WK+FINFO::DRV_NUM
000421r 3  20 rr rr       JSR INTOPEN_DRV                   ; ドライブ番号が違ったら更新
000424r 3  A9 rr 85 rr    loadmem16 ZR0,FINFO_WK+FINFO::HEAD
000428r 3  A9 rr 85 rr  
00042Cr 3  B2 rr          LDA (ZR0)
00042Er 3  A0 01          LDY #1                            ; クラスタ番号がゼロなら特別処理
000430r 3  11 rr          ORA (ZR0),Y
000432r 3  C8             INY
000433r 3  11 rr          ORA (ZR0),Y
000435r 3  C8             INY
000436r 3  11 rr          ORA (ZR0),Y
000438r 3  D0 0D          BNE @OTHERS                       ; クラスタ番号がゼロ
00043Ar 3  AD rr rr       LDA FINFO_WK+FINFO::ATTR          ; 属性を取得
00043Dr 3  C9 10          CMP #DIRATTR_DIRECTORY            ; ディレクトリ（..）か？
00043Fr 3  D0 06          BNE @OTHERS
000441r 3  A9 rr A2 rr    loadreg16 DWK+DINFO::BPB_ROOTCLUS ; ..がルートを示すので特別にルートをロード
000445r 3  80 0A          BRA OPENCLUS
000447r 3               @OTHERS:
000447r 3  A9 rr A2 rr    loadreg16 FINFO_WK+FINFO::HEAD
00044Br 3  80 04          BRA OPENCLUS
00044Dr 3               
00044Dr 3               INTOPEN_ROOT:
00044Dr 3                 ; ルートディレクトリを開く
00044Dr 3  A9 rr A2 rr    loadreg16 DWK+DINFO::BPB_ROOTCLUS
000451r 3               OPENCLUS:
000451r 3  20 rr rr       JSR CLUS2FWK
000454r 3  20 rr rr       JSR RDSEC
000457r 3  60             RTS
000458r 3               
000458r 3               CLUS2FWK:
000458r 3                 ; AXで与えられたクラスタ番号から、ファイル構造体を展開
000458r 3                 ; サイズに触れないため、ディレクトリにも使える
000458r 3                 ; --- ファイル構造体の展開
000458r 3                 ; 先頭クラスタ番号
000458r 3  20 rr rr       JSR AX_SRC
00045Br 3  A9 rr A2 rr    loadreg16 FWK+FCTRL::HEAD
00045Fr 3  20 rr rr       JSR AX_DST
000462r 3  20 rr rr       JSR L_LD
000465r 3               FILE_REOPEN:
000465r 3                 ; ここから呼ぶと現在のファイルを開きなおす
000465r 3                 ; 現在クラスタ番号に先頭クラスタ番号をコピー
000465r 3  A9 rr A2 rr    loadreg16 FWK+FCTRL::CUR_CLUS
000469r 3  20 rr rr       JSR AX_DST
00046Cr 3  A9 rr A2 rr    loadreg16 FWK+FCTRL::HEAD
000470r 3  20 rr rr       JSR L_LD_AXS
000473r 3                 ; 現在クラスタ内セクタ番号をゼロに
000473r 3  9C rr rr       STZ FWK+FCTRL::CUR_SEC
000476r 3                 ; リアルセクタ番号を展開
000476r 3                 ;loadmem8l ZP_LDST0_VEC16,FWK_REAL_SEC
000476r 3  A9 rr A2 rr    loadreg16 (FWK_REAL_SEC)
00047Ar 3  20 rr rr       JSR AX_DST
00047Dr 3  20 rr rr       JSR CLUS2SEC_IMP
000480r 3  A9 rr A2 rr    loadreg16 (FWK_REAL_SEC)
000484r 3  60             RTS
000485r 3               
000485r 3               LOAD_FWK:
000485r 3                 ; FCTRL内容をワークエリアにロード
000485r 3                 ; input:A=FD
000485r 3  20 rr rr       JSR FD2FCTRL
000488r 3  85 rr          STA ZR0
00048Ar 3  86 rr          STX ZR0+1               ; ZR0:FCTRL先頭ポインタ（ソース）
00048Cr 3  A9 rr 85 rr    loadmem16 ZR1,FWK       ; ZR1:ワークエリア先頭ポインタ（ディスティネーション）
000490r 3  A9 rr 85 rr  
000494r 3  A0 12          LDY #.SIZEOF(FCTRL)     ; Y=最後尾インデックス
000496r 3               @LOOP:
000496r 3  B1 rr          LDA (ZR0),Y
000498r 3  91 rr          STA (ZR1),Y
00049Ar 3  88             DEY
00049Br 3  F0 F9          BEQ @LOOP
00049Dr 3  10 F7          BPL @LOOP
00049Fr 3               @END:
00049Fr 3  60             RTS
0004A0r 3               
0004A0r 3               PUT_FWK:
0004A0r 3                 ; ワークエリアからFCTRLに書き込む
0004A0r 3                 ; input:A=FD
0004A0r 3  20 rr rr       JSR FD2FCTRL
0004A3r 3  85 rr          STA ZR0
0004A5r 3  86 rr          STX ZR0+1               ; ZR0:FCTRL先頭ポインタ（ディスティネーション）
0004A7r 3  A9 rr 85 rr    loadmem16 ZR1,FWK       ; ZR1:ワークエリア先頭ポインタ（ソース）
0004ABr 3  A9 rr 85 rr  
0004AFr 3  A0 12          LDY #.SIZEOF(FCTRL)     ; Y=最後尾インデックス
0004B1r 3               @LOOP:
0004B1r 3  B1 rr          LDA (ZR1),Y
0004B3r 3  91 rr          STA (ZR0),Y
0004B5r 3  88             DEY
0004B6r 3  F0 F9          BEQ @LOOP
0004B8r 3  10 F7          BPL @LOOP
0004BAr 3               @END:
0004BAr 3  60             RTS
0004BBr 3               
0004BBr 3               LOAD_DWK:
0004BBr 3                 ; ドライブ情報をワークエリアに展開する
0004BBr 3                 ; 複数ドライブが実装されるまでは徒労もいいところ
0004BBr 3                 ; input A=ドライブ番号
0004BBr 3  8D rr rr       STA FWK+FCTRL::DRV_NUM  ; ファイルワークエリアのドライブ番号をセット
0004BEr 3  0A             ASL                     ; ベクタテーブルなので二倍にする
0004BFr 3  A8             TAY
0004C0r 3  B9 rr rr       LDA DRV_TABLE,Y
0004C3r 3  BE rr rr       LDX DRV_TABLE+1,Y       ;NOTE:ベクタ位置を示すBP
0004C6r 3  85 rr          STA ZR0
0004C8r 3  86 rr          STX ZR0+1
0004CAr 3                 ; コピーループ
0004CAr 3  A0 00          LDY #0
0004CCr 3               @LOOP:
0004CCr 3  B1 rr          LDA (ZR0),Y
0004CEr 3  99 rr rr       STA DWK,Y
0004D1r 3  C8             INY
0004D2r 3  C0 11          CPY #.SIZEOF(DINFO)      ; DINFOのサイズ分コピーしたら終了
0004D4r 3  D0 F6          BNE @LOOP                ; ロード結果を示すBP
0004D6r 3  60             RTS
0004D7r 3               
0004D7r 3               RDSEC:
0004D7r 3                 ;loadmem16 ZP_SDSEEK_VEC16,SECBF512         ; SECBFに縛るのは面白くない
0004D7r 3                 ;loadAY16 SECBF512                          ; 分割するとき、どうせ下位はゼロなのだからloadAYはナンセンス
0004D7r 3  A9 rr          LDA #>SECBF512
0004D9r 3               RDSEC_A_DST:                                  ; Aが読み取り先ページを示す
0004D9r 3                 ;storeAY16 ZP_SDSEEK_VEC16                  ; ナンセンス
0004D9r 3  85 rr          STA ZP_SDSEEK_VEC16+1
0004DBr 3  64 rr          STZ ZP_SDSEEK_VEC16
0004DDr 3  A9 rr 85 rr    loadmem16 ZP_SDCMDPRM_VEC16,(FWK_REAL_SEC)  ; NOTE:FWK_REAL_SECを読んで監視するBP
0004E1r 3  A9 rr 85 rr  
0004E5r 3  20 rr rr       JSR SD::RDSEC
0004E8r 3  38             SEC
0004E9r 3  D0 03          BNE @ERR
0004EBr 3               @SKP_E:
0004EBr 3  C6 rr          DEC ZP_SDSEEK_VEC16+1
0004EDr 3  18             CLC
0004EEr 3               @ERR:
0004EEr 3  60             RTS
0004EFr 3               
0004EFr 3               CLUS2SEC_AXS: ; ソースを指定
0004EFr 3  20 rr rr       JSR AX_SRC
0004F2r 3               CLUS2SEC_IMP: ; S,Dが適切に設定されている
0004F2r 3  20 rr rr       JSR L_LD    ; そのままコピーする
0004F5r 3               CLUS2SEC:
0004F5r 3                 ; クラスタ番号をセクタ番号に変換する
0004F5r 3                 ; SECPERCLUSは2の累乗であることが保証されている
0004F5r 3                 ; 2を減算
0004F5r 3  A9 02          LDA #$2
0004F7r 3  20 rr rr       JSR L_SB_BYT
0004FAr 3                 ; *SECPERCLUS
0004FAr 3  AD rr rr       LDA DWK+DINFO::BPB_SECPERCLUS
0004FDr 3               @LOOP:
0004FDr 3  AA             TAX
0004FEr 3  20 rr rr       JSR L_X2
000501r 3  8A             TXA
000502r 3  4A             LSR
000503r 3  C9 01          CMP #1
000505r 3  D0 F6          BNE @LOOP
000507r 3                 ; DATSTARTを加算
000507r 3  A9 rr A2 rr    loadreg16 (DWK+DINFO::DATSTART)
00050Br 3  20 rr rr       JSR L_ADD_AXS
00050Er 3  60             RTS
00050Fr 3               
00050Fr 3               DIR_NEXTENT:
00050Fr 3                 ; 次の有効な（LFNでない）エントリを拾ってくる
00050Fr 3                 ; ZP_SDSEEK_VEC16が32bitにアライメントされる
00050Fr 3                 ; Aには属性が入って帰る
00050Fr 3                 ; もう何もなければ$FFを返す
00050Fr 3                 ; 次のエントリ
00050Fr 3               @LOOP:
00050Fr 3  A5 rr          LDA ZP_SDSEEK_VEC16+1
000511r 3  C9 rr          CMP #(>SECBF512)+1
000513r 3  D0 0E          BNE @SKP_NEXTSEC            ; 上位桁が後半でないならセクタ読み切りの心配なし
000515r 3  A5 rr          LDA ZP_SDSEEK_VEC16
000517r 3  C9 E0          CMP #256-32
000519r 3  D0 08          BNE @SKP_NEXTSEC            ; 下位桁が最終エントリならこのセクタは読み切った
00051Br 3  20 rr rr       JSR NEXTSEC                 ; 次のセクタに進む
00051Er 3  20 rr rr       JSR RDSEC                   ; セクタを読み出す
000521r 3  80 0D          BRA @ENT
000523r 3               @SKP_NEXTSEC:
000523r 3                 ; シーク
000523r 3  A5 rr          LDA ZP_SDSEEK_VEC16
000525r 3  A6 rr          LDX ZP_SDSEEK_VEC16+1
000527r 3  A0 20          LDY #32
000529r 3  20 rr rr       JSR S_ADD_BYT
00052Cr 3  85 rr          STA ZP_SDSEEK_VEC16
00052Er 3  86 rr          STX ZP_SDSEEK_VEC16+1
000530r 3               @ENT:
000530r 3               DIR_NEXTENT_ENT:              ; エントリポイント
000530r 3  20 rr rr       JSR DIR_GETENT
000533r 3  C9 00          CMP #0
000535r 3  D0 03          BNE @SKP_NULL               ; 0ならもうない
000537r 3  A9 FF          LDA #$FF                    ; EC:NotFound
000539r 3  60             RTS
00053Ar 3               @SKP_NULL:
00053Ar 3  C9 E5          CMP #$E5                    ; 消去されたエントリ
00053Cr 3  F0 D1          BEQ DIR_NEXTENT
00053Er 3  C9 0F          CMP #DIRATTR_LONGNAME
000540r 3  D0 02          BNE @EXT
000542r 3  80 CB          BRA DIR_NEXTENT
000544r 3               @EXT:
000544r 3  AD rr rr       LDA FINFO_WK+FINFO::ATTR
000547r 3  60             RTS
000548r 3               
000548r 3               DIR_GETENT:
000548r 3                 ; エントリを拾ってくる
000548r 3                 ; ZP_SDSEEK_VEC16がディレクトリエントリ先頭にある
000548r 3                 ; 属性
000548r 3                 ; LFNだったらサボる
000548r 3  AD rr rr       LDA FWK+FCTRL::DRV_NUM        ; FWKのドライブ番号を引っ張る
00054Br 3  8D rr rr       STA FINFO_WK+FINFO::DRV_NUM   ; DRV_NUM登録
00054Er 3  A2 04          LDX #4
000550r 3               @CLUSLOOP:                      ; ディレクトリの現在クラスタとクラスタ内セクタをコピー
000550r 3  BD rr rr       LDA FWK+FCTRL::CUR_CLUS,X
000553r 3  9D rr rr       STA FINFO_WK+FINFO::DIR_CLUS,X
000556r 3  CA             DEX
000557r 3  10 F7          BPL @CLUSLOOP
000559r 3                 ; セクタ内エントリ番号の登録
000559r 3  A5 rr          LDA ZP_SDSEEK_VEC16+1         ; シーク位置の上位
00055Br 3  C9 rr          CMP #>SECBF512                ; バッファの上位と同じか
00055Dr 3  18             CLC
00055Er 3  F0 01          BEQ @SKP_8
000560r 3  38             SEC
000561r 3               @SKP_8:                         ; シークがセクタ前半ならC=0、後半ならC=1
000561r 3  A5 rr          LDA ZP_SDSEEK_VEC16           ; シーク位置の下位、32bitアライメント
000563r 3  6A             ROR ; 16                      ; キャリーを巻き込む
000564r 3  8D rr rr       STA FINFO_WK+FINFO::DIR_ENT   ; セクタ内エントリ番号を登録
000567r 3  A0 0B          LDY #OFS_DIR_ATTR
000569r 3  B1 rr          LDA (ZP_SDSEEK_VEC16),Y
00056Br 3  8D rr rr       STA FINFO_WK+FINFO::ATTR      ; 一応LFNであったとしても属性は残しておく
00056Er 3  C9 0F          CMP #DIRATTR_LONGNAME         ; LFNならサボる
000570r 3  F0 58          BEQ @EXT
000572r 3                 ; 名前
000572r 3  B2 rr          LDA (ZP_SDSEEK_VEC16)
000574r 3  F0 54          BEQ @EXT                      ; 0ならもうない
000576r 3  C9 E5          CMP #$E5                      ; 消去されたエントリならサボる
000578r 3  F0 50          BEQ @EXT
00057Ar 3  A5 rr          LDA ZP_SDSEEK_VEC16
00057Cr 3  A6 rr          LDX ZP_SDSEEK_VEC16+1
00057Er 3  20 rr rr       JSR AX_SRC
000581r 3  A9 rr A2 rr    loadreg16 FINFO_WK+FINFO::NAME
000585r 3  20 rr rr       JSR M_SFN_RAW2DOT_AXD
000588r 3                 ; サイズ
000588r 3  A9 rr A2 rr    loadreg16 FINFO_WK+FINFO::SIZ
00058Cr 3  20 rr rr       JSR AX_DST
00058Fr 3  A5 rr          LDA ZP_SDSEEK_VEC16
000591r 3  A6 rr          LDX ZP_SDSEEK_VEC16+1
000593r 3  A0 1C          LDY #OFS_DIR_FILESIZE
000595r 3  20 rr rr       JSR S_ADD_BYT
000598r 3  20 rr rr       JSR L_LD_AXS
00059Br 3                 ; 更新日時
00059Br 3  A9 rr A2 rr    loadreg16 FINFO_WK+FINFO::WRTIME
00059Fr 3  20 rr rr       JSR AX_DST
0005A2r 3  A5 rr          LDA ZP_SDSEEK_VEC16
0005A4r 3  A6 rr          LDX ZP_SDSEEK_VEC16+1
0005A6r 3  A0 16          LDY #OFS_DIR_WRTTIME
0005A8r 3  20 rr rr       JSR S_ADD_BYT
0005ABr 3  20 rr rr       JSR L_LD_AXS
0005AEr 3                ; クラスタ番号
0005AEr 3                 ; TODO 16bitコピーのサブルーチン化
0005AEr 3  A0 1A          LDY #OFS_DIR_FSTCLUSLO
0005B0r 3  B1 rr          LDA (ZP_SDSEEK_VEC16),Y      ; 低位
0005B2r 3  8D rr rr       STA FINFO_WK+FINFO::HEAD
0005B5r 3  C8             INY
0005B6r 3  B1 rr          LDA (ZP_SDSEEK_VEC16),Y      ; 低位
0005B8r 3  8D rr rr       STA FINFO_WK+FINFO::HEAD+1
0005BBr 3  A0 14          LDY #OFS_DIR_FSTCLUSHI
0005BDr 3  B1 rr          LDA (ZP_SDSEEK_VEC16),Y      ; 高位
0005BFr 3  8D rr rr       STA FINFO_WK+FINFO::HEAD+2
0005C2r 3  C8             INY
0005C3r 3  B1 rr          LDA (ZP_SDSEEK_VEC16),Y      ; 高位
0005C5r 3  8D rr rr       STA FINFO_WK+FINFO::HEAD+3
0005C8r 3  A9 01          LDA #1                       ; 成功コード
0005CAr 3               @EXT:
0005CAr 3  60             RTS
0005CBr 3               
0005CBr 3               NEXTSEC:
0005CBr 3                 ; ファイル構造体を更新し、次のセクタを開く
0005CBr 3                 ; クラスタ内セクタ番号の更新
0005CBr 3  AD rr rr       LDA FWK+FCTRL::CUR_SEC
0005CEr 3  CD rr rr       CMP DWK+DINFO::BPB_SECPERCLUS ; クラスタ内最終セクタか
0005D1r 3  D0 01          BNE @SKP_NEXTCLUS             ; まだならFATチェーン読み取りキャンセル
0005D3r 3  00             BRK                           ; TODO:FATを読む
0005D4r 3               @SKP_NEXTCLUS:
0005D4r 3  EE rr rr       INC FWK+FCTRL::CUR_SEC
0005D7r 3                 ; リアルセクタ番号を更新
0005D7r 3  A9 rr A2 rr    loadreg16 (FWK_REAL_SEC)
0005DBr 3  20 rr rr       JSR AX_DST
0005DEr 3  A9 01          LDA #1
0005E0r 3  20 rr rr       JSR L_ADD_BYT
0005E3r 3  60             RTS
0005E4r 3               
0005E4r 3               FINFO2SIZ:
0005E4r 3                 ; FINFO構造体に展開されたサイズをFCTRL構造体にコピー
0005E4r 3  A9 rr A2 rr    loadreg16 FWK+FCTRL::SIZ        ; デスティネーションをサイズに
0005E8r 3  20 rr rr       JSR AX_DST
0005EBr 3  A9 rr A2 rr    loadreg16 FINFO_WK+FINFO::SIZ   ; ソースをFINFOのサイズにしてロード
0005EFr 3  20 rr rr       JSR L_LD_AXS
0005F2r 3  A9 rr A2 rr    loadreg16 FWK+FCTRL::SEEK_PTR   ; デスティネーションをシークポインタに
0005F6r 3  20 rr rr       JSR AX_DST
0005F9r 3  A9 rr A2 rr    loadreg16 SD::BTS_CMDPRM_ZERO   ; ソースを$00000000にしてロード
0005FDr 3  20 rr rr       JSR L_LD_AXS
000600r 3  60             RTS
000601r 3               
000601r 3               DIR_NEXTMATCH:
000601r 3                 ; 次のマッチするエントリを拾ってくる（FINFO_WKを構築する）
000601r 3                 ; ZP_SDSEEK_VEC16が32bitにアライメントされる
000601r 3                 ; Aには属性が入って帰る
000601r 3                 ; もう何もなければ$FFを返す
000601r 3                 ; input:AY=ファイル名
000601r 3  85 rr          STA ZR2                       ; ZR2=マッチパターン（ファイル名）
000603r 3  84 rr          STY ZR2+1
000605r 3  20 rr rr       JSR DIR_NEXTENT_ENT           ; 初回用エントリ
000608r 3  80 03          BRA :+                        ; @FIRST
00060Ar 3               DIR_NEXTMATCH_NEXT_ZR2:         ; 今のポイントを無視して次を探すためのエントリポイント
00060Ar 3               @NEXT:
00060Ar 3  20 rr rr       JSR DIR_NEXTENT               ; 次のエントリを拾う
00060Dr 3               :
00060Dr 3               @FIRST:
00060Dr 3  C9 FF          CMP #$FF                      ; もうエントリがない時のエラーハンドル
00060Fr 3  D0 01          BNE @SKP_END
000611r 3  60             RTS
000612r 3               @SKP_END:
000612r 3  48             PHA                           ; 属性値をプッシュ
000613r 3  A5 rr          LDA ZR2
000615r 3  A4 rr          LDY ZR2+1
000617r 3  20 rr rr       JSR PATTERNMATCH
00061Ar 3  68             PLA                           ; 属性値をプル
00061Br 3  90 ED          BCC @NEXT                     ; C=0つまりマッチしなかったら次を見る
00061Dr 3  60             RTS
00061Er 3               
00061Er 3               PATH2FINFO:
00061Er 3                 ; フルパスからFINFOをゲットする
00061Er 3                 ; input:AY=PATH
00061Er 3                 ; output:AY=FINFO, ZR2=最終要素の先頭
00061Er 3                 ; ZR0,2使用
00061Er 3  85 rr          STA ZR2
000620r 3  84 rr          STY ZR2+1             ; パス先頭を格納
000622r 3               PATH2FINFO_ZR2:
000622r 3  A0 01          LDY #1
000624r 3  B1 rr          LDA (ZR2),Y           ; 二文字目
000626r 3  C9 3A          CMP #':'              ; ドライブ文字があること判別
000628r 3  F0 05          BEQ @SKP_E1
00062Ar 3  A9 01          LDA #ERR::ILLEGAL_PATH
00062Cr 3  4C rr rr       JMP ERR::REPORT       ; ERR:ドライブ文字がないパスをぶち込まれても困る
00062Fr 3               @SKP_E1:
00062Fr 3  B2 rr          LDA (ZR2)             ; ドライブレターを取得
000631r 3  38             SEC
000632r 3  E9 41          SBC #'A'              ; ドライブ番号に変換
000634r 3                 ;STA FINFO_WK+FINFO::DRV_NUM ; ドライブ番号を登録
000634r 3  20 rr rr       JSR INTOPEN_DRV       ; ドライブを開く
000637r 3  20 rr rr       JSR INTOPEN_ROOT      ; ルートディレクトリを開く
00063Ar 3                 ; ディレクトリをたどる旅
00063Ar 3               @LOOP:
00063Ar 3  A5 rr A4 rr    mem2AY16 ZR2
00063Er 3  20 rr rr       JSR PATH_SLASHNEXT_GETNULL    ; 次の（初回ならルート直下の）要素先頭、最終要素でC=1 NOTE:AYが次のよう先頭を指すBP
000641r 3  85 rr 84 rr    storeAY16 ZR2
000645r 3  B0 06          BCS @LAST             ; パス要素がまだあるなら続行
000647r 3  20 rr rr       JSR @NEXT             ; 非最終要素
00064Ar 3  90 EE          BCC @LOOP             ; 見つからないエラーがなければ次の要素へ
00064Cr 3  60             RTS                   ; 見つからなければC=1を保持して戻る
00064Dr 3               @LAST:                  ; 最終要素 ; NOTE:ZR2を読むと、LASTが本当にLASTか見えるBP
00064Dr 3  20 rr rr       JSR @NEXT
000650r 3  B0 05          BCS @ERREND           ; 最終要素が見つからなかったらC=1を保持して戻る
000652r 3  A9 rr A0 rr    loadAY16 FINFO_WK     ; パス要素がもうないのでFINFOを返す
000656r 3  18             CLC                   ; 成功コード
000657r 3               @ERREND:
000657r 3  60             RTS
000658r 3               @NEXT:
000658r 3  20 rr rr       JSR DIR_NEXTMATCH     ; 現在ディレクトリ内のマッチするファイルを取得 NOTE:ヒットしたが開かれる前のFINFOを見るBP
00065Br 3  C9 FF          CMP #$FF              ; 見つからない場合
00065Dr 3  D0 05          BNE @SKP_E2
00065Fr 3  A9 02          LDA #ERR::FILE_NOT_FOUND
000661r 3  4C rr rr       JMP ERR::REPORT       ; ERR:指定されてファイルが見つからなかった
000664r 3               @SKP_E2:
000664r 3  20 rr rr       JSR INTOPEN_FILE      ; ファイル/ディレクトリを開く NOTE:開かれた内容を覗くBP
000667r 3  18             CLC                   ; コールされた時の成功を知るC=0
000668r 3  60             RTS
000669r 3               
000669r 3               PATH_SLASHNEXT_GETNULL:
000669r 3                 ; 下のサブルーチンの、その要素が/で終わるのかnullで終わるのか通知する版
000669r 3  20 rr rr       JSR PATH_SLASHNEXT
00066Cr 3  90 01          BCC @SKP_FIRSTNULL        ; そもそもnullから開始される
00066Er 3  60             RTS
00066Fr 3               @SKP_FIRSTNULL:
00066Fr 3  48 5A          pushAY16
000671r 3  20 rr rr       JSR PATH_SLASHNEXT        ; 進んだ先の次を探知
000674r 3  7A 68          pullAY16
000676r 3  60             RTS                       ; キャリー含め返す
000677r 3               
000677r 3               PATH_SLASHNEXT:
000677r 3                 ; AYの次のスラッシュの次を得る、AYが進む
000677r 3                 ; そこがnullならC=1（失敗
000677r 3  85 rr          STA ZR0
000679r 3  84 rr          STY ZR0+1
00067Br 3  A0 FF          LDY #$FF
00067Dr 3               @LOOP:
00067Dr 3  C8             INY
00067Er 3  B1 rr          LDA (ZR0),Y
000680r 3  D0 02          BNE @SKP_ERR
000682r 3               @EXP:                   ; 例外終了
000682r 3  38             SEC
000683r 3  60             RTS
000684r 3               @SKP_ERR:
000684r 3  C9 2F          CMP #'/'
000686r 3  D0 F5          BNE @LOOP
000688r 3  C8             INY                   ; スラッシュの次を示す
000689r 3  B1 rr          LDA (ZR0),Y           ; /の次がヌルならやはり例外終了
00068Br 3  F0 F5          BEQ @EXP
00068Dr 3  A5 rr          LDA ZR0
00068Fr 3  A6 rr          LDX ZR0+1
000691r 3  20 rr rr       JSR S_ADD_BYT         ; ZR0+Y
000694r 3  DA             PHX
000695r 3  7A             PLY
000696r 3  18             CLC
000697r 3  60             RTS
000698r 3               
000698r 3               
000698r 2               ;.ENDPROC
000698r 2               
000698r 2               ; 命名規則
000698r 2               ; BYT  8bit
000698r 2               ; SHORT 16bit
000698r 2               ; LONG  32bit
000698r 2               
000698r 2               ; -------------------------------------------------------------------
000698r 2               ;                           定数定義
000698r 2               ; -------------------------------------------------------------------
000698r 2               FCTRL_ALLOC_SIZE = 4  ; 静的に確保するFCTRLの数
000698r 2               NONSTD_FD        = 8  ; 0～7を一応標準ファイルに予約
000698r 2               
000698r 2               ; -------------------------------------------------------------------
000698r 2               ;                           初期化処理
000698r 2               ; -------------------------------------------------------------------
000698r 2               INIT:
000698r 2  A9 FF          LDA #$FF
00069Ar 2  8D rr rr       STA FINFO_WK+FINFO::SIG ; FINFO_WKのシグネチャ設定
00069Dr 2  8D rr rr       STA DWK_CUR_DRV         ; カレントドライブをめちゃくちゃにする
0006A0r 2  20 rr rr       JSR SD::INIT            ; カードの初期化
0006A3r 2                 ;JSR DRV_INIT           ; ドライブの初期化はIPLがやったのでひとまずパス
0006A3r 2                 ; ドライブテーブルの初期化
0006A3r 2  A9 rr 8D rr    loadmem16 DRV_TABLE,DRV0
0006A7r 2  rr A9 rr 8D  
0006ABr 2  rr rr        
0006ADr 2                 ; ファイル記述子テーブルの初期化 上位バイトを0にしてテーブルを開放する
0006ADr 2  A9 00          LDA #0
0006AFr 2  AA             TAX
0006B0r 2               @FDT_LOOP:
0006B0r 2  9D rr rr       STA FD_TABLE+1,X
0006B3r 2  E8             INX
0006B4r 2  E0 07          CPX #(FCTRL_ALLOC_SIZE*2)-1
0006B6r 2  D0 F8          BNE @FDT_LOOP
0006B8r 2  60             RTS
0006B9r 2               
0006B9r 2               ; -------------------------------------------------------------------
0006B9r 2               ; BCOS 15                 ファイル読み取り
0006B9r 2               ; -------------------------------------------------------------------
0006B9r 2               ; input :ZR1=fd, AY=len, ZR0=bfptr
0006B9r 2               ; output:AY=actual_len、C=EOF
0006B9r 2               ; -------------------------------------------------------------------
0006B9r 2               FUNC_FS_READ_BYTS:
0006B9r 2               ; 32bit値をコピーする
0006B9r 2               .macro long_long_copy dst,src
0006B9r 2                 LDA src
0006B9r 2                 STA dst
0006B9r 2                 LDA src+1
0006B9r 2                 STA dst+1
0006B9r 2                 LDA src+2
0006B9r 2                 STA dst+2
0006B9r 2                 LDA src+3
0006B9r 2                 STA dst+3
0006B9r 2               .endmac
0006B9r 2               ; 32bit値を減算する
0006B9r 2               .macro long_long_sub dst,left,right
0006B9r 2                 SEC
0006B9r 2                 LDA left
0006B9r 2                 SBC right
0006B9r 2                 STA dst
0006B9r 2                 LDA left+1
0006B9r 2                 SBC right+1
0006B9r 2                 STA dst+1
0006B9r 2                 LDA left+2
0006B9r 2                 SBC right+2
0006B9r 2                 STA dst+2
0006B9r 2                 LDA left+3
0006B9r 2                 SBC right+3
0006B9r 2                 STA dst+3
0006B9r 2               .endmac
0006B9r 2               ; 32bit値と16bit値とを比較する
0006B9r 2               .macro long_short_cmp left,right
0006B9r 2                 .local @EXIT
0006B9r 2                 .local @LEFT_GREAT
0006B9r 2                 .local @EQUAL
0006B9r 2                 .local @LEFT_SMALL
0006B9r 2                 ; byte 3, 2 の比較
0006B9r 2                 LDA left+3
0006B9r 2                 ORA left+2
0006B9r 2                 BNE @LEFT_GREAT ; 左の上位半分がゼロでなかったら右は敵わない
0006B9r 2                 ; byte 1
0006B9r 2                 LDA left+1
0006B9r 2                 CMP right+1
0006B9r 2                 BNE @EXIT       ; 16bit中上位8bitが同じでなかったら比較結果が出ている
0006B9r 2                 ; byte 0
0006B9r 2                 LDA left
0006B9r 2                 CMP right
0006B9r 2                 BRA @EXIT
0006B9r 2               @LEFT_GREAT:
0006B9r 2                 LDA #2
0006B9r 2                 CMP #1          ; 2-1
0006B9r 2               @EXIT:
0006B9r 2               .endmac
0006B9r 2               ; 32bit値に16bit値を加算する
0006B9r 2               .macro long_short_add dst,left,right
0006B9r 2                 CLC
0006B9r 2                 LDA left
0006B9r 2                 ADC right
0006B9r 2                 STA dst
0006B9r 2                 LDA left+1
0006B9r 2                 ADC right+1
0006B9r 2                 STA dst+1
0006B9r 2                 LDA left+2
0006B9r 2                 ADC #0
0006B9r 2                 STA dst+2
0006B9r 2                 LDA left+3
0006B9r 2                 ADC #0
0006B9r 2                 STA dst+3
0006B9r 2               .endmac
0006B9r 2                 ; ---------------------------------------------------------------
0006B9r 2                 ;   サブルーチンローカル変数の定義
0006B9r 2                 @ZR2_LENGTH         = ZR2       ; 読みたいバイト長=>読まれたバイト長
0006B9r 2                 @ZR34_TMP32         = ZR3       ; 32bit計算用、読まれたバイト長が求まった時点で破棄
0006B9r 2                 @ZR3_BFPTR          = ZR3       ; 書き込み先のアドレス
0006B9r 2                 @ZR4_ITR            = ZR4       ; イテレータ
0006B9r 2                 ; ---------------------------------------------------------------
0006B9r 2                 ;   引数の格納
0006B9r 2  85 rr 84 rr    storeAY16 @ZR2_LENGTH
0006BDr 2  A5 rr          LDA ZR1
0006BFr 2  48             PHA                             ; fdをプッシュ
0006C0r 2  A5 rr 48 A5    pushmem16 ZR0                   ; 書き込み先アドレス退避
0006C4r 2  rr 48        
0006C6r 2  A5 rr          LDA ZR1
0006C8r 2                 ; ---------------------------------------------------------------
0006C8r 2                 ;   LENGTHの算出
0006C8r 2                 ;   ファイルの残りより多く要求されていた場合、ファイルの残りにする
0006C8r 2  20 rr rr       JSR LOAD_FWK_MAKEREALSEC        ; AのfdからFCTRL構造体をロード、リアルセクタ作成
0006CBr 2  AD rr rr       LDA FWK+FCTRL::SIZ
0006CEr 2  38 AD rr rr    long_long_sub   @ZR34_TMP32, FWK+FCTRL::SIZ, FWK+FCTRL::SEEK_PTR   ; tmp=siz-seek
0006D2r 2  ED rr rr 85  
0006D6r 2  rr AD rr rr  
0006EFr 2  A5 rr 05 rr    long_short_cmp  @ZR34_TMP32, @ZR2_LENGTH                           ; tmp<=>length @ZR34_TMP32の破棄
0006F3r 2  D0 0C A5 rr  
0006F7r 2  C5 rr D0 0A  
000705r 2  F0 0A          BEQ @SKP_PARTIAL_LENGTH
000707r 2  B0 08          BCS @SKP_PARTIAL_LENGTH         ; 要求lengthがファイルの残りより小さければそのままで問題なし
000709r 2                 ; lengthをファイルの残りに変更
000709r 2  A5 rr 85 rr    mem2mem16 @ZR2_LENGTH,@ZR34_TMP32
00070Dr 2  A5 rr 85 rr  
000711r 2               @SKP_PARTIAL_LENGTH:
000711r 2                 ; lengthが0になったら強制終了
000711r 2  A5 rr          LDA @ZR2_LENGTH
000713r 2  05 rr          ORA @ZR2_LENGTH+1
000715r 2  D0 05          BNE @SKP_EOF
000717r 2                 ; length=0
000717r 2  FA             PLX                             ; fd回収
000718r 2  FA             PLX                             ; fd回収
000719r 2  FA             PLX                             ; fd回収
00071Ar 2  38             SEC
00071Br 2  60             RTS
00071Cr 2               @SKP_EOF:
00071Cr 2  68 85 rr 68    pullmem16 @ZR3_BFPTR            ; 書き込み先アドレスをスタックから復帰
000720r 2  85 rr        
000722r 2                 ; ---------------------------------------------------------------
000722r 2                 ;   モード分岐
000722r 2                 ; SEEKはセクタアライメントされているか？
000722r 2  AD rr rr       LDA FWK+FCTRL::SEEK_PTR
000725r 2  D0 12          BNE @NOT_SECALIGN
000727r 2  AD rr rr       LDA FWK+FCTRL::SEEK_PTR+1
00072Ar 2  4A             LSR
00072Br 2  B0 0C          BCS @NOT_SECALIGN
00072Dr 2                 ; SEEKがセクタアライン
00072Dr 2                 ; LENGTHはセクタアライメントされているか？
00072Dr 2  A5 rr          LDA @ZR2_LENGTH                 ; 下位
00072Fr 2  D0 08          BNE @NOT_SECALIGN
000731r 2  A5 rr          LDA @ZR2_LENGTH+1               ; 上位
000733r 2  4A             LSR                             ; C=bit0
000734r 2  B0 03          BCS @NOT_SECALIGN               ; ページ境界だがセクタ境界でない残念な場合
000736r 2                 ; LENGTHもセクタアライン、A=読み取りセクタ数
000736r 2  4C rr rr       JMP @READ_BY_SEC
000739r 2               @NOT_SECALIGN:
000739r 2                 ; SEEKがセクタアライメントされていなかった
000739r 2                 ; ---------------------------------------------------------------
000739r 2                 ;   バイト単位リード
000739r 2               @READ_BY_BYT:
000739r 2                 ; 読み取り長さの上位をイテレータに
000739r 2  A5 rr          LDA @ZR2_LENGTH+1
00073Br 2  85 rr          STA @ZR4_ITR
00073Dr 2  20 rr rr       JSR RDSEC                       ; セクタ読み取り、SDSEEKは起点
000740r 2                 ; SDSEEKの初期位置をシークポインタから計算
000740r 2  AD rr rr       LDA FWK+FCTRL::SEEK_PTR+1       ; 第1バイト
000743r 2  4A             LSR                             ; bit 0 をキャリーに
000744r 2  90 02          BCC @SKP_INCPAGE                ; C=0 上部 $03 ？ 逆では
000746r 2  E6 rr          INC ZP_SDSEEK_VEC16+1           ; C=1 下部 $04
000748r 2               @SKP_INCPAGE:
000748r 2  AD rr rr       LDA FWK+FCTRL::SEEK_PTR         ; 第0バイト
00074Br 2  85 rr          STA ZP_SDSEEK_VEC16
00074Dr 2                 ; 1文字ずつ、固定バッファロード->指定バッファに移送
00074Dr 2  A6 rr          LDX @ZR2_LENGTH                 ; ページ端数部分を初回ループカウンタに
00074Fr 2  F0 02          BEQ @SKP_INC_ITR                ; 下位がゼロでないとき、
000751r 2  E6 rr          INC @ZR4_ITR                    ; DECでゼロ検知したいので1つ足す
000753r 2               @SKP_INC_ITR:
000753r 2  A0 00          LDY #0                          ; BFPTRインデックス
000755r 2               @LOOP_BYT:
000755r 2  B2 rr          LDA (ZP_SDSEEK_VEC16)           ; 固定バッファからデータをロード
000757r 2  91 rr          STA (@ZR3_BFPTR),Y              ; 指定バッファにデータをストア
000759r 2                 ; BFPTRの更新
000759r 2  C8             INY                             ; Yインクリメント
00075Ar 2  D0 02          BNE @SKP_BF_NEXT_PAGE           ; Yが0に戻った=BFPTRのページ跨ぎ発生
00075Cr 2                 ; BFPTRのページを進める
00075Cr 2  E6 rr          INC @ZR3_BFPTR+1                ; 書き込み先の上位インクリメント
00075Er 2                 ; - BFPTRのページ進め終了
00075Er 2               @SKP_BF_NEXT_PAGE:                ; <-BFPTRページ跨ぎがない
00075Er 2                 ; SDSEEKの更新
00075Er 2  E6 rr          INC ZP_SDSEEK_VEC16             ; 下位インクリメント
000760r 2  D0 18          BNE @SKP_SDSEEK_NEXT_PAGE       ; 下位のインクリメントがゼロに=SDSEEKのページ跨ぎ
000762r 2                 ;BNE @LOOP_BYT                   ; 下位のインクリメントがゼロに=SDSEEKのページ跨ぎ
000762r 2                 ; SDSEEKのページを進める
000762r 2  A5 rr          LDA ZP_SDSEEK_VEC16+1           ; 上位
000764r 2  C9 rr          CMP #>SECBF512
000766r 2  F0 10          BEQ @SKP_SDSEEK_LOOP            ; 固定バッファの前半分だったらINCのみ
000768r 2                 ; SDSEEKのページを巻き戻し、次のセクタをロード
000768r 2  A9 rr          LDA #>(SECBF512)                ; ページを先頭に
00076Ar 2  85 rr          STA ZP_SDSEEK_VEC16+1           ; 上位更新
00076Cr 2  DA             PHX
00076Dr 2  5A             PHY
00076Er 2  20 rr rr       JSR NEXTSEC                     ; 次のセクタに移行
000771r 2  20 rr rr       JSR RDSEC                       ; ロード NOTE:Aに示されるエラーコードを見る
000774r 2  7A             PLY
000775r 2  FA             PLX
000776r 2  80 02          BRA @SKP_INC_SDSEEK
000778r 2                 ;BRA @LOOP_BYT
000778r 2                 ; - SDSEEKのページ巻き戻し終了
000778r 2               @SKP_SDSEEK_LOOP:                 ; <-ページ巻き戻しが不要
000778r 2  E6 rr          INC ZP_SDSEEK_VEC16+1           ; 上位インクリメント
00077Ar 2               @SKP_INC_SDSEEK:                  ; <-ページ巻き戻し終了（特別やることがないので実際には直接LOOP_BYTへ）
00077Ar 2               @SKP_SDSEEK_NEXT_PAGE:            ; <-SDSEEKページ跨ぎなし（特別やることがないので実際には直接LOOP_BYTへ）
00077Ar 2                 ; 残りチェック
00077Ar 2  CA             DEX
00077Br 2  D0 04          BNE @SKP_NOKORI
00077Dr 2                 ; 残りページ数チェック
00077Dr 2  C6 rr          DEC @ZR4_ITR                    ; 読み取り長さ上位イテレータ
00077Fr 2  F0 20          BEQ @END                        ; イテレータが0ならもう読むべきものはない
000781r 2               @SKP_NOKORI:
000781r 2  80 D2          BRA @LOOP_BYT                   ; 次の文字へ
000783r 2                 ; ---------------------------------------------------------------
000783r 2                 ;   セクタ単位リード
000783r 2               @READ_BY_SEC:
000783r 2                 ; 残りセクタ数をイテレータに
000783r 2  85 rr          STA @ZR4_ITR
000785r 2                 ; rdsec
000785r 2  A5 rr 85 rr    mem2mem16 ZP_SDSEEK_VEC16  ,  @ZR3_BFPTR      ; 書き込み先をBFPTRに（初回のみ）
000789r 2  A5 rr 85 rr  
00078Dr 2  A9 rr 85 rr    loadmem16 ZP_SDCMDPRM_VEC16,  FWK_REAL_SEC    ; リアルセクタをコマンドパラメータに
000791r 2  A9 rr 85 rr  
000795r 2               @LOOP_SEC:
000795r 2  20 rr rr       JSR SD::RDSEC                   ; 実際にロード
000798r 2  20 rr rr       JSR NEXTSEC                     ; 次弾装填
00079Br 2  E6 rr          INC ZP_SDSEEK_VEC16+1           ; 書き込み先ページの更新
00079Dr 2  C6 rr          DEC @ZR4_ITR                    ; 残りセクタ数を減算
00079Fr 2  D0 F4          BNE @LOOP_SEC                   ; 残りセクタが0でなければ次を読む
0007A1r 2                 ; エラー処理省略
0007A1r 2                 ; ---------------------------------------------------------------
0007A1r 2                 ;   終了処理
0007A1r 2               @END:
0007A1r 2                 ; fctrl::seekを進める
0007A1r 2  18 AD rr rr    long_short_add FWK+FCTRL::SEEK_PTR, FWK+FCTRL::SEEK_PTR, @ZR2_LENGTH ; seek=seek+length
0007A5r 2  65 rr 8D rr  
0007A9r 2  rr AD rr rr  
0007C2r 2                 ; FWKを反映
0007C2r 2  68             PLA                             ; fd
0007C3r 2  20 rr rr       JSR PUT_FWK
0007C6r 2               @SKP_SEC:
0007C6r 2                 ; 実際に読み込んだバイト長をAYで帰す
0007C6r 2  A5 rr A4 rr    mem2AY16 @ZR2_LENGTH
0007CAr 2  18             CLC
0007CBr 2                 ; debug
0007CBr 2                 ;mem2mem16 ZR0,ZP_SDSEEK_VEC16
0007CBr 2                 ;loadAY16 FWK                    ; 実験用にFCTRLを開放
0007CBr 2  60             RTS
0007CCr 2               
0007CCr 2               ; -------------------------------------------------------------------
0007CCr 2               ; BCOS 9                   ファイル検索                エラーハンドル
0007CCr 2               ; -------------------------------------------------------------------
0007CCr 2               ; input :AY=PATH
0007CCr 2               ; output:AY=FINFO
0007CCr 2               ; パス文字列から新たなFINFO構造体を得る
0007CCr 2               ; 初回（FST）
0007CCr 2               ; -------------------------------------------------------------------
0007CCr 2               FUNC_FS_FIND_FST:
0007CCr 2  20 rr rr       JSR FUNC_FS_FPATH         ; 何はともあれフルパス取得
0007CFr 2               FIND_FST_RAWPATH:           ; FPATHを多重に呼ぶと狂うので"とりあえず"スキップ
0007CFr 2               @PATH:
0007CFr 2  20 rr rr       JSR PATH2FINFO            ; パスからFINFOを開く
0007D2r 2  90 01          BCC @SKP_PATHERR          ; エラーハンドル
0007D4r 2  60             RTS
0007D5r 2               @SKP_PATHERR:
0007D5r 2  A9 rr A0 rr    loadAY16 FINFO_WK
0007D9r 2  18             CLC
0007DAr 2  60             RTS
0007DBr 2               
0007DBr 2               ; -------------------------------------------------------------------
0007DBr 2               ; BCOS 17                ファイル検索（次）              エラーハンドル
0007DBr 2               ; -------------------------------------------------------------------
0007DBr 2               ; input :AY=前のFINFO、ZR0=ファイル名
0007DBr 2               ; output:AY=FINFO
0007DBr 2               ; -------------------------------------------------------------------
0007DBr 2               FUNC_FS_FIND_NXT:
0007DBr 2  85 rr 84 rr    storeAY16 ZR1                       ; ZR1=与えられたFINFO
0007DFr 2  A0 21          LDY #.SIZEOF(FINFO)-1
0007E1r 2               @DLFWK_LOOP:                          ; 与えられたFINFOをワークエリアにコピーするループ
0007E1r 2  B1 rr          LDA (ZR1),Y
0007E3r 2  99 rr rr       STA FINFO_WK,Y
0007E6r 2  88             DEY
0007E7r 2  10 F8          BPL @DLFWK_LOOP                     ; FINFOコピー終了
0007E9r 2  A9 rr A2 rr    loadreg16 FINFO_WK+FINFO::DIR_CLUS
0007EDr 2  20 rr rr       JSR CLUS2FWK                        ; FINFOの親ディレクトリの現在クラスタをFWKに展開、ただしSEC=0
0007F0r 2  AD rr rr       LDA FINFO_WK+FINFO::DIR_SEC         ; クラスタ内セクタ番号を取得
0007F3r 2  8D rr rr       STA FWK+FCTRL::CUR_SEC              ; 現在セクタ反映
0007F6r 2  20 rr rr       JSR FLASH_REALSEC
0007F9r 2  20 rr rr       JSR RDSEC                           ; セクタ読み取り
0007FCr 2  AD rr rr       LDA FINFO_WK+FINFO::DIR_ENT
0007FFr 2  0A             ASL                                 ; 左に転がしてSDSEEK下位を復元、C=後半フラグ
000800r 2  85 rr          STA ZP_SDSEEK_VEC16
000802r 2  A9 rr          LDA #>SECBF512                      ; 前半のSDSEEK
000804r 2  69 00          ADC #0                              ; C=1つまり後半であれば+1する
000806r 2  85 rr          STA ZP_SDSEEK_VEC16+1               ; SDSEEK上位を復元
000808r 2  20 rr rr       JSR DIR_NEXTMATCH_NEXT_ZR2
00080Br 2  C9 FF          CMP #$FF                            ; もう無いか？
00080Dr 2  18             CLC
00080Er 2  D0 01          BNE @SUCS
000810r 2  38             SEC
000811r 2               @SUCS:
000811r 2  A9 rr A0 rr    loadAY16 FINFO_WK
000815r 2  60             RTS
000816r 2               
000816r 2               FLASH_REALSEC:
000816r 2                 ; リアルセクタ番号にクラスタ内セクタ番号を反映
000816r 2  A9 rr A2 rr    loadreg16 (FWK_REAL_SEC)
00081Ar 2  20 rr rr       JSR AX_DST
00081Dr 2  AD rr rr       LDA FWK+FCTRL::CUR_SEC              ; クラスタ内セクタ番号取得
000820r 2  20 rr rr       JSR L_ADD_BYT
000823r 2  60             RTS
000824r 2               
000824r 2               ; -------------------------------------------------------------------
000824r 2               ; BCOS 6                  ファイルクローズ
000824r 2               ; -------------------------------------------------------------------
000824r 2               ; ファイル記述子をクローズして開放する
000824r 2               ; input:A=fd
000824r 2               ; -------------------------------------------------------------------
000824r 2               FUNC_FS_CLOSE:
000824r 2  38             SEC
000825r 2  E9 08          SBC #NONSTD_FD            ; 標準ファイル分を減算
000827r 2  50 05          BVC @SKP_CLOSESTDF
000829r 2  A9 04          LDA #ERR::FAILED_CLOSE
00082Br 2  4C rr rr       JMP ERR::REPORT
00082Er 2               @SKP_CLOSESTDF:
00082Er 2  0A             ASL                       ; テーブル参照の為x2
00082Fr 2  1A             INC                       ; 上位を見るために+1
000830r 2  AA             TAX
000831r 2  A9 00          LDA #0
000833r 2  9D rr rr       STA FD_TABLE,X
000836r 2  18             CLC
000837r 2  60             RTS
000838r 2               
000838r 2               ; -------------------------------------------------------------------
000838r 2               ; BCOS 10                   パス分類
000838r 2               ; -------------------------------------------------------------------
000838r 2               ; あらゆる種類のパスを解析する
000838r 2               ; ディスクアクセスはしない
000838r 2               ; input : AY=パス先頭
000838r 2               ; output: A=分析結果
000838r 2               ;           bit4:/を含む
000838r 2               ;           bit3:/で終わる
000838r 2               ;           bit2:ルートディレクトリを指す
000838r 2               ;           bit1:ルートから始まる（相対パスでない
000838r 2               ;           bit0:ドライブ文字を含む
000838r 2               ; ZR0,1使用
000838r 2               ; -------------------------------------------------------------------
000838r 2               FUNC_FS_PURSE:
000838r 2  85 rr 84 rr    storeAY16 ZR0
00083Cr 2  64 rr          STZ ZR1         ; 記録保存用
00083Er 2  A0 01          LDY #1
000840r 2  B1 rr          LDA (ZR0),Y     ; :の有無を見る
000842r 2  C9 3A          CMP #':'
000844r 2  D0 13          BNE @NODRIVE
000846r 2  87 rr          SMB0 ZR1        ; ドライブ文字があるフラグを立てる
000848r 2  A9 02          LDA #2          ; ポインタを進め、ドライブなしと同一条件にする
00084Ar 2  18             CLC
00084Br 2  65 rr          ADC ZR0
00084Dr 2  85 rr          STA ZR0
00084Fr 2  A9 00          LDA #0
000851r 2  65 rr          ADC ZR0+1
000853r 2  85 rr          STA ZR0+1
000855r 2  B2 rr          LDA (ZR0)       ; 最初の文字を見る
000857r 2  F0 24          BEQ @ROOTEND    ; 何もないならルートを指している（ドライブ前提
000859r 2               @NODRIVE:
000859r 2  B2 rr          LDA (ZR0)       ; 最初の文字を見る
00085Br 2  C9 2F          CMP #'/'
00085Dr 2  D0 02          BNE @NOTFULL    ; /でないなら相対パス（ドライブ指定なし前提
00085Fr 2  97 rr          SMB1 ZR1        ; ルートから始まるフラグを立てる
000861r 2               @NOTFULL:
000861r 2  A0 FF          LDY #$FF
000863r 2               @LOOP:            ; 最後の文字を調べるループ;おまけに/の有無を調べる
000863r 2  C8             INY
000864r 2  B1 rr          LDA (ZR0),Y
000866r 2  F0 08          BEQ @SKP_LOOP   ; 以下、(ZR0),Yはヌル
000868r 2  C9 2F          CMP #'/'
00086Ar 2  D0 02          BNE @SKP_SET4
00086Cr 2  C7 rr          SMB4 ZR1        ; /を含むフラグを立てる
00086Er 2               @SKP_SET4:
00086Er 2  80 F3          BRA @LOOP
000870r 2               @SKP_LOOP:
000870r 2  88             DEY             ; 最後の文字を指す
000871r 2  B1 rr          LDA (ZR0),Y     ; 最後の文字を読む
000873r 2  C9 2F          CMP #'/'
000875r 2  D0 08          BNE @END        ; 最後が/でなければ終わり
000877r 2  B7 rr          SMB3 ZR1        ; /で終わるフラグを立てる
000879r 2  C0 00          CPY #0          ; /で終わり、しかも一文字だけなら、それはルートを指している
00087Br 2  D0 02          BNE @END
00087Dr 2               @ROOTEND:
00087Dr 2  A7 rr          SMB2 ZR1        ; ルートディレクトリが指されているフラグを立てる
00087Fr 2               @END:
00087Fr 2  A5 rr          LDA ZR1
000881r 2  60             RTS
000882r 2               
000882r 2               ; -------------------------------------------------------------------
000882r 2               ; BCOS 11              カレントディレクトリ変更        エラーハンドル
000882r 2               ; -------------------------------------------------------------------
000882r 2               ; input : AY=パス先頭
000882r 2               ; -------------------------------------------------------------------
000882r 2               FUNC_FS_CHDIR:
000882r 2  20 rr rr       JSR FUNC_FS_FPATH             ; 何はともあれフルパス取得
000885r 2  85 rr 84 rr    storeAY16 ZR3                 ; フルパスをZR3に格納
000889r 2  20 rr rr       JSR FUNC_FS_PURSE             ; ディレクトリである必要性をチェック
00088Cr 2  AF rr 11       BBS2 ZR1,@OK                  ; ルートディレクトリを指すならディレクトリチェック不要
00088Fr 2  A5 rr A4 rr    mem2AY16 ZR3
000893r 2  20 rr rr       JSR FIND_FST_RAWPATH          ; 検索、成功したらC=0
000896r 2  90 01          BCC @SKPERR
000898r 2  60             RTS
000899r 2               @SKPERR:                        ; どうやら存在するらしい
000899r 2  AD rr rr       LDA FINFO_WK+FINFO::ATTR      ; 属性値を取得
00089Cr 2  29 10          AND #DIRATTR_DIRECTORY        ; ディレクトリかをチェック
00089Er 2  F0 11          BEQ @NOTDIR
0008A0r 2               @OK:
0008A0r 2  A9 rr 85 rr    loadmem16 ZR1,CUR_DIR         ; カレントディレクトリを対象に
0008A4r 2  A9 rr 85 rr  
0008A8r 2  A5 rr A4 rr    mem2AY16 ZR3                  ; フルパスをソースに
0008ACr 2  20 rr rr       JSR M_CP_AYS                  ; カレントディレクトリを更新
0008AFr 2  18             CLC
0008B0r 2  60             RTS
0008B1r 2               @NOTDIR:                        ; ERR:ディレクトリ以外に移動しようとした
0008B1r 2  A9 03          LDA #ERR::NOT_DIR
0008B3r 2  4C rr rr       JMP ERR::REPORT
0008B6r 2               
0008B6r 2               ; -------------------------------------------------------------------
0008B6r 2               ; BCOS 12                 絶対パス取得                エラーレポート
0008B6r 2               ; -------------------------------------------------------------------
0008B6r 2               ; input : AY=相対/絶対パス先頭
0008B6r 2               ; output: AY=絶対パス先頭
0008B6r 2               ; FINFOを受け取ったら親ディレクトリを追いかけてフルパスを組み立てることも
0008B6r 2               ;  検討したが面倒すぎて折れた
0008B6r 2               ; -------------------------------------------------------------------
0008B6r 2               FUNC_FS_FPATH:
0008B6r 2  85 rr 84 rr    storeAY16 ZR2                 ; 与えられたパスをZR2に
0008BAr 2  A9 rr 85 rr    loadmem16 ZR1,PATH_WK         ; PATH_WKにカレントディレクトリをコピー
0008BEr 2  A9 rr 85 rr  
0008C2r 2  A9 rr A0 rr    loadAY16 CUR_DIR
0008C6r 2  20 rr rr       JSR M_CP_AYS
0008C9r 2  A9 rr A0 rr    loadAY16 CUR_DIR
0008CDr 2  20 rr rr       JSR M_LEN                     ; Yにカレントディレクトリの長さを与える
0008D0r 2  84 rr          STY ZR3                       ; ZR3に保存
0008D2r 2  A5 rr          LDA ZR2
0008D4r 2  A4 rr          LDY ZR2+1
0008D6r 2  20 rr rr       JSR FUNC_FS_PURSE             ; パスを解析する
0008D9r 2                 ;BBR2 ZR1,@SKP_SETROOT         ; サブディレクトリやファイル（ルートディレクトリを指さない）なら分岐
0008D9r 2  0F rr 11       BBR0 ZR1,@NO_DRV              ; ドライブレターがないなら分岐
0008DCr 2                 ; ドライブが指定された（A:/MIRACOS/）
0008DCr 2  A9 rr 85 rr    loadmem16 ZR1,PATH_WK         ; PATH_WKに与えられたパスをそのままコピー
0008E0r 2  A9 rr 85 rr  
0008E4r 2  A5 rr A4 rr    mem2AY16 ZR2                  ; 与えられたパス
0008E8r 2  20 rr rr       JSR M_CP_AYS
0008EBr 2  80 27          BRA @CLEAR_DOT                ; 最終工程だけは共有
0008EDr 2               @NO_DRV:                        ; 少なくともドライブレターを流用しなければならない
0008EDr 2  9F rr 15       BBS1 ZR1,@ZETTAI              ; 絶対パスなら分岐
0008F0r 2               @SOUTAI:                        ; 相対パスである
0008F0r 2  A9 2F          LDA #'/'
0008F2r 2  A4 rr          LDY ZR3                       ; カレントディレクトリの長さを取得
0008F4r 2  99 rr rr       STA PATH_WK,Y                 ; 最後に区切り文字を設定
0008F7r 2  C8             INY
0008F8r 2  A9 rr A2 rr    loadreg16 PATH_WK
0008FCr 2  20 rr rr       JSR S_ADD_BYT                 ; Yを加算してつぎ足すべき場所を産出
0008FFr 2  85 rr          STA ZR1
000901r 2  86 rr          STX ZR1+1
000903r 2  80 08          BRA @CONCAT
000905r 2               @ZETTAI:                        ; 絶対パスである
000905r 2  A9 rr 85 rr    loadmem16 ZR1,PATH_WK+2       ; ワークエリアのA:より後が対象
000909r 2  A9 rr 85 rr  
00090Dr 2               @CONCAT:                        ; 接合
00090Dr 2  A5 rr A4 rr    mem2AY16 ZR2                  ; 与えられたパスがソース
000911r 2  20 rr rr       JSR M_CP_AYS                  ; 文字列コピーで接合
000914r 2               @CLEAR_DOT:                     ; .を削除する
000914r 2  A2 FF          LDX #$FF
000916r 2               @CLEAR_DOT_LOOP:                ; .を削除するための探索ループ
000916r 2  84 rr          STY ZR0
000918r 2  E8             INX
000919r 2  BD rr rr       LDA PATH_WK,X
00091Cr 2  F0 1F          BEQ @DEL_SLH
00091Er 2  C9 2F          CMP #'/'
000920r 2  D0 F4          BNE @CLEAR_DOT_LOOP           ; /でないならパス
000922r 2  8A             TXA                           ; 前の/としてインデックスを保存
000923r 2  A8             TAY
000924r 2  BD rr rr       LDA PATH_WK+1,X               ; 一つ先読み
000927r 2  C9 2E          CMP #'.'                      ; /.であるか
000929r 2  D0 EB          BNE @CLEAR_DOT_LOOP
00092Br 2  BD rr rr       LDA PATH_WK+2,X               ; さらに先読み
00092Er 2  C9 2E          CMP #'.'                      ; /..であるか
000930r 2  F0 24          BEQ @DELDOTS
000932r 2               @DELDOT:                        ; /.を削除
000932r 2  BD rr rr       LDA PATH_WK+2,X
000935r 2  9D rr rr       STA PATH_WK,X
000938r 2  F0 DA          BEQ @CLEAR_DOT
00093Ar 2  E8             INX
00093Br 2  80 F5          BRA @DELDOT
00093Dr 2               @DEL_SLH:                       ; 最終工程スラッシュ消し
00093Dr 2  A9 rr A0 rr    loadAY16 PATH_WK
000941r 2  20 rr rr       JSR M_LEN                     ; 最終結果の長さを取得
000944r 2  B9 rr rr       LDA PATH_WK-1,Y
000947r 2  C9 2F          CMP #'/'
000949r 2  D0 05          BNE @RET
00094Br 2  A9 00          LDA #0
00094Dr 2  99 rr rr       STA PATH_WK-1,Y
000950r 2               @RET:
000950r 2  A9 rr A0 rr    loadAY16 PATH_WK
000954r 2  18             CLC                           ; キャリークリアで成功を示す
000955r 2  60             RTS
000956r 2               @DELDOTS:                       ; ../を消すループ（飛び地）
000956r 2  A4 rr          LDY ZR0
000958r 2               @DELDOTS_LOOP:
000958r 2  BD rr rr       LDA PATH_WK+3,X
00095Br 2  99 rr rr       STA PATH_WK,Y
00095Er 2  F0 B4          BEQ @CLEAR_DOT                ; 文頭からやり直す
000960r 2  E8             INX
000961r 2  C8             INY
000962r 2  80 F4          BRA @DELDOTS_LOOP
000964r 2               
000964r 2               ; -------------------------------------------------------------------
000964r 2               ; BCOS 5                  ファイルオープン
000964r 2               ; -------------------------------------------------------------------
000964r 2               ; ドライブパスまたはFINFOポインタからファイル記述子をオープンして返す
000964r 2               ; input:AY=ptr
000964r 2               ; output:A=FD, X=ERR
000964r 2               ; -------------------------------------------------------------------
000964r 2               FUNC_FS_OPEN:
000964r 2  85 rr          STA ZR2
000966r 2  84 rr          STY ZR2+1
000968r 2  B2 rr          LDA (ZR2)                 ; 先頭バイトを取得
00096Ar 2  C9 FF          CMP #$FF                  ; FINFOシグネチャ
00096Cr 2  F0 06          BEQ @FINFO
00096Er 2               @PATH:
00096Er 2  20 rr rr       JSR PATH2FINFO_ZR2        ; パスからFINFOを開く
000971r 2  90 01          BCC @SKP_PATHERR          ; エラーハンドル
000973r 2  60             RTS
000974r 2               @SKP_PATHERR:
000974r 2               @FINFO:
000974r 2  20 rr rr       JSR FD_OPEN
000977r 2  90 39          BCC X0RTS                 ; エラーハンドル
000979r 2  A9 05          LDA #ERR::FAILED_OPEN
00097Br 2  4C rr rr       JMP ERR::REPORT           ; ERR:ディレクトリとかでオープンできない
00097Er 2               
00097Er 2               ; -------------------------------------------------------------------
00097Er 2               ;                         リアルセクタ作成
00097Er 2               ; -------------------------------------------------------------------
00097Er 2               ; input   :A=fd
00097Er 2               ; output  :FWKがREAL_SECが展開された状態で作成される
00097Er 2               ; -------------------------------------------------------------------
00097Er 2               LOAD_FWK_MAKEREALSEC:
00097Er 2  20 rr rr       JSR LOAD_FWK                    ; AのFDからFCTRL構造体をロード
000981r 2  A9 rr A2 rr    loadreg16 FWK_REAL_SEC          ; FWKのリアルセクタのポインタを
000985r 2  20 rr rr       JSR AX_DST                      ;   書き込み先にして
000988r 2  A9 rr A2 rr    loadreg16 FWK+FCTRL::CUR_CLUS   ; 現在クラスタのポインタを
00098Cr 2  20 rr rr       JSR CLUS2SEC_AXS                ;   ソースにしてクラスタtoセクタ変換
00098Fr 2  AD rr rr       LDA FWK+FCTRL::CUR_SEC          ; 現在セクタ
000992r 2  20 rr rr       JSR L_ADD_BYT                   ; リアルセクタに現在セクタを加算
000995r 2  60             RTS
000996r 2               
000996r 2               ; -------------------------------------------------------------------
000996r 2               ;                       ファイル記述子操作関連
000996r 2               ; -------------------------------------------------------------------
000996r 2               
000996r 2               FD_OPEN:
000996r 2                 ; FINFOからファイル記述子をオープン
000996r 2                 ; output A=FD, X=EC
000996r 2  AD rr rr       LDA FINFO_WK+FINFO::ATTR      ; 属性値を取得
000999r 2  29 10          AND #DIRATTR_DIRECTORY        ; ディレクトリかをチェック ディレクトリなら非ゼロ
00099Br 2  F0 02          BEQ @SKP_DIRERR
00099Dr 2  38             SEC                       ; ディレクトリを開こうとしたエラー
00099Er 2  60             RTS
00099Fr 2               @SKP_DIRERR:                ; 以下、ディレクトリではない
00099Fr 2  20 rr rr       JSR INTOPEN_FILE          ; FINFOからファイルを開く
0009A2r 2  20 rr rr       JSR FINFO2SIZ             ; サイズ情報も展開
0009A5r 2  20 rr rr       JSR GET_NEXTFD            ; ファイル記述子を取得
0009A8r 2  48             PHA
0009A9r 2  20 rr rr       JSR FCTRL_ALLOC           ; ファイル記述子に実際の構造体を割り当て
0009ACr 2  68             PLA
0009ADr 2  48             PHA
0009AEr 2  20 rr rr       JSR PUT_FWK               ; ワークエリアの内容を書き込む
0009B1r 2  68             PLA
0009B2r 2               X0RTS:
0009B2r 2  18             CLC
0009B3r 2  60             RTS
0009B4r 2               
0009B4r 2               FCTRL_ALLOC:
0009B4r 2                 ; FDにFCTRL領域を割り当てる…インチキで
0009B4r 2                 ; input:A=FD
0009B4r 2  38             SEC
0009B5r 2  E9 08          SBC #NONSTD_FD          ; 非標準番号
0009B7r 2  AA             TAX                     ; 下位作成のためXに移動
0009B8r 2  0A             ASL                     ; 非標準番号*2でテーブルの頭
0009B9r 2  A8             TAY                     ; Yに保存
0009BAr 2  A9 rr 85 rr    loadmem16 ZR0,FD_TABLE  ; 非標準FDテーブルへのポインタを作成
0009BEr 2  A9 rr 85 rr  
0009C2r 2  A9 rr          LDA #<FCTRL_RES         ; オフセット下位をロード
0009C4r 2               @OFST_LOOP:
0009C4r 2  E0 00          CPX #0
0009C6r 2  F0 06          BEQ @OFST_DONE          ; オフセット完成
0009C8r 2  18             CLC
0009C9r 2  69 12          ADC #.SIZEOF(FCTRL)     ; 構造体サイズを加算
0009CBr 2  CA             DEX
0009CCr 2  80 F6          BRA @OFST_LOOP
0009CEr 2               @OFST_DONE:               ; 下位が完成
0009CEr 2  91 rr          STA (ZR0),Y             ; テーブルに保存
0009D0r 2  C8             INY
0009D1r 2  A9 rr          LDA #>FCTRL_RES
0009D3r 2  91 rr          STA (ZR0),Y             ; 上位をテーブルに保存
0009D5r 2  60             RTS
0009D6r 2               
0009D6r 2               GET_NEXTFD:
0009D6r 2                 ; 次に空いたFDを取得
0009D6r 2  A9 rr 85 rr    loadmem16 ZR0,FD_TABLE  ; テーブル読み取り
0009DAr 2  A9 rr 85 rr  
0009DEr 2  A0 01          LDY #1
0009E0r 2               @TLOOP:
0009E0r 2  B1 rr          LDA (ZR0),Y             ;NOTE:間接参照する利益がないのでは？
0009E2r 2  F0 04          BEQ @ZERO
0009E4r 2  C8             INY
0009E5r 2  C8             INY
0009E6r 2  80 F8          BRA @TLOOP
0009E8r 2               @ZERO:
0009E8r 2  88             DEY                     ; 下位桁に合わせる
0009E9r 2  98             TYA
0009EAr 2  18             CLC
0009EBr 2  69 08          ADC #NONSTD_FD          ; 非標準ファイル
0009EDr 2  60             RTS
0009EEr 2               
0009EEr 2               FD2FCTRL:
0009EEr 2                 ; ファイル記述子をFCTRL先頭AXに変換
0009EEr 2  38             SEC
0009EFr 2  E9 08          SBC #NONSTD_FD          ; 非標準番号
0009F1r 2  0A             ASL                     ; x2
0009F2r 2  A8             TAY
0009F3r 2  A9 rr 85 rr    loadmem16 ZR0,FD_TABLE  ; 非標準FDテーブルへのポインタを作成
0009F7r 2  A9 rr 85 rr  
0009FBr 2  C8             INY
0009FCr 2  B1 rr          LDA (ZR0),Y
0009FEr 2  AA             TAX
0009FFr 2  88             DEY
000A00r 2  B1 rr          LDA (ZR0),Y
000A02r 2  60             RTS
000A03r 2               
000A03r 2               
000A03r 1                 .ENDPROC
000A03r 1                 .PROC GCHR
000A03r 1                   .INCLUDE "gcon/gchr.s"
000A03r 2               ; 2色モードChDzによるキャラクタ表示
000A03r 2               .INCLUDE "FXT65.inc"
000A03r 3               ; FxT65のハードウェア構成を定義する
000A03r 3               
000A03r 3               .PC02 ; CMOS命令を許可
000A03r 3               
000A03r 3               RAMBASE = $0000
000A03r 3               UARTBASE = $E000
000A03r 3               VIABASE = $E200
000A03r 3               YMZBASE = $E400
000A03r 3               CRTCBASE = $E600
000A03r 3               ROMBASE = $F000
000A03r 3               
000A03r 3               ; UART
000A03r 3               .PROC UART
000A03r 3                 RX = UARTBASE
000A03r 3                 TX = UARTBASE
000A03r 3                 STATUS = UARTBASE+1
000A03r 3                 COMMAND = UARTBASE+2
000A03r 3                 CONTROL = UARTBASE+3
000A03r 3                 .PROC CMD
000A03r 3                   ; PMC1/PMC0/PME/REM/TIC1/TIC0/IRD/DTR
000A03r 3                   ; 全てゼロだと「エコーオフ、RTSオフ、割り込み有効、DTRオフ」
000A03r 3                   RTS_ON =    %00001000
000A03r 3                   ECHO_ON =   %00010000
000A03r 3                   RIRQ_OFF =  %00000010
000A03r 3                   DTR_ON =    %00000001
000A03r 3                 .ENDPROC
000A03r 3                 XON = $11
000A03r 3                 XOFF = $13
000A03r 3               .ENDPROC
000A03r 3               
000A03r 3               ; VIA
000A03r 3               .PROC VIA
000A03r 3                 PORTB = VIABASE
000A03r 3                 PORTA = VIABASE+1
000A03r 3                 DDRB = VIABASE+2
000A03r 3                 DDRA = VIABASE+3
000A03r 3                 T1CL = VIABASE+4
000A03r 3                 T1CH = VIABASE+5
000A03r 3                 T1LL = VIABASE+6
000A03r 3                 T1LH = VIABASE+7
000A03r 3                 SR = VIABASE+$A
000A03r 3                 ACR = VIABASE+$B
000A03r 3                 PCR = VIABASE+$C
000A03r 3                 IFR = VIABASE+$D
000A03r 3                 IER = VIABASE+$E
000A03r 3                 IFR_IRQ = %10000000
000A03r 3                 IER_SET = %10000000
000A03r 3                 IFR_T1  = %01000000
000A03r 3                 IFR_T2  = %00100000
000A03r 3                 IFR_CB1 = %00010000
000A03r 3                 IFR_CB2 = %00001000
000A03r 3                 IFR_SR  = %00000100
000A03r 3                 IFR_CA1 = %00000010
000A03r 3                 IFR_CA2 = %00000001
000A03r 3                 ; 新式
000A03r 3                 SPI_REG    = PORTB
000A03r 3                 SPI_DDR    = DDRB
000A03r 3                 SPI_INOUT  = %10000000  ; 1=in, 0=out
000A03r 3                 SPI_CS0    = %01000000
000A03r 3                 PS2_REG    = PORTB
000A03r 3                 PS2_DDR    = DDRB
000A03r 3                 PS2_CLK    = %00100000
000A03r 3                 PS2_DAT    = %00010000
000A03r 3                 PAD_REG    = PORTB
000A03r 3                 PAD_DDR    = DDRB
000A03r 3                 PAD_CLK    = %00000100
000A03r 3                 PAD_PTS    = %00000010
000A03r 3                 PAD_DAT    = %00000001
000A03r 3               .ENDPROC
000A03r 3               
000A03r 3               ; ChDz
000A03r 3               .PROC CRTC
000A03r 3                 CFG = CRTCBASE+$1   ; コンフィグ
000A03r 3                                         ;   MD0 MD1 MD2 MD3 - - - WCUE
000A03r 3                                         ;   MD : 色モード選択（各フレーム）
000A03r 3                                         ;   WCUE  : 書き込みカウントアップ有効化
000A03r 3               
000A03r 3                 VMAH = CRTCBASE+$2  ; VRAM書き込みアドレス下位
000A03r 3                                         ;   - 6 5 4 3 2 1 0
000A03r 3               
000A03r 3                 VMAV = CRTCBASE+$3  ; VRAM書き込みアドレス上位
000A03r 3                                     ;   7 6 5 4 3 2 1 0
000A03r 3               
000A03r 3                 WDBF = CRTCBASE+$4  ; 書き込みデータ
000A03r 3               
000A03r 3                 RF  = CRTCBASE+$5   ; 出力フレーム選択
000A03r 3                                     ;   (0) 1 0 | (1) 1 0 | (2) 1 0 | (3) 1 0
000A03r 3               
000A03r 3                 WF  = CRTCBASE+$6   ; 書き込みフレーム選択
000A03r 3                                     ;   - - - - - - WF1 WF0
000A03r 3               
000A03r 3                 TCP  = CRTCBASE+$7  ; 2色モード色選択
000A03r 3                                         ;   (0) 3 2 1 0 | (1) 3 2 1 0
000A03r 3               .ENDPROC
000A03r 3               
000A03r 3               ; YMZ
000A03r 3               .PROC YMZ
000A03r 3                 ADDR = YMZBASE
000A03r 3                 DATA = YMZBASE+1
000A03r 3                 ; IR:Internal Address
000A03r 3                 IA_FRQ = $00        ; 各チャンネル周波数
000A03r 3                 IA_NOISE_FRQ = $06  ; ノイズ音周波数
000A03r 3                 IA_MIX = $07        ; ミキサ設定
000A03r 3                 IA_VOL = $08        ; 各チャンネル音量
000A03r 3                 IA_EVLP_FRQ = $0B   ; エンベロープ周波数
000A03r 3                 IA_EVLP_SHAPE = $0D ; エンベロープ形状
000A03r 3               .ENDPROC
000A03r 3               
000A03r 3               
000A03r 2               
000A03r 2               ; -------------------------------------------------------------------
000A03r 2               ; BCOS 8             テキスト画面色操作
000A03r 2               ; -------------------------------------------------------------------
000A03r 2               ; input   : A = 動作選択
000A03r 2               ;               $0 : 文字色を取得
000A03r 2               ;               $1 : 背景色を取得
000A03r 2               ;               $2 : 文字色を設定
000A03r 2               ;               $3 : 背景色を設定
000A03r 2               ;           Y = 色データ（下位ニブル有効、$2,$3動作時のみ
000A03r 2               ; output  : A = 取得した色データ
000A03r 2               ; 二色モードに限らず画面の状態は勝手に叩いていいのだが、
000A03r 2               ; GCHRモジュールを使うならカーネルの支配下にないといけない
000A03r 2               ; -------------------------------------------------------------------
000A03r 2               FUNC_GCHR_COL:
000A03r 2  89 02          BIT #%00000010  ; bit1が立ってたら設定、でなければ取得
000A05r 2  D0 0B          BNE @SETTING
000A07r 2               @GETTING:
000A07r 2  6A             ROR             ; bit0が立ってたら背景色、でなければ文字色
000A08r 2  B0 04          BCS @GETBACK
000A0Ar 2               @GETMAIN:
000A0Ar 2  AD rr rr       LDA COL_MAIN
000A0Dr 2  60             RTS
000A0Er 2               @GETBACK:
000A0Er 2  AD rr rr       LDA COL_BACK
000A11r 2  60             RTS
000A12r 2               @SETTING:
000A12r 2  6A             ROR             ; bit0が立ってたら背景色、でなければ文字色
000A13r 2  B0 05          BCS @SETBACK
000A15r 2               @SETMAIN:
000A15r 2  8C rr rr       STY COL_MAIN
000A18r 2  80 03          BRA SET_TCP
000A1Ar 2               @SETBACK:
000A1Ar 2  8C rr rr       STY COL_BACK
000A1Dr 2               SET_TCP:
000A1Dr 2                 ; 2色パレットを変数から反映する
000A1Dr 2  AD rr rr       LDA COL_BACK
000A20r 2  0A             ASL
000A21r 2  0A             ASL
000A22r 2  0A             ASL
000A23r 2  0A             ASL
000A24r 2  85 rr          STA ZP_X
000A26r 2  AD rr rr       LDA COL_MAIN
000A29r 2  29 0F          AND #%00001111
000A2Br 2  05 rr          ORA ZP_X
000A2Dr 2  8D 07 E6       STA CRTC::TCP
000A30r 2  60             RTS
000A31r 2               
000A31r 2               INIT:
000A31r 2                 ; 2色モードの色を白黒に初期化
000A31r 2                 ;LDA #$00                  ; 黒
000A31r 2  A9 44          LDA #$44                  ; 青
000A33r 2  8D rr rr       STA COL_BACK              ; 背景色に設定
000A36r 2                 ;LDA #$03                  ; 緑
000A36r 2  A9 FF          LDA #$FF                  ; 白
000A38r 2  8D rr rr       STA COL_MAIN              ; 文字色に設定
000A3Br 2  20 rr rr       JSR CLEAR_TXTVRAM         ; TRAMの空白埋め
000A3Er 2               ENTER_TXTMODE:
000A3Er 2  9C 06 E6       STZ CRTC::WF              ; f0に対する書き込み
000A41r 2  20 rr rr       JSR SET_TCP
000A44r 2  20 rr rr       JSR DRAW_ALLLINE          ; 全体描画
000A47r 2  A9 F2          LDA #%11110010            ; 全内部行を2色モード、書き込みカウントアップ無効、2色モード座標
000A49r 2  8D 01 E6       STA CRTC::CFG
000A4Cr 2  9C 05 E6       STZ CRTC::RF              ; f0を表示
000A4Fr 2  60             RTS
000A50r 2               
000A50r 2               DRAW_ALLLINE:
000A50r 2                 ; TRAMから全行を反映する
000A50r 2  A9 rr 85 rr    loadmem16 ZP_TRAM_VEC16,TXTVRAM768
000A54r 2  A9 rr 85 rr  
000A58r 2  A0 00          LDY #0
000A5Ar 2  A2 06          LDX #6
000A5Cr 2               DRAW_ALLLINE_LOOP:
000A5Cr 2  DA             PHX
000A5Dr 2  20 rr rr       JSR DRAW_LINE_RAW
000A60r 2  20 rr rr       JSR DRAW_LINE_RAW
000A63r 2  20 rr rr       JSR DRAW_LINE_RAW
000A66r 2  20 rr rr       JSR DRAW_LINE_RAW
000A69r 2  FA             PLX
000A6Ar 2  CA             DEX
000A6Br 2  D0 EF          BNE DRAW_ALLLINE_LOOP
000A6Dr 2  60             RTS
000A6Er 2               
000A6Er 2               DRAW_LINE:
000A6Er 2                 ; Yで指定された行を描画する
000A6Er 2  98             TYA                       ; 行数をAに
000A6Fr 2  64 rr          STZ ZP_Y                  ; シフト先をクリア
000A71r 2  0A             ASL                       ; 行数を右にシフト
000A72r 2  66 rr          ROR ZP_Y                  ; おこぼれをインデックスとするx3
000A74r 2  0A             ASL
000A75r 2  66 rr          ROR ZP_Y
000A77r 2  0A             ASL
000A78r 2  66 rr          ROR ZP_Y                  ; A:ページ数0~2 ZP_Y:ページ内インデックス行頭
000A7Ar 2  18             CLC
000A7Br 2  69 rr          ADC #>TXTVRAM768          ; TXTVRAM上位に加算
000A7Dr 2  85 rr          STA ZP_TRAM_VEC16+1       ; ページ数登録
000A7Fr 2  A4 rr          LDY ZP_Y                  ; インデックスをYにロード
000A81r 2               DRAW_LINE_RAW:
000A81r 2                 ; 行を描画する
000A81r 2                 ; TRAM_VEC16を上位だけ設定しておき、そのなかのインデックスもYで持っておく
000A81r 2                 ; 連続実行すると次の行を描画できる
000A81r 2  98             TYA                       ; インデックスをAに
000A82r 2  29 E0          AND #%11100000            ; 行として意味のある部分を抽出
000A84r 2  AA             TAX                       ; しばらく使わないXに保存
000A85r 2                 ; HVの初期化
000A85r 2  64 rr          STZ ZP_X
000A87r 2                 ; 0~2のページオフセットを取得
000A87r 2  A5 rr          LDA ZP_TRAM_VEC16+1
000A89r 2  38             SEC
000A8Ar 2  E9 rr          SBC #>TXTVRAM768
000A8Cr 2  85 rr          STA ZP_Y
000A8Er 2                 ; インデックスの垂直部分3bitを挿入
000A8Er 2  98             TYA
000A8Fr 2  0A             ASL
000A90r 2  26 rr          ROL ZP_Y
000A92r 2  0A             ASL
000A93r 2  26 rr          ROL ZP_Y
000A95r 2  0A             ASL
000A96r 2  26 rr          ROL ZP_Y
000A98r 2                 ; 8倍
000A98r 2  A5 rr          LDA ZP_Y
000A9Ar 2  0A             ASL
000A9Br 2  0A             ASL
000A9Cr 2  0A             ASL
000A9Dr 2  85 rr          STA ZP_Y
000A9Fr 2                 ; --- フォント参照ベクタ作成
000A9Fr 2               DRAW_TXT_LOOP:
000A9Fr 2  A9 rr          LDA #>FONT2048
000AA1r 2  85 rr          STA ZP_FONT_VEC16+1
000AA3r 2                 ; フォントあぶれ初期化
000AA3r 2  A0 00          LDY #0
000AA5r 2  84 rr          STY ZP_FONT_SR
000AA7r 2                 ; アスキーコード読み取り
000AA7r 2  8A             TXA                       ; 保存していたページ内行を復帰してインデックスに
000AA8r 2  A8             TAY
000AA9r 2  B1 rr          LDA (ZP_TRAM_VEC16),Y
000AABr 2  0A             ASL                       ; 8倍してあぶれた分をアドレス上位に加算
000AACr 2  26 rr          ROL ZP_FONT_SR
000AAEr 2  0A             ASL
000AAFr 2  26 rr          ROL ZP_FONT_SR
000AB1r 2  0A             ASL
000AB2r 2  26 rr          ROL ZP_FONT_SR
000AB4r 2  85 rr          STA ZP_FONT_VEC16
000AB6r 2  A5 rr          LDA ZP_FONT_SR
000AB8r 2  65 rr          ADC ZP_FONT_VEC16+1       ; キャリーは最後のROLにより0
000ABAr 2  85 rr          STA ZP_FONT_VEC16+1
000ABCr 2                 ; --- フォント書き込み
000ABCr 2                 ; カーソルセット
000ABCr 2  A5 rr          LDA ZP_X
000ABEr 2  8D 02 E6       STA CRTC::VMAH
000AC1r 2                 ; 一文字表示ループ
000AC1r 2  A0 00          LDY #0
000AC3r 2               CHAR_LOOP:
000AC3r 2  A5 rr          LDA ZP_Y
000AC5r 2  8D 03 E6       STA CRTC::VMAV
000AC8r 2                 ; フォントデータ読み取り
000AC8r 2  B1 rr          LDA (ZP_FONT_VEC16),Y
000ACAr 2  8D 04 E6       STA CRTC::WDBF
000ACDr 2  E6 rr          INC ZP_Y
000ACFr 2  C8             INY
000AD0r 2  C0 08          CPY #8
000AD2r 2  D0 EF          BNE CHAR_LOOP
000AD4r 2                 ; --- 次の文字へアドレス類を更新
000AD4r 2                 ; テキストVRAM読み取りベクタ
000AD4r 2  E8             INX
000AD5r 2  D0 02          BNE SKP_TXTNP
000AD7r 2  E6 rr          INC ZP_TRAM_VEC16+1
000AD9r 2               SKP_TXTNP:
000AD9r 2                 ; H
000AD9r 2  E6 rr          INC ZP_X
000ADBr 2  A5 rr          LDA ZP_X
000ADDr 2  29 1F          AND #%00011111  ; 左端に戻るたびゼロ
000ADFr 2  D0 03          BNE SKP_EXT_DRAWLINE
000AE1r 2  8A             TXA
000AE2r 2  A8             TAY
000AE3r 2  60             RTS
000AE4r 2               SKP_EXT_DRAWLINE:
000AE4r 2                 ; V
000AE4r 2  38             SEC
000AE5r 2  A5 rr          LDA ZP_Y
000AE7r 2  E9 08          SBC #8
000AE9r 2  85 rr          STA ZP_Y
000AEBr 2  80 B2          BRA DRAW_TXT_LOOP
000AEDr 2               
000AEDr 2               CLEAR_TXTVRAM:
000AEDr 2  A9 rr 85 rr    loadmem16 ZR0,TXTVRAM768
000AF1r 2  A9 rr 85 rr  
000AF5r 2  A9 20          LDA #' '
000AF7r 2  A0 00          LDY #0
000AF9r 2  A2 03          LDX #3
000AFBr 2               CLEAR_TXTVRAM_LOOP:
000AFBr 2  91 rr          STA (ZR0),Y
000AFDr 2  C8             INY
000AFEr 2  D0 FB          BNE CLEAR_TXTVRAM_LOOP
000B00r 2  E6 rr          INC ZR0+1
000B02r 2  CA             DEX
000B03r 2  D0 F6          BNE CLEAR_TXTVRAM_LOOP
000B05r 2  60             RTS
000B06r 2               
000B06r 2               
000B06r 1                 .ENDPROC
000B06r 1                 .PROC GCON
000B06r 1                   .INCLUDE "gcon/gcon.s"
000B06r 2               ; 2色モードChDzによるコンソールモジュール
000B06r 2               .INCLUDE "FXT65.inc"
000B06r 3               ; FxT65のハードウェア構成を定義する
000B06r 3               
000B06r 3               .PC02 ; CMOS命令を許可
000B06r 3               
000B06r 3               RAMBASE = $0000
000B06r 3               UARTBASE = $E000
000B06r 3               VIABASE = $E200
000B06r 3               YMZBASE = $E400
000B06r 3               CRTCBASE = $E600
000B06r 3               ROMBASE = $F000
000B06r 3               
000B06r 3               ; UART
000B06r 3               .PROC UART
000B06r 3                 RX = UARTBASE
000B06r 3                 TX = UARTBASE
000B06r 3                 STATUS = UARTBASE+1
000B06r 3                 COMMAND = UARTBASE+2
000B06r 3                 CONTROL = UARTBASE+3
000B06r 3                 .PROC CMD
000B06r 3                   ; PMC1/PMC0/PME/REM/TIC1/TIC0/IRD/DTR
000B06r 3                   ; 全てゼロだと「エコーオフ、RTSオフ、割り込み有効、DTRオフ」
000B06r 3                   RTS_ON =    %00001000
000B06r 3                   ECHO_ON =   %00010000
000B06r 3                   RIRQ_OFF =  %00000010
000B06r 3                   DTR_ON =    %00000001
000B06r 3                 .ENDPROC
000B06r 3                 XON = $11
000B06r 3                 XOFF = $13
000B06r 3               .ENDPROC
000B06r 3               
000B06r 3               ; VIA
000B06r 3               .PROC VIA
000B06r 3                 PORTB = VIABASE
000B06r 3                 PORTA = VIABASE+1
000B06r 3                 DDRB = VIABASE+2
000B06r 3                 DDRA = VIABASE+3
000B06r 3                 T1CL = VIABASE+4
000B06r 3                 T1CH = VIABASE+5
000B06r 3                 T1LL = VIABASE+6
000B06r 3                 T1LH = VIABASE+7
000B06r 3                 SR = VIABASE+$A
000B06r 3                 ACR = VIABASE+$B
000B06r 3                 PCR = VIABASE+$C
000B06r 3                 IFR = VIABASE+$D
000B06r 3                 IER = VIABASE+$E
000B06r 3                 IFR_IRQ = %10000000
000B06r 3                 IER_SET = %10000000
000B06r 3                 IFR_T1  = %01000000
000B06r 3                 IFR_T2  = %00100000
000B06r 3                 IFR_CB1 = %00010000
000B06r 3                 IFR_CB2 = %00001000
000B06r 3                 IFR_SR  = %00000100
000B06r 3                 IFR_CA1 = %00000010
000B06r 3                 IFR_CA2 = %00000001
000B06r 3                 ; 新式
000B06r 3                 SPI_REG    = PORTB
000B06r 3                 SPI_DDR    = DDRB
000B06r 3                 SPI_INOUT  = %10000000  ; 1=in, 0=out
000B06r 3                 SPI_CS0    = %01000000
000B06r 3                 PS2_REG    = PORTB
000B06r 3                 PS2_DDR    = DDRB
000B06r 3                 PS2_CLK    = %00100000
000B06r 3                 PS2_DAT    = %00010000
000B06r 3                 PAD_REG    = PORTB
000B06r 3                 PAD_DDR    = DDRB
000B06r 3                 PAD_CLK    = %00000100
000B06r 3                 PAD_PTS    = %00000010
000B06r 3                 PAD_DAT    = %00000001
000B06r 3               .ENDPROC
000B06r 3               
000B06r 3               ; ChDz
000B06r 3               .PROC CRTC
000B06r 3                 CFG = CRTCBASE+$1   ; コンフィグ
000B06r 3                                         ;   MD0 MD1 MD2 MD3 - - - WCUE
000B06r 3                                         ;   MD : 色モード選択（各フレーム）
000B06r 3                                         ;   WCUE  : 書き込みカウントアップ有効化
000B06r 3               
000B06r 3                 VMAH = CRTCBASE+$2  ; VRAM書き込みアドレス下位
000B06r 3                                         ;   - 6 5 4 3 2 1 0
000B06r 3               
000B06r 3                 VMAV = CRTCBASE+$3  ; VRAM書き込みアドレス上位
000B06r 3                                     ;   7 6 5 4 3 2 1 0
000B06r 3               
000B06r 3                 WDBF = CRTCBASE+$4  ; 書き込みデータ
000B06r 3               
000B06r 3                 RF  = CRTCBASE+$5   ; 出力フレーム選択
000B06r 3                                     ;   (0) 1 0 | (1) 1 0 | (2) 1 0 | (3) 1 0
000B06r 3               
000B06r 3                 WF  = CRTCBASE+$6   ; 書き込みフレーム選択
000B06r 3                                     ;   - - - - - - WF1 WF0
000B06r 3               
000B06r 3                 TCP  = CRTCBASE+$7  ; 2色モード色選択
000B06r 3                                         ;   (0) 3 2 1 0 | (1) 3 2 1 0
000B06r 3               .ENDPROC
000B06r 3               
000B06r 3               ; YMZ
000B06r 3               .PROC YMZ
000B06r 3                 ADDR = YMZBASE
000B06r 3                 DATA = YMZBASE+1
000B06r 3                 ; IR:Internal Address
000B06r 3                 IA_FRQ = $00        ; 各チャンネル周波数
000B06r 3                 IA_NOISE_FRQ = $06  ; ノイズ音周波数
000B06r 3                 IA_MIX = $07        ; ミキサ設定
000B06r 3                 IA_VOL = $08        ; 各チャンネル音量
000B06r 3                 IA_EVLP_FRQ = $0B   ; エンベロープ周波数
000B06r 3                 IA_EVLP_SHAPE = $0D ; エンベロープ形状
000B06r 3               .ENDPROC
000B06r 3               
000B06r 3               
000B06r 2               
000B06r 2  41 3A 2F 4D  PATH_FONT_DEFAULT:  .ASCIIZ "A:/MCOS/DAT/MIRAFONT.FNT"
000B0Ar 2  43 4F 53 2F  
000B0Er 2  44 41 54 2F  
000B1Fr 2               
000B1Fr 2               INIT:
000B1Fr 2                 ; コンソール画面の初期化
000B1Fr 2                 ; フォントロードで使うのでファイルシステムモジュールが起動していること
000B1Fr 2  A9 rr A0 rr    loadAY16 PATH_FONT_DEFAULT
000B23r 2  20 rr rr       JSR FS::FUNC_FS_OPEN        ; フォントファイルをオープン NOTE:ロードできたかを見るBP
000B26r 2  85 rr          STA ZR1
000B28r 2  48             PHA
000B29r 2  A9 rr 85 rr    loadmem16 ZR0,FONT2048      ; 書き込み先
000B2Dr 2  A9 rr 85 rr  
000B31r 2  A9 00 A0 08    loadAY16  2048              ; 長さ
000B35r 2  20 rr rr       JSR FS::FUNC_FS_READ_BYTS   ; ロード NOTE:ロードできたかを見るBP
000B38r 2  20 rr rr       JSR GCHR::INIT
000B3Br 2  68             PLA                         ; FD復帰
000B3Cr 2  20 rr rr       JSR FS::FUNC_FS_CLOSE       ; クローズ
000B3Fr 2  9C rr rr       STZ CURSOR_X
000B42r 2  A9 17          LDA #23                     ; 最下行
000B44r 2  8D rr rr       STA CURSOR_Y
000B47r 2  60             RTS
000B48r 2               
000B48r 2               ;TEST:
000B48r 2               ;@LOOP:
000B48r 2               ;  JSR FUNC_CON_IN_CHR
000B48r 2               ;  ;JSR SCROLL_DOWN
000B48r 2               ;  BRA @LOOP
000B48r 2               
000B48r 2               PUTC:
000B48r 2                 ; コンソールに一文字表示する
000B48r 2                 ; --- テキスト書き込みベクタ作成
000B48r 2  C9 0A          CMP #$A
000B4Ar 2  D0 07          BNE @SKP_LF           ; 改行なら改行する
000B4Cr 2  20 rr rr       JSR SCROLL_DOWN
000B4Fr 2  9C rr rr       STZ CURSOR_X
000B52r 2  60             RTS
000B53r 2               @SKP_LF:
000B53r 2  C9 08          CMP #$8
000B55r 2  D0 0C          BNE @SKP_BS           ; バックスペースなら1文字消す
000B57r 2  CE rr rr       DEC CURSOR_X          ; カーソルを戻す
000B5Ar 2  A9 20          LDA #' '              ; 一つ戻ってスペースを書き込む
000B5Cr 2  20 rr rr       JSR PUTC
000B5Fr 2  CE rr rr       DEC CURSOR_X          ; 再びカーソルを戻す
000B62r 2  60             RTS
000B63r 2               @SKP_BS:
000B63r 2  48             PHA
000B64r 2  AD rr rr       LDA CURSOR_Y
000B67r 2  C9 18          CMP #24
000B69r 2  D0 09          BNE @SKP_OVER
000B6Br 2  20 rr rr       JSR SCROLL_DOWN
000B6Er 2  9C rr rr       STZ CURSOR_X
000B71r 2  CE rr rr       DEC CURSOR_Y
000B74r 2               @SKP_OVER:
000B74r 2  64 rr          STZ ZP_FONT_SR
000B76r 2  64 rr          STZ ZP_TRAM_VEC16
000B78r 2  AD rr rr       LDA CURSOR_Y
000B7Br 2  4A             LSR
000B7Cr 2  66 rr          ROR ZP_FONT_SR
000B7Er 2  4A             LSR
000B7Fr 2  66 rr          ROR ZP_FONT_SR
000B81r 2  4A             LSR
000B82r 2  66 rr          ROR ZP_FONT_SR
000B84r 2  69 rr          ADC #>TXTVRAM768
000B86r 2  85 rr          STA ZP_TRAM_VEC16+1
000B88r 2  AD rr rr       LDA CURSOR_X
000B8Br 2  05 rr          ORA ZP_FONT_SR
000B8Dr 2  A8             TAY
000B8Er 2                 ; --- 書き込み
000B8Er 2  68             PLA
000B8Fr 2               SKP_EXT_PUTC:
000B8Fr 2  C9 0A          CMP #$A
000B91r 2  D0 07          BNE SKP_NL
000B93r 2  A9 00          LDA #0
000B95r 2  8D rr rr       STA CURSOR_X
000B98r 2  F0 12          BEQ EDIT_NL
000B9Ar 2               SKP_NL:
000B9Ar 2  91 rr          STA (ZP_TRAM_VEC16),Y
000B9Cr 2  20 rr rr       JSR GCHR::DRAW_LINE_RAW
000B9Fr 2                 ; --- カーソル更新
000B9Fr 2  AD rr rr       LDA CURSOR_X
000BA2r 2  18             CLC
000BA3r 2  69 01          ADC #1
000BA5r 2  29 1F          AND #%00011111
000BA7r 2  8D rr rr       STA CURSOR_X
000BAAr 2  D0 03          BNE SKP_INC_EDY
000BACr 2               EDIT_NL:
000BACr 2  EE rr rr       INC CURSOR_Y
000BAFr 2               SKP_INC_EDY:
000BAFr 2  60             RTS
000BB0r 2               
000BB0r 2               SCROLL_DOWN:
000BB0r 2                 ; 1行スクロールする
000BB0r 2                 ; カメラが下がるイメージからの命名
000BB0r 2  A9 rr 85 rr    loadmem16 ZP_TRAM_VEC16,TXTVRAM768  ; 原点
000BB4r 2  A9 rr 85 rr  
000BB8r 2  A2 17          LDX #23
000BBAr 2               @LOOP:
000BBAr 2  A9 20          LDA #32                             ; 1行下を指す読み取りインデックス
000BBCr 2  85 rr          STA ZP_X
000BBEr 2  64 rr          STZ ZP_Y                            ; 書き込み先インデックス
000BC0r 2               @LINELOOP:
000BC0r 2  A4 rr          LDY ZP_X
000BC2r 2  B1 rr          LDA (ZP_TRAM_VEC16),Y
000BC4r 2  A4 rr          LDY ZP_Y
000BC6r 2  91 rr          STA (ZP_TRAM_VEC16),Y
000BC8r 2  E6 rr          INC ZP_Y
000BCAr 2  E6 rr          INC ZP_X                            ; 先を行くこれを監視
000BCCr 2  A5 rr          LDA ZP_X
000BCEr 2  29 1F          AND #31
000BD0r 2  D0 EE          BNE @LINELOOP                       ; ひっくり返るまではループ
000BD2r 2  A9 20          LDA #32
000BD4r 2  18             CLC
000BD5r 2  65 rr          ADC ZP_TRAM_VEC16                   ; 最後にページを一つ進める
000BD7r 2  85 rr          STA ZP_TRAM_VEC16
000BD9r 2  A9 00          LDA #0
000BDBr 2  65 rr          ADC ZP_TRAM_VEC16+1                 ; 最後にページを一つ進める
000BDDr 2  85 rr          STA ZP_TRAM_VEC16+1
000BDFr 2  CA             DEX
000BE0r 2  D0 D8          BNE @LOOP
000BE2r 2  A0 00          LDY #0
000BE4r 2  A9 20          LDA #' '
000BE6r 2               @LASTLOOP:
000BE6r 2  91 rr          STA (ZP_TRAM_VEC16),Y
000BE8r 2  C8             INY
000BE9r 2  C0 20          CPY #32
000BEBr 2  D0 F9          BNE @LASTLOOP
000BEDr 2                 ;JSR GCHR::DRAW_ALLLINE
000BEDr 2  20 rr rr       JSR GCHR::ENTER_TXTMODE             ; CHDZがすぐ狂うので初期化処理まで含める
000BF0r 2  60             RTS
000BF1r 2               
000BF1r 2               
000BF1r 1                 .ENDPROC
000BF1r 1                 .PROC BCOS_UART ; 単にUARTとするとアドレス宣言とかぶる
000BF1r 1                   .INCLUDE "uart.s"
000BF1r 2               ; BCOSに含まれるUART部分
000BF1r 2               ; 受信部分はinterrupt.s
000BF1r 2               
000BF1r 2               ; 使える設定集
000BF1r 2               UARTCMD_WELLCOME = UART::CMD::RTS_ON|UART::CMD::DTR_ON
000BF1r 2               UARTCMD_BUSY = UART::CMD::DTR_ON
000BF1r 2               UARTCMD_DOWN = UART::CMD::RIRQ_OFF
000BF1r 2               
000BF1r 2               ; --- UART初期化 ---
000BF1r 2               INIT:
000BF1r 2  A9 00          LDA #$00                ; ステータスへの書き込みはソフトリセットを意味する
000BF3r 2  8D 01 E0       STA UART::STATUS
000BF6r 2  A9 09          LDA #UARTCMD_WELLCOME   ; RTS_ON|DTR_ON
000BF8r 2  8D 02 E0       STA UART::COMMAND
000BFBr 2  A9 1D          LDA #%00011101          ; 1stopbit,word=8bit,rx-rate=tx-rate,xl/256
000BFDr 2  8D 03 E0       STA UART::CONTROL       ; SBN/WL1/WL0/RSC/SBR3/SBR2/SBR1/SBR0
000C00r 2  60             RTS
000C01r 2               
000C01r 2               ; print A reg to UART
000C01r 2               OUT_CHR:
000C01r 2  8D 00 E0       STA UART::TX
000C04r 2               @DELAY_6551:
000C04r 2  5A             PHY
000C05r 2  DA             PHX
000C06r 2               @DELAY_LOOP:
000C06r 2  A0 10          LDY #16
000C08r 2               @MINIDLY:
000C08r 2  A2 68          LDX #$68
000C0Ar 2               @DELAY_1:
000C0Ar 2  CA             DEX
000C0Br 2  D0 FD          BNE @DELAY_1
000C0Dr 2  88             DEY
000C0Er 2  D0 F8          BNE @MINIDLY
000C10r 2  FA             PLX
000C11r 2  7A             PLY
000C12r 2               @DELAY_DONE:
000C12r 2  60             RTS
000C13r 2               
000C13r 2               
000C13r 1                 .ENDPROC
000C13r 1                 .PROC DONKI
000C13r 1                   .INCLUDE "donki/donki.s"
000C13r 2               ; -------------------------------------------------------------------
000C13r 2               ; DONKI                  Debug OperatioN KIt
000C13r 2               ; -------------------------------------------------------------------
000C13r 2               ; デバッガ
000C13r 2               ; ひとまず、BCOSの一部として常駐する
000C13r 2               ; -------------------------------------------------------------------
000C13r 2               ; TODO 専用コマンドライン
000C13r 2               ; TODO ソフトウェアブレーク処理ルーチン
000C13r 2               LOOP:
000C13r 2  A9 rr A0 rr    loadAY16 STR_NEWLINE
000C17r 2  20 rr rr       JSR FUNC_CON_OUT_STR
000C1Ar 2  20 rr rr       JSR FUNC_CON_IN_STR
000C1Dr 2                 ; 復帰
000C1Dr 2  AD rr rr       LDA ROM::SP_SAVE
000C20r 2  18             CLC
000C21r 2  69 03          ADC #3                  ; SPを割り込み前の状態に戻す
000C23r 2  AA             TAX
000C24r 2  9A             TXS                     ; SP復帰
000C25r 2  AD rr rr       LDA ROM::A_SAVE
000C28r 2  AE rr rr       LDX ROM::X_SAVE
000C2Br 2  AC rr rr       LDY ROM::Y_SAVE
000C2Er 2  AD rr rr       LDA FLAG_SAVE           ; フラグをロード
000C31r 2  48             PHA                     ; フラグをプッシュ
000C32r 2  28             PLP                     ; フラグをフラグとしてプル
000C33r 2  6C rr rr       JMP (PC_SAVE)           ; 復帰ジャンプ
000C36r 2  4C rr rr       JMP LOOP
000C39r 2               
000C39r 2               ENT_DONKI:
000C39r 2               SAV_STAT:
000C39r 2               ; 状態を保存
000C39r 2               ; 割り込み直後のスタック状態を想定
000C39r 2  78             SEI
000C3Ar 2  8D rr rr       STA ROM::A_SAVE   ; レジスタ保存
000C3Dr 2  8E rr rr       STX ROM::X_SAVE
000C40r 2  8C rr rr       STY ROM::Y_SAVE
000C43r 2  A2 0B          LDX #12-1
000C45r 2               @STOREZRLOOP:       ; ゼロページレジスタを退避
000C45r 2  B5 rr          LDA ZR0,X
000C47r 2  9D rr rr       STA ROM::ZR0_SAVE,X
000C4Ar 2  CA             DEX
000C4Br 2  10 F8          BPL @STOREZRLOOP
000C4Dr 2  BA             TSX
000C4Er 2  8E rr rr       STX ROM::SP_SAVE  ; save targets stack poi
000C51r 2                 ; --- FLAG、PC保存 ---
000C51r 2                 ; SP+1=FLAG、+2=PCL、+3=PCH
000C51r 2  A0 00          LDY #0
000C53r 2               @STACK_SAVE_LOOP:
000C53r 2  E8             INX
000C54r 2  BD 00 01       LDA $0100,X
000C57r 2  99 rr rr       STA FLAG_SAVE,Y
000C5Ar 2  C8             INY
000C5Br 2  C0 03          CPY #3
000C5Dr 2  D0 F4          BNE @STACK_SAVE_LOOP
000C5Fr 2                 ; --- プログラムカウンタを減算 ---
000C5Fr 2  A9 01          LDA #$1
000C61r 2  CD rr rr       CMP PC_SAVE   ; PCLと#$1の比較
000C64r 2  90 05          BCC SKIPHDEC
000C66r 2  F0 03          BEQ SKIPHDEC
000C68r 2  CE rr rr       DEC PC_SAVE+1 ; PCH--
000C6Br 2               SKIPHDEC:
000C6Br 2  CE rr rr       DEC PC_SAVE   ; PCL--
000C6Er 2               PRT_STAT:  ; print contents of stack
000C6Er 2                 ; --- レジスタ情報を表示 ---
000C6Er 2                 ; 表示中にさらにBRKされると分かりづらいので改行
000C6Er 2  A9 rr A0 rr    loadAY16 STR_NEWLINE
000C72r 2  20 rr rr       JSR FUNC_CON_OUT_STR
000C75r 2                 ; A
000C75r 2  20 rr rr       JSR PRT_S
000C78r 2  A9 61          LDA #'a'
000C7Ar 2  20 rr rr       JSR FUNC_CON_OUT_CHR
000C7Dr 2  AD rr rr       LDA ROM::A_SAVE       ; Acc reg
000C80r 2  20 rr rr       JSR PRT_BYT_S
000C83r 2                 ; X
000C83r 2  A9 78          LDA #'x'
000C85r 2  20 rr rr       JSR FUNC_CON_OUT_CHR
000C88r 2  AD rr rr       LDA ROM::X_SAVE       ; X reg
000C8Br 2  20 rr rr       JSR PRT_BYT_S
000C8Er 2                 ; Y
000C8Er 2  A9 79          LDA #'y'
000C90r 2  20 rr rr       JSR FUNC_CON_OUT_CHR
000C93r 2  AD rr rr       LDA ROM::Y_SAVE       ; Y reg
000C96r 2  20 rr rr       JSR PRT_BYT_S
000C99r 2                 ; Flag
000C99r 2  A9 66          LDA #'f'
000C9Br 2  20 rr rr       JSR FUNC_CON_OUT_CHR
000C9Er 2  AD rr rr       LDA FLAG_SAVE
000CA1r 2  20 rr rr       JSR PRT_BYT_S
000CA4r 2                 ; PC
000CA4r 2  A9 70          LDA #'p'
000CA6r 2  20 rr rr       JSR FUNC_CON_OUT_CHR
000CA9r 2  AD rr rr       LDA PC_SAVE+1
000CACr 2  20 rr rr       JSR PRT_BYT
000CAFr 2  AD rr rr       LDA PC_SAVE
000CB2r 2  20 rr rr       JSR PRT_BYT_S
000CB5r 2                 ; SP
000CB5r 2  A9 73          LDA #'s'
000CB7r 2  20 rr rr       JSR FUNC_CON_OUT_CHR
000CBAr 2  AD rr rr       LDA ROM::SP_SAVE      ; stack pointer
000CBDr 2  20 rr rr       JSR PRT_BYT
000CC0r 2  58             CLI
000CC1r 2  4C rr rr       JMP LOOP
000CC4r 2               
000CC4r 2  0A 2B 00     STR_NEWLINE: .BYT $A,"+",$0
000CC7r 2               
000CC7r 2               ; -------------------------------------------------------------------
000CC7r 2               ;                          汎用関数群
000CC7r 2               ; -------------------------------------------------------------------
000CC7r 2               ; どうする？ライブラリ？システムコール？
000CC7r 2               ; -------------------------------------------------------------------
000CC7r 2               BCOS_ERROR:
000CC7r 2  20 rr rr       JSR PRT_LF
000CCAr 2  20 rr rr       JSR ERR::FUNC_ERR_GET
000CCDr 2  20 rr rr       JSR ERR::FUNC_ERR_MES
000CD0r 2  4C rr rr       JMP LOOP
000CD3r 2               
000CD3r 2               PRT_BIN:
000CD3r 2  A2 08          LDX #8
000CD5r 2               @LOOP:
000CD5r 2  0A             ASL
000CD6r 2  48             PHA
000CD7r 2  A9 30          LDA #'0'    ; キャリーが立ってなければ'0'
000CD9r 2  90 01          BCC @SKP_ADD1
000CDBr 2  1A             INC         ; キャリーが立ってたら'1'
000CDCr 2               @SKP_ADD1:
000CDCr 2  DA             PHX
000CDDr 2  20 rr rr       JSR FUNC_CON_OUT_CHR
000CE0r 2  FA             PLX
000CE1r 2  68             PLA
000CE2r 2  CA             DEX
000CE3r 2  D0 F0          BNE @LOOP
000CE5r 2  60             RTS
000CE6r 2               
000CE6r 2               PRT_BYT:
000CE6r 2  20 rr rr       JSR BYT2ASC
000CE9r 2  5A             PHY
000CEAr 2  20 rr rr       JSR PRT_C_CALL
000CEDr 2  68             PLA
000CEEr 2               PRT_C_CALL:
000CEEr 2  20 rr rr       JSR FUNC_CON_OUT_CHR
000CF1r 2  60             RTS
000CF2r 2               
000CF2r 2               PRT_LF:
000CF2r 2                 ; 改行
000CF2r 2  A9 0A          LDA #$A
000CF4r 2  4C rr rr       JMP PRT_C_CALL
000CF7r 2               
000CF7r 2               PRT_BYT_S:
000CF7r 2  20 rr rr       JSR PRT_BYT
000CFAr 2               PRT_S:
000CFAr 2                 ; スペース
000CFAr 2  A9 20          LDA #' '
000CFCr 2  4C rr rr       JMP PRT_C_CALL
000CFFr 2               
000CFFr 2               BYT2ASC:
000CFFr 2                 ; Aで与えられたバイト値をASCII値AYにする
000CFFr 2                 ; Aから先に表示すると良い
000CFFr 2  48             PHA           ; 下位のために保存
000D00r 2  29 0F          AND #$0F
000D02r 2  20 rr rr       JSR NIB2ASC
000D05r 2  A8             TAY
000D06r 2  68             PLA
000D07r 2  4A             LSR           ; 右シフトx4で上位を下位に持ってくる
000D08r 2  4A             LSR
000D09r 2  4A             LSR
000D0Ar 2  4A             LSR
000D0Br 2  20 rr rr       JSR NIB2ASC
000D0Er 2  60             RTS
000D0Fr 2               
000D0Fr 2               NIB2ASC:
000D0Fr 2                 ; #$0?をアスキー一文字にする
000D0Fr 2  09 30          ORA #$30
000D11r 2  C9 3A          CMP #$3A
000D13r 2  90 02          BCC @SKP_ADC  ; Aが$3Aより小さいか等しければ分岐
000D15r 2  69 06          ADC #$06
000D17r 2               @SKP_ADC:
000D17r 2  60             RTS
000D18r 2               
000D18r 2               
000D18r 1                 .ENDPROC
000D18r 1                 .PROC PS2
000D18r 1                   .INCLUDE "ps2/serial_ps2.s"
000D18r 2               ; -------------------------------------------------------------------
000D18r 2               ;               PS/2 キーボード シリアル信号ドライバ
000D18r 2               ; -------------------------------------------------------------------
000D18r 2               ; http://sbc.rictor.org/io/pckb6522.htmlの写経
000D18r 2               ; FXT65.incにアクセスできること
000D18r 2               ; -------------------------------------------------------------------
000D18r 2               ; アセンブル設定スイッチ
000D18r 2               TRUE = 1
000D18r 2               FALSE = 0
000D18r 2               PS2DEBUG = FALSE
000D18r 2               
000D18r 2               ; -------------------------------------------------------------------
000D18r 2               ;                             定数
000D18r 2               ; -------------------------------------------------------------------
000D18r 2               CPUCLK = 4                ; 一定時間の待機ルーチンに使うCPUクロック[MHz]
000D18r 2               INIT_TIMEOUT_MAX = $FF    ; 初期化タイムアウト期間
000D18r 2               ; -------------------------------------------------------------------
000D18r 2               ; ->KB コマンド
000D18r 2               ; -------------------------------------------------------------------
000D18r 2               KBCMD_ENABLE_SCAN   = $F4 ; キースキャンを開始する。res:ACK
000D18r 2               KBCMD_RESEND_LAST   = $FE ; 再送要求。res:DATA
000D18r 2               KBCMD_RESET         = $FF ; リセット。res:ACK
000D18r 2               KBCMD_SETLED        = $ED ; LEDの状態を設定。res:ACK
000D18r 2                 KBLED_CAPS          = %100
000D18r 2                 KBLED_NUM           = %010
000D18r 2                 KBLED_SCROLL        = %001
000D18r 2               
000D18r 2               ; -------------------------------------------------------------------
000D18r 2               ; <-KB レスポンス
000D18r 2               ; -------------------------------------------------------------------
000D18r 2               KBRES_ACK           = $FA ; 通常応答
000D18r 2               KBRES_BAT_COMPLET   = $AA ; BATが成功
000D18r 2               
000D18r 2               ; -------------------------------------------------------------------
000D18r 2               ; PS2KBドライバルーチン群
000D18r 2               ; -------------------------------------------------------------------
000D18r 2               ; INIT: ドライバソフトウェア及びキーボードデバイスの初期化
000D18r 2               ; SCAN: データの有無を取得  データなしでA=0、あるとA=非ゼロもしくはGET
000D18r 2               ; GET : A=スキャンコード
000D18r 2               ; -------------------------------------------------------------------
000D18r 2               SCAN:
000D18r 2                 ;LDX #(CPUCLK*$50) ; 実測で420usの受信待ち
000D18r 2  A2 FF          LDX #$FF
000D1Ar 2                 ; クロックを入力にセット（とあるが両方入力にしている
000D1Ar 2  AD 02 E2       LDA VIA::PS2_DDR
000D1Dr 2  29 CF          AND #<~(VIA::PS2_CLK|VIA::PS2_DAT)
000D1Fr 2  8D 02 E2       STA VIA::PS2_DDR
000D22r 2               @LOOP: ;kbscan1
000D22r 2  A9 20          LDA #VIA::PS2_CLK ; クロックの                          | 2
000D24r 2  2C 00 E2       BIT VIA::PS2_REG  ;     状態を取得                      | 4
000D27r 2  F0 09          BEQ @READY        ; クロックの立下りつまりデータを検出  | 2
000D29r 2  CA             DEX               ; タイマー減少                        | 2
000D2Ar 2  D0 F6          BNE @LOOP         ;                                     | 3 | sum=13  | 13*$FF=3315
000D2Cr 2                                   ;                                     | 0.125us*3315=414us
000D2Cr 2                 ; データが結局ない
000D2Cr 2  20 rr rr       JSR DIS           ; 無効化
000D2Fr 2  A9 00          LDA #0            ; データなしを示す0
000D31r 2  60             RTS
000D32r 2               @READY: ;kbscan2
000D32r 2                 ; データがある
000D32r 2                 ;JSR DIS           ; 無効化
000D32r 2                 ; 選べる終わり方の選択肢
000D32r 2                 ;RTS               ; データの有無だけを返す
000D32r 2                 ;JMP GET           ; 直接スキャンコードを取得
000D32r 2  DA             PHX                ; 直接GETの途中に突入する
000D33r 2  5A             PHY
000D34r 2                 ; バイトとパリティのクリア
000D34r 2  9C rr rr       STZ BYTSAV
000D37r 2  9C rr rr       STZ PARITY
000D3Ar 2  A8             TAY
000D3Br 2  A2 08          LDX #$08            ; ビットカウンタ
000D3Dr 2  4C rr rr       JMP GET_STARTBIT
000D40r 2               
000D40r 2               FLUSH:
000D40r 2                 ; バッファをフラッシュするらしいが実際にはスキャン開始コマンド？
000D40r 2  A9 F4          LDA #KBCMD_ENABLE_SCAN
000D42r 2               SEND:
000D42r 2                 ; --- バイトデータを送信する
000D42r 2  8D rr rr       STA BYTSAV        ; 送信するデータを保存
000D45r 2  DA             PHX               ; レジスタ退避
000D46r 2  5A             PHY
000D47r 2  8D rr rr       STA LASTBYT       ; 失敗に備える
000D4Ar 2                 ; クロックを下げ、データを上げる
000D4Ar 2  AD 00 E2       LDA VIA::PS2_REG
000D4Dr 2  29 DF          AND #<~VIA::PS2_CLK
000D4Fr 2  09 10          ORA #VIA::PS2_DAT
000D51r 2  8D 00 E2       STA VIA::PS2_REG
000D54r 2                 ; 両ピンを出力に設定
000D54r 2  AD 02 E2       LDA VIA::PS2_DDR
000D57r 2  09 30          ORA #VIA::PS2_CLK|VIA::PS2_DAT
000D59r 2  8D 02 E2       STA VIA::PS2_DDR
000D5Cr 2                 ; CPUクロックに応じた遅延64us
000D5Cr 2                 ; NOTE: 割り込み化できないか？
000D5Cr 2                 ;       もともと割込みで呼ばれるんだから無茶を言うな
000D5Cr 2  A9 40          LDA #(CPUCLK*$10)
000D5Er 2               @WAIT:
000D5Er 2  3A             DEC
000D5Fr 2  D0 FD          BNE @WAIT
000D61r 2  A0 00          LDY #$00          ; パリティカウンタ
000D63r 2  A2 08          LDX #$08          ; bit カウンタ
000D65r 2                 ; 両ピンを下げる
000D65r 2  AD 00 E2       LDA VIA::PS2_REG
000D68r 2  29 CF          AND #<~(VIA::PS2_CLK|VIA::PS2_DAT)
000D6Ar 2  8D 00 E2       STA VIA::PS2_REG
000D6Dr 2                 ; クロックを入力に設定
000D6Dr 2  AD 02 E2       LDA VIA::PS2_DDR
000D70r 2  29 DF          AND #<~VIA::PS2_CLK
000D72r 2  8D 02 E2       STA VIA::PS2_DDR
000D75r 2  20 rr rr       JSR HL
000D78r 2               SENDBIT:                ; シリアル送信
000D78r 2  6E rr rr       ROR BYTSAV
000D7Br 2  B0 0A          BCS MARK
000D7Dr 2                 ; データビットを下げる
000D7Dr 2  AD 00 E2       LDA VIA::PS2_REG
000D80r 2  29 EF          AND #<~VIA::PS2_DAT
000D82r 2  8D 00 E2       STA VIA::PS2_REG
000D85r 2  80 09          BRA NEXT
000D87r 2               MARK:
000D87r 2                 ; データビットを上げる
000D87r 2  AD 00 E2       LDA VIA::PS2_REG
000D8Ar 2  09 10          ORA #VIA::PS2_DAT
000D8Cr 2  8D 00 E2       STA VIA::PS2_REG
000D8Fr 2  C8             INY                   ; パリティカウンタカウントアップ
000D90r 2               NEXT:
000D90r 2  20 rr rr       JSR HL
000D93r 2  CA             DEX
000D94r 2  D0 E2          BNE SENDBIT           ; シリアル送信バイトループ
000D96r 2  98             TYA                   ; パリティカウントを処理
000D97r 2  29 01          AND #01
000D99r 2  D0 0A          BNE PCLR              ; 偶数奇数で分岐
000D9Br 2                 ; 偶数なら1送信
000D9Br 2  AD 00 E2       LDA VIA::PS2_REG
000D9Er 2  09 10          ORA #VIA::PS2_DAT
000DA0r 2  8D 00 E2       STA VIA::PS2_REG
000DA3r 2  80 08          BRA BACK
000DA5r 2               PCLR:
000DA5r 2                 ; 奇数なら0送信
000DA5r 2  AD 00 E2       LDA VIA::PS2_REG
000DA8r 2  09 EF          ORA #<~VIA::PS2_DAT
000DAAr 2  8D 00 E2       STA VIA::PS2_REG
000DADr 2               BACK:
000DADr 2  20 rr rr       JSR HL
000DB0r 2                 ; 両ピンを入力にセット
000DB0r 2  AD 02 E2       LDA VIA::PS2_DDR
000DB3r 2  29 CF          AND #<~(VIA::PS2_CLK|VIA::PS2_DAT)
000DB5r 2  8D 02 E2       STA VIA::PS2_DDR
000DB8r 2                 ; レジスタ復帰
000DB8r 2  7A             PLY
000DB9r 2  FA             PLX
000DBAr 2  20 rr rr       JSR HL                ; キーボードからのACKを待機
000DBDr 2  D0 75          BNE INIT              ; 0以外であるはずがない…もしそうなら初期化してまえ
000DBFr 2               @WAIT2:
000DBFr 2  AD 00 E2       LDA VIA::PS2_REG
000DC2r 2  29 20          AND #VIA::PS2_CLK
000DC4r 2  F0 F9          BEQ @WAIT2
000DC6r 2               DIS:
000DC6r 2                 ; 送信の無効化
000DC6r 2                 ; クロックを下げる
000DC6r 2  AD 00 E2       LDA VIA::PS2_REG
000DC9r 2  29 DF          AND #<~VIA::PS2_CLK
000DCBr 2  8D 00 E2       STA VIA::PS2_REG
000DCEr 2                 ; データを入力に、クロックを出力に
000DCEr 2  AD 02 E2       LDA VIA::PS2_DDR
000DD1r 2  29 CF          AND #<~(VIA::PS2_CLK|VIA::PS2_DAT)
000DD3r 2  09 20          ORA #VIA::PS2_CLK
000DD5r 2  8D 02 E2       STA VIA::PS2_DDR
000DD8r 2  60             RTS
000DD9r 2               
000DD9r 2               ERROR:
000DD9r 2  A9 FE          LDA #KBCMD_RESEND_LAST
000DDBr 2  20 rr rr       JSR SEND            ; 再送信要求
000DDEr 2               GET:
000DDEr 2  DA             PHX
000DDFr 2  5A             PHY
000DE0r 2                 ; バイトとパリティのクリア
000DE0r 2  A9 00          LDA #$00
000DE2r 2  9C rr rr       STZ BYTSAV
000DE5r 2  9C rr rr       STZ PARITY
000DE8r 2  A8             TAY
000DE9r 2  A2 08          LDX #$08            ; ビットカウンタ
000DEBr 2                 ; 両ピンを入力に
000DEBr 2  AD 02 E2       LDA VIA::PS2_DDR
000DEEr 2  29 CF          AND #<~(VIA::PS2_CLK|VIA::PS2_DAT)
000DF0r 2  8D 02 E2       STA VIA::PS2_DDR
000DF3r 2               WCLKH: ; kbget1
000DF3r 2                 ; クロックが高い間待つ
000DF3r 2  A9 20          LDA #VIA::PS2_CLK
000DF5r 2  2C 00 E2       BIT VIA::PS2_REG
000DF8r 2  D0 F9          BNE WCLKH
000DFAr 2                 ; スタートビットを取得
000DFAr 2               GET_STARTBIT:
000DFAr 2  AD 00 E2       LDA VIA::PS2_REG
000DFDr 2  29 10          AND #VIA::PS2_DAT
000DFFr 2  D0 F2          BNE WCLKH          ; 1だとスタートビットとして不適格なのでやり直し
000E01r 2               @NEXTBIT:  ; kbget2
000E01r 2  20 rr rr       JSR HL              ; 次の立下りを待つ
000E04r 2  18             CLC
000E05r 2  F0 01          BEQ @SKPSET
000E07r 2                 ;LSR                ; 獲得したデータビットをキャリーに格納
000E07r 2  38             SEC
000E08r 2               @SKPSET:
000E08r 2  6E rr rr       ROR BYTSAV          ; 変数に保存
000E0Br 2  10 01          BPL @SKPINP
000E0Dr 2  C8             INY                 ; パリティ増加
000E0Er 2               @SKPINP: ; kbget3
000E0Er 2  CA             DEX                 ; バイトカウンタ減少
000E0Fr 2  D0 F0          BNE @NEXTBIT        ; バイト内ループ
000E11r 2                 ; バイト終わり
000E11r 2  20 rr rr       JSR HL              ; パリティビットを取得
000E14r 2  F0 03          BEQ @SKPINP2        ; パリティビットが0なら何もしない
000E16r 2  EE rr rr       INC PARITY          ; 1なら増加
000E19r 2               @SKPINP2:
000E19r 2  98             TYA                 ; パリティカウントを取得
000E1Ar 2  7A             PLY
000E1Br 2  FA             PLX
000E1Cr 2  4D rr rr       EOR PARITY          ; パリティビットと比較
000E1Fr 2  29 01          AND #$01            ; LSBのみ見る
000E21r 2  F0 B6          BEQ ERROR           ; パリティエラー
000E23r 2  20 rr rr       JSR HL              ; ストップビットを待機
000E26r 2  F0 B1          BEQ ERROR           ; ストップビットエラー
000E28r 2  AD rr rr       LDA BYTSAV
000E2Br 2  F0 B1          BEQ GET             ; 受信バイトが0なら何も受信してないのでもう一度
000E2Dr 2  20 rr rr       JSR DIS
000E30r 2  AD rr rr       LDA BYTSAV
000E33r 2  60             RTS
000E34r 2               
000E34r 2               ; -------------------------------------------------------------------
000E34r 2               ; INIT:キーボードの初期化
000E34r 2               ; -------------------------------------------------------------------
000E34r 2               INIT:
000E34r 2                 ; スペシャルキー状態初期化
000E34r 2  A9 02          LDA #KBLED_NUM      ; NUMLOCKのみがオン
000E36r 2  85 rr          STA ZP_DECODE_STATE
000E38r 2               @RESET:
000E38r 2                 ; リセットと自己診断
000E38r 2  A9 FF          LDA #KBCMD_RESET
000E3Ar 2  20 rr rr       JSR SEND            ; $FF リセットコマンド
000E3Dr 2  20 rr rr       JSR GET
000E40r 2  C9 FA          CMP #KBRES_ACK
000E42r 2  D0 F4          BNE @RESET          ; ACKが来るまででリセット
000E44r 2  20 rr rr       JSR GET
000E47r 2  C9 AA          CMP #KBRES_BAT_COMPLET
000E49r 2  D0 ED          BNE @RESET          ; BATが成功するまでリセット
000E4Br 2                 ; LED状態更新
000E4Br 2               SETLED:
000E4Br 2  A9 ED          LDA #KBCMD_SETLED   ; 変数に従いLEDをセット
000E4Dr 2  20 rr rr       JSR SEND
000E50r 2  20 rr rr       JSR GET
000E53r 2  C9 FA          CMP #KBRES_ACK
000E55r 2  D0 F4          BNE SETLED          ; ack待機
000E57r 2  A5 rr          LDA ZP_DECODE_STATE         ; スペシャルの下位3bitがLED状態に対応
000E59r 2  29 07          AND #%00000111      ; bits 3-7 を0に 不要説あり
000E5Br 2  20 rr rr       JSR SEND
000E5Er 2  20 rr rr       JSR GET             ; ackか何かが返る
000E61r 2                 ;CMP #KBRES_ACK
000E61r 2                 ;BNE SETLED          ; ack待機
000E61r 2  60             RTS
000E62r 2               
000E62r 2               HL:
000E62r 2                 ; 次の立下りでのデータを返す
000E62r 2  A9 20          LDA #VIA::PS2_CLK
000E64r 2  2C 00 E2       BIT VIA::PS2_REG
000E67r 2  F0 F9          BEQ HL              ; クロックがLの期間待つ
000E69r 2               @H:
000E69r 2  2C 00 E2       BIT VIA::PS2_REG
000E6Cr 2  D0 FB          BNE @H              ; クロックがHの期間待つ
000E6Er 2  AD 00 E2       LDA VIA::PS2_REG
000E71r 2  29 10          AND #VIA::PS2_DAT   ; データラインの状態を返す
000E73r 2  60             RTS
000E74r 2               
000E74r 2               
000E74r 1                   .INCLUDE "ps2/decode_ps2.s"
000E74r 2               ; -------------------------------------------------------------------
000E74r 2               ;               PS/2 キーボード スキャンコードデコーダ
000E74r 2               ; -------------------------------------------------------------------
000E74r 2               ; 垂直同期スキャンし、
000E74r 2               ; 1. ASCII列を出力
000E74r 2               ; 2. キー押下状況をビットマップに保持
000E74r 2               ; -------------------------------------------------------------------
000E74r 2               .INCLUDE "../FXT65.inc"
000E74r 3               ; FxT65のハードウェア構成を定義する
000E74r 3               
000E74r 3               .PC02 ; CMOS命令を許可
000E74r 3               
000E74r 3               RAMBASE = $0000
000E74r 3               UARTBASE = $E000
000E74r 3               VIABASE = $E200
000E74r 3               YMZBASE = $E400
000E74r 3               CRTCBASE = $E600
000E74r 3               ROMBASE = $F000
000E74r 3               
000E74r 3               ; UART
000E74r 3               .PROC UART
000E74r 3                 RX = UARTBASE
000E74r 3                 TX = UARTBASE
000E74r 3                 STATUS = UARTBASE+1
000E74r 3                 COMMAND = UARTBASE+2
000E74r 3                 CONTROL = UARTBASE+3
000E74r 3                 .PROC CMD
000E74r 3                   ; PMC1/PMC0/PME/REM/TIC1/TIC0/IRD/DTR
000E74r 3                   ; 全てゼロだと「エコーオフ、RTSオフ、割り込み有効、DTRオフ」
000E74r 3                   RTS_ON =    %00001000
000E74r 3                   ECHO_ON =   %00010000
000E74r 3                   RIRQ_OFF =  %00000010
000E74r 3                   DTR_ON =    %00000001
000E74r 3                 .ENDPROC
000E74r 3                 XON = $11
000E74r 3                 XOFF = $13
000E74r 3               .ENDPROC
000E74r 3               
000E74r 3               ; VIA
000E74r 3               .PROC VIA
000E74r 3                 PORTB = VIABASE
000E74r 3                 PORTA = VIABASE+1
000E74r 3                 DDRB = VIABASE+2
000E74r 3                 DDRA = VIABASE+3
000E74r 3                 T1CL = VIABASE+4
000E74r 3                 T1CH = VIABASE+5
000E74r 3                 T1LL = VIABASE+6
000E74r 3                 T1LH = VIABASE+7
000E74r 3                 SR = VIABASE+$A
000E74r 3                 ACR = VIABASE+$B
000E74r 3                 PCR = VIABASE+$C
000E74r 3                 IFR = VIABASE+$D
000E74r 3                 IER = VIABASE+$E
000E74r 3                 IFR_IRQ = %10000000
000E74r 3                 IER_SET = %10000000
000E74r 3                 IFR_T1  = %01000000
000E74r 3                 IFR_T2  = %00100000
000E74r 3                 IFR_CB1 = %00010000
000E74r 3                 IFR_CB2 = %00001000
000E74r 3                 IFR_SR  = %00000100
000E74r 3                 IFR_CA1 = %00000010
000E74r 3                 IFR_CA2 = %00000001
000E74r 3                 ; 新式
000E74r 3                 SPI_REG    = PORTB
000E74r 3                 SPI_DDR    = DDRB
000E74r 3                 SPI_INOUT  = %10000000  ; 1=in, 0=out
000E74r 3                 SPI_CS0    = %01000000
000E74r 3                 PS2_REG    = PORTB
000E74r 3                 PS2_DDR    = DDRB
000E74r 3                 PS2_CLK    = %00100000
000E74r 3                 PS2_DAT    = %00010000
000E74r 3                 PAD_REG    = PORTB
000E74r 3                 PAD_DDR    = DDRB
000E74r 3                 PAD_CLK    = %00000100
000E74r 3                 PAD_PTS    = %00000010
000E74r 3                 PAD_DAT    = %00000001
000E74r 3               .ENDPROC
000E74r 3               
000E74r 3               ; ChDz
000E74r 3               .PROC CRTC
000E74r 3                 CFG = CRTCBASE+$1   ; コンフィグ
000E74r 3                                         ;   MD0 MD1 MD2 MD3 - - - WCUE
000E74r 3                                         ;   MD : 色モード選択（各フレーム）
000E74r 3                                         ;   WCUE  : 書き込みカウントアップ有効化
000E74r 3               
000E74r 3                 VMAH = CRTCBASE+$2  ; VRAM書き込みアドレス下位
000E74r 3                                         ;   - 6 5 4 3 2 1 0
000E74r 3               
000E74r 3                 VMAV = CRTCBASE+$3  ; VRAM書き込みアドレス上位
000E74r 3                                     ;   7 6 5 4 3 2 1 0
000E74r 3               
000E74r 3                 WDBF = CRTCBASE+$4  ; 書き込みデータ
000E74r 3               
000E74r 3                 RF  = CRTCBASE+$5   ; 出力フレーム選択
000E74r 3                                     ;   (0) 1 0 | (1) 1 0 | (2) 1 0 | (3) 1 0
000E74r 3               
000E74r 3                 WF  = CRTCBASE+$6   ; 書き込みフレーム選択
000E74r 3                                     ;   - - - - - - WF1 WF0
000E74r 3               
000E74r 3                 TCP  = CRTCBASE+$7  ; 2色モード色選択
000E74r 3                                         ;   (0) 3 2 1 0 | (1) 3 2 1 0
000E74r 3               .ENDPROC
000E74r 3               
000E74r 3               ; YMZ
000E74r 3               .PROC YMZ
000E74r 3                 ADDR = YMZBASE
000E74r 3                 DATA = YMZBASE+1
000E74r 3                 ; IR:Internal Address
000E74r 3                 IA_FRQ = $00        ; 各チャンネル周波数
000E74r 3                 IA_NOISE_FRQ = $06  ; ノイズ音周波数
000E74r 3                 IA_MIX = $07        ; ミキサ設定
000E74r 3                 IA_VOL = $08        ; 各チャンネル音量
000E74r 3                 IA_EVLP_FRQ = $0B   ; エンベロープ周波数
000E74r 3                 IA_EVLP_SHAPE = $0D ; エンベロープ形状
000E74r 3               .ENDPROC
000E74r 3               
000E74r 3               
000E74r 2               
000E74r 2               ; -------------------------------------------------------------------
000E74r 2               ;                              定数
000E74r 2               ; -------------------------------------------------------------------
000E74r 2               VB_DEV  = 1                 ; 垂直同期をこれで分周した周期でスキャンする
000E74r 2               _VB_DEV_ENABLE = VB_DEV-1   ; VB_DEVが1だとこれが偽になり、分周コード省略
000E74r 2               
000E74r 2               ; -------------------------------------------------------------------
000E74r 2               ;                          垂直同期割り込み
000E74r 2               ; -------------------------------------------------------------------
000E74r 2               ; （場合によっては分周した周期の）垂直同期のタイミングでスキャンし、
000E74r 2               ; あれば多バイト分処理する
000E74r 2               ; -------------------------------------------------------------------
000E74r 2               VBLANK:
000E74r 2                 ; 分周
000E74r 2                 .IF _VB_DEV_ENABLE
000E74r 2                   DEC VB_COUNT
000E74r 2                   BNE @EXT
000E74r 2                   LDA #VB_DEV
000E74r 2                   STA VB_COUNT
000E74r 2                 .ENDIF
000E74r 2                 ; スキャン
000E74r 2  20 rr rr       JSR PS2::SCAN
000E77r 2  F0 26          BEQ @EXT                        ; スキャンして0が返ったらデータなし
000E79r 2                 ; データが返った
000E79r 2                 ; スキャンコードのASCIIデコード
000E79r 2               @PROCESSING_SCAN_CODE:
000E79r 2  20 rr rr       JSR CHK_SPCODES                 ; 特殊処理
000E7Cr 2               @kbvnvt:
000E7Cr 2  F0 21          BEQ @EXT                        ; 0なら無視
000E7Er 2  AA             TAX                             ; 処理されたスキャンコードをテーブルインデックスに
000E7Fr 2                 ; NOTE:ここに78,69,7E,02,numpad
000E7Fr 2               @TEST_SHIFT:
000E7Fr 2  A5 rr          LDA ZP_DECODE_STATE
000E81r 2  89 10          BIT #STATE_SHIFT                ; シフトが押されてるか
000E83r 2  F0 04          BEQ @NOSHIFT
000E85r 2               @SHIFT:     ; kbcnvt2
000E85r 2  8A             TXA
000E86r 2  09 80          ORA #%10000000
000E88r 2  AA             TAX
000E89r 2               @NOSHIFT:   ; kbcnvt3
000E89r 2  A5 rr          LDA ZP_DECODE_STATE
000E8Br 2  89 08          BIT #STATE_CTRL                 ; コントロールが押されているか
000E8Dr 2  F0 0B          BEQ @NOCTRL
000E8Fr 2               @CTRL:
000E8Fr 2  BD rr rr       LDA ASCIITBL,X
000E92r 2  C9 8F          CMP #$8F
000E94r 2                 ;BEQ REINIT
000E94r 2  29 1F          AND #$1F
000E96r 2  80 07          BRA @EXT
000E98r 2                 ;TAX
000E98r 2  80 05          BRA @DONE
000E9Ar 2               @NOCTRL:    ; kbcnvt4
000E9Ar 2  BD rr rr       LDA ASCIITBL,X
000E9Dr 2  F0 00          BEQ @EXT
000E9Fr 2                 ; NOTE:CAPS処理
000E9Fr 2               @DONE:
000E9Fr 2                 ; Aにアスキーコードが
000E9Fr 2               @EXT:
000E9Fr 2  60             RTS                             ; 0以外はトラップされる
000EA0r 2               
000EA0r 2               ; -------------------------------------------------------------------
000EA0r 2               ;                    スキャンコード処理ルーチン群
000EA0r 2               ; -------------------------------------------------------------------
000EA0r 2               ; シフトキー押下
000EA0r 2               SP_SET_SHIFT:
000EA0r 2  A9 10          LDA #STATE_SHIFT
000EA2r 2  2C             .BYT $2C
000EA3r 2               ; コントロールキー押下
000EA3r 2               SP_SET_CTRL:
000EA3r 2  A9 08          LDA #STATE_CTRL
000EA5r 2  05 rr          ORA ZP_DECODE_STATE
000EA7r 2  85 rr          STA ZP_DECODE_STATE
000EA9r 2  80 06          BRA SP_NULL
000EABr 2               
000EABr 2               ; 再送要求をくらった
000EABr 2               SP_RESEND:
000EABr 2  AD rr rr       LDA LASTBYT
000EAEr 2  20 rr rr       JSR SEND
000EB1r 2                 ;BRA SP_NULL          ; NULLまでの間のコードを省いたので直通
000EB1r 2               
000EB1r 2               ; なにもしない
000EB1r 2               SP_NULL:
000EB1r 2  A9 00          LDA #0
000EB3r 2  60             RTS
000EB4r 2               
000EB4r 2               ; E0拡張
000EB4r 2               SP_E0EXT:
000EB4r 2  20 rr rr       JSR GET         ; 次のコードを取得する
000EB7r 2  C9 F0          CMP #$F0        ; 拡張リリースか？
000EB9r 2  F0 06          BEQ @RLS        ; 拡張リリース
000EBBr 2  C9 14          CMP #$14        ; 右CTRL
000EBDr 2  F0 E4          BEQ SP_SET_CTRL
000EBFr 2                 ; NOTE:ここに4つの置換コード
000EBFr 2  C9 03          CMP #$03
000EC1r 2               ; E0リリース
000EC1r 2               @RLS:
000EC1r 2  C9 12          CMP #$12            ; E0F012
000EC3r 2  D0 0D          BNE SP_RLS_CHKCTRL  ; でなければふつうのリリース
000EC5r 2  80 EA          BRA SP_NULL
000EC7r 2               
000EC7r 2               ; リリース
000EC7r 2               SP_RLS:
000EC7r 2  20 rr rr       JSR GET
000ECAr 2  C9 12          CMP #$12      ; 左シフト
000ECCr 2  F0 12          BEQ SP_RLS_SHIFT
000ECEr 2  C9 59          CMP #$59      ; 右シフト
000ED0r 2  F0 0E          BEQ SP_RLS_SHIFT
000ED2r 2               SP_RLS_CHKCTRL:
000ED2r 2  C9 14          CMP #$14      ; CTRL
000ED4r 2  F0 07          BEQ SP_RLS_CTRL
000ED6r 2  C9 11          CMP #$11      ; ALT
000ED8r 2  D0 D7          BNE SP_NULL   ; シフト、コントロール、オルト以外のリリースは無視
000EDAr 2                               ; では困るのだが
000EDAr 2               @ALT:
000EDAr 2  A9 13          LDA #$13      ; ALTリリースで13を返す真意はわからない
000EDCr 2  60             RTS
000EDDr 2               SP_RLS_CTRL:
000EDDr 2  A9 F7          LDA #<~STATE_CTRL
000EDFr 2  2C             .BYT $2C
000EE0r 2               SP_RLS_SHIFT:
000EE0r 2  A9 EF          LDA #<~STATE_SHIFT
000EE2r 2  25 rr          AND ZP_DECODE_STATE
000EE4r 2  85 rr          STA ZP_DECODE_STATE
000EE6r 2  80 C9          BRA SP_NULL
000EE8r 2               
000EE8r 2               ; ブレイク
000EE8r 2               SP_BRK:
000EE8r 2  A2 07          LDX #$07
000EEAr 2               @LOOP:
000EEAr 2  20 rr rr       JSR GET
000EEDr 2  CA             DEX
000EEEr 2  D0 FA          BNE @LOOP
000EF0r 2  A9 10          LDA #$10
000EF2r 2  60             RTS
000EF3r 2               
000EF3r 2               CHK_SPCODES: ; kbcsrch            ; 14種類の特殊コードがあればベクタテーブルで処理する
000EF3r 2  A2 0B          LDX #(SP_VECLST-SP_LST-1)         ; ループ回数
000EF5r 2               @LOOP_CHK:
000EF5r 2  DD rr rr       CMP SP_LST,X                    ; チェック対象リストに対照
000EF8r 2  F0 04          BEQ @JUMP                       ; マッチしたらベクタに跳ぶ
000EFAr 2  CA             DEX
000EFBr 2  10 F8          BPL @LOOP_CHK
000EFDr 2  60             RTS                             ; マッチしない
000EFEr 2               @JUMP:
000EFEr 2  8A             TXA                             ; マッチしたインデックスをAに
000EFFr 2  0A             ASL                             ; 16bit幅ベクタに適合するようにx2
000F00r 2  AA             TAX                             ; Xに
000F01r 2  AD rr rr       LDA BYTSAV                      ; 元のスキャンコードをAに復帰
000F04r 2  7C rr rr       JMP (SP_VECLST,X)               ; 各ベクタにジャンプ
000F07r 2               
000F07r 2               SP_LST:
000F07r 2  12           .BYT $12               ; Lshift
000F08r 2  59           .BYT $59               ; Rshift
000F09r 2  14           .BYT $14               ; ctrl
000F0Ar 2  E1           .BYT $E1               ; Extended pause break
000F0Br 2               ;
000F0Br 2  E0           .BYT $E0               ; Extended key handler
000F0Cr 2  F0           .BYT $F0               ; Release 1 BYT key code
000F0Dr 2  FA           .BYT $FA               ; Ack
000F0Er 2  AA           .BYT $AA               ; POST passed
000F0Fr 2               ;
000F0Fr 2  EE           .BYT $EE               ; Echo
000F10r 2  FE           .BYT $FE               ; resend
000F11r 2  FF           .BYT $FF               ; overflow/error
000F12r 2  00           .BYT $00               ; underflow/error
000F13r 2               ;
000F13r 2               ; command/scancode jump table
000F13r 2               ;
000F13r 2               SP_VECLST:
000F13r 2  rr rr        .WORD SP_SET_SHIFT      ; Lshift
000F15r 2  rr rr        .WORD SP_SET_SHIFT      ; Rshift
000F17r 2  rr rr        .WORD SP_SET_CTRL       ; ctrl
000F19r 2  rr rr        .WORD SP_BRK            ; Extended pause break
000F1Br 2               ;
000F1Br 2  rr rr        .WORD SP_E0EXT          ; Extended key handler
000F1Dr 2  rr rr        .WORD SP_RLS            ; Release 1 BYT key code
000F1Fr 2  rr rr        .WORD SP_NULL           ; Ack
000F21r 2  rr rr        .WORD SP_NULL           ; POST passed
000F23r 2               ;
000F23r 2  rr rr        .WORD SP_NULL           ; Echo
000F25r 2  rr rr        .WORD SP_RESEND         ; resend
000F27r 2  rr rr        .WORD FLUSH             ; overflow/error
000F29r 2  rr rr        .WORD FLUSH             ; underflow/error
000F2Br 2               
000F2Br 2               ;*************************************************************
000F2Br 2               ;
000F2Br 2               ; Unshifted table for scancodes to ascii conversion
000F2Br 2               ;                                      Scan|Keyboard
000F2Br 2               ;                                      Code|Key
000F2Br 2               ;                                      ----|----------
000F2Br 2  00           ASCIITBL:      .byte $00               ; 00 no key pressed
000F2Cr 2  89                          .byte $89               ; 01 F9
000F2Dr 2  87                          .byte $87               ; 02 relocated F7
000F2Er 2  85                          .byte $85               ; 03 F5
000F2Fr 2  83                          .byte $83               ; 04 F3
000F30r 2  81                          .byte $81               ; 05 F1
000F31r 2  82                          .byte $82               ; 06 F2
000F32r 2  8C                          .byte $8C               ; 07 F12
000F33r 2  00                          .byte $00               ; 08
000F34r 2  8A                          .byte $8A               ; 09 F10
000F35r 2  88                          .byte $88               ; 0A F8
000F36r 2  86                          .byte $86               ; 0B F6
000F37r 2  84                          .byte $84               ; 0C F4
000F38r 2  09                          .byte $09               ; 0D tab
000F39r 2  60                          .byte $60               ; 0E `~
000F3Ar 2  8F                          .byte $8F               ; 0F relocated Print Screen key
000F3Br 2  03                          .byte $03               ; 10 relocated Pause/Break key
000F3Cr 2  A0                          .byte $A0               ; 11 left alt (right alt too)
000F3Dr 2  00                          .byte $00               ; 12 left shift
000F3Er 2  E0                          .byte $E0               ; 13 relocated Alt release code
000F3Fr 2  00                          .byte $00               ; 14 left ctrl (right ctrl too)
000F40r 2  71                          .byte $71               ; 15 qQ
000F41r 2  31                          .byte $31               ; 16 1!
000F42r 2  00                          .byte $00               ; 17
000F43r 2  00                          .byte $00               ; 18
000F44r 2  00                          .byte $00               ; 19
000F45r 2  7A                          .byte $7A               ; 1A zZ
000F46r 2  73                          .byte $73               ; 1B sS
000F47r 2  61                          .byte $61               ; 1C aA
000F48r 2  77                          .byte $77               ; 1D wW
000F49r 2  32                          .byte $32               ; 1E 2@
000F4Ar 2  A1                          .byte $A1               ; 1F Windows 98 menu key (left side)
000F4Br 2  02                          .byte $02               ; 20 relocated ctrl-break key
000F4Cr 2  63                          .byte $63               ; 21 cC
000F4Dr 2  78                          .byte $78               ; 22 xX
000F4Er 2  64                          .byte $64               ; 23 dD
000F4Fr 2  65                          .byte $65               ; 24 eE
000F50r 2  34                          .byte $34               ; 25 4$
000F51r 2  33                          .byte $33               ; 26 3#
000F52r 2  A2                          .byte $A2               ; 27 Windows 98 menu key (right side)
000F53r 2  00                          .byte $00               ; 28
000F54r 2  20                          .byte $20               ; 29 space
000F55r 2  76                          .byte $76               ; 2A vV
000F56r 2  66                          .byte $66               ; 2B fF
000F57r 2  74                          .byte $74               ; 2C tT
000F58r 2  72                          .byte $72               ; 2D rR
000F59r 2  35                          .byte $35               ; 2E 5%
000F5Ar 2  A3                          .byte $A3               ; 2F Windows 98 option key (right click, right side)
000F5Br 2  00                          .byte $00               ; 30
000F5Cr 2  6E                          .byte $6E               ; 31 nN
000F5Dr 2  62                          .byte $62               ; 32 bB
000F5Er 2  68                          .byte $68               ; 33 hH
000F5Fr 2  67                          .byte $67               ; 34 gG
000F60r 2  79                          .byte $79               ; 35 yY
000F61r 2  36                          .byte $36               ; 36 6^
000F62r 2  00                          .byte $00               ; 37
000F63r 2  00                          .byte $00               ; 38
000F64r 2  00                          .byte $00               ; 39
000F65r 2  6D                          .byte $6D               ; 3A mM
000F66r 2  6A                          .byte $6A               ; 3B jJ
000F67r 2  75                          .byte $75               ; 3C uU
000F68r 2  37                          .byte $37               ; 3D 7&
000F69r 2  38                          .byte $38               ; 3E 8*
000F6Ar 2  00                          .byte $00               ; 3F
000F6Br 2  00                          .byte $00               ; 40
000F6Cr 2  2C                          .byte ','               ; 41 ,<
000F6Dr 2  6B                          .byte $6B               ; 42 kK
000F6Er 2  69                          .byte $69               ; 43 iI
000F6Fr 2  6F                          .byte $6F               ; 44 oO
000F70r 2  30                          .byte $30               ; 45 0)
000F71r 2  39                          .byte $39               ; 46 9(
000F72r 2  00                          .byte $00               ; 47
000F73r 2  00                          .byte $00               ; 48
000F74r 2  2E                          .byte '.'               ; 49 .>
000F75r 2  2F                          .byte $2F               ; 4A /?
000F76r 2  6C                          .byte $6C               ; 4B lL
000F77r 2  3B                          .byte ';'               ; 4C ;+
000F78r 2  70                          .byte $70               ; 4D pP
000F79r 2  2D                          .byte '-'               ; 4E -=
000F7Ar 2  00                          .byte $00               ; 4F
000F7Br 2  00                          .byte $00               ; 50
000F7Cr 2  5C                          .byte '\'               ; 51 \_
000F7Dr 2  3A                          .byte ':'               ; 52 :*
000F7Er 2  00                          .byte $00               ; 53
000F7Fr 2  40                          .byte '@'               ; 54 @`
000F80r 2  5E                          .byte '^'               ; 55 ^~
000F81r 2  00                          .byte $00               ; 56
000F82r 2  00                          .byte $00               ; 57
000F83r 2  00                          .byte $00               ; 58 caps
000F84r 2  00                          .byte $00               ; 59 r shift
000F85r 2  0A                          .byte $0A               ; 5A <Enter>
000F86r 2  5B                          .byte '['               ; 5B [{
000F87r 2  00                          .byte $00               ; 5C
000F88r 2  5D                          .byte ']'               ; 5D ]}
000F89r 2  00                          .byte $00               ; 5E
000F8Ar 2  00                          .byte $00               ; 5F
000F8Br 2  00                          .byte $00               ; 60
000F8Cr 2  00                          .byte $00               ; 61
000F8Dr 2  00                          .byte $00               ; 62
000F8Er 2  00                          .byte $00               ; 63
000F8Fr 2  00                          .byte $00               ; 64
000F90r 2  00                          .byte $00               ; 65
000F91r 2  08                          .byte $08               ; 66 bkspace
000F92r 2  00                          .byte $00               ; 67
000F93r 2  00                          .byte $00               ; 68
000F94r 2  31                          .byte $31               ; 69 kp 1
000F95r 2  5C                          .byte '\'               ; 6A \|
000F96r 2  34                          .byte $34               ; 6B kp 4
000F97r 2  37                          .byte $37               ; 6C kp 7
000F98r 2  00                          .byte $00               ; 6D
000F99r 2  00                          .byte $00               ; 6E
000F9Ar 2  00                          .byte $00               ; 6F
000F9Br 2  30                          .byte $30               ; 70 kp 0
000F9Cr 2  2E                          .byte $2E               ; 71 kp .
000F9Dr 2  32                          .byte $32               ; 72 kp 2
000F9Er 2  35                          .byte $35               ; 73 kp 5
000F9Fr 2  36                          .byte $36               ; 74 kp 6
000FA0r 2  38                          .byte $38               ; 75 kp 8
000FA1r 2  1B                          .byte $1B               ; 76 esc
000FA2r 2  00                          .byte $00               ; 77 num lock
000FA3r 2  8B                          .byte $8B               ; 78 F11
000FA4r 2  2B                          .byte $2B               ; 79 kp +
000FA5r 2  33                          .byte $33               ; 7A kp 3
000FA6r 2  2D                          .byte $2D               ; 7B kp -
000FA7r 2  2A                          .byte $2A               ; 7C kp *
000FA8r 2  39                          .byte $39               ; 7D kp 9
000FA9r 2  8D                          .byte $8D               ; 7E scroll lock
000FAAr 2  00                          .byte $00               ; 7F
000FABr 2               ;
000FABr 2               ; Table for shifted scancodes
000FABr 2               ;
000FABr 2  00                          .byte $00               ; 80
000FACr 2  C9                          .byte $C9               ; 81 F9
000FADr 2  C7                          .byte $C7               ; 82 relocated F7
000FAEr 2  C5                          .byte $C5               ; 83 F5 (F7 actual scancode=83)
000FAFr 2  C3                          .byte $C3               ; 84 F3
000FB0r 2  C1                          .byte $C1               ; 85 F1
000FB1r 2  C2                          .byte $C2               ; 86 F2
000FB2r 2  CC                          .byte $CC               ; 87 F12
000FB3r 2  00                          .byte $00               ; 88
000FB4r 2  CA                          .byte $CA               ; 89 F10
000FB5r 2  C8                          .byte $C8               ; 8A F8
000FB6r 2  C6                          .byte $C6               ; 8B F6
000FB7r 2  C4                          .byte $C4               ; 8C F4
000FB8r 2  09                          .byte $09               ; 8D tab
000FB9r 2  7E                          .byte $7E               ; 8E `~
000FBAr 2  CF                          .byte $CF               ; 8F relocated Print Screen key
000FBBr 2  03                          .byte $03               ; 90 relocated Pause/Break key
000FBCr 2  A0                          .byte $A0               ; 91 left alt (right alt)
000FBDr 2  00                          .byte $00               ; 92 left shift
000FBEr 2  E0                          .byte $E0               ; 93 relocated Alt release code
000FBFr 2  00                          .byte $00               ; 94 left ctrl (and right ctrl)
000FC0r 2  51                          .byte $51               ; 95 qQ
000FC1r 2  21                          .byte $21               ; 96 1!
000FC2r 2  00                          .byte $00               ; 97
000FC3r 2  00                          .byte $00               ; 98
000FC4r 2  00                          .byte $00               ; 99
000FC5r 2  5A                          .byte $5A               ; 9A zZ
000FC6r 2  53                          .byte $53               ; 9B sS
000FC7r 2  41                          .byte $41               ; 9C aA
000FC8r 2  57                          .byte $57               ; 9D wW
000FC9r 2  22                          .byte '"'               ; 9E 2'"'
000FCAr 2  E1                          .byte $E1               ; 9F Windows 98 menu key (left side)
000FCBr 2  02                          .byte $02               ; A0 relocated ctrl-break key
000FCCr 2  43                          .byte $43               ; A1 cC
000FCDr 2  58                          .byte $58               ; A2 xX
000FCEr 2  44                          .byte $44               ; A3 dD
000FCFr 2  45                          .byte $45               ; A4 eE
000FD0r 2  24                          .byte $24               ; A5 4$
000FD1r 2  23                          .byte $23               ; A6 3#
000FD2r 2  E2                          .byte $E2               ; A7 Windows 98 menu key (right side)
000FD3r 2  00                          .byte $00               ; A8
000FD4r 2  20                          .byte $20               ; A9 space
000FD5r 2  56                          .byte $56               ; AA vV
000FD6r 2  46                          .byte $46               ; AB fF
000FD7r 2  54                          .byte $54               ; AC tT
000FD8r 2  52                          .byte $52               ; AD rR
000FD9r 2  25                          .byte $25               ; AE 5%
000FDAr 2  E3                          .byte $E3               ; AF Windows 98 option key (right click, right side)
000FDBr 2  00                          .byte $00               ; B0
000FDCr 2  4E                          .byte $4E               ; B1 nN
000FDDr 2  42                          .byte $42               ; B2 bB
000FDEr 2  48                          .byte $48               ; B3 hH
000FDFr 2  47                          .byte $47               ; B4 gG
000FE0r 2  59                          .byte $59               ; B5 yY
000FE1r 2  26                          .byte '&'               ; B6 6&
000FE2r 2  00                          .byte $00               ; B7
000FE3r 2  00                          .byte $00               ; B8
000FE4r 2  00                          .byte $00               ; B9
000FE5r 2  4D                          .byte $4D               ; BA mM
000FE6r 2  4A                          .byte $4A               ; BB jJ
000FE7r 2  55                          .byte $55               ; BC uU
000FE8r 2  27                          .byte '''               ; BD 7'
000FE9r 2  28                          .byte '('               ; BE 8(
000FEAr 2  00                          .byte $00               ; BF
000FEBr 2  00                          .byte $00               ; C0
000FECr 2  3C                          .byte $3C               ; C1 ,<
000FEDr 2  4B                          .byte $4B               ; C2 kK
000FEEr 2  49                          .byte $49               ; C3 iI
000FEFr 2  4F                          .byte $4F               ; C4 oO
000FF0r 2  00                          .byte $00               ; C5 0
000FF1r 2  29                          .byte ')'               ; C6 9)
000FF2r 2  00                          .byte $00               ; C7
000FF3r 2  00                          .byte $00               ; C8
000FF4r 2  3E                          .byte $3E               ; C9 .>
000FF5r 2  3F                          .byte $3F               ; CA /?
000FF6r 2  4C                          .byte $4C               ; CB lL
000FF7r 2  2B                          .byte '+'               ; CC ;+
000FF8r 2  50                          .byte $50               ; CD pP
000FF9r 2  3D                          .byte '='               ; CE -=
000FFAr 2  00                          .byte $00               ; CF
000FFBr 2  00                          .byte $00               ; D0
000FFCr 2  5F                          .byte '_'               ; D1 \_
000FFDr 2  2A                          .byte '*'               ; D2 :*
000FFEr 2  00                          .byte $00               ; D3
000FFFr 2  60                          .byte '`'               ; D4 @`
001000r 2  7E                          .byte '~'               ; D5 ^~
001001r 2  00                          .byte $00               ; D6
001002r 2  00                          .byte $00               ; D7
001003r 2  00                          .byte $00               ; D8 caps
001004r 2  00                          .byte $00               ; D9 r shift
001005r 2  0A                          .byte $0A               ; DA <Enter>
001006r 2  7B                          .byte '{'               ; DB [{
001007r 2  00                          .byte $00               ; DC
001008r 2  7D                          .byte '}'               ; DD ]}
001009r 2  00                          .byte $00               ; DE
00100Ar 2  00                          .byte $00               ; DF
00100Br 2  00                          .byte $00               ; E0
00100Cr 2  00                          .byte $00               ; E1
00100Dr 2  00                          .byte $00               ; E2
00100Er 2  00                          .byte $00               ; E3
00100Fr 2  00                          .byte $00               ; E4
001010r 2  00                          .byte $00               ; E5
001011r 2  08                          .byte $08               ; E6 bkspace
001012r 2  00                          .byte $00               ; E7
001013r 2  00                          .byte $00               ; E8
001014r 2  91                          .byte $91               ; E9 kp 1
001015r 2  7C                          .byte '|'               ; EA \|
001016r 2  94                          .byte $94               ; EB kp 4
001017r 2  97                          .byte $97               ; EC kp 7
001018r 2  00                          .byte $00               ; ED
001019r 2  00                          .byte $00               ; EE
00101Ar 2  00                          .byte $00               ; EF
00101Br 2  90                          .byte $90               ; F0 kp 0
00101Cr 2  7F                          .byte $7F               ; F1 kp .
00101Dr 2  92                          .byte $92               ; F2 kp 2
00101Er 2  95                          .byte $95               ; F3 kp 5
00101Fr 2  96                          .byte $96               ; F4 kp 6
001020r 2  98                          .byte $98               ; F5 kp 8
001021r 2  1B                          .byte $1B               ; F6 esc
001022r 2  00                          .byte $00               ; F7 num lock
001023r 2  CB                          .byte $CB               ; F8 F11
001024r 2  2B                          .byte $2B               ; F9 kp +
001025r 2  93                          .byte $93               ; FA kp 3
001026r 2  2D                          .byte $2D               ; FB kp -
001027r 2  2A                          .byte $2A               ; FC kp *
001028r 2  99                          .byte $99               ; FD kp 9
001029r 2  CD                          .byte $CD               ; FE scroll lock
00102Ar 2               ; NOT USED     .byte $00               ; FF
00102Ar 2               ; end
00102Ar 2               
00102Ar 2               
00102Ar 1                 .ENDPROC
00102Ar 1                 .PROC IRQ
00102Ar 1                   .INCLUDE "interrupt.s"
00102Ar 2               ; -------------------------------------------------------------------
00102Ar 2               ;                        MIRACOS INTERRUPT
00102Ar 2               ; -------------------------------------------------------------------
00102Ar 2               ; BCOSの割り込み関連部分
00102Ar 2               ; -------------------------------------------------------------------
00102Ar 2               
00102Ar 2               ; 通常より待ちの短い一文字送信。XOFF送信用。
00102Ar 2               ; 時間計算をしているわけではないがとにかくこれで動く
00102Ar 2               .macro prt_xoff
00102Ar 2                 PHX
00102Ar 2                 LDX #$80
00102Ar 2               SHORTDELAY:
00102Ar 2                 NOP
00102Ar 2                 NOP
00102Ar 2                 DEX
00102Ar 2                 BNE SHORTDELAY
00102Ar 2                 PLX
00102Ar 2                 LDA #UART::XOFF
00102Ar 2                 STA UART::TX
00102Ar 2               .endmac
00102Ar 2               
00102Ar 2               ; --- BCOS独自の割り込みハンドラ ---
00102Ar 2               IRQ_BCOS:
00102Ar 2                 ; SEIだけされてここに飛んだ
00102Ar 2                 ; おとなしく全部スタックに退避する
00102Ar 2  48             PHA
00102Br 2  DA             PHX
00102Cr 2  5A             PHY
00102Dr 2               ; --- 外部割込み判別 ---
00102Dr 2                 ; UART判定
00102Dr 2  AD 01 E0       LDA UART::STATUS
001030r 2  89 08          BIT #%00001000
001032r 2  F0 0B          BEQ SKP_UART       ; bit3の論理積がゼロ、つまりフルじゃない
001034r 2                 ; すなわち受信割り込み
001034r 2  AD 00 E0       LDA UART::RX        ; UARTから読み取り
001037r 2  20 rr rr       JSR TRAP            ; 制御トラップおよびエンキュー
00103Ar 2               PL_CLI_RTI:
00103Ar 2  7A             PLY
00103Br 2  FA             PLX
00103Cr 2  68             PLA
00103Dr 2  58             CLI
00103Er 2  40             RTI
00103Fr 2               SKP_UART:
00103Fr 2                 ; VIA判定
00103Fr 2  AD 0D E2       LDA VIA::IFR        ; 割り込みフラグレジスタ読み取り
001042r 2  4A             LSR                 ; C = bit 0 CA2
001043r 2  90 0E          BCC @SKP_CA2
001045r 2                 ; 垂直同期割り込み処理
001045r 2                 ; NOTE:ここにキーボード処理など
001045r 2                 ; PS/2は有効か
001045r 2  2F rr 08       BBR2 ZP_CON_DEV_CFG,@SKP_PS2TRAP
001048r 2                 ; PS/2処理
001048r 2  20 rr rr       JSR PS2::VBLANK
00104Br 2  F0 03          BEQ @SKP_PS2TRAP
00104Dr 2  20 rr rr       JSR TRAP
001050r 2               @SKP_PS2TRAP:
001050r 2  6C rr rr       JMP (VBLANK_USER_VEC16)
001053r 2               @SKP_CA2:
001053r 2                 ; T1検査
001053r 2  29 20          AND #%00100000      ; Z -> not T1（1右シフト済み）
001055r 2  F0 1A          BEQ @SKP_T1
001057r 2                 ; タイムアウト用カウントダウン
001057r 2  CE rr rr       DEC TIMEOUT_MS_CNT
00105Ar 2  D0 0B          BNE @SET_T1             ; 数え切らないうちはT1再設定
00105Cr 2                 ; タイムアウト発生
00105Cr 2  2C 04 E2       BIT VIA::T1CL           ; 割り込みフラグぽっきり
00105Fr 2                 ; スタックポインタ復帰
00105Fr 2  AE rr rr       LDX TIMEOUT_STACKPTR
001062r 2  9A             TXS
001063r 2                 ; 脱出
001063r 2  58             CLI
001064r 2  6C rr rr       JMP (TIMEOUT_EXIT_VEC16)
001067r 2               @SET_T1:
001067r 2                 ; T1タイマー設定
001067r 2  A9 40          LDA #TIMEOUT_T1H        ; フルの1/4で、8MHz時1ms
001069r 2  8D 05 E2       STA VIA::T1CH
00106Cr 2  9C 04 E2       STZ VIA::T1CL
00106Fr 2  80 C9          BRA PL_CLI_RTI          ; 終了
001071r 2               @SKP_T1:
001071r 2               
001071r 2               ; 不明な割り込みはデバッガへ
001071r 2               DONKI:
001071r 2  7A             PLY
001072r 2  FA             PLX
001073r 2  68             PLA
001074r 2  4C rr rr       JMP DONKI::ENT_DONKI
001077r 2               
001077r 2               ; 何もせずに垂直同期割り込みを終える
001077r 2               ; デフォルトでVBLANK_USER_VEC16に登録される
001077r 2               VBLANK_STUB:
001077r 2  AD 0D E2       LDA VIA::IFR
00107Ar 2  29 01          AND #%00000001      ; 割り込みフラグを折る
00107Cr 2  8D 0D E2       STA VIA::IFR
00107Fr 2  80 B9          BRA PL_CLI_RTI
001081r 2               
001081r 2               ; -------------------------------------------------------------------
001081r 2               ; BCOS 19             垂直同期割り込みハンドラ登録
001081r 2               ; -------------------------------------------------------------------
001081r 2               ; input   : AY = ptr
001081r 2               ; output  : AY = 垂直同期割り込みスタブルーチン
001081r 2               ;                 ルーチンの終わりにジャンプして片付けをやらせたり、
001081r 2               ;                 これを登録してハンドラ登録を抹消したりしてよい
001081r 2               ; -------------------------------------------------------------------
001081r 2               FUNC_IRQ_SETHNDR_VB:
001081r 2  8D rr rr 8C    storeAY16 VBLANK_USER_VEC16
001085r 2  rr rr        
001087r 2  A9 rr A0 rr    loadAY16 IRQ::VBLANK_STUB
00108Br 2  60             RTS
00108Cr 2               
00108Cr 2               ; -------------------------------------------------------------------
00108Cr 2               ;                     キャラクタ入力割り込み一般
00108Cr 2               ; -------------------------------------------------------------------
00108Cr 2               ; ASCIIを受け取り、制御キーをトラップし、キューに淹れる
00108Cr 2               ; -------------------------------------------------------------------
00108Cr 2               TRAP:
00108Cr 2  C9 03          CMP #$03
00108Er 2  D0 0A          BNE @SKP_C
001090r 2  A2 06          LDX #6
001092r 2               @LOOP:
001092r 2  68             PLA
001093r 2  CA             DEX
001094r 2  D0 FC          BNE @LOOP
001096r 2  58             CLI
001097r 2  4C rr rr       JMP FUNC_RESET
00109Ar 2               @SKP_C:
00109Ar 2               ENQ:
00109Ar 2  A6 rr          LDX ZP_CONINBF_WR_P     ; バッファの書き込み位置インデックス
00109Cr 2  9D rr rr       STA CONINBF_BASE,X      ; バッファへ書き込み
00109Fr 2  A6 rr          LDX ZP_CONINBF_LEN
0010A1r 2  E0 BF          CPX #$BF                ; バッファが3/4超えたら停止を求める
0010A3r 2  90 0E          BCC SKIP_RTSOFF         ; A < M BLT
0010A5r 2  DA A2 80 EA    prt_xoff                ; バッファがきついのでXoff送信
0010A9r 2  EA CA D0 FB  
0010ADr 2  FA A9 13 8D  
0010B3r 2               SKIP_RTSOFF:
0010B3r 2  E0 FF          CPX #$FF                ; バッファが完全に限界なら止める
0010B5r 2  D0 02          BNE @SKP_BRK
0010B7r 2  00             BRK
0010B8r 2  EA             NOP
0010B9r 2               @SKP_BRK:
0010B9r 2                 ; ポインタ増加
0010B9r 2  E6 rr          INC ZP_CONINBF_WR_P
0010BBr 2  E6 rr          INC ZP_CONINBF_LEN
0010BDr 2  60             RTS
0010BEr 2               
0010BEr 2               
0010BEr 1                 .ENDPROC
0010BEr 1               
0010BEr 1               ; -------------------------------------------------------------------
0010BEr 1               ;                       システムコールテーブル
0010BEr 1               ; -------------------------------------------------------------------
0010BEr 1               ; 別バイナリ（SYSCALL.BIN）で出力され、$0600にあとから配置される
0010BEr 1               ; -------------------------------------------------------------------
0010BEr 1               .SEGMENT "SYSCALL"
000000r 1               ; システムコール ジャンプテーブル $0600
000000r 1  4C rr rr       JMP FUNC_RESET
000003r 1               SYSCALL:
000003r 1  7C rr rr       JMP (SYSCALL_TABLE,X) ; 呼び出し規約：Xにコール番号*2を格納してJSR $0603
000006r 1               SYSCALL_TABLE:
000006r 1  rr rr          .WORD FUNC_RESET                ; 0 リセット、CCPロード部分に変更予定
000008r 1  rr rr          .WORD FUNC_CON_IN_CHR           ; 1 コンソール入力
00000Ar 1  rr rr          .WORD FUNC_CON_OUT_CHR          ; 2 コンソール出力
00000Cr 1  rr rr          .WORD FUNC_CON_RAWIN            ; 3 コンソール生入力
00000Er 1  rr rr          .WORD FUNC_CON_OUT_STR          ; 4 コンソール文字列出力
000010r 1  rr rr          .WORD FS::FUNC_FS_OPEN          ; 5 ファイル記述子オープン
000012r 1  rr rr          .WORD FS::FUNC_FS_CLOSE         ; 6 ファイル記述子クローズ
000014r 1  rr rr          .WORD FUNC_CON_IN_STR           ; 7 バッファ行入力
000016r 1  rr rr          .WORD GCHR::FUNC_GCHR_COL       ; 8 2色テキスト画面パレット操作
000018r 1  rr rr          .WORD FS::FUNC_FS_FIND_FST      ; 9 最初のエントリの検索
00001Ar 1  rr rr          .WORD FS::FUNC_FS_PURSE         ; 10 パス文字列の解析
00001Cr 1  rr rr          .WORD FS::FUNC_FS_CHDIR         ; 11 カレントディレクトリ変更
00001Er 1  rr rr          .WORD FS::FUNC_FS_FPATH         ; 12 絶対パス取得
000020r 1  rr rr          .WORD ERR::FUNC_ERR_GET         ; 13 エラー番号取得
000022r 1  rr rr          .WORD ERR::FUNC_ERR_MES         ; 14 エラー表示
000024r 1  rr rr          .WORD FUNC_UPPER_CHR            ; 15 小文字を大文字に
000026r 1  rr rr          .WORD FUNC_UPPER_STR            ; 16 文字列の小文字を大文字に
000028r 1  rr rr          .WORD FS::FUNC_FS_FIND_NXT      ; 17 次のエントリの検索
00002Ar 1  rr rr          .WORD FS::FUNC_FS_READ_BYTS     ; 18 バイト数指定ファイル読み取り
00002Cr 1  rr rr          .WORD IRQ::FUNC_IRQ_SETHNDR_VB  ; 19 垂直同期割り込みハンドラ登録
00002Er 1  rr rr          .WORD FUNC_GET_ADDR             ; 20 カーネル管理のアドレスを取得
000030r 1  rr rr          .WORD FUNC_CON_INTERRUPT_CHR    ; 21 コンソール入力キューに割り込む
000032r 1  rr rr          .WORD FUNC_TIMEOUT              ; 22 タイムアウトを設定
000034r 1               
000034r 1               ; -------------------------------------------------------------------
000034r 1               ;                       システムコールの実ルーチン
000034r 1               ; -------------------------------------------------------------------
000034r 1               ; 下位モジュールにもFUNC_ルーチンはある
000034r 1               ; -------------------------------------------------------------------
000034r 1               
000034r 1               .SEGMENT "COSCODE"
000000r 1               
000000r 1               ; -------------------------------------------------------------------
000000r 1               ; BCOS 0                        リセット
000000r 1               ; -------------------------------------------------------------------
000000r 1               ; BDOS 0
000000r 1               ; 各種モジュールを初期化して、CCPをロードし、CCPに飛ぶ
000000r 1               ; ホットスタートをするなら初期化処理はすっ飛ばすべきか？
000000r 1               ; -------------------------------------------------------------------
000000r 1               FUNC_RESET:
000000r 1  A9 0B          LDA #CONDEV::UART_IN|CONDEV::UART_OUT|CONDEV::GCON
000002r 1  85 rr          STA ZP_CON_DEV_CFG              ; 有効なコンソールデバイスの設定
000004r 1  20 rr rr       JSR FS::INIT                    ; ファイルシステムの初期化処理
000007r 1  20 rr rr       JSR GCON::INIT                  ; コンソール画面の初期化処理
00000Ar 1  78             SEI                             ; --- 割込みに関連する初期化
00000Br 1  20 rr rr       JSR BCOS_UART::INIT             ; UARTの初期化処理
00000Er 1                 ; コンソール入力バッファの初期化
00000Er 1  64 rr          STZ ZP_CONINBF_RD_P
000010r 1  64 rr          STZ ZP_CONINBF_WR_P
000012r 1  64 rr          STZ ZP_CONINBF_LEN
000014r 1                 ; 割り込みベクタ変更
000014r 1  A9 rr A0 rr    loadAY16 IRQ::IRQ_BCOS
000018r 1  8D rr rr 8C    storeAY16 ROM::IRQ_VEC16
00001Cr 1  rr rr        
00001Er 1                 ; 垂直同期割り込みを設定する
00001Er 1  A9 rr A0 rr    loadAY16 IRQ::VBLANK_STUB
000022r 1  8D rr rr 8C    storeAY16 VBLANK_USER_VEC16     ; 垂直同期ユーザベクタ変更
000026r 1  rr rr        
000028r 1  AD 0C E2       LDA VIA::PCR                    ; ポート制御端子の設定
00002Br 1  29 F1          AND #%11110001                  ; 321がCA2
00002Dr 1  09 02          ORA #%00000010                  ; 001＝独立した負の割り込みエッジ入力
00002Fr 1  8D 0C E2       STA VIA::PCR
000032r 1  AD 0E E2       LDA VIA::IER                    ; 割り込み許可
000035r 1  09 81          ORA #%10000001                  ; bit 0はCA2
000037r 1  8D 0E E2       STA VIA::IER
00003Ar 1  58             CLI                             ; --- 割込みに関連する初期化終わり
00003Br 1                 ; --- PS/2キーボードの初期化処理  タイムアウト付き
00003Br 1                 ; タイムアウト設定
00003Br 1  A9 rr 85 rr    loadmem16 ZR0,@INIT_PS2_END
00003Fr 1  A9 rr 85 rr  
000043r 1  A9 FF          LDA #PS2::INIT_TIMEOUT_MAX
000045r 1  20 rr rr       JSR FUNC_TIMEOUT
000048r 1  20 rr rr       JSR PS2::INIT                   ; PS/2キーボードの初期化処理
00004Br 1                 ; 成功！
00004Br 1                 ; タイムアウトオフ
00004Br 1  A9 00          LDA #0
00004Dr 1  20 rr rr       JSR FUNC_TIMEOUT
000050r 1                 ; PS/2KBデバイス有効化
000050r 1  A7 rr          SMB2 ZP_CON_DEV_CFG
000052r 1               @INIT_PS2_END:
000052r 1                 ; --- PS/2キーボードの初期化処理  ここまで
000052r 1                 .IF !SRECBUILD                  ; 分離部分の配置は、UARTロードの時は不要
000052r 1                   ; SYSCALL.SYSを配置する
000052r 1  A9 rr A0 rr      loadAY16 PATH_SYSCALL
000056r 1  20 rr rr         JSR FS::FUNC_FS_OPEN            ; フォントファイルをオープン
000059r 1  85 rr            STA ZR1
00005Br 1  48               PHA
00005Cr 1  A9 00 85 rr      loadmem16 ZR0,$0600             ; 書き込み先
000060r 1  A9 06 85 rr  
000064r 1  A9 00 A0 01      loadAY16  256                   ; 長さ
000068r 1  20 rr rr         JSR FS::FUNC_FS_READ_BYTS       ; ロード
00006Br 1  68               PLA
00006Cr 1  20 rr rr         JSR FS::FUNC_FS_CLOSE           ; クローズ
00006Fr 1                   ; CCP.SYSを配置する
00006Fr 1  A9 rr A0 rr      loadAY16 PATH_CCP
000073r 1  20 rr rr         JSR FS::FUNC_FS_OPEN            ; CCPをオープン
000076r 1  85 rr            STA ZR1
000078r 1  48               PHA
000079r 1  A9 00 85 rr      loadmem16 ZR0,$5000             ; 書き込み先
00007Dr 1  A9 50 85 rr  
000081r 1  A9 00 A0 04      loadAY16  1024                  ; 長さ決め打ち、長い分には害はないはず
000085r 1  20 rr rr         JSR FS::FUNC_FS_READ_BYTS       ; ロード
000088r 1  68               PLA
000089r 1  20 rr rr         JSR FS::FUNC_FS_CLOSE           ; クローズ
00008Cr 1                 .ENDIF
00008Cr 1  4C 00 50       JMP $5000                       ; CCP（仮）へ飛ぶ
00008Fr 1               
00008Fr 1               .IF !SRECBUILD
00008Fr 1  41 3A 2F 4D    PATH_SYSCALL:         .ASCIIZ "A:/MCOS/SYSCALL.SYS"
000093r 1  43 4F 53 2F  
000097r 1  53 59 53 43  
0000A3r 1  41 3A 2F 4D    PATH_CCP:             .ASCIIZ "A:/MCOS/CCP.SYS"
0000A7r 1  43 4F 53 2F  
0000ABr 1  43 43 50 2E  
0000B3r 1               .ENDIF
0000B3r 1               
0000B3r 1               ; -------------------------------------------------------------------
0000B3r 1               ; BCOS 1                  コンソール文字入力
0000B3r 1               ; -------------------------------------------------------------------
0000B3r 1               ; BDOS 1
0000B3r 1               ; 一文字入力する。なければ入力を待つ。
0000B3r 1               ; 何らかのキーで中断する？（CTRL+C？）
0000B3r 1               ; 使う場面がわからない…（改行もエコーするよこれ）
0000B3r 1               ; -------------------------------------------------------------------
0000B3r 1               FUNC_CON_IN_CHR:
0000B3r 1  A9 02          LDA #$2
0000B5r 1  20 rr rr       JSR FUNC_CON_RAWIN      ; 待機入力するがエコーしない
0000B8r 1  20 rr rr       JSR FUNC_CON_OUT_CHR    ; エコー
0000BBr 1  60             RTS
0000BCr 1               
0000BCr 1               ; -------------------------------------------------------------------
0000BCr 1               ; BCOS 2                  コンソール文字出力
0000BCr 1               ; -------------------------------------------------------------------
0000BCr 1               ; BDOS 2
0000BCr 1               ; input:A=char
0000BCr 1               ; コンソールから（CTRL+S）が押されると一時停止？
0000BCr 1               ; -------------------------------------------------------------------
0000BCr 1               FUNC_CON_OUT_CHR:
0000BCr 1  1F rr 03       BBR1  ZP_CON_DEV_CFG,@SKP_UART    ; UART_OUTが無効ならスキップ
0000BFr 1  20 rr rr       JSR BCOS_UART::OUT_CHR
0000C2r 1               @SKP_UART:
0000C2r 1  3F rr 05       BBR3  ZP_CON_DEV_CFG,@SKP_GCON    ; GCONが無効ならスキップ
0000C5r 1  48             PHA
0000C6r 1  20 rr rr       JSR GCON::PUTC
0000C9r 1  68             PLA
0000CAr 1               @SKP_GCON:
0000CAr 1  60             RTS
0000CBr 1               
0000CBr 1               ; -------------------------------------------------------------------
0000CBr 1               ; BCOS 6                 コンソール文字生入力
0000CBr 1               ; -------------------------------------------------------------------
0000CBr 1               ; BDOS 3
0000CBr 1               ; input:A=動作選択
0000CBr 1               ;   A=$0:コンソール入力状況を返す
0000CBr 1               ;   A=$1:コンソール入力があれば返すがエコーしない
0000CBr 1               ;   A=$2:文字入力があるまで待機して返し、エコーしない
0000CBr 1               ; output:A=獲得文字/$00（バッファなし）
0000CBr 1               ; -------------------------------------------------------------------
0000CBr 1               FUNC_CON_RAWIN:
0000CBr 1  89 FF          BIT #$FF
0000CDr 1  D0 03          BNE @NOT_BUFLEN
0000CFr 1                 ; 入力状況を返すだけ
0000CFr 1  A5 rr          LDA ZP_CONINBF_LEN
0000D1r 1  60             RTS
0000D2r 1               @NOT_BUFLEN:            ; 待機するかしないか、エコーせずに返す
0000D2r 1  6A             ROR
0000D3r 1  B0 0A          BCS @SKP_WAIT         ; FDでなければ（FFなら）待機はしない
0000D5r 1               @WAIT:
0000D5r 1                 ; 乱数の更新
0000D5r 1  E6 rr          INC ZP_RND16
0000D7r 1  D0 02          BNE @SKP_RNDH
0000D9r 1  E6 rr          INC ZP_RND16+1
0000DBr 1               @SKP_RNDH:
0000DBr 1  A5 rr          LDA ZP_CONINBF_LEN
0000DDr 1  F0 F6          BEQ @WAIT             ; バッファに何もないなら待つ
0000DFr 1               @SKP_WAIT:
0000DFr 1               C_RAWWAITIN:
0000DFr 1  A5 rr          LDA ZP_CONINBF_LEN
0000E1r 1  F0 19          BEQ END               ; バッファに何もないなら0を返す
0000E3r 1  A6 rr          LDX ZP_CONINBF_RD_P   ; インデックス
0000E5r 1  BD rr rr       LDA CONINBF_BASE,X    ; バッファから読む、ここからRTSまでA使わない
0000E8r 1  E6 rr          INC ZP_CONINBF_RD_P   ; 読み取りポインタ増加
0000EAr 1  C6 rr          DEC ZP_CONINBF_LEN    ; 残りバッファ減少
0000ECr 1  A6 rr          LDX ZP_CONINBF_LEN
0000EEr 1  E0 80          CPX #$80              ; LEN - $80
0000F0r 1  D0 0A          BNE END               ; バッファに余裕があれば毎度XON送ってた…？
0000F2r 1                 ; UARTが有効なら、RTS再開
0000F2r 1  0F rr 07       BBR0 ZP_CON_DEV_CFG,END
0000F5r 1  48             PHA
0000F6r 1  A9 11          LDA #UART::XON
0000F8r 1  20 rr rr       JSR BCOS_UART::OUT_CHR
0000FBr 1  68             PLA
0000FCr 1               END:
0000FCr 1  60             RTS
0000FDr 1               
0000FDr 1               ; -------------------------------------------------------------------
0000FDr 1               ; BCOS 21               コンソール文字入力割込み
0000FDr 1               ; -------------------------------------------------------------------
0000FDr 1               ; input:A=エンキューする文字
0000FDr 1               ; -------------------------------------------------------------------
0000FDr 1               FUNC_CON_INTERRUPT_CHR:
0000FDr 1  20 rr rr       JSR IRQ::TRAP
000100r 1  60             RTS
000101r 1               
000101r 1               ; -------------------------------------------------------------------
000101r 1               ; BCOS 4                 コンソール文字列出力
000101r 1               ; -------------------------------------------------------------------
000101r 1               ; input:AY=str
000101r 1               ; コンソールから（CTRL+S）が押されると一時停止？
000101r 1               ; -------------------------------------------------------------------
000101r 1               FUNC_CON_OUT_STR:
000101r 1  85 rr          STA ZR5
000103r 1  84 rr          STY ZR5+1                   ; ZR5を文字列インデックスに
000105r 1  A0 FF          LDY #$FF
000107r 1               @LOOP:
000107r 1  C8             INY
000108r 1  B1 rr          LDA (ZR5),Y                 ; 文字をロード
00010Ar 1  F0 F0          BEQ END                     ; ヌルなら終わり
00010Cr 1  5A             PHY
00010Dr 1  20 rr rr       JSR FUNC_CON_OUT_CHR        ; 文字を表示（独自にした方が効率的かも）
000110r 1  7A             PLY
000111r 1  C0 FF          CPY #$FF
000113r 1  D0 F2          BNE @LOOP                   ; #$FFに到達しないまではそのままループ
000115r 1  E6 rr          INC ZR5+1                   ; 次のページへ
000117r 1  80 EE          BRA @LOOP                   ; ループ
000119r 1               
000119r 1               ; -------------------------------------------------------------------
000119r 1               ; BCOS 7               コンソールバッファ行入力
000119r 1               ; -------------------------------------------------------------------
000119r 1               ; input   : AY   = buff
000119r 1               ;           ZR0L = バッファ長さ（1～255）
000119r 1               ; output  : A    = 実際に入力された字数
000119r 1               ; TODO:バックスペースや矢印キーを用いた行編集機能
000119r 1               ; -------------------------------------------------------------------
000119r 1               FUNC_CON_IN_STR:
000119r 1  85 rr 84 rr    storeAY16 ZR1         ; ZR1をバッファインデックスに
00011Dr 1  A0 FF          LDY #$FF
00011Fr 1               @NEXT:
00011Fr 1  C8             INY
000120r 1  5A             PHY
000121r 1  A9 02          LDA #$2
000123r 1  20 rr rr       JSR FUNC_CON_RAWIN    ; 入力待機するがエコーしない
000126r 1  7A             PLY
000127r 1  C9 0A          CMP #$A               ; 改行か？
000129r 1  F0 15          BEQ @END              ; 改行なら行入力終了
00012Br 1  C9 08          CMP #$8               ; ^H(BS)か？
00012Dr 1  D0 08          BNE @WRITE            ; なら直下のバックスペース処理
00012Fr 1  88             DEY                   ; 後退（先行INY打消し
000130r 1  C0 FF          CPY #$FF                ; Y=0ならそれ以上後退できない
000132r 1  F0 EB          BEQ @NEXT             ; ので無視
000134r 1  88             DEY                   ; 後退（本質
000135r 1  80 02          BRA @ECHO             ; バッファには書き込まず、エコーのみ
000137r 1               @WRITE:
000137r 1  91 rr          STA (ZR1),Y           ; バッファに書き込み
000139r 1               @ECHO:
000139r 1  5A             PHY
00013Ar 1  20 rr rr       JSR FUNC_CON_OUT_CHR  ; エコー出力
00013Dr 1  7A             PLY
00013Er 1  80 DF          BRA @NEXT
000140r 1               @END:
000140r 1  A9 00          LDA #0
000142r 1  91 rr          STA (ZR1),Y           ; 終端挿入
000144r 1  88             DEY
000145r 1  98             TYA                   ; 入力された字数を返す
000146r 1  60             RTS
000147r 1               
000147r 1               ; -------------------------------------------------------------------
000147r 1               ; BCOS 15                大文字小文字変換
000147r 1               ; -------------------------------------------------------------------
000147r 1               ; input   : A = chr
000147r 1               ; -------------------------------------------------------------------
000147r 1               FUNC_UPPER_CHR:
000147r 1  C9 61          CMP #'a'
000149r 1  30 07          BMI @EXT
00014Br 1  C9 7B          CMP #'z'+1
00014Dr 1  10 03          BPL @EXT
00014Fr 1  38             SEC
000150r 1  E9 20          SBC #'a'-'A'
000152r 1               @EXT:
000152r 1  60             RTS
000153r 1               
000153r 1               ; -------------------------------------------------------------------
000153r 1               ; BCOS 16                大文字小文字変換（文字列）
000153r 1               ; -------------------------------------------------------------------
000153r 1               ; input   : AY = buf
000153r 1               ; -------------------------------------------------------------------
000153r 1               FUNC_UPPER_STR:
000153r 1  85 rr 84 rr    storeAY16 ZR0
000157r 1  A0 FF          LDY #$FF
000159r 1               @LOOP:
000159r 1  C8             INY
00015Ar 1  B1 rr          LDA (ZR0),Y
00015Cr 1  F0 07          BEQ @END
00015Er 1  20 rr rr       JSR FUNC_UPPER_CHR
000161r 1  91 rr          STA (ZR0),Y
000163r 1  80 F4          BRA @LOOP
000165r 1               @END:
000165r 1  60             RTS
000166r 1               
000166r 1               ; -------------------------------------------------------------------
000166r 1               ; BCOS 20                    アドレス取得
000166r 1               ; -------------------------------------------------------------------
000166r 1               ; input     : Y   = 0*2 : ZP_RND16            16bit乱数
000166r 1               ;                 = 1*2 : TXTVRAM768          テキストVRAM
000166r 1               ;                 = 2*2 : FONT2048            フォントグリフエリア
000166r 1               ;                 = 3*3 : ZP_CON_DEV_CFG      コンソールデバイス設定
000166r 1               ; output    : AY = ptr
000166r 1               ; -------------------------------------------------------------------
000166r 1               FUNC_GET_ADDR:
000166r 1  BE rr rr       LDX OPEN_ADDR_TABLE,Y
000169r 1  B9 rr rr       LDA OPEN_ADDR_TABLE+1,Y
00016Cr 1  A8             TAY
00016Dr 1  8A             TXA
00016Er 1  60             RTS
00016Fr 1               
00016Fr 1               OPEN_ADDR_TABLE:
00016Fr 1  rr rr          .WORD ZP_RND16          ; 0
000171r 1  rr rr          .WORD TXTVRAM768        ; 1
000173r 1  rr rr          .WORD FONT2048          ; 2
000175r 1  rr rr          .WORD ZP_CON_DEV_CFG    ; 3
000177r 1               
000177r 1               ; -------------------------------------------------------------------
000177r 1               ; BCOS 22                 タイムアウト設定
000177r 1               ; -------------------------------------------------------------------
000177r 1               ; input     : A   = タイムアウト期間（ミリ秒）
000177r 1               ;           : ZR0 = 脱出先アドレス
000177r 1               ; output    : A   = 可否？
000177r 1               ; -------------------------------------------------------------------
000177r 1               FUNC_TIMEOUT:
000177r 1                 ; ゼロチェック
000177r 1  C9 00          CMP #0
000179r 1  D0 04          BNE @SKP_OFF
00017Br 1                 ; ゼロ時間が指定されたので起動したタイマーを無効化
00017Br 1  A9 40          LDA #VIA::IFR_T1               ; T1割込みを無効に
00017Dr 1  80 15          BRA @SET_IER
00017Fr 1               @SKP_OFF:
00017Fr 1                 ; スタックポインタを保存
00017Fr 1  BA             TSX
000180r 1  E8             INX ; システムコールでのフレームを破棄
000181r 1  E8             INX
000182r 1  8E rr rr       STX TIMEOUT_STACKPTR
000185r 1                 ; 引数を変数領域に格納
000185r 1  8D rr rr       STA TIMEOUT_MS_CNT
000188r 1  A5 rr 8D rr    mem2mem16 TIMEOUT_EXIT_VEC16,ZR0
00018Cr 1  rr A5 rr 8D  
000190r 1  rr rr        
000192r 1                 ; タイマーを起動
000192r 1                 ; IER=割込み有効レジスタ
000192r 1  A9 C0          LDA #(VIA::IER_SET|VIA::IFR_T1)   ; T1割込みを有効に
000194r 1               @SET_IER:
000194r 1  8D 0E E2       STA VIA::IER
000197r 1                 ; ACR=補助制御レジスタ
000197r 1  AD 0B E2       LDA VIA::ACR
00019Ar 1  29 3F          AND #%00111111                    ; 76=00でT1時限割込み
00019Cr 1  8D 0B E2       STA VIA::ACR
00019Fr 1                 ; T1タイマー
00019Fr 1  A9 40          LDA #TIMEOUT_T1H                  ; フルの1/4で、8MHz時1ms
0001A1r 1  8D 05 E2       STA VIA::T1CH
0001A4r 1  9C 04 E2       STZ VIA::T1CL
0001A7r 1  60             RTS
0001A8r 1               
0001A8r 1               
