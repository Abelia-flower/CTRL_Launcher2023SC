#pragma once
#include"TypeManager.h"
#include"BaseType.h"
#include"RainShot.h"
#include"ChildBullet.h"

class Type4 :public BaseType
{
private:
	double BallSpeed = 200;
	double TypeTimer = 0;
	double TypeTimer2 = 0;
	double interval = 110;//交差弾幕の間隔
	Vec2 velo = { 0,-40 };//敵の武器が動く速さ
	Vec2 velo2 = { 40,0 };
	double GeneTime = 2.5;//type=2で敵が追加されていく秒間隔
	bool RorL = true;	//type=2で敵が追加されるのが左右のどちらかを判定。trueなら右側。

	int32 bullet_R = 10;//バレットの当たり判定の半径
	EneBullet_1* bullet1 = 0;
	EneBullet_1* bullet2 = 0;
	EneBullet_1* bullet3 = 0;
	EneBullet_1* bullet4 = 0;
	EneBullet_1* bullet5 = 0;
	EneBullet_1* bullet6 = 0;
	EneBullet_1* bullet7 = 0;

	ChildBullet* c_bullet1 = 0;
	ChildBullet* c_bullet2 = 0;

	int32 ball_r = 5;
	int32 ball_R = 6;
	Ball_1* ball1 = 0;
	Ball_1* ball2 = 0;
	Ball_1* ball3 = 0;
	Ball_1* ball4 = 0;

	Array< Array<bullets>> b;

	int32 type = 0;			//弾幕の形態

	Array<bullets> bullet;

	Vec2 CircleVelo{ 0,150 };

	bool TypeChange;
	bool FirstGene;

	RainShot* bullet100;
	RainShot* bullet200;
public:
	Type4();
	~Type4();

	void Update(Pac* pac, Player* player, Enemy* enemy);
	void Draw();
};

