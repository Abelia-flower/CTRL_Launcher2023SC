#include "stdafx.h"
#include "EneBullet_1.h"


EneBullet_1::EneBullet_1(int32 R,Array<bullets> bs)
	:RevivableEneBullet(R),theta(0)
{
	for (auto& b : bs)
	{
		SetEneBullet_1(b);
	}
	for (auto itBullets = enebullets.begin(); itBullets != enebullets.end();)
	{
		itBullets->GeneTimer += Scene::DeltaTime();
		++itBullets;
	}
}

EneBullet_1::~EneBullet_1()
{
}

void EneBullet_1::bulletDraw()
{
	for (auto& bullet : enebullets)
	{
		//バレットが生きてたら描写
		if (bullet.GeneTimer == 0) {
			Bullet_1 = { int32(bullet.pos.x),int32(bullet.pos.y),r };
			Bullet_1.rotatedAt(Bullet_1.pos, 45_deg).draw(ColorF(Palette::Red));
		}

	}
}

void EneBullet_1::DrawCircle(Color c)
{
	for (auto& bullet : enebullets)
	{
		if (bullet.GeneTimer == 0)
		{
			Circle{ bullet.pos,r }.draw(c);
		}
	}
}

void EneBullet_1::SetEneBullet_1(bullets b)
{
	enebullets << b;
}

void EneBullet_1::RemoveEneBullet_1()
{
	//table外に出た敵は削除
	enebullets.remove_if([](const bullets b) {return !table.intersects(Circle{ b.pos,0 }); });

}

void EneBullet_1::RemoveHanabimae()
{
	int32 i = 0;
	for (auto it = enebullets.begin(); it != enebullets.end();)
	{
		if (i == 2)
			it = enebullets.erase(it);
		else
			it++;
		i++;
	}
}

void EneBullet_1::Shotball(Ball_1* ball, double Speed, double ct,double MinDece,double MaxDece)
{
	for (auto itB_1 = enebullets.begin(); itB_1 != enebullets.end();)
	{
		//itB_1->ShotCoolTime = ct;
		itB_1->ShotTimer += Scene::DeltaTime();
		if (ct <= itB_1->ShotTimer)
		{
			if (itB_1->GeneTimer == 0)
			{
				ball->shot(itB_1->pos, itB_1->dir, Speed, Random(MinDece, MaxDece), 0);
			}
			itB_1->ShotTimer = 0;
		}
		itB_1++;
	}
}

void EneBullet_1::Shotball(Ball_1* ball, double Speed, double ct)
{
	for (auto itB_1 = enebullets.begin(); itB_1 != enebullets.end();)
	{
		//itB_1->ShotCoolTime = ct;
		itB_1->ShotTimer += Scene::DeltaTime();
		if (ct <= itB_1->ShotTimer)
		{
			if (itB_1->GeneTimer == 0)
			{
				ball->shot(itB_1->pos, itB_1->dir, Speed, 0, 0);		
			}
			itB_1->ShotTimer = 0;
		}
		itB_1++;
	}
}

void EneBullet_1::Shotball(Ball_1* ball, double Speed, double dece, double ct)
{
	for (auto itB_1 = enebullets.begin(); itB_1 != enebullets.end();)
	{
		itB_1->ShotTimer += Scene::DeltaTime();
		if (ct <= itB_1->ShotTimer)
		{
			if (itB_1->GeneTimer == 0)
			{
				ball->shot(itB_1->pos, itB_1->dir, Speed, dece, 0);
			}
			itB_1->ShotTimer = 0;
		}
		itB_1++;
	}
}

void EneBullet_1::Shotball(Ball_1* ball, double Speed, double ct,Array<double> dir,double zurasu,double MinDece,double MaxDece)
{
	int i = 0;
	for (auto itB_1 = enebullets.begin(); itB_1 != enebullets.end();)
	{
		//itB_1->ShotCoolTime = ct;
		itB_1->ShotTimer += Scene::DeltaTime();
		if (ct <= itB_1->ShotTimer)
		{
			if (itB_1->GeneTimer == 0)
			{
				ball->shot(itB_1->pos, dir[i]+zurasu, Speed, Random(MinDece, MaxDece),0);
			}
			itB_1->ShotTimer = 0;
		}
		itB_1++; i++;
	}
}

