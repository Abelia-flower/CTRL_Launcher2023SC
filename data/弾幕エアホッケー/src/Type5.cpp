#include "stdafx.h"
#include "Type5.h"

Type5::Type5() :FirstGene(true), TypeChange(true)
{
	
	Edamage = 0.16;
	bullet = { {{tableLeft + tableWide / 2,tableUpper + tableHight * 2/ 5},3.14 / 2}};
	ball1 = new Ball_1(2, 4);
	ball2 = new Ball_1(2, 4);
	ball3 = new Ball_1(4, 7);
	ball4 = new Ball_1(2, 4);
	ball5 = new Ball_1(2, 5);
	ball6 = new Ball_1(2, 4);
	ball7 = new Ball_1(2, 4);

	NeutronStar = new EneBullet_1(17, bullet);

	bullet = { {{WindowWide / 2 + 100, tableUpper + tableHight / 5} ,0},{{WindowWide / 2 - 100, tableUpper + tableHight / 5},0} };
	jikinerai = new EneBullet_1(10, bullet);

	bullet = { {{WindowWide / 2, tableUpper + tableHight / 5} ,jikuDir[0]},{{WindowWide / 2, tableUpper + tableHight / 5} ,jikuDir[1]} };
	michi = new EneBullet_1(17, bullet);

	bullet = { {{0,0},0} };
	uzu = new ChildBullet(0, bullet);
	
	hunsui_t3 = new EneBullet_1(3, bullet);

	hanabi = new Hanabi(3, bullet);

	nokogiri_down = new ChildBullet(0, bullet);
	nokogiri_down->RemoveEneBullet_1();
	nokogiri_mid = new ChildBullet(0, bullet);
	nokogiri_mid->RemoveEneBullet_1();
	nokogiri_upper = new ChildBullet(0, bullet);
	nokogiri_upper->RemoveEneBullet_1();

	RectLaser = new EneBullet_1(0, bullet);

	wipe = new EneBullet_1(0, bullet);

	bullet.clear();
	for (int32 i = 0; hunsuiinterval * (i + 1) < tableWide; i++)
	{
		bullet << bullets({ tableLeft+hunsuiinterval * (i + 1), WindowHight - tableUpper }, 3.14 * 3 / 2);
	}
	hunsui = new ChildBullet(0, bullet);

	bullet.clear();
	for (int32 i = 0; tableWide / 4 + ziguzaguinterval * (2 * i - 1) / 2 <= tableWide * 3 / 4 + ziguzaguinterval / 2; i++)
	{
		bullet << bullets({ tableLeft + tableWide / 4 + ziguzaguinterval * (2 * i - 1) / 2, tableUpper }, 3.14 / 2);
	}
	Ueziguzagu = new ChildBullet(0, bullet);
	bullet.clear();
	for (int32 i = 0; tableWide / 2 + ziguzaguinterval * (i - 1) <= tableWide / 2 + ziguzaguinterval; i++)
	{
		bullet << bullets({ tableLeft + tableWide / 2 + ziguzaguinterval * (i - 1) ,WindowHight - tableUpper }, 3.14 * 3 / 2);
	}
	Shitaziguzagu = new ChildBullet(0, bullet);
	bullet.clear();

	wipeTime = 6.5;
	intervalTime = 2;
}

Type5::~Type5(){}

