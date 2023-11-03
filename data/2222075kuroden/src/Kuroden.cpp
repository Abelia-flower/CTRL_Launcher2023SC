#include "stdafx.h"
#include "Kuroden.h"
#include"Player.h"
#include"Kuizuou.h"

void Kuroden::update()
{
	if (grab and MouseL.pressed() and not triangle.mouseOver() and not nothantei.mouseOver() and hantei.mouseOver())
	{
		Vec2 n = Cursor::Pos()-hantei.center;
		n.setLength(hantei.r);
		if (std::abs(n.getAngle() - grab_angle.getAngle()) > 3)angle += 0.02;
		else angle += n.getAngle() - grab_angle.getAngle();
		grab_angle = n;
	}
	else if(grab)
	{
		if (dial.isPlaying())dial.stop(); dial.play();

		//離した瞬間
		bool flag = false;
		for (auto N : step(9))
		{
			if (Line{ hantei.center,trianglePos }.intersects(Circle{ hantei.center + (hantei.r - 23) * Vec2 { Cos(angle + Math::Pi / 2 + 2 * Math::Pi * N / 13),Sin(angle + Math::Pi / 2 + 2 * Math::Pi * N / 13) },17 }))
			{
				flag = true;
				if (not ou->sengen->GetLimitTimerRunning())
				{
					if (ou->review(bango[8 - N]))
					{
						player->addScore(150);
					}
					ou->ReSetTimer(8 - ou->count);
				}
			}
		}
		grab = false;
	}
	if (MouseL.down() and hantei.mouseOver() and not nothantei.mouseOver())
	{
		grab = true;
		grab_angle = Cursor::Pos() - hantei.center;
		grab_angle.setLength(hantei.r);
	}

	if (not grab)
	{
		angle -= w * Scene::DeltaTime();
		if (angle < 0) {
			if (dial.isPlaying())dial.stop();
			angle = 0;
		}
	}
}

void Kuroden::draw()
{
	tx[state].drawAt(texpos);
	Circle{ hantei.center,hantei.r }.draw(ColorF(Palette::White,0.6));
	for (auto N : step(9))
	{
		Circle{ hantei.center + (hantei.r - 23) * Vec2 { Cos(angle+ Math::Pi / 2 + 2 * Math::Pi * N / 13),Sin(angle+ Math::Pi / 2 + 2 * Math::Pi * N / 13) },15 }.draw(Palette::Dimgray);
		font(Format(bango[8-N])).drawAt(hantei.center+(hantei.r + 10) * Vec2 { Cos(Math::Pi / 2 + 2 * Math::Pi * N / 13), Sin(Math::Pi / 2 + 2 * Math::Pi * N / 13) });
	}
	triangle.draw(Palette::Gray);
}

void Kuroden::AddBango(int32 num, int32 str)
{
	bango.emplace(num-1, str);
}
