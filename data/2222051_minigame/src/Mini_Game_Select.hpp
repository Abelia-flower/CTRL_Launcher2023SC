#pragma once
#include"Common.hpp"
class Mini_Game_Select : public App::Scene
{
public:
	//フォント
	const Font font{30};

	//画面下の四角形の情報
	const int rect_size=100;//四角形の大きさ
	const int rect_num=7;//四角形(ゲーム)の個数
	const int rect_gap = 20;//四角形の間隔

	//アイコン画像
	const Texture Lock_icon{ 0xf023_icon, 120 };//鍵の画像
	const Texture Back_icon{ 0xf0e2_icon, 40 };//戻る矢印の画像

	//ボタンの座標(戻る、戻る、開始)
	const Point back_pos{ 35, 35 };
	const Point back_pos2{ 430, 230 };
	const Point start_pos{ 600,470 };

	//ボタン(開始、イージー、ノーマル、ハード)
	const Rect start{ Arg::center(start_pos), 300, 70 };
	const Rect rect_easy{ Arg::center(600,300),380,80 };
	const Rect rect_normal{ Arg::center(600,400),380,80 };
	const Rect rect_hard{ Arg::center(600,500),380,80 };

	//enumからStringに変換
	const Array<String> henkan{ U"Stage",U"Easy",U"Normal",U"Hard" };

	//光らせるのに必要
	const Size sceneSize{ 1200, 800 };
	const RenderTexture gaussianA1{ sceneSize }, gaussianB1{ sceneSize };
	const RenderTexture gaussianA4{ sceneSize / 4 }, gaussianB4{ sceneSize / 4 };
	const RenderTexture gaussianA8{ sceneSize / 8 }, gaussianB8{ sceneSize / 8 };

	//JSONファイル
	JSON json = JSON::Load(U"score.json");

	//各ゲームのデータ
	Array<Texture>images;//各ゲームの小さい画像
	Array<Texture>pictures;//各ゲームの大きい画像
	Array<String>sentences;//各ゲームの説明文
	Grid<bool>ClearData{ 4,rect_num };// 各ゲームのクリア状況

	Array<String>sceneNames;

	//どのゲームを選択しているか
	int index = 0;

	//写真を拡大
	bool largeFlg = false;

	//難易度選択中か(難易度選択中のときtrue)
	bool mode_selsect = false;
	
	Mini_Game_Select(const InitData& init) : IScene{ init }{
		Scene::SetBackground(ColorF{ 0.0, 0.0, 0.0 });

		if (getData().mini_clear == true&& json[U"Stage{}"_fmt(getData().stage)][henkan[getData().mini_mode]].get<bool>()==false) {
			json[U"Stage{}"_fmt(getData().stage)][henkan[getData().mini_mode]] = true;
			json.save(U"score.json");
		}

		index = getData().stage - 1;

		for (int i = 0; i < rect_num; i++) {
			//各ステージの読み込み
			String str{ U"Stage{}"_fmt(i + 1) };
			images << Texture{ json[str][U"Image"].get<String>() };
			pictures << Texture{ json[str][U"Picture"].get<String>() };
			sentences << json[str][U"Sentence"].get<String>();
			sceneNames<< json[str][U"SceneName"].get<String>();
			for (int j = 0; j < 4; j++)ClearData[i][j] = json[str][henkan[j]].get<bool>();
		}
	}

	void update() override
	{
		if (not largeFlg) {

			if (mode_selsect) {
				if (Circle(back_pos2, 25).leftClicked())mode_selsect = false;
				bool end = false;
				if (rect_easy.leftClicked()) {
					end = true;
					getData().mini_mode = Easy_Mode;
				}
				if (rect_normal.leftClicked()) {
					end = true;
					getData().mini_mode = Normal_Mode;
				}
				if (rect_hard.leftClicked()) {
					end = true;
					getData().mini_mode = Hard_Mode;
				}
				if (end) {
					getData().stage = index + 1;
					getData().mini_clear = false;
					changeScene(sceneNames[index]);
				}

			}
			else {
				if (Circle(back_pos, 25).leftClicked()) {
					getData().mini_mode = Stage_Mode;//念のため
					getData().stage = 1;//念のため
					getData().mini_clear = false;//念のため
					//changeScene(U"Start");///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
				}

				if (start.leftClicked() && ClearData[index][Stage_Mode])mode_selsect = true;

				//index
				if (((KeyLeft | KeyA).down() || 0.5s <= KeyLeft.pressedDuration() || 0.5s <= KeyA.pressedDuration()) && index != 0)index--;
				if (((KeyRight | KeyD).down() || 0.5s <= KeyRight.pressedDuration() || 0.5s <= KeyD.pressedDuration()) && index != rect_num - 1)index++;

				for (int i : step(rect_num)) {
					if (Rect{ Arg::center(rect_x(i),700), rect_size }.leftClicked()) {
						index = i;
					}
				}

				if (RectF{ 100, 100,pictures[index].resized(450).size }.leftClicked()&& ClearData[index][Stage_Mode]) {
					largeFlg = true;
				}
			}
		}
		else if (MouseL.down())largeFlg = false;
	}

