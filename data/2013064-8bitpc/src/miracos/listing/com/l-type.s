ca65 V2.16 - Ubuntu 2.16-2
Main file   : ./com/type.s
Current file: ./com/type.s

000000r 1               ; -------------------------------------------------------------------
000000r 1               ; テキストファイルを打ち出す
000000r 1               ; -------------------------------------------------------------------
000000r 1               ; TCのテスト
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
000000r 1               ;                             変数領域
000000r 1               ; -------------------------------------------------------------------
000000r 1               .BSS
000000r 1  xx             FD_SAV:         .RES 1  ; ファイル記述子
000001r 1  xx xx          FINFO_SAV:      .RES 2  ; FINFO
000003r 1               
000003r 1               ; -------------------------------------------------------------------
000003r 1               ;                             実行領域
000003r 1               ; -------------------------------------------------------------------
000003r 1               .CODE
000000r 1               START:
000000r 1  9C rr rr       STZ TEXT+256                    ; 終端
000003r 1                 ;pushAY16                       ; デバッグ情報
000003r 1                 ;loadAY16 STR_FILE
000003r 1                 ;syscall CON_OUT_STR
000003r 1                 ;pullAY16
000003r 1                 ;pushAY16
000003r 1                 ;syscall CON_OUT_STR
000003r 1                 ;JSR PRT_LF
000003r 1                 ;pullAY16
000003r 1                 ; nullチェック
000003r 1  85 00 84 01    storeAY16 ZR0
000007r 1  AA             TAX
000008r 1  B2 00          LDA (ZR0)
00000Ar 1  F0 50          BEQ NOTFOUND
00000Cr 1  8A             TXA
00000Dr 1                 ; オープン
00000Dr 1  A2 12 20 03    syscall FS_FIND_FST             ; 検索
000011r 1  06           
000012r 1  B0 48          BCS NOTFOUND                    ; 見つからなかったらあきらめる
000014r 1  8D rr rr 8C    storeAY16 FINFO_SAV             ; FINFOを格納
000018r 1  rr rr        
00001Ar 1  A2 0A 20 03    syscall FS_OPEN                 ; ファイルをオープン
00001Er 1  06           
00001Fr 1  B0 3B          BCS NOTFOUND                    ; オープンできなかったらあきらめる
000021r 1  8D rr rr       STA FD_SAV                      ; ファイル記述子をセーブ
000024r 1                 ;JSR PRT_BYT
000024r 1                 ;JSR PRT_LF
000024r 1               LOOP:
000024r 1                 ; ロード
000024r 1  AD rr rr       LDA FD_SAV
000027r 1  85 02          STA ZR1                         ; 規約、ファイル記述子はZR1！
000029r 1  A9 rr 85 00    loadmem16 ZR0,TEXT              ; 書き込み先
00002Dr 1  A9 rr 85 01  
000031r 1  A9 00 A0 01    loadAY16 256
000035r 1  A2 24 20 03    syscall FS_READ_BYTS            ; ロード
000039r 1  06           
00003Ar 1  B0 15          BCS @CLOSE
00003Cr 1  AA             TAX                             ; 読み取ったバイト数
00003Dr 1  C0 01          CPY #1                          ; 256バイト読んだか？
00003Fr 1  F0 05          BEQ @SKP_EOF
000041r 1  A9 00          LDA #0
000043r 1  9E rr rr       STZ TEXT,X
000046r 1               @SKP_EOF:
000046r 1                 ; 出力
000046r 1  A9 rr A0 rr    loadAY16 TEXT
00004Ar 1  A2 08 20 03    syscall CON_OUT_STR
00004Er 1  06           
00004Fr 1  80 D3          BRA LOOP
000051r 1                 ; 最終バイトがあるとき
000051r 1                 ; クローズ
000051r 1               @CLOSE:
000051r 1  AD rr rr       LDA FD_SAV
000054r 1  A2 0C 20 03    syscall FS_CLOSE                ; クローズ
000058r 1  06           
000059r 1  B0 0B          BCS BCOS_ERROR
00005Br 1                 ;loadAY16 STR_EOF               ; debug EOF表示
00005Br 1                 ;syscall CON_OUT_STR
00005Br 1  60             RTS
00005Cr 1               
00005Cr 1               NOTFOUND:
00005Cr 1  A9 rr A0 rr    loadAY16 STR_NOTFOUND
000060r 1  A2 08 20 03    syscall CON_OUT_STR
000064r 1  06           
000065r 1  60             RTS
000066r 1               
000066r 1               BCOS_ERROR:
000066r 1  20 rr rr       JSR PRT_LF
000069r 1  A2 1A 20 03    syscall ERR_GET
00006Dr 1  06           
00006Er 1  A2 1C 20 03    syscall ERR_MES
000072r 1  06           
000073r 1  4C rr rr       JMP LOOP
000076r 1               
000076r 1               ;PRT_BYT:
000076r 1               ;  JSR BYT2ASC
000076r 1               ;  PHY
000076r 1               ;  JSR PRT_C_CALL
000076r 1               ;  PLA
000076r 1               PRT_C_CALL:
000076r 1  A2 04 20 03    syscall CON_OUT_CHR
00007Ar 1  06           
00007Br 1  60             RTS
00007Cr 1               
00007Cr 1               PRT_LF:
00007Cr 1                 ; 改行
00007Cr 1  A9 0A          LDA #$A
00007Er 1  4C rr rr       JMP PRT_C_CALL
000081r 1               ;
000081r 1               ;PRT_S:
000081r 1               ;  ; スペース
000081r 1               ;  LDA #' '
000081r 1               ;  JMP PRT_C_CALL
000081r 1               ;
000081r 1               ;BYT2ASC:
000081r 1               ;  ; Aで与えられたバイト値をASCII値AYにする
000081r 1               ;  ; Aから先に表示すると良い
000081r 1               ;  PHA           ; 下位のために保存
000081r 1               ;  AND #$0F
000081r 1               ;  JSR NIB2ASC
000081r 1               ;  TAY
000081r 1               ;  PLA
000081r 1               ;  LSR           ; 右シフトx4で上位を下位に持ってくる
000081r 1               ;  LSR
000081r 1               ;  LSR
000081r 1               ;  LSR
000081r 1               ;  JSR NIB2ASC
000081r 1               ;  RTS
000081r 1               ;
000081r 1               ;NIB2ASC:
000081r 1               ;  ; #$0?をアスキー一文字にする
000081r 1               ;  ORA #$30
000081r 1               ;  CMP #$3A
000081r 1               ;  BCC @SKP_ADC  ; Aが$3Aより小さいか等しければ分岐
000081r 1               ;  ADC #$06
000081r 1               ;@SKP_ADC:
000081r 1               ;  RTS
000081r 1               
000081r 1               STR_NOTFOUND:
000081r 1  49 6E 70 75    .BYT "Input File Not Found.",$A,$0
000085r 1  74 20 46 69  
000089r 1  6C 65 20 4E  
000098r 1               ;STR_FILE:
000098r 1               ;  .BYT "File:",$0
000098r 1               ;STR_EOF:
000098r 1               ;  .BYT "[EOF]",$0
000098r 1               
000098r 1               ; -------------------------------------------------------------------
000098r 1               ;                             データ領域
000098r 1               ; -------------------------------------------------------------------
000098r 1               .BSS
000003r 1               TEXT:
000003r 1               
000003r 1               
