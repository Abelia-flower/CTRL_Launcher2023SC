#pragma once
#include"Common.h"
class Sikaku
{
public:
	ColorF color;
	int x, y;
	String str, rure;
	Font font{ 40 }, font2{ 18 };
	RoundRect rect;
	Sikaku(int x1, int y1, String str1, String str2, ColorF color1) {
		x = x1; y = y1; str = str1; rure = str2; color = color1;
		rect = { Arg::center(x, y), 200, 200 ,30 };
	}
	bool Draw(int score) {
		rect.draw(color);
		font(str).drawAt(x, y - 65);
		font2(rure).drawAt(x, y);
		font2(U"スコア" + Format(score)).drawAt(x, y + 65);
		return rect.leftClicked();
	}
};

class Title : public App::Scene
{

public:
	Stopwatch stopwatch;
	Array<Sikaku*>s;
	enum Mode modenum[3] = { normal,random,mirror };

	Title(const InitData& init)
		: IScene{ init } {
		s <<new Sikaku(150, 300, U"ノーマル", U"通常モード"							  , Palette::Green);
		s <<new Sikaku(400, 300, U"ランダム", U"リンゴをクリックごとに\nカーソルが移動", Palette::Peru);
		s <<new Sikaku(650, 300, U"リバース", U"カーソルが反対に動く"			    , Palette::Darkred);
	}

	void update() override
	{
		for (int i = 0; i < 3; i++) {
			if (s[i]->Draw(getData().max[i]))
			{
				getData().mode = modenum[i];
				changeScene(U"Game", 0);
			}
		}
	}

	void draw() const override
	{
		FontAsset(U"title")(U"カーソルどこ？").drawAt(400, 100);
		FontAsset(U"font")(U"ルール説明\n30秒以内にできるだけ多くのリンゴをクリックしよう\nリンゴをクリックするたびに偽のマウスカーソルが増えるよ\nモードを選択した瞬間から始まるよ\nプレイを中断したいときはEscキーを押してね").drawAt(400, 500);
	}
};
