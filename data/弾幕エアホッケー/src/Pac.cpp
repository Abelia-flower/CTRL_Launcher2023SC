
#include "stdafx.h"
#include<Siv3D.hpp>
#include "Pac.h"
#include"myfunction.h"

Pac::Pac(double x, double y, double p_r, Vec2 Velo, double tableleft, double tableupper,
	double windowwide, double windowhight, double pms)
	:pac(x, y, p_r), PacVelocity(Velo), tl(tableleft), tu(tableupper), ww(windowwide), wh(windowhight), pacMaxSpeed(pms)
{

}

Pac::~Pac() {};

void Pac::SetXY(Vec2 xy)
{
	pac.center = xy;
}

void Pac::SetVelocity(Vec2 xy)
{
	PacVelocity = xy;
}

void Pac::pacSpeedRestrict()
{
	if (sqrt(PacVelocity.x * PacVelocity.x + PacVelocity.y * PacVelocity.y) > pacMaxSpeed)
	{
		PacVelocity.x *= pacMaxSpeed / (sqrt(PacVelocity.x * PacVelocity.x + PacVelocity.y * PacVelocity.y));
		PacVelocity.y *= pacMaxSpeed / (sqrt(PacVelocity.x * PacVelocity.x + PacVelocity.y * PacVelocity.y));
	}
}

void Pac::intersects(Mallet* m)
{
	if (pac.intersects(m->GetMallet()))
	{
		if (pacMoveType)//もしレーザにあたっていない（パックの見た目の動きがそのままなら
		{
			//すべてマレットに対するパックの相対的な値
			vx = PacVelocity.x + m->GetSpeed() * (m->GetKey()[Left] - m->GetKey()[Right]), vy = PacVelocity.y + m->GetSpeed() * (m->GetKey()[Up] - m->GetKey()[Down]);
			ConPacSpeed = sqrt(vx * vx + vy * vy);
			ConPacVelocity = { vx,vy };
			disx = pac.x - m->GetMallet().x, disy = pac.y - m->GetMallet().y;
			z = disx * vx + disy * vy;	//式を短くするため

			px = pac.x, py = pac.y; //パックの座標を保持

			//パックとマレットの埋まり込みをなくす
			//pac.x -= vx * (z + sqrt(z * z - ConPacSpeed * ConPacSpeed * (disx * disx + disy * disy - (pac.r + m->GetMallet().r) * (pac.r + m->GetMallet().r)))) / (ConPacSpeed * ConPacSpeed);
			//pac.y -= vy * (z + sqrt(z * z - ConPacSpeed * ConPacSpeed * (disx * disx + disy * disy - (pac.r + m->GetMallet().r) * (pac.r + m->GetMallet().r)))) / (ConPacSpeed * ConPacSpeed);
			pac.center = Merikomi(pac, m->GetMallet(), ConPacVelocity);
			//ここで壁との埋まりこみを判定することで、マレットがパックを壁外に押し出すことを防ぐ
			if (!(pac.intersects(pgoal) || pac.intersects(egoal)))
			{
				if (!table.contains(pac))//pac.x < tl + pac.r || pac.x > ww - tl - pac.r || pac.y < tu + pac.r || pac.y > wh - tu - pac.r)
				{
					pac.x = px; pac.y = py;
					m->SetXY(m->GetPreXY().x, m->GetPreXY().y);
				}
			}

			cos = -disy / sqrt(disx * disx + disy * disy), sin = -disx / sqrt(disx * disx + disy * disy);
			//パックの跳ね返り
			PacVelocity.x = vx * (cos * cos - sin * sin) - vy * 2 * sin * cos + m->GetSpeed() * (m->GetKey()[Right] - m->GetKey()[Left]);
			PacVelocity.y = -vx * 2 * sin * cos - vy * (cos * cos - sin * sin) + m->GetSpeed() * (m->GetKey()[Down] - m->GetKey()[Up]);

			//跳ね返り係数をかける
			PacVelocity.x *= m->GetE();
			PacVelocity.y *= m->GetE();

			pacSpeedRestrict();
		}
		else
		{
			Vec2 PacV = PacVelocity / k;
			//すべてマレットに対するパックの相対的な値
			vx = PacV.x + m->GetSpeed() * (m->GetKey()[Left] - m->GetKey()[Right]), vy = PacV.y + m->GetSpeed() * (m->GetKey()[Up] - m->GetKey()[Down]);
			ConPacSpeed = sqrt(vx * vx + vy * vy);
			ConPacVelocity = { vx,vy };
			disx = pac.x - m->GetMallet().x, disy = pac.y - m->GetMallet().y;
			z = disx * vx + disy * vy;	//式を短くするため

			px = pac.x, py = pac.y; //パックの座標を保持

			//パックとマレットの埋まり込みをなくす
			//pac.x -= vx * (z + sqrt(z * z - ConPacSpeed * ConPacSpeed * (disx * disx + disy * disy - (pac.r + m->GetMallet().r) * (pac.r + m->GetMallet().r)))) / (ConPacSpeed * ConPacSpeed);
			//pac.y -= vy * (z + sqrt(z * z - ConPacSpeed * ConPacSpeed * (disx * disx + disy * disy - (pac.r + m->GetMallet().r) * (pac.r + m->GetMallet().r)))) / (ConPacSpeed * ConPacSpeed);
			pac.center = Merikomi(pac, m->GetMallet(), ConPacVelocity);
			//ここで壁との埋まりこみを判定することで、マレットがパックを壁外に押し出すことを防ぐ
			if (!(pac.intersects(pgoal) || pac.intersects(egoal)))
			{
				if (!table.contains(pac))//pac.x < tl + pac.r || pac.x > ww - tl - pac.r || pac.y < tu + pac.r || pac.y > wh - tu - pac.r)
				{
					pac.x = px; pac.y = py;
					m->SetXY(m->GetPreXY().x, m->GetPreXY().y);
				}
			}

			cos = -disy / sqrt(disx * disx + disy * disy), sin = -disx / sqrt(disx * disx + disy * disy);
			//パックの跳ね返り
			PacV.x = vx * (cos * cos - sin * sin) - vy * 2 * sin * cos + m->GetSpeed() * (m->GetKey()[Right] - m->GetKey()[Left]);
			PacV.y = -vx * 2 * sin * cos - vy * (cos * cos - sin * sin) + m->GetSpeed() * (m->GetKey()[Down] - m->GetKey()[Up]);

			//跳ね返り係数をかける
			PacV.x *= m->GetE();
			PacV.y *= m->GetE();

			pacSpeedRestrict();
		}
	}
}

