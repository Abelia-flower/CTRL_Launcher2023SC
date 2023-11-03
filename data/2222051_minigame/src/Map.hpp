#pragma once
#include"Common.hpp"
class Map : public App::Scene
{
public:

	Map(const InitData& init)
		: IScene{ init }
	{
	}


	void update() override
	{
		// 左クリックで
		if (SimpleGUI::Button(U"戻る", Vec2{ 100, 100 }))changeScene(U"Start");
	}

	void draw() const override
	{
		Scene::SetBackground(ColorF{ 1.0, 0.98, 0.96 });
	}

private:

};
