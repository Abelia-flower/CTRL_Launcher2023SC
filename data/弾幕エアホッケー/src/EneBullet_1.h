#pragma once
#include"EneBall.h"
#include"EneBullet.h"

//散弾バレット（復活する）
//三発の弾を扇状に放つ（断続的に）
class EneBullet_1 :public RevivableEneBullet
{
private:
	Rect Bullet_1;//敵のビジュアル　ひし形(この正方形を45度回転して描写させる)

	double GeneTime = 4.0;		//敵がテーブル上にいないとき、敵を生み出すまでの時間

	double Time = 0;//経過時間計測　T5Wipeで使う
	double Time1 = 0;//経過時間（ショートタイム）
	double kasandir = 0;//積分用dir

	double theta;

public:
	EneBullet_1(int32 R, Array<bullets> b);
	virtual ~EneBullet_1();

	void bulletDraw();						//敵の描写

	void DrawCircle(Color c);

	void SetEneBullet_1(bullets b);

	void RemoveEneBullet_1();

	void RemoveHanabimae();

	void Shotball(Ball_1* ball, double Speed, double ct, double MinD, double MaxD);	//弾を放つ,減速はランダム

	void Shotball(Ball_1* ball, double Speed, double ct);	//弾を放つ、減速はなし

	void Shotball(Ball_1* ball, double Speed, double dece, double ct);//弾を放つ、減速は任意

	void Shotball(Ball_1* ball, double Speed, double ct, Array<double> dir, double zurasu, double MinD, double MaxD);//dir指定

	void RandomShotball(Ball_1* ball, double MinSpeed, double MaxSpeed, Array<double> dir, double baratsuki, double MinD, double MaxD);//type4のrainshotで主に使う

	void ShotRay(Ball_1* ball, int32 hutosa, Color c, Pac* pac);

	void ShotRay(Ball_1* ball, int32 hutosa, Color c, double len);

	void HunsuiShot(Ball_1* ball, double MaxSpeed, double MinSpeed,double ct, double zurasu, double grab);//噴水

	void NeutronStarRay(Ball_1* ball, int32 hutosa, Color c, Pac* pac);//中性子星のガンマ線バースト、パックが光線に当たった時の処理も書いてる

    Array<Vec2> SetBulSurr(Vec2 center,double BaseDir, int32 k);//centerを中心にステージをk等分し、centerをとりかこむようにbulletを設置

	void GeneBullet_1();		//bulletが欠損しているかを調べ、欠損したbulletを生み出す。bulletの定位置と復活にかかる時間を引数に持つ。

	void GeneBullet_1(double time);//bulletをtime以内に生み出す

	void deleteEneAll();

	bool TimerNotCount();		//genetimerが起動中かどうか（０かどうか）

	void SwingNeck(double delta);

	void SwingNeck_360(double t);//回転バレット、何秒で一回転するかを引数にもつ。負の時間を入れると回る向きが反転する。

	void SwingingSIN(double range,double isou,double t,double jiku);//首を振る範囲をラジアンで指定、t秒で一周。

	void SwingingSIN(double range, double isou, double t, Array<double>jiku);

	void SwingingSIN(double range, double isou, Array<double>t, Array<double>jiku);

	void MoveGrab(Vec2 point,double g);//pointに向けてgに比例する引力を受ける

	void MoveCircle(Vec2 p, double r);//円運動の中心と半径を引数に持つ

	void ProcessionSet(double dir, int32 dis);

	void Resettheta();

	void ResetDir(Array<double> Init);

	void SetDir(double dir);

	void absor(Player* p,Vec2 point,double d,bool enemyBreak);//playerをpointに吸い込む,dは一秒間あたりの移動距離

	bool T5Wipe(Ball_1* ball, double t1,double t2);//Type5で使うワイプショット、t1は移動時間、t2は休憩時間

	void SetBallHexagon(Ball_1* ball, int32 n, Vec2 center,int32 interval);//nで大きさが変化(n>1)

	Array<Vec2> SetKabeHaritsuki(Vec2 cen, int32 n, double hanniRad, double Dir);//見えない線を放射、壁との交点に武器を配置

	void SetKabeHaritsuki_kai(Vec2 cen, int32 n, double hanniRad, double dir);//噴水用！

	void RectArea(Ball_1* ball, Vec2 p1, Vec2 p2, int32 hutosa, Color c);//対角の二点の座標をもらい、長方形を作成

};
