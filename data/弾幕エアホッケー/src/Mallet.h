#pragma once
#ifndef _MALLET_H_
#define _MALLET_H_
#include <Siv3D.hpp>

enum KEY {
	Left,
	Right,
	Up,
	Down
};

class Mallet
{
protected:
	Circle mallet;
	Circle grip;
	Circle Atarihantei;
	Vec2 preMxy;	//マレットの座標を保持する

	int32 key[4] = { 0,0,0,0 };

	double em;	//マレットの反発係数
	double malletspeed;
	double highspeed, rowspeed;
	double grip_r;//マレットグリップの半径
	double tl;	//tableleft
	double tu;	//tableupper
	double ww;	//windowwide
	double wh;	//windowhight

	double duability;

	bool Break;

	bool Revivaled;

	Array<Vec2> lifes;
public:
	Mallet(double x, double y, double e, double m_r, double h_s, double r_s, double m_s, double tableleft,
		double tableupper, double windowwide, double windowhight, double g_r, Array<Vec2> life);

	virtual ~Mallet();

	void SetXY(double x, double y);
	void SetX(double x);
	void SetY(double y);

	void MoveX();
	void MoveY();

	void SetPreXY();
	void SetPreX();
	void SetPreY();

	Circle GetMallet();
	Circle GetGrip();

	Vec2 GetXY();
	Vec2 GetPreXY();
	double GetE();
	double GetDelta();
	double GetSpeed();
	double GetHighspeed();
	double GetRowspeed();

	int32* GetKey();
	void ResetKey();

	bool GetRevivaled();

	bool GetBreak();

	void DrawLifes();

	void LostLifes();

	void SetRevivaled(bool b);

	int32 GetLifeNum();
};

#endif //_MALLET_H_