bool Pac::intersects(Enemy* e)
{
	//if (PacVelocity != Vec2(0, 0))
	//{
		if (pac.intersects(e->GetMallet()))
		{
			e->CollidePac(PacVelocity, Edamage);
			//すべてマレットに対するパックの相対的な値
			vx = PacVelocity.x + e->GetSpeed() * (e->GetKey()[Left] - e->GetKey()[Right]), vy = PacVelocity.y + e->GetSpeed() * (e->GetKey()[Up] - e->GetKey()[Down]);
			ConPacSpeed = sqrt(vx * vx + vy * vy);
			disx = pac.x - e->GetMallet().x, disy = pac.y - e->GetMallet().y;
			z = disx * vx + disy * vy;	//式を短くするため

			px = pac.x, py = pac.y; //パックの座標を保持

			//パックとマレットの埋まり込みをなくす
			pac.x -= vx * (z + sqrt(z * z - ConPacSpeed * ConPacSpeed * (disx * disx + disy * disy - (pac.r + e->GetMallet().r) * (pac.r + e->GetMallet().r)))) / (ConPacSpeed * ConPacSpeed);
			pac.y -= vy * (z + sqrt(z * z - ConPacSpeed * ConPacSpeed * (disx * disx + disy * disy - (pac.r + e->GetMallet().r) * (pac.r + e->GetMallet().r)))) / (ConPacSpeed * ConPacSpeed);
			//ここで壁との埋まりこみを判定することで、マレットがパックを壁外に押し出すことを防ぐ
			if (pac.x < tl + pac.r || pac.x > ww - tl - pac.r || pac.y < tu + pac.r || pac.y > wh - tu - pac.r)
			{
				pac.x = px; pac.y = py;
				e->SetXY(e->GetPreXY().x, e->GetPreXY().y);
			}

			cos = -disy / sqrt(disx * disx + disy * disy), sin = -disx / sqrt(disx * disx + disy * disy);
			//パックの跳ね返り
			PacVelocity.x = vx * (cos * cos - sin * sin) - vy * 2 * sin * cos + e->GetSpeed() * (e->GetKey()[Right] - e->GetKey()[Left]);
			PacVelocity.y = -vx * 2 * sin * cos - vy * (cos * cos - sin * sin) + e->GetSpeed() * (e->GetKey()[Down] - e->GetKey()[Up]);

			//跳ね返り係数をかける
			PacVelocity.x *= e->GetE();
			PacVelocity.y *= e->GetE();

			pacSpeedRestrict();

			return true;
		}
		else {
			return false;
		}
	//}
	//else {
	//return false;
	//}
}


