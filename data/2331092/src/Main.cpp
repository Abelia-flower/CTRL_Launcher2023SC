#include <Siv3D.hpp>

struct StageData {
	int stage = 0;
	double start = -300;

	//debug
	//300

};

using App = SceneManager<String, StageData>;


class Block {
public:
	Array<RectF>blocks;
	Array<RectF>blocks_w;
	Array<RectF>blocks_w_re;
	Array<RectF>blocks_bo;
	Array<RectF>blocks_re_e;
	Array<RectF>blocks_re_p_u;
	Array<RectF>blocks_re_p_d;
	Array<RectF>blocks_w_re_p;
	// 
	Array<RectF>blocks_re_r;
	Array<RectF>blocks_re_l;
	// 
	Array<RectF>blocks_inv;
	Array<RectF>inv_stop;
	Array<RectF>blocks_goal;
	Array<RectF>item;
	Array<RectF>blocks_item;
	Array<RectF>stop;
	Array<bool>touch_item;
	RectF background{ 0,550,6000,100 };
	Array<RectF>needle;
	Array<RectF>blocks_down;
	Array<Ellipse>circle_death;

	Stopwatch stopwatch;
	Stopwatch gimmick;

	double speed = 150;
	int touch_w;
	int touch_i;
	//	double player_position;
	bool move = false;
	Array<int>inv;
	Array<bool>touch_inv;
	//const Texture kari1{ U"example/済み.jfif" };
	const Texture kumo{ U"くも.png" };
	const Texture kumokumo{ U"くもくも.png" };
	const Texture kumokumo2{ U"くもくも2.png" };
	const Texture m_s{ U"まんじゅう山小.png" };
	const Texture m_m{ U"まんじゅう山中.png" };
	const Texture m_l{ U"まんじゅう山大.png" };
	const Texture s{ U"山小.png" };
	const Texture m{ U"山中.png" };
	const Texture l{ U"山大.png" };
	const Texture goal{ U"旗.png" };
	const Audio audio_block{ U"buryun.mp3" };
	Array<Vec2>pos_k;
	Array<Vec2>pos_kk;
	Array<Vec2>pos_ms;
	Array<Vec2>pos_mm;
	Array<Vec2>pos_ml;
	Array<Vec2>pos_s;
	Array<Vec2>pos_m;
	Array<Vec2>pos_l;
	Vec2 pos_goal;

	//int num_inv = 2;
	Array<bool>flag_inv;
	bool re_r = false;
	bool re_l = false;
	double x_re = 0;
	Array<bool>touch_w_re_r;
	Array<bool>touch_w_re_l;
	double a = 1;
	bool touch_bo = false;
	bool flag = false;
	bool touch_goal = false;
	bool flag_start = false;
	double shusei = 0;
	int x = 0, y = 0;
	TextWriter writer{ U"stage.txt", OpenMode::Append };

