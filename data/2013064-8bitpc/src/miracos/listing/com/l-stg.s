ca65 V2.16 - Ubuntu 2.16-2
Main file   : ./com/stg.s
Current file: ./com/stg.s

000000r 1               ; -------------------------------------------------------------------
000000r 1               ;                               STG.COM
000000r 1               ; -------------------------------------------------------------------
000000r 1               ; シューティングゲーム
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
000000r 1               ; --- 定数定義 ---
000000r 1               BGC = $00             ; 背景色
000000r 1               DEBUG_BGC = $00       ; オルタナティブ背景色
000000r 1               INFO_BGC = $22        ; INFO背景色
000000r 1               INFO_COL = $FF        ; INFO文字色
000000r 1               INFO_FLAME = $11      ; INFOフチ
000000r 1               INFO_FLAME_L = $12    ; INFOフチ
000000r 1               INFO_FLAME_R = $21    ; INFOフチ
000000r 1               PLAYER_SPEED = 3      ; PL速度
000000r 1               PLAYER_SHOOTRATE = 5  ; 射撃クールダウンレート
000000r 1               PLBLT_SPEED = 8       ; PLBLT速度
000000r 1               PLAYER_X = (256/2)-4  ; プレイヤー初期位置X
000000r 1               PLAYER_Y = 192-(8*3)  ; プレイヤー初期位置Y
000000r 1               TOP_MARGIN = 8*3      ; 上部のマージン
000000r 1               RL_MARGIN = 4         ; 左右のマージン
000000r 1               ZANKI_MAX = 6         ; ストック可能な自機の最大数
000000r 1               ZANKI_START = 3       ; 残機の初期値
000000r 1               
000000r 1               ; -------------------------------------------------------------------
000000r 1               ;                               ZP領域
000000r 1               ; -------------------------------------------------------------------
000000r 1               .ZEROPAGE
000000r 1                 ; キャラクタ描画canvas
000000r 1  xx             ZP_CANVAS_X:        .RES 1        ; X座標汎用
000001r 1  xx             ZP_CANVAS_Y:        .RES 1        ; Y座標汎用
000002r 1  xx             ZP_VISIBLE_FLAME:   .RES 1        ; 可視フレームバッファ
000003r 1  xx xx          ZP_BLACKLIST_PTR:   .RES 2        ; 塗りつぶしリスト用のポインタ
000005r 1  xx xx          ZP_CHAR_PTR:        .RES 2        ; キャラクタデータ用のポインタ
000007r 1                 ; SNESPAD
000007r 1  xx xx          ZP_PADSTAT:         .RES 2        ; ゲームパッドの状態が収まる
000009r 1  xx             ZP_SHIFTER:         .RES 1        ; ゲームパッド読み取り処理用
00000Ar 1                 ; VBLANK
00000Ar 1  xx xx          ZP_VB_STUB:         .RES 2        ; 割り込み終了処理
00000Cr 1                 ; ゲームデータ
00000Cr 1  xx             ZP_PLAYER_X:        .RES 1        ; プレイヤ座標
00000Dr 1  xx             ZP_PLAYER_Y:        .RES 1
00000Er 1  xx             ZP_ANT_NZ_Y:        .RES 1        ; アンチ・ノイズY座標
00000Fr 1  xx             ZP_PL_DX:           .RES 1        ; プレイヤX軸速度
000010r 1  xx             ZP_PL_DY:           .RES 1        ; プレイヤY軸速度
000011r 1  xx             ZP_PL_COOLDOWN:     .RES 1
000012r 1  xx             ZP_BL_INDEX:        .RES 1        ; ブラックリストのYインデックス退避
000013r 1  xx             ZP_PLBLT_TERMIDX:   .RES 1        ; PLBLT_LSTの終端を指す
000014r 1  xx             ZP_GENERAL_CNT:     .RES 1
000015r 1  xx xx          ZP_CMD_PTR:         .RES 2        ; ステージコマンドのポインタ
000017r 1  xx             ZP_CMD_WAIT_CNT:    .RES 1
000018r 1  xx             ZP_ZANKI:           .RES 1        ; 残機
000019r 1  xx             ZP_INFO_FLAG_P:     .RES 1        ; INFO描画箇所フラグ 7|???? ???,残機|0
00001Ar 1  xx             ZP_INFO_FLAG_S:     .RES 1        ; セカンダリ
00001Br 1  xx             ZP_DEATH_MUTEKI:    .RES 1        ; 死亡時ティックカウンタを記録し、255ティックの範囲で無敵時間を調整
00001Cr 1  xx             ZP_PL_STAT_FLAG:    .RES 1        ; 7|???? ???,無敵|0
00001Dr 1               
00001Dr 1               ; -------------------------------------------------------------------
00001Dr 1               ;                           実行用ライブラリ
00001Dr 1               ; -------------------------------------------------------------------
00001Dr 1                 .PROC IMF
00001Dr 1                   .INCLUDE "./+stg/imf.s"
00001Dr 2               ; -------------------------------------------------------------------
00001Dr 2               ;  画像ファイルを表示する
00001Dr 2               ; -------------------------------------------------------------------
00001Dr 2               IMAGE_BUFFER_SECS = 2 ; 何セクタをバッファに使うか？ 48の約数
00001Dr 2               ; -------------------------------------------------------------------
00001Dr 2               ;                              変数領域
00001Dr 2               ; -------------------------------------------------------------------
00001Dr 2               .BSS
000000r 2  xx             FD_SAV:         .RES 1  ; ファイル記述子
000001r 2  xx xx          FINFO_SAV:      .RES 2  ; FINFO
000003r 2               TEXT:
000003r 2  xx xx xx xx    .RES 512*IMAGE_BUFFER_SECS
000007r 2  xx xx xx xx  
00000Br 2  xx xx xx xx  
000403r 2               
000403r 2               ; -------------------------------------------------------------------
000403r 2               ;                               ZP領域
000403r 2               ; -------------------------------------------------------------------
000403r 2               .ZEROPAGE
00001Dr 2  xx             ZP_TMP_X:       .RES 1
00001Er 2  xx             ZP_TMP_Y:       .RES 1
00001Fr 2  xx             ZP_TMP_X_DEST:  .RES 1
000020r 2  xx             ZP_TMP_Y_DEST:  .RES 1
000021r 2  xx xx          ZP_READ_VEC16:  .RES 2
000023r 2  xx             ZP_VMAV:        .RES 1
000024r 2               
000024r 2               ; -------------------------------------------------------------------
000024r 2               ;                             実行領域
000024r 2               ; -------------------------------------------------------------------
000024r 2               .SEGMENT "LIB"
000000r 2               PRINT_IMF:
000000r 2                 ; nullチェック
000000r 2  85 00 84 01    storeAY16 ZR0
000004r 2  AA             TAX
000005r 2  B2 00          LDA (ZR0)
000007r 2  D0 03          BNE @SKP_NOTFOUND
000009r 2               @NOTFOUND2:
000009r 2  4C rr rr       JMP NOTFOUND
00000Cr 2               @SKP_NOTFOUND:
00000Cr 2  8A             TXA
00000Dr 2                 ; オープン
00000Dr 2  A2 12 20 03    syscall FS_FIND_FST             ; 検索
000011r 2  06           
000012r 2  B0 F5          BCS @NOTFOUND2                  ; 見つからなかったらあきらめる
000014r 2  8D rr rr 8C    storeAY16 FINFO_SAV             ; FINFOを格納
000018r 2  rr rr        
00001Ar 2  A2 0A 20 03    syscall FS_OPEN                 ; ファイルをオープン
00001Er 2  06           
00001Fr 2  B0 61          BCS NOTFOUND                    ; オープンできなかったらあきらめる
000021r 2  8D rr rr       STA FD_SAV                      ; ファイル記述子をセーブ
000024r 2               ;  ; CRTCを初期化
000024r 2               ;  LDA #%00000001           ; 全内部行を16色モード、書き込みカウントアップ有効、16色モード座標
000024r 2               ;  STA CRTC::CFG
000024r 2               ;  STZ CRTC::RF              ; f0を表示
000024r 2  A9 00          LDA #$00
000026r 2  85 rr          STA ZP_VMAV
000028r 2               ;  JSR FILL
000028r 2               LOOP:
000028r 2                 ; ロード
000028r 2  AD rr rr       LDA FD_SAV
00002Br 2  85 02          STA ZR1                         ; 規約、ファイル記述子はZR1！
00002Dr 2  A9 rr 85 00    loadmem16 ZR0,TEXT              ; 書き込み先
000031r 2  A9 rr 85 01  
000035r 2  A9 00 A0 04    loadAY16 512*IMAGE_BUFFER_SECS  ; 数セクタをバッファに読み込み
000039r 2  A2 24 20 03    syscall FS_READ_BYTS            ; ロード
00003Dr 2  06           
00003Er 2  B0 37          BCS @CLOSE
000040r 2                 ; 読み取ったセクタ数をバッファ出力ループのイテレータに
000040r 2  98             TYA
000041r 2  4A             LSR
000042r 2  AA             TAX
000043r 2                 ; バッファ出力
000043r 2                 ; 書き込み座標リセット
000043r 2  A5 rr          LDA ZP_VMAV
000045r 2  8D 03 E6       STA CRTC::VMAV
000048r 2  9C 02 E6       STZ CRTC::VMAH
00004Br 2  A9 rr 85 rr    loadmem16 ZP_READ_VEC16, TEXT
00004Fr 2  A9 rr 85 rr  
000053r 2                 ; バッファ出力ループ
000053r 2                 ;LDX #IMAGE_BUFFER_SECS
000053r 2               @BUFFER_LOOP:
000053r 2                 ; 256バイト出力ループx2
000053r 2                 ; 前編
000053r 2  A0 00          LDY #0
000055r 2               @PAGE_LOOP:
000055r 2  B1 rr          LDA (ZP_READ_VEC16),Y
000057r 2  8D 04 E6       STA CRTC::WDBF
00005Ar 2  C8             INY
00005Br 2  D0 F8          BNE @PAGE_LOOP
00005Dr 2  E6 rr          INC ZP_READ_VEC16+1             ; 読み取りポイント更新
00005Fr 2                 ; 後編
00005Fr 2  A0 00          LDY #0
000061r 2               @PAGE_LOOP2:
000061r 2  B1 rr          LDA (ZP_READ_VEC16),Y
000063r 2  8D 04 E6       STA CRTC::WDBF
000066r 2  C8             INY
000067r 2  D0 F8          BNE @PAGE_LOOP2
000069r 2  E6 rr          INC ZP_READ_VEC16+1             ; 読み取りポイント更新
00006Br 2                 ; 512バイト出力終了
00006Br 2  CA             DEX
00006Cr 2  D0 E5          BNE @BUFFER_LOOP
00006Er 2                 ; バッファ出力終了
00006Er 2                 ; 垂直アドレスの更新
00006Er 2                 ; 512バイトは4行に相当する
00006Er 2  18             CLC
00006Fr 2  A5 rr          LDA ZP_VMAV
000071r 2  69 08          ADC #4*IMAGE_BUFFER_SECS
000073r 2  85 rr          STA ZP_VMAV
000075r 2  80 B1          BRA LOOP
000077r 2                 ; 最終バイトがあるとき
000077r 2                 ; クローズ
000077r 2               @CLOSE:
000077r 2  AD rr rr       LDA FD_SAV
00007Ar 2  A2 0C 20 03    syscall FS_CLOSE                ; クローズ
00007Er 2  06           
00007Fr 2  B0 0B          BCS BCOS_ERROR
000081r 2  60             RTS
000082r 2               
000082r 2               NOTFOUND:
000082r 2  A9 rr A0 rr    loadAY16 STR_NOTFOUND
000086r 2  A2 08 20 03    syscall CON_OUT_STR
00008Ar 2  06           
00008Br 2  60             RTS
00008Cr 2               
00008Cr 2               BCOS_ERROR:
00008Cr 2  20 rr rr       JSR PRT_LF
00008Fr 2  A2 1A 20 03    syscall ERR_GET
000093r 2  06           
000094r 2  A2 1C 20 03    syscall ERR_MES
000098r 2  06           
000099r 2  4C rr rr       JMP LOOP
00009Cr 2               
00009Cr 2               ;PRT_BYT:
00009Cr 2               ;  JSR BYT2ASC
00009Cr 2               ;  PHY
00009Cr 2               ;  JSR PRT_C_CALL
00009Cr 2               ;  PLA
00009Cr 2               PRT_C_CALL:
00009Cr 2  A2 04 20 03    syscall CON_OUT_CHR
0000A0r 2  06           
0000A1r 2  60             RTS
0000A2r 2               
0000A2r 2               PRT_LF:
0000A2r 2                 ; 改行
0000A2r 2  A9 0A          LDA #$A
0000A4r 2  4C rr rr       JMP PRT_C_CALL
0000A7r 2               
0000A7r 2               STR_NOTFOUND:
0000A7r 2  49 6E 70 75    .BYT "Input File Not Found.",$A,$0
0000ABr 2  74 20 46 69  
0000AFr 2  6C 65 20 4E  
0000BEr 2               
0000BEr 2               
0000BEr 1                 .ENDPROC
0000BEr 1                 .INCLUDE "./+stg/infobox.s"
0000BEr 2               INFO_TOP_MARGIN = 2
0000BEr 2               INFO_RL_MARGIN = 2
0000BEr 2               
0000BEr 2               ; -------------------------------------------------------------------
0000BEr 2               ;                              残機描画
0000BEr 2               ; -------------------------------------------------------------------
0000BEr 2               ; 塗りつぶしてから、左から一機一機描いていく
0000BEr 2               ; NOTE:増減のたびにやるのは非効率ではある
0000BEr 2               .macro draw_zanki
0000BEr 2                 ; エリアを黒で塗りつぶす
0000BEr 2                 LDX #128-(4*ZANKI_MAX)-(INFO_RL_MARGIN/2)
0000BEr 2                 LDY #INFO_TOP_MARGIN
0000BEr 2                 LDA #BGC
0000BEr 2               @FILL_LOOP:
0000BEr 2                 STX CRTC::VMAH
0000BEr 2                 STY CRTC::VMAV
0000BEr 2                 .REPEAT ZANKI_MAX*4
0000BEr 2                 STA CRTC::WDBF
0000BEr 2                 .ENDREP
0000BEr 2                 INY
0000BEr 2                 CPY #INFO_TOP_MARGIN+8
0000BEr 2                 BNE @FILL_LOOP
0000BEr 2                 ; 残機画像
0000BEr 2                 loadmem16 ZP_CHAR_PTR,CHAR_DAT_ZIKI ; 画像指定
0000BEr 2                 LDA ZP_ZANKI                        ; 残機数取得
0000BEr 2                 STA ZR1+1                           ; ZR1H=カウントダウン用
0000BEr 2                 INC ZR1+1
0000BEr 2                 LDA #256-INFO_TOP_MARGIN-8          ; 一匹目のX座標
0000BEr 2                 STA ZR1                             ; X座標保存
0000BEr 2               @ZANKI_LOOP:
0000BEr 2                 ; X座標指定
0000BEr 2                 STA ZP_CANVAS_X
0000BEr 2                 ; 脱出条件確認
0000BEr 2                 DEC ZR1+1
0000BEr 2                 BEQ @EXT_LOOP
0000BEr 2                 ; Y座標指定
0000BEr 2                 LDA #INFO_TOP_MARGIN
0000BEr 2                 STA ZP_CANVAS_Y
0000BEr 2                 JSR DRAW_CHAR8
0000BEr 2                 ; X座標更新
0000BEr 2                 LDA ZR1
0000BEr 2                 SEC
0000BEr 2                 SBC #8
0000BEr 2                 STA ZR1
0000BEr 2                 BRA @ZANKI_LOOP
0000BEr 2               @EXT_LOOP:
0000BEr 2               .endmac
0000BEr 2               
0000BEr 2               ; -------------------------------------------------------------------
0000BEr 2               ;                          INFOBOXティック
0000BEr 2               ; -------------------------------------------------------------------
0000BEr 2               .macro tick_infobox
0000BEr 2                 ; セカンダリから処理
0000BEr 2                 LDA ZP_INFO_FLAG_S
0000BEr 2                 JSR DRAW_INFO_LIST
0000BEr 2                 ; プライマリも処理
0000BEr 2                 LDA ZP_INFO_FLAG_P
0000BEr 2                 JSR DRAW_INFO_LIST
0000BEr 2                 ; プライマリをセカンダリに移管
0000BEr 2                 LDA ZP_INFO_FLAG_P
0000BEr 2                 STA ZP_INFO_FLAG_S
0000BEr 2                 ; プライマリを初期化
0000BEr 2                 STZ ZP_INFO_FLAG_P
0000BEr 2               .endmac
0000BEr 2               
0000BEr 2               ; -------------------------------------------------------------------
0000BEr 2               ;                         フラグに従って描画
0000BEr 2               ; -------------------------------------------------------------------
0000BEr 2               DRAW_INFO_LIST:
0000BEr 2  85 00          STA ZR0
0000C0r 2  8F 00 01       BBS0 ZR0,@NOTSKP_ZANKI
0000C3r 2  60             RTS
0000C4r 2               @NOTSKP_ZANKI:
0000C4r 2  A2 67 A0 02    draw_zanki
0000C8r 2  A9 00 8E 02  
0000CCr 2  E6 8C 03 E6  
000145r 2  60             RTS
000146r 2               
000146r 2               
000146r 1                 .INCLUDE "./+stg/dmk.s"
000146r 2               ; -------------------------------------------------------------------
000146r 2               ;                               ZP領域
000146r 2               ; -------------------------------------------------------------------
000146r 2               .ZEROPAGE
000024r 2  xx             ZP_DMK1_TERMIDX:    .RES 1        ; DMK1_LSTの終端を指す
000025r 2               
000025r 2               ; -------------------------------------------------------------------
000025r 2               ;                              変数領域
000025r 2               ; -------------------------------------------------------------------
000025r 2               .BSS
000403r 2                 ; 弾幕1
000403r 2  xx xx xx xx    DMK1_LST:      .RES 256 ; (X,Y,.x.y,I),...
000407r 2  xx xx xx xx  
00040Br 2  xx xx xx xx  
000503r 2               
000503r 2               .SEGMENT "LIB"
000146r 2               
000146r 2               ; -------------------------------------------------------------------
000146r 2               ;                           DMK1ティック
000146r 2               ; -------------------------------------------------------------------
000146r 2               .macro tick_dmk1
000146r 2                 .local TICK_DMK1
000146r 2                 .local @LOOP
000146r 2                 .local @END
000146r 2                 .local @SKP_Hamburg
000146r 2                 .local @DEL
000146r 2               TICK_DMK1:
000146r 2                 @ZR0_XHIT_FLAG  = ZR0
000146r 2                 @ZR1_DIFF       = ZR1
000146r 2                 LDX #$0                   ; X:DMK1リスト用インデックス
000146r 2               @LOOP:
000146r 2                 CPX ZP_DMK1_TERMIDX
000146r 2                 BCC @SKP_END              ; DMK1をすべて処理したなら処理終了
000146r 2                 JMP @END
000146r 2               @SKP_END:
000146r 2                 ; ---------------------------------------------------------------
000146r 2                 ;   X
000146r 2                 ; 1px/tickより遅い可能性
000146r 2                 ; C=0保障
000146r 2               
000146r 2                 LDA DMK1_LST+3,X          ; 速度インデックス取得
000146r 2               
000146r 2                 LDA DMK1_LST+2,X          ; dX取得
000146r 2                 BPL @SKP_SEC
000146r 2                 SEC
000146r 2               @SKP_SEC:
000146r 2                 ROR                       ; C<-bit0 低速フラグ
000146r 2                 BCC @FASTX
000146r 2                 ; 低速
000146r 2               @SLOWX:
000146r 2                 LSR                       ; C<-bit1 負方向フラグ
000146r 2                 PHA                       ; マスク値を退避
000146r 2                 BCS @MINUSX
000146r 2                 LDA #1
000146r 2                 .BYT $2C                  ; 例のテクニック
000146r 2               @MINUSX:
000146r 2                 LDA #255
000146r 2                 STA @ZR1_DIFF
000146r 2                 PLA                       ; マスク値を復帰
000146r 2                 AND ZP_GENERAL_CNT        ; マスク値
000146r 2                 BEQ @SKP_ZEROX            ; ゼロなら1/-1を反映
000146r 2                 ;STZ @ZR1_DIFF
000146r 2                 LDA #0
000146r 2               @FASTX:
000146r 2                 STA @ZR1_DIFF
000146r 2               @SKP_ZEROX:
000146r 2               @ADDX:
000146r 2                 LDA DMK1_LST,X
000146r 2                 CLC
000146r 2                 ADC #$80                  ; 半分ずらした状態で加算して戻すことで、Vフラグで跨ぎ判定
000146r 2                 CLC
000146r 2                 ADC @ZR1_DIFF
000146r 2                 BVC @SKP_Hamburg          ; 左右端を跨ぐなら削除
000146r 2               @DEL:
000146r 2                 ; 弾丸削除
000146r 2                 PHY
000146r 2                 JSR DEL_DMK1
000146r 2                 PLY
000146r 2                 BRA @LOOP
000146r 2               @SKP_Hamburg:
000146r 2                 SEC
000146r 2                 SBC #$80
000146r 2                 STA DMK1_LST,X            ; リストに格納
000146r 2                 STA ZP_CANVAS_X           ; 描画用座標
000146r 2                 STA (ZP_BLACKLIST_PTR),Y  ; BL格納
000146r 2                 ; ---------------------------------------------------------------
000146r 2                 ;   X当たり判定
000146r 2                 SEC
000146r 2                 SBC ZP_PLAYER_X
000146r 2                 ADC #3
000146r 2                 CMP #8
000146r 2                 ROR @ZR0_XHIT_FLAG        ; CをZR0 bit7に格納
000146r 2                 ; ---------------------------------------------------------------
000146r 2                 ;   Y
000146r 2                 ; 1px/tickより遅い可能性
000146r 2                 CLC
000146r 2                 LDA DMK1_LST+3,X          ; dY取得
000146r 2                 BPL @SKP_SECY
000146r 2                 SEC
000146r 2               @SKP_SECY:
000146r 2                 ROR                       ; C<-bit0 低速フラグ
000146r 2                 BCC @FAST
000146r 2                 ; 低速
000146r 2               @SLOW:
000146r 2                 LSR                       ; C<-bit1 負方向フラグ
000146r 2                 PHA                       ; マスク値を退避
000146r 2                 BCS @MINUS
000146r 2                 LDA #1
000146r 2                 .BYT $2C                  ; 例のテクニック
000146r 2               @MINUS:
000146r 2                 LDA #255
000146r 2                 STA @ZR1_DIFF
000146r 2                 PLA                       ; マスク値を復帰
000146r 2                 AND ZP_GENERAL_CNT        ; マスク値
000146r 2                 BEQ @SKP_ZERO             ; ゼロなら1/-1を反映
000146r 2                 STZ @ZR1_DIFF
000146r 2               @SKP_ZERO:
000146r 2                 LDA @ZR1_DIFF
000146r 2                 ; 高速のばあいそのまま足す
000146r 2               @FAST:
000146r 2               @ADD:
000146r 2                 CLC
000146r 2                 ADC DMK1_LST+1,X
000146r 2               @STORE:
000146r 2                 STA DMK1_LST+1,X          ; リストに格納
000146r 2                 STA ZP_CANVAS_Y           ; 描画用座標
000146r 2                 INY
000146r 2                 STA (ZP_BLACKLIST_PTR),Y  ; BL格納
000146r 2                 DEY                       ; DELに備えて戻しておく
000146r 2                 SEC
000146r 2                 SBC #TOP_MARGIN
000146r 2                 CMP #192-TOP_MARGIN
000146r 2                 BCS @DEL
000146r 2                 INY                       ; DELは回避された
000146r 2                 ; ---------------------------------------------------------------
000146r 2                 ;   Y当たり判定
000146r 2                 BBS7 ZR0,@SKP_COL_Y       ; XがヒットしてなければY判定もスキップ
000146r 2                 LDA ZP_CANVAS_Y
000146r 2                 ;SEC                      ; BCSでC=0が保証されている
000146r 2                 SBC ZP_PLAYER_Y           ; 1余計に引いている
000146r 2                 ADC #3+1                  ; 1余計に足しておく
000146r 2                 CMP #8
000146r 2                 BCS @SKP_COL_Y
000146r 2                 ; ---------------------------------------------------------------
000146r 2                 ;   プレイヤダメージ
000146r 2                 PHX
000146r 2                 JSR KILL_PLAYER
000146r 2                 PLX
000146r 2               @SKP_COL_Y:
000146r 2                 ; ---------------------------------------------------------------
000146r 2                 ;   インデックス更新
000146r 2                 TXA
000146r 2                 CLC
000146r 2                 ADC #4                    ; TAXとするとINX*4にサイクル数まで等価
000146r 2                 PHA                       ; しかしスタック退避を考慮するとこっちが有利
000146r 2                 INY
000146r 2                 ; ---------------------------------------------------------------
000146r 2                 ;   実際の描画
000146r 2                 PHY
000146r 2                 loadmem16 ZP_CHAR_PTR,CHAR_DAT_DMK1
000146r 2                 JSR DRAW_CHAR8            ; 描画する
000146r 2                 PLY
000146r 2                 PLX
000146r 2                 ;BRA @LOOP                 ; PL弾処理ループ
000146r 2                 JMP @LOOP
000146r 2               @END:
000146r 2               .endmac
000146r 2               
000146r 2               ; -------------------------------------------------------------------
000146r 2               ;                            DMK1削除
000146r 2               ; -------------------------------------------------------------------
000146r 2               ; 対象インデックスはXで与えられる
000146r 2               DEL_DMK1:
000146r 2  A4 rr          LDY ZP_DMK1_TERMIDX  ; Y:終端インデックス
000148r 2  B9 rr rr       LDA DMK1_LST-4,Y     ; 終端部データX取得
00014Br 2  9D rr rr       STA DMK1_LST,X       ; 対象Xに格納
00014Er 2  B9 rr rr       LDA DMK1_LST-3,Y     ; 終端部データX取得
000151r 2  9D rr rr       STA DMK1_LST+1,X     ; 対象Xに格納
000154r 2  B9 rr rr       LDA DMK1_LST-2,Y     ; 終端部データX取得
000157r 2  9D rr rr       STA DMK1_LST+2,X     ; 対象Xに格納
00015Ar 2  B9 rr rr       LDA DMK1_LST-1,Y     ; 終端部データX取得
00015Dr 2  9D rr rr       STA DMK1_LST+3,X     ; 対象Xに格納
000160r 2  98             TYA
000161r 2  38             SEC
000162r 2  E9 04          SBC #4
000164r 2  85 rr          STA ZP_DMK1_TERMIDX  ; 縮小した終端インデックス
000166r 2  60             RTS
000167r 2               
000167r 2               SPEED_TABLE:
000167r 2  08 08 08 08    .REPEAT 128
00016Br 2  08 08 08 08  
00016Fr 2  08 08 08 08  
000267r 2                 .BYT 8,8
000267r 2                 .ENDREP
000267r 2               
000267r 2               
000267r 1                 .INCLUDE "./+stg/se.s"
000267r 2               ; -------------------------------------------------------------------
000267r 2               ;                           効果音定数
000267r 2               ; -------------------------------------------------------------------
000267r 2               SE1_LENGTH = 5
000267r 2               SE1_NUMBER = 1*2
000267r 2               SE2_LENGTH = 5
000267r 2               SE2_NUMBER = 2*2
000267r 2               
000267r 2               ; -------------------------------------------------------------------
000267r 2               ;                               ZP領域
000267r 2               ; -------------------------------------------------------------------
000267r 2               .ZEROPAGE
000025r 2                 ; SOUND
000025r 2  xx             ZP_SE_STATE:        .RES 1        ; 効果音の状態
000026r 2  xx             ZP_SE_TIMER:        .RES 1
000027r 2               
000027r 2               .SEGMENT "LIB"
000267r 2               
000267r 2               ; -------------------------------------------------------------------
000267r 2               ;                   YMZ内部レジスタに値を格納する
000267r 2               ; -------------------------------------------------------------------
000267r 2               .macro set_ymzreg addr,dat
000267r 2                 LDA addr
000267r 2                 STA YMZ::ADDR
000267r 2                 LDA dat
000267r 2                 STA YMZ::DATA
000267r 2               .endmac
000267r 2               
000267r 2               ; -------------------------------------------------------------------
000267r 2               ;                   Aで与えられた番号のSEを鳴らす
000267r 2               ; -------------------------------------------------------------------
000267r 2               ; X使用
000267r 2               PLAY_SE:
000267r 2  85 rr          STA ZP_SE_STATE
000269r 2  4A             LSR
00026Ar 2  AA             TAX
00026Br 2  BD rr rr       LDA SE_LENGTH_TABLE-1,X
00026Er 2  85 rr          STA ZP_SE_TIMER
000270r 2               @END:
000270r 2  60             RTS
000271r 2               
000271r 2               ; -------------------------------------------------------------------
000271r 2               ;                       効果音ティック処理
000271r 2               ; -------------------------------------------------------------------
000271r 2               .macro tick_se
000271r 2               TICK_SE:
000271r 2                 LDX ZP_SE_STATE       ; 効果音状態
000271r 2                 BEQ TICK_SE_END       ; 何も鳴ってないなら無視
000271r 2                 JMP (SE_TICK_JT-2,X)  ; 鳴っているので効果音種類ごとの処理に跳ぶ
000271r 2               TICK_SE_RETURN:         ; ここに帰ってくる
000271r 2                 DEC ZP_SE_TIMER       ; タイマー減算
000271r 2                 BNE TICK_SE_END
000271r 2                 ; 0になった
000271r 2                 set_ymzreg #YMZ::IA_MIX,#%00111111
000271r 2                 STZ ZP_SE_STATE
000271r 2               TICK_SE_END:
000271r 2               .endmac
000271r 2               
000271r 2               ; -------------------------------------------------------------------
000271r 2               ;                        効果音種類テーブル
000271r 2               ; -------------------------------------------------------------------
000271r 2               SE_LENGTH_TABLE:
000271r 2  05             .BYTE SE1_LENGTH      ; 1
000272r 2  05             .BYTE SE2_LENGTH      ; 2
000273r 2               
000273r 2               SE_TICK_JT:
000273r 2  rr rr          .WORD SE1_TICK
000275r 2  rr rr          .WORD SE2_TICK
000277r 2               
000277r 2               ; -------------------------------------------------------------------
000277r 2               ;                         各効果音ティック
000277r 2               ; -------------------------------------------------------------------
000277r 2               SE1_TICK:
000277r 2  A5 rr          LDA ZP_SE_TIMER
000279r 2  C9 05          CMP #SE1_LENGTH
00027Br 2  D0 2B          BNE @a
00027Dr 2  A9 07 8D 00    set_ymzreg #YMZ::IA_MIX,#%00111110
000281r 2  E4 A9 3E 8D  
000285r 2  01 E4        
000287r 2  A9 01 8D 00    set_ymzreg #YMZ::IA_FRQ+1,#>(125000/800)
00028Br 2  E4 A9 00 8D  
00028Fr 2  01 E4        
000291r 2  A9 00 8D 00    set_ymzreg #YMZ::IA_FRQ,#<(125000/800)
000295r 2  E4 A9 9C 8D  
000299r 2  01 E4        
00029Br 2  A9 08 8D 00    set_ymzreg #YMZ::IA_VOL,#$0F
00029Fr 2  E4 A9 0F 8D  
0002A3r 2  01 E4        
0002A5r 2  4C rr rr       JMP TICK_SE_RETURN
0002A8r 2               @a:
0002A8r 2  A2 08          LDX #YMZ::IA_VOL
0002AAr 2  8E 00 E4       STX YMZ::ADDR
0002ADr 2  0A             ASL                       ; タイマーの左シフト、最大8
0002AEr 2  69 04          ADC #4
0002B0r 2  8D 01 E4       STA YMZ::DATA
0002B3r 2  4C rr rr       JMP TICK_SE_RETURN
0002B6r 2               
0002B6r 2               SE2_TICK:
0002B6r 2  A9 07 8D 00    set_ymzreg #YMZ::IA_MIX,#%00110111
0002BAr 2  E4 A9 37 8D  
0002BEr 2  01 E4        
0002C0r 2  A9 06 8D 00    set_ymzreg #YMZ::IA_NOISE_FRQ,#>(125000/400)
0002C4r 2  E4 A9 01 8D  
0002C8r 2  01 E4        
0002CAr 2  A9 08 8D 00    set_ymzreg #YMZ::IA_VOL,#$0F
0002CEr 2  E4 A9 0F 8D  
0002D2r 2  01 E4        
0002D4r 2  4C rr rr       JMP TICK_SE_RETURN
0002D7r 2               
0002D7r 2               
0002D7r 1                 .INCLUDE "./+stg/enem.s"
0002D7r 2               
0002D7r 2               NANAMETTA_SHOOTRATE = 30
0002D7r 2               
0002D7r 2               ; -------------------------------------------------------------------
0002D7r 2               ;                           敵種類リスト
0002D7r 2               ; -------------------------------------------------------------------
0002D7r 2               ENEM_CODE_0_NANAMETTA          = 0*2  ; ナナメッタ。プレイヤーを狙ってか狙わずか、斜めに撃つ。
0002D7r 2               ENEM_CODE_1_YOKOGIRYA          = 1*2  ; ヨコギリャ。左右から現れ反対方向に直進し、プレイヤに弾を落とす。
0002D7r 2               
0002D7r 2               ; -------------------------------------------------------------------
0002D7r 2               ;                             ZP領域
0002D7r 2               ; -------------------------------------------------------------------
0002D7r 2               .ZEROPAGE
000027r 2  xx             ZP_ENEM_TERMIDX:    .RES 1    ; ENEM_LSTの終端を指す
000028r 2  xx             ZP_ENEM_CODEWK:     .RES 1    ; 作業用敵種類
000029r 2  xx             ZP_ENEM_XWK:        .RES 1    ; X退避
00002Ar 2  xx             ZP_ENEM_CODEFLAGWK: .RES 1    ; CODEにひそむフラグ
00002Br 2               
00002Br 2               ; -------------------------------------------------------------------
00002Br 2               ;                            変数領域
00002Br 2               ; -------------------------------------------------------------------
00002Br 2               .BSS
000503r 2  xx xx xx xx    ENEM_LST:         .RES 256  ; (code,X,Y,f),(code,X,Y,f),...
000507r 2  xx xx xx xx  
00050Br 2  xx xx xx xx  
000603r 2               
000603r 2               .SEGMENT "LIB"
0002D7r 2               
0002D7r 2               ; -------------------------------------------------------------------
0002D7r 2               ;                             敵生成
0002D7r 2               ; -------------------------------------------------------------------
0002D7r 2               .macro make_enem1
0002D7r 2                 LDY ZP_ENEM_TERMIDX
0002D7r 2                 LDA #ENEM_CODE_0_NANAMETTA
0002D7r 2                 STA ENEM_LST,Y        ; code
0002D7r 2                 LDA ZP_PLAYER_X
0002D7r 2                 STA ENEM_LST+1,Y      ; X
0002D7r 2                 LDA #TOP_MARGIN+1
0002D7r 2                 STA ENEM_LST+2,Y      ; Y
0002D7r 2                 LDA #NANAMETTA_SHOOTRATE
0002D7r 2                 STA ENEM_LST+3,Y      ; T
0002D7r 2                 ; ---------------------------------------------------------------
0002D7r 2                 ;   インデックス更新
0002D7r 2                 TYA
0002D7r 2                 CLC
0002D7r 2                 ADC #4                    ; TAXとするとINX*4にサイクル数まで等価
0002D7r 2                 STA ZP_ENEM_TERMIDX
0002D7r 2               .endmac
0002D7r 2               
0002D7r 2               ; -------------------------------------------------------------------
0002D7r 2               ;                             敵削除
0002D7r 2               ; -------------------------------------------------------------------
0002D7r 2               ; 対象インデックスはXで与えられる
0002D7r 2               DEL_ENEM:
0002D7r 2  A4 rr          LDY ZP_ENEM_TERMIDX ; Y:終端インデックス
0002D9r 2  B9 rr rr       LDA ENEM_LST-4,Y    ; 終端部データcode取得
0002DCr 2  9D rr rr       STA ENEM_LST,X      ; 対象codeに格納
0002DFr 2  B9 rr rr       LDA ENEM_LST-3,Y    ; 終端部データX取得
0002E2r 2  9D rr rr       STA ENEM_LST+1,X    ; 対象Xに格納
0002E5r 2  B9 rr rr       LDA ENEM_LST-2,Y    ; 終端部データY取得
0002E8r 2  9D rr rr       STA ENEM_LST+2,X    ; 対象Yに格納
0002EBr 2  B9 rr rr       LDA ENEM_LST-1,Y    ; 終端部データT取得
0002EEr 2  9D rr rr       STA ENEM_LST+3,X    ; 対象Tに格納
0002F1r 2                 ; ---------------------------------------------------------------
0002F1r 2                 ;   インデックス更新
0002F1r 2  98             TYA
0002F2r 2  38             SEC
0002F3r 2  E9 04          SBC #4                    ; TAXとするとINX*4にサイクル数まで等価
0002F5r 2  85 rr          STA ZP_ENEM_TERMIDX
0002F7r 2  60             RTS
0002F8r 2               
0002F8r 2               ; -------------------------------------------------------------------
0002F8r 2               ;                           敵ティック
0002F8r 2               ; -------------------------------------------------------------------
0002F8r 2               ; Yはブラックリストインデックス
0002F8r 2               .macro tick_enem
0002F8r 2               TICK_ENEM:
0002F8r 2                 ; ---------------------------------------------------------------
0002F8r 2                 ;   ENEMリストループ
0002F8r 2                 LDX #$0                   ; X:敵リスト用インデックス
0002F8r 2               TICK_ENEM_LOOP:
0002F8r 2                 CPX ZP_ENEM_TERMIDX
0002F8r 2                 BCC @SKP_END
0002F8r 2                 JMP TICK_ENEM_END         ; 敵をすべて処理したなら敵処理終了
0002F8r 2               @SKP_END:
0002F8r 2                 STX ZP_ENEM_XWK
0002F8r 2                 LDA ENEM_LST,X            ; 敵コード取得
0002F8r 2                 ROR                       ; LSBはインデックス参照用としては無視する
0002F8r 2                 ROR ZP_ENEM_CODEFLAGWK    ; LSBをフラグとして格納 MSBに
0002F8r 2                 ASL
0002F8r 2                 STA ZP_ENEM_CODEWK        ; 作業用
0002F8r 2                 LDA ENEM_LST+1,X          ; 敵X座標取得
0002F8r 2                 STA ZP_CANVAS_X           ; 作業用に、描画用ゼロページを使う
0002F8r 2                 LDA ENEM_LST+2,X
0002F8r 2                 STA ZP_CANVAS_Y           ; 作業用に、描画用ゼロページを使う
0002F8r 2                 ; ---------------------------------------------------------------
0002F8r 2                 ;   PLBLTとの当たり判定
0002F8r 2                 PHY                       ; BLIDX退避
0002F8r 2                 LDY #$FE                  ; PL弾インデックス
0002F8r 2               @COL_PLBLT_LOOP:
0002F8r 2                 INY
0002F8r 2                 INY
0002F8r 2                 CPY ZP_PLBLT_TERMIDX      ; PL弾インデックスの終端確認
0002F8r 2                 BEQ @END_COL_PLBLT
0002F8r 2                 ; ---------------------------------------------------------------
0002F8r 2                 ;   X判定
0002F8r 2                 LDA ZP_CANVAS_X           ; 敵X座標取得
0002F8r 2                 SEC
0002F8r 2                 SBC PLBLT_LST,Y           ; PL弾X座標を減算
0002F8r 2                 ADC #8                    ; -8が0に
0002F8r 2                 CMP #16
0002F8r 2                 BCS @COL_PLBLT_LOOP
0002F8r 2                 ; ---------------------------------------------------------------
0002F8r 2                 ;   Y判定
0002F8r 2                 LDA ZP_CANVAS_Y           ; 敵Y座標取得
0002F8r 2                 SEC
0002F8r 2                 SBC PLBLT_LST+1,Y
0002F8r 2                 ADC #8                    ; -8が0に
0002F8r 2                 CMP #16
0002F8r 2                 BCS @COL_PLBLT_LOOP
0002F8r 2                 ; ---------------------------------------------------------------
0002F8r 2                 ;   敵被弾
0002F8r 2                 LDX ZP_ENEM_CODEWK        ; ジャンプテーブル用に
0002F8r 2                 JMP (ENEM_HIT_JT,X)
0002F8r 2               @END_COL_PLBLT:
0002F8r 2                 ; ---------------------------------------------------------------
0002F8r 2                 ;   個別更新処理（移動、射撃、など
0002F8r 2                 LDX ZP_ENEM_CODEWK        ; ジャンプテーブル用に
0002F8r 2                 JMP (ENEM_UPDATE_JT,X)
0002F8r 2               TICK_ENEM_UPDATE_END:
0002F8r 2                 ; ---------------------------------------------------------------
0002F8r 2                 ;   BL登録
0002F8r 2                 PLY
0002F8r 2                 LDA ZP_CANVAS_X
0002F8r 2                 STA (ZP_BLACKLIST_PTR),Y  ; BL格納X
0002F8r 2                 INY
0002F8r 2                 LDA ZP_CANVAS_Y
0002F8r 2                 STA (ZP_BLACKLIST_PTR),Y  ; BL格納Y
0002F8r 2                 INY
0002F8r 2                 ; ---------------------------------------------------------------
0002F8r 2                 ;   インデックス更新
0002F8r 2                 LDA ZP_ENEM_XWK
0002F8r 2                 CLC
0002F8r 2                 ADC #4
0002F8r 2                 PHA
0002F8r 2                 ; ---------------------------------------------------------------
0002F8r 2                 ;   実際の描画
0002F8r 2                 PHY
0002F8r 2                 JSR DRAW_CHAR8            ; 描画する
0002F8r 2                 PLY
0002F8r 2                 PLX
0002F8r 2                 BRA TICK_ENEM_LOOP        ; 敵処理ループ
0002F8r 2               TICK_ENEM_END:
0002F8r 2               .endmac
0002F8r 2               
0002F8r 2               ; -------------------------------------------------------------------
0002F8r 2               ;                             敵個別
0002F8r 2               ; -------------------------------------------------------------------
0002F8r 2               ; -------------------------------------------------------------------
0002F8r 2               ;                        敵更新処理テーブル
0002F8r 2               ; -------------------------------------------------------------------
0002F8r 2               ENEM_UPDATE_JT:
0002F8r 2  rr rr          .WORD NANAMETTA_UPDATE
0002FAr 2  rr rr          .WORD YOKOGIRYA_UPDATE
0002FCr 2               
0002FCr 2               NANAMETTA_UPDATE:
0002FCr 2  8F rr 50       BBS0 ZP_GENERAL_CNT,@LOAD_TEXTURE ; 移動1/2
0002FFr 2  9F rr 41       BBS1 ZP_GENERAL_CNT,@MOVE         ; 射撃1/4
000302r 2                 ; ---------------------------------------------------------------
000302r 2                 ;   射撃判定
000302r 2  A6 rr          LDX ZP_ENEM_XWK
000304r 2  BD rr rr       LDA ENEM_LST+3,X          ; T取得
000307r 2  3A             DEC                       ; T減算
000308r 2  D0 02          BNE @SKP_TRESET
00030Ar 2  A9 1E          LDA #NANAMETTA_SHOOTRATE
00030Cr 2               @SKP_TRESET:
00030Cr 2  9D rr rr       STA ENEM_LST+3,X          ; クールダウン更新
00030Fr 2  C9 08          CMP #8
000311r 2  B0 30          BCS @SKP_SHOT
000313r 2  6A             ROR
000314r 2  B0 2D          BCS @SKP_SHOT
000316r 2                 ; ---------------------------------------------------------------
000316r 2                 ;   射撃
000316r 2  A4 rr          LDY ZP_DMK1_TERMIDX       ; Y:DMK1インデックス
000318r 2                 ; X
000318r 2  A5 rr          LDA ZP_CANVAS_X
00031Ar 2  99 rr rr       STA DMK1_LST,Y            ; X
00031Dr 2                 ; dX
00031Dr 2  C5 rr          CMP ZP_PLAYER_X           ; PL-Xと比較
00031Fr 2                 ;LDA #1
00031Fr 2  A9 02          LDA #(1<<1)
000321r 2  90 02          BCC @SKP_ADC256a
000323r 2                 ;LDA #256-1
000323r 2  A9 FE          LDA #<(255<<1)
000325r 2                 @SKP_ADC256a:
000325r 2  99 rr rr       STA DMK1_LST+2,Y          ; dX
000328r 2                 ; Y
000328r 2  A5 rr          LDA ZP_CANVAS_Y
00032Ar 2  99 rr rr       STA DMK1_LST+1,Y          ; Y
00032Dr 2                 ; dY
00032Dr 2  C5 rr          CMP ZP_PLAYER_Y           ; PL-Xと比較
00032Fr 2                 ;LDA #1
00032Fr 2  A9 02          LDA #(1<<1)
000331r 2  90 02          BCC @SKP_ADC256b
000333r 2                 ;LDA #256-1
000333r 2  A9 FE          LDA #<(255<<1)
000335r 2                 @SKP_ADC256b:
000335r 2  99 rr rr       STA DMK1_LST+3,Y          ; dY
000338r 2  98             TYA
000339r 2  18             CLC
00033Ar 2  69 04          ADC #4
00033Cr 2  85 rr          STA ZP_DMK1_TERMIDX       ; DMK1終端更新
00033Er 2  A9 02          LDA #SE1_NUMBER
000340r 2  20 rr rr       JSR PLAY_SE               ; 発射音再生 X使用
000343r 2               @SKP_SHOT:
000343r 2                 ; ---------------------------------------------------------------
000343r 2                 ;   移動
000343r 2                 ;    ゆっくり降りてきて、適当なところで止まる
000343r 2               @MOVE:
000343r 2  A6 rr          LDX ZP_ENEM_XWK
000345r 2  A5 rr          LDA ZP_CANVAS_Y
000347r 2  1A             INC
000348r 2  C9 50          CMP #80
00034Ar 2  F0 03          BEQ @LOAD_TEXTURE
00034Cr 2  9D rr rr       STA ENEM_LST+2,X
00034Fr 2                 ;INC ZP_CANVAS_X
00034Fr 2                 ;LDA ENEM1_LST,X
00034Fr 2                 ;ADC #$80
00034Fr 2                 ;CLC
00034Fr 2                 ;ADC #256-1
00034Fr 2                 ;BVC @SKP_DEL_LEFT
00034Fr 2                 ; ENEM1削除
00034Fr 2                 ;PHY
00034Fr 2                 ;JSR DEL_ENEM1
00034Fr 2                 ;PLY
00034Fr 2                 ;JMP @DRAWPLBL
00034Fr 2               ;@SKP_DEL_LEFT:
00034Fr 2                 ;SEC
00034Fr 2                 ;SBC #$80
00034Fr 2                 ;STA ENEM1_LST,X
00034Fr 2               @LOAD_TEXTURE:
00034Fr 2  A9 rr 85 rr    loadmem16 ZP_CHAR_PTR,CHAR_DAT_TEKI2
000353r 2  A9 rr 85 rr  
000357r 2  4C rr rr       JMP TICK_ENEM_UPDATE_END
00035Ar 2               
00035Ar 2               YOKOGIRYA_UPDATE:
00035Ar 2                 ; ---------------------------------------------------------------
00035Ar 2                 ;   射撃判定
00035Ar 2  A5 rr          LDA ZP_CANVAS_X
00035Cr 2  38             SEC
00035Dr 2  E5 rr          SBC ZP_PLAYER_X
00035Fr 2  69 03          ADC #3
000361r 2  C9 08          CMP #8
000363r 2  B0 2D          BCS @SKP_SHOT
000365r 2  FF rr 2A       BBS7 ZP_ENEM_CODEFLAGWK,@SKP_SHOT ; 射撃済みならやめておく
000368r 2                 ; ---------------------------------------------------------------
000368r 2                 ;   射撃
000368r 2  A6 rr          LDX ZP_ENEM_XWK           ; 射撃及び移動に使うENEMIDX
00036Ar 2  A5 rr          LDA ZP_ENEM_CODEWK
00036Cr 2  09 01          ORA #%00000001            ; 射撃済みフラグを立てる
00036Er 2  9D rr rr       STA ENEM_LST,X            ; 更新
000371r 2  A4 rr          LDY ZP_DMK1_TERMIDX       ; Y:DMK1インデックス
000373r 2                 ; X
000373r 2  A5 rr          LDA ZP_CANVAS_X
000375r 2  99 rr rr       STA DMK1_LST,Y            ; X
000378r 2                 ; dX
000378r 2  A9 00          LDA #0
00037Ar 2  99 rr rr       STA DMK1_LST+2,Y          ; dX
00037Dr 2                 ; Y
00037Dr 2  A5 rr          LDA ZP_CANVAS_Y
00037Fr 2  99 rr rr       STA DMK1_LST+1,Y          ; Y
000382r 2                 ; dY
000382r 2                 ;LDA #2
000382r 2  A9 04          LDA #(2<<1)
000384r 2  99 rr rr       STA DMK1_LST+3,Y          ; dY
000387r 2  98             TYA
000388r 2  18             CLC
000389r 2  69 04          ADC #4
00038Br 2  85 rr          STA ZP_DMK1_TERMIDX       ; DMK1終端更新
00038Dr 2  A9 02          LDA #SE1_NUMBER
00038Fr 2  20 rr rr       JSR PLAY_SE               ; 発射音再生 X使用
000392r 2               @SKP_SHOT:
000392r 2                 ; ---------------------------------------------------------------
000392r 2                 ;   移動
000392r 2               @MOVE:
000392r 2  A6 rr          LDX ZP_ENEM_XWK           ; 射撃及び移動に使うENEMIDX
000394r 2  A5 rr          LDA ZP_CANVAS_X
000396r 2  18             CLC
000397r 2  69 80          ADC #$80
000399r 2  18             CLC
00039Ar 2  7D rr rr       ADC ENEM_LST+3,X          ; Tを加算
00039Dr 2                 ; 逸脱判定
00039Dr 2  50 09          BVC @SKP_DEL_LEFT
00039Fr 2                 ; 削除
00039Fr 2  20 rr rr       JSR DEL_ENEM
0003A2r 2  A6 rr          LDX ZP_ENEM_XWK
0003A4r 2  7A             PLY                       ; BLPTR
0003A5r 2  4C rr rr       JMP TICK_ENEM_LOOP        ; もう存在しないので描画等すっ飛ばす
0003A8r 2               @SKP_DEL_LEFT:
0003A8r 2  E9 80          SBC #$80
0003AAr 2  85 rr          STA ZP_CANVAS_X
0003ACr 2  9D rr rr       STA ENEM_LST+1,X
0003AFr 2               @LOAD_TEXTURE:
0003AFr 2  A9 rr 85 rr    loadmem16 ZP_CHAR_PTR,CHAR_DAT_TEKI3
0003B3r 2  A9 rr 85 rr  
0003B7r 2  4C rr rr       JMP TICK_ENEM_UPDATE_END
0003BAr 2               
0003BAr 2               ; -------------------------------------------------------------------
0003BAr 2               ;                        敵被弾処理テーブル
0003BAr 2               ; -------------------------------------------------------------------
0003BAr 2               ENEM_HIT_JT:
0003BAr 2  rr rr          .WORD NANAMETTA_HIT
0003BCr 2  rr rr          .WORD NANAMETTA_HIT
0003BEr 2               
0003BEr 2               NANAMETTA_HIT:
0003BEr 2  A6 rr          LDX ZP_ENEM_XWK
0003C0r 2  20 rr rr       JSR DEL_ENEM              ; 敵削除
0003C3r 2  A9 04          LDA #SE2_NUMBER
0003C5r 2  20 rr rr       JSR PLAY_SE               ; 撃破効果音
0003C8r 2  A6 rr          LDX ZP_ENEM_XWK
0003CAr 2  7A             PLY                       ; BLPTR
0003CBr 2  4C rr rr       JMP TICK_ENEM_LOOP
0003CEr 2               
0003CEr 2               ; -------------------------------------------------------------------
0003CEr 2               ;                             敵画像
0003CEr 2               ; -------------------------------------------------------------------
0003CEr 2               CHAR_DAT_TEKI1:
0003CEr 2  00 D8 88 00    .INCBIN "+stg/teki1-88-tate.bin"
0003D2r 2  00 0E 80 00  
0003D6r 2  D0 0D 80 08  
0003EEr 2               
0003EEr 2               CHAR_DAT_TEKI2:
0003EEr 2  00 0D D0 00    .INCBIN "+stg/teki2-88-tate.bin"
0003F2r 2  00 DF FD 00  
0003F6r 2  0B 1F F1 B0  
00040Er 2               
00040Er 2               CHAR_DAT_TEKI3:
00040Er 2  0F 00 0F F0    .INCBIN "+stg/teki3-88.bin"
000412r 2  F0 00 0F 0F  
000416r 2  FF 0F F0 00  
00042Er 2               
00042Er 2               
00042Er 1                 .INCLUDE "./+stg/title.s"
00042Er 2               STARS_NUM = 10
00042Er 2               ; -------------------------------------------------------------------
00042Er 2               ;                               ZP領域
00042Er 2               ; -------------------------------------------------------------------
00042Er 2               .ZEROPAGE
00002Br 2  xx             ZP_START_FLAG:      .RES 1
00002Cr 2  xx             ZP_STARS_INDEX:     .RES 1
00002Dr 2               
00002Dr 2               ; -------------------------------------------------------------------
00002Dr 2               ;                             実行領域
00002Dr 2               ; -------------------------------------------------------------------
00002Dr 2               .SEGMENT "LIB"
00042Er 2               
00042Er 2               INIT_TITLE:
00042Er 2                 ; ---------------------------------------------------------------
00042Er 2                 ;   CRTC
00042Er 2  A9 01          LDA #%00000001            ; 全フレーム16色モード、16色モード座標書き込み、書き込みカウントアップ有効
000430r 2  8D 01 E6       STA CRTC::CFG
000433r 2  A9 55          LDA #%01010101            ; フレームバッファ1
000435r 2  8D 05 E6       STA CRTC::RF              ; FB1を表示
000438r 2  8D 06 E6       STA CRTC::WF              ; FB1を書き込み先に
00043Br 2                 ; ---------------------------------------------------------------
00043Br 2                 ;   変数の初期化
00043Br 2  64 rr          STZ ZP_START_FLAG
00043Dr 2                 ; 画像表示
00043Dr 2  A9 rr A0 rr    loadAY16 PATH_TITLEIMF
000441r 2  20 rr rr       JSR IMF::PRINT_IMF
000444r 2                 ; CRTC再設定
000444r 2  A9 00          LDA #%00000000            ; 全フレーム16色モード、16色モード座標書き込み、書き込みカウントアップ無効
000446r 2  8D 01 E6       STA CRTC::CFG
000449r 2                 ; ---------------------------------------------------------------
000449r 2                 ;   割り込みハンドラの登録
000449r 2  78             SEI
00044Ar 2  A9 rr A0 rr    loadAY16 TITLE_VBLANK
00044Er 2  A2 26 20 03    syscall IRQ_SETHNDR_VB
000452r 2  06           
000453r 2  85 rr 84 rr    storeAY16 ZP_VB_STUB
000457r 2  58             CLI
000458r 2                 ; 無限ループ
000458r 2               TITLE_LOOP:
000458r 2  0F rr FD       BBR0 ZP_START_FLAG,TITLE_LOOP
00045Br 2                 ; ---------------------------------------------------------------
00045Br 2                 ; 脱出
00045Br 2                 ; ---------------------------------------------------------------
00045Br 2                 ;   割り込みハンドラの抹消
00045Br 2  78             SEI
00045Cr 2  A5 rr A4 rr    mem2AY16 ZP_VB_STUB
000460r 2  A2 26 20 03    syscall IRQ_SETHNDR_VB
000464r 2  06           
000465r 2  58             CLI
000466r 2  4C rr rr       JMP INIT_GAME
000469r 2               
000469r 2               ; -------------------------------------------------------------------
000469r 2               ;                        綺羅星ティック
000469r 2               ; -------------------------------------------------------------------
000469r 2               .macro kiraboshi
000469r 2                 LDX #0                    ; 星インデックス
000469r 2                 STX ZP_STARS_INDEX
000469r 2               KIRABOSHI_LOOP:
000469r 2                 ; 座標設定
000469r 2                 ; NOTE:結構無駄
000469r 2                 LDA TITLE_STARS_LIST,X    ; X
000469r 2                 STA CRTC::VMAH
000469r 2                 LDA TITLE_STARS_LIST+1,X  ; Y
000469r 2                 STA CRTC::VMAV
000469r 2                 ; ON/OFF判定
000469r 2                 LDA TITLE_STARS_LIST+2,X  ; マスク値を取得
000469r 2                 AND ZP_GENERAL_CNT
000469r 2                 CMP TITLE_STARS_LIST+3,X  ; ON
000469r 2                 BNE @SKP_ON
000469r 2                 ; ON
000469r 2                 LDA #$F0
000469r 2                 STA CRTC::WDBF
000469r 2                 BRA @SKP_OFF
000469r 2               @SKP_ON:
000469r 2                 CMP TITLE_STARS_LIST+4,X  ; OFF
000469r 2                 BNE @SKP_OFF
000469r 2                 ; OFF
000469r 2                 LDA #$00
000469r 2                 STA CRTC::WDBF
000469r 2               @SKP_OFF:
000469r 2                 ; ループ処理
000469r 2                 ; インデックス加算
000469r 2                 LDA #5
000469r 2                 CLC
000469r 2                 ADC ZP_STARS_INDEX
000469r 2                 STA ZP_STARS_INDEX
000469r 2                 TAX
000469r 2                 CPX #STARS_NUM*5
000469r 2                 BNE KIRABOSHI_LOOP
000469r 2               .endmac
000469r 2               
000469r 2               ; -------------------------------------------------------------------
000469r 2               ;                        垂直同期割り込み
000469r 2               ; -------------------------------------------------------------------
000469r 2               TITLE_VBLANK:
000469r 2  20 rr rr       JSR PAD_READ                ; パッド状態更新
00046Cr 2  CF rr 02       BBS4 ZP_PADSTAT,@SKP_START  ; STARTボタン
00046Fr 2  87 rr          SMB0 ZP_START_FLAG          ; フラグを立てて脱出を企画する
000471r 2               @SKP_START:
000471r 2  A2 00 86 rr    kiraboshi
000475r 2  BD rr rr 8D  
000479r 2  02 E6 BD rr  
0004A8r 2  E6 rr          INC ZP_GENERAL_CNT
0004AAr 2  6C rr rr       JMP (ZP_VB_STUB)            ; 片付けはBCOSにやらせる
0004ADr 2               
0004ADr 2               ; -------------------------------------------------------------------
0004ADr 2               ;                           データ部
0004ADr 2               ; -------------------------------------------------------------------
0004ADr 2               PATH_TITLEIMF:
0004ADr 2  2F 44 4F 43    .BYT "/DOC/STGTITLE.IMF",0
0004B1r 2  2F 53 54 47  
0004B5r 2  54 49 54 4C  
0004BFr 2               
0004BFr 2               TITLE_STARS_LIST:
0004BFr 2                 ;      0    1          2    3    4
0004BFr 2                 ;      X,   Y, %    mask,  ON, OFF
0004BFr 2  0B 2C FF 5A    .BYT  11,  44, %11111111,  90, 255
0004C3r 2  FF           
0004C4r 2  6F 5A 7F 14    .BYT 111,  90, %01111111,  20,  50
0004C8r 2  32           
0004C9r 2  38 9A 3F 0A    .BYT  56, 154, %00111111,  10,   5
0004CDr 2  05           
0004CEr 2  3C 0A 1F 13    .BYT  60,  10, %00011111,  19,  20
0004D2r 2  14           
0004D3r 2               
0004D3r 2  2C B5 FF 50    .BYT  44, 181, %11111111,  80, 200
0004D7r 2  C8           
0004D8r 2  14 0A 7F 1E    .BYT  20,  10, %01111111,  30,  40
0004DCr 2  28           
0004DDr 2  2A 66 3F 21    .BYT  42, 102, %00111111,  33,   8
0004E1r 2  08           
0004E2r 2  03 8E FF 5A    .BYT   3, 142, %11111111,  90, 255
0004E6r 2  FF           
0004E7r 2               
0004E7r 2  78 2B 7F 00    .BYT 120,  43, %01111111,   0,  30
0004EBr 2  1E           
0004ECr 2  66 8C 3F 32    .BYT 102, 140, %00111111,  50,  35
0004F0r 2  23           
0004F1r 2               
0004F1r 2               
0004F1r 1               
0004F1r 1               ; -------------------------------------------------------------------
0004F1r 1               ;                              変数領域
0004F1r 1               ; -------------------------------------------------------------------
0004F1r 1               .BSS
000603r 1  xx             FD_SAV:         .RES 1  ; ファイル記述子
000604r 1  xx xx          FINFO_SAV:      .RES 2  ; FINFO
000606r 1                 ; ブラックに塗りつぶすべき座標のリスト（命名がわるい
000606r 1                 ; 2バイトで座標が表現され、それを原点に8x8が黒で塗られる
000606r 1                 ; "Yの場所の"$FFが番人
000606r 1                 ; X,Y,X,Y,..,$??,$FF
000606r 1  xx xx xx xx    BLACKLIST1:     .RES 256
00060Ar 1  xx xx xx xx  
00060Er 1  xx xx xx xx  
000706r 1  xx xx xx xx    BLACKLIST2:     .RES 256
00070Ar 1  xx xx xx xx  
00070Er 1  xx xx xx xx  
000806r 1                 ; プレイヤの発射した弾丸
000806r 1  xx xx xx xx    PLBLT_LST:     .RES 32  ; (X,Y),(X,Y),...
00080Ar 1  xx xx xx xx  
00080Er 1  xx xx xx xx  
000826r 1               
000826r 1               ; -------------------------------------------------------------------
000826r 1               ;                             実行領域
000826r 1               ; -------------------------------------------------------------------
000826r 1               .CODE
000000r 1               
000000r 1               ; -------------------------------------------------------------------
000000r 1               ;                         プログラム初期化
000000r 1               ; -------------------------------------------------------------------
000000r 1               INIT_GENERAL:
000000r 1                 ; ---------------------------------------------------------------
000000r 1                 ;   IOレジスタの設定
000000r 1                 ; ---------------------------------------------------------------
000000r 1                 ;   汎用ポートの設定
000000r 1  AD 02 E2       LDA VIA::PAD_DDR          ; 0で入力、1で出力
000003r 1  09 06          ORA #(VIA::PAD_CLK|VIA::PAD_PTS)
000005r 1  29 FE          AND #<~(VIA::PAD_DAT)
000007r 1  8D 02 E2       STA VIA::PAD_DDR
00000Ar 1  4C rr rr       JMP INIT_TITLE
00000Dr 1               INIT_GAME:
00000Dr 1                 ; ---------------------------------------------------------------
00000Dr 1                 ;   CRTC
00000Dr 1  A9 01          LDA #%00000001            ; 全フレーム16色モード、16色モード座標書き込み、書き込みカウントアップ有効
00000Fr 1  8D 01 E6       STA CRTC::CFG
000012r 1  A9 55          LDA #%01010101            ; フレームバッファ1
000014r 1  85 rr          STA ZP_VISIBLE_FLAME
000016r 1  8D 05 E6       STA CRTC::RF              ; FB1を表示
000019r 1  8D 06 E6       STA CRTC::WF              ; FB1を書き込み先に
00001Cr 1                 ; ---------------------------------------------------------------
00001Cr 1                 ;   変数初期化
00001Cr 1  A9 FF          LDA #$FF                  ; ブラックリスト用番人
00001Er 1  8D rr rr       STA BLACKLIST1+1          ; 番人設定
000021r 1  8D rr rr       STA BLACKLIST2+1
000024r 1  85 rr          STA ZP_INFO_FLAG_P
000026r 1  85 rr          STA ZP_INFO_FLAG_S
000028r 1  A9 01          LDA #1
00002Ar 1  85 rr          STA ZP_PL_COOLDOWN
00002Cr 1  64 rr          STZ ZP_PLBLT_TERMIDX      ; PLBLT終端ポインタ
00002Er 1  64 rr          STZ ZP_ENEM_TERMIDX       ; ENEM終端ポインタ
000030r 1  64 rr          STZ ZP_DMK1_TERMIDX       ; DMK1終端ポインタ
000032r 1  64 rr          STZ ZP_PL_DX              ; プレイヤ速度初期値
000034r 1  64 rr          STZ ZP_PL_DY              ; プレイヤ速度初期値
000036r 1  A9 rr 85 rr    loadmem16 ZP_CMD_PTR,STAGE_CMDS
00003Ar 1  A9 rr 85 rr  
00003Er 1  64 rr          STZ ZP_CMD_WAIT_CNT
000040r 1  A9 03          LDA #ZANKI_START
000042r 1  85 rr          STA ZP_ZANKI
000044r 1  64 rr          STZ ZP_PL_STAT_FLAG
000046r 1                 ; ---------------------------------------------------------------
000046r 1                 ;   画面の初期化
000046r 1  A9 00          LDA #BGC
000048r 1  20 rr rr       JSR FILL_BG               ; FB1塗りつぶし
00004Br 1  A2 02          LDX #2                    ; FB2を書き込み先に
00004Dr 1  8E 06 E6       STX CRTC::WF
000050r 1  20 rr rr       JSR FILL_BG               ; FB2塗りつぶし
000053r 1  A9 7C          LDA #PLAYER_X
000055r 1  85 rr          STA ZP_PLAYER_X           ; プレイヤー初期座標
000057r 1  A9 A8          LDA #PLAYER_Y
000059r 1  85 rr          STA ZP_PLAYER_Y
00005Br 1                 ; ---------------------------------------------------------------
00005Br 1                 ;   効果音の初期化
00005Br 1  64 rr          STZ ZP_SE_STATE           ; サウンドの初期化
00005Dr 1                 ; ---------------------------------------------------------------
00005Dr 1                 ;   割り込みハンドラの登録
00005Dr 1  78             SEI
00005Er 1  A9 rr A0 rr    loadAY16 VBLANK
000062r 1  A2 26 20 03    syscall IRQ_SETHNDR_VB
000066r 1  06           
000067r 1  85 rr 84 rr    storeAY16 ZP_VB_STUB
00006Br 1  58             CLI
00006Cr 1                 ; 完全垂直同期割り込み駆動？
00006Cr 1               MAIN:
00006Cr 1                 ; 無限ループ
00006Cr 1                 ; 実際には下記の割り込みが走る
00006Cr 1  80 FE          BRA MAIN
00006Er 1               
00006Er 1               ; -------------------------------------------------------------------
00006Er 1               ;                             マクロ
00006Er 1               ; -------------------------------------------------------------------
00006Er 1               ; 割込みルーチンの見通しをよくするために、
00006Er 1               ; 一回きりの展開を想定したものもある
00006Er 1               
00006Er 1               ; -------------------------------------------------------------------
00006Er 1               ;                     ブラックリストポインタ作成
00006Er 1               ; -------------------------------------------------------------------
00006Er 1               .macro make_blacklist_ptr
00006Er 1                 LDA ZP_VISIBLE_FLAME    ; 可視取得
00006Er 1                 CMP #%10101010          ; F2が可視かな
00006Er 1                 BNE @F2
00006Er 1               @F1:                      ; F2が可視なら反対のF1を編集
00006Er 1                 LDA #>BLACKLIST1
00006Er 1                 BRA @SKP_F2
00006Er 1               @F2:                      ; F1が可視なら反対のF2を編集
00006Er 1                 LDA #>BLACKLIST2
00006Er 1               @SKP_F2:
00006Er 1                 STA ZP_BLACKLIST_PTR+1
00006Er 1                 LDA #<BLACKLIST1
00006Er 1                 STA ZP_BLACKLIST_PTR   ; アライメントしないので下位も設定
00006Er 1               .endmac
00006Er 1               
00006Er 1               ; -------------------------------------------------------------------
00006Er 1               ;           ブラックリストに沿って画面上エンティティ削除
00006Er 1               ; -------------------------------------------------------------------
00006Er 1               .macro clear_by_blacklist
00006Er 1                 LDY #0
00006Er 1               @BL_DEL_LOOP:
00006Er 1                 LDA (ZP_BLACKLIST_PTR),Y  ; X座標取得
00006Er 1                 LSR
00006Er 1                 TAX
00006Er 1                 INY
00006Er 1                 LDA (ZP_BLACKLIST_PTR),Y  ; Y座標取得
00006Er 1                 CMP #$FF
00006Er 1                 BEQ @BL_END
00006Er 1                 PHY
00006Er 1                 TAY
00006Er 1                 JSR DEL_SQ8               ; 塗りつぶす
00006Er 1                 PLY
00006Er 1                 INY
00006Er 1                 BRA @BL_DEL_LOOP
00006Er 1               @BL_END:
00006Er 1                 STY ZP_BL_INDEX
00006Er 1               .endmac
00006Er 1               
00006Er 1               ; -------------------------------------------------------------------
00006Er 1               ;                        アンチノイズ水平消去
00006Er 1               ; -------------------------------------------------------------------
00006Er 1               .macro anti_noise
00006Er 1                 .local @ANLLOOP
00006Er 1                 STZ CRTC::VMAH    ; 水平カーソルを左端に
00006Er 1                 LDA ZP_ANT_NZ_Y   ; アンチノイズY座標
00006Er 1                 STA CRTC::VMAV
00006Er 1                 LDX #$20          ; 繰り返し回数
00006Er 1                 LDA #BGC
00006Er 1               @ANLLOOP:
00006Er 1                 STA CRTC::WDBF    ; $8x$20=$100=256
00006Er 1                 STA CRTC::WDBF    ; 2行の塗りつぶし
00006Er 1                 STA CRTC::WDBF
00006Er 1                 STA CRTC::WDBF
00006Er 1                 STA CRTC::WDBF
00006Er 1                 STA CRTC::WDBF
00006Er 1                 STA CRTC::WDBF
00006Er 1                 STA CRTC::WDBF
00006Er 1                 DEX
00006Er 1                 BNE @ANLLOOP
00006Er 1                 INC ZP_ANT_NZ_Y
00006Er 1               .endmac
00006Er 1               
00006Er 1               ; -------------------------------------------------------------------
00006Er 1               ;                           フレーム交換
00006Er 1               ; -------------------------------------------------------------------
00006Er 1               .macro exchange_frame
00006Er 1                 LDA ZP_VISIBLE_FLAME
00006Er 1                 STA CRTC::WF
00006Er 1                 CLC
00006Er 1                 ROL ; %01010101と%10101010を交換する
00006Er 1                 ADC #0
00006Er 1                 STA ZP_VISIBLE_FLAME
00006Er 1                 STA CRTC::RF
00006Er 1               .endmac
00006Er 1               
00006Er 1               ; -------------------------------------------------------------------
00006Er 1               ;                             PL弾生成
00006Er 1               ; -------------------------------------------------------------------
00006Er 1               .macro make_pl_blt
00006Er 1                 LDY ZP_PLBLT_TERMIDX
00006Er 1                 LDA ZP_PLAYER_X
00006Er 1                 STA PLBLT_LST,Y      ; X
00006Er 1                 LDA ZP_PLAYER_Y
00006Er 1                 STA PLBLT_LST+1,Y    ; Y
00006Er 1                 INY
00006Er 1                 INY
00006Er 1                 STY ZP_PLBLT_TERMIDX
00006Er 1               .endmac
00006Er 1               
00006Er 1               ; -------------------------------------------------------------------
00006Er 1               ;                            PL弾削除
00006Er 1               ; -------------------------------------------------------------------
00006Er 1               ; 対象インデックスはXで与えられる
00006Er 1               DEL_PL_BLT:
00006Er 1  A4 rr          LDY ZP_PLBLT_TERMIDX  ; Y:終端インデックス
000070r 1  B9 rr rr       LDA PLBLT_LST-2,Y    ; 終端部データX取得
000073r 1  9D rr rr       STA PLBLT_LST,X      ; 対象Xに格納
000076r 1  B9 rr rr       LDA PLBLT_LST-1,Y    ; 終端部データY取得
000079r 1  9D rr rr       STA PLBLT_LST+1,X    ; 対象Yに格納
00007Cr 1  88             DEY
00007Dr 1  88             DEY
00007Er 1  84 rr          STY ZP_PLBLT_TERMIDX  ; 縮小した終端インデックス
000080r 1  60             RTS
000081r 1               
000081r 1               ; -------------------------------------------------------------------
000081r 1               ;                            プレイヤ死亡
000081r 1               ; -------------------------------------------------------------------
000081r 1               KILL_PLAYER:
000081r 1                 ; 無敵ならキャンセル
000081r 1  8F rr 13       BBS0 ZP_PL_STAT_FLAG,@SKP_KILL
000084r 1                 ; 効果音
000084r 1  A9 04          LDA #SE2_NUMBER
000086r 1  20 rr rr       JSR PLAY_SE               ; 撃破効果音
000089r 1                 ; 残機処理
000089r 1  C6 rr          DEC ZP_ZANKI              ; 残機減少
00008Br 1  87 rr          SMB0 ZP_INFO_FLAG_P       ; 残機再描画フラグを立てる
00008Dr 1                 ; 死亡無敵処理
00008Dr 1  87 rr          SMB0 ZP_PL_STAT_FLAG      ; 無敵フラグを立てる
00008Fr 1  A5 rr          LDA ZP_GENERAL_CNT
000091r 1  85 rr          STA ZP_DEATH_MUTEKI       ; 死亡時点を記録
000093r 1                 ; リスポーン
000093r 1  A9 7C          LDA #PLAYER_X
000095r 1  85 rr          STA ZP_PLAYER_X
000097r 1               @SKP_KILL:
000097r 1  60             RTS
000098r 1               
000098r 1               ; エンティティティック処理
000098r 1               ; -------------------------------------------------------------------
000098r 1               ;                         プレイヤティック
000098r 1               ; -------------------------------------------------------------------
000098r 1               .macro tick_player
000098r 1                 ; 死亡無敵解除
000098r 1                 BBR0 ZP_PL_STAT_FLAG,@SKP_DEATHMUTEKI  ; bit0 無敵でなければ処理の必要なし
000098r 1                 LDA ZP_GENERAL_CNT
000098r 1                 CMP ZP_DEATH_MUTEKI
000098r 1                 BNE @SKP_DEATHMUTEKI
000098r 1                 ; $FFティック経過
000098r 1                 RMB0 ZP_PL_STAT_FLAG  ; bit0 無敵フラグを折る
000098r 1               @SKP_DEATHMUTEKI:
000098r 1                 ; プレイヤ移動
000098r 1                 ; X
000098r 1                 LDA ZP_PLAYER_X
000098r 1                 CLC
000098r 1                 ADC ZP_PL_DX
000098r 1                 PHA
000098r 1                 SEC
000098r 1                 SBC #RL_MARGIN
000098r 1                 CMP #256-(RL_MARGIN*2)-4
000098r 1                 PLA
000098r 1                 BCS @SKP_NEW_X
000098r 1                 STA ZP_PLAYER_X
000098r 1               @SKP_NEW_X:
000098r 1                 ; Y
000098r 1                 LDA ZP_PLAYER_Y
000098r 1                 CLC
000098r 1                 ADC ZP_PL_DY
000098r 1                 PHA
000098r 1                 SEC
000098r 1                 SBC #TOP_MARGIN           ; 比較のためにテキスト領域を無視してそろえる
000098r 1                 CMP #192-TOP_MARGIN-8     ; 自由領域をオーバーしたか
000098r 1                 PLA
000098r 1                 BCS @SKP_NEW_Y
000098r 1                 STA ZP_PLAYER_Y
000098r 1               @SKP_NEW_Y:
000098r 1                 ; 無敵でかつ描画フレームがどちらか一方なら描画キャンセル（点滅
000098r 1                 LDA ZP_VISIBLE_FLAME
000098r 1                 AND ZP_PL_STAT_FLAG
000098r 1                 AND #%00000001
000098r 1                 BNE @DONT_DRAW
000098r 1                 ; プレイヤ描画
000098r 1                 loadmem16 ZP_CHAR_PTR,CHAR_DAT_ZIKI
000098r 1                 LDA ZP_PLAYER_X
000098r 1                 STA ZP_CANVAS_X
000098r 1                 STA (ZP_BLACKLIST_PTR)
000098r 1                 LDA ZP_PLAYER_Y
000098r 1                 STA ZP_CANVAS_Y
000098r 1                 LDY #1
000098r 1                 STA (ZP_BLACKLIST_PTR),Y
000098r 1                 JSR DRAW_CHAR8
000098r 1               @DONT_DRAW:
000098r 1               .endmac
000098r 1               
000098r 1               ; -------------------------------------------------------------------
000098r 1               ;                           PL弾ティック
000098r 1               ; -------------------------------------------------------------------
000098r 1               .macro tick_pl_blt
000098r 1                 .local TICK_PL_BLT
000098r 1                 .local @DRAWPLBL
000098r 1                 .local @END
000098r 1                 .local @SKP_Hamburg
000098r 1                 .local @DEL
000098r 1               TICK_PL_BLT:
000098r 1                 LDX #$0                   ; X:PL弾リスト用インデックス
000098r 1               @DRAWPLBL:
000098r 1                 CPX ZP_PLBLT_TERMIDX
000098r 1                 BCS @END                  ; PL弾をすべて処理したならPL弾処理終了
000098r 1                 ; X
000098r 1                 LDA PLBLT_LST,X
000098r 1                 STA ZP_CANVAS_X           ; 描画用座標
000098r 1                 STA (ZP_BLACKLIST_PTR),Y  ; BL格納
000098r 1                 ; Y
000098r 1                 LDA PLBLT_LST+1,X           ; Y座標取得（信頼している
000098r 1                 SBC #PLBLT_SPEED          ; 新しい弾の位置
000098r 1                 ;BCC @SKP_Hamburg          ; 右にオーバーしたか
000098r 1                 CMP #TOP_MARGIN
000098r 1                 BCS @SKP_Hamburg
000098r 1               @DEL:
000098r 1                 ; 弾丸削除
000098r 1                 PHY
000098r 1                 JSR DEL_PL_BLT
000098r 1                 PLY
000098r 1                 BRA @DRAWPLBL
000098r 1               @SKP_Hamburg:
000098r 1                 STA PLBLT_LST+1,X           ; リストに格納
000098r 1                 STA ZP_CANVAS_Y           ; 描画用座標
000098r 1                 INX                       ; 次のデータにインデックスを合わせる
000098r 1                 INY
000098r 1                 STA (ZP_BLACKLIST_PTR),Y  ; BL格納
000098r 1                 INX
000098r 1                 INY
000098r 1                 PHY
000098r 1                 PHX
000098r 1                 loadmem16 ZP_CHAR_PTR,CHAR_DAT_ZITAMA1
000098r 1                 JSR DRAW_CHAR8            ; 描画する
000098r 1                 PLX
000098r 1                 PLY
000098r 1                 BRA @DRAWPLBL             ; PL弾処理ループ
000098r 1               @END:
000098r 1               .endmac
000098r 1               
000098r 1               ; -------------------------------------------------------------------
000098r 1               ;                   ブラックリストを終端する
000098r 1               ; -------------------------------------------------------------------
000098r 1               .macro term_blacklist
000098r 1                 LDA #$FF
000098r 1                 INY
000098r 1                 STA (ZP_BLACKLIST_PTR),Y
000098r 1               .endmac
000098r 1               
000098r 1               ; -------------------------------------------------------------------
000098r 1               ;                           コマンド処理
000098r 1               ; -------------------------------------------------------------------
000098r 1               .macro tick_cmd
000098r 1               TICK_CMD:
000098r 1                 LDY #1              ; コマンド読み取り用インデックス
000098r 1                 LDA (ZP_CMD_PTR)    ; コマンド取得
000098r 1                 CMP #$FD
000098r 1                 BNE @SKP_LOOP
000098r 1                 ; ---------------------------------------------------------------
000098r 1                 ;   ループ
000098r 1               @LOOP:
000098r 1                 LDA (ZP_CMD_PTR),Y  ; 回数
000098r 1                 DEC
000098r 1                 STA (ZP_CMD_PTR),Y
000098r 1                 BEQ @PLUS_4
000098r 1                 INY
000098r 1                 LDA (ZP_CMD_PTR),Y
000098r 1                 TAX
000098r 1                 INY
000098r 1                 LDA (ZP_CMD_PTR),Y
000098r 1                 STX ZP_CMD_PTR
000098r 1                 STA ZP_CMD_PTR+1
000098r 1                 BRA @END_TICK_CMD
000098r 1               @SKP_LOOP:
000098r 1                 CMP #$FE
000098r 1                 BNE @SKP_WAIT
000098r 1                 ; ---------------------------------------------------------------
000098r 1                 ;   待機
000098r 1               @WAIT:                ; $FE WAIT
000098r 1                 LDA ZP_CMD_WAIT_CNT ; 現在カウント
000098r 1                 BNE @SKP_NEW_WAIT
000098r 1                 ; 新規待機
000098r 1                 LDA (ZP_CMD_PTR),Y  ; 引数:待ちフレーム
000098r 1                 STA ZP_CMD_WAIT_CNT
000098r 1               @SKP_NEW_WAIT:
000098r 1                 DEC ZP_CMD_WAIT_CNT
000098r 1                 BNE @END_TICK_CMD
000098r 1                 CLC
000098r 1                 LDA ZP_CMD_PTR
000098r 1                 ADC #2
000098r 1                 STA ZP_CMD_PTR
000098r 1                 LDA ZP_CMD_PTR+1
000098r 1                 ADC #0
000098r 1                 STA ZP_CMD_PTR+1
000098r 1                 BRA @END_TICK_CMD
000098r 1               @SKP_WAIT:
000098r 1                 ; ---------------------------------------------------------------
000098r 1                 ;   終了
000098r 1               @STOP:
000098r 1                 CMP #$FF
000098r 1                 BEQ @END_TICK_CMD
000098r 1                 ; ---------------------------------------------------------------
000098r 1                 ;   敵をコードと引数からスポーン
000098r 1               @SPAWN_ENEM:
000098r 1                 LDX ZP_ENEM_TERMIDX
000098r 1                 STA ENEM_LST,X        ; code
000098r 1                 LDA (ZP_CMD_PTR),Y
000098r 1                 STA ENEM_LST+1,X      ; X
000098r 1                 INY
000098r 1                 LDA (ZP_CMD_PTR),Y
000098r 1                 STA ENEM_LST+2,X      ; Y
000098r 1                 INY
000098r 1                 LDA (ZP_CMD_PTR),Y
000098r 1                 STA ENEM_LST+3,X      ; T
000098r 1                 ; ---------------------------------------------------------------
000098r 1                 ;   ENEMインデックス更新
000098r 1                 TXA
000098r 1                 CLC
000098r 1                 ADC #4                    ; TAXとするとINX*4にサイクル数まで等価
000098r 1                 STA ZP_ENEM_TERMIDX
000098r 1               @PLUS_4:
000098r 1                 ; ---------------------------------------------------------------
000098r 1                 ;   CMDインデックス更新
000098r 1                 CLC
000098r 1                 LDA ZP_CMD_PTR
000098r 1                 ADC #4
000098r 1                 STA ZP_CMD_PTR
000098r 1                 LDA ZP_CMD_PTR+1
000098r 1                 ADC #0
000098r 1                 STA ZP_CMD_PTR+1
000098r 1               @END_TICK_CMD:
000098r 1               .endmac
000098r 1               
000098r 1               ; -------------------------------------------------------------------
000098r 1               ;                        垂直同期割り込み
000098r 1               ; -------------------------------------------------------------------
000098r 1               VBLANK:
000098r 1               TICK:
000098r 1  A0 01 B2 rr    tick_cmd
00009Cr 1  C9 FD D0 14  
0000A0r 1  B1 rr 3A 91  
000100r 1                 ; ---------------------------------------------------------------
000100r 1                 ;   塗りつぶし
000100r 1  A5 rr C9 AA    make_blacklist_ptr          ; ブラックリストポインタ作成
000104r 1  D0 04 A9 rr  
000108r 1  80 02 A9 rr  
000112r 1  A0 00 B1 rr    clear_by_blacklist          ; ブラックリストに沿ったエンティティ削除
000116r 1  4A AA C8 B1  
00011Ar 1  rr C9 FF F0  
00012Ar 1                 ;anti_noise                  ; ノイズ対策に行ごと消去
00012Ar 1                 ; ---------------------------------------------------------------
00012Ar 1                 ;   キー操作
00012Ar 1  20 rr rr       JSR PAD_READ                ; パッド状態更新
00012Dr 1  64 rr          STZ ZP_PL_DY
00012Fr 1  64 rr          STZ ZP_PL_DX
000131r 1                 ;LDX #256-PLAYER_SPEED
000131r 1                 ;LDY #PLAYER_SPEED
000131r 1  A9 03          LDA #PLAYER_SPEED
000133r 1  DF rr 01       BBS5 ZP_PADSTAT+1,@SKP_L    ; L
000136r 1  4A             LSR                         ; 速度を半分に
000137r 1               @SKP_L:
000137r 1  A8             TAY                         ; Y:正のスピード
000138r 1  85 00          STA ZR0
00013Ar 1  A9 00          LDA #0
00013Cr 1  E5 00          SBC ZR0
00013Er 1  AA             TAX                         ; X:負のスピード
00013Fr 1  BF rr 02       BBS3 ZP_PADSTAT,@SKP_UP     ; up
000142r 1  86 rr          STX ZP_PL_DY
000144r 1               @SKP_UP:
000144r 1  AF rr 02       BBS2 ZP_PADSTAT,@SKP_DOWN   ; down
000147r 1  84 rr          STY ZP_PL_DY
000149r 1               @SKP_DOWN:
000149r 1  9F rr 02       BBS1 ZP_PADSTAT,@SKP_LEFT   ; left
00014Cr 1  86 rr          STX ZP_PL_DX
00014Er 1               @SKP_LEFT:
00014Er 1  8F rr 02       BBS0 ZP_PADSTAT,@SKP_RIGHT  ; right
000151r 1  84 rr          STY ZP_PL_DX
000153r 1               @SKP_RIGHT:
000153r 1  FF rr 1D       BBS7 ZP_PADSTAT,@SKP_B      ; B button
000156r 1  C6 rr          DEC ZP_PL_COOLDOWN          ; クールダウンチェック
000158r 1  D0 19          BNE @SKP_B
00015Ar 1  A9 05          LDA #PLAYER_SHOOTRATE
00015Cr 1  85 rr          STA ZP_PL_COOLDOWN          ; クールダウン更新
00015Er 1  A4 rr A5 rr    make_pl_blt                 ; PL弾生成
000162r 1  99 rr rr A5  
000166r 1  rr 99 rr rr  
00016Er 1  A9 02          LDA #SE1_NUMBER
000170r 1  20 rr rr       JSR PLAY_SE                 ; 発射音再生
000173r 1               @SKP_B:
000173r 1  EF rr 24       BBS6 ZP_PADSTAT,@SKP_Y      ; B button
000176r 1  C6 rr          DEC ZP_PL_COOLDOWN          ; クールダウンチェック
000178r 1  D0 20          BNE @SKP_Y
00017Ar 1  A9 05          LDA #PLAYER_SHOOTRATE
00017Cr 1  85 rr          STA ZP_PL_COOLDOWN          ; クールダウン更新
00017Er 1  A4 rr A9 00    make_enem1                 ; PL弾生成
000182r 1  99 rr rr A5  
000186r 1  rr 99 rr rr  
00019Ar 1               @SKP_Y:
00019Ar 1                 ; ---------------------------------------------------------------
00019Ar 1                 ;   ティック処理
00019Ar 1  0F rr 08 A5    tick_player                 ; プレイヤ処理
00019Er 1  rr C5 rr D0  
0001A2r 1  02 07 rr A5  
0001E6r 1  A0 02          LDY #2
0001E8r 1  A2 00 E4 rr    tick_pl_blt                 ; PL弾移動と描画
0001ECr 1  B0 33 BD rr  
0001F0r 1  rr 85 rr 91  
000221r 1  A2 00 E4 rr    tick_dmk1
000225r 1  90 03 4C rr  
000229r 1  rr BD rr rr  
0002CBr 1  A2 00 E4 rr    tick_enem
0002CFr 1  90 03 4C rr  
0002D3r 1  rr 86 rr BD  
00032Dr 1  A9 FF C8 91    term_blacklist              ; ブラックリスト終端
000331r 1  rr           
000332r 1  A6 rr F0 13    tick_se                     ; 効果音
000336r 1  7C rr rr C6  
00033Ar 1  rr D0 0C A9  
000349r 1  A5 rr 20 rr    tick_infobox                ; 情報画面
00034Dr 1  rr A5 rr 20  
000351r 1  rr rr A5 rr  
000359r 1  A5 rr 8D 06    exchange_frame              ; フレーム交換
00035Dr 1  E6 18 2A 69  
000361r 1  00 85 rr 8D  
000367r 1                 ; ---------------------------------------------------------------
000367r 1                 ;   ティック終端
000367r 1  E6 rr          INC ZP_GENERAL_CNT
000369r 1  6C rr rr       JMP (ZP_VB_STUB)            ; 片付けはBCOSにやらせる
00036Cr 1               
00036Cr 1               ; 背景色で正方形領域を塗りつぶす
00036Cr 1               ; 妙に汎用的にすると重そうなので8x8固定
00036Cr 1               ; X,Yがそのまま座標
00036Cr 1               DEL_SQ8:
00036Cr 1  98             TYA
00036Dr 1  18             CLC
00036Er 1  69 08          ADC #8
000370r 1  85 rr          STA ZP_CANVAS_Y
000372r 1                 ;LDA #BGC
000372r 1  A9 00          LDA #DEBUG_BGC              ; どこを四角く塗りつぶしたかがわかる
000374r 1               DRAW_SQ_LOOP:
000374r 1  8E 02 E6       STX CRTC::VMAH
000377r 1  8C 03 E6       STY CRTC::VMAV
00037Ar 1  8D 04 E6       STA CRTC::WDBF
00037Dr 1  8D 04 E6       STA CRTC::WDBF
000380r 1  8D 04 E6       STA CRTC::WDBF
000383r 1  8D 04 E6       STA CRTC::WDBF
000386r 1  C8             INY
000387r 1  C4 rr          CPY ZP_CANVAS_Y
000389r 1  D0 E9          BNE DRAW_SQ_LOOP
00038Br 1  60             RTS
00038Cr 1               
00038Cr 1               ; 8x8キャラクタを表示する
00038Cr 1               ; キャラデータの先頭座標がZP_CHAR_PTRで与えられる
00038Cr 1               DRAW_CHAR8:
00038Cr 1  46 rr          LSR ZP_CANVAS_X
00038Er 1  A5 rr          LDA ZP_CANVAS_X
000390r 1  C9 7C          CMP #$7F-3
000392r 1  B0 31          BCS @END            ; 左右をまたぎそうならキャンセル
000394r 1  8D 02 E6       STA CRTC::VMAH
000397r 1  A0 00          LDY #0
000399r 1  A2 20          LDX #32
00039Br 1               @DRAW_CHAR8_LOOP0:
00039Br 1  A5 rr          LDA ZP_CANVAS_Y
00039Dr 1  8D 03 E6       STA CRTC::VMAV
0003A0r 1  A5 rr          LDA ZP_CANVAS_X
0003A2r 1  8D 02 E6       STA CRTC::VMAH
0003A5r 1  B1 rr          LDA (ZP_CHAR_PTR),Y
0003A7r 1  8D 04 E6       STA CRTC::WDBF
0003AAr 1  C8             INY
0003ABr 1  B1 rr          LDA (ZP_CHAR_PTR),Y
0003ADr 1  8D 04 E6       STA CRTC::WDBF
0003B0r 1  C8             INY
0003B1r 1  B1 rr          LDA (ZP_CHAR_PTR),Y
0003B3r 1  8D 04 E6       STA CRTC::WDBF
0003B6r 1  C8             INY
0003B7r 1  B1 rr          LDA (ZP_CHAR_PTR),Y
0003B9r 1  8D 04 E6       STA CRTC::WDBF
0003BCr 1  C8             INY
0003BDr 1               @DRAW_CHAR8_SKP_9:
0003BDr 1  E6 rr          INC ZP_CANVAS_Y
0003BFr 1  86 00          STX ZR0
0003C1r 1  C4 00          CPY ZR0
0003C3r 1  D0 D6          BNE @DRAW_CHAR8_LOOP0
0003C5r 1               @END:
0003C5r 1  60             RTS
0003C6r 1               
0003C6r 1               ; メッセージ画面、ゲーム画面を各背景色で
0003C6r 1               FILL_BG:
0003C6r 1                 ; message
0003C6r 1  A0 00          LDY #$00
0003C8r 1  8C 03 E6       STY CRTC::VMAV
0003CBr 1  8C 02 E6       STY CRTC::VMAH
0003CEr 1                 ; 上のフチ
0003CEr 1  A9 11          LDA #INFO_FLAME
0003D0r 1  A2 80          LDX #256/2
0003D2r 1  20 rr rr       JSR HLINE
0003D5r 1                 ; 左右の淵と中身
0003D5r 1  A0 16          LDY #TOP_MARGIN-2
0003D7r 1               @LOOP:
0003D7r 1  A9 12          LDA #INFO_FLAME_L
0003D9r 1  8D 04 E6       STA CRTC::WDBF
0003DCr 1  A9 22          LDA #INFO_BGC
0003DEr 1  A2 7E          LDX #(256/2)-2
0003E0r 1  20 rr rr       JSR HLINE
0003E3r 1  A9 21          LDA #INFO_FLAME_R
0003E5r 1  8D 04 E6       STA CRTC::WDBF
0003E8r 1  88             DEY
0003E9r 1  D0 EC          BNE @LOOP
0003EBr 1                 ; 下の淵
0003EBr 1  A9 11          LDA #INFO_FLAME
0003EDr 1  A2 80          LDX #256/2
0003EFr 1  20 rr rr       JSR HLINE
0003F2r 1                 ; game
0003F2r 1  A9 00          LDA #BGC
0003F4r 1  A0 A8          LDY #192-TOP_MARGIN
0003F6r 1               FILL_LOOP_V:
0003F6r 1  A2 80          LDX #256/2
0003F8r 1               FILL_LOOP_H:
0003F8r 1  8D 04 E6       STA CRTC::WDBF
0003FBr 1  CA             DEX
0003FCr 1  D0 FA          BNE FILL_LOOP_H
0003FEr 1  88             DEY
0003FFr 1  D0 F5          BNE FILL_LOOP_V
000401r 1  60             RTS
000402r 1               
000402r 1               HLINE:
000402r 1               @LOOP:
000402r 1  8D 04 E6       STA CRTC::WDBF
000405r 1  CA             DEX
000406r 1  D0 FA          BNE @LOOP
000408r 1  60             RTS
000409r 1               
000409r 1               PAD_READ:
000409r 1  A9 01          LDA #BCOS::BHA_CON_RAWIN_NoWaitNoEcho  ; キー入力チェック
00040Br 1  A2 06 20 03    syscall CON_RAWIN
00040Fr 1  06           
000410r 1  F0 01          BEQ @SKP_RTS
000412r 1  60             RTS
000413r 1               @SKP_RTS:
000413r 1                 ; P/S下げる
000413r 1  AD 00 E2       LDA VIA::PAD_REG
000416r 1  09 02          ORA #VIA::PAD_PTS
000418r 1  8D 00 E2       STA VIA::PAD_REG
00041Br 1                 ; P/S下げる
00041Br 1  AD 00 E2       LDA VIA::PAD_REG
00041Er 1  29 FD          AND #<~VIA::PAD_PTS
000420r 1  8D 00 E2       STA VIA::PAD_REG
000423r 1                 ; 読み取りループ
000423r 1  A2 10          LDX #16
000425r 1               @LOOP:
000425r 1  AD 00 E2       LDA VIA::PAD_REG        ; データ読み取り
000428r 1                 ; クロック下げる
000428r 1  29 FB          AND #<~VIA::PAD_CLK
00042Ar 1  8D 00 E2       STA VIA::PAD_REG
00042Dr 1                 ; 16bit値として格納
00042Dr 1  6A             ROR
00042Er 1  26 rr          ROL ZP_PADSTAT+1
000430r 1  26 rr          ROL ZP_PADSTAT
000432r 1                 ; クロック上げる
000432r 1  AD 00 E2       LDA VIA::PAD_REG        ; データ読み取り
000435r 1  09 04          ORA #VIA::PAD_CLK
000437r 1  8D 00 E2       STA VIA::PAD_REG
00043Ar 1  CA             DEX
00043Br 1  D0 E8          BNE @LOOP
00043Dr 1  60             RTS
00043Er 1               
00043Er 1               CHAR_DAT_ZIKI:
00043Er 1  09 00 00 90    .INCBIN "+stg/ziki1-88-tate.bin"
000442r 1  0B 0F 30 B0  
000446r 1  0B F7 7B A0  
00045Er 1               
00045Er 1               CHAR_DAT_ZITAMA1:
00045Er 1  0F 00 00 F0    .INCBIN "+stg/zitama-88-tate.bin"
000462r 1  0A 00 00 A0  
000466r 1  09 00 00 90  
00047Er 1               
00047Er 1               CHAR_DAT_DMK1:
00047Er 1  00 0E E0 00    .INCBIN "+stg/dmk1-88.bin"
000482r 1  00 E8 8E 00  
000486r 1  0E 88 88 E0  
00049Er 1               
00049Er 1               STAGE_CMDS:
00049Er 1  FE 3C          .BYTE $FE,60
0004A0r 1  00 0A 18 06    .BYTE ENEM_CODE_0_NANAMETTA,10,TOP_MARGIN,6
0004A4r 1  00 14 18 0C    .BYTE ENEM_CODE_0_NANAMETTA,20,TOP_MARGIN,12
0004A8r 1  00 1E 18 18    .BYTE ENEM_CODE_0_NANAMETTA,30,TOP_MARGIN,24
0004ACr 1  FE 3C          .BYTE $FE,60
0004AEr 1  00 F6 18 06    .BYTE ENEM_CODE_0_NANAMETTA,256-10,TOP_MARGIN,6
0004B2r 1  00 EC 18 0C    .BYTE ENEM_CODE_0_NANAMETTA,256-20,TOP_MARGIN,12
0004B6r 1  00 E2 18 18    .BYTE ENEM_CODE_0_NANAMETTA,256-30,TOP_MARGIN,24
0004BAr 1  FE 3C          .BYTE $FE,60
0004BCr 1  00 80 18 06    .BYTE ENEM_CODE_0_NANAMETTA,128,TOP_MARGIN,6
0004C0r 1               YOKOGIRYA_LOOP:
0004C0r 1  FE C8          .BYTE $FE,200
0004C2r 1  02 00 18 03    .BYTE ENEM_CODE_1_YOKOGIRYA,0,  TOP_MARGIN,3
0004C6r 1  02 FF 20 FE    .BYTE ENEM_CODE_1_YOKOGIRYA,255,TOP_MARGIN+(8*1),257-3
0004CAr 1  02 00 28 03    .BYTE ENEM_CODE_1_YOKOGIRYA,0,  TOP_MARGIN+(8*2),3
0004CEr 1  02 FF 30 FE    .BYTE ENEM_CODE_1_YOKOGIRYA,255,TOP_MARGIN+(8*3),257-3
0004D2r 1  02 00 38 03    .BYTE ENEM_CODE_1_YOKOGIRYA,0,  TOP_MARGIN+(8*4),3
0004D6r 1  02 FF 40 FE    .BYTE ENEM_CODE_1_YOKOGIRYA,255,TOP_MARGIN+(8*5),257-3
0004DAr 1  FE 0A          .BYTE $FE,10
0004DCr 1  02 00 18 02    .BYTE ENEM_CODE_1_YOKOGIRYA,0,  TOP_MARGIN,2
0004E0r 1  02 FF 20 FF    .BYTE ENEM_CODE_1_YOKOGIRYA,255,TOP_MARGIN+(8*1),257-2
0004E4r 1  02 00 28 03    .BYTE ENEM_CODE_1_YOKOGIRYA,0,  TOP_MARGIN+(8*2),3
0004E8r 1  02 FF 30 FE    .BYTE ENEM_CODE_1_YOKOGIRYA,255,TOP_MARGIN+(8*3),257-3
0004ECr 1  02 00 38 04    .BYTE ENEM_CODE_1_YOKOGIRYA,0,  TOP_MARGIN+(8*4),4
0004F0r 1  02 FF 40 FD    .BYTE ENEM_CODE_1_YOKOGIRYA,255,TOP_MARGIN+(8*5),257-4
0004F4r 1  FE 0A          .BYTE $FE,10
0004F6r 1  02 00 18 04    .BYTE ENEM_CODE_1_YOKOGIRYA,0,  TOP_MARGIN,4
0004FAr 1  02 FF 20 FD    .BYTE ENEM_CODE_1_YOKOGIRYA,255,TOP_MARGIN+(8*1),257-4
0004FEr 1  02 00 28 03    .BYTE ENEM_CODE_1_YOKOGIRYA,0,  TOP_MARGIN+(8*2),3
000502r 1  02 FF 30 FE    .BYTE ENEM_CODE_1_YOKOGIRYA,255,TOP_MARGIN+(8*3),257-3
000506r 1  02 00 38 02    .BYTE ENEM_CODE_1_YOKOGIRYA,0,  TOP_MARGIN+(8*4),2
00050Ar 1  02 FF 40 FF    .BYTE ENEM_CODE_1_YOKOGIRYA,255,TOP_MARGIN+(8*5),257-2
00050Er 1  FD             .BYTE $FD
00050Fr 1  64               .BYTE 100
000510r 1  rr rr            .WORD YOKOGIRYA_LOOP
000512r 1  FF             .BYTE $FF
000513r 1               
000513r 1               
