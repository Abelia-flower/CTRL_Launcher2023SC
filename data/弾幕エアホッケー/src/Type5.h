#pragma once
#include "BaseType.h"
#include "ChildBullet.h"
#include "EneBullet_1.h"
#include"Hanabi.h"
#include "Ball_1.h"

class Type5:public BaseType
{
private:
	double BallSpeed = 200;
	double BaseDir = 3.14/2;
	EneBullet_1* NeutronStar = 0;
	ChildBullet* uzu = 0;
	ChildBullet* hunsui = 0;
	ChildBullet* Ueziguzagu = 0;
	ChildBullet* Shitaziguzagu = 0;
	ChildBullet* nokogiri_down = 0;//左移動
	ChildBullet* nokogiri_mid = 0;//右移動
	ChildBullet* nokogiri_upper = 0;
	EneBullet_1* RectLaser = 0;
	EneBullet_1* jikinerai = 0;
	EneBullet_1* michi = 0;
	EneBullet_1* hunsui_t3 = 0;
	EneBullet_1* wipe = 0;
	Hanabi* hanabi = 0;

	int32 ziguzaguinterval = tableWide/4;
	int32 hunsuiinterval = 20;
	int32 nokointerval = 150;
	int32 hutosa = 6;
	double wipeTime;
	double intervalTime;
	double taikyuuTime;

	Array<Vec2> from{ { tableLeft,WindowHight / 2 },{ WindowWide - tableLeft,WindowHight - tableUpper } };
	Array<Vec2> to{ { tableLeft + tableWide / 3, tableUpper + tableHight * 3 / 4 } ,{ tableLeft + tableWide * 2 / 3, WindowHight - tableUpper - 12 },
		{tableLeft + tableWide / 14,tableUpper + tableHight * 3 / 4 - 50},{tableLeft + tableWide * 10 / 24,WindowHight - tableUpper - 40},
		{tableLeft + tableWide / 2 - 10,tableUpper + tableHight / 2 + 20},{WindowWide - tableLeft - 50,WindowHight - tableUpper - 100 },
		{tableLeft + 25,tableUpper + tableHight / 2 - 20},{tableLeft + tableWide / 3 + 40,tableUpper + tableHight * 4 / 5},
		{tableLeft + tableWide * 4 / 5,tableUpper + tableHight / 2 + 20},{WindowWide - tableLeft - 10,WindowHight - tableUpper - 50},
		{tableLeft + tableWide * 2 / 3,tableUpper + tableHight * 3 / 4 } ,{WindowWide - tableLeft - 10,WindowHight - tableUpper} };

	int32 i = 0; Array<double> time{ 4,2,4,3, 7,2 };

	double HunsuiDir = 3.14/2;

	Stopwatch stopwatch{ StartImmediately::Yes };

	Ball_1* ball1 = 0;
	Ball_1* ball2 = 0;
	Ball_1* ball3 = 0;
	Ball_1* ball4 = 0;
	Ball_1* ball5 = 0;
	Ball_1* ball6 = 0;
	Ball_1* ball7 = 0;

	Array<double>jikuDir = { 3.14 * 7 / 12 ,3.14 * 5 / 12 };

	Array<bullets> bullet;
	Array<double>jiku{ 3.14 / 2,-3.14 / 2 };
	Array<double>t{ 4,-4 };

	int32 type = 0;

	bool TypeChange;
	bool FirstGene;
public:
	Type5();
	~Type5();

	void Update(Pac* pac, Player* player, Enemy* enemy);
	void Draw();
};

