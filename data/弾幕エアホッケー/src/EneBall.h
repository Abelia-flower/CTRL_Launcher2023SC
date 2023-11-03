#pragma once
#include "Pac.h"
#include"Player.h"
#include"myfunction.h"

//基底となる弾の構成
//これを様々な弾に継承させる

class EneBall
{
protected:
	struct ball {
		Vec2 pos;
		double dir;		//発射方向　ラジアン
		double Speed;
		double deceleration;
		double time;			//発射されてからの経過時間？
	};

	struct ray {
		Line line;
		Color color;
		int32 hutosa;
	};
	Array<ball> Balls;    //弾の座標
	Array<ray> Ray;		//レーザーの線分
	int32 r;				//弾の大きさ(当たり判定)
	int32 vr;				//弾の大きさ（見ため）
	Effect effect;			//パックにあたって消滅するときのエフェクト
public:
	EneBall(int32 BallR,int32 BallVR);
	virtual ~EneBall();

	void IntersectsPac(Pac* pac);			//パックと衝突したときんの処理
	void IntersectsPac(Pac* pac,double iryoku);//敵がパックと衝突（なんでここに宣言されるんだ…）
	Array<bool> IntersectsPac(Pac* pac, Vec2 start);//レーザーとパックの衝突、startはレーザーの起点
	void IntersectsHunsui(Pac* pac, double iryoku);//レーザーとの衝突、上方向に加速iryokuは噴水の押し返す力
	void IntersectsifUe(Pac* pac, double iryoku);//パックが上に進んでいれば速度.yを加速
	void IntersectsJun(Pac* pac, double iryoku);//パックの順方向に加速
	bool IntersectsPlayer(Player* player);	//プレイヤーが被弾したかどうかを返す
	bool RayIntersectsPlayer(Player* player);//プレイヤーが光線に被弾したとき
	void RemoveOutBall(Rect table);					//場外に出た弾を除外
	void Ball_1_draw();
	void BallAllExtingish();
	void BallAllExtingishWithoutRay();
	void RayAllExtingish();
	void MoveAt(Vec2 dir);

	void pop_back();

	bool DistanceOver_if(Vec2 p, Vec2 b, double r);//ballとpの距離がr以上ならtrue

	Array<ball> GetBalls();
	Array<ray> GetRays();
	int32 GetVisualR();
	int32 GetAtariR();

	void RayDraw();

	void Draw(Color c);

	void DrawA(Color c, double t);
};

