ca65 V2.16 - Ubuntu 2.16-2
Main file   : ./com/conconfg.s
Current file: ./com/conconfg.s

000000r 1               ; -------------------------------------------------------------------
000000r 1               ;                          CONCONFGコマンド
000000r 1               ; -------------------------------------------------------------------
000000r 1               ; コンソールを構成するデバイスの有効無効を設定するツール
000000r 1               ; コマンドライン引数に従ってコンソールデバイスの設定をする
000000r 1               ; コマンドライン引数のありなしにかかわらず変更後の設定を表示する
000000r 1               ; [コマンドライン引数の構文]
000000r 1               ; A:>CONCONFG 0=1 2=0
000000r 1               ;           : <コンソールデバイス番号>=<0(OFF)or1(on)>
000000r 1               ;           : 複数の設定を同時に処理可能
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
000000r 1               .PROC CONDEV
000000r 1                 ; ZP_CON_DEV_CFGでのコンソールデバイス
000000r 1                 UART_IN   = %00000001
000000r 1                 UART_OUT  = %00000010
000000r 1                 PS2       = %00000100
000000r 1                 GCON      = %00001000
000000r 1               .ENDPROC
000000r 1               
000000r 1               ; -------------------------------------------------------------------
000000r 1               ;                            ZP変数領域
000000r 1               ; -------------------------------------------------------------------
000000r 1               .ZEROPAGE
000000r 1  xx xx        ZP_CONCFG_ADDR16:         .RES 2  ; 取得した設定値のアドレス
000002r 1  xx           ZP_SHIFT:                 .RES 1  ; 設定値をシフトしてビット処理
000003r 1  xx xx        ZP_ARG:                   .RES 2  ; コマンドライン引数
000005r 1  xx           ZP_DEVNUM:                .RES 1  ; 処理すべきかもしれないコマンド番号
000006r 1               
000006r 1               ; -------------------------------------------------------------------
000006r 1               ;                             実行領域
000006r 1               ; -------------------------------------------------------------------
000006r 1               .CODE
000000r 1  85 rr 84 rr    storeAY16 ZP_ARG
000004r 1                 ; 設定メモリのアドレスを取得
000004r 1  A0 06          LDY #BCOS::BHY_GET_ADDR_condevcfg   ; コンソールデバイス設定のアドレスを要求
000006r 1  A2 28 20 03    syscall GET_ADDR                    ; アドレス要求
00000Ar 1  06           
00000Br 1  85 rr 84 rr    storeAY16 ZP_CONCFG_ADDR16          ; アドレス保存
00000Fr 1                 ; コマンドライン引数を処理
00000Fr 1  A0 00          LDY #0
000011r 1               LOOP:
000011r 1  C8             INY
000012r 1  F0 1B          BEQ @END_CHANGE
000014r 1  B1 rr          LDA (ZP_ARG),Y
000016r 1  F0 17          BEQ @END_CHANGE
000018r 1  C9 3D          CMP #'='
00001Ar 1  D0 F5          BNE LOOP
00001Cr 1                 ; Y='='
00001Cr 1  88             DEY
00001Dr 1  B1 rr          LDA (ZP_ARG),Y      ; 左辺を取得
00001Fr 1  85 rr          STA ZP_DEVNUM
000021r 1  C8             INY
000022r 1  C8             INY
000023r 1  B1 rr          LDA (ZP_ARG),Y      ; 右辺を取得
000025r 1  C9 30          CMP #'0'
000027r 1  F0 3A          BEQ OFF
000029r 1  C9 31          CMP #'1'
00002Br 1  F0 23          BEQ ON
00002Dr 1  80 E2          BRA LOOP
00002Fr 1               @END_CHANGE:
00002Fr 1                 ; 設定の表示
00002Fr 1                 ; 設定の取得
00002Fr 1  B2 rr          LDA (ZP_CONCFG_ADDR16)
000031r 1  85 rr          STA ZP_SHIFT
000033r 1                 ; 0 UART_IN
000033r 1  A9 rr A0 rr    loadAY16 STR_UART_IN
000037r 1  20 rr rr       JSR OUT_TAG_ON_OFF
00003Ar 1                 ; 1 UART_OUT
00003Ar 1  A9 rr A0 rr    loadAY16 STR_UART_OUT
00003Er 1  20 rr rr       JSR OUT_TAG_ON_OFF
000041r 1                 ; 2 PS2
000041r 1  A9 rr A0 rr    loadAY16 STR_PS2
000045r 1  20 rr rr       JSR OUT_TAG_ON_OFF
000048r 1                 ; 3 GCON
000048r 1  A9 rr A0 rr    loadAY16 STR_GCON
00004Cr 1  20 rr rr       JSR OUT_TAG_ON_OFF
00004Fr 1  60             RTS
000050r 1               
000050r 1               ON:
000050r 1  A5 rr          LDA ZP_DEVNUM
000052r 1  38             SEC
000053r 1  E9 30          SBC #'0'
000055r 1  C9 08          CMP #8          ; num-8
000057r 1  B0 B8          BCS LOOP        ; 8以上では困る
000059r 1  AA             TAX
00005Ar 1  BD rr rr       LDA ONEHOT,X
00005Dr 1  12 rr          ORA (ZP_CONCFG_ADDR16)
00005Fr 1  92 rr          STA (ZP_CONCFG_ADDR16)
000061r 1  80 AE          BRA LOOP
000063r 1               
000063r 1               OFF:
000063r 1  A5 rr          LDA ZP_DEVNUM
000065r 1  38             SEC
000066r 1  E9 30          SBC #'0'
000068r 1  C9 08          CMP #8          ; num-8
00006Ar 1  B0 A5          BCS LOOP        ; 8以上では困る
00006Cr 1  AA             TAX
00006Dr 1  BD rr rr       LDA ONEHOT,X
000070r 1  49 FF          EOR #$FF
000072r 1  32 rr          AND (ZP_CONCFG_ADDR16)
000074r 1  92 rr          STA (ZP_CONCFG_ADDR16)
000076r 1  80 99          BRA LOOP
000078r 1               
000078r 1               ONEHOT:
000078r 1  01             .BYT %00000001
000079r 1  02             .BYT %00000010
00007Ar 1  04             .BYT %00000100
00007Br 1  08             .BYT %00001000
00007Cr 1  10             .BYT %00010000
00007Dr 1  20             .BYT %00100000
00007Er 1  40             .BYT %01000000
00007Fr 1  80             .BYT %10000000
000080r 1               
000080r 1               OUT_TAG_ON_OFF:
000080r 1  A2 08 20 03    syscall CON_OUT_STR
000084r 1  06           
000085r 1  46 rr          LSR ZP_SHIFT
000087r 1  90 0A          BCC @OFF
000089r 1               @ON:
000089r 1  A9 rr A0 rr    loadAY16 STR_ON
00008Dr 1  A2 08 20 03    syscall CON_OUT_STR
000091r 1  06           
000092r 1  60             RTS
000093r 1               @OFF:
000093r 1  A9 rr A0 rr    loadAY16 STR_OFF
000097r 1  A2 08 20 03    syscall CON_OUT_STR
00009Br 1  06           
00009Cr 1  60             RTS
00009Dr 1               
00009Dr 1  30 29 55 41  STR_UART_IN:    .BYT  "0)UART-Input    : ",0
0000A1r 1  52 54 2D 49  
0000A5r 1  6E 70 75 74  
0000B0r 1  31 29 55 41  STR_UART_OUT:   .BYT  "1)UART-Output   : ",0
0000B4r 1  52 54 2D 4F  
0000B8r 1  75 74 70 75  
0000C3r 1  32 29 50 53  STR_PS2:        .BYT  "2)PS/2-Keyboard : ",0
0000C7r 1  2F 32 2D 4B  
0000CBr 1  65 79 62 6F  
0000D6r 1  33 29 47 43  STR_GCON:       .BYT  "3)GCON-Monitor  : ",0
0000DAr 1  4F 4E 2D 4D  
0000DEr 1  6F 6E 69 74  
0000E9r 1  4F 4E 0A 00  STR_ON:         .BYT  "ON",$A,0
0000EDr 1  4F 46 46 0A  STR_OFF:        .BYT  "OFF",$A,0
0000F1r 1  00           
0000F2r 1               
0000F2r 1               