void EneBullet_1::RandomShotball(Ball_1* ball, double MinSpeed, double MaxSpeed, Array<double> dir, double baratsuki, double MinD, double MaxD)
{
	int i = 0;
	for (auto itB_1 = enebullets.begin(); itB_1 != enebullets.end();)
	{
		if (itB_1->GeneTimer == 0)
		{
			ball->shot(itB_1->pos, dir[i] + Random(-baratsuki,baratsuki), Random(MinSpeed,MaxSpeed), Random(MinD, MaxD), 0);
		}
		itB_1++; i++;
	}
}

void EneBullet_1::ShotRay(Ball_1* ball ,int32 hutosa, Color c,Pac *p)
{
	for (auto& bullet : enebullets)
	{
		ball->ShotRay(bullet.pos, bullet.dir, hutosa, c);
		ball->IntersectsPac(p, bullet.pos);
	}
}

void EneBullet_1::ShotRay(Ball_1* ball, int32 hutosa, Color c, double len)
{
	ball->RayAllExtingish();
	for (auto& bullet : enebullets)
	{
		ball->ShotRay(bullet.pos, bullet.dir, hutosa, len, c);
	}
}

void EneBullet_1::HunsuiShot(Ball_1* ball, double maxs, double mins, double ct, double zurasu, double grab)
{
	for (auto it = enebullets.begin(); it != enebullets.end();)
	{
		it->ShotTimer += Scene::DeltaTime();
		if (it->ShotTimer >= ct)
		{
			if(it->GeneTimer==0)
				ball->shot(it->pos, it->dir + Random(-zurasu, zurasu), Random(mins, maxs), 0, 0, grab);
			it->ShotTimer = 0;
		}
		it++;
	}
	ball->BallFall();
}

void EneBullet_1::NeutronStarRay(Ball_1* ball, int32 hutosa, Color c, Pac* p)
{
	ball->RayAllExtingish();
	for (auto& bullet : enebullets)
	{
		ball->ShotRay(bullet.pos, bullet.dir, hutosa, c);
		ball->ShotRay(bullet.pos, bullet.dir+3.14, hutosa, c);
		Array<bool> i = ball->IntersectsPac(p, bullet.pos);
		if (i[0]||i[1])
		{
			p->RayPacmove(bullet.pos, bullet.dir);
		}
	}
}

Array<Vec2> EneBullet_1::SetBulSurr(Vec2 center, double bdir, int32 k)
{
	Array<Vec2> zahyou;
	double Maxlen = Distance(Vec2(tableLeft, tableUpper), Vec2(WindowWide - tableLeft, WindowHight - tableUpper));

	for (int32 i = 0; i < k; i++)
	{
		if (const auto points = table.intersectsAt(MakeLine(Maxlen, bdir + 2 * 3.14 * i / k, center)))
		{
			for (const auto& point : *points)
			{
				if (point != center)
				{
					zahyou << point;
				}
			}
		}
	}
	return zahyou;
}

void EneBullet_1::GeneBullet_1()
{
	GeneTimerCount();
	for (auto itB_1 = enebullets.begin(); itB_1 != enebullets.end();)
	{
		if (itB_1->GeneTimer >= GeneTime)
		{
			itB_1->GeneTimer = 0;
		}
		itB_1++;
	}
}


void EneBullet_1::GeneBullet_1(double time)
{
	GeneTimerCount();
	for (auto itB_1 = enebullets.begin(); itB_1 != enebullets.end();)
	{
		if (itB_1->GeneTimer >= time)
		{
			itB_1->GeneTimer = 0;
		}
		itB_1++;
	}
}

void EneBullet_1::deleteEneAll()
{
	for (auto it = enebullets.begin(); it != enebullets.end();)
	{
		it = enebullets.erase(it);
	}
}

bool EneBullet_1::TimerNotCount()
{
	bool b = true;
	for (auto itB_1 = enebullets.begin(); itB_1 != enebullets.end();)
	{
		if (itB_1->GeneTimer != 0)
		{
			b = false;
		}
		itB_1++;
	}
	return b;
}

void EneBullet_1::SwingNeck(double delta)
{
	for (auto itB_1 = enebullets.begin(); itB_1 != enebullets.end();)
	{
		itB_1->dir += delta;
		itB_1++;
	}
}

void EneBullet_1::SwingNeck_360(double t)
{
	for (auto itB_1 = enebullets.begin(); itB_1 != enebullets.end();)
	{
		itB_1->dir += 6.28 * Scene::DeltaTime() / t;
		if (itB_1->dir >= 6.28)
			itB_1->dir = 0;
		itB_1++;
	}
}