	Block(int stage) {

		//基準用
		blocks << RectF{ 0,0,0 };

		//アイテム関係//
		if (stage == 0) {
			blocks_item << RectF{ 800,350,50 };

		}
		if (stage == 1) {
			blocks_item << RectF{ 1800,300,50 };
		}
		if (stage == 2) {
			blocks_item << RectF{ 950,200,50 };

			blocks_item << RectF{ 800 + 750,350,50 };

			blocks_item << RectF{ 2900 + 750,50,50 };
		}
		for (int i = 0; i < blocks_item.size(); i++) {
			stop << RectF{ blocks_item[i].x + 10 , blocks_item[i].y + 1 , blocks_item[i].w - 20 };
			blocks << RectF{ blocks_item[i].x, blocks_item[i].y , blocks_item[i].w };
			item << RectF{ blocks_item[i].x, blocks_item[i].y + 5, blocks_item[i].w, blocks_item[i].h };
		}

		//初期化
		for (int i = 0; i < blocks_item.size(); i++) {
			touch_item << false;
		}
		////////////////

		//for (int i = 0; i < 60; i++) {
		//	blocks << RectF{ i * 50,100,50 };
		//}
		if (stage == 0) {
			for (int i = 0; i < 12; i++) {
				for (int j = 0; j < 10; j++) {
					blocks << RectF{ -500 + j * 50,i * 50,50 };
				}
			}
			for (int i = 0; i < 20; i++) {
				blocks << RectF{ i * 50,550,50 };
			}

			blocks << RectF{ 750,350,50 };

			blocks << RectF{ 850,350,50 };

			for (int i = 0; i < 20; i++) {
				blocks << RectF{ 1000 + i * 50 ,550,50 };
			}

			blocks << RectF{ 1500,500,50 };
			blocks << RectF{ 1550,500,50 };
			blocks << RectF{ 1500,450,50 };
			blocks << RectF{ 1550,450,50 };

			blocks << RectF{ 1500,500,50 };

			for (int i = 0; i < 14; i++) {
				blocks << RectF{ 1950 + i * 50 ,550,50 };
			}

			blocks << RectF{ 1500,500,50 };

			blocks << RectF{ 2600,500,50 };

			for (int i = 0; i < 10; i++) {
				blocks << RectF{ 2650 + i * 50 ,550,50 };
				blocks << RectF{ 2650 + i * 50 ,500,50 };
			}
			blocks << RectF{ 3050,450,50 };
			blocks << RectF{ 3100,450,50 };
			blocks << RectF{ 3100,400,50 };

			blocks << RectF{ 3250,450,50 };
			blocks << RectF{ 3300,450,50 };
			blocks << RectF{ 3250,400,50 };

			for (int i = 0; i < 15; i++) {
				blocks << RectF{ 3250 + i * 50 ,550,50 };
				blocks << RectF{ 3250 + i * 50 ,500,50 };
			}

			blocks_goal << RectF{ 3650,500,50 };

			for (int i = 0; i < 12; i++) {
				for (int j = 0; j < 11; j++) {
					blocks << RectF{ 3950 + j * 50,i * 50,50 };
				}
			}

		}
		if (stage == 1) {
			for (int i = 0; i < 12; i++) {
				for (int j = 0; j < 10; j++) {
					blocks << RectF{ -500 + j * 50,i * 50,50 };
				}
			}
			for (int i = 0; i < 16; i++) {
				blocks << RectF{ i * 50,550,50 };
			}

			blocks << RectF{ 700,500,50 };

			for (int i = 0; i < 8; i++) {
				blocks << RectF{ 800 + i * 50,550,50 };
			}
			blocks << RectF{ 1150,500,50 };

			blocks << RectF{ 1150,300,50 };

			needle << RectF{ 1150,350,25 };
			needle << RectF{ 1175,350,25 };

			for (int i = 0; i < 8; i++) {
				blocks << RectF{ 1200 + i * 50,550,50 };
			}
			for (int i = 0; i < 4; i++) {
				blocks << RectF{ 1550,550 - i * 50,50 };
			}
			for (int i = 0; i < 10; i++) {
				blocks << RectF{ 1600 + i * 50,550,50 };
			}
			blocks << RectF{ 2000,500,50 };
			blocks << RectF{ 2050,500,50 };
			blocks << RectF{ 2050,450,50 };

			blocks << RectF{ 2200,500,50 };
			blocks << RectF{ 2200,450,50 };
			blocks << RectF{ 2250,500,50 };
			for (int i = 0; i < 16; i++) {
				blocks << RectF{ 2200 + i * 50,550,50 };
			}

			blocks_goal << RectF{ 2810,500,40 };

			for (int i = 0; i < 12; i++) {
				for (int j = 0; j < 11; j++) {
					blocks << RectF{ 3000 + j * 50,i * 50,50 };
				}
			}
		}
		if (stage == 2) {
			for (int i = 0; i < 12; i++) {
				for (int j = 0; j < 10; j++) {
					blocks << RectF{ -500 + j * 50,i * 50,50 };
				}
			}

			for (int i = 0; i < 10; i++) {
				blocks << RectF{ i * 50,550,50 };
			}
			blocks << RectF{ 400,500,50 };
			blocks << RectF{ 450,500,50 };
			blocks << RectF{ 450,450,50 };

			blocks_inv << RectF{ 500,300,50 };
			blocks_inv << RectF{ 500,250,50 };


			for (int i = 0; i < 4; i++) {
				blocks << RectF{ 700 + i * 50,550,50 };
			}

			for (int i = 0; i < 5; i++) {
				if (i != 2) {
					blocks << RectF{ 850 + i * 50,200,50 };
				}
			}
			blocks_inv << RectF{ 1100,00,50 };

			blocks << RectF{ 750,350,50 };
			blocks << RectF{ 800,350,50 };

			blocks_inv << RectF{ 850,350,50 };
			blocks_inv << RectF{ 900,350,50 };
			blocks_inv << RectF{ 950,350,50 };
			blocks_inv << RectF{ 1000,350,50 };
			blocks_inv << RectF{ 1050,350,50 };

			blocks << RectF{ 1100,350,50 };
			blocks << RectF{ 1150,350,50 };
			blocks_inv << RectF{ 1200,150,50 };

			for (int i = 0; i < 5; i++) {
				blocks << RectF{ 1050 + i * 50,550,50 };
			}
			blocks_inv << RectF{ 1300,400,50 };




			for (int i = 0; i < 7; i++) {
				blocks << RectF{ 1450 + i * 50,550,50 };
			}
			blocks_inv << RectF{ 1400,350,50 };
			blocks_inv << RectF{ 1450,350,50 };
			blocks << RectF{ 1500,350,50 };
			blocks << RectF{ 1600,350,50 };


			blocks << RectF{ 1700,500,50 };
			blocks << RectF{ 1750,500,50 };
			blocks << RectF{ 1750,450,50 };
			for (int i = 0; i < 4; i++) {
				blocks_inv << RectF{ 1800 + i * 50,300,50 };
			}
			for (int i = 0; i < 6; i++) {
				blocks_inv << RectF{ 1950,350 + i * 50,50 };
				blocks_inv << RectF{ 1950,250 - i * 50,50 };
			}
			//	for (int i = 0; i < 1; i++) {
			//		blocks_inv << RectF{ 1200,100 - i * 50,50 };
			//	}
			blocks << RectF{ 2000,500,50 };
			blocks << RectF{ 2000,450,50 };
			blocks << RectF{ 2050,500,50 };

			for (int i = 0; i < 4; i++) {
				blocks << RectF{ 2000 + i * 50,550,50 };
			}

			blocks << RectF{ 2300,400,50 };
			blocks << RectF{ 2350,400,50 };

			blocks << RectF{ 2550,300,50 };
			blocks << RectF{ 2600,300,50 };

			blocks << RectF{ 2850,200,50.01 };
			blocks << RectF{ 2900,200,50.02 };

			blocks << RectF{ 2800,500,50 };
			blocks << RectF{ 2850,500,50 };

			needle << RectF{ 2800,475,25.01 };
			needle << RectF{ 2825,475,25.01 };
			needle << RectF{ 2850,475,25.01 };
			needle << RectF{ 2875,475,25.01 };

			blocks << RectF{ 3100,400,50 };
			blocks << RectF{ 3150,400,50 };

			for (int i = 0; i < 14; i++) {
				blocks << RectF{ 3450 + i * 50,550,50 };
			}

			blocks_inv << RectF{ 3650,400,50 };
			blocks_inv << RectF{ 3650,250,50 };

			//for (int i = 0; i < 5; i++) {
			//	blocks << RectF{ 4150,350 + 50 * i,50 };
			//}

			for (int i = 0; i < 6; i++) {
				blocks << RectF{ 4150 + i * 50,550,50 };
			}

			/*壊れブロック
			for (int i = 0; i < 4; i++) {
				if (i % 2 == 0) {
					blocks << RectF{ 4450 + i * 50,550,50.01 };
				}
				else {
					blocks << RectF{ 4450 + i * 50,550,50.02 };
				}
			}*/
			for (int i = 0; i < 4; i++) {
				blocks << RectF{ 4450 + i * 50,550,50 };
			}


			for (int i = 0; i < 62; i++) {
				needle << RectF{ 4450 + i * 25,525,25.01 };
			}


			for (int i = 0; i < 27; i++) {
				blocks << RectF{ 4650 + i * 50,550,50 };
			}

			blocks << RectF{ 4300,400,50 };

			blocks << RectF{ 4500,350,50 };

			for (int i = 0; i < 2; i++) {
				for (int j = 0; j < 3; j++) {
					blocks << RectF{ 4600 + i * 50, 0 + j * 50,50 };
				}
			}

			blocks << RectF{ 4700,350,50 };

			blocks << RectF{ 4900,200,50 };

			blocks << RectF{ 5150,450,50 };

			blocks << RectF{ 5400,400,50 };

			for (int i = 0; i < 3; i++) {
				for (int j = 0; j < 5; j++) {
					blocks << RectF{ 5450 + i * 50, 0 + j * 50,50 };
				}
			}

			blocks << RectF{ 5600,400,50 };

			blocks << RectF{ 6000,400,50 };

			for (int i = 0; i < 5; i++) {
				blocks << RectF{ 6050 + i * 50,400,50 };
			}

			blocks_goal << RectF{ 6160,350,40 };

			for (int i = 0; i < 12; i++) {
				for (int j = 0; j < 11; j++) {
					blocks << RectF{ 6300 + j * 50,i * 50,50 };
				}
			}

		}

		//blocks_goal << RectF{ 2000,450,50 };



		//blocks_w << RectF{ block_item.x + block_item.w,block_item.y + 5,3,block_item.h - 5 };

		for (int i = 0; i < blocks.size(); i++) {
			blocks_re_e << RectF{ blocks[i].x - 5,(blocks[i].y + 1),blocks[i].w + 10,1 };
		}
		//屋根
		for (int i = 0; i < blocks.size(); i++) {
			blocks_re_p_u << RectF{ blocks[i].x - 3 ,(blocks[i].y + 1),blocks[i].w + 5,5 };
		}

		//底
		for (int i = 0; i < blocks.size(); i++) {
			blocks_re_p_d << RectF{ blocks[i].x + 1 ,(blocks[i].y + blocks[i].h),blocks[i].w - 2,1 };
		}
		//底
		for (int i = 0; i < blocks.size(); i++) {
			blocks_bo << RectF{ blocks[i].x + 1 ,blocks[i].y + blocks[i].h,blocks[i].w - 2 ,3 };
		}
		//壁
		for (int i = 0; i < blocks.size(); i++) {
			blocks_w << RectF{ blocks[i].x - 3 ,blocks[i].y + 2,5,blocks[i].w - 2 };
			blocks_w << RectF{ blocks[i].x - 2 + blocks[i].w,blocks[i].y + 2,5,blocks[i].w - 2 };
		}
		//敵壁
		for (int i = 0; i < blocks.size(); i++) {
			blocks_w_re << RectF{ blocks[i].x - 3.1 ,blocks[i].y + 2,5,blocks[i].w - 2 };
			blocks_w_re << RectF{ blocks[i].x - 1.9 + blocks[i].w,blocks[i].y + 2,5,blocks[i].w - 2 };
		}
		//透明の判定用
		for (int i = 0; i < blocks_inv.size(); i++) {
			inv_stop << RectF{ blocks_inv[i].x,blocks_inv[i].y,50,45 };
		}
		//雲判定
		if (stage == 2) {
			circle_death << Ellipse{ 2360 + 750,145,70,45 };
			circle_death << Ellipse{ 2400 + 750,180,50,20 };
		}

		//修正

		////////////////
		for (int i = 0; i < blocks.size(); i++) {
			blocks_re_l << RectF{ blocks[i].x - 3			 , blocks[i].y + 2	,5	,blocks[i].w - 2 };
		}
		for (int i = 0; i < blocks.size(); i++) {
			blocks_re_r << RectF{ blocks[i].x - 2 + blocks[i].w, blocks[i].y + 2 ,5	,blocks[i].w - 2 };
		}
		////////////////
		//初期化////
		for (int i = 0; i < blocks_inv.size(); i++) {
			inv << 0;
			touch_inv << false;
			flag_inv << false;
		}

		for (int i = 0; i < blocks_w_re_p.size(); i++) {
			touch_w_re_r << false;
		}
		for (int i = 0; i < blocks_w_re_p.size(); i++) {
			touch_w_re_l << false;
		}
		///////////
		for (int i = 0; i < blocks_re_r.size(); i++) {
			touch_w_re_r << false;
		}
		for (int i = 0; i < blocks_re_l.size(); i++) {
			touch_w_re_l << false;
		}
		///////////
		touch_w = 0;
		touch_i = 0;
		if (stage == 0) {
			for (int i = 0; i < 2; i++) {
				pos_k << Vec2{ Random(4000),Random(50,150) };
				pos_kk << Vec2{ Random(4000),Random(100,150) };
			}
			for (int i = 0; i < 1; i++) {
				pos_ms << Vec2{ Random(4000),480 };
				pos_mm << Vec2{ Random(4000),395 };
				pos_ml << Vec2{ Random(2000,4000),280 };
				pos_s << Vec2{ Random(4000),465 };
				pos_m << Vec2{ Random(4000),330 };
				pos_l << Vec2{ Random(2000),200 };
			}
		}
		if (stage == 1) {
			for (int i = 0; i < 2; i++) {
				pos_k << Vec2{ Random(3000),Random(50,150) };
				pos_kk << Vec2{ Random(3000),Random(100,150) };
			}
			for (int i = 0; i < 1; i++) {
				pos_ms << Vec2{ Random(3000),480 };
				pos_mm << Vec2{ Random(3000),395 };
				pos_ml << Vec2{ Random(1500,3000),280 };
				pos_s << Vec2{ Random(3000),465 };
				pos_m << Vec2{ Random(3000),330 };
				pos_l << Vec2{ Random(1500),200 };
			}
		}
		if (stage == 2) {
			for (int i = 0; i < 2; i++) {
				pos_k << Vec2{ Random(6300),Random(50,150) };
				pos_kk << Vec2{ Random(6300),Random(100,150) };
			}
			for (int i = 0; i < 1; i++) {
				pos_ms << Vec2{ Random(6300),480 };
				pos_mm << Vec2{ Random(6300),395 };
				pos_ml << Vec2{ Random(3150,6300),280 };
				pos_s << Vec2{ Random(6300),465 };
				pos_m << Vec2{ Random(6300),330 };
				pos_l << Vec2{ Random(3150),200 };
			}
		}

		if (stage == 2) {
			pos_kk << Vec2{ 5220,0 };
			pos_kk << Vec2{ 4950,250 };
			pos_kk << Vec2{ 5220,75 };
			pos_kk << Vec2{ 4950,350 };
			pos_kk << Vec2{ 5220,150 };
			pos_kk << Vec2{ 4950,450 };


			pos_kk << Vec2{ 2290 + 750,100 };
		}
		if (stage == 0) {
			pos_goal = Vec2{ 3650,443 };
		}
		if (stage == 1) {
			pos_goal = Vec2{ 2800,493 };
		}
		if (stage == 2) {
			pos_goal = Vec2{ 6150,393 - 50 };
		}

	}

