#include"Common.hpp"
#include"Start.hpp"
#include"Setting.hpp"
#include"Map.hpp"
#include"Mini_Game_Select.hpp"
#include"FallingAnna.h"
#include"HawkDropOut.h"
#include"ManjuRush.h"
#include"MAZE.h"
#include"Maze2.h"

// ゲームシーン

void Main()
{
	Window::Resize(1200, 800);
	System::SetTerminationTriggers(UserAction::CloseButtonClicked);
	Window::SetTitle(U"アンナのお菓子な大冒険 ミニゲーム集");

	FontAsset::Register(U"TitleFont", 85, Typeface::Heavy);

	// シーンマネージャーを作成
	App manager;

	// タイトルシーン（名前は "Title"）を登録
	manager.add<Start>(U"Start");
	manager.add<Setting>(U"Setting");
	manager.add<Map>(U"Map");
	manager.add<Mini_Game_Select>(U"Mini_Game_Select");
	manager.add<FallingAnna>(U"FallingAnna");
	manager.add<HawkDropOut>(U"HawkDropOut");
	manager.add<ManjuRush>(U"ManjuRush");

	manager.add<MAZE>(U"MAZE");
	manager.add<Game>(U"Game");
	manager.add<Clear>(U"Clear");

	manager.add<mazeGame>(U"MazeGame");

	manager.init(U"Mini_Game_Select");

	while (System::Update())
	{
		if (not manager.update())
		{
			break;
		}
	}
}