void EneBullet_1::ResetDir(Array<double> Init)
{
	int i = 0;
	for (auto itB_1 = enebullets.begin(); itB_1 != enebullets.end();)
	{
		itB_1->dir = Init[i];
		itB_1++; i++;
	}
}

void EneBullet_1::Resettheta()
{
	theta = 0;
}

//三角関数の首振り
void EneBullet_1::SwingingSIN(double range, double isou, double t,double jiku)
{
	double dt = Scene::DeltaTime();
	for (auto it = enebullets.begin(); it != enebullets.end();)
	{
		if (theta >= Abs(t))
		{
			theta = 0;
			it->dir = jiku;
		}
		it->dir += (2 * 3.14 * range / t) * dt * cos((3.14 * 2 / t) * theta + isou +0.05);//0.05はよくわかんない誤差を修正するため(tが小さいほど誤差は大きい)
		theta += dt;
		it++;
	}
}

void EneBullet_1::SwingingSIN(double range, double isou, double t, Array<double> jiku)
{
	if (size(jiku) < size(enebullets))
	{
		Print << U"SwingingSINの引数Array<double>jikuはenebulletsよりも多くの要素数をもつ必要があります。";
	}
	else
	{
		int32 i = 0;
		double dt = Scene::DeltaTime();
		for (auto it = enebullets.begin(); it != enebullets.end();)
		{
			if (theta >= Abs(t))
			{
				theta = 0;
				it->dir = jiku[i];
			}
			it->dir += (2 * 3.14 * range / t) * dt * cos((3.14 * 2 / t) * theta + isou + 0.05);//0.05はよくわかんない誤差を修正するため(tが小さいほど誤差は大きい)
			theta += dt;
			it++; i++;
		}
	}
}

void EneBullet_1::SwingingSIN(double range, double isou, Array<double>t, Array<double>jiku)
{
	if (size(jiku) < size(enebullets) || size(t) < size(enebullets))
	{
		Print << U"SwingingSINの引数Array<double>jikuはenebulletsよりも多くの要素数をもつ必要があります。";
	}
	else
	{
		int32 i = 0;
		double dt = Scene::DeltaTime();
		for (auto it = enebullets.begin(); it != enebullets.end();)
		{
			if (theta >= Abs(t[i]))
			{
				theta = 0;
				it->dir = jiku[i];
			}
			it->dir += (2 * 3.14 * range / t[i]) * dt * cos((3.14 * 2 / t[i]) * theta + isou + 0.05);//0.05はよくわかんない誤差を修正するため(tが小さいほど誤差は大きい)
			theta += dt;
			it++; i++;
		}
	}
}

void EneBullet_1::SetDir(double dir)
{
	for (auto it = enebullets.begin(); it != enebullets.end();)
	{
		it->dir = dir;
		it++;
	}
}

void EneBullet_1::MoveGrab(Vec2 point, double g)
{
	for (auto& Bullet : enebullets)
	{
		if(Distance(point, Bullet.pos)>20)
			Bullet.Velocity += (point - Bullet.pos) * g * Scene::DeltaTime() / squared(Distance(point, Bullet.pos));
	}
	MoveXY();
}

void EneBullet_1::MoveCircle(Vec2 p, double r)
{
	for (auto& Bullet : enebullets)
	{
		Bullet.Velocity += (p - Bullet.pos) * squared(AbsV(Bullet.Velocity)) * Scene::DeltaTime() / squared(r);
	}
	MoveXY();
}

void EneBullet_1::ProcessionSet(double dir, int32 dis)
{
	for (auto& Bullet : enebullets)
	{
		Bullet.pos.x += cos(dir) * dis;
		Bullet.pos.y += sin(dir) * dis;
	}
}

void EneBullet_1::absor(Player* p, Vec2 point,double d,bool enemyBreak)
{
	
	Vec2 houkou{ point.x - p->GetMallet().x,point.y - p->GetMallet().y };
	p->Move(houkou * d * Scene::DeltaTime() / houkou.length(), enemyBreak);
}

