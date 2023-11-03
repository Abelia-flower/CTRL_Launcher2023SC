#include "stdafx.h"
#include "Mallet.h"
#include "data.h"

Mallet::Mallet(double x, double y, double e, double m_r, double h_s, double r_s, double m_s, double tl, double tu,
	double ww, double wh, double g_r, Array<Vec2> life)
	:duability(DuaInit), mallet(x, y, m_r), grip(x, y, g_r), em(e), highspeed(h_s), rowspeed(r_s), malletspeed(m_s),
	tl(tl), tu(tu), ww(ww), wh(wh), grip_r(g_r), Atarihantei(x, y, atarihantei)
{
	lifes = life;
	Break = false;
}

Mallet::~Mallet() {}

void Mallet::SetXY(double x, double y)
{
	SetPreXY();
	mallet.x = x, mallet.y = y;
	grip.x = x, grip.y = y;
	Atarihantei.x = x, Atarihantei.y = y;
}
void Mallet::SetX(double x)
{
	SetPreX();
	mallet.x = x;
	grip.x = x;
	Atarihantei.x = x;
}
void Mallet::SetY(double y)
{
	SetPreY();
	mallet.y = y;
	grip.y = y;
	Atarihantei.y = y;
}

void Mallet::MoveX()
{
	double xyz = malletspeed * Scene::DeltaTime() * (key[Right] - key[Left]);
	SetPreX();
	mallet.x += xyz;
	grip.x += xyz;
	Atarihantei.x += xyz;
}
void Mallet::MoveY()
{
	double xyz= malletspeed * Scene::DeltaTime() * (key[Down] - key[Up]);
	SetPreY();
	mallet.y += xyz;
	grip.y += xyz;
	Atarihantei.y += xyz;
}

void Mallet::SetPreXY()
{
	preMxy.x = mallet.x; preMxy.y = mallet.y;
}

void Mallet::SetPreX()
{
	preMxy.x = mallet.x;
}
void Mallet::SetPreY()
{
	preMxy.y = mallet.y;
}

Circle Mallet::GetMallet()
{
	return mallet;
}

Circle Mallet::GetGrip()
{
	return grip;
}

Vec2 Mallet::GetXY()
{
	return mallet.center;
}

Vec2 Mallet::GetPreXY()
{
	return preMxy;
}

double Mallet::GetE()
{
	return em;
}

double Mallet::GetSpeed()
{
	return malletspeed;
}

double Mallet::GetHighspeed()
{
	return highspeed;
}

double Mallet::GetRowspeed()
{
	return rowspeed;
}

int32* Mallet::GetKey()
{
	return key;
}
void Mallet::ResetKey()
{
	for (int i = 0; i < 4; i++)
	{
		key[i] = 0;
	}
}

bool Mallet::GetRevivaled()
{
	return Revivaled;
}

bool Mallet::GetBreak()
{
	return Break;
}

void Mallet::DrawLifes()
{
	for (auto& life : lifes)
	{
		Circle{ life,10 }.draw(Palette::White);
	}
}

void Mallet::LostLifes()
{
	lifes.pop_back();
}

void Mallet::SetRevivaled(bool b)
{
	Revivaled = b;
	Break = false;
}

int32 Mallet::GetLifeNum()
{
	return lifes.size();
}
