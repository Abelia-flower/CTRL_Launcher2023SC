#pragma once
#include"Common.h"
class Start : public App::Scene
{
public:
	Start(const InitData& init) : IScene{ init }
	{
		//過去のスコアの読み取り
		TextReader read;
		String line;
		int i = 0;
		if (read.open(U"スコア.txt"))while (read.readLine(line)&&i<3)getData().max[i++] = Parse<int>(line);
		read.close();

	}

	void update() override
	{
		//もしShiftが押されたらTitleへ移動
		if (KeyShift.pressed())changeScene(U"Title", 0);
	}

	void draw() const override
	{
		//表示
		FontAsset(U"title")(U"カーソルどこ？").drawAt(400, 250);
		FontAsset(U"font")(U"Shiftを押してゲームを始める").drawAt(400, 450);
	}
};
