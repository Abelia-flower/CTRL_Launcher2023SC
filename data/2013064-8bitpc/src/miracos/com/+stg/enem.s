
NANAMETTA_SHOOTRATE = 30

; -------------------------------------------------------------------
;                           敵種類リスト
; -------------------------------------------------------------------
ENEM_CODE_0_NANAMETTA          = 0*2  ; ナナメッタ。プレイヤーを狙ってか狙わずか、斜めに撃つ。
ENEM_CODE_1_YOKOGIRYA          = 1*2  ; ヨコギリャ。左右から現れ反対方向に直進し、プレイヤに弾を落とす。

; -------------------------------------------------------------------
;                             ZP領域
; -------------------------------------------------------------------
.ZEROPAGE
  ZP_ENEM_TERMIDX:    .RES 1    ; ENEM_LSTの終端を指す
  ZP_ENEM_CODEWK:     .RES 1    ; 作業用敵種類
  ZP_ENEM_XWK:        .RES 1    ; X退避
  ZP_ENEM_CODEFLAGWK: .RES 1    ; CODEにひそむフラグ

; -------------------------------------------------------------------
;                            変数領域
; -------------------------------------------------------------------
.BSS
  ENEM_LST:         .RES 256  ; (code,X,Y,f),(code,X,Y,f),...

.SEGMENT "LIB"

; -------------------------------------------------------------------
;                             敵生成
; -------------------------------------------------------------------
.macro make_enem1
  LDY ZP_ENEM_TERMIDX
  LDA #ENEM_CODE_0_NANAMETTA
  STA ENEM_LST,Y        ; code
  LDA ZP_PLAYER_X
  STA ENEM_LST+1,Y      ; X
  LDA #TOP_MARGIN+1
  STA ENEM_LST+2,Y      ; Y
  LDA #NANAMETTA_SHOOTRATE
  STA ENEM_LST+3,Y      ; T
  ; ---------------------------------------------------------------
  ;   インデックス更新
  TYA
  CLC
  ADC #4                    ; TAXとするとINX*4にサイクル数まで等価
  STA ZP_ENEM_TERMIDX
.endmac

; -------------------------------------------------------------------
;                             敵削除
; -------------------------------------------------------------------
; 対象インデックスはXで与えられる
DEL_ENEM:
  LDY ZP_ENEM_TERMIDX ; Y:終端インデックス
  LDA ENEM_LST-4,Y    ; 終端部データcode取得
  STA ENEM_LST,X      ; 対象codeに格納
  LDA ENEM_LST-3,Y    ; 終端部データX取得
  STA ENEM_LST+1,X    ; 対象Xに格納
  LDA ENEM_LST-2,Y    ; 終端部データY取得
  STA ENEM_LST+2,X    ; 対象Yに格納
  LDA ENEM_LST-1,Y    ; 終端部データT取得
  STA ENEM_LST+3,X    ; 対象Tに格納
  ; ---------------------------------------------------------------
  ;   インデックス更新
  TYA
  SEC
  SBC #4                    ; TAXとするとINX*4にサイクル数まで等価
  STA ZP_ENEM_TERMIDX
  RTS

; -------------------------------------------------------------------
;                           敵ティック
; -------------------------------------------------------------------
; Yはブラックリストインデックス
.macro tick_enem
TICK_ENEM:
  ; ---------------------------------------------------------------
  ;   ENEMリストループ
  LDX #$0                   ; X:敵リスト用インデックス
TICK_ENEM_LOOP:
  CPX ZP_ENEM_TERMIDX
  BCC @SKP_END
  JMP TICK_ENEM_END         ; 敵をすべて処理したなら敵処理終了
@SKP_END:
  STX ZP_ENEM_XWK
  LDA ENEM_LST,X            ; 敵コード取得
  ROR                       ; LSBはインデックス参照用としては無視する
  ROR ZP_ENEM_CODEFLAGWK    ; LSBをフラグとして格納 MSBに
  ASL
  STA ZP_ENEM_CODEWK        ; 作業用
  LDA ENEM_LST+1,X          ; 敵X座標取得
  STA ZP_CANVAS_X           ; 作業用に、描画用ゼロページを使う
  LDA ENEM_LST+2,X
  STA ZP_CANVAS_Y           ; 作業用に、描画用ゼロページを使う
  ; ---------------------------------------------------------------
  ;   PLBLTとの当たり判定
  PHY                       ; BLIDX退避
  LDY #$FE                  ; PL弾インデックス
