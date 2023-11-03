#include "stdafx.h"
#include "Player.h"

Player::Player(double x, double y, double em, double m_r, double h_s, double r_s, double m_s, double tableleft, double tableupper,
	double windowwide, double windowhight, double g_r,Array<Vec2> life)
	:Mallet(x, y, em, m_r, h_s, r_s, m_s, tableleft, tableupper, windowwide, windowhight, g_r,life), delta(0), duability(DuaInit)
{
	Revivaled = false;
}
Player::~Player()
{

}

void Player::keymove(bool enemyBreak)
{
	if (!Break) {
		delta = malletspeed * Scene::DeltaTime();
		if (KeyLeft.pressed())
		{
			if (mallet.x - delta > tl + mallet.r)			//壁判定
			{
				key[Left] = 1;
			}
			else
			{
				SetX(tl + mallet.r);					//壁あったら
			}
		}
		//右
		if (KeyRight.pressed())
		{
			if (mallet.x + delta < ww - tl - mallet.r)
			{
				key[Right] = 1;
			}
			else
			{
				SetX(ww - tl - mallet.r);
			}
		}
		//上
		if (KeyUp.pressed())
		{
			if (enemyBreak)//敵が壊れてれば
			{
				if (mallet.y - delta > tu + mallet.r)
				{
					key[Up] = 1;
				}
				else
				{
					SetY(tu + mallet.r);
				}
			}
			else//壊れてなければ
			{
				if (mallet.y - delta > tu + mallet.r + tableHight / 2)
				{
					key[Up] = 1;
				}
				else
				{
					SetY(tu + mallet.r+tableHight/2);
				}
			}
		}
		//下
		if (KeyDown.pressed())
		{
			if (mallet.y + delta < wh - tu - mallet.r)
			{
				key[Down] = 1;
			}
			else
			{
				SetY(wh - tu - mallet.r);
			}
		}
		MoveX();
		MoveY();
	}
}

void Player::Move(Vec2 houkou, bool enemyBreak)
{
	if (!Break)
	{
		SetPreXY();
		if (!enemyBreak)
		{
			if (mallet.y + houkou.y > tableUpper + tableHight / 2 + mallet.r) {
				SetXY(mallet.x + houkou.x, mallet.y + houkou.y);
			}
		}
		else
		{
			SetXY(mallet.x + houkou.x, mallet.y + houkou.y);
		}
	}
}

void Player::ChangeSpeed()
{
	if (KeyShift.pressed())
	{
		malletspeed = rowspeed;
	}
	else
	{
		malletspeed = highspeed;
	}
}

void Player::duabilityDown()
{
	duability -= damage;
}

void Player::duabilityDownContinuous()
{
	duability -= Raydamage * Scene::DeltaTime();
}

int32 Player::GetDua()
{
	return duability;
}

Circle Player::GetAtarihantei()
{
	return Atarihantei;
}



void Player::BreakMallet()
{
	if (!Break)
	{
		Break = true;
		duability = 0;
		SetXY(-1000, -1000);
	}
	RepairMallet();
}

void Player::Draw()
{
	if (Break)
	{
		Circle{ GetPreXY(),GetMallet().r }.draw(ColorF(Palette::Whitesmoke, 0.5));
		Circle{ GetPreXY(),GetGrip().r }.drawFrame(1,ColorF(Palette::Gray, 0.5));
		Circle{ GetPreXY(),GetAtarihantei().r }.draw(ColorF(Palette::Red, 0.5));
	}
	else
	{
		GetMallet().draw(ColorF(Palette::Whitesmoke));
		GetGrip().drawFrame(1, ColorF(Palette::Gray));
		GetAtarihantei().draw(ColorF(Palette::Red));
	}
}

void Player::RepairMallet()
{
	duability += Scene::DeltaTime() * DuaInit / RepairTime;
	if (duability >= DuaInit)
	{
		Repaired();
	}
}

void Player::Repaired()
{
	duability = DuaInit;
	SetXY(GetPreXY().x, GetPreXY().y);
	Revivaled = true;
	Break = false;
}
