#include "stdafx.h"
#include "Type3.h"

Type3::Type3()
	:bullet1(0), ball1(0), type(0), TypeChange(true), FirstGene(true)
{
	Edamage = 0.14;
	for (auto i : step(5))
	{
		bullets b{ {WindowWide / 2, tableUpper + tableHight / 3}, 6.28 * i / 5 };
		bullet << b;
	}
	bullet1 = new EneBullet_1(bullet_R, bullet);
	bullet.clear();
	for (auto i : step(5))
	{
		bullets b{ {WindowWide / 2 + 50 , tableUpper + tableHight / 3}, 6.28 * i / 5 };
		bullet << b;
	}
	bullet2 = new EneBullet_1(bullet_R, bullet);
	bullet.clear();
	for (auto i : step(5))
	{
		bullets b{ {WindowWide / 2 - 50 , tableUpper + tableHight / 3}, 6.28 * i / 5 };
		bullet << b;
	}
	bullet3 = new EneBullet_1(bullet_R, bullet);
	bullet.clear();
	for (auto i : step(5))
	{
		bullets b{ {WindowWide / 2 + 125 , tableUpper + tableHight / 3}, 6.28 * i / 5 };
		bullet << b;
	}
	bullet4 = new EneBullet_1(bullet_R, bullet);
	bullet.clear();
	for (auto i : step(5))
	{
		bullets b{ {WindowWide / 2 - 125 , tableUpper + tableHight / 3}, 6.28 * i / 5 };
		bullet << b;
	}
	bullet5 = new EneBullet_1(bullet_R, bullet);
	bullet.clear();
	for (auto i : step(5))
	{
		bullets b{ {WindowWide / 2, tableUpper + tableHight / 3+225}, 6.28 * i / 5 };
		bullet << b;
	}
	bullet6 = new EneBullet_1(bullet_R, bullet);
	bullet.clear();
	for (auto i : step(5))
	{
		bullets b{ {WindowWide / 2 , tableUpper + tableHight / 3-225}, 6.28 * i / 5 };
		bullet << b;
	}
	bullet7 = new EneBullet_1(bullet_R, bullet);
	bullet.clear();

	ball1 = new Ball_1(ball_r, ball_R * 1.5);
	ball2 = new Ball_1(ball_r, ball_R);
}

Type3::~Type3()
{

}

