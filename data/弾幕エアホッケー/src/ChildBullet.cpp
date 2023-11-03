#include "stdafx.h"
#include "ChildBullet.h"

ChildBullet::ChildBullet(int32 r, Array<bullets> b) :EneBullet_1(r, b)
{
	for (auto i : step(size(b)))
	{
		First << false;
	}
}

ChildBullet::~ChildBullet()
{

}

void ChildBullet::RemoveBullet()
{
	Array<bullets> new_enebullets;
	auto f = First.begin();
	for (auto& bullet : enebullets)
	{
		if (table.intersects(Circle{ bullet.pos,0 }))
		{
			new_enebullets << bullet;
			f++;
		}
		else
		{
			f = First.erase(f);
		}
	}
}

void ChildBullet::SetBullet(Array<bullets> bullets,Vec2 velo)
{
	for (auto& b : bullets)
	{
		enebullets << b;
		First << false;
	}
	SetVelo(velo);
}

void ChildBullet::ColumnSet(Ball_1* ball, double interval, double speed)
{
	Vec2 basho;
	for (auto& bullet : enebullets)
	{
		basho.x = (cos(bullet.dir)) * interval;
		basho.y = (sin(bullet.dir)) * interval;
		int32 k = 0;
		while (table.intersects(Circle{ bullet.pos + basho * k,1 }))
		{
			ball->shot(bullet.pos + basho * k, bullet.dir, speed, 0, 0);
			k++;
		}
	}
}

void ChildBullet::ColumnSetX(int32 interval, int32 startX, int32 Y,double dir)
{
	for (int32 i = 0; startX + i * interval <= WindowWide - tableLeft; i++)
	{
		bullets b{ Vec2(startX + i * interval,Y),dir,0,0,Vec2(0,0) };
		enebullets << b; First << false;
	}
	for (int32 i = 1; startX - i * interval >= tableLeft; i++)
	{
		bullets b{ Vec2(startX - i * interval,Y),dir,0,0,Vec2(0,0) };
		enebullets << b; First << false;
	}
}

void ChildBullet::ColumnSetV(Vec2 v)
{
	for (auto it = enebullets.begin(); it != enebullets.end();)
	{
		it->Velocity = v;
		if ((v.x > 0 && it->pos.x >= WindowWide - tableLeft)|| (v.x < 0 && it->pos.x <= tableLeft))
		{
			it = enebullets.erase(it);
		}
		else
		{
			it++;
		}
	}
}

void ChildBullet::ColumnMove(int32 interval,int32 Y)
{
	double delta = Scene::DeltaTime();
	bool tsuika = true;
	for (auto it = enebullets.begin(); it != enebullets.end();)
	{
		//動かす
		it->pos += it->Velocity * delta;
		//追加があるかどうか
		if (it->Velocity.x < 0 && it->pos.x >= WindowWide - tableLeft - interval)
			tsuika = false;
		if (it->Velocity.x > 0 && it->pos.x <= tableLeft + interval)
			tsuika = false;
		//削除するかどうか
		if (it->pos.x > WindowWide - tableLeft || it->pos.x < tableLeft)
		{
			it = enebullets.erase(it);
		}
		else
		{
			it++;
		}
	}
	//追加のフラグが立ってたら
	if (tsuika)
	{
		bullets b;
		if (enebullets[0].Velocity.x < 0)
			b = { Vec2(WindowWide - tableLeft,Y),enebullets[0].dir,0,0,enebullets[0].Velocity };
		if (enebullets[0].Velocity.x > 0)
			b = { Vec2(tableLeft, Y), enebullets[0].dir, 0, 0, enebullets[0].Velocity };
		enebullets << b; First << false;
	}	
}

void ChildBullet::ColumnShot(Ball_1* ball, double interval,double speed)
{
	auto itB_1 = enebullets.begin();
	Vec2 basho;
	for (auto& f : First)
	{
		if (!f)//初動
		{
			basho.x = (cos(itB_1->dir)) * interval;
			basho.y = (sin(itB_1->dir)) * interval;
			int32 k = 0;
			while (table.intersects(Circle{ itB_1->pos+basho*k,1 }))
			{
				ball->shot(itB_1->pos+basho * k, itB_1->dir, speed, 0, 0);
				k++;
			}
		}
		f = true;
		if (itB_1 == enebullets.end())
			break;
		itB_1++;
	}

	Shotball(ball, speed, interval / speed);
}

void ChildBullet::NobiShotRay(Ball_1* ball, double len, double s, Color c, int32 hutosa)	//レーザーの長さ、伸びきるまでの秒
{
	for (auto& f : First)
	{	
		if (!f)
		{
			ball->RayAllExtingish();
			if (nowlen >= len)
			{
				f = true;
				ShotRay(ball, hutosa, c, len);
			}
			else
			{
				nowlen += len * Scene::DeltaTime() / s;
				ShotRay(ball, hutosa, c, nowlen);
			}
		}
	}
}

void ChildBullet::uzukaiten(Ball_1* ball, double s, double ct, double bs, Vec2 c, int32 k, double *bd)
{
	for (auto& f : First)
	{
		if (!f)
		{
			Array<Vec2> pos = SetBulSurr(c, *bd, k);
			for (auto i : step(k))
			{
				enebullets << bullets(pos[i], CalDir(pos[i], c), 0);
			}
			f = true;
		}
	}
	Shotball(ball, bs, bs * 2, ct);
	 
	*bd += s * Scene::DeltaTime();
	if (*bd > 6.28)
	{
		*bd=0;
	}

	Array<Vec2>p = SetBulSurr(c, *bd, k);
	for (auto i : step(k))
	{
		enebullets[i+1].pos = p[i];//enebulletsには先頭要素に0,0が入っているのでi+1としている。
		enebullets[i+1].dir = CalDir(p[i], c);
	}
}

void ChildBullet::Move_if(Ball_1* balls)
{
	double end = 1.1*Distance({ 0,0 }, { tableWide,tableHight });
	for (auto& bullet : enebullets)
	{
		//Print << bullet.pos<<U"Moveif";
		Vec2 dir{ cos(bullet.dir),sin(bullet.dir) };
		const Line line = { bullet.pos,bullet.pos + end * dir };
		double x=bullet.Velocity.x * Scene::DeltaTime();double y= bullet.Velocity.y * Scene::DeltaTime();
		bullet.pos.x += x; bullet.pos.y += y;
		balls->Move_if(line, x, y);
	}
}

void ChildBullet::Mixer(Ball_1* ball)
{
	for (auto& f : First)
	{
		if (!f)//初動
		{

		}
	}
}
