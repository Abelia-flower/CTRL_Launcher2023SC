#include "stdafx.h"
#include "Player.h"
#include "Notes.h"
#include"Kuizuou.h"
#include"Kuroden.h"

Player::~Player()
{

}

void Player::update()
{
	//Print << score;
	if (MouseL.down())
	{
		if (not interval_push->GetLimitTimerRunning())
		{
			if (hantei.mouseOver()) {
				if (audio.isPlaying())audio.stop();
				audio.play();
				interval_push->ReStartLimitTimer();
				for (auto& note : *list)note.push = true;
				if (not ou->sengen->GetLimitTimerRunning()) {
					ou->ReSetTimer(8 - ou->count);
				}
			}
		}
	}
	if (interval_push->GetLimitTimerRunning())
	{
		state = Player::pushing;
	}
	else
	{
		state = Player::nomal;
	}
	interval_push->update();
}

void Player::draw()
{
	tx[state].scaled(scale).drawAt(pos);
	//hantei.draw(ColorF(Palette::Red,0.6));
}
