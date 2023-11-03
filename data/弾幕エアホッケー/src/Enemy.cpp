#include "stdafx.h"
#include "Enemy.h"
#include "Pac.h"

Enemy::Enemy(double x, double y, double e, double m_r, double h_s, double r_s, double m_s, double tableleft, double tableupper,
	double windowwide, double windowhight, double g_r, Array<Vec2> life)
	:Mallet(x, y, e, m_r, h_s, r_s, m_s, tableleft, tableupper, windowwide, windowhight, g_r, life)
{
}
Enemy::~Enemy()
{

}

void Enemy::emove(double x)
{
	if(!Break)
		SetXY(x,tableUpper+Pr);
}

void Enemy::CollidePac(Vec2 v,double damage)
{
	duability -= sqrt(v.x * v.x + v.y * v.y) * damage;
}

int32 Enemy::GetDua()
{
	return duability;
}

void Enemy::SetDua(int32 d)
{
	duability = d;
}

void Enemy::BreakMallet()
{
	SetXY(-1000, -1000);
	duability = 0;
	Break = true;
}

void Enemy::RepairMallet()
{
	duability = DuaInit;
	Break = false;
}
