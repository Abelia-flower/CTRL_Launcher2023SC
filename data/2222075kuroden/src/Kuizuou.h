#pragma once
#include"c_timer.h"
class Kuizuou
{
public:
	Kuizuou(bool* system) 
		:systemupd(system)
	{
		seikai = new c_timer(systemupd, 2);
		huseikai = new c_timer(systemupd, 2);
		cooltim = new c_timer(systemupd, 8);
		sengen = new c_timer(systemupd,4);
		pre_timer = new c_timer(systemupd, 12);
		cooltim->ReStartLimitTimer();
		sengen->ReStartLimitTimer();
		pre_timer->ReStartLimitTimer();
		//kuizuの構造→ [問題番号]={"問題","選択1","選択2",...,"選択n"}
		//"選択1"が答えとなる。nは最大8まで！
		kuizu.emplace(0, Array<String>{U"「跳梁■扈」　■に入る漢字は？", U"跋", U"獏", U"蹴"});
		kuizu.emplace(1, Array<String>{U"「鎧袖■触」　■に入る漢字は？",U"一", U"円", U"本"});
		kuizu.emplace(2, Array<String>{U"「魑魅■魎」　■に入る漢字は？",U"魍", U"魑", U"魎"});
		kuizu.emplace(3, Array<String>{U"「群雄■拠」　■に入る漢字は？", U"割", U"克", U"活"});
		kuizu.emplace(4, Array<String>{U"「酒池■林」　■に入る漢字は？", U"肉", U"陸", U"魚"});
		kuizu.emplace(5, Array<String>{U"「沈魚■雁」　■に入る漢字は？", U"落", U"鳴", U"白"});
		kuizu.emplace(6, Array<String>{U"「臥薪■胆」　■に入る漢字は？", U"嘗", U"誉", U"旨"});
	}
	~Kuizuou(){}

	void ReSetTimer(double nexttime)
	{
		delete cooltim;
		cooltim = new c_timer(systemupd, nexttime);
		pre_timer->ReStartLimitTimer();
		syutudai = false;
		sengen->ReStartLimitTimer();
		//cooltim->ReStartLimitTimer();
	}

	bool review(int32 ans);

	void update();
	void draw();

	bool syutudai;

	int32 count = 0;

	c_timer* cooltim;
	c_timer* sengen;

	c_timer* seikai;
	c_timer* huseikai;
private:
	HashTable<int32, Array<String>>kuizu;
	bool* systemupd;
	c_timer* pre_timer;
	Font font{ 25 };
	Texture juwa{ Resource(U"受話器.png") };
	int32 n = 0;
	Array<int32> nn;
	Array<int32>num;
	const Array<int32> Bango{ 1,2,3,4,5,6,7,8,9 };
};

