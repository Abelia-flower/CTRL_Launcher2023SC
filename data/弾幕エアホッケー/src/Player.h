#ifndef _PLAYER_H_
#define _PLAYER_H_
#include"Mallet.h"
#include"Pac.h"


class Player: public Mallet
{
private:
	double delta;
	double duability;
public:
	Player(double x, double y, double em, double m_r, double h_s, double r_s, double m_s, double tableleft, double tableupper,
		double windowwide, double windowhight, double g_r,Array<Vec2> life);
	~Player();

	void keymove(bool enemyBrak);

	void Move(Vec2 houkou, bool enemyBreak);

	void ChangeSpeed();

	void duabilityDown();

	void duabilityDownContinuous();

	int32 GetDua();

	Circle GetAtarihantei();

	void BreakMallet();

	void RepairMallet();

	void Repaired();

	void Draw();
};

#endif
