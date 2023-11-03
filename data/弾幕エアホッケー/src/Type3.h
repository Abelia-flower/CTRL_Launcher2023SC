#pragma once
#include"TypeManager.h"
#include"BaseType.h"

class Type3:public BaseType
{
private:
	double BallSpeed = 200;

	int32 bullet_R = 10;//バレットの当たり判定の半径
	EneBullet_1* bullet1 = 0;
	EneBullet_1* bullet2 = 0;
	EneBullet_1* bullet3 = 0;
	EneBullet_1* bullet4 = 0;
	EneBullet_1* bullet5 = 0;
	EneBullet_1* bullet6 = 0;
	EneBullet_1* bullet7 = 0;

	int32 ball_r = 5;
	int32 ball_R = 6;
	Ball_1* ball1 = 0;
	Ball_1* ball2 = 0;

	int32 type = 0;			//弾幕の形態

	Array<bullets> bullet;

	Vec2 CircleVelo{ 0,150 };

	bool TypeChange;
	bool FirstGene;
public:
	Type3();
	~Type3();

	void Update(Pac* pac, Player* player, Enemy* enemy);
	void Draw();
};

