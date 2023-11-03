#pragma once
#include"data.h"
#include"BaseType.h"
#include"Pac.h"
#include"Player.h"
#include"Type1.h"
#include"Type2.h"
#include"Type3.h"
#include"Type4.h"
#include"Type5.h"
#include"Enemy.h"
#include"myfunction.h"

class TypeManager
{
private:
	static BaseType* m_pType;

	static Pac* insP;
	static Player* player_m;
	static Enemy* enemy_m;
public:
	enum TYPE {
		TYPE1,
		TYPE2,
		TYPE3,
		TYPE4,
		TYPE5,
		Clear
	};

	TypeManager();

	static void ChangeType(int32 type);

	static int32 GetNowType();

	static void Retry();

	static void Update();

	static void Draw();

};

