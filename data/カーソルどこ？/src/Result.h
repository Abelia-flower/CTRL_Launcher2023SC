#pragma once
#include"Common.h"
class Result : public App::Scene
{
public:
	Result(const InitData& init): IScene{ init }{}

	void update() override
	{
		if (KeyShift.pressed())changeScene(U"Title",0);
	}

	void draw() const override
	{
		FontAsset(U"title")(U"スコア{}"_fmt(getData().score)).drawAt(400, 300);
		FontAsset(U"font")(U"Shiftでスタート画面に戻る").drawAt(400, 500);
	}
};
