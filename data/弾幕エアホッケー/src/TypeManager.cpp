#include "stdafx.h"
#include "TypeManager.h"

const double PacHighSpeed = 450;		//パックの最高速度
const Vec2 PacVelocity = { 0,150 };	//パックの初速度	
const int32 Pr = 30;	//パックの半径Pr(pixel)

const int32 tableUpper = 25;
const int32 tableLeft = 350;
const int32 tableWide = 500;
const int32 tableHight = 750;
const int32 goalWide = 280;

const int32 centerlineWide = 2;

const double MalletSpeed = 250;
const int32 highSpeed = 250;
const int32 rowSpeed = 90;
const int32 Mr = 30;	//マレットの半径Mr(pixel)
const int32 gr = 17;

const int32 atarihantei = 4;//プレイヤーの当たり判定の半径

Rect table{ tableLeft,tableUpper,tableWide,tableHight };
//ゴールの立幅はPr,横幅はgoalWide
Rect pgoal{ (WindowWide - goalWide) / 2, WindowHight - tableUpper, goalWide, Pr * 2 };
Rect egoal{ (WindowWide - goalWide) / 2, tableUpper - 2 * Pr, goalWide, Pr * 2 };

double masatsu = 0;	//速度とかけて減速させる摩擦係数
double em = 0.7;		//マレットの反発係数
double eme = 1.15;			//敵マレットの反発係数
double ew = 0.5;		//壁などの反発係数

int32 DuaBarLen = 300;
int32 DuaInit = 2800;	//耐久値バーのデフォルト長さ
double Edamage = 0.2;

int32 damage = DuaInit/4;	//被弾したときのダメージ
int32 Raydamage = DuaInit * 1.1;
int32 RepairTime = 6;		//プレイヤーが復帰するまでの時間

bool changeSc = false;
bool BackChangeSc = false;
bool retry = false;
bool rebegin = false;

bool pause = false;
bool gameover = false;

BaseType* TypeManager::m_pType = NULL;

Player* TypeManager::player_m = 0;
Pac* TypeManager::insP = 0;
Enemy* TypeManager::enemy_m = 0;

Array<Vec2> GorlSide{ {(WindowWide - goalWide) / 2,tableUpper},{(WindowWide + goalWide) / 2,tableUpper }, {(WindowWide - goalWide) / 2,WindowHight - tableUpper},{(WindowWide + goalWide) / 2,WindowHight - tableUpper} };

int32 nowtype = 0;

TypeManager::TypeManager()
{
	int32 lifeX = WindowWide - tableLeft + 120;
	int32 lifeY = WindowHight - 80;
	Array<Vec2> playerlife = { {lifeX,lifeY},{lifeX + 25,lifeY},{lifeX + 50,lifeY},{lifeX + 75,lifeY},{lifeX + 100,lifeY} };
	lifeX = tableLeft - 120;
	lifeY = 80;
	Array<Vec2> enemylife = { {lifeX,lifeY},{lifeX - 25,lifeY},{lifeX - 50,lifeY},{lifeX - 75,lifeY},{lifeX - 100,lifeY} };

	insP = new Pac(WindowWide / 2, WindowHight / 2, Pr, PacVelocity, tableLeft, tableUpper, WindowWide, WindowHight, PacHighSpeed);
	player_m = new Player(WindowWide / 2, WindowHight - tableUpper - Mr, em, Mr, highSpeed, rowSpeed, MalletSpeed, tableLeft, tableUpper, WindowWide, WindowHight, gr,playerlife);
	enemy_m = new Enemy(WindowWide / 2, tableUpper + Mr, eme, Mr, highSpeed, rowSpeed, MalletSpeed, tableLeft, tableUpper, WindowWide, WindowHight, gr, enemylife);
}

void TypeManager::ChangeType(int32 type)
{
	if (m_pType != NULL)
	{
		delete m_pType;
	}
	switch (type)
	{
	case TYPE1:
		m_pType = new Type1();
		nowtype = TYPE1;
		break;
	case TYPE2:
		m_pType = new Type2();
		nowtype = TYPE2;
		break;
	case TYPE3:
		m_pType = new Type3();
		nowtype = TYPE3;
		break;
	case TYPE4:
		m_pType = new Type4();
		nowtype = TYPE4;
		break;
	case TYPE5:
		m_pType = new Type5();
		nowtype = TYPE5;
		break;
	case Clear:
		changeSc = true;
		break;
	default:
		break;
	}
}