bool EneBullet_1::T5Wipe(Ball_1* ball, double t1,double t2)
{
	double deltatime = Scene::DeltaTime();
	Time += deltatime;
	if (t2 >= Time)
	{
		kasandir = 0;
		if (t2 / 3 < Time)
			ball->RayAllExtingish();
		Time1 = 0;
	}
	if (t2 < Time && t2 + t1 >= Time)
	{
		double dir = CalDir(Vec2(WindowWide - tableLeft, tableUpper), Vec2(tableLeft, WindowHight - tableUpper)) - CalDir(Vec2(WindowWide - tableLeft, tableUpper), Vec2(WindowWide - tableLeft, WindowHight - tableUpper))+3.14/22;
		Time1 += deltatime;
		if (Time1 >= t1/24)
		{
			if (dir >= dir * (Time - t2) * 2 / t1)
				ball->shot(Vec2(WindowWide - tableLeft, tableUpper), dir * (Time - t2)*2 / t1 + CalDir(Vec2(WindowWide - tableLeft, tableUpper), Vec2(WindowWide - tableLeft, WindowHight - tableUpper)) + Random(-3.14 / 60, 3.14 / 60), Random(300, 400), Random(20, 40), 0);
			if (Time1 >= t1 / 5)
				Time1 = 0;
		}
	}
	if (t2 + t1 < Time && t2 * 2 + t1 >= Time)
	{

	}
	if (t2*2+t1 < Time && t2*2+t1*2 >= Time)
	{
		double dir = CalDir(Vec2(tableLeft, WindowHight - tableUpper), Vec2(WindowWide - tableLeft, tableUpper)) - CalDir( Vec2(tableLeft, WindowHight - tableUpper), Vec2(tableLeft, tableUpper)) + 3.14 / 7+3.14/45;
		ball->RayAllExtingish();
		ball->ShotRay(Vec2(tableLeft, WindowHight - tableUpper), kasandir + CalDir(Vec2(tableLeft, WindowHight - tableUpper), Vec2(tableLeft, tableUpper)), 5, Palette::Gold);

		kasandir += dir * (1 - Cos(2 * 3.14 * (Time - t2 * 2 - t1) / t1)) * deltatime / t1;
	}
	if (t2*2+t1*2 < Time && 2*t1+3*t2 >= Time)
	{
		if(t2 * 2 + t1 * 2 + t2 / 3<Time)
			ball->RayAllExtingish();
		Time1 = 0;
	}
	if (2*t1+t2*3 < Time && t1*3+t2*3 >= Time)
	{
		double dir = CalDir(Vec2(WindowWide - tableLeft, tableUpper), Vec2(tableLeft, WindowHight - tableUpper)) - CalDir(Vec2(WindowWide - tableLeft, tableUpper), Vec2(WindowWide - tableLeft, WindowHight - tableUpper))+3.14 / 16;
		Time1 += deltatime;
		if (Time1 >=  t1/ 24)
		{
			if (dir >= dir * (Time - 2 * t1 - t2 * 3) *2 / t1)
				ball->shot(Vec2(tableLeft, tableUpper), dir * (Time - 2 * t1 - t2 * 3)*2 /t1 + 3.14 * 5 / 11  - dir + Random(-3.14 / 60, 3.14 / 60), Random(300, 400), Random(20, 40), 0);
			if (Time1 >= t1 / 5)
				Time1 = 0;
		}
	}
	if (t1 * 3 + t2 * 3 < Time && t1 * 3 + t2 * 4 >= Time)
	{
		Time1 = 0;
		kasandir = 0;
	}
	if (t1 * 3 + t2 * 4 < Time && t1 * 4 + t2 * 4 >= Time)
	{
		double dir = CalDir(Vec2(WindowWide - tableLeft, tableUpper), Vec2(tableLeft, WindowHight - tableUpper)) - CalDir(Vec2(WindowWide - tableLeft, tableUpper), Vec2(WindowWide - tableLeft, WindowHight - tableUpper)) + 3.14 / 6+3.14/13;
		ball->RayAllExtingish();
		ball->ShotRay(Vec2(WindowWide - tableLeft, WindowHight - tableUpper), kasandir + CalDir(Vec2(WindowWide - tableLeft, WindowHight - tableUpper), Vec2(tableLeft, WindowHight - tableUpper)), 5, Palette::Gold);
		kasandir += dir * (1 - Cos(2 * 3.14 * (Time - t1 * 3 - t2 * 4) / t1)) * deltatime / t1;
	}
	if (t1 * 4 + t2 * 4 < Time)
	{
		Time = 0;
		return true;
	}
	return false;
}

