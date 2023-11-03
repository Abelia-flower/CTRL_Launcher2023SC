#include "stdafx.h"
#include "Type1.h"

Type1::Type1()
	:bullet1(0), ball1(0), type(0), TypeChange(true),FirstGene(true)
{
	bullet = { {{tableLeft, tableUpper + tableHight / 6},3.14 / 3},{{ WindowWide - tableLeft,tableUpper + tableHight / 6 },3.14 * 2 / 3} };

	bullet1 = new EneBullet_1(bullet_R,bullet);
	bullet2 = new EneBullet_1(bullet_R, bullet);
	bullet3 = new EneBullet_1(bullet_R, bullet);

	Edamage = 0.22;

	ball1 = new Ball_1(ball_r, ball_R);
}

Type1::~Type1() {}

void Type1::Update(Pac* pac, Player* player, Enemy* enemy)
{
	if (player->GetRevivaled())		//プレイヤーが復活したとき,または点を入れられたとき弾をすべて消す
	{
		ball1->BallAllExtingish();
		player->SetRevivaled(false);
	}

	//初めに一回行う処理
	if (TypeChange)
	{
		
		switch (type)
		{
		case 0:
			break;
		case 1:
			ball1->BallAllExtingish();
			delete bullet1;
			delete bullet2;
			bullet1 = new EneBullet_1(bullet_R, bullet);
			bullet2 = new EneBullet_1(bullet_R, bullet);
			FirstGene = true;
			break;
		case 2:
			ball1->BallAllExtingish();
			delete bullet1;
			delete bullet2;
			bullet1 = new EneBullet_1(bullet_R, bullet);
			bullet2 = new EneBullet_1(bullet_R, bullet);
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
		bullet1->GeneBullet_1(2);
		bullet2->GeneBullet_1(2);
		if (enemy->GetDua() < DuaInit * 2 / 3) {
			TypeChange = true; type++;
		}
		bullet1->AimShot(player, ball1, 150, 0, 1);
		bullet2->Shotball(ball1, BallSpeed, 2,0.2,0.8);
		bullet2->SwingingSIN(3.14 / 3,0,8,jiku);
		ball1->BallMove();
		bullet1->IntersectsPac(pac);
		bullet2->IntersectsPac(pac);
		break;
	case 1:
		if (FirstGene)
		{
			bullet1->GeneBullet_1(0.5);	//最初生み出されるまで
			bullet2->GeneBullet_1(0.5);
			if (bullet1->TimerNotCount() && bullet2->TimerNotCount())
				FirstGene = false;
		}
		else
		{
			bullet1->GeneBullet_1(4);
			bullet2->GeneBullet_1(4);
		}
		if (enemy->GetDua() < DuaInit / 3) {
			TypeChange = true; type++;
		}
		bullet1->Shotball(ball1, BallSpeed / 2, 1,0.2,0.8);
		bullet2->Shotball(ball1, BallSpeed / 2, 1, bullet1->GeteneDir(),3.14/12,0.2,0.8);
		bullet1->SwingingSIN(3.14 / 5, 0, 5, jiku);
		ball1->BallMove();
		bullet1->IntersectsPac(pac);
		bullet2->IntersectsPac(pac);
		break;
	case 2:
		if (FirstGene)
		{
			bullet1->GeneBullet_1(0.5);	//最初生み出されるまで
			bullet2->GeneBullet_1(0.5);
			bullet3->GeneBullet_1(0.5);
			if (bullet1->TimerNotCount() && bullet2->TimerNotCount() && bullet3->TimerNotCount())
				FirstGene = false;
		}
		else
		{
			bullet1->GeneBullet_1(4);
			bullet2->GeneBullet_1(4);
			bullet3->GeneBullet_1(4);
		}
		bullet1->Shotball(ball1, BallSpeed,1,BallSpeed/8,BallSpeed/4);
		bullet2->Shotball(ball1, BallSpeed, 1, bullet1->GeteneDir() , 3.14 / 12, BallSpeed / 8, BallSpeed/4);
		bullet3->Shotball(ball1, BallSpeed, 1, bullet1->GeteneDir() , -3.14 / 12, BallSpeed / 8, BallSpeed/4);
		//bullet1->SetDir()
		ball1->BallMove();
		ball1->BallDecelerate();
		bullet1->SwingingSIN(3.14 / 3, 0, 4, jiku);
		bullet1->IntersectsPac(pac);
		bullet2->IntersectsPac(pac);
		bullet3->IntersectsPac(pac);
		break;
	default:
		break;
	}
	ball1->IntersectsPac(pac);
	ball1->RemoveOutBall(table);
	if (ball1->IntersectsPlayer(player))
	{
		ball1->BallAllExtingishWithoutRay();
	}
	ball1->BallDecrease();
}

void Type1::Draw()
{
	ball1->Ball_1_draw();
	bullet1->bulletDraw();
}