	void scroll(int i, double speed, int stage) {
		double deltaTimeB = Scene::DeltaTime();
		if (i == 0) {
			for (auto& blocks : blocks)
			{
				blocks.x -= speed;
			}

			for (auto& blocks_w : blocks_w)
			{
				blocks_w.x -= speed;
			}
			for (auto& blocks_item : blocks_item) {
				blocks_item.x -= speed;
			}

			for (auto& item : item) {
				item.x -= speed;
			}
			for (auto& stop : stop) {
				stop.x -= speed;
			}
			for (auto& blocks_re_e : blocks_re_e)
			{
				blocks_re_e.x -= speed;
			}
			for (auto& blocks_re_p_u : blocks_re_p_u)
			{
				blocks_re_p_u.x -= speed;
			}
			for (auto& blocks_re_p_d : blocks_re_p_d)
			{
				blocks_re_p_d.x -= speed;
			}
			for (auto& blocks_inv : blocks_inv)
			{
				blocks_inv.x -= speed;
			}
			for (auto& blocks_w_re_p : blocks_w_re_p) {
				blocks_w_re_p.x -= speed;
			}
			//////
			for (auto& blocks_re_r : blocks_re_r) {
				blocks_re_r.x -= speed;
			}for (auto& blocks_re_l : blocks_re_l) {
				blocks_re_l.x -= speed;
			}
			//////
			for (auto& blocks_bo : blocks_bo)
			{
				blocks_bo.x -= speed;
			}
			for (auto& blocks_goal : blocks_goal)
			{
				blocks_goal.x -= speed;
			}
			for (auto& blocks_w_re : blocks_w_re)
			{
				blocks_w_re.x -= speed;
			}
			for (int i = 0; i < pos_k.size(); i++) {
				pos_k[i].x -= speed;
				pos_kk[i].x -= speed;
			}
			if (stage == 2) {
				pos_kk[pos_kk.size() - 1].x -= speed;
				pos_kk[pos_kk.size() - 2].x -= speed;
				pos_kk[pos_kk.size() - 3].x -= speed;
				pos_kk[pos_kk.size() - 4].x -= speed;
				pos_kk[pos_kk.size() - 5].x -= speed;
				pos_kk[pos_kk.size() - 6].x -= speed;
				pos_kk[pos_kk.size() - 7].x -= speed;

			}
			for (int i = 0; i < pos_ms.size(); i++) {
				pos_ms[i].x -= speed;
				pos_mm[i].x -= speed;
				pos_ml[i].x -= speed;
				pos_s[i].x -= speed;
				pos_m[i].x -= speed;
				pos_l[i].x -= speed;
			}
			pos_goal.x -= speed;

			background.x -= speed;

			for (auto& k : needle)
			{
				k.x -= speed;
			}
			for (auto& k : inv_stop) {
				k.x -= speed;
			}
			for (auto& k : blocks_down) {
				k.x -= speed;
			}
			for (auto& k : circle_death) {
				k.x -= speed;
			}
		}
		else {
			for (auto& blocks : blocks)
			{
				blocks.x += speed;
			}
			for (auto& blocks_w : blocks_w)
			{
				blocks_w.x += speed;
			}
			for (auto& blocks_item : blocks_item) {
				blocks_item.x += speed;
			}

			for (auto& item : item) {
				item.x += speed;
			}

			for (auto& stop : stop) {
				stop.x += speed;
			}
			for (auto& blocks_re_e : blocks_re_e)
			{
				blocks_re_e.x += speed;
			}
			for (auto& blocks_re_p_u : blocks_re_p_u)
			{
				blocks_re_p_u.x += speed;
			}
			for (auto& blocks_re_p_d : blocks_re_p_d)
			{
				blocks_re_p_d.x += speed;
			}
			for (auto& blocks_inv : blocks_inv)
			{
				blocks_inv.x += speed;
			}
			for (auto& blocks_w_re_p : blocks_w_re_p)
			{
				blocks_w_re_p.x += speed;
			}
			//////
			for (auto& blocks_re_r : blocks_re_r) {
				blocks_re_r.x += speed;
			}for (auto& blocks_re_l : blocks_re_l) {
				blocks_re_l.x += speed;
			}
			//////
			for (auto& blocks_bo : blocks_bo)
			{
				blocks_bo.x += speed;
			}
			for (auto& blocks_goal : blocks_goal)
			{
				blocks_goal.x += speed;
			}
			for (auto& blocks_w_re : blocks_w_re)
			{
				blocks_w_re.x += speed;
			}

			for (int i = 0; i < pos_k.size(); i++) {
				pos_k[i].x += speed;
				pos_kk[i].x += speed;
			}
			if (stage == 2) {
				pos_kk[pos_kk.size() - 1].x += speed;
				pos_kk[pos_kk.size() - 2].x += speed;
				pos_kk[pos_kk.size() - 3].x += speed;
				pos_kk[pos_kk.size() - 4].x += speed;
				pos_kk[pos_kk.size() - 5].x += speed;
				pos_kk[pos_kk.size() - 6].x += speed;
				pos_kk[pos_kk.size() - 7].x += speed;

			}
			for (int i = 0; i < pos_ms.size(); i++) {
				pos_ms[i].x += speed;
				pos_mm[i].x += speed;
				pos_ml[i].x += speed;
				pos_s[i].x += speed;
				pos_m[i].x += speed;
				pos_l[i].x += speed;
			}
			pos_goal.x += speed;

			background.x += speed;

			for (auto& k : needle)
			{
				k.x += speed;
			}
			for (auto& k : inv_stop) {
				k.x += speed;
			}
			for (auto& k : blocks_down) {
				k.x += speed;
			}
			for (auto& k : circle_death) {
				k.x += speed;
			}
		}
	}