@COL_PLBLT_LOOP:
  INY
  INY
  CPY ZP_PLBLT_TERMIDX      ; PL弾インデックスの終端確認
  BEQ @END_COL_PLBLT
  ; ---------------------------------------------------------------
  ;   X判定
  LDA ZP_CANVAS_X           ; 敵X座標取得
  SEC
  SBC PLBLT_LST,Y           ; PL弾X座標を減算
  ADC #8                    ; -8が0に
  CMP #16
  BCS @COL_PLBLT_LOOP
  ; ---------------------------------------------------------------
  ;   Y判定
  LDA ZP_CANVAS_Y           ; 敵Y座標取得
  SEC
  SBC PLBLT_LST+1,Y
  ADC #8                    ; -8が0に
  CMP #16
  BCS @COL_PLBLT_LOOP
  ; ---------------------------------------------------------------
  ;   敵被弾
  LDX ZP_ENEM_CODEWK        ; ジャンプテーブル用に
  JMP (ENEM_HIT_JT,X)
@END_COL_PLBLT:
  ; ---------------------------------------------------------------
  ;   個別更新処理（移動、射撃、など
  LDX ZP_ENEM_CODEWK        ; ジャンプテーブル用に
  JMP (ENEM_UPDATE_JT,X)
TICK_ENEM_UPDATE_END:
  ; ---------------------------------------------------------------
  ;   BL登録
  PLY
  LDA ZP_CANVAS_X
  STA (ZP_BLACKLIST_PTR),Y  ; BL格納X
  INY
  LDA ZP_CANVAS_Y
  STA (ZP_BLACKLIST_PTR),Y  ; BL格納Y
  INY
  ; ---------------------------------------------------------------
  ;   インデックス更新
  LDA ZP_ENEM_XWK
  CLC
  ADC #4
  PHA
  ; ---------------------------------------------------------------
  ;   実際の描画
  PHY
  JSR DRAW_CHAR8            ; 描画する
  PLY
  PLX
  BRA TICK_ENEM_LOOP        ; 敵処理ループ
TICK_ENEM_END:
.endmac

; -------------------------------------------------------------------
;                             敵個別
; -------------------------------------------------------------------
; -------------------------------------------------------------------
;                        敵更新処理テーブル
; -------------------------------------------------------------------
ENEM_UPDATE_JT:
  .WORD NANAMETTA_UPDATE
  .WORD YOKOGIRYA_UPDATE

NANAMETTA_UPDATE:
  BBS0 ZP_GENERAL_CNT,@LOAD_TEXTURE ; 移動1/2
  BBS1 ZP_GENERAL_CNT,@MOVE         ; 射撃1/4
  ; ---------------------------------------------------------------
  ;   射撃判定
  LDX ZP_ENEM_XWK
  LDA ENEM_LST+3,X          ; T取得
  DEC                       ; T減算
  BNE @SKP_TRESET
  LDA #NANAMETTA_SHOOTRATE
@SKP_TRESET:
  STA ENEM_LST+3,X          ; クールダウン更新
  CMP #8
  BCS @SKP_SHOT
  ROR
  BCS @SKP_SHOT
  ; ---------------------------------------------------------------
  ;   射撃
  LDY ZP_DMK1_TERMIDX       ; Y:DMK1インデックス
  ; X
  LDA ZP_CANVAS_X
  STA DMK1_LST,Y            ; X
  ; dX
  CMP ZP_PLAYER_X           ; PL-Xと比較
  ;LDA #1
  LDA #(1<<1)
  BCC @SKP_ADC256a
  ;LDA #256-1
  LDA #<(255<<1)
  @SKP_ADC256a:
  STA DMK1_LST+2,Y          ; dX
  ; Y
  LDA ZP_CANVAS_Y
  STA DMK1_LST+1,Y          ; Y
  ; dY
  CMP ZP_PLAYER_Y           ; PL-Xと比較
  ;LDA #1
  LDA #(1<<1)
  BCC @SKP_ADC256b
  ;LDA #256-1
  LDA #<(255<<1)
  @SKP_ADC256b:
  STA DMK1_LST+3,Y          ; dY
  TYA
  CLC
  ADC #4
  STA ZP_DMK1_TERMIDX       ; DMK1終端更新
  LDA #SE1_NUMBER
  JSR PLAY_SE               ; 発射音再生 X使用
