#include "stdafx.h"
#include "pch_script.h"

#include "script_ui_registrator.h"
#include "MainMenu.h"

#include "UIGameCustom.h"
#include "UI/UIScriptWnd.h"
#include "../xrUI/Widgets/UIButton.h"
#include "../xrUI/Widgets/UIProgressBar.h"
#include "../xrUI/Widgets/UIEditBox.h"
#include "UI/UIMessageBox.h"
#include "UI/UIPropertiesBox.h"
#include "../../xrUI/Widgets/UITabControl.h"
#include "UI/UIMapList.h"
#include "UI/UIMMShniaga.h"
#include "../xrUI/Widgets/UIComboBox.h"
#include "../xrUI/Widgets/UIOptionsManagerScript.h"
#include "ui/UIMapInfo.h"
#include "map_manager.h"
#include "ScriptXmlInit.h"

#include "login_manager.h"
#include "account_manager.h"
#include "profile_store.h"

using namespace luabind;

CMainMenu*	MainMenu();

#pragma optimize("s",on)
void UIRegistrator::script_register(lua_State *L)
{
	CUIWindow::script_register(L);
	CUIMMShniaga::script_register(L);
	CUIStatic::script_register(L);
	CUIButton::script_register(L);
	CUIProgressBar::script_register(L);
	CUIComboBox::script_register(L);
	CUIEditBox::script_register(L);
	CUITabControl::script_register(L);
	CUIMessageBox::script_register(L);
	CUIListBox::script_register(L);
	CUIMapList::script_register(L);
	CUIDialogWndEx::script_register(L);
	CUIPropertiesBox::script_register(L);
	CUIOptionsManagerScript::script_register(L);
	CUIMapInfo::script_register(L);
	CScriptXmlInit::script_register(L);
	CUIGameCustom::script_register(L);

	module(L)
	[

		class_<CGameFont>("CGameFont")
			.enum_("EAligment")
			[
				value("alLeft",						int(CGameFont::alLeft)),
				value("alRight",					int(CGameFont::alRight)),
				value("alCenter",					int(CGameFont::alCenter))
			],


		class_<Patch_Dawnload_Progress>("Patch_Dawnload_Progress")
			.def("GetInProgress",	&Patch_Dawnload_Progress::GetInProgress)
			.def("GetStatus",		&Patch_Dawnload_Progress::GetStatus)
			.def("GetFlieName",		&Patch_Dawnload_Progress::GetFlieName)
			.def("GetProgress",		&Patch_Dawnload_Progress::GetProgress),

		class_<CMainMenu>("CMainMenu")
			.def("GetPatchProgress",		&CMainMenu::GetPatchProgress)
			.def("CancelDownload",			&CMainMenu::CancelDownload)
			.def("ValidateCDKey",			&CMainMenu::ValidateCDKey)
			.def("GetGSVer",				&CMainMenu::GetGSVer)
			.def("GetCDKey",				&CMainMenu::GetCDKeyFromRegistry)
			.def("GetPlayerName",			&CMainMenu::GetPlayerName)
			.def("GetDemoInfo",				&CMainMenu::GetDemoInfo)
			.def("GetLoginMngr",			&CMainMenu::GetLoginMngr)
			.def("GetAccountMngr",			&CMainMenu::GetAccountMngr)
			.def("GetProfileStore",			&CMainMenu::GetProfileStore)
	];

	module(L,"main_menu")
	[
		def("get_main_menu",				&MainMenu)
	];

	CMapManager::script_register(L);
}
