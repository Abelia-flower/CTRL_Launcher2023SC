#include "stdafx.h"
#include "Ball_1.h"

Ball_1::Ball_1(int32 r1, int32 r2) :EneBall(r1,r2), R(r2)
{

}

Ball_1::~Ball_1()
{

}

void Ball_1::shot(Vec2 start, double dir, double speed, double decele, double t)
{
	ball b = { start,dir,speed,decele ,t };
	Balls << b;
}

void Ball_1::shot(Vec2 start, double dir, double Speed, double dec, double t, double gra)
{
	ball b = { start,dir,Speed,dec,t };
	Balls << b;
	g = gra;
}

void Ball_1::ShotRay(Vec2 start, double dir,int32 hutosa,Color c)
{
	ray r{ {start.x,start.y,start.x+1500 * cos(dir),start.y+1500 * sin(dir)},c,hutosa };
	
	const auto points = table.intersectsAt(r.line);
	
	for (auto& point : *points)
	{
		
		if (point != start)
		{
			r = { {start,point},c,hutosa };
			Ray << r;			
		}
	}
}

void Ball_1::ShotRay(Vec2 start, double dir, int32 hutosa, double len, Color c)
{
	ray r{ {start.x,start.y,start.x + len * Cos(dir),start.y + len * Sin(dir)},c,hutosa };
	Ray << r;
}

void Ball_1::BallSetX(int32 x)
{
	for (auto& Ball : Balls)
	{
		Ball.pos.x = x;
	}
}

void Ball_1::BallSetY(int32 y)
{
	for (auto& Ball : Balls)
	{
		Ball.pos.y = y;
	}
}

void Ball_1::BallSet(Array<Vec2> roca)
{
	if (size(roca) > size(Balls))
	{
		Print << U"BallSet内の処理。弾に指定した座標が弾の数を超えています。";
	}
	else
	{
		int32 i = 0;
		for (auto& p : roca)
		{
			Balls[i].pos = p;
			i++;;
		}
	}
}

void Ball_1::BallMove()
{
	for (auto& Ball:Balls)
	{
		Ball.time += Scene::DeltaTime();
		Ball.pos.x += (Scene::DeltaTime() * cos(Ball.dir) * Ball.Speed);
		Ball.pos.y += (Scene::DeltaTime() * sin(Ball.dir) * Ball.Speed);
	}
}

void Ball_1::BallMove(Vec2 xy)
{
	for (auto& Ball : Balls)
	{
		Ball.pos.x += xy.x;
		Ball.pos.y += xy.y;
	}
}

void Ball_1::BallMove(double min)
{
	for (auto& Ball : Balls)
	{
		if (Ball.Speed < min)
			Ball.Speed = min;

		Ball.pos.x += (Scene::DeltaTime() * cos(Ball.dir) * Ball.Speed);
		Ball.pos.y += (Scene::DeltaTime() * sin(Ball.dir) * Ball.Speed);
	}
}

void Ball_1::Move_if(Line line, double x, double y)
{
	for (auto& ball : Balls)
	{
		if (Circle{ ball.pos,5 }.intersects(line))
		{
			ball.pos.x += x;
			ball.pos.y += y;
		}
	}
}

void Ball_1::BallMoveMax(double max)
{
	for (auto& Ball : Balls)
	{
		if (Ball.Speed > max)
			Ball.Speed = max;

		Ball.pos.x += (Scene::DeltaTime() * cos(Ball.dir) * Ball.Speed);
		Ball.pos.y += (Scene::DeltaTime() * sin(Ball.dir) * Ball.Speed);
	}
}

void Ball_1::BallFall()
{
	double ds = Scene::DeltaTime();
	for (auto& ball : Balls)
	{
		ball.dir = CalDir(Vec2(0, 0), Vec2(Cos(ball.dir), Sin(ball.dir)) * ball.Speed + g * ds * Vec2(0, 1));
		ball.Speed = Vec2(Vec2(Cos(ball.dir), Sin(ball.dir)) * ball.Speed + g * ds * Vec2(0, 1)).length();
	}
}

//deceを引力定数にすれば玉ごとに引きよせ易さを変えることができる
void Ball_1::BallFall(Vec2 p)
{
	for (auto& Ball : Balls)
	{
		Vec2 altV{ Ball.Speed * cos(Ball.dir) - 1000000*Ball.deceleration * Scene::DeltaTime() * (Ball.pos.x - p.x) / (squared(Distance(p,Ball.pos))* Distance(p,Ball.pos)),
			Ball.Speed * sin(Ball.dir) - 1000000*Ball.deceleration * Scene::DeltaTime() * (Ball.pos.y - p.y) / (squared(Distance(p,Ball.pos)) * Distance(p,Ball.pos)) };
		
		if (altV.y < 0)
		{
			Ball.dir = 2*3.14-acos(altV.x / AbsV(altV));
		}
		else
		{
			Ball.dir= acos(altV.x / AbsV(altV));
		}
		Ball.Speed = AbsV(altV);
	}
}

