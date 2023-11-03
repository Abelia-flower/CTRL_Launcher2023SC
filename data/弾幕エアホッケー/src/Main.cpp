#include <Siv3D.hpp>
#include"data.h"
#include"Mallet.h"
#include"Player.h"
#include"Pac.h"
#include"Enemy.h"
#include"ButtonManager.h"
#include"TypeManager.h"

///自分が死んだとき、玉の消滅にエフェクトをつけたい

const int32 WindowWide = 1200;
const int32 WindowHight = 800;

using App = SceneManager<String>;

ButtonManager b_manager;

class Title : public App::Scene
{
private:
	Font font{ 30 };
public:
	Title(const InitData& init)
		: IScene(init)
	{
		pause = false;
		gameover = false;
		BackChangeSc = false;
		changeSc = false;
		b_manager.RemoveAllButton();
		b_manager.SetButton(U"スタート", Vec2(WindowWide / 2-60, WindowHight / 2), 30, 120, Palette::White, START);
		b_manager.SetButton(U"終了", Vec2(WindowWide / 2-60, WindowHight / 2 + 50), 30, 120, Palette::White, QUIT);
	}

	void update() override
	{
		b_manager.Update();

		if (changeSc)
		{
			changeScene(U"game");
		}
	}

	void draw()const override
	{
		b_manager.Draw();

		Scene::SetBackground(ColorF(0.3, 0.4, 0.5));

		FontAsset(U"Titlefont")(U"弾幕エアホッケー").drawAt(600, 100);

		font(U"z...決定").draw(10, WindowHight - 50);
	}
};

class Game : public App::Scene
{
private:
	TypeManager t_manager;
	Font font{ 60 };
	bool oneTime = true;
public:
	
	Game(const InitData& init)
		:IScene(init)
	{
		changeSc = false;
		t_manager.ChangeType(0);
		b_manager.RemoveAllButton();
		b_manager.SetButton(U"再開", Vec2(WindowWide - 300, tableUpper + tableHight * 3 / 4), 30, 120, Palette::White, RESTART);
		b_manager.SetButton(U"最初から始める", Vec2(WindowWide - 315, tableUpper + tableHight * 3 / 4 + 50), 30, 150, Palette::White, REBEGIN);
		b_manager.SetButton(U"タイトルに戻る", Vec2(WindowWide - 315, tableUpper + tableHight * 3 / 4 + 100), 30, 150, Palette::White, BACK_TO_TITLE);
	}

	void update() override
	{
		t_manager.Update();

		if (rebegin)
		{
			pause = false;
			gameover = false;
			rebegin = false;
			changeScene(U"game");
		}

		
		if (BackChangeSc)
		{
			changeScene(U"title");
		}
		if (changeSc)
		{
			changeScene(U"GameClear");
		}

		if (gameover&&oneTime)
		{			
			b_manager.RemoveAllButton();
			b_manager.SetButton(U"タイトルに戻る", Vec2(WindowWide - 315, tableUpper + tableHight * 3 / 4 + 100), 30, 150, Palette::White, BACK_TO_TITLE);
			b_manager.SetButton(U"最初から始める", Vec2(WindowWide - 315, tableUpper + tableHight * 3 / 4 + 50), 30, 150, Palette::White, REBEGIN);
			b_manager.SetButton(U"リトライ", Vec2(WindowWide - 300, tableUpper + tableHight * 3 / 4), 30, 120, Palette::White, RETRY);
			oneTime = false;
		}
		if (gameover)
			b_manager.Update();

		if (pause)
			b_manager.Update();

		if (retry)
		{
			t_manager.ChangeType(t_manager.GetNowType());
			t_manager.Retry();
			oneTime = true;
			changeSc = false;
			gameover = false;
			retry = false;
		}
		
	}

	void draw() const override
	{
		if(!changeSc)
			t_manager.Draw();
		if (pause)
		{
			Rect{ 0,0,WindowWide,WindowHight }.draw(ColorF(Palette::Black, 0.7));
			font(U"ポーズ").drawAt(Scene::Center(), Palette::White);
			b_manager.Draw();
		}
		if (gameover)
		{
			Rect{ 0,0,WindowWide,WindowHight }.draw(ColorF(Palette::Black, 0.7));
			font(U"ゲームオーバー").drawAt(Scene::Center(), Palette::Darkred);
			b_manager.Draw();
		}
	}
};

class GameClear : public App::Scene
{
public:
	GameClear(const InitData& init) : IScene(init)
	{
		changeSc = false;
		b_manager.RemoveAllButton();
		b_manager.SetButton(U"タイトルに戻る", Vec2(WindowWide - 315, tableUpper + tableHight * 3 / 4 ), 30, 150, Palette::White, BACK_TO_TITLE);
	}

	void update() override
	{
		b_manager.Update();
		if (BackChangeSc)
		{
			changeScene(U"title");
		}
	}

	void draw() const override
	{
		Scene::SetBackground(ColorF(0.3, 0.4, 0.5));
		b_manager.Draw();
		FontAsset(U"Titlefont")(U"ゲームクリア！！").drawAt(Scene::Center(), Palette::Greenyellow);
	}
};

void Main()
{
	System::SetTerminationTriggers(UserAction::CloseButtonClicked);

	Window::Resize(WindowWide, WindowHight);

	FontAsset::Register(U"Titlefont", 60, Typeface::Heavy);

	App manager;

	manager.add<Title>(U"title");

	manager.add<Game>(U"game");

	manager.add<GameClear>(U"GameClear");
	
	while (System::Update())
	{

		
		if (!manager.update())
		{
			break;
		}
	}
}
