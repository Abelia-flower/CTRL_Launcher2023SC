#pragma once
#include"Common.hpp"
class Start : public App::Scene
{
public:

	Start(const InitData& init)
		: IScene{ init }
	{
	}


	void update() override
	{
		// 左クリックで
		if (SimpleGUI::Button(U"Setting", Vec2{ 100, 100 }))changeScene(U"Setting");
		if (SimpleGUI::Button(U"Map", Vec2{ 100, 250 }))changeScene(U"Map");
		if (SimpleGUI::Button(U"Mini_Game_Select", Vec2{ 100, 300 }))changeScene(U"Mini_Game_Select");
	}

	void draw() const override
	{
		Scene::SetBackground(ColorF{ 1.0, 0.98, 0.96 });
	}

private:

};
