#include "stdafx.h"
#include "EneBall.h"

EneBall::EneBall(int32 BallR, int32 BallVR) :r(BallR), vr(BallVR)
{
}

EneBall:: ~EneBall() {};

void EneBall::IntersectsPac(Pac* p)
{
	for (auto itEneButs = Balls.begin(); itEneButs != Balls.end();)
	{
		const Circle enemyCircle{ itEneButs->pos,r };
		bool skip = false;

		if (enemyCircle.intersects(p->GetPac()))
		{
			//消滅エフェクト
			effect.add([pos = itEneButs->pos](double t)
			{
				const double t2 = t / 2;    //円の外枠の太さが増加する速さ
				Circle{ pos,t * 20 }.drawFrame(t2 * 20, AlphaF(1 - t));
				return(t < 1);
			});
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

void EneBall::IntersectsPac(Pac* p,double iryoku)
{
	for (auto itEneButs = Balls.begin(); itEneButs != Balls.end();)
	{
		const Circle enemyCircle{ itEneButs->pos,r };
		bool skip = false;

		if (enemyCircle.intersects(p->GetPac()))
		{
			Vec2 ballvelo{ itEneButs->Speed * cos(itEneButs->dir), itEneButs->Speed * sin(itEneButs->dir) };
			p->SetVelocity(p->GetPacVelocity() + ballvelo * iryoku);
			//消滅エフェクト
			effect.add([pos = itEneButs->pos](double t)
			{
				const double t2 = t / 2;    //円の外枠の太さが増加する速さ
				Circle{ pos,t * 20 }.drawFrame(t2 * 20, AlphaF(1 - t));
				return(t < 1);
			});
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

Array<bool> EneBall::IntersectsPac(Pac* pac, Vec2 start)
{
	Array<bool> intersects;
	for (auto it = Ray.begin(); it != Ray.end();)
	{
		if (const auto points = it->line.intersectsAt(pac->GetPac()))
		{
			double dis = it->line.length();
			Vec2 p;
			for (const auto& point : *points)
			{
				if (Distance(start, point) < dis)
				{
					dis = Distance(start, point);
					p = point;
				}
			}
			Line l{ start,p };
			it->line = l;
			intersects << true;
		}
		else
		{
			intersects << false;
		}
		it++;
	}
	return intersects;
}

void EneBall::IntersectsHunsui(Pac* pac, double iryoku)
{
	for (auto it = Ray.begin(); it != Ray.end();)
	{
		if (it->line.intersects(pac->GetPac()))
		{
			pac->SetVelocity(Vec2(pac->GetPacVelocity().x, pac->GetPacVelocity().y - iryoku));
		}
		it++;
	}
}

void EneBall::IntersectsifUe(Pac* pac, double iryoku)
{
	if (pac->GetPacVelocity().y <= 0)
	{
		for (auto it = Ray.begin(); it != Ray.end();)
		{
			if (it->line.intersects(pac->GetPac()))
			{
				pac->SetVelocity(Vec2(pac->GetPacVelocity().x, pac->GetPacVelocity().y - iryoku));
			}
			it++;
		}
	}
}

void EneBall::IntersectsJun(Pac* pac, double iryoku)
{
	if (pac->GetPacVelocity().y <= 0)
	{
		for (auto it = Ray.begin(); it != Ray.end();)
		{
			if (it->line.intersects(pac->GetPac()))
			{
				pac->SetVelocity(Vec2(pac->GetPacVelocity().x, pac->GetPacVelocity().y - iryoku));
			}
			it++;
		}
	}
	else
	{
		for (auto it = Ray.begin(); it != Ray.end();)
		{
			if (it->line.intersects(pac->GetPac()))
			{
				pac->SetVelocity(Vec2(pac->GetPacVelocity().x, pac->GetPacVelocity().y + iryoku));
			}
			it++;
		}
	}
}

bool EneBall::IntersectsPlayer(Player* player)
{
	for (auto itEneButs = Balls.begin(); itEneButs != Balls.end();)
	{
		const Circle enemyCircle{ itEneButs->pos,r };
		if (enemyCircle.intersects(player->GetAtarihantei()))
		{
			player->duabilityDown();
			return true;
		}
		itEneButs++;
	}
	return false;
}

bool EneBall::RayIntersectsPlayer(Player* player)
{
	for (auto it = Ray.begin(); it != Ray.end();)
	{
		double theta;
		if (it->line.end.x - it->line.center().x < 0)
		{
			theta = acos((it->line.end.y - it->line.center().y)*2 / it->line.length());
		}
		else
		{
			theta = -acos((it->line.end.y - it->line.center().y)*2 / it->line.length());
		}
		const Rect rayRect{ Arg::center(int32(it->line.center().x),int32(it->line.center().y)), it->hutosa, int32(it->line.length()) };
		if (isfinite(theta))
		{
			if (rayRect.rotated(theta).intersects(player->GetAtarihantei()))
			{
				player->duabilityDownContinuous();

				return true;
			}
		}
		it++;
	}
	return false;
}

void EneBall::RemoveOutBall(Rect table)
{
	for (auto itEneButs = Balls.begin(); itEneButs != Balls.end();)
	{
		const Circle enemyCircle{ itEneButs->pos,0 };
		bool skip = false;

		if (!table.intersects(enemyCircle))
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

void EneBall::Ball_1_draw()
{
	Circle B_1;

	for (auto itEneButs = Balls.begin(); itEneButs != Balls.end();)
	{
		B_1.center = itEneButs->pos;
		B_1.r = vr;
		B_1.draw(ColorF(Palette::Orange));
		++itEneButs;
	}
	effect.update();
}

void EneBall::BallAllExtingish()
{
	for (auto itEneButs = Balls.begin(); itEneButs != Balls.end();)
	{
		itEneButs = Balls.erase(itEneButs);
	}
	for (auto it = Ray.begin(); it != Ray.end();)
	{
		it = Ray.erase(it);
	}
}

void EneBall::BallAllExtingishWithoutRay()
{
	for (auto itEneButs = Balls.begin(); itEneButs != Balls.end();)
	{
		itEneButs = Balls.erase(itEneButs);
	}
}

void EneBall::RayAllExtingish()
{
	for (auto it = Ray.begin(); it != Ray.end();)
	{
		it = Ray.erase(it);
	}
}

void EneBall::MoveAt(Vec2 dir)
{
	for (auto& Ball : Balls)
	{
		Ball.pos.x += (Scene::DeltaTime() * dir.normalized().x * Ball.Speed);
		Ball.pos.y += (Scene::DeltaTime() * dir.normalized().y * Ball.Speed);
	}
}

void EneBall::pop_back()
{
	Balls.pop_back();
}

bool EneBall::DistanceOver_if(Vec2 p, Vec2 b, double r)
{
	if (Distance(p, b) > r)
	{
		return true;
	}
	else
	{
		return false;
	}
}

Array<EneBall::ball> EneBall::GetBalls()
{
	return Balls;
}

Array<EneBall::ray>EneBall::GetRays()
{
	return Ray;
}

int32 EneBall::GetVisualR()
{
	return vr;
}

int32 EneBall::GetAtariR()
{
	return r;
}

void EneBall::RayDraw()
{
	for (auto it = Ray.begin(); it != Ray.end();)
	{
		it->line.draw(it->hutosa, it->color);
		//it = Ray.erase(it);
		it++;
	}
}

void EneBall::Draw(Color c)
{
	Circle B_1;
	for (auto itEneButs = Balls.begin(); itEneButs != Balls.end();)
	{
		B_1.center = itEneButs->pos;
		B_1.r = vr;
		B_1.draw(c);
		++itEneButs;
	}
	effect.update();
}

void EneBall::DrawA(Color c,double t)
{
	Circle b;
	for (auto it = Balls.begin(); it != Balls.end();)
	{
		ColorF co = { c,(t - it->time)/t };
		b.center = it->pos;
		b.r = vr;
		b.draw(co);
		it++;
	}
}