void Type5::Update(Pac* pac, Player* player, Enemy* enemy)
{
	//プレイヤー修復中の処理
	if (player->GetBreak())			
	{
		switch (type)
		{
		case 0:
			break;
		case 1:
			break;
		case 2:
			ball1->RayAllExtingish();
			break;
		case 3:
			if (taikyuuTime <= 120)
			{
				if(pac->GetPacXY().y<=130+tableUpper)
					pac->SetVelocity(150 * Vec2(Cos(CalDir(pac->GetPacXY(), Vec2(WindowWide / 2, WindowHight - tableUpper))), Sin(CalDir(pac->GetPacXY(), Vec2(WindowWide / 2, WindowHight - tableUpper)))));
			}
			else
			{
				ball4->BallAllExtingish();
			}
			break;
		default:
			break;
		}
	}

	if (player->GetRevivaled())		//プレイヤーが復活したとき,または点を入れられたとき弾をすべて消す
	{
		ball6->BallAllExtingish();
		ball7->RayAllExtingish();
		ball1->BallAllExtingish();
		ball2->BallAllExtingish();
		ball3->BallAllExtingish();
		ball4->BallAllExtingish();
	
		player->SetRevivaled(false);
		switch (type)
		{
		case 0:
			delete NeutronStar;
			bullet = { {{tableLeft + tableWide / 2,tableUpper + tableHight * 2 / 5},3.14 / 2} };
			NeutronStar = new EneBullet_1(17, bullet);
			break;
		case 1:
			delete NeutronStar;
			bullet = { {{tableLeft + tableWide / 2,tableUpper + tableHight * 2 / 5},3.14 / 2} };
			NeutronStar = new EneBullet_1(17, bullet);
			break;
		case 2:
			delete Ueziguzagu;
			delete Shitaziguzagu;
			delete hunsui;
			delete wipe;
			bullet.clear();
			bullet << bullets{ {0,0},0 };
			wipe = new EneBullet_1(0, bullet);
			bullet.clear();
			for (int32 i = 0; hunsuiinterval * (i + 1) < tableWide; i++)
			{
				bullet << bullets({ tableLeft + hunsuiinterval * (i + 1), WindowHight - tableUpper }, 3.14 * 3 / 2);
			}
			hunsui = new ChildBullet(0, bullet);

			bullet.clear();
			for (int32 i = 0; tableWide / 4 + ziguzaguinterval * (2 * i - 1) / 2 <= tableWide * 3 / 4 + ziguzaguinterval / 2; i++)
			{
				bullet << bullets({ tableLeft + tableWide / 4 + ziguzaguinterval * (2 * i - 1) / 2, tableUpper }, 3.14 / 2);
			}
			Ueziguzagu = new ChildBullet(0, bullet);
			bullet.clear();
			for (int32 i = 0; tableWide / 2 + ziguzaguinterval * (i - 1) <= tableWide / 2 + ziguzaguinterval; i++)
			{
				bullet << bullets({ tableLeft + tableWide / 2 + ziguzaguinterval * (i - 1) ,WindowHight - tableUpper }, 3.14 * 3 / 2);
			}
			Shitaziguzagu = new ChildBullet(0, bullet);
			bullet.clear();
			break;
		case 3:
			ball5->BallAllExtingishWithoutRay();
			if (taikyuuTime >= 8 && taikyuuTime < 43)
				i = 0;
			FirstGene = true;
			break;
		default:
			break;
		}
		FirstGene = true;
	}
	//初めに一回行う処理
	if (TypeChange)
	{
		switch (type)
		{
		case 0:

			break;
		case 1:
			ball7->BallAllExtingish();
			ball6->BallAllExtingish();
			delete NeutronStar;

			bullet = { {{tableLeft + tableWide / 2,tableUpper + tableHight * 2 / 5},3.14 / 2} };
			NeutronStar = new EneBullet_1(17, bullet);
			FirstGene = true;
			break;
		case 2:
			Edamage = 0.017;
			ball1->BallAllExtingish();
			ball2->BallAllExtingish();
			ball3->BallAllExtingish();
			ball4->BallAllExtingish();
			FirstGene = true;
			break;
		case 3:
			Edamage = 0.12;
			ball1->BallAllExtingish();
			ball2->BallAllExtingish();
			ball3->BallAllExtingish();
			ball4->BallAllExtingish();
			taikyuuTime = 0;
			nokogiri_down->ColumnSetX(nokointerval, tableLeft+20, WindowHight - tableUpper, 3.14 * 3 / 2);
			nokogiri_upper->ColumnSetX(nokointerval, tableLeft+ 20, tableUpper + tableHight * 2 / 3, 3.14 * 3 / 2);
			nokogiri_mid->ColumnSetX(nokointerval, tableLeft+ 20, tableUpper + tableHight * 5 / 6, 3.14 * 3 / 2);
			intervalTime = 0;
			hunsui_t3->Setenebullets(hunsui_t3->SetKabeHaritsuki(Vec2(WindowWide / 2, WindowHight / 2), 5, CalDir(Vec2(WindowWide / 2, WindowHight / 2), Vec2(tableLeft, WindowHight - tableUpper)) - CalDir(Vec2(WindowWide / 2, WindowHight / 2), Vec2(WindowWide - tableLeft, WindowHight - tableUpper)) - 0.25, 3.14 / 2), 3.14 * 3 / 2, 0, 0, Vec2(0, 0));

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
		//shot
		if (FirstGene)
		{
			NeutronStar->GeneBullet_1(1);
			if (NeutronStar->TimerNotCount())
				FirstGene = false;
		}
		else
		{
			NeutronStar->NeutronStarRay(ball7, hutosa, Palette::Skyblue, pac);
			uzu->uzukaiten(ball6, 3.14 / 17, 1.7, 110, Vec2(tableLeft + tableWide / 2, tableUpper + tableHight * 2 / 5), 12, &BaseDir);
			if (enemy->GetDua() < DuaInit * 4 / 5) {
				TypeChange = true; type++;
			}
			NeutronStar->SwingingSIN(3.14 / 8, 0, t, jiku);
			//intersects
			ball7->RayIntersectsPlayer(player);
			ball6->IntersectsPac(pac);
			ball6->BallDecelerate();
			ball6->BallMove(50);
			ball6->BallRemove_if(Vec2(tableLeft + tableWide / 2, tableUpper + tableHight * 2 / 5), 17);
		}
		break;
	case 1:
		if (FirstGene)
		{
			NeutronStar->GeneBullet_1(1);
			if (NeutronStar->TimerNotCount())
				FirstGene = false;
		}
		else
		{
			NeutronStar->NeutronStarRay(ball7, hutosa, Palette::Skyblue, pac);
			uzu->uzukaiten(ball6, 3.14 / 10, 0.9, 140, Vec2(tableLeft + tableWide / 2, tableUpper + tableHight * 2 / 5), 12, &BaseDir);
			if (enemy->GetDua() < DuaInit * 3 / 5) {
				TypeChange = true; type++;
			}
			NeutronStar->SwingingSIN(3.14 / 8, 0, t, jiku);
			//intersects
			ball7->RayIntersectsPlayer(player);
			ball6->IntersectsPac(pac);
			ball6->BallDecelerate();
			ball6->BallMove(60);
			ball6->BallRemove_if(Vec2(tableLeft + tableWide / 2, tableUpper + tableHight * 2 / 5), 17);
			
			NeutronStar->absor(player, Vec2(tableLeft + tableWide / 2, tableUpper + tableHight * 2 / 5),50, enemy->GetBreak());
		}
		break;
	case 2:
		if (FirstGene)
		{
			hunsui->GeneBullet_1(0.5);
			Ueziguzagu->GeneBullet_1(0.5);
			Shitaziguzagu->GeneBullet_1(0.5);
			wipe->GeneBullet_1(0.5);
			if(hunsui->TimerNotCount())
				FirstGene = false;
		}
		else
		{
			if (enemy->GetDua() < DuaInit * 2 / 5)
			{
				TypeChange = true; type++;
			}

			Ueziguzagu->NobiShotRay(ball2, tableHight / 2 + 90, 5, Palette::Lightcyan, 12);
			Shitaziguzagu->NobiShotRay(ball3, tableHight / 2 - 60, 6, Palette::Deepskyblue, 12);
			hunsui->NobiShotRay(ball1, 150, 30, Palette::Blue, hutosa);
			if (wipe->T5Wipe(ball4, wipeTime, intervalTime))
			{
				if (wipeTime > 4.5)
				{
					wipeTime -= 0.5;
				}
				if (wipeTime > 4)
				{
					wipeTime -= 0.2;
				}
				if (intervalTime > 0.3)
				{
					intervalTime -= 0.6;
				}
			}
			ball1->IntersectsHunsui(pac, Scene::DeltaTime()*1000);
			ball2->IntersectsifUe(pac, Scene::DeltaTime() * 500);
			ball3->IntersectsJun(pac, Scene::DeltaTime() * 100);
			ball1->RayIntersectsPlayer(player);
			ball2->RayIntersectsPlayer(player);
			ball3->RayIntersectsPlayer(player);
			ball4->RayIntersectsPlayer(player);
				
		}
		break;
	case 3:
		if (taikyuuTime < 3)
		{
			if (FirstGene)
			{
				nokogiri_down->GeneBullet_1(0.5);
				nokogiri_mid->GeneBullet_1(0.5);
				nokogiri_upper->GeneBullet_1(0.5);
				if (nokogiri_down->TimerNotCount())
				{
					FirstGene = false;
				}
			}
			nokogiri_down->NobiShotRay(ball1, tableHight / 6, 4, Palette::Deepskyblue, 8);
			nokogiri_mid->NobiShotRay(ball2, tableHight / 6, 4, Palette::Deepskyblue, 8);
			nokogiri_upper->NobiShotRay(ball3, tableHight / 6, 4, Palette::Deepskyblue, 8);
		}
		else
		{
			
			if (taikyuuTime <= 5)
			{
				nokogiri_down->ColumnSetV(Vec2(-70 * (taikyuuTime - 3), 0));
				nokogiri_upper->ColumnSetV(Vec2(-70 * (taikyuuTime - 3), 0));
				nokogiri_mid->ColumnSetV(Vec2(70 * (taikyuuTime - 3), 0));
			}
			else
			{
				nokogiri_down->ColumnSetV(Vec2(-140, 0));
				nokogiri_upper->ColumnSetV(Vec2(-140, 0));
				nokogiri_mid->ColumnSetV(Vec2(140, 0)); 
			}

			if (taikyuuTime < 8)
				stopwatch.restart();

			if (taikyuuTime >= 8 && i < size(to) && taikyuuTime < 43)
			{
				const double t = Min(stopwatch.sF()/time[i/2], 1.0);
				if (stopwatch.sF() < time[i/2]+2) {
					const Vec2 pos = from[i].lerp(to[i], t);
					const Vec2 pos2 = from[i+1].lerp(to[i+1], t);
					RectLaser->RectArea(ball4, pos, pos2, 12, Palette::Gold);
				}
				else
				{
					stopwatch.restart();
					from << to[i];
					from << to[i + 1];
					i += 2;
				}
			}
			if (taikyuuTime >= 43 && taikyuuTime < 44)
			{
				ball4->RayAllExtingish();
				FirstGene = true;
			}
			if (taikyuuTime >= 44&&taikyuuTime<75)
			{
				if (FirstGene)
				{
					jikinerai->GeneBullet_1(0.5);
					michi->GeneBullet_1(6);
					if (michi->TimerNotCount())
					{
						FirstGene = false;
					}
						
				}
				jikinerai->AimShot(player, ball3, BallSpeed*1.6, 0, 0.6);
				michi->Shotball(ball5, BallSpeed * 0.7,40, 0.07);
				michi->SwingingSIN(3.14 / 6+0.2, 0, 11, jikuDir);
			}
			if (taikyuuTime >= 75 && taikyuuTime < 76)
			{
				jikinerai->deleteEneAll(); michi->deleteEneAll();
				FirstGene = true;
			}
			if (taikyuuTime >= 76 && taikyuuTime < 119)
			{
				if (FirstGene)
				{
					hunsui_t3->GeneBullet_1(0.5);
					if (hunsui_t3->TimerNotCount())
					{						
						FirstGene = false;
					}
				}
				hunsui_t3->HunsuiShot(ball4, BallSpeed, BallSpeed *2/ 3, 0.1, 3.14 / 24, 210);
				if (taikyuuTime >= 82&&taikyuuTime<93)
				{
					if (taikyuuTime < 82 + 3.14 * 7 / 3 + 1);
						HunsuiDir = (taikyuuTime - 82)/7 + 3.14 / 2;
				}
				if (taikyuuTime >= 93&&taikyuuTime<98)
				{
					if (taikyuuTime < 93 + 3.14 * 2 / 12)
						HunsuiDir = -(taikyuuTime - 93) / 2 + 3.14 / 2 + 3.14 / 7 + 1;
				}
				if (taikyuuTime >= 98&&taikyuuTime<108)
				{
					if (taikyuuTime < 98 + 3.14 * 3 * 4 / 4 + 1)
						HunsuiDir = -(taikyuuTime - 98) / 4 + 3.14 / 2 + 3.14 / 7 + 1 - 3.14 / 12;
				}
				if (taikyuuTime >= 113)
				{
					if (taikyuuTime < 113 + 3.14 * 2 / 2 - 0.247 * 2)
						HunsuiDir = (taikyuuTime - 113) / 2 + 0.247;
				}
				hunsui_t3->SetKabeHaritsuki_kai(Vec2(WindowWide / 2, WindowHight / 2), 5, CalDir(Vec2(WindowWide / 2, WindowHight / 2), Vec2(tableLeft, WindowHight - tableUpper)) - CalDir(Vec2(WindowWide / 2, WindowHight / 2), Vec2(WindowWide - tableLeft, WindowHight - tableUpper)) - 0.25, HunsuiDir);
			}
			if (taikyuuTime >= 119&&taikyuuTime<120)
			{
				hunsui_t3->HunsuiShot(ball4, BallSpeed, BallSpeed * 2 / 3, 0.1, 3.14 / 64, 210 - 70*(taikyuuTime-119));
				
				FirstGene = true;
			}
			
			nokogiri_down->ShotRay(ball1, 8, Palette::Deepskyblue, tableHight / 6);
			nokogiri_mid->ShotRay(ball2, 8, Palette::Deepskyblue, tableHight / 6);
			nokogiri_upper->ShotRay(ball3, 8, Palette::Deepskyblue, tableHight / 6);

			nokogiri_down->ColumnMove(nokointerval, WindowHight - tableUpper);
			nokogiri_mid->ColumnMove(nokointerval, tableUpper + tableHight * 5 / 6);
			nokogiri_upper->ColumnMove(nokointerval, tableUpper + tableHight * 2 / 3);
		}
		if (taikyuuTime >= 120)
		{
			if (FirstGene)
			{
				hunsui_t3->SetKabeHaritsuki_kai(Vec2(WindowWide / 2, WindowHight / 2), 5, CalDir(Vec2(WindowWide / 2, WindowHight / 2), Vec2(tableLeft, WindowHight - tableUpper)) - CalDir(Vec2(WindowWide / 2, WindowHight / 2), Vec2(WindowWide - tableLeft, WindowHight - tableUpper))-0.1, HunsuiDir);
				hunsui_t3->RemoveHanabimae();
				if (1)
				{
					pac->SetVelocity(Vec2(0, 100));
					FirstGene = false;
				}
			}
			if (enemy->GetDua() < DuaInit / 7)
			{
				hanabi->HanabiShot(ball2, 2, 2);
			}
			else
				hanabi->HanabiShot(ball2, 4, 3.5);

			hanabi->Explo(ball1);
			hunsui_t3->HunsuiShot(ball4, BallSpeed, BallSpeed * 2 / 3, 0.1, 3.14 / 64, 160);
			ball1->BallFall();
			ball2->BallFall();
			ball1->BallMove(10);
			ball2->BallMove(50);

			ball4->IntersectsPac(pac, 2.0);
			ball1->IntersectsPac(pac);

			if (ball1->IntersectsPlayer(player))
				ball1->BallAllExtingish();
		}
		else
		{
			if (pac->GetPacXY().y < tableUpper + 130&& !player->GetBreak())
				pac->SetVelocity(Vec2(0, 0));
		}
		taikyuuTime += Scene::DeltaTime();
		break;
	default:
		break;
	}
	//ballMove
	ball1->BallDecrease(4);
	
	ball3->BallMove();
	ball4->BallMove();
	ball5->BallMove();
	ball1->BallMove();
	ball1->BallDecelerate();
	ball2->BallMove();
	ball2->BallDecelerate();
	ball1->RemoveOutBall(table);
	ball2->RemoveOutBall(table);
	ball3->RemoveOutBall(table);
	ball4->RemoveOutBall(table);
	ball5->RemoveOutBall(table);

	if (ball1->IntersectsPlayer(player) || ball3->IntersectsPlayer(player)||ball4->IntersectsPlayer(player)||ball6->IntersectsPlayer(player)||ball5->IntersectsPlayer(player)
		||ball1->RayIntersectsPlayer(player)||ball2->RayIntersectsPlayer(player)|| ball3->RayIntersectsPlayer(player)|| ball4->RayIntersectsPlayer(player))
	{
		switch (type)
		{
		case 0:
			ball6->BallAllExtingishWithoutRay();
			break;
		case 1:
			ball6->BallAllExtingishWithoutRay();
			break;
		case 2:
			ball4->BallAllExtingishWithoutRay();
			
			break;
		case 3:
			
			break;
		default:
		
			break;
		}
	}
}

void Type5::Draw()
{
	switch (type)
	{
	case 0:
		ball6->Draw(Palette::Orange);
		ball7->RayDraw();


		NeutronStar->DrawCircle(Palette::Lightcyan);
		break;
	case 1:
		ball7->RayDraw();
		ball6->Draw(Palette::Orange);
		NeutronStar->DrawCircle(Palette::Black);
		break;
	case 2:
		ball1->RayDraw();
		ball2->RayDraw();
		ball3->RayDraw();
		ball4->Draw(Palette::Orange); ball4->RayDraw();
		break;
	case 3:
		ball1->RayDraw();
		ball2->RayDraw();
		ball3->RayDraw();
		ball3->Draw(Palette::Orange);
		ball4->RayDraw();
		ball4->Draw(Palette::Dodgerblue);
		jikinerai->bulletDraw();
		ball5->Draw(Palette::Orange);
		michi->bulletDraw();
		ball1->Draw(Palette::Orange);
		ball2->DrawA(Palette::Orange, 3);
		//uzu->bulletDraw();
		//ball4->Draw(Palette::Azure);
		break;
	default:
		break;
	}
}
