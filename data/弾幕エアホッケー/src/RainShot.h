#pragma once
#include "EneBullet_1.h"

class RainShot
{
private:
	int32 interval;
	double dir;
	double CoolTime;
	double VeloMax;
	double VeloMin;
	double baratsuki;//dirのばらつき
	double ShotTimer;
public:
	RainShot(int32 inter,double VMa,double VMi,double baratsuki);
	~RainShot();

	void GeneBullet_1(double time, EneBullet_1* b1, EneBullet_1* b2, EneBullet_1* b3);

	Array< Array<bullets>> RemainderShotSet();//武器を配置（大きさ0）
	void RemainderShot(Ball_1* ball, EneBullet_1* b1, EneBullet_1* b2, EneBullet_1* b3);

	void ShiftBullet(EneBullet_1* b1, EneBullet_1* b2, EneBullet_1* b3);

	void Swing(double theta, double t, EneBullet_1* b1, EneBullet_1* b2, EneBullet_1* b3);//今のdirからt秒かけて一回転する（一回転以上もする）

	void HunsuiShot(Ball_1* ball, double Speed, double ct, double zurasu, double grab);//噴水

	void Draw(EneBullet_1* b1, EneBullet_1* b2, EneBullet_1* b3);//テスト用
};