@SKP_SHOT:
  ; ---------------------------------------------------------------
  ;   移動
  ;    ゆっくり降りてきて、適当なところで止まる
@MOVE:
  LDX ZP_ENEM_XWK
  LDA ZP_CANVAS_Y
  INC
  CMP #80
  BEQ @LOAD_TEXTURE
  STA ENEM_LST+2,X
  ;INC ZP_CANVAS_X
  ;LDA ENEM1_LST,X
  ;ADC #$80
  ;CLC
  ;ADC #256-1
  ;BVC @SKP_DEL_LEFT
  ; ENEM1削除
  ;PHY
  ;JSR DEL_ENEM1
  ;PLY
  ;JMP @DRAWPLBL
;@SKP_DEL_LEFT:
  ;SEC
  ;SBC #$80
  ;STA ENEM1_LST,X
@LOAD_TEXTURE:
  loadmem16 ZP_CHAR_PTR,CHAR_DAT_TEKI2
  JMP TICK_ENEM_UPDATE_END

YOKOGIRYA_UPDATE:
  ; ---------------------------------------------------------------
  ;   射撃判定
  LDA ZP_CANVAS_X
  SEC
  SBC ZP_PLAYER_X
  ADC #3
  CMP #8
  BCS @SKP_SHOT
  BBS7 ZP_ENEM_CODEFLAGWK,@SKP_SHOT ; 射撃済みならやめておく
  ; ---------------------------------------------------------------
  ;   射撃
  LDX ZP_ENEM_XWK           ; 射撃及び移動に使うENEMIDX
  LDA ZP_ENEM_CODEWK
  ORA #%00000001            ; 射撃済みフラグを立てる
  STA ENEM_LST,X            ; 更新
  LDY ZP_DMK1_TERMIDX       ; Y:DMK1インデックス
  ; X
  LDA ZP_CANVAS_X
  STA DMK1_LST,Y            ; X
  ; dX
  LDA #0
  STA DMK1_LST+2,Y          ; dX
  ; Y
  LDA ZP_CANVAS_Y
  STA DMK1_LST+1,Y          ; Y
  ; dY
  ;LDA #2
  LDA #(2<<1)
  STA DMK1_LST+3,Y          ; dY
  TYA
  CLC
  ADC #4
  STA ZP_DMK1_TERMIDX       ; DMK1終端更新
  LDA #SE1_NUMBER
  JSR PLAY_SE               ; 発射音再生 X使用
@SKP_SHOT:
  ; ---------------------------------------------------------------
  ;   移動
@MOVE:
  LDX ZP_ENEM_XWK           ; 射撃及び移動に使うENEMIDX
  LDA ZP_CANVAS_X
  CLC
  ADC #$80
  CLC
  ADC ENEM_LST+3,X          ; Tを加算
  ; 逸脱判定
  BVC @SKP_DEL_LEFT
  ; 削除
  JSR DEL_ENEM
  LDX ZP_ENEM_XWK
  PLY                       ; BLPTR
  JMP TICK_ENEM_LOOP        ; もう存在しないので描画等すっ飛ばす
@SKP_DEL_LEFT:
  SBC #$80
  STA ZP_CANVAS_X
  STA ENEM_LST+1,X
@LOAD_TEXTURE:
  loadmem16 ZP_CHAR_PTR,CHAR_DAT_TEKI3
  JMP TICK_ENEM_UPDATE_END

; -------------------------------------------------------------------
;                        敵被弾処理テーブル
; -------------------------------------------------------------------
ENEM_HIT_JT:
  .WORD NANAMETTA_HIT
  .WORD NANAMETTA_HIT

NANAMETTA_HIT:
  LDX ZP_ENEM_XWK
  JSR DEL_ENEM              ; 敵削除
  LDA #SE2_NUMBER
  JSR PLAY_SE               ; 撃破効果音
  LDX ZP_ENEM_XWK
  PLY                       ; BLPTR
  JMP TICK_ENEM_LOOP

; -------------------------------------------------------------------
;                             敵画像
; -------------------------------------------------------------------
CHAR_DAT_TEKI1:
  .INCBIN "+stg/teki1-88-tate.bin"

CHAR_DAT_TEKI2:
  .INCBIN "+stg/teki2-88-tate.bin"

CHAR_DAT_TEKI3:
  .INCBIN "+stg/teki3-88.bin"