void Ball_1::BallFall(Vec2 p,double g)
{
	for (auto& Ball : Balls)
	{
		Vec2 altV{ Ball.Speed * cos(Ball.dir) - 1000000 * g * Scene::DeltaTime() * (Ball.pos.x - p.x) / (squared(Distance(p,Ball.pos)) * Distance(p,Ball.pos)),
			Ball.Speed * sin(Ball.dir) - 1000000 * g * Scene::DeltaTime() * (Ball.pos.y - p.y) / (squared(Distance(p,Ball.pos)) * Distance(p,Ball.pos)) };
		
		if (altV.y < 0)
		{
			Ball.dir = 2 * 3.14 - acos(altV.x / AbsV(altV));
		}
		else
		{
			Ball.dir = acos(altV.x / AbsV(altV));
		}
		Ball.Speed = AbsV(altV);
	}
}

void Ball_1::BallFall_if(Vec2 p, double g, Vec2 from, double dis)
{
	for (auto& Ball : Balls)
	{
		if (Distance(Ball.pos, from) < dis) {
			Vec2 altV{ Ball.Speed * cos(Ball.dir) - 1000000 * g * Scene::DeltaTime() * (Ball.pos.x - p.x) / (squared(Distance(p,Ball.pos)) * Distance(p,Ball.pos)),
				Ball.Speed * sin(Ball.dir) - 1000000 * g * Scene::DeltaTime() * (Ball.pos.y - p.y) / (squared(Distance(p,Ball.pos)) * Distance(p,Ball.pos)) };

			if (altV.y < 0)
			{
				Ball.dir = 2 * 3.14 - acos(altV.x / AbsV(altV));
			}
			else
			{
				Ball.dir = acos(altV.x / AbsV(altV));
			}
			Ball.Speed = AbsV(altV);
		}
	}
}

void Ball_1::BallDecelerate()
{
	for (auto& Ball : Balls)
		if (Ball.Speed > 0)
		{
			Ball.Speed -= Ball.deceleration * Scene::DeltaTime();
		}
		else
		{
			Ball.time += Scene::DeltaTime();
		}
}

void Ball_1::BallDecelerate_if(Vec2 p, double r)
{
	for (auto& Ball : Balls)
		if (!DistanceOver_if(p, Ball.pos, r))
		{
			if (Ball.Speed > 0)
			{
				Ball.Speed -= Ball.deceleration;
			}
			else
			{
				Ball.time += Scene::DeltaTime();
			}
		}
}

void Ball_1::BallDecrease(double t)
{
	for (auto itEneButs = Balls.begin(); itEneButs != Balls.end();)
	{
		bool skip = false;

		if (itEneButs->time > t)
		{
			itEneButs = Balls.erase(itEneButs);
			skip = true;
		}

		if (skip)
		{
			continue;
		}

		++itEneButs;
	}
}

void Ball_1::BallDecrease()
{
	for (auto itEneButs = Balls.begin(); itEneButs != Balls.end();)
	{
		bool skip = false;

		if (itEneButs->time > 8)
		{
			itEneButs = Balls.erase(itEneButs);
			skip = true;
		}

		if (skip)
		{
			continue;
		}

		++itEneButs;
	}
}

void Ball_1::BallRemove_if(Vec2 pos, int32 r)
{
	for (auto it=Balls.begin();it!=Balls.end();)
	{
		if (Circle{ it->pos,R }.intersects(Circle{ pos,r }))
		{
			it = Balls.erase(it);
		}
		else
		{
			it++;
		}
	}
}

void Ball_1::PopBall()
{
	for (int32 i = 0; i < size(Balls); i++)
	{
		for (int32 j = i + 1; j < size(Balls); j++)
		{
			if (Circle{ Balls[i].pos,R }.intersects(Circle(Balls[j].pos, R)))
			{
				double theta = CalDir(Balls[i].pos, Balls[j].pos);
				Vec2 p1{ Balls[i].Speed * Cos(Balls[i].dir), Balls[i].Speed * Sin(Balls[i].dir) };
				Vec2 p2{ Balls[j].Speed * Cos(Balls[j].dir), Balls[j].Speed * Sin(Balls[j].dir) };
				Vec2 v1{ p1.x + (p2.y - p2.y) / tan(theta),p2.y };
				Vec2 v2{ p2.x + (p1.y - p1.y) / tan(theta),p1.y };
				if (isfinite(v1.length()) && isfinite(v2.length()) && isfinite(CalDir(Vec2(0, 0), v1)) && isfinite(CalDir(Vec2(0, 0), v1)))
				{
					v1 *= 1.1; v2 *= 1.1;
					Balls[i].dir = CalDir(Vec2(0, 0), v1); Balls[i].Speed = v1.length();
					Balls[j].dir = CalDir(Vec2(0, 0), v2); Balls[j].Speed = v2.length();
				}
			}
		}
	}
}
