#pragma once
#include"EneBullet_1.h"

//初動の動きが違う、最初に準備が必要なショットをする武器
class ChildBullet:public EneBullet_1
{
private:
	Array<bool> First;
	double basedir;
	double nowlen = 0;//shotrayで使用；
public:
	ChildBullet(int32 R, Array<bullets> b);
	~ChildBullet();

	void RemoveBullet();//画面外に出たChildBulletを消去。

	void SetBullet(Array<bullets> b,Vec2 velo);

	void ColumnSet(Ball_1* ball,double interval,double Speed);

	void ColumnSetX(int32 interval, int32 startX, int32 Y,double dir);//interval間隔で高さYに武器を設置していく

	void ColumnSetV(Vec2 velo);

	void ColumnMove(int32 interval, int32 Y);

	void ColumnReset();

	void ColumnShot(Ball_1* ball, double interval,double Speed);

	void NobiShotRay(Ball_1* ball, double len, double s, Color c, int32 hutosa);//レーザーの長さ、伸びきるまでの秒

	void uzukaiten(Ball_1* ball, double Speed, double ct, double BallSpeed, Vec2 center, int32 k, double* basedir);//回転スピード(rad/s)、クールタイム、間隔、中心、k等分、基準方向

	void Move_if(Ball_1* ball);//enebulletに対してdirの直線上にある弾をxyだけ動かす

	void Mixer(Ball_1* ball);
};
