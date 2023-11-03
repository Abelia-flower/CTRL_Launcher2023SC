#include "stdafx.h"
#include "ButtonManager.h"

BaseButton* ButtonManager::m_pButton = NULL;

ButtonManager::ButtonManager()
{
	for (int32 i = 0; i <= QUIT; i++)
	{
		state << false;
		m_Button button{ U"a",Vec2(0,0),0,0,Palette::White };
		b << button;
	}
}

void ButtonManager::SetButton(String name, Vec2 pos, int32 hight, int32 wideth, Color c,int32 bt)
{
	switch (bt)
	{
	case START:
		state[START] = true;
		b[START] = m_Button(name, pos, hight, wideth, c);
		break;
	case RETRY:
		state[RETRY] = true;
		b[RETRY] = m_Button(name, pos, hight, wideth, c);
		break;
	case RESTART:
		state[RESTART] = true;
		b[RESTART] = m_Button(name, pos, hight, wideth, c);
		break;
	case REBEGIN:
		state[REBEGIN] = true;
		b[REBEGIN] = m_Button(name, pos, hight, wideth, c);
		break;
	case BACK_TO_TITLE:
		state[BACK_TO_TITLE] = true;
		b[BACK_TO_TITLE] = m_Button(name, pos, hight, wideth, c);
		break;
	case QUIT:
		state[QUIT] = true;
		b[QUIT] = m_Button(name, pos, hight, wideth, c);
		break;
	default:
		break;
	}
	num_button++;
	Change(nowButton);
}

void ButtonManager::RemoveButton(int32 bt)
{
	switch (bt)
	{
	case START:
		if (state[START])
			state[START] = false;
		break;
	case RETRY:
		if (state[RETRY])
			state[RETRY] = false;
		break;
	case RESTART:
		if (state[RESTART])
			state[RESTART] = false;
		break;
	case REBEGIN:
		if (state[REBEGIN])
			state[REBEGIN] = false;
		break;
	case BACK_TO_TITLE:
		if (state[BACK_TO_TITLE])
			state[BACK_TO_TITLE] = false;
		break;
	case QUIT:
		if (state[QUIT])
			state[QUIT] = false;
		break;
	default:
		break;
	}
	if(num_button>1)
		num_button--;
	nowButton = 0;
}

void ButtonManager::RemoveAllButton()
{
	for (int32 i = 0; i <= QUIT; i++)
	{
		state[i] = false;
	}
	num_button = 0;
	nowButton = 0;
}

void ButtonManager::Change(int32 button)
{
	int32 count = 0;// bool skip = false;
	if (m_pButton != NULL)
	{
		delete m_pButton;
	}
	if (state[START])
	{
		if (count == (button+ num_button) % num_button)
		{
			m_pButton = new Start(b[START]);
			nowButton = count;
		}
		count++;
	}
	if (state[RETRY])
	{
		if (count == (button + num_button) % num_button)
		{
			m_pButton = new Retry(b[RETRY]);
			nowButton = count;
		}
		count++;
	}
	if (state[RESTART])
	{
		if (count == (button+num_button) % num_button)
		{
			m_pButton = new Restart(b[RESTART]);
			nowButton = count;
		}
		count++;
	}
	if (state[REBEGIN])
	{
		if (count == (button+num_button) % num_button)
		{
			m_pButton = new ReBegin(b[REBEGIN]);
			nowButton = count;
		}
		count++;
	}
	if (state[BACK_TO_TITLE])
	{
		if (count == (button+num_button) % num_button)
		{
			m_pButton = new BackToTitle(b[BACK_TO_TITLE]);
			nowButton = count;
		}
		count++;
	}
	//最後尾
	if (state[QUIT])
	{
		if (count == (button+num_button) % num_button)
		{
			m_pButton = new Quit(b[QUIT]);
			nowButton = count;
		}
		count++;
	}
}

void ButtonManager::Update()
{
	//押された瞬間
	if (KeyLeft.down() || KeyUp.down())
	{
		Change(nowButton - 1);
		PressedTimer = 0;
		ChangeTimer = 0;
	}
	else
	{
		if (KeyRight.down() || KeyDown.down())
		{
			Change(nowButton + 1);
			PressedTimer = 0;
			ChangeTimer = 0;
		}
	}
	//長押し移動
	if (KeyLeft.pressed() || KeyUp.pressed())
	{
		PressedTimer += Scene::DeltaTime();
		if (PressedTimer > 0.7)
		{
			if (ChangeTimer - 0.1 > 0)
			{
				Change(nowButton - 1);
				ChangeTimer = 0;
			}
			ChangeTimer += Scene::DeltaTime();
		}
	}
	else
	{
		if (KeyRight.pressed() || KeyDown.pressed())
		{
			PressedTimer += Scene::DeltaTime();
			if (PressedTimer > 0.7)
			{
				if (ChangeTimer - 0.1 > 0)
				{
					Change(nowButton + 1);
					ChangeTimer = 0;
				}
				ChangeTimer += Scene::DeltaTime();
			}
		}
	}

	m_pButton->Update();	
}

void ButtonManager::Draw()
{	
	if (state[START])
	{
		SimpleGUI::Button(b[START].name, b[START].pos,b[START].wideth);
	}
	if (state[RETRY])
	{
		SimpleGUI::Button(b[RETRY].name, b[RETRY].pos, b[RETRY].wideth);
	}
	if (state[RESTART])
	{
		SimpleGUI::Button(b[RESTART].name, b[RESTART].pos, b[RESTART].wideth);
	}
	if (state[REBEGIN])
	{
		SimpleGUI::Button(b[REBEGIN].name, b[REBEGIN].pos, b[REBEGIN].wideth);
	}
	if (state[BACK_TO_TITLE])
	{
		SimpleGUI::Button(b[BACK_TO_TITLE].name, b[BACK_TO_TITLE].pos, b[BACK_TO_TITLE].wideth);
	}
	//最後尾
	if (state[QUIT])
	{
		SimpleGUI::Button(b[QUIT].name, b[QUIT].pos,b[QUIT].wideth);
	}
	m_pButton->Draw();
}

