# include <Siv3D.hpp>
bool flag2;
struct ScoreEffect : IEffect
{
	Vec2 m_start;
	String m_score;
	Font m_font;

	ScoreEffect(const Vec2& start, String score, const Font& font)
		: m_start{ start }
		, m_score{ score }
		, m_font{ font } {}

	bool update(double t) override
	{
		m_font(m_score).drawAt(m_start.movedBy(0, t * -120), ColorF(1.0,0.0,0.0, 1.0 - (t * 2.0)));
		Line{ 0,100,800,100 }.draw(12, ColorF{ 1.0,0.0,0.0,Sin((t/0.3)*3.14) });
		flag2 = 1;
		return (t < 0.3);
	}
};

String make_text() {
	String str=U"", moji = U"Il|";
	for (int i = 0; i < 20; i++) {
		str += moji[Random(moji.size()-1)];
	}
	return str;
}

class Sikaku {
public:
	String c,str;
	int x, y;
	Rect rect;
	Font font,font2;
	Sikaku(String c1, int x1, int y1,String str1) {
		c = c1; x = x1; y = y1; rect = { x - 50,y - 50,100,100 }; font = { 80 }; str = str1, font2 = {20};
	}
	void draw() {
		rect.drawFrame(0, 3, Palette::Gray); font(c).drawAt(x, y, Palette::Gray); font2(str).drawAt(x, y + 80);
	}
	void light(){
		if (flag2) {
			ColorF color{ 1.0,0.0,0.0 };
			rect.drawFrame(0, 3, color); font(c).drawAt(x, y, color);
		}
		else {
			ColorF color{ 0.0,1.0,0.0 };
			rect.drawFrame(0, 3, color); font(c).drawAt(x, y, color);
		}
	}
};

void Main()
{
	const Audio piano{ GMInstrument::Clarinet, PianoKey::C2, 0.3s };
	const Audio audio{ Resource(U"example/shot.mp3") };

	//タイトル
	Window::SetTitle(U"Il|タイピング");
	//背景の設定
	Scene::SetBackground(ColorF{ 0.0, 0.0, 0.0 });
	//変数の宣言
	Stopwatch stopwatch;
	enum { start, game, result } mode = start;
	bool flag;
	int miss,score,max=0;
	double watch,time,limit,volume;
	String target,input,slid=U"||||||||||";
	const Font font(70), scorefont(40),enter(30),rule(25);
	Effect effect;
	Sikaku s1(U"I", 200, 450,U"アイ"), s2(U"l", 400, 450,U"エル"), s3(U"|", 800 - 200, 450,U"バーティカルバー");

	//スコアの読み込み
	{
		TextReader reader{ U"スコア.txt" };
		String line;
		if(reader)if(reader.readLine(line))max= Parse<int>(line);
	}

	while (System::Update())
	{
		//スタート画面***************************************************************************
		if (mode==start) {
			font(U"Il|タイピング").drawAt(400,170);
			enter(U"Enterを押すとスタート").drawAt(400,300, ColorF{ Periodic::Jump0_1(3s) });
			rule(U"I(大文字アイ)　l(小文字エル)　|(バーティカルバー)\nのみで構成されたタイピングゲームです。\nタイプミスすると0.5秒、制限時間が短くなります。").drawAt(400,450);
			rule(U"スコア：{}"_fmt(max)).drawAt(600, 550);
			rule(U"音量　　{}"_fmt(slid)).draw(100, 530);
			if(SimpleGUI::Button(U"＋", Vec2{ 290, 530 },30)&&slid.size()<10)slid+=U"|";
			if(SimpleGUI::Button(U"ー", Vec2{ 165, 530 },30)&&slid.size())slid.pop_back();

			if (KeyEnter.down()) {
				mode = game;
				volume = slid.size() / 10.0;
				flag2=flag=miss=score=0;
				input.clear();
				target = make_text();
				limit = 60;
				effect.clear();
				stopwatch.restart();
				audio.playOneShot(volume);
			}
		}
		//ゲーム画面***************************************************************************
		else if(mode==game){
			//時間計算
			time = Clamp(limit-stopwatch.sF(),0.0,60.0);
			watch = 1-time +(int)time;//周期

			s1.draw(); s2.draw(); s3.draw();

			if (KeyI.pressed() && KeyShift.pressed())s1.light();
			if (KeyL.pressed()&&not KeyShift.pressed())s2.light();
			if (KeyYen_JIS.pressed() && KeyShift.pressed())s3.light();

			// テキスト入力
			TextInput::UpdateText(input, TextInputMode::DenyControl);


			// 誤った入力が含まれていたら削除
			while (not target.starts_with(input))
			{
				piano.playOneShot(volume);
				limit-=0.5;
				miss++;
				input.pop_back();
				effect.add<ScoreEffect>(Vec2(600,50), U"{}ミス -0.5秒"_fmt(miss), scorefont);
			}

			// 一致したら次の問題へ
			if (input == target)
			{
				score += input.size();
				input.clear();
				target = make_text();
			}

			//表示
			scorefont(U"残り{}秒　スコア{}"_fmt((int)time+1,score+input.size())).draw(10, 10);
			if (flag2) {
				font(target).draw(180, 220, ColorF{ 1.0,0.0,0.0 });
				font(input).draw(180, 220, ColorF{ 0.3,0.0,0.0 });
			}
			else {
				font(target).draw(180, 220, ColorF{ 0.0,1.0,0.0 });
				font(input).draw(180, 220, ColorF{ 0.0,0.3,0.0 });
			}
			Line{ 0,100,800,100 }.draw(12, ColorF{ 0.0,1.0,0.0 });
			flag2 = 0;
			effect.update();
			Line{ watch*800, 100, watch*800+20, 100 }.draw(12, ColorF{ 1.0,1.0,1.0 });

			//制限時間になったら
			if (time ==0) {
				mode = result;
				score += input.size();
				//新記録なら
				if (score > max) {
					TextWriter writer{ U"スコア.txt" };
					if (writer)writer.write(score);
					flag = true;
					max = score;
				}
				audio.playOneShot(volume);
			}
		}
		//結果画面***************************************************************************
		else {
			if (KeyEnter.down()) { mode = start; audio.playOneShot(volume);}
			if (flag)scorefont(U"新記録！").drawAt(400,200);
			scorefont(U"スコア{} ミス{}"_fmt(score,miss)).drawAt(400, 250);
			enter(U"Enterを押すと終了").drawAt(400, 350, ColorF{ Periodic::Jump0_1(3s) });
		}
	}
}
