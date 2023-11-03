#include "stdafx.h"
#include "Type4.h"

Type4::Type4()
	:bullet1(0), ball1(0), type(0), TypeChange(true), FirstGene(true)
{
	Edamage = 0.13;
	bullet = { {{tableLeft, WindowHight - tableUpper},0} };

	ball1 = new Ball_1(2, 4);
	ball2 = new Ball_1(2, 4);
	ball3 = new Ball_1(2, 4);
	ball4 = new Ball_1(2, 4);

	bullet100 = new RainShot(90, 150, 50, 3.14 / 72);
	bullet200 = new RainShot(140, 150, 50, 3.14 / 72);
	b = bullet100->RemainderShotSet();
	bullet1 = new EneBullet_1(0, b[0]);
	bullet2 = new EneBullet_1(0, b[1]);
	bullet3 = new EneBullet_1(0, b[2]);
	b.clear();
	b = bullet200->RemainderShotSet();
	bullet4 = new EneBullet_1(0, b[0]);
	bullet5 = new EneBullet_1(0, b[1]);
	bullet6 = new EneBullet_1(0, b[2]);
	b.clear();
}

Type4::~Type4() {}

void Type4::Update(Pac* pac, Player* player, Enemy* enemy)
{
	if (player->GetRevivaled())		//プレイヤーが復活したとき,または点を入れられたとき弾をすべて消す
	{
		ball1->BallAllExtingish();
		ball2->BallAllExtingish();
		ball3->BallAllExtingish();
		ball4->BallAllExtingish();
		player->SetRevivaled(false);
		switch (type)
		{
		case 2:
			delete c_bullet1;
			delete c_bullet2;
			bullet = { {{tableLeft, WindowHight - tableUpper}, 0 } };
			c_bullet1 = new ChildBullet(0, bullet);
			bullet = { {{tableLeft,tableUpper},3.14 / 2} };
			c_bullet2 = new ChildBullet(0, bullet);
			c_bullet1->SetVelo(velo);
			c_bullet2->SetVelo(velo2);
			FirstGene = true;
			RorL = true;
			break;
		default:
			break;
		}

	}
	//初めに一回行う処理
	if (TypeChange)
	{
		switch (type)
		{
		case 0:
			bullet100->GeneBullet_1(0, bullet1, bullet2, bullet3);
			bullet200->GeneBullet_1(0, bullet4, bullet5, bullet6);
			break;
		case 1:
			TypeTimer = 0;
			delete bullet100;
			delete bullet200;
			bullet100 = new RainShot(70, 200, 150, 3.14 / 72);
			bullet200 = new RainShot(140, 200, 150, 3.14 / 72);
			bullet100->GeneBullet_1(0, bullet1, bullet2, bullet3);
			bullet200->GeneBullet_1(0, bullet4, bullet5, bullet6);
			FirstGene = true;
			break;
		case 2:
			//ball1->BallAllExtingish();
			//ball2->BallAllExtingish();
			TypeTimer2 = 0;
			
			delete ball1; delete ball2;
			ball1 = new Ball_1(5, 13);
			ball2 = new Ball_1(5, 13);
			
			delete bullet100;delete bullet200;
			bullet100 = new RainShot(200, 120, 90, 3.14*5 / 36);
			bullet200 = new RainShot(200, 120, 90, 3.14*5 / 36);
			delete bullet1; delete bullet2; delete bullet3;
			delete bullet4; delete bullet5; delete bullet6;
			b = bullet100->RemainderShotSet();
			bullet1 = new EneBullet_1(0, b[0]);
			bullet2 = new EneBullet_1(0, b[1]);
			bullet3 = new EneBullet_1(0, b[2]);
			b.clear();
			b = bullet200->RemainderShotSet();
			bullet4 = new EneBullet_1(0, b[0]);
			bullet5 = new EneBullet_1(0, b[1]);
			bullet6 = new EneBullet_1(0, b[2]);
			b.clear();
			bullet100->GeneBullet_1(0, bullet1, bullet2, bullet3);
			bullet200->GeneBullet_1(0, bullet4, bullet5, bullet6);

			bullet = { {{tableLeft, WindowHight - tableUpper}, 0 } };
			c_bullet1 = new ChildBullet(0, bullet);
			bullet = { {{tableLeft,tableUpper},3.14 / 2} };
			c_bullet2 = new ChildBullet(0, bullet);
			c_bullet1->SetVelo(velo);
			c_bullet2->SetVelo(velo2);
			FirstGene = true;
			break;
		default:
			break;
		}
		TypeChange = false;
	}
	//タイプがチェンジしていない時
	switch (type)
	{
	case 0:
		bullet100->RemainderShot(ball1, bullet1, bullet2, bullet3);
		bullet200->RemainderShot(ball2, bullet4, bullet5, bullet6);
		if (enemy->GetDua() < DuaInit * 2 / 3) {
			TypeChange = true; type++;
		}
		ball1->IntersectsPac(pac, 0.3);
		ball2->IntersectsPac(pac);
		break;
	case 1:
		if (FirstGene)
		{
			FirstGene = false;
		}
		else
		{
			TypeTimer += Scene::DeltaTime();
			if (TypeTimer < 25)
			{
				bullet100->Swing(6.28 / 3, 72, bullet1, bullet2, bullet3);
				bullet200->Swing(6.28 / 3, 72, bullet4, bullet5, bullet6);
			}
			else
			{
				if (TypeTimer >= 25 && TypeTimer <= 50)
				{
					bullet100->Swing(3.14 / 4, -72, bullet1, bullet2, bullet3);
					bullet200->Swing(3.14 / 4, -72, bullet4, bullet5, bullet6);
				}
				else
				{
					TypeTimer = 0;
				}
			}
			bullet100->RemainderShot(ball1, bullet1, bullet2, bullet3);
			bullet200->RemainderShot(ball2, bullet4, bullet5, bullet6);
		}
		if (enemy->GetDua() < DuaInit / 3) {
			TypeChange = true; type++;
		}
		ball1->IntersectsPac(pac, 0.3);
		ball2->IntersectsPac(pac);
		break;
	case 2:
		if (FirstGene)
		{
			TypeTimer = 0;
			
			c_bullet1->GeneBullet_1(1);	//最初生み出されるまで
			c_bullet2->GeneBullet_1(1);
			if(c_bullet1->TimerNotCount())
				FirstGene = false;
		}
		else
		{
			TypeTimer2 += Scene::DeltaTime();
			if(TypeTimer2>20)
			{
				
				bullet100->RemainderShot(ball3, bullet1, bullet2, bullet3);
				bullet200->RemainderShot(ball4, bullet4, bullet5, bullet6);
				if (TypeTimer2 > 30)
				{
					TypeTimer2 = 0;
				}
			}
			TypeTimer += Scene::DeltaTime();
			c_bullet1->ColumnShot(ball1, interval+30, BallSpeed *2 / 5);
			c_bullet2->ColumnShot(ball2, interval+30, BallSpeed *2 / 5);
			c_bullet1->Move_if(ball1);
			c_bullet2->Move_if(ball2);
			if (TypeTimer > GeneTime)
			{
				if (RorL)
				{
					bullet = { {{WindowWide - tableLeft, WindowHight - tableUpper}, 3.14 } };
					c_bullet1->SetBullet(bullet,velo);
					bullet = { {{tableLeft,WindowHight - tableUpper},-3.14 / 2} };
					c_bullet2->SetBullet(bullet, velo2);
				}
				else
				{
					bullet= { {{tableLeft, WindowHight - tableUpper}, 0 } };
					c_bullet1->SetBullet(bullet,velo);
					bullet = { {{tableLeft,tableUpper},3.14 / 2} };
					c_bullet2->SetBullet(bullet, velo2);
				}
				RorL = !RorL;
				TypeTimer = 0;
			}
		}
		ball3->BallMove();
		ball4->BallMove();
		ball3->IntersectsPac(pac, 0.4);
		ball4->IntersectsPac(pac);
		ball3->RemoveOutBall(table);
		ball4->RemoveOutBall(table);
		break;
	default:
		break;
	}
	ball1->BallMove();
	ball2->BallMove();
	
	ball1->RemoveOutBall(table);
	ball2->RemoveOutBall(table);
	if (ball1->IntersectsPlayer(player) || ball2->IntersectsPlayer(player) || ball3->IntersectsPlayer(player)|| ball4->IntersectsPlayer(player))
	{
		ball2->BallAllExtingish();
		ball1->BallAllExtingish();
		ball3->BallAllExtingish();
		ball4->BallAllExtingish();
		switch (type)
		{
		case 2:
			delete c_bullet1;
			delete c_bullet2;
			bullet = { {{tableLeft, WindowHight - tableUpper}, 0 } };
			c_bullet1 = new ChildBullet(0, bullet);
			bullet = { {{tableLeft,tableUpper},3.14 / 2} };
			c_bullet2 = new ChildBullet(0, bullet);
			c_bullet1->SetVelo(velo);
			c_bullet2->SetVelo(velo2);
			FirstGene = true;
			RorL = true;
			break;
		default:
			break;
		}
	}
}

void Type4::Draw()
{
	//drawで使うものはコンストラクタの中で生成しなきゃいけないみたい
	
	switch (type)
	{
	case 0:
		ball1->Draw(Palette::Dodgerblue);
		ball2->Draw(Palette::Lightgray);
		break;
	case 1:
		ball1->Draw(Palette::Dodgerblue);
		ball2->Draw(Palette::Lightgray);
		break;
	case 2:
		ball1->Ball_1_draw();
		ball2->Ball_1_draw();
		ball3->Draw(Palette::Dodgerblue);
		ball4->Draw(Palette::Lightgray);
		break;
	default:
		break;
	}
}