	void update(RectF player_, int right_, double jumpframe_, double v_, bool jump_, Array<bool>touch_w_e_r_, Array<bool>touch_w_e_l_,
		bool Up_, int stage, double start) {
		double deltaTimeB = Scene::DeltaTime();

		//中間
		if (flag_start == false) {
			scroll(0, start, stage);
			flag_start = true;
		}
		////debug
		/*
		if (MouseL.down()) {
			for (int i = 0; i < 100; i++) {
				if (i * 50 < Cursor::Pos().x && Cursor::Pos().x <= (i + 1) * 50) {
					x = i * 50;
				}
				if (i * 50 < Cursor::Pos().y && Cursor::Pos().y <= (i + 1) * 50) {
					y = i * 50;
				}
			}

			writer << U"blocks << RectF{" << x << U"," << y << U", 50 }";
			blocks << RectF{ x,y,50 };
		}
		//Print <<U"player.x : " << - blocks[0].x +373 ;
		//Print << U"player.y : " << player_.y;
		*/


		//移動
		if (KeyRight.pressed() && (touch_w == 0 || right_ == 0))
		{
			if (speed < 210) {
				speed += 10;
			}
			if (speed > 210) {
				speed = 210;
			}
		}

		//左
		if (KeyLeft.pressed() && (touch_w == 0 || right_ == 1))
		{
			if (-210 < speed) {
				speed -= 10;
			}
			if (speed < -210) {
				speed = -210;
			}
		}
		if (!KeyRight.pressed() && !KeyLeft.pressed()) {
			speed *= 0.7;
		}

		if (speed > 0) {
			scroll(0, deltaTimeB * speed, stage);
		}
		else {
			scroll(1, deltaTimeB * -speed, stage);
		}


		//x座標の修正(埋まるのを防ぐ
		for (int i = 0; i < blocks_re_r.size(); i++) {
			if (player_.intersects(blocks_re_r[i])) {
				touch_w_re_r[i] = true;
			}
			else {
				touch_w_re_r[i] = false;
			}
			if (player_.intersects(blocks_re_l[i])) {
				touch_w_re_l[i] = true;
			}
			else {
				touch_w_re_l[i] = false;
			}

		}

		for (int i = 0; i < blocks_re_r.size(); i++) {
			if (touch_w_re_r[i] == true) {
				shusei = -speed * deltaTimeB - (blocks_re_r[i].x + blocks_re_r[i].w - player_.x);
				scroll(0, (blocks_re_r[i].x + blocks_re_r[i].w) - player_.x, stage);

				//Print << U"プレイヤーを右に修正";
			}

			if (touch_w_re_l[i] == true) {
				shusei = speed * deltaTimeB - (player_.x + player_.w - blocks_re_l[i].x);
				scroll(1, (player_.x + player_.w) - (blocks_re_l[i].x), stage);

				//Print << U"プレイヤーを左に修正";
			}
		}

		//壁の当たり
		int flag_w = 0;
		for (int block_i = 0; block_i < blocks_w.size(); block_i++)
		{
			if (blocks_w[block_i].intersects(player_))
			{
				flag_w = 1;
			}
		}
		if (flag_w == 1)
		{
			touch_w = 1;
		}
		else
		{
			touch_w = 0;
		}
		//アイテムブロックの当たり判定
		for (int i = 0; i << blocks_item.size(); i++) {
			if (blocks_item[i].intersects(player_))
			{
				touch_i = 1;
			}
			else
			{
				touch_i = 0;
			}
		}
		//透明ブロックの当たり判定
		for (int i = 0; i < blocks_inv.size(); i++)
		{
			//Print << jumpframe_;
			if (player_.intersects(blocks_inv[i]) && Up_ == true && !inv_stop[i].intersects(player_))
			{
				touch_inv[i] = true;
			}
			else {
				touch_inv[i] = false;
			}
		}
		//天井下当たり判定
		flag = false;
		for (int i = 0; i < blocks_bo.size(); i++)
		{
			if (player_.intersects(blocks_bo[i]))
			{
				flag = true;
			}
		}
		if (flag == true) {
			touch_bo = true;
		}
		else {
			touch_bo = false;
		}

		//ゴール当たり判定
		flag = false;
		for (int i = 0; i < blocks_goal.size(); i++)
		{
			if (player_.intersects(blocks_goal[i]))
			{
				flag = true;
			}
		}
		if (flag == true) {
			touch_goal = true;
		}
		else {
			touch_goal = false;
		}

		//不透明度更新
		if (stage == 2) {
			if (touch_inv[12] == true) {
				if (flag_inv[12] == false) {
					gimmick.restart();

					audio_block.playOneShot();

					blocks << RectF{ blocks_inv[12].x, blocks_inv[12].y,50 };
					blocks_re_p_d << RectF{ blocks_inv[12].x + 1 ,(blocks_inv[12].y + blocks_inv[12].h), blocks_inv[12].w - 2,1 };
					blocks_re_r << RectF{ blocks_inv[12].x - 2 + blocks_inv[12].w,  blocks_inv[12].y + 2 ,5	,blocks_inv[12].w - 2 };
					blocks_re_l << RectF{ blocks_inv[12].x - 3			 ,  blocks_inv[12].y + 2	,5	,blocks_inv[12].w - 2 };
					blocks_bo << RectF{ blocks_inv[12].x + 1 ,blocks_inv[12].y + blocks_inv[12].h,blocks_inv[12].w - 2 ,3 };
					blocks_re_p_u << RectF{ blocks_inv[12].x + 1,(blocks_inv[12].y + 1),blocks_inv[12].w - 2,5 };

					touch_w_re_r << false;
					touch_w_re_l << false;

					flag_inv[12] = true;
				}
			}
			if (flag_inv[12] == true) {
				for (int i = 12; i < 28; i++) {
					if (0.1 < gimmick.sF() && 0.1 + (i - 11.8) * 0.2 < gimmick.sF()) {
						touch_inv[i] = true;
					}
				}
			}
		}

		for (int i = 0; i < blocks_inv.size(); i++)
		{
			if (touch_inv[i] == true) {
				inv[i] = 1;
				if (flag_inv[i] == false) {
					audio_block.playOneShot();


					blocks << RectF{ blocks_inv[i].x,blocks_inv[i].y,50 };
					blocks_re_p_d << RectF{ blocks_inv[i].x + 1 ,(blocks_inv[i].y + blocks_inv[i].h),blocks_inv[i].w - 2,1 };
					blocks_re_r << RectF{ blocks_inv[i].x - 2 + blocks_inv[i].w, blocks_inv[i].y + 2 ,5	,blocks_inv[i].w - 2 };
					blocks_re_l << RectF{ blocks_inv[i].x - 3			 , blocks_inv[i].y + 2	,5	,blocks_inv[i].w - 2 };
					blocks_bo << RectF{ blocks_inv[i].x + 1 ,blocks_inv[i].y + blocks_inv[i].h,blocks_inv[i].w - 2 ,3 };
					blocks_re_p_u << RectF{ blocks_inv[i].x + 1,(blocks_inv[i].y + 1),blocks_inv[i].w - 2,5 };

					touch_w_re_r << false;
					touch_w_re_l << false;

					flag_inv[i] = true;
				}
			}

		}
		//アイテムが出る判定
		for (int i = 0; i < item.size(); i++) {
			if (item[i].intersects(player_) || touch_item[i] == true)
			{
				touch_item[i] = true;
			}
		}

	}
	void draw(RectF player_) {
		//フィールド当たり判定の描画
		for (int size_i = 0; size_i < blocks.size(); size_i++)
		{
			blocks[size_i].draw(ColorF{ 1,1,1,a });
		}

		for (int size_i = 0; size_i < blocks_w.size(); size_i++)
		{
			blocks_w[size_i].draw(ColorF{ 1,0.5,0,a });
		}

		//block_item.draw(ColorF{ 1,0.1,a });
		for (int i = 0; i < stop.size(); i++) {
			stop[i].draw(ColorF{ 0,0,0,a });
		}
		for (int size_i = 0; size_i < blocks_re_e.size(); size_i++)
		{
			blocks_re_e[size_i].draw(ColorF{ 0,1,0,a });
		}
		for (int size_i = 0; size_i < blocks_re_p_u.size(); size_i++)
		{
			blocks_re_p_u[size_i].draw(ColorF{ 1,0,0,a });
		}
		for (int size_i = 0; size_i < blocks_re_p_d.size(); size_i++)
		{
			blocks_re_p_d[size_i].draw(ColorF{ 1,1,0,a });
		}
		for (int i = 0; i < blocks_inv.size(); i++) {
			blocks_inv[i].draw(ColorF(1, 1, 1, inv[i]));
		}
		for (int i = 0; i < blocks_w_re_p.size(); i++) {
			blocks_w_re_p[i].draw(ColorF{ 0,0,0,a });
		}
		for (int i = 0; i < blocks_re_r.size(); i++) {
			blocks_re_r[i].draw(ColorF{ 0,0,0,a });
		}
		for (int i = 0; i < blocks_re_l.size(); i++) {
			blocks_re_l[i].draw(ColorF{ 0,0,0,a });
		}

		for (int i = 0; i < blocks_bo.size(); i++) {
			blocks_bo[i].draw(ColorF{ 0,0.3,0.5,a });
		}
		for (int i = 0; i < blocks_goal.size(); i++) {
			blocks_goal[i].draw(ColorF{ 0,0,0,a });
		}
		for (int i = 0; i < needle.size(); i++) {
			needle[i].draw(ColorF{ 1,1,1,a });
		}
		for (int i = 0; i < blocks_inv.size(); i++) {
			inv_stop[i].draw(ColorF{ 1,1,1,a });
		}
		for (int i = 0; i < blocks_down.size(); i++) {
			blocks_down[i].draw(ColorF{ 1,1,1,a });
		}
		for (int i = 0; i < circle_death.size(); i++) {
			circle_death[i].draw(ColorF{ 1,1,1,0.7 });
		}
	}