void EneBullet_1::SetBallHexagon(Ball_1* ball, int32 n, Vec2 center,int32 interval)
{
	for (int32 i = 0; i < n; i++)
	{
		Vec2 pos{ center.x, center.y - interval * i };
		if (i == 0)
			ball->shot(pos, 0, 0, 0, 0);
		for (int32 j = 0; j < i; j++)
		{
			pos += interval * Vec2(Cos(3.14 / 6), Sin(3.14 / 6));
			ball->shot(pos, 0, 0, 0, 0);
		}
		for (int32 j = 0; j < i; j++)
		{
			pos += interval * Vec2(0, 1);
			ball->shot(pos, 0, 0, 0, 0);
		}
		for (int32 j = 0; j < i; j++)
		{
			pos += interval * Vec2(Cos(3.14 * 5 / 6), Sin(3.14 * 5 / 6));
			ball->shot(pos, 0, 0, 0, 0);
		}
		for (int32 j = 0; j < i; j++)
		{
			pos += interval * Vec2(Cos(3.14 * 7 / 6), Sin(3.14 * 7 / 6));
			ball->shot(pos, 0, 0, 0, 0);
		}
		for (int32 j = 0; j < i; j++)
		{
			pos += interval * Vec2(0, -1);
			ball->shot(pos, 0, 0, 0, 0);
		}
		for (int32 j = 0; j < i; j++)
		{
			pos += interval * Vec2(Cos(3.14 * 11 / 6), Sin(3.14 * 11 / 6));
			ball->shot(pos, 0, 0, 0, 0);
		}
	}
}

Array<Vec2> EneBullet_1::SetKabeHaritsuki(Vec2 cen, int32 n, double hanniRad, double Dir)
{
	double Maxlen = Distance(Vec2(tableLeft, tableUpper), Vec2(WindowWide - tableLeft, WindowHight - tableUpper));
	Array<Vec2> zahyou;
	for (int32 i = 0; i < n; i++)
	{
		if (const auto points = table.intersectsAt(MakeLine(Maxlen, Dir - hanniRad / 2 + hanniRad * i / (n - 1), cen)))
		{
			for (const auto& point : *points)
			{
				if (point != cen)
				{
					zahyou << point;
				}
			}
		}
	}
	return zahyou;
}

void EneBullet_1::SetKabeHaritsuki_kai(Vec2 cen, int32 n, double hanniRad, double dir)
{
	double t = enebullets[0].ShotTimer;
	deleteEneAll();
	double Maxlen = Distance(Vec2(tableLeft, tableUpper), Vec2(WindowWide - tableLeft, WindowHight - tableUpper));
	for (int32 i = 0; i < n; i++)
	{
		if (const auto points = table.intersectsAt(MakeLine(Maxlen, dir - hanniRad / 2 + hanniRad * i / (n - 1), cen)))
		{
			for (const auto& point : *points)
			{
				if (point != cen)
				{
					bullets b;
					if (point.x <WindowWide / 2 && point.y < WindowHight - tableUpper)
						b= bullets(point, 0, 0, t, Vec2(0, 0));
					if (point.x > WindowWide / 2 && point.y < WindowHight - tableUpper)
						b=bullets(point, 3.14, 0, t, Vec2(0, 0));
					if (point.y >= WindowHight - tableUpper)
						b=bullets(point, 3.14 * 3 / 2, 0, t, Vec2(0, 0));
					enebullets << b; 
				}
			}
		}
	}
}

void EneBullet_1::RectArea(Ball_1* ball, Vec2 p1, Vec2 p2, int32 hutosa, Color c)
{
	ball->RayAllExtingish();
	ball->ShotRay(p1, CalDir(p1, Vec2(p1.x, p2.y)), hutosa, Distance(p1, Vec2(p1.x, p2.y)), c);
	ball->ShotRay(p1, CalDir(p1, Vec2(p2.x, p1.y)), hutosa, Distance(p1, Vec2(p2.x, p1.y)), c);
	ball->ShotRay(p2, CalDir(p2, Vec2(p2.x, p1.y)), hutosa, Distance(p2, Vec2(p2.x, p1.y)), c);
	ball->ShotRay(p2, CalDir(p2, Vec2(p1.x, p2.y)), hutosa, Distance(p2, Vec2(p1.x, p2.y)), c);
}
