!include "MUI.nsh" ; modern UI
!include "FileFunc.nsh" ; to get estimated size for uinstaller display

RequestExecutionLevel admin
AutoCloseWindow true

; Compress installer exe
SetCompressor LZMA
SetCompress Force

; Folder selection page
InstallDir "$PROGRAMFILES\${GAME}"

; Finish page settings
Function .onInstSuccess
  ExecShell "open" "$INSTDIR\${EXE}" 
FunctionEnd

!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_COMPONENTS
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES
!insertmacro MUI_LANGUAGE "English"

BrandingText /TRIMRIGHT "${GAME} Installer"

!define TMPFILE "12345.tmp"
; validate installation dir by writing a dummy tmp file
Function .onVerifyInstDir
  IfFileExists "$INSTDIR\..\*.*" +2
  Abort

  ClearErrors
  FileOpen $0 "$INSTDIR\..\${TMPFILE}" "w"
  FileWriteByte $0 "0"
  IfErrors invalid valid

  invalid:
    Abort
  valid:
    FileClose $0
    Delete "$INSTDIR\..\${TMPFILE}"
FunctionEnd

; For updating file associations
!define SHCNE_ASSOCCHANGED 0x08000000
!define SHCNF_IDLIST 0
 
Function RefreshShellIcons
  ; By jerome tremblay - april 2003
  System::Call 'shell32.dll::SHChangeNotify(i, i, i, i) v \
  (${SHCNE_ASSOCCHANGED}, ${SHCNF_IDLIST}, 0, 0)'
FunctionEnd


; Program Files
Section "Game Files" SecPrograms

; Validate permissions
  ClearErrors
  UserInfo::GetName	; On NT-based systems this
			; will grab the current user's username.
  IfErrors user  	; If we don't get a username from this it means
			; the user isn't using an NT-based system.

  UserInfo::GetAccountType  ; Returns 'admin', 'power', 'user', or 'guest'
  Pop $1
  StrCmp $1 "Admin" admin 0
  StrCmp $1 "Power" admin user

admin:
  SetShellVarContext all
  Goto +2

user:
  SetShellVarContext current

  SetOutPath $INSTDIR
  SetOverwrite on
  SectionIn RO ; Can't unselect

  ;Only install known files and mimic for uninstall to avoid dangerous dir-deletes
  File "${FILEDIR}\${EXE}"
  File "${FILEDIR}\byondcore.dll"
  File "${FILEDIR}\byondext.dll"
  File "${FILEDIR}\byondwin.dll"
  File "${FILEDIR}\fmodex.dll"
  
  WriteUninstaller "$INSTDIR\uninst.exe"

  Call RefreshShellIcons

SectionEnd

; Start Menu
Section "Start Menu" SecStartMenu
  CreateDirectory "$SMPROGRAMS\${GAME}"
  CreateShortCut "$SMPROGRAMS\${GAME}\${GAME}.lnk" "$INSTDIR\${EXE}" "" "$INSTDIR\${EXE}" 0
  CreateShortCut "$SMPROGRAMS\${GAME}\Uninstall ${GAME}.lnk" "$INSTDIR\uninst.exe" "" "$INSTDIR\uninst.exe" 0
SectionEnd

; Desktop icons
Section "Desktop Icons" SecDesktop
  CreateShortCut "$DESKTOP\${GAME}.lnk" "$INSTDIR\${EXE}" "" "$INSTDIR\${EXE}" 0
SectionEnd

; Quicklaunch (uncomment to use)
;Section "QuickLaunch Icons" SecQuickLaunch
;  CreateShortCut "$QUICKLAUNCH\${GAME}.lnk" "$INSTDIR\${EXE}" "" "$INSTDIR\${EXE}" 0
;SectionEnd