	void draw2(int stage, bool death_) {
		for (int i = 0; i < pos_k.size(); i++) {
			kumo.scaled(0.3).draw(pos_k[i]);
			kumokumo.scaled(0.4).draw(pos_kk[i]);
		}
		for (int i = 0; i < pos_ms.size(); i++) {
			l.scaled(0.9).draw(pos_l[i]);
			m_l.scaled(0.9).draw(pos_ml[i]);
			m.scaled(0.6).draw(pos_m[i]);
			m_m.scaled(0.6).draw(pos_mm[i]);
			s.scaled(0.3).draw(pos_s[i]);
			m_s.scaled(0.3).draw(pos_ms[i]);

		}
		if (stage == 2) {
			kumokumo.scaled(0.45).draw(pos_kk[pos_kk.size() - 1]);
			if (death_ == true) {
				kumokumo2.scaled(0.45).draw(pos_kk[pos_kk.size() - 1]);
			}
			kumokumo.scaled(0.4).draw(pos_kk[pos_kk.size() - 2]);
			kumokumo.scaled(0.4).draw(pos_kk[pos_kk.size() - 3]);
			kumokumo.scaled(0.4).draw(pos_kk[pos_kk.size() - 4]);
			kumokumo.scaled(0.4).draw(pos_kk[pos_kk.size() - 5]);
			kumokumo.scaled(0.4).draw(pos_kk[pos_kk.size() - 6]);
			kumokumo.scaled(0.4).draw(pos_kk[pos_kk.size() - 7]);

		}
		goal.scaled(0.9).draw(pos_goal);
	}

};

class Player {
public:
	double animation_time = Periodic::Square0_1(2s);
	Stopwatch stopwatch_{ StartImmediately::Yes };
	Stopwatch jumptime;
	//Circle circle_h{ 100,450,49 };
	RectF player{ 400 - 24,450,48,80 };
	double jumpframe;
	int right;
	double v = 0;
	double vy = 0;
	bool jump = false;
	bool touch_f = false;
	double y = 450;
	double up = 0;
	bool Up = false;

	const Texture anna2_n1{ U"アンナちゃん2_n1.1.png" };
	const Texture anna2_n2{ U"アンナちゃん2_n2.png" };
	const Texture anna2_j1{ U"アンナちゃん2_j1.png" };
	const Texture anna2_j2{ U"アンナちゃん2_j2.png" };
	const Texture anna2_j3{ U"アンナちゃん2_j3.png" };
	const Texture anna2_j4{ U"アンナちゃん2_j4.png" };
	const Texture anna2_w1{ U"アンナちゃん2_w1.1.png" };
	const Texture anna2_w2{ U"アンナちゃん2_w2.1.png" };

	const Texture anna2l_n1{ U"アンナちゃん2左_n1.1.png" };
	const Texture anna2l_n2{ U"アンナちゃん2左_n2.png" };
	const Texture anna2l_j1{ U"アンナちゃん2左_j1.png" };
	const Texture anna2l_j2{ U"アンナちゃん2左_j2.png" };
	const Texture anna2l_j3{ U"アンナちゃん2左_j3.png" };
	const Texture anna2l_j4{ U"アンナちゃん2左_j4.png" };
	const Texture anna2l_w1{ U"アンナちゃん2左_w1.1.png" };
	const Texture anna2l_w2{ U"アンナちゃん2左_w2.1.png" };

	const Audio audio_block{ U"buryun.mp3" };

	//const Audio audio1{ U"8bitジャンプ.mp3" };

	Player() {
		//Circle circle_h{ 100,450,49 };
		//RectF player{ 100,100,100,100 };
		jumpframe = 0;
		right = 1;
	}



	void update(int touch_i_,/*  player_position_,*/  Array<RectF>blocks_re_p_u_, Array<RectF>blocks_re_p_d_, bool jump_,
		Array<bool>touch_inv_, Array<RectF>blocks_, bool touch_bo_) {

		double deltaTime = Scene::DeltaTime();
		//床との当たり判定
		int flag_h = 0;
		for (int block_i = 0; block_i < blocks_.size(); block_i++)
		{
			if (blocks_[block_i].intersects(player))
			{
				flag_h = 1;
				//player_position = blocks[block_i].y;
			}
		}
		if (flag_h == 1)
		{
			touch_f = 1;
		}
		else
		{
			touch_f = 0;
		}
		//重力
		if (touch_f == 0)
		{
			if (v == 0) {
				player.y += 5;
			}
			else {
				player.y += 8;
			}

		}



		//向きの判定
		if (KeyRight.pressed())
		{
			right = 1;
		}
		if (KeyLeft.pressed())
		{
			right = 0;
		}
		//ジャンプ
		//jumpset
		if (KeyUp.down() && (touch_f == 1 || jump_ == true)) {
			v = 12;
			jumptime.restart();
		}
		else if (jump_ == true) {
			v = 12;
			jumptime.restart();
		}
		//床当たり判定
		flag_h = 0;
		for (int block_i = 0; block_i < blocks_.size(); block_i++)
		{
			if (blocks_[block_i].intersects(player))
			{
				flag_h = 1;
				//player_position = blocks[block_i].y;
			}
		}
		if (flag_h == 1)
		{
			touch_f = 1;
		}
		else
		{
			touch_f = 0;
		}
		//add
	//	Print << v;
		if ((touch_f == 0 && touch_bo_ == false) || v == 12/*(max)*/) {
			if (0s < jumptime && jumptime < 0.45s && KeyUp.pressed() && touch_bo_ == false) {
				player.y -= v + 1.1;
			}
			//up
			else if (v > 0) {
				player.y -= v;
				//v_sub
				v -= 0.25;
			}
			//ジャンプ強制終了
		}
		else if (Up == false) {
			v = 0;
			//		Print << U"a";
		}
		else if (touch_bo_ == true) {
			v /= 3;
			audio_block.playOneShot();
		}

		//Print << v;


		//床との当たり判定
		for (int block_i = 0; block_i < blocks_.size(); block_i++)
		{
			if (blocks_[block_i].intersects(player))
			{
				flag_h = 1;
				//player_position = blocks[block_i].y;
			}
		}
		if (flag_h == 1)
		{
			touch_f = 1;
		}
		else
		{
			touch_f = 0;
		}

		//y座標の修正
	//check
		up = y - player.y;
		y = player.y;
		if (up > 0) {
			Up = true;
		}
		else {
			Up = false;
		}
		//Print << Up;
		if (touch_f == 1)
		{


			for (int i = 0; i < blocks_re_p_u_.size(); i++)
			{
				if (player.intersects(blocks_re_p_u_[i]) && Up == false) {
					//	Print << blocks_re_p_u_[i].y;
					player.y = (blocks_re_p_u_[i].y) - player.h;
					//	Print << U"上";
				}

				if (player.intersects(blocks_re_p_d_[i])) {
					player.y = (blocks_re_p_d_[i].y) + blocks_re_p_d_[i].h - 1;
					//	Print << U"下";
						//Print << U"b" << blocks_re_p_d_[i].y + blocks_re_p_d_[i].h;
						//Print << U"p" << player.y;

				}
			}
			//Print << player.y + player.h;

		}

		//Print << stopwatch_.sF();
		//Print << U"数値: {}"_fmt(deltaTimeP_);
	}
	void draw() {
		player.draw(ColorF{ 1,1,1,1 });

	}
	void draw2() {
		//モーション
		double animation_time = Periodic::Square0_1(2.5s);
		double animation_time_w = Periodic::Sine0_1(0.5s);
		double deltaTimeP_ = Scene::DeltaTime();

		if (touch_f == 1 && right == 1)
		{
			//モーション歩行右
			if (KeyRight.pressed())
			{
				if (animation_time_w >= 0.5)
				{
					anna2_w1.scaled(0.17).draw(player.x - 20, player.y - 7);
				}
				else
				{
					anna2_w2.scaled(0.17).draw(player.x - 20, player.y - 7);
				}
			}
			//モーション待機右
			else {
				if (animation_time == 0.0)
				{
					anna2_n2.scaled(0.17).draw(player.x - 20, player.y - 9);
				}
				else
				{
					anna2_n1.scaled(0.17).draw(player.x - 20, player.y - 8);
				}
			}
		}
		else if (touch_f == 1 && right == 0)
		{
			//モーション歩行左
			if (KeyLeft.pressed())
			{
				if (animation_time_w >= 0.5)
				{
					anna2l_w1.scaled(0.17).draw(player.x - 20, player.y - 7);
				}
				else
				{
					anna2l_w2.scaled(0.17).draw(player.x - 20, player.y - 7);
				}
			}
			//モーション待機左
			else {
				if (animation_time == 0.0)
				{
					anna2l_n2.scaled(0.17).draw(player.x - 20, player.y - 9);
				}
				else
				{
					anna2l_n1.scaled(0.17).draw(player.x - 20, player.y - 8);
				}
			}
		}

		//ジャンプモーション右
		else if (right == 1)
		{
			if (jumptime < 0.2s)
			{
				anna2_j1.scaled(0.17).draw(player.x - 20, player.y - 5);
			}
			else if (Up == true)
			{
				anna2_j2.scaled(0.17).draw(player.x - 20, player.y - 5);
			}
			else
			{
				anna2_j3.scaled(0.17).draw(player.x - 20, player.y - 5);
			}

		}
		//ジャンプモーション左
		else
		{
			if (jumptime < 0.2s)
			{
				anna2l_j1.scaled(0.17).draw(player.x - 20, player.y - 5);
			}
			else if (Up == true)
			{
				anna2l_j2.scaled(0.17).draw(player.x - 20, player.y - 5);
			}
			else
			{
				anna2l_j3.scaled(0.17).draw(player.x - 20, player.y - 5);
			}

		}


	}
};







