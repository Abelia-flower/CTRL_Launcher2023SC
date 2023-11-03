#include "stdafx.h"
#include "Hanabi.h"

Hanabi::Hanabi(int32 R, Array<bullets> bs) :EneBullet_1(R, bs)
{

}

Hanabi::~Hanabi() {};


void Hanabi::HanabiShot(Ball_1* ball, double Maxct, double Minct)
{
	ShotTimer += Scene::DeltaTime();
	if (ShotTimer >= Random(Minct, Maxct))
	{
		RectF r{ tableLeft + tableWide / 6,tableUpper + tableHight / 10-50,tableWide * 2 / 3,tableHight * 2 / 5 };
		bullets b{ RandomVec2(r),0,0.3,0,Vec2(150,0) };
		enebullets << b;
		ball->shot(Vec2(b.pos.x, WindowHight - tableUpper), 3.14 * 3 / 2, tableHight / 5, 100, 0,-100);
		ShotTimer = 0;
	}
}

void Hanabi::Explo(Ball_1* ball)
{
	//HanabiではgeneTimerがcoolTime,Velocity.xが玉の発射速度,ｙが発射回数
	for (auto it = enebullets.begin(); it != enebullets.end();)
	{
		it->ShotTimer += Scene::DeltaTime();
		if (it->Velocity.x > 0)
		{
			if (it->ShotTimer >= it->GeneTimer)
			{
				it->GeneTimer = 0.2;
				it->Velocity.y += 1;
				double dir = 0;
				for (auto i : step(12))
				{
					ball->shot(it->pos, dir + 3.14 * 2 * i / 12 + 3.14 * it->Velocity.y / 12, it->Velocity.x, 100, 0, 70);
				}
				it->ShotTimer = 0;
				it->Velocity.x -= 30;
				
			}
			it++;
		}
		else
		{
			it = enebullets.erase(it);
		}
	}

}
