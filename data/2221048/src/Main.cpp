# include <Siv3D.hpp> // OpenSiv3D v0.6.5

void Main()
{
	int x = 40, y = 40;
	double vecX = 0, vecY = 0;
	int time = 0;
	int Mode = 0;
	int bx = 620, by = 640;
	double score = 0, score2 = 0;;
	int point = 0;
	double count = 0;
	int colorpoint = 0;
	double colorx = 255;
	double colory = 0;
	double colorz = 0;
	int color = 6;
	int mouse = 0;
	Window::Resize(1280, 720);
	Window::SetTitle(U"ピンポン");
	int FPS = 60; // 1秒間に1画面を書き換える回数
	Stopwatch sw;   //FPS60
	sw.start(); //FPS60

	// 通常のフォントを作成
	const Font font{ 50 };
	const Font text55{ 55 , Resource(U"example/font/DotGothic16/DotGothic16-Regular.ttf"), FontStyle::Bitmap };
	const Font text50{ 50 , Resource(U"example/font/DotGothic16/DotGothic16-Regular.ttf"), FontStyle::Bitmap };
	const Font text17{ 17 };
	const Font text43{ 43 , Resource(U"example/font/DotGothic16/DotGothic16-Regular.ttf"), FontStyle::Bitmap };
	const Font text30{ 30 , Resource(U"example/font/DotGothic16/DotGothic16-Regular.ttf"), FontStyle::Bitmap };
	const Font text32{ 32 , Resource(U"example/font/DotGothic16/DotGothic16-Regular.ttf"), FontStyle::Bitmap };
	const Font text38{ 38 , Resource(U"example/font/DotGothic16/DotGothic16-Regular.ttf"), FontStyle::Bitmap };
	const Font text250{ 250 , Resource(U"example/font/DotGothic16/DotGothic16-Regular.ttf"), FontStyle::Bitmap };
	const Audio audio1{ Resource(U"example/color.mp3") };
	const Audio countdown{ Resource(U"example/countdown.mp3") };
	const Audio VERYEASY1{ Resource(U"example/VERYEASY.mp3"),Loop::Yes };
	const Audio EASY1{ Resource(U"example/EASY.mp3"),Loop::Yes };
	const Audio NORMAL1{ Resource(U"example/NORMAL.mp3"),Loop::Yes };
	const Audio HARD1{ Resource(U"example/HARD.mp3"),Loop::Yes };
	const Audio shoot{ Resource(U"example/dageki.mp3") };
	const Audio nega{ Resource(U"example/nega.mp3") };
	const Audio click{ Resource(U"example/click.mp3") };
	const Audio bonus{ Resource(U"example/bonus.mp3") };
	// 画像ファイルからテクスチャを作成
	const Texture texture{ Resource(U"example/universe.jpg") };
	const Texture pic{ Resource(U"example/blue.png") };
	const Texture pic2{ Resource(U"example/pin.png") };
	const Texture button1{ Resource(U"example/001.png") };
	const Texture button2{ Resource(U"example/002.png") };
	const Texture button3{ Resource(U"example/004.png") };
	const Texture button4{ Resource(U"example/006.png") };
	const Texture VERYEASY{ Resource(U"example/VERYEASY12.png") };
	const Texture EASY{ Resource(U"example/EASY12.png") };
	const Texture NORMAL{ Resource(U"example/NORMAL12.png") };
	const Texture HARD{ Resource(U"example/HARD12.png") };

	// テキストを画面にデバッグ出力

	while (System::Update())
	{
		const Rect bar{ Arg::center(bx, 640), 110, 20 };
		const Circle cir{ x, y, 28 };
		texture.draw(0, 0);

		if (vecX != 0 && vecY != 0) {
			if (Mode == 1) {
				time++;
				if (time == 178)VERYEASY1.playOneShot();
				if (x > 1280) {
					vecX = -11;
					shoot.playOneShot();
				}
				if (x < 0) {
					vecX = 11;
					shoot.playOneShot();
				}
				if (y < 0)vecY = 10;
				if (x >= bx - 48 && x <= bx + 158 && y >= by - 28 && y <= by + 30) {
					vecY = -10;
					shoot.play();
				}
				if (y == 5) {

					shoot.play();
					score += 5;
					count += 0.50;
					point = (int)count;
				}
				if (KeyLeft.pressed())bx -= 14;
				if (KeyRight.pressed())bx += 14;
				if (y > 720) {
					nega.playOneShot();
					x = 40;
					y = 40;
					vecX = 1;
					vecY = 1;
					Mode = 10;
				}
				if (point != 0 && point % 5 == 0) {
					bonus.play();
					text32(point, U"回ボーナス 50点!!").draw(960, 110, Palette::Yellow);
				}
			}
			if (Mode == 2) {
				time++;
				if (time == 178)EASY1.playOneShot();
				if (x > 1280)
				{
					vecX = -15;
					shoot.playOneShot();
				}
				if (x < 0) {
					vecX = 15;
					shoot.playOneShot();
				}
				if (y < 0)vecY = 14;
				if (x >= bx - 48 && x <= bx + 158 && y >= by - 28 && y <= by + 30) {
					vecY = -14;
					shoot.play();
				}
				if (y == 5) {
					shoot.play();
					score += 5;
					count += 0.50;
					point = (int)count;
				}
				if (KeyLeft.pressed())bx -= 15;
				if (KeyRight.pressed())bx += 15;
				if (y > 720) {
					nega.playOneShot();
					x = 40;
					y = 40;
					vecX = 1;
					vecY = 1;
					Mode = 11;
				}
				if (point != 0 && point % 5 == 0) {
					bonus.play();
					text32(point, U"回ボーナス 50点!!").draw(960, 110, Palette::Yellow);
				}
			}
			if (Mode == 3) {
				time++;
				if (time == 178)NORMAL1.playOneShot();
				if (x > 1280) {
					vecX = -19;
					shoot.playOneShot();
				}
				if (x < 0) {
					vecX = 19;
					shoot.playOneShot();
				}
				if (y < 0)vecY = 18;
				if (x >= bx - 48 && x <= bx + 158 && y >= by - 28 && y <= by + 30) {
					vecY = -18;
					shoot.play();
				}
				if (y <= 1) {
					shoot.play();
					score += 10;
					count += 1;
					point = count;
				}
				if (KeyLeft.pressed())bx -= 18;
				if (KeyRight.pressed())bx += 18;
				if (y > 720) {
					nega.playOneShot();
					x = 40;
					y = 40;
					vecX = 1;
					vecY = 1;
					Mode = 12;
				}
				if (point != 0 && point % 5 == 0) {
					bonus.play();
					text32(point, U"回ボーナス 50点!!").draw(960, 110, Palette::Yellow);
				}
			}
			if (Mode == 4) {
				time++;
				if (time == 178)HARD1.playOneShot();
				if (x > 1280) {
					vecX = -25;
					shoot.playOneShot();
				}
				if (x < 0) {
					vecX = 25;
					shoot.playOneShot();
				}
				if (y < 0) {
					vecY = 24;
				}
				if (x >= bx - 48 && x <= bx + 158 && y >= by - 28 && y <= by + 30) {
					vecY = -24;
					shoot.play();
				}
				if (y <= 25) {
					shoot.play();
					score += 2;
					count += 2;
					point = count / 10;
				}
				if (KeyLeft.pressed())bx -= 21;
				if (KeyRight.pressed())bx += 21;
				if (y > 720) {
					nega.playOneShot();
					x = 40;
					y = 40;
					vecX = 1;
					vecY = 1;
					Mode = 13;
				}
				if (point != 0 && point % 5 == 0) {
					bonus.play();
					text32(point, U"回ボーナス 50点!!").draw(960, 110, Palette::Yellow);
				}
			}

			if (Mode == 10) {
				text17(U"BGM by OtoLogic").draw(3, 695);
				text55(U"VeryEasyモード").draw(460, 120, Palette::Red);
				text50(U"あなたのスコアは", score, U"点").draw(400, 260, Palette::Yellow);
				text43(U"エンターキーを押してタイトル画面に戻る").draw(280, 390, Palette::Blue);
				if (KeyEnter.down()) {
					Mode = 0;
					score = 0;
					point = 0;
					count = 0;
					vecX = 0;
					vecY = 0;
					time = 0;
					nega.stopAllShots();
				}
				if (KeyLeft.pressed())bx -= 14;
				if (KeyRight.pressed())bx += 14;
				VERYEASY1.stopAllShots();
			}
			if (Mode == 11) {
				text17(U"BGM by OtoLogic").draw(3, 695);
				text55(U"Easyモード").draw(500, 120, Palette::Red);
				text50(U"あなたのスコアは", score, U"点").draw(400, 260, Palette::Yellow);
				text43(U"エンターキーを押してタイトル画面に戻る").draw(280, 390, Palette::Blue);
				if (KeyEnter.down()) {
					Mode = 0;
					score = 0;
					point = 0;
					count = 0;
					vecX = 0;
					vecY = 0;
					time = 0;
					nega.stopAllShots();
				}
				if (KeyLeft.pressed())bx -= 15;
				if (KeyRight.pressed())bx += 15;
				EASY1.stopAllShots();
			}
			if (Mode == 12) {
				text17(U"BGM by OtoLogic").draw(3, 695);
				text55(U"Normalモード").draw(470, 120, Palette::Red);
				text50(U"あなたのスコアは", score, U"点").draw(400, 260, Palette::Yellow);
				text43(U"エンターキーを押してタイトル画面に戻る").draw(280, 390, Palette::Blue);
				if (KeyEnter.down()) {
					Mode = 0;
					score = 0;
					point = 0;
					count = 0;
					vecX = 0;
					vecY = 0;
					time = 0;
					nega.stopAllShots();
				}
				if (KeyLeft.pressed())bx -= 18;
				if (KeyRight.pressed())bx += 18;
				NORMAL1.stopAllShots();
			}
			if (Mode == 13) {
				text17(U"BGM by OtoLogic").draw(3, 695);
				text55(U"Hardモード").draw(500, 120, Palette::Red);
				text50(U"あなたのスコアは", score, U"点").draw(400, 260, Palette::Yellow);
				text43(U"エンターキーを押してタイトル画面に戻る").draw(280, 390, Palette::Blue);
				if (KeyEnter.down()) {
					Mode = 0;
					score = 0;
					point = 0;
					count = 0;
					vecX = 0;
					vecY = 0;
					time = 0;
					nega.stopAllShots();
				}
				if (KeyLeft.pressed())bx -= 21;
				if (KeyRight.pressed())bx += 21;
				HARD1.stopAllShots();
			}
		}

		else { //タイトル画面
			//難易度選択の背景
			button3.scaled(0.83).draw(230, 190);
			button2.scaled(0.83).draw(670, 190);
			button4.scaled(0.83).draw(230, 420);
			button1.scaled(0.83).draw(670, 420);
			//難易度選択画像
			VERYEASY.scaled(0.195).draw(288, 208);
			EASY.scaled(0.195).draw(780, 207);
			NORMAL.scaled(0.186).draw(305, 438);
			HARD.scaled(0.194).draw(775, 435);
			/*font(U"1を押してEasyモード").draw(390, 170);
			font(U"2を押してNormalモード").draw(370, 280);
			font(U"3を押してHardモード").draw(390, 390);*/
			text32(U" 操作方法 移動 : 左右矢印キー").draw(-10, 673, ColorF{ 1.0, 1.0, 1.0 });
			text30(U"ボールの色を変更").draw(1015, 505, ColorF{ 1.0, 1.0, 1.0 });
			pic.scaled(0.32).draw(1080, 550);
			pic2.scaled(2.9).draw(370, 0);
			if (KeyLeft.pressed())bx -= 14;
			if (KeyRight.pressed())bx += 14;
			/*if (Key1.down())
			{
				Mode = 21;
				vecX = 1;
				vecY = 1;
				countdown.playOneShot();
			}
			if (Key2.down())
			{
				Mode = 22;
				vecX = 1;
				vecY = 1;
				countdown.playOneShot();
			}
			if (Key3.down())
			{
				Mode = 23;
				vecX = 1;
				vecY = 1;
				countdown.playOneShot();
			}
			if (Key4.down())
			{
				Mode = 24;
				vecX = 1;
				vecY = 1;
				countdown.playOneShot();
			}*/
			if (KeyF12.down())LicenseManager::ShowInBrowser();
			if (MouseL.down()) {
				if (Cursor::Pos().x >= 246 && Cursor::Pos().x < 577 && Cursor::Pos().y >= 205 && Cursor::Pos().y < 279) {
					Mode = 21;
					vecX = 1;
					vecY = 1;
					countdown.playOneShot();
				}
				if (Cursor::Pos().x >= 690 && Cursor::Pos().x < 1025 && Cursor::Pos().y >= 205 && Cursor::Pos().y < 279) {
					Mode = 22;
					vecX = 1;
					vecY = 1;
					countdown.playOneShot();
				}
				if (Cursor::Pos().x >= 246 && Cursor::Pos().x < 577 && Cursor::Pos().y >= 432 && Cursor::Pos().y < 509) {
					Mode = 23;
					vecX = 1;
					vecY = 1;
					countdown.playOneShot();
				}
				if (Cursor::Pos().x >= 690 && Cursor::Pos().x < 1025 && Cursor::Pos().y >= 432 && Cursor::Pos().y < 509) {
					Mode = 24;
					vecX = 1;
					vecY = 1;
					countdown.playOneShot();
				}
				if (Cursor::Pos().x < 1088 || Cursor::Pos().x >= 1190 || Cursor::Pos().y < 560 || Cursor::Pos().y >= 665)click.playOneShot();
			}
			if (MouseL.pressed()) {
				if (Cursor::Pos().x >= 1088 && Cursor::Pos().x < 1190 && Cursor::Pos().y >= 560 && Cursor::Pos().y < 665)mouse += 1;
			}
			if (MouseL.up()) mouse = 0;
			if (mouse == 1) {
				colorpoint += 1;
				if (Cursor::Pos().x >= 1088 && Cursor::Pos().x < 1190 && Cursor::Pos().y >= 560 && Cursor::Pos().y < 665 && colorpoint % 6 == 1) {

					colorx = 0;
					colory = 0;
					colorz = 255;
					color = 1; //青色
					audio1.playOneShot();
				}
				if (Cursor::Pos().x >= 1088 && Cursor::Pos().x < 1190 && Cursor::Pos().y >= 560 && Cursor::Pos().y < 665 && colorpoint % 6 == 2) {

					colorx = 0;
					colory = 255;
					colorz = 0;
					color = 2; //緑色
					audio1.playOneShot();
				}
				if (Cursor::Pos().x >= 1088 && Cursor::Pos().x < 1190 && Cursor::Pos().y >= 560 && Cursor::Pos().y < 665 && colorpoint % 6 == 3) {

					colorx = 255;
					colory = 255;
					colorz = 0;
					color = 3; //黄色
					audio1.playOneShot();
				}
				if (Cursor::Pos().x >= 1088 && Cursor::Pos().x < 1190 && Cursor::Pos().y >= 560 && Cursor::Pos().y < 665 && colorpoint % 6 == 4) {

					colorx = 226;
					colory = 0;
					colorz = 226;
					color = 4; //紫色
					audio1.playOneShot();
				}
				if (Cursor::Pos().x >= 1088 && Cursor::Pos().x < 1190 && Cursor::Pos().y >= 560 && Cursor::Pos().y < 665 && colorpoint % 6 == 5) {

					colorx = 255;
					colory = 255;
					colorz = 255;
					color = 5; //白色
					audio1.playOneShot();
				}
				if (Cursor::Pos().x >= 1088 && Cursor::Pos().x < 1190 && Cursor::Pos().y >= 560 && Cursor::Pos().y < 665 && colorpoint % 6 == 0) {

					colorx = 255;
					colory = 0;
					colorz = 0;
					color = 6; //赤色
					audio1.playOneShot();
				}
			}

			if (color == 1)text32(U"青色").draw(1110, 667, ColorF{ 0.0, 0.0, 1.0 });
			if (color == 2)text32(U"緑色").draw(1110, 667, ColorF{ 0.0, 1.0, 0.0 });
			if (color == 3)text32(U"黄色").draw(1110, 667, ColorF{ 1.0, 1.0, 0.0 });
			if (color == 4)text32(U"紫色").draw(1110, 667, ColorF{ 226, 0.0, 226 });
			if (color == 5)text32(U"白色").draw(1110, 667, ColorF{ 1.0, 1.0, 1.0 });
			if (color == 6)text32(U"赤色").draw(1110, 667, ColorF{ 1.0, 0.0, 0.0 });
		}

		if (Mode == 21) {
			time++;
			if (KeyLeft.pressed())bx -= 14;
			if (KeyRight.pressed())bx += 14;
			if (time >= 0 && time <= 50) {
				text250(U"3").draw(560, 140, Palette::Red);
			}
			if (time >= 50 && time <= 100) {
				text250(U"2").draw(560, 140, Palette::Red);
			}
			if (time >= 100 && time <= 170) {
				text250(U"1").draw(560, 140, Palette::Red);
			}
			if (time == 170) {
				Mode = 1;
				vecX = 11;
				vecY = 10;
			}
		}

		if (Mode == 22) {
			time++;
			if (KeyLeft.pressed())bx -= 15;
			if (KeyRight.pressed())bx += 15;
			if (time >= 0 && time <= 50) {
				text250(U"3").draw(560, 140, Palette::Red);
			}
			if (time >= 50 && time <= 100) {
				text250(U"2").draw(560, 140, Palette::Red);
			}
			if (time >= 100 && time <= 170) {
				text250(U"1").draw(560, 140, Palette::Red);
			}
			if (time == 170) {
				Mode = 2;
				vecX = 15;
				vecY = 14;
			}
		}

		if (Mode == 23) {
			time++;
			if (KeyLeft.pressed())bx -= 18;
			if (KeyRight.pressed())bx += 18;
			if (time >= 0 && time <= 50) {
				text250(U"3").draw(560, 140, Palette::Red);
			}
			if (time >= 50 && time <= 100) {
				text250(U"2").draw(560, 140, Palette::Red);
			}
			if (time >= 100 && time <= 170) {
				text250(U"1").draw(560, 140, Palette::Red);
			}
			if (time == 170) {
				Mode = 3;
				vecX = 19;
				vecY = 18;
			}
		}
		if (Mode == 24) {
			time++;
			if (KeyLeft.pressed())bx -= 21;
			if (KeyRight.pressed())bx += 21;
			if (time >= 0 && time <= 50) {
				text250(U"3").draw(560, 140, Palette::Red);
			}
			if (time >= 50 && time <= 100) {
				text250(U"2").draw(560, 140, Palette::Red);
			}
			if (time >= 100 && time <= 170) {
				text250(U"1").draw(560, 140, Palette::Red);
			}
			if (time == 170) {
				Mode = 4;
				vecX = 25;
				vecY = 24;
			}
		}
		// テクスチャを描く
		bar.draw();
		cir.draw(ColorF{ colorx,colory,colorz });
		x += 0.50 * vecX;
		y += 0.50 * vecY;

		text38(U"スコア:", score, U"点").draw(995, 5, ColorF{ 0.0, 1.0, 0.0 });
		text38(U"回数:", point, U"回").draw(995, 55, ColorF{ 0.0, 1.0, 0.0 });
		if (bx < 0) bx = 0;
		if (bx > 1280) bx = 1280;
		ClearPrint();
		//Print << Cursor::Pos();
		//Print << (time);
		//Print <<U"(" << bx<<U"," << by<<U")";
		//Print << U"(" << x << U"," << y << U")";
		if ((int)score % 50 == 100 && (int)score % 100 != 0)score += 100;
		/*if (score == 50)score = 100;//5回
		if (score == 150)score = 200;//10回
		if (score == 250)score = 300;//15回
		if (score == 350)score = 400;//20回
		if (score == 450)score = 500;//25回
		if (score == 550)score = 600;//30回
		if (score == 650)score = 700;//35回
		if (score == 750)score = 800;//40回
		if (score == 850)score = 900;//45回
		if (score == 950)score = 1000;//50回
		if (score == 1050)score = 1100;//55回
		if (score == 1150)score = 1200;//60回
		if (score == 1250)score = 1300;//65回
		if (score == 1350)score = 1400;//70回
		if (score == 1450)score = 1500;//75回
		if (score == 1550)score = 1600;//80回
		if (score == 1650)score = 1700;//85回
		if (score == 1750)score = 1800;//90回
		if (score == 1850)score = 1900;//95回
		if (score == 1950)score = 2000;//100回
		if (score == 2050)score = 2100;
		if (score == 2150)score = 2200;
		if (score == 2250)score = 2300;
		if (score == 2350)score = 2400;
		if (score == 2450)score = 2500;
		if (score == 2550)score = 2600;
		if (score == 2650)score = 2700;
		if (score == 2750)score = 2800;
		if (score == 2850)score = 2900;
		if (score == 2950)score = 3000;
		if (score == 3050)score = 3100;
		if (score == 3150)score = 3200;
		if (score == 3250)score = 3300;
		if (score == 3350)score = 3400;
		if (score == 3450)score = 3500;
		if (score == 3550)score = 3600;
		if (score == 3650)score = 3700;
		if (score == 3750)score = 3800;
		if (score == 3850)score = 3900;
		if (score == 3950)score = 4000;
		if (score == 4050)score = 4100;
		if (score == 4150)score = 4200;
		if (score == 4250)score = 4300;
		if (score == 4350)score = 4400;
		if (score == 4450)score = 4500;
		if (score == 4550)score = 4600;
		if (score == 4650)score = 4700;
		if (score == 4750)score = 4800;
		if (score == 4850)score = 4900;
		if (score == 4950)score = 5000;
		if (score == 5050)score = 5100;
		if (score == 5150)score = 5200;
		if (score == 5250)score = 5300;*/

		while (sw.msF() < 1000.0 / FPS);    //1/60秒経過するまでループ
		sw.restart();   //FPS60  ストップウォッチをリスタート
	}

}