int32 TypeManager::GetNowType()
{
	return nowtype;
}

void TypeManager::Retry()
{
	delete player_m;
	int32 lifeX = WindowWide - tableLeft + 120;
	int32 lifeY = WindowHight - 80;
	Array<Vec2> playerlife = { {lifeX,lifeY},{lifeX + 25,lifeY},{lifeX + 50,lifeY},{lifeX + 75,lifeY},{lifeX + 100,lifeY} };
	player_m = new Player(WindowWide / 2, WindowHight - tableUpper - Mr, em, Mr, highSpeed, rowSpeed, MalletSpeed, tableLeft, tableUpper, WindowWide, WindowHight, gr, playerlife);
	enemy_m->GetRevivaled();
}

void TypeManager::Update()
{
	if (player_m->GetLifeNum() == 0)		//ゲームオーバー
	{
		gameover=true;
	}

	if (KeyEscape.down())
	{
		pause = !pause;
	}
	if (pause || gameover)
	{
		return;
	}

	player_m->ChangeSpeed();

	player_m->keymove(enemy_m->GetBreak());

	insP->intersects(player_m);
	
	enemy_m->emove(insP->GetPac().x);
	insP->Decelerate(masatsu);
	
	insP->Pacmove();
	insP->reflect(ew);
	insP->intersects(enemy_m);
	//ここから上の行程は固定
	m_pType->Update(insP, player_m, enemy_m);

	if (player_m->GetDua() < 0 || player_m->GetBreak())
		player_m->BreakMallet();
	if (enemy_m->GetDua() < 0 || enemy_m->GetBreak()) 
		enemy_m->BreakMallet();

	//ゴールした時の処理
	if (!insP->GetPac().intersects(table))
	{
		if (insP->GetPac().y > WindowHight / 2)
		{
			//敵のゴール
			player_m->LostLifes();
			player_m->Repaired();
			Vec2 a{ WindowWide / 2,WindowHight / 2 }, b{ 0,100 };
			insP->SetXY(a);
			insP->SetVelocity(b);
		}
		else
		{
			//自分のゴール
			enemy_m->LostLifes();
			enemy_m->RepairMallet();
			player_m->Repaired();
			if (player_m->GetXY().y < tableUpper + tableHight / 2 + player_m->GetMallet().r)
				player_m->SetXY(player_m->GetXY().x, tableUpper + tableHight / 2 + player_m->GetMallet().r);
			ChangeType(nowtype + 1);
			Vec2 a{ WindowWide / 2,WindowHight / 2 }, b{ 0,100 };
			insP->SetXY(a);
			insP->SetVelocity(b);
		}
	}
	player_m->ResetKey(); enemy_m->ResetKey();
}

void TypeManager::Draw()
{
	Scene::SetBackground(Palette::Black);

	pgoal.drawFrame(0, 8, ColorF(Palette::Yellow));
	egoal.drawFrame(0, 8, ColorF(Palette::Yellow));

	table.draw(ColorF(Palette::Forestgreen));

	if(!enemy_m->GetBreak())
		Line{ Vec2(tableLeft,tableUpper + tableHight / 2),Vec2(WindowWide - tableLeft,tableUpper + tableHight / 2) }.draw(centerlineWide,Palette::Blue);

	player_m->DrawLifes();
	enemy_m->DrawLifes();

	Rect{ 25,50,DuaBarLen * enemy_m->GetDua() / DuaInit,5 }.draw(ColorF(Palette::White));
	Rect{ WindowWide - 250,WindowHight - 50,(DuaBarLen / 2) * player_m->GetDua() / DuaInit,5 }.draw(ColorF(Palette::White));
	
	player_m->Draw();
	enemy_m->GetMallet().draw(ColorF(Palette::Whitesmoke));
	enemy_m->GetGrip().drawFrame(1,ColorF(Palette::Gray));

	m_pType->Draw();
	insP->GetPac().draw(ColorF(Palette::Whitesmoke));
}
