#pragma once

extern const int32 WindowWide;
extern const int32 WindowHight;

extern const int32 tableUpper;
extern const int32 tableLeft;
extern const int32 tableWide;
extern const int32 tableHight;
extern const int32 goalWide;

extern const int32 centerlineWide;

extern const double PacHighSpeed;		//パックの最高速度
extern const Vec2 PacVelocity;	//パックの初速度	
extern const int32 Pr;	//パックの半径Pr(pixel)

extern const double MalletSpeed;
extern const int32 highSpeed;
extern const int32 rowSpeed;
extern const int32 Mr;	//マレットの半径Mr(pixel)
extern const int32 gr;

extern const int32 atarihantei;//プレイヤーの当たり判定の半径

extern Rect table;
//ゴールの立幅はPr,横幅はgoalWide
extern Rect pgoal;
extern Rect egoal;
extern Rect ScoreP;
extern Rect ScoreE;

extern double masatsu;	//速度とかけて減速させる摩擦係数
extern double em;		//マレットの反発係数
extern double eme;			//敵マレットの反発係数
extern double ew;		//壁などの反発係数

extern int32 DuaBarLen;//耐久値バーの長さ
extern int32 DuaInit;	//耐久値の初期値

extern double Edamage;//敵の耐久値を削る度合い。Edamageに比例して敵に与えるダメージが大きくなる。
//Edamageにタイプ2で値を代入した

extern int32 damage;	//被弾したときのダメージ
extern int32 Raydamage; //光線にあたった時の連続的ダメージ(1秒間にRaydamage減る)
extern int32 RepairTime;//プレイヤーが復帰するまでの時間

extern Array<Vec2> GorlSide;

extern bool changeSc;
extern bool BackChangeSc;
extern bool retry;
extern bool rebegin;

extern bool pause;
extern bool gameover;
