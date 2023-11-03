#pragma once
#ifndef _PAC_H_
#define _PAC_H_
#include <Siv3D.hpp>
#include"Mallet.h"
#include"Enemy.h"

class Pac 
{
private:
	Circle pac;
	Vec2 PacVelocity;

	double pacMaxSpeed;
	double tl;	//tableleft
	double tu;	//tableupper
	double ww;	//windowwide
	double wh;	//windowhight

	//intersectsで使う変数
	double px, py;	//pacの座標を保持
	//計算式簡略用変数
	double vx = 0, vy = 0, ConPacSpeed = 0, disx = 0, disy = 0, z = 0, cos = 0, sin = 0;
	Vec2 ConPacVelocity;

	bool pacMoveType = true;//trueなら通常のパックの動き、falseならRayPacmove。Pacmoveでtrueになる。
	int32 k = 6;//RayPacmoveでパックの最低速度がv/kになる
public:
	Pac(double x, double y, double p_r, Vec2 Velo, double tableleft, double tableupper,
		double windowwide, double windowhight,double pacMaxSpeed);

	virtual ~Pac();

	void SetXY(Vec2 xy);

	void SetVelocity(Vec2 xy);

	void pacSpeedRestrict();

	void intersects(Mallet* m);	//インターセクト
	bool intersects(Enemy* e);

	void reflect(double eWall);

	void Decelerate(double flaction);

	void Pacmove();

	void RayPacmove(Vec2 start,double dir);

	Circle GetPac();

	Vec2 GetPacVelocity();

	Vec2 GetPacXY();
};

#endif //_PAC_H_

