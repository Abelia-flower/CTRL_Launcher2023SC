ca65 V2.16 - Ubuntu 2.16-2
Main file   : ./com/test/timeout.s
Current file: ./com/test/timeout.s

000000r 1               ; -------------------------------------------------------------------
000000r 1               ;                           TIMEOUT.COM
000000r 1               ; -------------------------------------------------------------------
000000r 1               ; タイムアウトのテスト
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
000000r 1               ;                               ZP領域
000000r 1               ; -------------------------------------------------------------------
000000r 1               .ZEROPAGE
000000r 1  xx             ZP_CNT:   .RES 1
000001r 1               
000001r 1               ; -------------------------------------------------------------------
000001r 1               ;                             実行領域
000001r 1               ; -------------------------------------------------------------------
000001r 1               .CODE
000000r 1               START:
000000r 1                 ; ZR0のコマンドライン引数をHEXとしてタイムアウト時間に解釈
000000r 1  20 rr rr       JSR STR2NUM
000003r 1  48             PHA
000004r 1                 ; 挨拶
000004r 1  A9 rr A0 rr    loadAY16 STR_HELLO
000008r 1  A2 08 20 03    syscall CON_OUT_STR
00000Cr 1  06           
00000Dr 1                 ;LDA #$FF                        ; 256ms
00000Dr 1  A9 rr 85 00    loadmem16 ZR0,EXIT
000011r 1  A9 rr 85 01  
000015r 1  68             PLA
000016r 1  A2 2C 20 03    syscall TIMEOUT                 ; タイムアウト設定
00001Ar 1  06           
00001Br 1                 ; 数値表示
00001Br 1  64 rr          STZ ZP_CNT
00001Dr 1               LOOP:
00001Dr 1  A5 rr          LDA ZP_CNT
00001Fr 1  20 rr rr       JSR PRT_NUM
000022r 1  20 rr rr       JSR PRT_S
000025r 1  E6 rr          INC ZP_CNT
000027r 1  80 F4          BRA LOOP
000029r 1               
000029r 1               EXIT:                             ; タイムアウトした
000029r 1  A9 rr A0 rr    loadAY16 STR_TIMEOUT
00002Dr 1  A2 08 20 03    syscall CON_OUT_STR
000031r 1  06           
000032r 1  A9 rr A0 rr    loadAY16 STR_GOODBYE
000036r 1  A2 08 20 03    syscall CON_OUT_STR
00003Ar 1  06           
00003Br 1  60             RTS
00003Cr 1               
00003Cr 1               ; ASCII文字列をHEXと信じて変換
00003Cr 1               STR2NUM:
00003Cr 1                 @STR_PTR=ZR0
00003Cr 1                 @NUMBER16=ZR1
00003Cr 1  85 00 84 01    storeAY16 @STR_PTR
000040r 1  64 02          STZ ZR1
000042r 1  64 03          STZ ZR1+1
000044r 1                 ; 最後尾まで探索、余計な文字があったらエラー
000044r 1  A0 FF          LDY #$FF
000046r 1               @FIND_EOS_LOOP:
000046r 1  C8             INY
000047r 1  B1 00          LDA (@STR_PTR),Y
000049r 1  D0 FB          BNE @FIND_EOS_LOOP
00004Br 1               @END_OF_STR:
00004Br 1                 ; Y=\0
00004Br 1  A2 00          LDX #0
00004Dr 1               @BYT_LOOP:
00004Dr 1                 ; 下位nibble
00004Dr 1  88             DEY
00004Er 1  C0 FF          CPY #$FF
000050r 1  F0 20          BEQ @END
000052r 1  B1 00          LDA (@STR_PTR),Y
000054r 1  20 rr rr       JSR CHR2NIB
000057r 1  B0 1B          BCS @ERR
000059r 1  95 02          STA ZR1,X
00005Br 1                 ; 上位nibble
00005Br 1  88             DEY
00005Cr 1  C0 FF          CPY #$FF
00005Er 1  F0 12          BEQ @END
000060r 1  B1 00          LDA (@STR_PTR),Y
000062r 1  20 rr rr       JSR CHR2NIB
000065r 1  B0 0D          BCS @ERR
000067r 1  0A             ASL
000068r 1  0A             ASL
000069r 1  0A             ASL
00006Ar 1  0A             ASL
00006Br 1  15 02          ORA ZR1,X
00006Dr 1  95 02          STA ZR1,X
00006Fr 1  E8             INX
000070r 1  80 DB          BRA @BYT_LOOP
000072r 1               @END:
000072r 1  18             CLC
000073r 1  60             RTS
000074r 1               @ERR:
000074r 1  38             SEC
000075r 1  60             RTS
000076r 1               
000076r 1               ; *
000076r 1               ; --- Aレジスタの一文字をNibbleとして値にする ---
000076r 1               ; *
000076r 1               CHR2NIB:
000076r 1  C9 30          CMP #'0'
000078r 1  30 16          BMI @ERR
00007Ar 1  C9 3A          CMP #'9'+1
00007Cr 1  10 05          BPL @ABCDEF
00007Er 1  38             SEC
00007Fr 1  E9 30          SBC #'0'
000081r 1  18             CLC
000082r 1  60             RTS
000083r 1               @ABCDEF:
000083r 1  C9 41          CMP #'A'
000085r 1  30 09          BMI @ERR
000087r 1  C9 47          CMP #'F'+1
000089r 1  10 05          BPL @ERR
00008Br 1  38             SEC
00008Cr 1  E9 37          SBC #'A'-$0A
00008Er 1  18             CLC
00008Fr 1  60             RTS
000090r 1               @ERR:
000090r 1  38             SEC
000091r 1  60             RTS
000092r 1               
000092r 1               ; -------------------------------------------------------------------
000092r 1               ;                             10進1桁表示
000092r 1               ; -------------------------------------------------------------------
000092r 1               PRT_NUM:
000092r 1  29 0F          AND #$0F
000094r 1  09 30          ORA #$30
000096r 1               PRT_CHR:
000096r 1  A2 04 20 03    syscall CON_OUT_CHR
00009Ar 1  06           
00009Br 1  60             RTS
00009Cr 1               
00009Cr 1               ; -------------------------------------------------------------------
00009Cr 1               ;                              空白表示
00009Cr 1               ; -------------------------------------------------------------------
00009Cr 1               PRT_S:
00009Cr 1  A9 20          LDA #' '
00009Er 1  80 F6          BRA PRT_CHR
0000A0r 1               
0000A0r 1               STR_HELLO:
0000A0r 1  54 69 6D 65    .BYT "Timeout syscall test program.",$A,$0
0000A4r 1  6F 75 74 20  
0000A8r 1  73 79 73 63  
0000BFr 1               STR_TIMEOUT:
0000BFr 1  54 69 6D 65    .BYT "Timeout.",$A,$0
0000C3r 1  6F 75 74 2E  
0000C7r 1  0A 00        
0000C9r 1               STR_GOODBYE:
0000C9r 1  47 6F 6F 64    .BYT "Good Bye!",$A,$0
0000CDr 1  20 42 79 65  
0000D1r 1  21 0A 00     
0000D4r 1               
0000D4r 1               
