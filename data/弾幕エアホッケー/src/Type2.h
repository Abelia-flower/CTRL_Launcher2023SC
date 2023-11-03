#pragma once
#include"EneBullet_1.h"
#include"Ball_1.h"
#include"BaseType.h"
#include "TypeManager.h"
#include "Pac.h"

class Type2:public BaseType
{
private:
	double BallSpeed = 200;

	int32 bullet_R = 10;//バレットの当たり判定の半径
	EneBullet_1* bullet1 = 0;
	EneBullet_1* bullet2 = 0;

	int32 ball_r = 5;
	int32 ball_R = 6;
	Ball_1* ball1 = 0;

	int32 type = 0;			//弾幕の形態

	Array<bullets> bullet;

	bool TypeChange;
	bool FirstGene;
public:
	Type2();
	~Type2();

	void Update(Pac* pac, Player* player, Enemy* enemy);
	void Draw();
};

