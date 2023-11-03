#pragma once
constexpr int32 highScore = 10;
constexpr int32 lowScore = 6;
constexpr int32 badScore = 3;

class Player;

class c_timer;

struct evalFonts {
	enum eval {
		non,
		perf,
		good,
		bad,
	}state;
	HashTable <eval,ColorF> col;
	Font font{ 30,Typeface::Medium };
	HashTable<eval, String> str;
	//一秒間描画
	c_timer* time;
};

class Notes
{
public:
	Notes(double v, Vec2 pos, int32 r,ColorF color,Line l,Player* player,Rect Window,evalFonts* font);
	~Notes();

	void update();

	void Set_vel(double v) { vel = v; };

	void draw();

	void Set_perfect_range(double perfect) { perfect_range = perfect; }
	void Set_bad_range(double bad) { bad_range = bad; }

	bool push;
	bool alive;//稼働中かどうか

private:
	evalFonts *font;
	Circle hantei;
	ColorF color;
	double vel;
	double perfect_range;
	double bad_range;
	Line line;
	Player* player;
	Rect window;
};

