#include "stdafx.h"
#include "RainShot.h"

RainShot::RainShot(int32 i, double VMa, double VMi,double baratsuki) :dir(3.14 / 2), CoolTime(1), baratsuki(baratsuki),ShotTimer(0)
{
	interval = i;	
	VeloMax = VMa;
	VeloMin = VMi;
};

RainShot::~RainShot()
{
};

Array< Array<bullets>> RainShot::RemainderShotSet()
{
	Array<bullets> bul;
	Array< Array<bullets>>b;
	int32 k = 1;
	//テーブルの上
	double zure = Random(interval);
	while (k * interval-zure < tableWide)
	{
		if (k * interval - zure > 0)
		{
			bullets b{ {tableLeft + k * interval - zure,tableUpper},dir,0,Random(1.5),{0,0} };
			bul << b;
		}
		k++;
	}
	k = 1;
	b << bul;
	bul.clear();

	if (tan(dir) != Math::Inf)
	{
		//テーブルの左
		zure = Random(k * interval * Abs(tan(dir)));
		while (k * interval * Abs(tan(dir))-zure < tableHight)
		{
			if (k * interval * Abs(tan(dir)) - zure > 0)
			{
				bullets b{ {tableLeft,tableUpper + k * interval * Abs(tan(dir)) - zure},dir,0,Random(1.5),{0,0} };
				bul << b;
			}
			k++;
		}
		k = 1;
	}
	b << bul;
	bul.clear();

	if (tan(dir) != Math::Inf)
	{
		zure = Random(k * interval * Abs(tan(dir)));
		//テーブルの右
		while (k * interval * Abs(tan(dir))-zure < tableHight)
		{
			if (k * interval * Abs(tan(dir)) - zure > 0)
			{
				bullets b{ {WindowWide - tableLeft,tableUpper + k * interval * Abs(tan(dir)) - zure},dir,0,Random(1.5),{0,0} };
				bul << b;
			}
			k++;
		}
		k = 1;
	}
	b << bul;
	bul.clear();

	return b;
}

void RainShot::GeneBullet_1(double time, EneBullet_1* b1, EneBullet_1* b2, EneBullet_1* b3)
{
	b1->GeneBullet_1(time);
	b2->GeneBullet_1(time);
	b3->GeneBullet_1(time);
}

void RainShot::RemainderShot(Ball_1* ball, EneBullet_1* b1, EneBullet_1* b2, EneBullet_1* b3)
{
	ShotTimer += Scene::DeltaTime();
	if (ShotTimer > CoolTime)
	{
		ShotTimer = 0;
		b1->RandomShotball(ball, VeloMin, VeloMax, b1->GeteneDir(), baratsuki, 0, 0);
		b2->RandomShotball(ball, VeloMin, VeloMax, b2->GeteneDir(), baratsuki, 0, 0);
		b3->RandomShotball(ball, VeloMin, VeloMax, b3->GeteneDir(), baratsuki, 0, 0);
	}
	
//	ShiftBullet();
	if (tan(dir) != Math::Inf)
	{
		Array<bullets> bul;
		int32 k = 1;
		//テーブルの左
		
		while (k * interval * Abs(tan(dir)) < tableHight)
		{
			if (k * interval * Abs(tan(dir)) > 0)
			{
				bullets b{ {tableLeft,tableUpper + k * interval * Abs(tan(dir)) },dir,0,Random(1.5),{0,0} };
				bul << b;
			}
			k++;
		}
		k = 1;

		b2->Setenebullets(bul);
		bul.clear();

		
		//テーブルの右
		while (k * interval * Abs(tan(dir)) < tableHight)
		{
			if (k * interval * Abs(tan(dir))  > 0)
			{
				bullets b{ {WindowWide - tableLeft,tableUpper + k * interval * Abs(tan(dir)) },dir,0,Random(1.5),{0,0} };
				bul << b;
			}
			k++;
		}
		k = 1;

		b3->Setenebullets(bul);
		bul.clear();
	}
}



void RainShot::ShiftBullet(EneBullet_1* b1, EneBullet_1* b2, EneBullet_1* b3)
{
	Array<bullets> bul;
	int32 k = 1;
	//テーブルの上
	double zure = Random(interval);
	while (k * interval - zure < tableWide)
	{
		if (k * interval - zure > 0)
		{
			bullets b{ {tableLeft + k * interval - zure,tableUpper},dir,0,Random(1.5),{0,0} };
			bul << b;
		}
		k++;
	}
	k = 1;
	b1->Setenebullets(bul);
	bul.clear();

	if (tan(dir) != Math::Inf)
	{
		//テーブルの左
		zure = Random(k * interval * Abs(tan(dir)));
		while (k * interval * Abs(tan(dir)) - zure < tableHight)
		{
			if (k * interval * Abs(tan(dir)) - zure > 0)
			{
				bullets b{ {tableLeft,tableUpper + k * interval * Abs(tan(dir)) - zure},dir,0,Random(1.5),{0,0} };
				bul << b;
			}
			k++;
		}
		k = 1;
	}
	b2->Setenebullets(bul);
	bul.clear();

	if (tan(dir) != Math::Inf)
	{
		zure = Random(k * interval * Abs(tan(dir)));
		//テーブルの右
		while (k * interval * Abs(tan(dir)) - zure < tableHight)
		{
			if (k * interval * Abs(tan(dir)) - zure > 0)
			{
				bullets b{ {WindowWide - tableLeft,tableUpper + k * interval * Abs(tan(dir)) - zure},dir,0,Random(1.5),{0,0} };
				bul << b;
			}
			k++;
		}
		k = 1;
	}
	b3->Setenebullets(bul);
	bul.clear();
}

void RainShot::Swing(double theta,double t, EneBullet_1* b1, EneBullet_1* b2, EneBullet_1* b3)
{
	if ((t > 0 && dir > theta) || (t < 0 && dir < theta) || t == 0)
	{
		dir = theta;
	}
	else
	{
		dir += 6.28 * Scene::DeltaTime() / t;
	}

	b1->SetDir(dir);
	b2->SetDir(dir);
	b3->SetDir(dir);
}

void RainShot::Draw(EneBullet_1* b1, EneBullet_1* b2, EneBullet_1* b3)
{
	b1->bulletDraw();
	b2->bulletDraw();
	b3->bulletDraw();
}
