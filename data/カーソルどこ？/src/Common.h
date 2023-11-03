#pragma once
#include<Siv3D.hpp>

enum Mode { normal, random, mirror };

struct GameData
{
	int score;
	Mode mode;
	int max[3] = {0,0,0};
};

using App = SceneManager<String, GameData>;

