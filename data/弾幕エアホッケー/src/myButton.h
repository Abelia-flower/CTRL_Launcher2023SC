#pragma once
#include"BaseButton.h"
#include"data.h"
#include"TypeManager.h"

struct m_Button
{
	String name;
	Vec2 pos;
	int32 hight;
	int32 wideth;
	Color c;
};

class Start :public BaseButton
{
private:
	m_Button b;
public:
	Start();
	Start(m_Button b);
	~Start();
	void Registation(String name, Vec2 pos, int32 hight, int32 wideth, Color c, bool state, int32 Cnum);
	m_Button GetButton();
	void Update();//押されたら次のシーンへ
	void Draw();
};
//ポーズ状態を解除し、プレイヤーのlifeをマックスにする
class Retry :public BaseButton
{
private:
	m_Button b;
public:
	Retry();
	Retry(m_Button b);
	~Retry();
	void Registation(String name, Vec2 pos, int32 hight, int32 wideth, Color c, bool state, int32 Cnum);
	m_Button GetButton();
	void Update();//最初から始める（GameSceneから始める）
	void Draw();
};
//最初から始める
class ReBegin :public BaseButton
{
private:
	m_Button b;
public:
	ReBegin();
	ReBegin(m_Button b);
	~ReBegin();
	void Registation(String name, Vec2 pos, int32 hight, int32 wideth, Color c, bool state, int32 Cnum);
	m_Button GetButton();
	void Update();//最初から始める（GameSceneから始める）
	void Draw();
};
//ポーズ状態を解除
class Restart :public BaseButton
{
private:
	m_Button b;
public:
	Restart();
	Restart(m_Button b);
	~Restart();
	void Registation(String name, Vec2 pos, int32 hight, int32 wideth, Color c, bool state, int32 Cnum);
	m_Button GetButton();
	void Update();
	void Draw();
};
//タイトル画面に戻る
class BackToTitle :public BaseButton
{
private:
	m_Button b;
public:
	BackToTitle();
	BackToTitle(m_Button b);
	~BackToTitle();
	void Registation(String name, Vec2 pos, int32 hight, int32 wideth, Color c, bool state, int32 Cnum);
	m_Button GetButton();
	void Update();
	void Draw();
};
//ゲームを終了
class Quit :public BaseButton
{
private:
	m_Button b;
public:
	Quit();
	Quit(m_Button b);
	~Quit();
	void Registation(String name, Vec2 pos, int32 hight, int32 wideth, Color c, bool state, int32 Cnum);
	m_Button GetButton();
	void Update();//押されたら終了
	void Draw();
};

