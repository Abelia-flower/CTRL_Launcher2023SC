#include "stdafx.h"
#include "EneBullet.h"

EneBullet::EneBullet(int32 BulletR) :r(BulletR)
{
}

EneBullet::~EneBullet(){}

void EneBullet::IntersectsPac(Pac* pac)
{
	for (auto itBullets = enebullets.begin(); itBullets != enebullets.end();)
	{
		const Circle enemyCircle{ itBullets->pos,r };
		bool skip = false;

		if (enemyCircle.intersects(pac->GetPac()))
		{
			//bullet消滅エフェクト
			effect.add([pos = itBullets->pos](double t)
			{
				const double t2 = t / 2;    //円の外枠の太さが増加する速さ
				Circle{ pos,t * 20 }.drawFrame(t2 * 20, AlphaF(1 - t));
				return(t < 1);
			});
			itBullets = enebullets.erase(itBullets);
			skip = true;
		}
		if (skip)
		{
			continue;
		}
		++itBullets;
	}
}

bool EneBullet::GetenebulletsisEmpty()
{
	return enebullets.isEmpty();
}



void EneBullet::Setenebullets(Array<bullets> b)
{
	enebullets.clear();
	for (auto& bullet : b)
	{
		enebullets << bullet;
	}
}

void EneBullet::Setenebullets(Array<Vec2> xy, double dir, double GeneTimer, double ShotTimer, Vec2 velo)
{
	enebullets.clear();
	for (auto zahyou : xy)
	{
		enebullets << bullets(zahyou, dir, GeneTimer, ShotTimer, velo);
	}
}

void EneBullet::MoveXY()
{
	for (auto& b : enebullets)
	{
		b.pos.x += b.Velocity.x * Scene::DeltaTime();
		b.pos.y += b.Velocity.y * Scene::DeltaTime();
	}
	
}

void EneBullet::SetXY(Vec2 XY)
{
	for (auto& B : enebullets)
	{
		B.pos = XY;
	}
}

void EneBullet::SetVelo(Vec2 v)
{
	for (auto& B : enebullets)
	{
		B.Velocity = v;
	}
}

void EneBullet::SetShotTimer(double t)
{
	for (auto& b : enebullets)
	{
		b.ShotTimer = t;
	}
}

void EneBullet::ChangeDir(double delta)
{
	for (auto itB = enebullets.begin(); itB != enebullets.end();)
	{
		itB->dir += delta;
	}
}

void EneBullet::AimShot(Player* player, Ball_1* ball, double Speed,double dec,double ct)		//自機狙い
{

	for (auto itB_1 = enebullets.begin(); itB_1 != enebullets.end();)
	{
		//itB_1->ShotCoolTime = ct;
		itB_1->ShotTimer += Scene::DeltaTime();
		if (ct <= itB_1->ShotTimer)
		{
			if (itB_1->GeneTimer == 0)
			{
				Vec2 dir{ player->GetXY() - itB_1->pos };
				ball->shot(itB_1->pos, acos(dir.normalized().x), Speed, dec, 0);
			}
			itB_1->ShotTimer = 0;
		}
		itB_1++;
	}
}

Array<bullets> EneBullet::Getenebullet()
{
	return enebullets;
}

Array<double> EneBullet::GeteneDir()
{
	Array<double> d;
	for (auto it = enebullets.begin(); it != enebullets.end();)
	{
		d << it->dir;
		it++;
	}

	return d;
}

RevivableEneBullet::RevivableEneBullet(int32 bR)
	:EneBullet(bR)
{
}

RevivableEneBullet::~RevivableEneBullet() {}

void RevivableEneBullet::IntersectsPac(Pac* pac)
{
	for (auto itBullets = enebullets.begin(); itBullets != enebullets.end();)
	{
		const Circle enemyCircle{ itBullets->pos,r };
		if (enemyCircle.intersects(pac->GetPac()) && itBullets->GeneTimer == 0)
		{
			//bullet消滅エフェクト
			effect.add([pos = itBullets->pos](double t)
			{
				const double t2 = t / 2;    //円の外枠の太さが増加する速さ
				Circle{ pos,t * 20 }.drawFrame(t2 * 20, AlphaF(1 - t));
				return(t < 1);
			});
			//GeneTimerを起動する。
			itBullets->GeneTimer += Scene::DeltaTime();
		}
		++itBullets;
	}
}

void RevivableEneBullet::GeneTimerCount()
{
	for (auto itBullets = enebullets.begin(); itBullets != enebullets.end();)
	{
		if (itBullets->GeneTimer > 0)
		{
			itBullets->GeneTimer += Scene::DeltaTime();
		}
		itBullets++;
	}
}

