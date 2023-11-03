#pragma once
#include "Pac.h"
#include "Player.h"
#include"Ball_1.h"

struct bullets {
	Vec2 pos;		//座標
	double dir;		//発射方向	ラジアン
	double GeneTimer;//いない状態での経過時間,バレットが再起動中かどうかの判断にも使う
	double ShotTimer = 0.0;
	Vec2 Velocity{ 0,0 };
};

class EneBullet
{
protected:
	//弾幕兵器の座標と当たり判定（半径）
	Array<bullets> enebullets;
	int32 r;

	Effect effect;

public:
	EneBullet(int32 BulletR);
	virtual ~EneBullet();

	void ChangeDir(double delta);

	void IntersectsPac(Pac* pac);

	bool GetenebulletsisEmpty();

	void Setenebullets(Array<bullets> xy);

	void Setenebullets(Array<Vec2> xy, double dir, double GeneTimer, double ShotTimer, Vec2 velo);

	void SetXY(Vec2 XY);

	void SetVelo(Vec2 v);

	void SetShotTimer(double t);

	void MoveXY();//速度ベクトルをもらう

	void AimShot(Player* player, Ball_1* ball, double Speed, double dec, double ct);//自機狙い

	Array<bullets> Getenebullet();

	Array<double> GeteneDir();
};

class RevivableEneBullet :public EneBullet
{
public:
	RevivableEneBullet(int32 BulletR);
	virtual ~RevivableEneBullet();

	void IntersectsPac(Pac* pac);	//当たったらGeneTimerを起動し、バレットを動作停止させる

	void GeneTimerCount();//GeneTimerが動いているバレットの経過時間を進める。
};