class Enemy {
public:
	Array<RectF>enemys;
	Array<RectF>defeat_e;
	Array<bool>touch_w_e_r;
	Array<bool>touch_w_e_l;
	//kokokara
	Array<bool>touch_e;
	Array<bool>touch_f;
	Array<bool>right_e;
	Array<bool>defeated;
	Array<bool>flag_pop;
	Array<bool>out;
	//flag後で直す
	bool flag_e = false;
	bool flag_j = false;
	bool jump = false;

	bool flag = false;
	bool flag_r = false;
	bool flag_l = false;

	bool flag1 = false;
	bool flag2 = false;
	bool flag3 = false;
	bool flag_shu_r = false;
	bool flag_shu_l = false;

	bool flag_start = false;

	const Audio pop1{ U"pop.mp3" };



	Enemy(int stage)
	{
		//先にアイテムブロックに入ってる敵を入れる
		if (stage == 0) {
			enemys << RectF{ 800,350,50,35 };
			enemys << RectF{ 2500,450,50,35 };
		}
		if (stage == 1) {
			//enemys << RectF{ 1,260,50,35 };
			//enemys << RectF{ 310,350,50,35 };
			//enemys << RectF{ 500,450,50,35 };
			//enemys << RectF{ 725,450,50,35 };
			enemys << RectF{ 1800,315,50,35 };
			enemys << RectF{ 2500,500,50,35.1 };
		}
		if (stage == 2) {
			enemys << RectF{ 950,215,50,35 };
			enemys << RectF{ 798.7 + 750 + 0.6,360 ,50,35.1 };
			enemys << RectF{ 2898 + 750 + 2,50,50,35.2 };
			//	enemys << RectF{ 0+2000+750,0,50,35.1 };
		}
		for (int i = 0; i < enemys.size(); i++) {
			defeat_e << RectF{ enemys[i].x,enemys[i].y,enemys[i].w,5 };
			if (enemys[i].h == 35.1) {
				defeat_e[i].x -= 9999;
			}
		}

		//初期化
		for (int i = 0; i < enemys.size(); i++) {
			touch_w_e_r << false;
			touch_w_e_l << false;
			touch_e << false;
			touch_f << false;
			right_e << false;
			defeated << false;
			flag_pop << false;
			out << false;
		}

	}
	//敵の向きを返す関数
	bool Touch(int num, Array<RectF>blocks_w_re_)
	{
		for (int block_i = 0; block_i < blocks_w_re_.size(); block_i++)
		{
			if (blocks_w_re_[block_i].intersects(enemys[num]) && right_e[num] == false)
			{
				right_e[num] = true;
				//Print << U"右向け";
			}
			else if (blocks_w_re_[block_i].intersects(enemys[num]) && right_e[num] == true)
			{
				right_e[num] = false;
				//Print << U"左向け";
			}
		}
		return right_e[num];
	}
	//アイテムの中に入っているか判定
	bool In(int num, Array<RectF>stop_) {
		bool in = false;
		for (auto& stop : stop_) {
			if (enemys[num].intersects(stop)) {
				in = true;
			}
		}
		return in;
	}

	void update(int touch_w_, int right_, int speed_, Array<RectF>blocks_, Array<RectF>blocks_w_,
		RectF player_, Array<RectF>stop_, Array<bool>touch_item_, Array<RectF>blocks_re_e_, Array<RectF>blocks_w_re_p_,
		bool re_r_, bool re_l_, double x_re_, Array<bool>touch_w_re_r_, Array<bool>touch_w_re_l_,
		Array<RectF>blocks_re_r_, Array<RectF>blocks_re_l_, Array<RectF>blocks_w_re_, double shusei_,
		double start, int stage) {
		double deltaTimeE = Scene::DeltaTime();

		//ClearPrint();
		//Print << Cursor::Pos();
		//Print << Cursor::PosF();

		if (flag_start == false) {
			for (auto& k : enemys) {
				k.x -= start;
			}
			flag_start = true;
		}

		//koremo仮
		//重力
		for (auto& blocks_ : blocks_)
		{
			for (int i = 0; i < enemys.size(); i++)
				if (enemys[i].intersects(blocks_)) {
					touch_f[i] = true;

				}
		}
		for (int i = 0; i < enemys.size(); i++) {
			if (touch_f[i] == false && !In(i, stop_)) {
				enemys[i].y += 9;
				defeat_e[i].y += 9;
				//Print << U"重力";
			}
			else if (touch_f[i] == true)
			{
				touch_f[i] = false;
			}
		}

		//y座標の修正
		for (int i = 0; i < blocks_re_e_.size(); i++)
		{
			for (int j = 0; j < enemys.size(); j++)
			{
				if (blocks_re_e_[i].intersects(enemys[j]) && !In(j, stop_))
				{
					defeat_e[j].y -= (enemys[j].y + enemys[j].h) - blocks_[i].y;
					enemys[j].y -= (enemys[j].y + enemys[j].h) - blocks_[i].y;
					//Print << U"y修正";
				}
			}
		}



		//敵死亡
		jump = false;
		for (int enemy_i = 0; enemy_i < enemys.size(); enemy_i++)
		{
			if (defeat_e[enemy_i].intersects(player_))
			{
				enemys[enemy_i].x -= 9999;
				defeat_e[enemy_i].x -= 9999;
				jump = true;
				//Print << jump;
			}
			//Print << jump;
		}

		//敵の移動
		for (int i = 0; i < enemys.size(); i++)
		{
			flag1 = false;
			flag2 = false;
			flag3 = false;
			//移動
			if (/*仮0 < enemys[i].x && */ enemys[i].x < 1000)
			{

				if (Touch(i, blocks_w_re_) == true)
				{
					flag1 = true;
					for (auto& stop_ : stop_) {
						if (enemys[i].intersects(stop_)) {
							flag3 = true;
						}
					}
				}
				else
				{
					flag2 = true;
					for (auto& stop_ : stop_) {
						if (enemys[i].intersects(stop_)) {
							flag3 = true;
						}
					}
				}
			}

			if (flag1 == true && flag3 == false) {
				enemys[i].x += 1;
				defeat_e[i].x += 1;
				if (stage == 2) {
					enemys[2].x += 1.7;
					defeat_e[2].x += 1.7;
				}

			}
			if (flag2 == true && flag3 == false) {
				enemys[i].x -= 1;
				defeat_e[i].x -= 1;
			}
		}
		for (int i = 0; i < touch_item_.size(); i++) {
			//ブロックからの登場
			if (touch_item_[i] == true && flag_pop[i] == false)
			{
				flag_pop[i] = true;
				pop1.play();
			}
			if (touch_item_[i] == true && In(i, stop_) && out[i] == false) {
				enemys[i].y -= 1;
				defeat_e[i].y -= 1;
				if (!In(i, stop_)) {
					out[i] = true;
					right_e[i] = true;
					//Print << U"out";
				}
			}
		}


		flag = false;

		for (int j = 0; j < enemys.size(); j++) {
			for (int i = 0; i < blocks_re_r_.size(); i++) {
				if (enemys[j].intersects(blocks_re_r_[i]) && !In(j, stop_)) {
					//Print << U"shuusei";
					enemys[j].x += (blocks_re_r_[i].x + blocks_re_r_[i].w) - enemys[j].x;
					//defeat_e[j].x += (blocks_re_r_[i].x + blocks_re_r_[i].w) - enemys[j].x;
					flag = true;
				}
			}
			if (flag == true) {
				touch_w_e_r[j] = true;
			}
			else {
				touch_w_e_r[j] = false;
			}
		}

		flag = false;
		for (int j = 0; j < enemys.size(); j++) {
			for (int i = 0; i < blocks_re_r_.size(); i++) {
				if (enemys[j].intersects(blocks_re_l_[i]) && !In(j, stop_))
				{
					enemys[j].x -= (enemys[j].x + enemys[j].w) - (blocks_re_l_[i].x);
					//defeat_e[j].x -= (enemys[j].x + enemys[j].w) - (blocks_re_l_[i].x);
					flag = true;
				}
			}

			if (flag == true) {
				touch_w_e_l[j] = true;
			}
			else {
				touch_w_e_l[j] = false;
			}
		}
		*/

		//死亡判定修正
		for (int i = 0; i < enemys.size(); i++) {
			if (defeat_e[i].x != enemys[i].x)
				defeat_e[i].x = enemys[i].x;
			if (enemys[i].h == 35.1) {
				defeat_e[i].x -= 9999;
			}
		}


		for (int j = 0; j < enemys.size(); j++) {
			for (int i = 0; i < blocks_re_r_.size(); i++) {

				if (touch_w_e_r[j] == true) {
					//
					//Print << U"敵を右に修正";
					//Print << (blocks_re_r_[i].x + blocks_re_r_[i].w) - enemys[j].x;
				}
				if (touch_w_e_l[j] == true) {
					//
					//Print << U"敵を左に修正";
					//Print << (enemys[j].x + enemys[j].w) - (blocks_re_l_[i].x);
				}
			}
		}


		//敵スクロール関係

//判定	
		flag_r = false;
		for (auto& touch_w_re_r_ : touch_w_re_r_) {
			if (touch_w_re_r_ == true) {
				flag_r = true;
			}

		}
		flag_l = false;
		for (auto& touch_w_re_l_ : touch_w_re_l_) {
			if (touch_w_re_l_ == true) {
				flag_l = true;
			}
		}



		//壁に当たった時の修正
		if (flag_l == false) {
			flag_shu_r = false;
		}
		if (flag_l == true && flag_shu_r == false) {
			for (auto& enemys : enemys) {
				enemys.x -= shusei_;
			}
			flag_shu_r = true;
		}
		if (flag_r == false) {
			flag_shu_l = false;
		}
		if (flag_r == true && flag_shu_l == false) {
			for (auto& enemys : enemys) {
				enemys.x += shusei_;
			}
			flag_shu_l = true;
		}

		//通常スクロール
			//Print << U"e" << speed_;

			//Print << U"スクロール";
		if (flag_l == false) {
			if (speed_ > 0) {

				for (auto& enemys : enemys)
				{

					enemys.x -= (deltaTimeE * speed_);

				}

				for (auto& defeat_e : defeat_e)
				{
					defeat_e.x -= (deltaTimeE * speed_);
				}
			}
		}

		//Print << U"スクロール";
		//Print << U"e" << speed_;
		if (flag_r == false) {
			if (speed_ < 0) {
				for (auto& enemys : enemys)
				{
					enemys.x += (deltaTimeE * -speed_);

				}
				for (auto& defeat_e : defeat_e)
				{
					defeat_e.x += (deltaTimeE * -speed_);
				}
			}
		}
	}