void Type3::Update(Pac* pac, Player* player, Enemy* enemy)
{
	if (player->GetRevivaled())		//プレイヤーが復活したとき,または点を入れられたとき弾をすべて消す
	{
		ball1->BallAllExtingish();
		ball2->BallAllExtingish();
		player->SetRevivaled(false);
	}

	//初めに一回行う処理
	if (TypeChange)
	{
		switch (type)
		{
		case 0:
			bullet2->SetVelo(CircleVelo);
			bullet3->SetVelo(-CircleVelo);
			bullet2->SetShotTimer(Random(2.0));
			bullet3->SetShotTimer(Random(2.0));
			break;
		case 1:
			ball1->BallAllExtingish();
			bullet4->SetVelo(CircleVelo * 3 / 4);
			bullet5->SetVelo(-CircleVelo * 3 / 4);
			bullet4->SetShotTimer(Random(2.0));
			bullet5->SetShotTimer(Random(2.0));
			break;
		case 2:
			ball1->BallAllExtingish();
			CircleVelo = { 150,0 };
			bullet6->SetVelo(-CircleVelo * 3 / 4);
			bullet7->SetVelo(CircleVelo * 3 / 4);
			CircleVelo = { 0,150 };
			bullet6->SetShotTimer(Random(2.0));
			bullet7->SetShotTimer(Random(2.0));
			break;
		case 3:
			ball1->BallAllExtingish();
			delete bullet1; delete bullet2; delete bullet3; //delete bullet4; delete bullet5; delete bullet6;
			for (auto i : step(8))
			{
				bullets b{ {WindowWide / 2, tableUpper + tableHight / 3}, 6.28 * i / 8 };
				bullet << b;
			}
			bullet1 = new EneBullet_1(bullet_R, bullet);
			bullet.clear();
			for (auto i : step(1))
			{
				bullets b{ {WindowWide / 2 + 75 , tableUpper + tableHight / 3}, 0 };
				bullet << b;
			}
			bullet2 = new EneBullet_1(bullet_R, bullet);
			bullet.clear();
			for (auto i : step(1))
			{
				bullets b{ {WindowWide / 2 - 75 , tableUpper + tableHight / 3}, 0 };
				bullet << b;
			}
			bullet3 = new EneBullet_1(bullet_R, bullet);
			bullet.clear();
			bullet2->SetVelo(CircleVelo*1.5);
			bullet3->SetVelo(-CircleVelo*1.5);
			break;
		case 4:
			for (auto i : step(1))
			{
				bullets b{ {WindowWide / 2 + 125 , tableUpper + tableHight / 3}, 6.28 * i / 5 };
				bullet << b;
			}
			bullet4 = new EneBullet_1(bullet_R, bullet);
			bullet.clear();
			for (auto i : step(1))
			{
				bullets b{ {WindowWide / 2 - 125 , tableUpper + tableHight / 3}, 6.28 * i / 5 };
				bullet << b;
			}
			bullet5 = new EneBullet_1(bullet_R, bullet);
			bullet.clear();
			bullet4->SetVelo(-CircleVelo * 3 / 4);
			bullet5->SetVelo(CircleVelo * 3 / 4);
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
		bullet1->GeneBullet_1(1);
		bullet2->GeneBullet_1(1);
		bullet3->GeneBullet_1(1);
		if (enemy->GetDua() < DuaInit * 4 / 5) {
			TypeChange = true; type++;
		}
		bullet1->Shotball(ball1, BallSpeed / 4, 2, 0.2, 0.8);
		bullet2->Shotball(ball1, BallSpeed / 4, Random(2.0,3.0), 0.2, 0.8);
		bullet3->Shotball(ball1, BallSpeed / 4, Random(2.0,3.0), 0.2, 0.8);
		ball1->BallFall(player->GetMallet().center);
		ball1->BallMoveMax(BallSpeed/3);
		bullet1->SwingNeck_360(3);
		bullet2->SwingNeck_360(3);
		bullet3->SwingNeck_360(3);
		bullet2->MoveCircle(bullet1->Getenebullet()[0].pos, Distance(bullet2->Getenebullet()[0].pos, bullet1->Getenebullet()[0].pos));
		bullet3->MoveCircle(bullet1->Getenebullet()[0].pos, Distance(bullet3->Getenebullet()[0].pos, bullet1->Getenebullet()[0].pos));
		break;
	case 1:
		bullet4->GeneBullet_1(0);
		bullet5->GeneBullet_1(0);
		if (enemy->GetDua() < DuaInit * 3 / 5) {
			TypeChange = true; type++;
		}
		bullet1->Shotball(ball1, BallSpeed / 4, 2, 0.2, 0.8);
		bullet2->Shotball(ball1, BallSpeed / 4, Random(2.0, 3.0), 0.2, 0.8);
		bullet3->Shotball(ball1, BallSpeed / 4, Random(2.0, 3.0), 0.2, 0.8);
		bullet4->Shotball(ball1, BallSpeed / 4, Random(3.0, 4.0), 0.2, 0.8);
		bullet5->Shotball(ball1, BallSpeed / 4, Random(3.0, 4.0), 0.2, 0.8);
		ball1->BallFall(player->GetMallet().center);
		ball1->BallMoveMax(BallSpeed / 3);
		bullet1->SwingNeck_360(3);
		bullet2->SwingNeck_360(3);
		bullet3->SwingNeck_360(3);
		bullet4->SwingNeck_360(4);
		bullet5->SwingNeck_360(4);
		bullet2->MoveCircle(bullet1->Getenebullet()[0].pos, Distance(bullet2->Getenebullet()[0].pos, bullet1->Getenebullet()[0].pos));
		bullet3->MoveCircle(bullet1->Getenebullet()[0].pos, Distance(bullet3->Getenebullet()[0].pos, bullet1->Getenebullet()[0].pos));
		bullet4->MoveCircle(bullet1->Getenebullet()[0].pos, Distance(bullet4->Getenebullet()[0].pos, bullet1->Getenebullet()[0].pos));
		bullet5->MoveCircle(bullet1->Getenebullet()[0].pos, Distance(bullet5->Getenebullet()[0].pos, bullet1->Getenebullet()[0].pos));
		break;
	case 2:
		bullet6->GeneBullet_1(0);
		bullet7->GeneBullet_1(0);
		if (enemy->GetDua() < DuaInit * 2 / 5) {
			TypeChange = true; type++;
		}
		bullet1->Shotball(ball1, BallSpeed / 4, 2, 0.2, 0.8);
		bullet2->Shotball(ball1, BallSpeed / 4, Random(2.0, 3.0), 0.2, 0.8);
		bullet3->Shotball(ball1, BallSpeed / 4, Random(2.0, 3.0), 0.2, 0.8);
		bullet4->Shotball(ball1, BallSpeed / 4, Random(3.0, 4.0), 0.2, 0.8);
		bullet5->Shotball(ball1, BallSpeed / 4, Random(3.0, 4.0), 0.2, 0.8);
		bullet6->Shotball(ball1, BallSpeed / 4, Random(3.0, 4.0), 0.2, 0.8);
		bullet7->Shotball(ball1, BallSpeed / 4, Random(3.0, 4.0), 0.2, 0.8);
		ball1->BallFall(player->GetMallet().center);
		ball1->BallMoveMax(BallSpeed / 3);
		bullet1->SwingNeck_360(3);
		bullet2->SwingNeck_360(3);
		bullet3->SwingNeck_360(3);
		bullet4->SwingNeck_360(4);
		bullet5->SwingNeck_360(4);
		bullet6->SwingNeck_360(4);
		bullet7->SwingNeck_360(4);
		bullet2->MoveCircle(bullet1->Getenebullet()[0].pos, Distance(bullet2->Getenebullet()[0].pos, bullet1->Getenebullet()[0].pos));
		bullet3->MoveCircle(bullet1->Getenebullet()[0].pos, Distance(bullet3->Getenebullet()[0].pos, bullet1->Getenebullet()[0].pos));
		bullet4->MoveCircle(bullet1->Getenebullet()[0].pos, Distance(bullet4->Getenebullet()[0].pos, bullet1->Getenebullet()[0].pos));
		bullet5->MoveCircle(bullet1->Getenebullet()[0].pos, Distance(bullet5->Getenebullet()[0].pos, bullet1->Getenebullet()[0].pos));
		bullet6->MoveCircle(bullet1->Getenebullet()[0].pos, Distance(bullet6->Getenebullet()[0].pos, bullet1->Getenebullet()[0].pos));
		bullet7->MoveCircle(bullet1->Getenebullet()[0].pos, Distance(bullet7->Getenebullet()[0].pos, bullet1->Getenebullet()[0].pos));
		break;
	case 3:
		bullet1->GeneBullet_1(0.5);
		bullet2->GeneBullet_1(0.5);
		bullet3->GeneBullet_1(0.5);
		if (enemy->GetDua() < DuaInit/5) {
			TypeChange = true; type++;
		}
		bullet1->Shotball(ball1, BallSpeed / 3, Random(0.5,1.0), 0.25);
		bullet1->SwingNeck_360(5);
		ball1->BallFall_if(bullet2->Getenebullet()[0].pos, 0.1, bullet1->Getenebullet()[0].pos, Distance(bullet1->Getenebullet()[0].pos, bullet2->Getenebullet()[0].pos)*1.2);
		ball1->BallFall_if(bullet3->Getenebullet()[0].pos, 0.1, bullet1->Getenebullet()[0].pos, Distance(bullet1->Getenebullet()[0].pos, bullet2->Getenebullet()[0].pos)*1.2);
		ball1->BallMoveMax(BallSpeed*4/5);
		ball1->BallDecelerate_if(bullet1->Getenebullet()[0].pos, Distance(bullet1->Getenebullet()[0].pos, bullet2->Getenebullet()[0].pos));
		bullet2->MoveCircle(bullet1->Getenebullet()[0].pos, Distance(bullet2->Getenebullet()[0].pos, bullet1->Getenebullet()[0].pos));
		bullet3->MoveCircle(bullet1->Getenebullet()[0].pos, Distance(bullet2->Getenebullet()[0].pos, bullet1->Getenebullet()[0].pos));
		break;
	case 4:
		bullet4->GeneBullet_1(0.5);
		bullet5->GeneBullet_1(0.5);
		bullet1->Shotball(ball1, BallSpeed / 3, Random(0.5, 1.0), 0.25);
		bullet1->SwingNeck_360(5);
		bullet4->AimShot(player, ball2, BallSpeed * 1.5, 0, 0.7);
		bullet5->AimShot(player, ball2, BallSpeed * 1.5, 0, 0.7);
		ball1->BallFall_if(bullet2->Getenebullet()[0].pos, 0.1, bullet1->Getenebullet()[0].pos, Distance(bullet1->Getenebullet()[0].pos, bullet2->Getenebullet()[0].pos) * 1.2);
		ball1->BallFall_if(bullet3->Getenebullet()[0].pos, 0.1, bullet1->Getenebullet()[0].pos, Distance(bullet1->Getenebullet()[0].pos, bullet2->Getenebullet()[0].pos) * 1.2);
		ball1->BallMoveMax(BallSpeed * 4 / 5);
		ball2->BallMove();
		ball1->BallDecelerate_if(bullet1->Getenebullet()[0].pos, Distance(bullet1->Getenebullet()[0].pos, bullet2->Getenebullet()[0].pos));
		bullet2->MoveCircle(bullet1->Getenebullet()[0].pos, Distance(bullet2->Getenebullet()[0].pos, bullet1->Getenebullet()[0].pos));
		bullet3->MoveCircle(bullet1->Getenebullet()[0].pos, Distance(bullet2->Getenebullet()[0].pos, bullet1->Getenebullet()[0].pos));
		bullet4->MoveCircle(bullet1->Getenebullet()[0].pos, Distance(bullet4->Getenebullet()[0].pos, bullet1->Getenebullet()[0].pos));
		bullet5->MoveCircle(bullet1->Getenebullet()[0].pos, Distance(bullet5->Getenebullet()[0].pos, bullet1->Getenebullet()[0].pos));
		break;
	default:
		break;
	}
	ball1->IntersectsPac(pac);
	ball2->IntersectsPac(pac);
	ball1->RemoveOutBall(table);
	ball2->RemoveOutBall(table);
	if (ball1->IntersectsPlayer(player) || ball2->IntersectsPlayer(player))
	{
		ball1->BallAllExtingish(); ball2->BallAllExtingish();
	}
	ball1->BallDecrease();
}

void Type3::Draw()
{
	ball1->Ball_1_draw();
	ball2->Ball_1_draw();
	switch (type)
	{
	case 0:
		bullet1->bulletDraw();
		bullet2->bulletDraw();
		bullet3->bulletDraw();
		break;
	case 1:
		bullet1->bulletDraw();
		bullet2->bulletDraw();
		bullet3->bulletDraw();
		bullet4->bulletDraw();
		bullet5->bulletDraw();
		break;
	case 2:
		bullet1->bulletDraw();
		bullet2->bulletDraw();
		bullet3->bulletDraw();
		bullet4->bulletDraw();
		bullet5->bulletDraw();
		bullet6->bulletDraw();
		bullet7->bulletDraw();
		break;
	case 3:
		bullet1->bulletDraw();
		bullet2->bulletDraw();
		bullet3->bulletDraw();
		break;
	case 4:
		bullet1->bulletDraw();
		bullet2->bulletDraw();
		bullet3->bulletDraw();
		bullet4->bulletDraw();
		bullet5->bulletDraw();
		break;
	default:
		break;
	}
}
