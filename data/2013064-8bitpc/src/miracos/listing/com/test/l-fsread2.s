ca65 V2.16 - Ubuntu 2.16-2
Main file   : ./com/test/fsread2.s
Current file: ./com/test/fsread2.s

000000r 1               ; -------------------------------------------------------------------
000000r 1               ;                           FSREAD2コマンド
000000r 1               ; -------------------------------------------------------------------
000000r 1               ; 新しいリードファンクションのテスト用
000000r 1               ; 実装されたら動かなくなるかも
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
000000r 1               .INCLUDE "../zr.inc"
000000r 2               ZR0 = $0000
000000r 2               ZR1 = $0002
000000r 2               ZR2 = $0004
000000r 2               ZR3 = $0006
000000r 2               ZR4 = $0008
000000r 2               ZR5 = $000A
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
000000r 1               ;                             定数定義
000000r 1               ; -------------------------------------------------------------------
000000r 1               BFPTR   = BUFFER
000000r 1               
000000r 1               ; -------------------------------------------------------------------
000000r 1               ;                             変数領域
000000r 1               ; -------------------------------------------------------------------
000000r 1               .BSS
000000r 1  xx             FD_SAV:         .RES 1  ; ファイル記述子
000001r 1  xx xx          FINFO_SAV:      .RES 2  ; FINFO
000003r 1  xx xx          FCTRL_SAV:      .RES 2
000005r 1  xx xx          ACTLEN:         .RES 2
000007r 1  xx xx          REQLEN:         .RES 2
000009r 1  xx xx          SDSEEK:         .RES 2
00000Br 1  xx xx          BFPTR_NEW:          .RES 2
00000Dr 1               
00000Dr 1               ; -------------------------------------------------------------------
00000Dr 1               ;                             実行領域
00000Dr 1               ; -------------------------------------------------------------------
00000Dr 1               .CODE
000000r 1               START:
000000r 1  48 5A          pushAY16
000002r 1                 ; 挨拶
000002r 1  A9 rr A0 rr    loadAY16 STR_HELLO
000006r 1  A2 08 20 03    syscall CON_OUT_STR
00000Ar 1  06           
00000Br 1  7A 68          pullAY16
00000Dr 1                 ; nullチェック
00000Dr 1  85 00 84 01    storeAY16 ZR0
000011r 1  AA             TAX
000012r 1  B2 00          LDA (ZR0)
000014r 1  F0 03          BEQ @TEST_TXT ; コマンドライン引数がないならデフォルトのパス
000016r 1  8A             TXA
000017r 1  80 04          BRA @ARG
000019r 1               @TEST_TXT:
000019r 1  A9 rr A0 rr    loadAY16 PATH_DATA
00001Dr 1               @ARG:
00001Dr 1                 ; ファイル検索
00001Dr 1  A2 12 20 03    syscall FS_FIND_FST             ; 検索
000021r 1  06           
000022r 1                 ;BCS NOTFOUND                    ; 見つからなかったらあきらめる
000022r 1  90 03          BCC @SKP_NOTFOUND
000024r 1  4C rr rr       JMP NOTFOUND
000027r 1               @SKP_NOTFOUND:
000027r 1  8D rr rr 8C    storeAY16 FINFO_SAV             ; FINFOを格納
00002Br 1  rr rr        
00002Dr 1                 ; ファイルオープン
00002Dr 1  A2 0A 20 03    syscall FS_OPEN                 ; ファイルをオープン
000031r 1  06           
000032r 1                 ;BCS NOTFOUND                    ; オープンできなかったらあきらめる
000032r 1  90 03          BCC @SKP_NOTFOUND2
000034r 1  4C rr rr       JMP NOTFOUND
000037r 1               @SKP_NOTFOUND2:
000037r 1  8D rr rr       STA FD_SAV                      ; ファイル記述子をセーブ
00003Ar 1                 ; ファイル記述子の報告
00003Ar 1  A9 rr A0 rr    loadAY16 STR_GOT_FD
00003Er 1  A2 08 20 03    syscall CON_OUT_STR
000042r 1  06           
000043r 1  AD rr rr       LDA FD_SAV
000046r 1  20 rr rr       JSR PRT_BYT
000049r 1  20 rr rr       JSR PRT_LF
00004Cr 1                 ; 要求LENGTHの入力
00004Cr 1                 ; LENGTH?プロンプト
00004Cr 1               @INPUT_LENGTH:
00004Cr 1  A9 rr A0 rr    loadAY16 STR_LENGTH
000050r 1  A2 08 20 03    syscall CON_OUT_STR
000054r 1  06           
000055r 1                 ; 文字列入力
000055r 1  A9 08          LDA #8                          ; 入力バッファ長さは8
000057r 1  85 00          STA ZR0
000059r 1  A9 rr A0 rr    loadAY16 INSTR_BF               ; 入力バッファのポインタ
00005Dr 1  A2 0E 20 03    syscall CON_IN_STR
000061r 1  06           
000062r 1                 ; 文字列の変換
000062r 1  A9 rr A0 rr    loadAY16 INSTR_BF               ; 入力バッファのポインタ
000066r 1  20 rr rr       JSR STR2NUM
000069r 1  B0 E1          BCS @INPUT_LENGTH               ; 失敗したらリトライ
00006Br 1  A5 02 8D rr    mem2mem16 REQLEN,ZR1
00006Fr 1  rr A5 03 8D  
000073r 1  rr rr        
000075r 1  20 rr rr       JSR PRT_LF
000078r 1                 ; コール
000078r 1  AD rr rr       LDA FD_SAV
00007Br 1  85 02          STA ZR1
00007Dr 1  A9 rr 85 00    loadmem16 ZR0,BFPTR
000081r 1  A9 rr 85 01  
000085r 1  AD rr rr AC    mem2AY16 REQLEN
000089r 1  rr rr        
00008Br 1  A2 24 20 03    syscall FS_READ_BYTS            ; コール
00008Fr 1  06           
000090r 1  90 03          BCC @SKP_EOF
000092r 1  4C rr rr       JMP @EOF
000095r 1               @SKP_EOF:
000095r 1  8D rr rr 8C    storeAY16 FCTRL_SAV             ; FCTRLを取得
000099r 1  rr rr        
00009Br 1  A5 04 8D rr    mem2mem16 ACTLEN,ZR2            ; 16bit値を保存
00009Fr 1  rr A5 05 8D  
0000A3r 1  rr rr        
0000A5r 1  A5 00 8D rr    mem2mem16 SDSEEK,ZR0
0000A9r 1  rr A5 01 8D  
0000ADr 1  rr rr        
0000AFr 1  A5 06 8D rr    mem2mem16 BFPTR_NEW,ZR3
0000B3r 1  rr A5 07 8D  
0000B7r 1  rr rr        
0000B9r 1                 ; FCTRL表示
0000B9r 1                 ; FCTRL_SIZラベル
0000B9r 1  A9 rr A0 rr    loadAY16 STR_FCTRL_SIZ
0000BDr 1  A2 08 20 03    syscall CON_OUT_STR
0000C1r 1  06           
0000C2r 1                 ; FCTRL_SIZ
0000C2r 1  A9 0A          LDA #FCTRL::SIZ
0000C4r 1  6D rr rr       ADC FCTRL_SAV
0000C7r 1  AC rr rr       LDY FCTRL_SAV+1
0000CAr 1  20 rr rr       JSR PRT_LONG_LF
0000CDr 1                 ; FCTRL_SEEKラベル
0000CDr 1  A9 rr A0 rr    loadAY16 STR_FCTRL_SEEK
0000D1r 1  A2 08 20 03    syscall CON_OUT_STR
0000D5r 1  06           
0000D6r 1                 ; FCTRL_SEEK
0000D6r 1  A9 0E          LDA #FCTRL::SEEK_PTR
0000D8r 1  6D rr rr       ADC FCTRL_SAV
0000DBr 1  AC rr rr       LDY FCTRL_SAV+1
0000DEr 1  20 rr rr       JSR PRT_LONG_LF
0000E1r 1                 ; ACTLENラベル
0000E1r 1  A9 rr A0 rr    loadAY16 STR_ACTLEN
0000E5r 1  A2 08 20 03    syscall CON_OUT_STR
0000E9r 1  06           
0000EAr 1                 ; ACTLEN
0000EAr 1  A9 rr A0 rr    loadAY16 ACTLEN
0000EEr 1  20 rr rr       JSR PRT_SHORT_LF
0000F1r 1                 ; SDSEEKラベル
0000F1r 1  A9 rr A0 rr    loadAY16 STR_SDSEEK
0000F5r 1  A2 08 20 03    syscall CON_OUT_STR
0000F9r 1  06           
0000FAr 1                 ; SDSEEK
0000FAr 1  A9 rr A0 rr    loadAY16 SDSEEK
0000FEr 1  20 rr rr       JSR PRT_SHORT_LF
000101r 1                 ; BFPTRラベル
000101r 1  A9 rr A0 rr    loadAY16 STR_BFPTR
000105r 1  A2 08 20 03    syscall CON_OUT_STR
000109r 1  06           
00010Ar 1                 ; BFPTR
00010Ar 1  A9 rr A0 rr    loadAY16 BFPTR_NEW
00010Er 1  20 rr rr       JSR PRT_SHORT_LF
000111r 1                 ; 受信文字列
000111r 1  A9 rr A0 rr    loadAY16 BUFFER
000115r 1  A2 08 20 03    syscall CON_OUT_STR
000119r 1  06           
00011Ar 1                 ; bra
00011Ar 1  4C rr rr       JMP @INPUT_LENGTH
00011Dr 1               @EOF:
00011Dr 1                 ; ファイルクローズ
00011Dr 1  AD rr rr       LDA FD_SAV
000120r 1  A2 0C 20 03    syscall FS_CLOSE
000124r 1  06           
000125r 1  60             RTS
000126r 1               
000126r 1               ; ファイルが見つからないとか開けないとか
000126r 1               NOTFOUND:
000126r 1  A9 rr A0 rr    loadAY16 STR_NOTFOUND
00012Ar 1  A2 08 20 03    syscall CON_OUT_STR
00012Er 1  06           
00012Fr 1  60             RTS
000130r 1               
000130r 1               ; カーネルエラーの表示
000130r 1               BCOS_ERROR:
000130r 1  20 rr rr       JSR PRT_LF
000133r 1  A2 1A 20 03    syscall ERR_GET
000137r 1  06           
000138r 1  A2 1C 20 03    syscall ERR_MES
00013Cr 1  06           
00013Dr 1  60             RTS
00013Er 1               
00013Er 1               ; ASCII文字列をHEXと信じて変換
00013Er 1               STR2NUM:
00013Er 1                 @STR_PTR=ZR0
00013Er 1                 @NUMBER16=ZR1
00013Er 1  85 00 84 01    storeAY16 @STR_PTR
000142r 1  64 02          STZ ZR1
000144r 1  64 03          STZ ZR1+1
000146r 1                 ; 最後尾まで探索、余計な文字があったらエラー
000146r 1  A0 FF          LDY #$FF
000148r 1               @FIND_EOS_LOOP:
000148r 1  C8             INY
000149r 1  B1 00          LDA (@STR_PTR),Y
00014Br 1  D0 FB          BNE @FIND_EOS_LOOP
00014Dr 1               @END_OF_STR:
00014Dr 1                 ; Y=\0
00014Dr 1  A2 00          LDX #0
00014Fr 1               @BYT_LOOP:
00014Fr 1                 ; 下位nibble
00014Fr 1  88             DEY
000150r 1  C0 FF          CPY #$FF
000152r 1  F0 20          BEQ @END
000154r 1  B1 00          LDA (@STR_PTR),Y
000156r 1  20 rr rr       JSR CHR2NIB
000159r 1  B0 1B          BCS @ERR
00015Br 1  95 02          STA ZR1,X
00015Dr 1                 ; 上位nibble
00015Dr 1  88             DEY
00015Er 1  C0 FF          CPY #$FF
000160r 1  F0 12          BEQ @END
000162r 1  B1 00          LDA (@STR_PTR),Y
000164r 1  20 rr rr       JSR CHR2NIB
000167r 1  B0 0D          BCS @ERR
000169r 1  0A             ASL
00016Ar 1  0A             ASL
00016Br 1  0A             ASL
00016Cr 1  0A             ASL
00016Dr 1  15 02          ORA ZR1,X
00016Fr 1  95 02          STA ZR1,X
000171r 1  E8             INX
000172r 1  80 DB          BRA @BYT_LOOP
000174r 1               @END:
000174r 1  18             CLC
000175r 1  60             RTS
000176r 1               @ERR:
000176r 1  38             SEC
000177r 1  60             RTS
000178r 1               
000178r 1               ; *
000178r 1               ; --- Aレジスタの一文字をNibbleとして値にする ---
000178r 1               ; *
000178r 1               CHR2NIB:
000178r 1  C9 30          CMP #'0'
00017Ar 1  30 16          BMI @ERR
00017Cr 1  C9 3A          CMP #'9'+1
00017Er 1  10 05          BPL @ABCDEF
000180r 1  38             SEC
000181r 1  E9 30          SBC #'0'
000183r 1  18             CLC
000184r 1  60             RTS
000185r 1               @ABCDEF:
000185r 1  C9 41          CMP #'A'
000187r 1  30 09          BMI @ERR
000189r 1  C9 47          CMP #'F'+1
00018Br 1  10 05          BPL @ERR
00018Dr 1  38             SEC
00018Er 1  E9 37          SBC #'A'-$0A
000190r 1  18             CLC
000191r 1  60             RTS
000192r 1               @ERR:
000192r 1  38             SEC
000193r 1  60             RTS
000194r 1               
000194r 1               ; 16bit値を表示+改行
000194r 1               PRT_SHORT_LF:
000194r 1  85 04 84 05    storeAY16 ZR2
000198r 1  A0 01          LDY #1
00019Ar 1  B1 04          LDA (ZR2),Y
00019Cr 1  20 rr rr       JSR PRT_BYT
00019Fr 1  A0 00          LDY #0
0001A1r 1  B1 04          LDA (ZR2),Y
0001A3r 1  20 rr rr       JSR PRT_BYT
0001A6r 1  4C rr rr       JMP PRT_LF
0001A9r 1               
0001A9r 1               ; 32bit値を表示+改行
0001A9r 1               PRT_LONG_LF:
0001A9r 1  20 rr rr       JSR PRT_LONG
0001ACr 1  4C rr rr       JMP PRT_LF
0001AFr 1               
0001AFr 1               ; 32bit値を表示
0001AFr 1               PRT_LONG:
0001AFr 1  85 04 84 05    storeAY16 ZR2
0001B3r 1  A0 03          LDY #3
0001B5r 1               @LOOP:
0001B5r 1  B1 04          LDA (ZR2),Y
0001B7r 1  5A             PHY
0001B8r 1  20 rr rr       JSR PRT_BYT
0001BBr 1  7A             PLY
0001BCr 1  88             DEY
0001BDr 1  10 F6          BPL @LOOP
0001BFr 1  60             RTS
0001C0r 1               
0001C0r 1               ; 8bit値を表示
0001C0r 1               PRT_BYT:
0001C0r 1  20 rr rr       JSR BYT2ASC
0001C3r 1  5A             PHY
0001C4r 1  20 rr rr       JSR PRT_C_CALL
0001C7r 1  68             PLA
0001C8r 1               PRT_C_CALL:
0001C8r 1  A2 04 20 03    syscall CON_OUT_CHR
0001CCr 1  06           
0001CDr 1  60             RTS
0001CEr 1               
0001CEr 1               ; 改行
0001CEr 1               PRT_LF:
0001CEr 1  A9 0A          LDA #$A
0001D0r 1  4C rr rr       JMP PRT_C_CALL
0001D3r 1               
0001D3r 1               ; スペース印字
0001D3r 1               PRT_S:
0001D3r 1  A9 20          LDA #' '
0001D5r 1  4C rr rr       JMP PRT_C_CALL
0001D8r 1               
0001D8r 1               ; Aで与えられたバイト値をASCII値AYにする
0001D8r 1               ; Aから先に表示すると良い
0001D8r 1               BYT2ASC:
0001D8r 1  48             PHA           ; 下位のために保存
0001D9r 1  29 0F          AND #$0F
0001DBr 1  20 rr rr       JSR NIB2ASC
0001DEr 1  A8             TAY
0001DFr 1  68             PLA
0001E0r 1  4A             LSR           ; 右シフトx4で上位を下位に持ってくる
0001E1r 1  4A             LSR
0001E2r 1  4A             LSR
0001E3r 1  4A             LSR
0001E4r 1  20 rr rr       JSR NIB2ASC
0001E7r 1  60             RTS
0001E8r 1               
0001E8r 1               ; #$0?をアスキー一文字にする
0001E8r 1               NIB2ASC:
0001E8r 1  09 30          ORA #$30
0001EAr 1  C9 3A          CMP #$3A
0001ECr 1  90 02          BCC @SKP_ADC  ; Aが$3Aより小さいか等しければ分岐
0001EEr 1  69 06          ADC #$06
0001F0r 1               @SKP_ADC:
0001F0r 1  60             RTS
0001F1r 1               
0001F1r 1               STR_NOTFOUND:
0001F1r 1  49 6E 70 75    .BYT "Input File Not Found.",$A,$0
0001F5r 1  74 20 46 69  
0001F9r 1  6C 65 20 4E  
000208r 1               STR_FILE:
000208r 1  46 69 6C 65    .BYT "File:",$0
00020Cr 1  3A 00        
00020Er 1               STR_EOF:
00020Er 1  5B 45 4F 46    .BYT "[EOF]",$0
000212r 1  5D 00        
000214r 1               
000214r 1               PATH_DATA:
000214r 1  41 3A 2F 54    .ASCIIZ "A:/TEST.TXT"
000218r 1  45 53 54 2E  
00021Cr 1  54 58 54 00  
000220r 1               
000220r 1  4E 65 77 20  STR_HELLO:      .BYT "New FS_READ syscall dev tool",$A,$0
000224r 1  46 53 5F 52  
000228r 1  45 41 44 20  
00023Er 1  4C 65 6E 67  STR_LENGTH:     .BYT "Length?   : $",$0
000242r 1  74 68 3F 20  
000246r 1  20 20 3A 20  
00024Cr 1  46 69 6C 65  STR_GOT_FD:     .BYT "File Dscr.:       $",$0
000250r 1  20 44 73 63  
000254r 1  72 2E 3A 20  
000260r 1  46 43 54 52  STR_FCTRL_SIZ:  .BYT "FCTRL_SIZE: $",$0
000264r 1  4C 5F 53 49  
000268r 1  5A 45 3A 20  
00026Er 1  46 43 54 52  STR_FCTRL_SEEK: .BYT "FCTRL_SEEK: $",$0
000272r 1  4C 5F 53 45  
000276r 1  45 4B 3A 20  
00027Cr 1  41 43 54 4C  STR_ACTLEN:     .BYT "ACTLEN    :     $",$0
000280r 1  45 4E 20 20  
000284r 1  20 20 3A 20  
00028Er 1  53 44 53 45  STR_SDSEEK:     .BYT "SDSEEK    : $",$0
000292r 1  45 4B 20 20  
000296r 1  20 20 3A 20  
00029Cr 1  42 46 50 54  STR_BFPTR:      .BYT "BFPTR     : $",$0
0002A0r 1  52 20 20 20  
0002A4r 1  20 20 3A 20  
0002AAr 1               
0002AAr 1  xx xx xx xx  INSTR_BF: .RES 8
0002AEr 1  xx xx xx xx  
0002B2r 1               .DATA
000000r 1               AAA:
000000r 1  xx xx xx xx  .res 200
000004r 1  xx xx xx xx  
000008r 1  xx xx xx xx  
0000C8r 1               BUFFER:
0000C8r 1               
0000C8r 1               