void Pac::reflect(double e)
{
	if (pac.x <= tl + pac.r && PacVelocity.x < 0)
	{
		pac.x = tl + pac.r;
		PacVelocity.x = -PacVelocity.x * e;
	}
	if (pac.x >= ww - tl - pac.r && PacVelocity.x > 0)
	{
		pac.x = ww - tl - pac.r;
		PacVelocity.x = -PacVelocity.x * e;
	}
	
	if (pac.y <= tu + pac.r && PacVelocity.y < 0)
	{
		if (!pac.intersects(egoal))//!(WindowWide / 2 - goalWide / 2 + Pr <= pac.x && WindowWide / 2 + goalWide / 2 - Pr >= pac.x))		//ゴールの条件
		{
			pac.y = tu + pac.r;
			PacVelocity.y = -PacVelocity.y * e;
		}
		else
		{
			/*ゴールのかどっこにあたたった時の処理
			* Pacの座標と速度ベクトルに加え、角っ子の座標を渡し、跳ね返る方向に速度を変える関数をここに入れる
			* もし、ゴールがパックを含む状態になったらプレイヤーのゴール
			* 得点加算関数を起動し、プレイヤー側の得点なのでタイプが変わる。
			* 得点加算関数はTypeChangeを使えるようにしたいので、タイプマネージャークラス内に定義する
			* もしくはTypeChangeメンバ関数自体を得点加算関数にするか
			*/
			//もしパックがゴールのかどにあたったら
			for (auto it = GorlSide.begin(); it != GorlSide.end();)
			{
				if (Distance(*it, pac.center) <= pac.r)
				{
					pac.center = Merikomi(pac, PacVelocity, *it);

					if (PacVelocity.x * PacVelocity.y > 0)
					{
						PacVelocity = Rotation(-PacVelocity, 2 * (InteriorAngle(PacVelocity, pac.center - *it)));
					}
					else
					{
						PacVelocity = Rotation(-PacVelocity, -2 * (InteriorAngle(PacVelocity, pac.center - *it)));
					}
				}
				it++;
			}
		}
		
	}
	if (pac.y >= wh - tu - pac.r && PacVelocity.y > 0)
	{
		if (!pac.intersects(pgoal))//!(WindowWide / 2 - goalWide / 2 + Pr <= pac.x && WindowWide / 2 + goalWide / 2 - Pr >= pac.x))		//ゴールの条件
		{
			pac.y = wh - tu - pac.r;
			PacVelocity.y = -PacVelocity.y * e;
		}
		else
		{
			//敵の得点
			//もしパックがゴールのかどにあたったら
			for (auto it = GorlSide.begin(); it != GorlSide.end();)
			{
				if (Distance(*it, pac.center) <= pac.r)
				{
					pac.center = Merikomi(pac, PacVelocity, *it);

					if (PacVelocity.x * PacVelocity.y > 0)
					{
						PacVelocity = Rotation(-PacVelocity, 2 * (InteriorAngle(PacVelocity, pac.center - *it)));
					}
					else
					{
						PacVelocity = Rotation(-PacVelocity, -2 * (InteriorAngle(PacVelocity, pac.center - *it)));
					}
				}
				it++;
			}
		}
	}
	

}

void Pac::RayPacmove(Vec2 start, double dir)
{
	double d = Abs(Sin(dir) * pac.x - Cos(dir) * pac.y + Cos(dir) * start.y - Sin(dir) * start.x);
	
	pac.moveBy(PacVelocity * Scene::DeltaTime() * ((k - 1) * d / pac.r + 1) / k);
	pacMoveType = false;
}

void Pac::Decelerate(double fl)
{
	if (PacVelocity.x != 0)
		PacVelocity.x -= PacVelocity.x * fl;
	if (PacVelocity.y != 0)
		PacVelocity.y -= PacVelocity.y * fl;
}

void Pac::Pacmove()
{
	if (pacMoveType)
	{
		pac.moveBy(PacVelocity * Scene::DeltaTime());
	}
	pacMoveType = true;
}


Circle Pac::GetPac()
{
	return pac;
}

Vec2 Pac::GetPacVelocity()
{
	return PacVelocity;
}

Vec2 Pac::GetPacXY()
{
	return pac.center;
}

