# include <Siv3D.hpp> // OpenSiv3D v0.6.6
#include"Player.h"
#include"Notes.h"
#include"c_timer.h"
#include"Kuroden.h"
#include"Kuizuou.h"

struct gameData
{
	int32 score = 0;
};

using App = SceneManager<String,gameData>;

// タイトルシーン
class Title : public App::Scene
{
private:
	Font font1{ 30 };
public:
	Title(const InitData& init)
		: IScene{ init }
	{
	}

	~Title()
	{
	}

	void update() override
	{
		// 左クリックで
		if (SimpleGUI::ButtonAt(U"スタート",Vec2{Scene::Width()/2,Scene::Height()-200}))
		{
			// ゲームシーンに遷移
			changeScene(U"Game");
		}
	}

	void draw() const override
	{
		Scene::SetBackground(ColorF{ 0.8, 0.9, 1.0 });
		FontAsset(U"TitleFont")(U"黒電話マスター").drawAt(Scene::Width()/2, 100,Palette::Black);
		FontAsset(U"TitleFont")(U"アンナちゃん").drawAt(Scene::Width()/2, 200,Palette::Black);
		font1(U"タイミングよくアンナちゃんを左クリックしましょう").drawAt(Scene::Width() / 2, 400, Palette::Gray);
		font1(U"クイズが始まったら黒電話のダイヤルを回して回答しましょう").drawAt(Scene::Width() / 2, 500, Palette::Gray);
	}
};

// ゲームシーン
class Game : public App::Scene
{
private:
	Font ScoreFont{ 30,Typeface::Regular };
	Font HP{ 25,Typeface::Regular };
public:
	Game(const InitData& init)
		: IScene{ init }
	{
		ou = new Kuizuou(&systemupdate);
		ou->ReSetTimer(8);
		player=new Player(0.3, 100, s3d::Vec2{ 200,500 }, &systemupdate, &notes_list, 1,ou);
		player->SetTex(Player::State::nomal, nom);
		player->SetTex(Player::State::pushing, don);

		notes_rep_nomal=new c_timer(&systemupdate, 0,0,0,0.5);
	
		line=Line{ s3d::Vec2{150,70},s3d::Vec2{150,150} };

		kuro=new Kuroden(s3d::Vec2{ 700, 550 }, 120, 70, 4 * Math::Pi, player, s3d::Vec2(700 - zure_x, 550 - zure_y), fontbango,ou);
		kuro->SetTex(Kuroden::nomal, kurodenwa);
		kuro->AddBango(9, 9); kuro->AddBango(8, 8); kuro->AddBango(7, 7);
		kuro->AddBango(6, 6); kuro->AddBango(5, 5); kuro->AddBango(4, 4);
		kuro->AddBango(3, 3); kuro->AddBango(2, 2); kuro->AddBango(1, 1);

		player->kuro = kuro;

		font.time = new c_timer(&systemupdate);

		font.str.emplace(evalFonts::eval::perf, U"Perfect");
		font.str.emplace(evalFonts::eval::good, U"Good");
		font.str.emplace(evalFonts::eval::bad, U"Bad");
		font.col.emplace(evalFonts::eval::perf, ColorF(Palette::Red));
		font.col.emplace(evalFonts::eval::good, ColorF(Palette::Green));
		font.col.emplace(evalFonts::eval::bad, ColorF(Palette::Blue));
	}

	~Game()
	{
	}

	void update() override
	{
		//ClearPrint();

		if (kuro->hp <= 0)
		{
			getData().score = player->score;
			changeScene(U"Result");
		}

		notes_rep_nomal->update();
		if (notes_rep_nomal->Period()&&not ou->cooltim->GetLimitTimerRunning())
		{
			if (not ou->syutudai)
			{
				Notes notes(notes_vel, notes_initpos, notes_r, ColorF(Palette::Orange), line, player, window, &font);
				notes.Set_bad_range(30);
				notes.Set_perfect_range(notes_r / 3);
				notes_list << notes;
			}
		}

		ou->update();

		player->update();

		for (auto ite = notes_list.begin(); ite != notes_list.end();)
		{
			if (not ite->alive) {
				ite = notes_list.erase(ite);
			}
			else {
				ite++;
			}
		}
		for (auto& note : notes_list)note.update();
		kuro->update();
		
		if (not font.time->GetLimitTimerRunning())font.state = evalFonts::non;

		if (not font.state == evalFonts::non) font.font(font.str[font.state]).drawAt(line.begin.x, line.begin.y - font.font.fontSize(), font.col[font.state]);

		systemupdate = not(systemupdate);
	}

	void draw() const override
	{
		Scene::SetBackground(Palette::Wheat);

		player->draw();
		for (auto note : notes_list)note.draw();
		line.draw(4, Palette::White);
		kuro->draw();
		ou->draw();
		ScoreFont(Format(player->score)).draw(0, Scene::Height() - 50,Palette::White);
		HP(U"黒電話のHP").drawAt(Scene::Width() / 2-100, Scene::Height() - 300,Palette::Black);
		HP(Format(kuro->hp)).drawAt(Scene::Width() / 2 - 50, Scene::Height() - 260, Palette::Red);
	}

private:
	
	Rect window{ 1000,800 };
	bool systemupdate = false;
	Array<Notes> notes_list;
	Texture kurodenwa{ Resource(U"黒電.png") };
	Texture nom{ Resource(U"黒電マスターあんなちゃん.png") };
	Texture don{ Resource(U"黒電マスターあんなちゃん2.png") };

	Player* player;
	
	c_timer* notes_rep_nomal;
	c_timer* speed_up;
	double notes_vel = 350;
	Vec2 notes_initpos{ 900,100 };
	double notes_r = 15;
	Line line{ Vec2{150,70},Vec2{150,200} };

	Font fontbango{ 20,Typeface::Regular };
	double zure_x = 8; double zure_y = 15;
	Kuroden* kuro;
	evalFonts font;
	Kuizuou *ou;
};

// 結果発表シーン
class Result : public App::Scene
{
public:
	Result(const InitData& init)
		: IScene{ init }
	{
	}

	~Result()
	{
	}

	void update() override
	{
		// 左クリックで
		if (MouseL.down())
		{
			changeScene(U"Title");
		}
	}

	void draw() const override
	{
		Scene::SetBackground(ColorF{ 0.8, 0.9, 1.0 });
		font1(U"結果").draw(200, 100);
		font2(Format(getData().score)).draw(250, 150,Palette::Khaki);
		if (getData().score < 1000) {
			font1(U"黒電話マスター　失格です").drawAt(Scene::Center(), Palette::Blue);
		}
		else if (getData().score > 1400)
		{
			font1(U"上手ですね").drawAt(Scene::Center(), Palette::Gold);
		}
		else if (getData().score >= 1000)
		{
			font1(U"黒電話マスター　合格です").drawAt(Scene::Center(), Palette::Red);
		}
	}
private:
	Font font1{ 70,Typeface::Medium };
	Font font2{ 100,Typeface::Bold};
};

void Main()
{
	//Scene::SetBackground(Palette::Wheat);

	Window::Resize(1000, 800);

	FontAsset::Register(U"TitleFont", 60, Typeface::Heavy);

	// シーンマネージャーを作成
	App manager;

	// タイトルシーン（名前は "Title"）を登録
	manager.add<Title>(U"Title");

	// ゲームシーン（名前は "Game"）を登録
	manager.add<Game>(U"Game");

	manager.add<Result>(U"Result");

	while (System::Update())
	{
		if (not manager.update())
		{
			break;
		}
	}

}
