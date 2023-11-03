#pragma once
#include "Mallet.h"
//#include"Pac.h"
#include"data.h"

class Enemy:public Mallet
{
private:
	//Rect DuabilityBar;
	int32 point;
public:
	Enemy(double x, double y, double e, double m_r, double h_s, double r_s, double m_s, double tableleft, double tableupper,
		double windowwide, double windowhight, double g_r,Array<Vec2> life);

	~Enemy();

	void emove(double x);

	void CollidePac(Vec2 velocity,double damage);//パックに当たった時、耐久値を減らす

	int32 GetDua();

	void SetDua(int32 d);

	void BreakMallet();

	void RepairMallet();

};
