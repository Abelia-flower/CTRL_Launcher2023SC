#pragma once
#include"Common.hpp"
class Setting : public App::Scene
{
public:
	Font title{ 90 }, font{40};
	const Texture Gear_icon{ 0xf013_icon, 100 };
	const Texture Back_icon{ 0xf0e2_icon, 40 };//戻る矢印の画像
	const Texture volume0_icon{ 0xf026_icon,50 };
	const Texture volume1_icon{ 0xf027_icon,50 };
	const Texture volume2_icon{ 0xf028_icon,50 };
	const Texture start_icon{ 0xf04b_icon,30 };

	const Point start1_pos{950,400};
	const Point start2_pos{ 950,500 };
	const Point back_pos{ 35, 35 };
	const Point back_size_pos{ 600, 700 };
	const Rect back_size_rect{ Arg::center(back_size_pos),400,50 };
	bool slider1_flg = false, slider2_flg = false;

	Setting(const InitData& init)
		: IScene{ init }
	{
		Scene::SetResizeMode(ResizeMode::Keep);
		Window::SetStyle(WindowStyle::Sizable);
	}


	void update() override
	{

		if (Circle(back_pos, 25).leftClicked()) {
			Window::SetStyle(WindowStyle::Fixed);
			changeScene(U"Start");
		}

		if (Rect{ Arg::center(600,400),420,50 }.leftClicked())slider1_flg = true;
		if (Rect{ Arg::center(600,500),420,50 }.leftClicked())slider2_flg = true;

		if(slider1_flg){
			getData().BGM_volume = (Clamp(Cursor::PosF().x,400.0,800.0)-400)/400.0;
			if(MouseL.up())slider1_flg = false;			
		}
		if (slider2_flg) {
			getData().Effect_volume = (Clamp(Cursor::PosF().x, 400.0, 800.0)-400)/400.0;
			if (MouseL.up())slider2_flg = false;
		}

		if(Circle(start1_pos,25).leftClicked()){
			//BGMを鳴らす
		}
		if (Circle(start2_pos, 25).leftClicked()) {
			//効果音を鳴らす
		}



		if (back_size_rect.leftClicked()) {
			Window::Resize(1200, 800);
		}
	}

	void draw() const override
	{
		Scene::SetBackground(ColorF{ 1.0, 0.98, 0.96 });
		Back_icon.drawAt(back_pos, Palette::Gray);
		Gear_icon.rotated(Scene::Time()*10_deg).drawAt(470, 200, Palette::Gray);
		title(U"設定").drawAt(620,200,Palette::Gray);

		//スライダー1
		font(U"音量(BGM)").draw(140, 370, Palette::Gray);

		if (getData().BGM_volume==0)volume0_icon.drawAt(870, 400, Palette::Gray);
		else if (InRange(getData().BGM_volume, 0.0, 0.5))volume1_icon.drawAt(870, 400, Palette::Gray);
		else volume2_icon.drawAt(870, 400, Palette::Gray);

		Rect{ Arg::center(600,400),400,20 }.draw(Palette::Black);
		RectF(Arg::center(getData().BGM_volume *400+400, 400), 20, 50).draw(slider1_flg ? Palette::Orange : Palette::Gray);
		start_icon.drawAt(start1_pos, Circle(start1_pos, 25).leftPressed()?Palette::Orange:Palette::Gray);


		//スライダー2
		font(U"音量(効果音)").draw(140,470,Palette::Gray);

		if (getData().Effect_volume == 0)volume0_icon.drawAt(870, 500, Palette::Gray);
		else if (InRange(getData().Effect_volume, 0.0, 0.5))volume1_icon.drawAt(870, 500, Palette::Gray);
		else volume2_icon.drawAt(870, 500, Palette::Gray);

		Rect{ Arg::center(600,500),400,20 }.draw(Palette::Black);
		RectF(Arg::center(getData().Effect_volume *400+400, 500), 20, 50).draw(slider2_flg ? Palette::Orange : Palette::Gray);
		start_icon.drawAt(start2_pos, Circle(start2_pos, 25).leftPressed() ? Palette::Orange : Palette::Gray);

		font(U"設定画面中は、手動で画面サイズを変更できます。").drawAt(600,600,Palette::Gray);
		font(U"元のサイズに戻す").drawAt(back_size_pos, back_size_rect.leftPressed() ? Palette::Black : Palette::Gray);
		back_size_rect.drawFrame(3, back_size_rect.leftPressed()?Palette::Black:Palette::Gray);
	}

private:

};