	void draw() {

		for (int i = 0; i < enemys.size(); i++) {
			enemys[i].draw();
			defeat_e[i].draw(ColorF(0, 0, 0));
		}


	}
};

class Title : public App::Scene {
public:

	RectF start{ 513,466,270,51 };
	RectF credit{ 513,534.5,270,51 };
	RectF rect0{ 20 + 50 + 20,120,240,170 };
	RectF rect1{ 300 + 150,120,240,170 };
	RectF rect2{ 270,380,240,170 };
	const Font font{ 40 };
	const Font font2{ 39 };
	const Font font3{ 100 };
	bool window = false;
	bool window_c = false;

	const Texture title{ U"Title.jpeg" };
	const Texture stage0{ U"stage0.png" };
	const Texture stage1{ U"stage1.png" };
	const Texture stage2{ U"stage2.png" };


	const Audio click{ U"選択.wav" };
	const Audio cancel{ U"キャンセル.wav" };

	Title(const InitData& init)
		:IScene{ init }
	{

	}

	void update() override {
		//Print << getData().stage;
		//Print << Cursor::Pos();
		title.scaled(0.5).draw();
		//font3(U"β版").draw(140, 180);

		//start.drawFrame(0,3,Color{ 220,20,60,122 });
		start.draw(Color{ 0,0,0,0 });

		//描画toka
		if (start.mouseOver() && window == false) {
			start.drawFrame(0, 3, Color{ 220,20,60,128 });
		}
		if (credit.mouseOver() && window_c == false) {
			credit.drawFrame(0, 3, Color{ 220,20,60,128 });
		}

		if (credit.leftClicked() || window_c == true) {
			RectF{ 0,0,800,600 }.draw(Color{ 101,20,63,128 });

			font2(U"音楽　イワシロ音楽素材\n　　　URL:https://iwashiro-sounds.work/\n　　　魔王魂\n\n効果音　Springin’ Sound Stock\n\nイラスト　妹、姉"
			).draw();


			window_c = true;
		}

		if (start.leftClicked() || window == true) {
			RectF{ 0,0,800,600 }.draw(Color{ 101,20,63,128 });

			font(U"チュートリアル").draw(70, 50);
			if (rect0.mouseOver()) {
				rect0.drawFrame(0, 3, Color{ 220,20,60,128 });
			}
			stage0.scaled(0.2).draw(rect1.x, rect1.y);

			if (getData().stage == 0) {
				font(U"　？？？").draw(475, 50);
				RectF{ rect1.x,rect1.y,240,170 }.draw(Color{ 0,0,0,255 });
			}
			else {
				font(U"ステージ1").draw(475, 50);
			}
			stage0.scaled(0.242).draw(rect0.x, rect0.y);
			if (getData().stage == 1 || getData().stage == 2) {
				if (rect1.mouseOver()) {
					rect1.drawFrame(0, 3, Color{ 220,20,60,128 });
				}
				stage1.scaled(0.2).draw(rect1.x, rect1.y);
			}
			if (getData().stage == 0 || getData().stage == 1) {
				font(U"　       ？？？").draw(210, 300);
			}
			else {
				font(U"ファイナルステージ").draw(210, 300);
			}

			if (getData().stage == 0 || getData().stage == 1) {
				RectF{ rect2.x,rect2.y,240,170 }.draw(Color{ 0,0,0,255 });
			}
			if (getData().stage == 2) {
				if (rect2.mouseOver()) {
					rect2.drawFrame(0, 3, Color{ 220,20,60,128 });
				}
				stage2.scaled(0.2).draw(rect2.x, rect2.y);
			}

			window = true;
		}
		if (MouseL.down()) {
			click.playOneShot();
		}
		if (MouseR.down()) {
			cancel.playOneShot();
			window = false;
			window_c = false;
		}

		//ステージ変更
		if (Key0.pressed()) {
			getData().stage = 0;
		}
		if (Key1.pressed()) {
			getData().stage = 1;
		}
		if (Key2.pressed()) {
			getData().stage = 2;
		}

		//シーン繊維
		if (window == true) {
			if (rect0.leftClicked()) {
				getData().stage = 0;
				changeScene(U"Game", 1s);
			}
			if (getData().stage == 1 || getData().stage == 2)
				if (rect1.leftClicked()) {
					getData().stage = 1;
					changeScene(U"Game", 1s);
				}
			if (getData().stage == 2) {
				if (rect2.leftClicked()) {
					changeScene(U"Game", 1s);
				}
			}
		}
		//if (KeySpace.pressed()) {
		//	changeScene(U"Game",0.1);
		//}
	}


};

class Game : public App::Scene
{

public:
	Player anna;

	Block floor_h{ getData().stage };

	Enemy enemy{ getData().stage };

	double deltaTime = Scene::DeltaTime();

	bool death = false;

	bool clear = false;

	const Texture anna_d{ U"アンナちゃん_d.png" };
	const Texture anna2_d{ U"アンナちゃん2右_d.png" };
	const Texture anna2l_d{ U"アンナちゃん2左_d.png" };

	Stopwatch stopwatch{ };

	int p = 0;

	bool c = false;

	bool flag = false;

	bool flag1 = false;

	double v = 0;

	double x = 0;

	double y = 0;

	const Audio audio1{ U"damage.mp3" };

	const Audio audio_clear{ U"クリア3.wav" };

	const Audio audio2{ U"death.m4a" };

	const Audio audio3{ U"iwashiro_pocket.mp3" };

	const Texture renga{ U"レンガピンク.png" };

	const Texture renga1{ U"レンガピンク壊れ1.png" };

	const Texture renga2{ U"レンガピンク壊れ2.png" };

	const Texture hatena{ U"ハテナ2.png" };

	const Texture kara{ U"カラ2.png" };

	const Texture manju{ U"まんじゅう3.png" };

	const Texture kabimanju{ U"かびまんじゅう.png" };

	const Texture mizumanju{ U"みずまんじゅう.png" };

	const Texture ne{ U"とげ.png" };

	//TextWriter writer{ U"stage.txt", OpenMode::Append };

	bool End() {
		bool end = false;
		//死亡判定

		for (int i = 0; i < enemy.enemys.size(); i++) {
			if (anna.player.y > 605 || anna.player.intersects(enemy.enemys[i]))
			{
				end = true;
			}
		}

		for (auto& k : floor_h.needle) {
			if (anna.player.intersects(k))
			{
				end = true;
			}
		}
		for (auto& k : floor_h.circle_death) {
			if (anna.player.intersects(k)) {
				end = true;
			}
		}


		return end;
	}

