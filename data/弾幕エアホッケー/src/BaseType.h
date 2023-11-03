#pragma once
#include"Pac.h"
#include"Player.h"

class BaseType
{
public:
	virtual void Update(Pac* pac, Player* player, Enemy* enemy) = 0;
	virtual void Draw() = 0;
};

