#pragma once
#include "EneBullet_1.h"

//弾が発射方向(dir)に進まない武器(ColmnShotはChildBulletで例外)
class Hanabi:public EneBullet_1
{
private:
	double ShotTimer = 0;
public:
	Hanabi(int32 R, Array<bullets> bs);
	~Hanabi();

	void HanabiShot(Ball_1* ball,double Maxct,double Minct);
	void Explo(Ball_1* ball);
};
