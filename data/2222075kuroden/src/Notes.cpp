#include "stdafx.h"
#include "Notes.h"
#include "Player.h"
#include "c_timer.h"
#include"Kuroden.h"

Notes::Notes(double v, Vec2 pos, int32 r, ColorF colo, Line l, Player* pl, Rect windw, evalFonts* font)
	:font(font) {
	push = false;
	alive = true;
	vel = v;
	line = l;
	hantei=Circle{ pos,r };
	player = pl;
	window = windw;
	color = colo;
}

Notes::~Notes()
{

}

void Notes::update()
{
	if (push)
	{
		alive = false;
		double d1=100;
		if (const auto Point = hantei.intersectsAt(line))
		{
			font->time->ReStartLimitTimer();
			for (const auto& point : *Point) d1 = std::abs(point.x - hantei.center.x);
			//perfect or good 
			if (d1 <= perfect_range) {
				player->addScore(highScore);
				player->kuro->damage(1);
				font->state = evalFonts::perf;
			}
			else {
				player->addScore(lowScore);
				player->kuro->damage(2);
				font->state = evalFonts::good;
			}
		}
		else {
			if (std::abs(hantei.center.x - line.begin.x) < hantei.r + bad_range)
			{
				font->time->ReStartLimitTimer();
				//bad
				player->kuro->damage(5);
				player->addScore(badScore);
				font->state = evalFonts::bad;
			}
			else
			{
				//not eat
				alive = true;
			}
		}
		push = false;
	}

	if (not hantei.intersects(window)) { alive = false; player->kuro->damage(5); }

	hantei.setCenter(hantei.center + vel * Vec2{ -1,0 }*Scene::DeltaTime());

}

void Notes::draw()
{
	hantei.draw(color);
}
