#include"myfunction.h"

double squared(double x)
{
	return x * x;
}

double Distance(Vec2 a, Vec2 b)
{
	return sqrt(squared(a.x - b.x) + squared(a.y - b.y));
}

Vec2 Rotation(Vec2 a, double rad)
{
	Vec2 v;
	v.x = a.x * cos(rad) - a.y * sin(rad);
	v.y = a.y * cos(rad) + a.x * sin(rad);
	return v;
}

double InnerProduct(Vec2 a, Vec2 b)
{
	return a.x * b.x + a.y * b.y;
}

double AbsV(Vec2 a)
{
	return sqrt(squared(a.x) + squared(a.y));
}

double InteriorAngle(Vec2 a, Vec2 b)
{
	return acos(InnerProduct(a, b) / (AbsV(a) * AbsV(b)));
}

Vec2 Merikomi(Circle pac, Vec2 velocity,Vec2 point)//pointは円が衝突した点
{
	Vec2 p = point - pac.center;
	
	return pac.center - velocity * (-InnerProduct(p, velocity)
		+ sqrt(squared(InnerProduct(p, velocity)) - squared(AbsV(velocity)) * (squared(AbsV(p)) - squared(pac.r))))/ squared(AbsV(velocity));
}

Vec2 Merikomi(Circle p, Circle m, Vec2 v)
{
	int32 r = p.r + m.r;
	//Vec2 x = m.center - p.center;
	Circle np(p.center, r);
	return Merikomi(np, v, m.center);
}

Line MakeLine(double len, double dir, Vec2 start)
{
	return Line{ start,start + len * Vec2(Cos(dir),Sin(dir)) };
}

double CalDir(Vec2 start, Vec2 end)
{
	if (end.y - start.y > 0)
	{
		return acos((end.x - start.x) / Distance(start, end));
	}
	else
	{
		return 2 * Math::Pi - acos((end.x - start.x) / Distance(start, end));
	}
}
