#pragma once
#include"c_timer.h"

class Notes;

class Kuizuou;

class Kuroden;

class Player
{
public:
	enum State {
		nomal,
		pushing,
	};
	Player(double push_interval, int32 scoreInit, Vec2 pos, bool* systemupd, Array<Notes>* list, double scale, Kuizuou* ou)
		:score(scoreInit), pos(pos), list(list), scale(scale), ou(ou), kuro(kuro)
	{
		interval_push=new c_timer(systemupd,push_interval);
		state = nomal;
		hantei=Rect{ 50,330,260,450 };
	};
	~Player();

	void SetTex(State state, Texture texture) {
		
		tx.emplace(state, texture);
	}

	void addScore(int32 Score) {
		score += Score;
	};

	void update();
	void draw();
	Kuroden* kuro;
	Kuizuou* ou;
	int32 score;
private:
	State state;
	Vec2 pos;
	Rect hantei;
	
	Array<Notes>* list;
	c_timer* interval_push;
	HashTable<State,Texture> tx;
	double scale;
	const Audio audio{ Resource(U"受話器置く02.mp3") };

};

