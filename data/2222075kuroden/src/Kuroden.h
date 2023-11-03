#pragma once

class Player;
class Kuizuou;

class Kuroden
{
public:
	enum State {
		nomal,
	};
	Kuroden(Vec2 pos, double out_r, double in_r, double v_angle, Player* player, Vec2 textpos, Font font, Kuizuou* ou)
		:w(v_angle), player(player), texpos(textpos), font(font), ou(ou)
	{
		hp = 150;
		state = nomal;
		hantei = Circle(pos, out_r);
		nothantei = Circle(pos, in_r);
		angle = 0;
		grab = false;
		grab_angle = Vec2{ 0,0 };
		trianglePos = hantei.center + Vec2{ 45,hantei.r };
		triangle = Triangle{ Point{-20,0},Point{0,0},Point{0,-80} }.rotated(-Math::Pi/6).movedBy(trianglePos);
	}
	~Kuroden() {};

	void damage(int32 power)
	{
		hp -= power;	
	}

	void SetTex(State state, Texture texture) {
		tx.emplace(state, texture);
	}

	void AddBango(int32 num,int32 str);

	void update();
	void draw();

	int32 hp;

	int32 OutPut;
private:
	Font font;
	State state;
	Circle hantei;
	Circle nothantei;
	double w;//戻る速さ
	double angle;
	Player* player;
	HashTable<State, Texture> tx;
	Vec2 texpos;
	HashTable<int32 ,int32>bango;
	bool grab;
	Vec2 grab_angle;
	Triangle triangle;
	Vec2 trianglePos;
	const Audio dial{Resource(U"ダイヤル式の電話機のダイヤルを回す音.wav")};
	Kuizuou* ou;
};

