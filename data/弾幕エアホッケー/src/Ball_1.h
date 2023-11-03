#pragma once
#include"EneBall.h"
class Ball_1:public EneBall
{
private:
	int32 R;	//Ball_1のビジュアル半径
	double g;//重力
public:
	Ball_1(int32 r,int32 R);//rは当たり判定、Rはビジュアル半径
	~Ball_1();

	void shot(Vec2 start, double dir, double Speed, double dec, double t);//弾を放つ座標をスタートで渡す。弾の発射方向をディレクションで渡す。

	void shot(Vec2 start, double dir, double Speed, double dec, double t, double grab);

	void ShotRay(Vec2 start, double dir, int32 hutosa, Color c);//ステージの端っこまで伸びるレーザー

	void ShotRay(Vec2 start, double dir, int32 hutosa, double len, Color c);

	void BallSetX(int32 x);

	void BallSetY(int32 y);

	void BallSet(Array<Vec2> rocation);

	void BallMove();

	void BallMove(Vec2 posXY);//位置ベクトルをもらい、全弾に加算する

	void BallMove(double MinSpeed);//最低速度を定める

	void Move_if(Line line, double x, double y);//type4のclomn弾幕で使う

	void BallMoveMax(double MaxSpeed);//最高速度を求める

	void BallFall();//下に向かって自由落下

	void BallFall(Vec2 p);//pに向かって自由落下する,減速度を引力係数に組み込んでいる

	void BallFall(Vec2 p,double g);//pに向かって自由落下する,gを引力係数に組み込んでいる

	void BallFall_if(Vec2 p, double g, Vec2 from, double dis);//formよりdis以上離れてなければ自由落下

	void BallDecelerate();

	void BallDecelerate_if(Vec2 p,double r);//球がpからr以上は慣れていなければ減速

	void BallDecrease(double t);

	void BallDecrease();

	void BallRemove_if(Vec2 pos,int32 r);//type5で使う

	void PopBall();//はじけるボール
};

