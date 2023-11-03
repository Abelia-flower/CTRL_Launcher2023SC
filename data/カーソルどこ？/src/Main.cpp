#include "Common.h"
#include "Start.h"
#include "Title.h"
#include "Game.h"
#include "Result.h"

void Main()
{
	Window::SetTitle(U"カーソルどこ？");

	FontAsset::Register(U"font", 20);
	FontAsset::Register(U"title", 60);

	App manager;
	manager.add<Start>(U"Start");
	manager.add<Title>(U"Title");
	manager.add<Game>(U"Game");
	manager.add<Result>(U"Result");

	while (System::Update())if(not manager.update())break;
		
}
