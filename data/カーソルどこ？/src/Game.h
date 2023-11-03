#pragma once
#include"Common.h"
class FalseMouse {
public:
	Vec2 pos, speed;
	FalseMouse() {
		int t = Random(0_deg, 360_deg);
		speed = { cos(t) ,sin(t) };
		pos = RandomVec2(800, 600);
	}
	void move() {
		if ((pos.x < 0 && speed.x < 0) || (800 < pos.x && speed.x > 0))speed.x *= -1;
		if ((pos.y < 0 && speed.y < 0) || (600 < pos.y && speed.y > 0))speed.y *= -1;
		pos += speed * AbsVec2(Cursor::Delta());
	}
private:
	int AbsVec2(Vec2 vec) {
		return sqrt(vec.x*vec.x+vec.y*vec.y);
	}

};
class Apple{
public:
	int size = 60;
	Vec2 pos = Vec2(10, 10) + RandomVec2(780, 580);
	bool click(Mode mode) {
		if (mode == mirror)return Circle(800 - pos.x, 600 - pos.y, size / 2).leftClicked();
		return Circle(pos, size / 2).leftClicked();
	}
};
Vec2 cur(Mode mode) {
	if (mode == mirror)return Vec2(800, 600) - Cursor::Pos();
	else return Cursor::Pos();
}


class Game : public App::Scene
{
public:
	double time;
	Stopwatch stopwatch{ StartImmediately::Yes };
	const Texture texture{ Resource(U"マウス.png") }, apple_t;
	Array<FalseMouse*>a;
	Apple apple;

	Game(const InitData& init):IScene{ init },apple_t(Emoji(U"🍎"))
	{
		getData().score = 0;//スコアの初期化
		Cursor::ClipToWindow(true);//カーソルが画面外に出ないように設定
	}

	void update() override
	{
		Cursor::RequestStyle(CursorStyle::Hidden);//カーソルを非表示
		time = 30 - stopwatch.sF();//残り時間の計算


		//リンゴの表示
		apple_t.resized(apple.size).drawAt(apple.pos);

		//偽のカーソルの移動と表示
		for (int i = 0; i < a.size(); i++) {
			texture.resized(20).draw(a[i]->pos);
			if (not(getData().mode == random && apple.click(random)))a[i]->move();
		}


		//もしリンゴがクリックされたら
		if (apple.click(getData().mode)) {
			for (int i = 0; i < 50; i++)a << new FalseMouse();//偽カーソルを50個追加
			apple = {};//リンゴを初期化(移動)
			getData().score++;//スコアを増加
			//もしランダムモードなら
			if (getData().mode == random) {
				Cursor::SetPos(RandomPoint(600,600));//真カーソルを移動
			}
		}

		//本物カーソルの表示
		texture.resized(20).draw(cur(getData().mode));

		//ゲーム終了時の処理
		if (time <= 0) {
			//記録の更新
			if (getData().max[getData().mode] < getData().score) {
				getData().max[getData().mode] = getData().score;
				TextWriter writer{ U"スコア.txt" };
				for (int i = 0; i < 3; i++)writer.write(Format(getData().max[i]) + U"\n");
			}
			Cursor::ClipToWindow(false);
			changeScene(U"Result", 0);//Resultへ移動
		}

	}

	void draw() const override
	{
		//残り時間とスコアの表示
		FontAsset(U"font")(U"残り{:.2f}秒"_fmt(time)).draw(10, 10);
		FontAsset(U"font")(U"スコア{}"_fmt(getData().score)).draw(10, 30);
	}
};
