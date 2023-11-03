#pragma once
#include"BaseButton.h"
#include"myButton.h"

enum ButtonType {//表示されるのはこの順番
	START,
	RETRY,
	RESTART,
	REBEGIN,
	BACK_TO_TITLE,
	QUIT//これをButtonTypeの最後尾にする(stateの初期化でQUITを最後尾として扱っている)
};

class ButtonManager
{
private:
	static BaseButton* m_pButton;
	int32 nowButton = 0;
	int32 num_button = 0;
	Array<bool> state;
	Array<m_Button> b;
	double PressedTimer = 0;
	double ChangeTimer = 0;
public:
	ButtonManager();

	void SetButton(String name, Vec2 pos, int32 hight, int32 wideth, Color c,int32 ButtonType);

	void RemoveButton(int32 ButtonType);

	void RemoveAllButton();

	void Change(int32 button);

	void Update();

	void Draw();
};