	Game(const InitData& init)
		:IScene{ init }
	{

	}

	void update()override
	{
		Scene::SetBackground(Palette::Lightpink);

		ClearPrint();

		/*
		if (MouseL.down()) {
			for (int i = 0; i < 100; i++) {
				if (i*50<Cursor::Pos().x && Cursor::Pos().x<=(i+1)*50) {
					x = 50;
				}
			}
			writer << x;
		}
		*/

		if (death == false)
		{
			audio3.play();

			floor_h.update(anna.player, anna.right, anna.jumpframe, anna.v, anna.jump, enemy.touch_w_e_r, enemy.touch_w_e_l,
				anna.Up, getData().stage, getData().start);

			anna.update(floor_h.touch_i, /*floor_h.player_position,*/ floor_h.blocks_re_p_u, floor_h.blocks_re_p_d, enemy.jump,
				floor_h.touch_inv, floor_h.blocks, floor_h.touch_bo);

			enemy.update(floor_h.touch_w, anna.right, floor_h.speed, floor_h.blocks, floor_h.blocks_w,
				anna.player, floor_h.stop, floor_h.touch_item, floor_h.blocks_re_e, floor_h.blocks_w_re_p,
				floor_h.re_r, floor_h.re_l, floor_h.x_re, floor_h.touch_w_re_r, floor_h.touch_w_re_l,
				floor_h.blocks_re_r, floor_h.blocks_re_l, floor_h.blocks_w_re, floor_h.shusei, getData().start, getData().stage);
		}


		//背景
		floor_h.draw2(getData().stage, death);
		floor_h.background.draw(Palette::Palevioletred);

		//当たり判定表示
		//floor_h.draw(anna.player);

		//anna.draw();

		//enemy.draw();

		//motion
		if (death == false)
		{
			anna.draw2();
		}

		if (p == 0) {
			//レンガ
			for (int i = 0; i < floor_h.blocks.size(); i++) {

				if (floor_h.blocks[i].w == 50) {
					renga.scaled(0.8).draw(floor_h.blocks[i].x, floor_h.blocks[i].y);
				}
				if (floor_h.blocks[i].w == 50.01) {
					renga1.scaled(0.8).draw(floor_h.blocks[i].x, floor_h.blocks[i].y);
				}
				if (floor_h.blocks[i].w == 50.02) {
					renga2.scaled(0.8).draw(floor_h.blocks[i].x, floor_h.blocks[i].y);
				}


			}

			//とげ
			for (int i = 0; i < floor_h.needle.size(); i++) {
				if (floor_h.needle[i].w == 25) {
					ne.scaled(0.8).flipped().draw(floor_h.needle[i].x, floor_h.needle[i].y);
				}
				if (getData().stage == 2) {

					if (floor_h.needle[i].w == 25.01) {
						//	ne.scaled(0.8).draw(floor_h.needle[i].x, floor_h.needle[i].y);
					}
					for (auto& k : floor_h.needle) {
						if (death == true && anna.player.intersects(k)) {
							for (int i = 0; i < floor_h.needle.size(); i++) {
								ne.scaled(0.8).draw(floor_h.needle[i].x, floor_h.needle[i].y);
							}
						}
					}
				}
			}
			if (getData().stage == 2) {
				for (int i = 4; i < 66; i++) {
					ne.scaled(0.8).draw(floor_h.needle[i].x, floor_h.needle[i].y);
				}
			}

			//まんじゅう
			for (int i = 0; i < enemy.enemys.size(); i++) {
				if (!enemy.right_e[i] && enemy.enemys[i].h != 35.2) {
					manju.scaled(0.87).draw(enemy.enemys[i].x, enemy.enemys[i].y);
				}
				else if (enemy.enemys[i].h != 35.2) {
					manju.mirrored().scaled(0.87).draw(enemy.enemys[i].x, enemy.enemys[i].y);
				}
				//かびまんじゅう
				if (enemy.enemys[i].h == 35.1) {
					if (!enemy.right_e[i]) {
						kabimanju.scaled(0.87).draw(enemy.enemys[i].x, enemy.enemys[i].y);
					}
					else {
						kabimanju.mirrored().scaled(0.87).draw(enemy.enemys[i].x, enemy.enemys[i].y);
					}
				}
				if (enemy.enemys[i].h == 35.2) {
					if (!enemy.right_e[i]) {
						mizumanju.scaled(0.87).draw(enemy.enemys[i].x, enemy.enemys[i].y);
					}
					else {
						mizumanju.mirrored().scaled(0.87).draw(enemy.enemys[i].x, enemy.enemys[i].y);
					}
				}
			}

			//ハテナ
			for (int i = 0; i < floor_h.blocks_item.size(); i++) {
				if (!floor_h.touch_item[i] == true)
				{
					hatena.scaled(0.098).draw(floor_h.blocks_item[i].x, floor_h.blocks_item[i].y);
				}
				else {
					kara.scaled(0.0999).draw(floor_h.blocks_item[i].x, floor_h.blocks_item[i].y);
				}
			}
			//透明
			for (int i = 0; i < floor_h.blocks_inv.size(); i++) {
				if (floor_h.inv[i] == true) {
					kara.scaled(0.0999).draw(floor_h.blocks_inv[i].x, floor_h.blocks_inv[i].y);
				}
			}
		}

		//死亡判定
		if (End() == true)
		{
			death = true;
			if (flag == false) {
				x = anna.player.x - 20;
				y = anna.player.y - 5;
				audio3.stop();
				audio1.play();

				stopwatch.start();
				flag = true;

			}

			//	Print << stopwatch;

				//死亡時ドット
			if (anna.right == 1) {
				anna2_d.scaled(0.17).draw(x, y);
			}
			else {
				anna2l_d.scaled(0.17).draw(x, y);
			}

			//死亡時アニメーション
			if (2s < stopwatch && stopwatch < 2.02s) {
				if (flag1 == false) {
					audio2.play();
					flag1 = true;
				}
				//Print << stopwatch;
				v = 5;
				y -= v;
			}
			if (2.02s < stopwatch) {

				v -= 0.15;
				y -= v;
			}
			if (3.9s < stopwatch) {
				death = false;
			}
			if (death == false) {
				changeScene(U"GameOver", 0);
			}
		}
		if (KeyShift.down()) {
			if (KeyT.down()) {
				changeScene(U"Title", 0);
			}
			if (KeyC.down()) {
				changeScene(U"Clear", 0);
			}
			if (KeyR.down()) {
				changeScene(U"Game", 0);
			}
		}

		//クリア判定
		if (floor_h.touch_goal == true) {
			if (flag == false) {
				stopwatch.restart();
				audio_clear.play();
				death = true;
				flag = true;
			}

			if (stopwatch > 3s) {
				changeScene(U"Clear", 1);
			}
		}
	}
};



class GameOver : public App::Scene
{
public:
	Font font{ FontMethod::MSDF, 48 };
	const Audio audio{ U"maou_bgm_8bit20.mp3" };
	const Texture Gameover{ U"GameOver.png" };

	GameOver(const InitData& init)
		:IScene{ init }
	{
		audio.play();

	}

	void update() override
	{
		font(U"GameOver").draw(80, 200, 200);

		Gameover.scaled(0.78).draw();

		font(U"スペースキーを押してリスタート").drawAt(20, 630, 574);


		if (KeySpace.pressed())
		{
			changeScene(U"Game", 0);
		}
	}
};
class Clear : public App::Scene
{
public:
	bool flag0 = false;
	bool flag1 = false;
	bool flag_clear1 = false;
	Font font{ FontMethod::MSDF, 48 };


	Clear(const InitData& init)
		:IScene{ init }
	{

	}

	void update() override
	{
		font(U"ステージクリア!").drawAt(90, Scene::Center() + Vec2{ 0,-100 });
		if (getData().stage == 0 || flag0 == true) {
			getData().stage = 1;
			flag0 = true;
			flag_clear1 = true;
			font(U"ステージ1が解放されました。").drawAt(40, Scene::Center());

		}
		if ((getData().stage == 1 || flag1 == true) && flag_clear1 == false) {
			flag_clear1 = false;
			getData().stage = 2;
			flag1 = true;
			font(U"ファイナルステージが解放されました。").drawAt(40, Scene::Center());
		}

		font(U"スペースキーでタイトルへ戻る").drawAt(40, 505, 550);
		if (KeySpace.pressed())
		{
			changeScene(U"Title", 0);
		}
	}

};

void Main() {
	//Scene::SetBackground(ColorF{ 1,1,1 });

	//Window::Resize(1200, 600);
	App manager;

	manager.add<Title>(U"Title");

	manager.add<Game>(U"Game");

	manager.add<GameOver>(U"GameOver");

	manager.add<Clear>(U"Clear");



	while (System::Update())
	{

		if (not manager.update())
		{
			break;
		}
	}
}
