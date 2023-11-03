; -------------------------------------------------------------------
;                               ZP領域
; -------------------------------------------------------------------
.ZEROPAGE
  ZP_DMK1_TERMIDX:    .RES 1        ; DMK1_LSTの終端を指す

; -------------------------------------------------------------------
;                              変数領域
; -------------------------------------------------------------------
.BSS
  ; 弾幕1
  DMK1_LST:      .RES 256 ; (X,Y,.x.y,I),...

.SEGMENT "LIB"

; -------------------------------------------------------------------
;                           DMK1ティック
; -------------------------------------------------------------------
.macro tick_dmk1
  .local TICK_DMK1
  .local @LOOP
  .local @END
  .local @SKP_Hamburg
  .local @DEL
TICK_DMK1:
  @ZR0_XHIT_FLAG  = ZR0
  @ZR1_DIFF       = ZR1
  LDX #$0                   ; X:DMK1リスト用インデックス
@LOOP:
  CPX ZP_DMK1_TERMIDX
  BCC @SKP_END              ; DMK1をすべて処理したなら処理終了
  JMP @END
@SKP_END:
  ; ---------------------------------------------------------------
  ;   X
  ; 1px/tickより遅い可能性
  ; C=0保障

  LDA DMK1_LST+3,X          ; 速度インデックス取得

  LDA DMK1_LST+2,X          ; dX取得
  BPL @SKP_SEC
  SEC
@SKP_SEC:
  ROR                       ; C<-bit0 低速フラグ
  BCC @FASTX
  ; 低速
@SLOWX:
  LSR                       ; C<-bit1 負方向フラグ
  PHA                       ; マスク値を退避
  BCS @MINUSX
  LDA #1
  .BYT $2C                  ; 例のテクニック
@MINUSX:
  LDA #255
  STA @ZR1_DIFF
  PLA                       ; マスク値を復帰
  AND ZP_GENERAL_CNT        ; マスク値
  BEQ @SKP_ZEROX            ; ゼロなら1/-1を反映
  ;STZ @ZR1_DIFF
  LDA #0
@FASTX:
  STA @ZR1_DIFF
@SKP_ZEROX:
@ADDX:
  LDA DMK1_LST,X
  CLC
  ADC #$80                  ; 半分ずらした状態で加算して戻すことで、Vフラグで跨ぎ判定
  CLC
  ADC @ZR1_DIFF
  BVC @SKP_Hamburg          ; 左右端を跨ぐなら削除
@DEL:
  ; 弾丸削除
  PHY
  JSR DEL_DMK1
  PLY
  BRA @LOOP
@SKP_Hamburg:
  SEC
  SBC #$80
  STA DMK1_LST,X            ; リストに格納
  STA ZP_CANVAS_X           ; 描画用座標
  STA (ZP_BLACKLIST_PTR),Y  ; BL格納
  ; ---------------------------------------------------------------
  ;   X当たり判定
  SEC
  SBC ZP_PLAYER_X
  ADC #3
  CMP #8
  ROR @ZR0_XHIT_FLAG        ; CをZR0 bit7に格納
  ; ---------------------------------------------------------------
  ;   Y
  ; 1px/tickより遅い可能性
  CLC
  LDA DMK1_LST+3,X          ; dY取得
  BPL @SKP_SECY
  SEC
@SKP_SECY:
  ROR                       ; C<-bit0 低速フラグ
  BCC @FAST
  ; 低速
@SLOW:
  LSR                       ; C<-bit1 負方向フラグ
  PHA                       ; マスク値を退避
  BCS @MINUS
  LDA #1
  .BYT $2C                  ; 例のテクニック
@MINUS:
  LDA #255
  STA @ZR1_DIFF
  PLA                       ; マスク値を復帰
  AND ZP_GENERAL_CNT        ; マスク値
  BEQ @SKP_ZERO             ; ゼロなら1/-1を反映
  STZ @ZR1_DIFF
@SKP_ZERO:
  LDA @ZR1_DIFF
  ; 高速のばあいそのまま足す
@FAST:
@ADD:
  CLC
  ADC DMK1_LST+1,X
@STORE:
  STA DMK1_LST+1,X          ; リストに格納
  STA ZP_CANVAS_Y           ; 描画用座標
  INY
  STA (ZP_BLACKLIST_PTR),Y  ; BL格納
  DEY                       ; DELに備えて戻しておく
  SEC
  SBC #TOP_MARGIN
  CMP #192-TOP_MARGIN
  BCS @DEL
  INY                       ; DELは回避された
  ; ---------------------------------------------------------------
  ;   Y当たり判定
  BBS7 ZR0,@SKP_COL_Y       ; XがヒットしてなければY判定もスキップ
  LDA ZP_CANVAS_Y
  ;SEC                      ; BCSでC=0が保証されている
  SBC ZP_PLAYER_Y           ; 1余計に引いている
  ADC #3+1                  ; 1余計に足しておく
  CMP #8
  BCS @SKP_COL_Y
  ; ---------------------------------------------------------------
  ;   プレイヤダメージ
  PHX
  JSR KILL_PLAYER
  PLX
@SKP_COL_Y:
  ; ---------------------------------------------------------------
  ;   インデックス更新
  TXA
  CLC
  ADC #4                    ; TAXとするとINX*4にサイクル数まで等価
  PHA                       ; しかしスタック退避を考慮するとこっちが有利
  INY
  ; ---------------------------------------------------------------
  ;   実際の描画
  PHY
  loadmem16 ZP_CHAR_PTR,CHAR_DAT_DMK1
  JSR DRAW_CHAR8            ; 描画する
  PLY
  PLX
  ;BRA @LOOP                 ; PL弾処理ループ
  JMP @LOOP
@END:
.endmac

; -------------------------------------------------------------------
;                            DMK1削除
; -------------------------------------------------------------------
; 対象インデックスはXで与えられる
DEL_DMK1:
  LDY ZP_DMK1_TERMIDX  ; Y:終端インデックス
  LDA DMK1_LST-4,Y     ; 終端部データX取得
  STA DMK1_LST,X       ; 対象Xに格納
  LDA DMK1_LST-3,Y     ; 終端部データX取得
  STA DMK1_LST+1,X     ; 対象Xに格納
  LDA DMK1_LST-2,Y     ; 終端部データX取得
  STA DMK1_LST+2,X     ; 対象Xに格納
  LDA DMK1_LST-1,Y     ; 終端部データX取得
  STA DMK1_LST+3,X     ; 対象Xに格納
  TYA
  SEC
  SBC #4
  STA ZP_DMK1_TERMIDX  ; 縮小した終端インデックス
  RTS

SPEED_TABLE:
  .REPEAT 128
  .BYT 8,8
  .ENDREP

