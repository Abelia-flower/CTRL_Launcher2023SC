#include "stdafx.h"
#include "Kuizuou.h"

void Kuizuou::update()
{
	if (seikai->GetLimitTimerRunning())
	{
		Shape2D::RectBalloon(RectF{ 400,200,500,50 }, Vec2{ 950,140 }).draw(Palette::White);
		font(U"正解").drawAt(400 + 250, 225, ColorF(Palette::Red));
	}
	if (huseikai->GetLimitTimerRunning())
	{
		Shape2D::RectBalloon(RectF{ 400,200,500,50 }, Vec2{ 950,140 }).draw(Palette::White);
		font(U"不正解").drawAt(400 + 250, 225, ColorF(Palette::Blue));
	}
	seikai->update(); huseikai->update();

	if (not pre_timer->GetLimitTimerRunning())
	{
		if (sengen->GetLimitTimerRunning())
		{
			syutudai = true;
			Shape2D::RectBalloon(RectF{ 400,200,500,50 }, Vec2{ 950,140 }).draw(Palette::White);
			font(U"クイズ王の挑戦").drawAt(400 + 250, 225, ColorF(Palette::Blue));
			n = Random<int32>(0, kuizu.size()-1);//何問めを出すか
			nn.clear();
			num.clear();
			//numに1～kuizu[n].size()-1まで代入
			for (auto k : step(kuizu[n].size() - 1))num << k + 1;
			if (num.size() > Bango.size())throw Error{ U"選択肢の数が番号の数より大きいです" };
			//選択肢に番号を割り当て
			nn = Bango.choice(num.size());
			nn.shuffle();
			num.shuffle();
		}
		else
		{
			if (syutudai) {
				cooltim->ReStartLimitTimer();
				count++;
			}
			//if (not cooltim->GetLimitTimerRunning())cooltim->ReStartLimitTimer();
			cooltim->update();
			RectF rect{ 200,200,700,100 };
			Shape2D::RectBalloon(rect, Vec2{ 950,140 }).draw(Palette::White);
			//問題文出力
			font(kuizu[n][0]).drawAt(200 + 350, 225, Palette::Blue);
			//選択肢文の生成
			String ques;
			for (auto i : step(nn.size()))
			{
				ques += Format(nn[i]) + U". " + kuizu[n][num[i]] + U"　";
			}
			font(ques).drawAt(200 + 350, 275, Palette::Blue);
			syutudai = false;
		}
		sengen->update();
	}
	pre_timer->update();
}

bool Kuizuou::review(int32 ans)
{
	if (not sengen->GetLimitTimerRunning())
	{
		for (int32 k = 0; k < 3; k++)
		{
			if (nn[k] == ans)
			{
				if (num[k] == 1) {
					seikai->ReStartLimitTimer();
					return true;
				}
			}
		}
		huseikai->ReStartLimitTimer();
	}
	return false;
}

void Kuizuou::draw()
{
	juwa.scaled(0.6).drawAt(950, 90);
}