; Registry for add/remove programs
Section "" Registry
  WriteRegStr SHELL_CONTEXT "Software\Microsoft\Windows\CurrentVersion\Uninstall\${GAME}" "DisplayName" "${GAME}"
  WriteRegStr SHELL_CONTEXT "Software\Microsoft\Windows\CurrentVersion\Uninstall\${GAME}" "UninstallString" "$INSTDIR\Uninst.exe"
  WriteRegStr SHELL_CONTEXT "Software\Microsoft\Windows\CurrentVersion\Uninstall\${GAME}" "InstallLocation" "$INSTDIR"
  WriteRegStr SHELL_CONTEXT "Software\Microsoft\Windows\CurrentVersion\Uninstall\${GAME}" "DisplayIcon" "$INSTDIR\${EXE}"
  WriteRegStr SHELL_CONTEXT "Software\Microsoft\Windows\CurrentVersion\Uninstall\${GAME}" "DisplayVersion" "${VERSION}"
  WriteRegStr SHELL_CONTEXT "Software\Microsoft\Windows\CurrentVersion\Uninstall\${GAME}" "Publisher" "${COMPANY}"
  WriteRegDWORD SHELL_CONTEXT "Software\Microsoft\Windows\CurrentVersion\Uninstall\${GAME}" "NoModify" 1
  WriteRegDWORD SHELL_CONTEXT "Software\Microsoft\Windows\CurrentVersion\Uninstall\${GAME}" "NoRepair" 1

; Get cumulative size of all files in and under install dir
; report the total in KB (decimal)
; place the answer into $0  ($1 and $2 get other info we don't care about)
  ${GetSize} "$INSTDIR" "/S=0K" $0 $1 $2

; Convert the decimal KB value in $0 to DWORD
; put it right back into $0
  IntFmt $0 "0x%08X" $0

  WriteRegDWORD SHELL_CONTEXT "Software\Microsoft\Windows\CurrentVersion\Uninstall\${GAME}" "EstimatedSize" $0
SectionEnd

; Descriptions
LangString DESC_SecPrograms ${LANG_ENGLISH} "Required Game Files"
LangString DESC_SecStartMenu ${LANG_ENGLISH} "Create Start Menu Shortcuts"
LangString DESC_SecDesktop ${LANG_ENGLISH} "Create Desktop Icons"
;LangString DESC_QuickLaunch ${LANG_ENGLISH} "Create QuickLaunch Icons"
!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
!insertmacro MUI_DESCRIPTION_TEXT ${SecDesktop} $(DESC_SecDesktop)
!insertmacro MUI_DESCRIPTION_TEXT ${SecStartMenu} $(DESC_SecStartMenu)
!insertmacro MUI_DESCRIPTION_TEXT ${SecPrograms} $(DESC_SecPrograms)
!insertmacro MUI_FUNCTION_DESCRIPTION_END

; Uninstaller
UninstallText "This will uninstall ${GAME} from your system"
Section Uninstall

  ClearErrors

; Delete known files in the installation to avoid dangerous dir-deletes
  Delete "$INSTDIR\${EXE}"
  Delete "$INSTDIR\byondcore.dll"
  Delete "$INSTDIR\byondext.dll"
  Delete "$INSTDIR\byondwin.dll"
  Delete "$INSTDIR\fmodex.dll"
  Delete "$INSTDIR\uninst.exe"
  RMDir "$INSTDIR"

; Delete admin-installed links
  SetShellVarContext all
  Delete "$DESKTOP\${GAME}.lnk"
  Delete "$SMPROGRAMS\${GAME}\*.*"
  RmDir "$SMPROGRAMS\${GAME}"
  Delete "$QUICKLAUNCH\${GAME}.lnk"

; And repeat for current user in case this was installed with less permissions
  SetShellVarContext current
  Delete "$DESKTOP\${GAME}.lnk"
  Delete "$SMPROGRAMS\${GAME}\*.*"
  RmDir "$SMPROGRAMS\${GAME}"
  Delete "$QUICKLAUNCH\${GAME}.lnk"

; Delete uinstaller registry entries
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${GAME}"
  DeleteRegKey HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\${GAME}"

SectionEnd
; End Uninstaller