	void draw() const override
	{

		HSV color{ Scene::Time() *20 };

		bool clear = ClearData[index][Stage_Mode];

		// ガウスぼかし用テクスチャにシーンを描く
		{
			const ScopedRenderTarget2D target{ gaussianA1.clear(ColorF{ 0.0 }) };
			if (clear) {
				DrawGame(false);
			}
			else {
				Lock_icon.drawAt(600, 300, color);
			}

			DrawScene(false, color);
			DrawSelectGame(false, color);
		}
		shader();//ガウスぼかし+このタイミングで描写

		if (clear) {
			DrawGame(true);
		}
		else {
			Lock_icon.drawAt(600, 300, Palette::White);
		}

		DrawScene(true, Palette::White);

		DrawSelectGame(true, Palette::White);

		if (mode_selsect)DrawSelectMode();

		if (largeFlg) {
			Rect{ Scene::Size() }.draw(ColorF(0,0.6));
			pictures[index].resized(1000).drawAt(Scene::Center());
		}
	}

private:
	int rect_x(int i)const{
		int gap = rect_size + rect_gap;
		return  600 - (rect_num-1)*gap/2+i*gap;
	}
	void shader()const {
		Shader::GaussianBlur(gaussianA1, gaussianB1, gaussianA1);
		Shader::Downsample(gaussianA1, gaussianA4);
		Shader::GaussianBlur(gaussianA4, gaussianB4, gaussianA4);
		Shader::Downsample(gaussianA4, gaussianA8);
		Shader::GaussianBlur(gaussianA8, gaussianB8, gaussianA8);
		const ScopedRenderStates2D blend{ BlendState::Additive };
		gaussianA1.resized(sceneSize).draw(ColorF{ 0.1 });
		gaussianA4.resized(sceneSize).draw(ColorF{ 0.4 });
		gaussianA8.resized(sceneSize).draw(ColorF{ 0.8 });
	}

	//線
	void DrawScene(bool flg,HSV color)const {
		int a, b;
		if (flg) { a = 3; b = 0; }
		else { a = 8; b = 5; }
		Line{ 50 + 2,525,rect_x(index) - rect_size / 2 ,700 - rect_size / 2 }.draw(a,color);
		Line{ 1150 - 2,525,rect_x(index) + rect_size / 2, 700 - rect_size / 2 }.draw(a,color);
		Ellipse{ 600, 740, 500, 50 }.drawFrame(a,b,color);
		Rect{ Arg::center(600,300),1100,450 }.drawFrame(a,b,color);

		/////////////////////////////////////////////////////////////////////////////////////////////////////////
		//Back_icon.drawAt(back_pos);
	}




	//ゲーム情報
	void DrawGame(bool flg)const {
			if (flg) {
				font(sentences[index]).draw(600, 100);
				if (ClearData[index][Easy_Mode])Shape2D::Star(40, Vec2{ 150, 470 }).draw(Palette::Yellow);
				if (ClearData[index][Normal_Mode])Shape2D::Star(40, Vec2{ 250, 470 }).draw(Palette::Yellow);
				if (ClearData[index][Hard_Mode])Shape2D::Star(40, Vec2{ 350, 470 }).draw(Palette::Yellow);
				start.drawFrame(3);
				font(U"開始").drawAt(start_pos, ColorF{ 1.0, Periodic::Sine0_1(3s) });
				pictures[index].resized(450).draw(100, 100);
			}
			else {
				Shape2D::Star(40, Vec2{ 150, 470 }).drawFrame(5, Palette::Yellow);
				Shape2D::Star(40, Vec2{ 250, 470 }).drawFrame(5, Palette::Yellow);
				Shape2D::Star(40, Vec2{ 350, 470 }).drawFrame(5, Palette::Yellow);
			}
	}

	//ステージ選択
	void DrawSelectGame(bool flg,HSV color)const {
		if (flg) {
			font(U"A ←").drawAt(50, 700);
			font(U"D →").drawAt(1150, 700);
			for (int i = 0; i < rect_num; i++) {
				if (ClearData[i][Stage_Mode]) {
					images[i].resized(rect_size, rect_size).drawAt(rect_x(i), 700);
				}
				else {
					Rect{ Arg::center(rect_x(i), 700) ,rect_size }.draw(ColorF(0,0.5));
					Lock_icon.resized(60).drawAt(rect_x(i), 700);
				}
			}
		}
		else Rect{ Arg::center(rect_x(index),700), rect_size + 10 }.draw(color);
	}

	//難易度選択
	void DrawSelectMode()const {
			Rect{ 0,0,1200,800 }.draw(ColorF(0, 0, 0, 0.6));
			Rect{ Arg::center(600, 400),400,400 }.draw(Palette::Black);
			Back_icon.drawAt(430, 230);
			if (ClearData[index][Easy_Mode])Shape2D::Star(30, Vec2{ 450, 300 }).draw(Palette::Yellow);
			if (ClearData[index][Normal_Mode])Shape2D::Star(30, Vec2{ 450, 400 }).draw(Palette::Yellow);
			if (ClearData[index][Hard_Mode])Shape2D::Star(30, Vec2{ 450, 500 }).draw(Palette::Yellow);
			font(U"イージー").drawAt(600, 300);
			font(U"ノーマル").drawAt(600, 400);
			font(U"ハード").drawAt(600, 500);
			rect_easy.drawFrame(3,Palette::Green);
			rect_normal.drawFrame(3, Palette::Orange);
			rect_hard.drawFrame(3, Palette::Red);
		{
			const ScopedRenderTarget2D target{ gaussianA1.clear(ColorF{ 0 }) };
			Rect{ 0,0,1200,800 }.draw(Palette::Black);//黒で埋めつくす(リセット)
			Back_icon.drawAt(430, 230);
			Shape2D::Star(30, Vec2{ 450, 300 }).drawFrame(5, Palette::Yellow);
			Shape2D::Star(30, Vec2{ 450, 400 }).drawFrame(5, Palette::Yellow);
			Shape2D::Star(30, Vec2{ 450, 500 }).drawFrame(5, Palette::Yellow);
			rect_easy.drawFrame(8,5, Palette::Green);
			rect_normal.drawFrame(8, 5, Palette::Orange);
			rect_hard.drawFrame(8, 5, Palette::Red);
		}
		shader();//ガウスぼかし+描写
	}
};
