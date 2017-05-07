;时间表
;早盘
;1:	[08:41:00]		TB启动
;2:	[08:42:00]		TB登录
;3:	[08:53:00]		交易启动
;4:	[08:54:00]		监控启动
;5:	[15:35:00]		保存所有工作区
;6:	[15:36:00]		关闭监控
;7:	[15:37:00]		停止所有自动交易
;8:	[15:58:00]		关闭TB
;夜盘
;1:	[20:41:00]		TB启动
;2:	[20:42:00]		TB登录
;3:	[20:53:00]		交易启动
;4:	[20:54:00]		监控启动
;5:	[02:35:00]		保存所有工作区
;6:	[02:36:00]		关闭监控
;7:	[02:37:00]		停止所有自动交易
;8:	[02:58:00]		关闭TB
;不正常清况
;0:	[08:40:00]		进程自杀
;9:	[08:49:00]		程序过期
;10:[08:50:00]		账户登录
;11:[08:51:00]		登录失败

;日志文件流程一览如下：
;正常情况		1、2、3、4、5、6、7、8
;非交易日		1、2、10、11、8
;程序过期		1、2、9、8
;手动登录		1、2、10、3、4、5、6、7、8
;周末重启		20

#include <Date.au3>
#include <FileConstants.au3>
#include <MsgBoxConstants.au3>
#include <Constants.au3>
Global $TBloginName		=	"gentle"
Global $TBloginPassword	=	"iamanoth1977OK"
Global $TBInstallPath	=	"C:\Users\Administrator\Documents\tbv5321_x64_portable"
Global $ExpirationDate  =	"2099/01/01";注意格式为“YYYY/MM/DD”
Global $LogName
Global $LogTime
Global $Week[7] = ['周日', '周一', '周二', '周三', '周四', '周五', '周六']
Global $s = 0

Filewriteline($TBInstallPath  & "\LOG_" & @YEAR & @MON & @MDAY & "_"& $Week[@WDAY - 1]&".txt", "  " & @TAB & "[" & @HOUR & ":" & @MIN & ":" & @SEC & "]" & @TAB & @TAB & "AutoRunTB启动")
Filewriteline($TBInstallPath  & "\LOG_" & @YEAR & @MON & @MDAY & "_"& $Week[@WDAY - 1]&".txt", "");另起一行



;开机后在早盘时间启动一次夜盘时间启动一次
While 1
        $LogName			=	$TBInstallPath  & "\LOG_" & @YEAR & @MON & @MDAY & "_"& $Week[@WDAY - 1]&".txt"
        $LogTime			=	"[" & @HOUR & ":" & @MIN & ":" & @SEC & "]" & @TAB & @TAB

        ;周一到周五
        If @WDAY > 1 And @WDAY <= 7 Then	;@WDAY指示当天属该周的第几天,值的范围是 1 到 7,依次表示星期天到星期六.
                ;盘前工作
                If (@MIN = 40 And @SEC = 0 And (@HOUR = 8 Or @HOUR = 20)) Then;杀进程
                        Kill()
                EndIf
                If (@MIN = 41 And @SEC = 0 And (@HOUR = 8 Or @HOUR = 20)) Then;启动TB
                        TBStar()
                EndIf
                If (@MIN = 42 And @SEC = 0 And (@HOUR = 8 Or @HOUR = 20)) Then;登录TB
                        TBlogin()
                EndIf
                If (@MIN = 49 And @SEC = 0 And (@HOUR = 8 Or @HOUR = 20)) Then;过期检测
                        Expired()
                EndIf
                If (@MIN = 50 And @SEC = 0 And (@HOUR = 8 Or @HOUR = 20)) Then;登录账户
                        AccountLogin()
                EndIf
                If (@MIN = 51 And @SEC = 0 And (@HOUR = 8 Or @HOUR = 20)) Then;登录失败
                        LoginFail()
                EndIf
                If (@MIN = 53 And @SEC = 0 And (@HOUR = 8 Or @HOUR = 20)) Then;启动交易
                        TradeStar()
                EndIf
                If (@MIN = 54 And @SEC = 0 And (@HOUR = 8 Or @HOUR = 20)) Then;启动监控
                        MonitorStar()
					 EndIf
			    ;盘中监控
					 ;TradeLog()
                ;盘后工作
                If (@MIN = 35 And @SEC = 0 And (@HOUR = 2 Or @HOUR = 15)) Then;保存工作区
                        SaveWorkSpace()
                EndIf
                If (@MIN = 36 And @SEC = 0 And (@HOUR = 2 Or @HOUR = 15)) Then;关闭监控
                        MonitorClose()
                EndIf
                If (@MIN = 37 And @SEC = 0 And (@HOUR = 2 Or @HOUR = 15)) Then;停止交易
                        TradeStop()
                EndIf
                If (@MIN = 58 And @SEC = 0 And (@HOUR = 2 Or @HOUR = 15)) Then;关闭TB
                        TBClose()
                EndIf
                ;每周重启
        ElseIf (@WDAY = 1 And @HOUR = 12 And @MIN = 0 And @sec = 0) Then;周日重启
                ShutdownR()
        EndIf
        Sleep(1000)
	 WEnd

;动作编号0：清空进程
Func Kill()
        If ProcessExists("TradeBlazer.exe")  Then	;动作前提条件
                ProcessClose("TradeBlazer.exe")		;关闭TB
                ProcessClose("TBDataCenter.exe")	;关闭数据区
                Filewriteline($LogName, "0:" & @TAB & $LogTime & "进程清零")
        EndIf
EndFunc
;动作编号1：TB启动
Func TBStar()
        If Not WinExists ("交易开拓者平台(旗舰版)") Then	;动作前提条件
                Run($TBInstallPath & "\TradeBlazer.exe", $TBInstallPath)
                Filewriteline($LogName, "1:" & @TAB & $LogTime & "启动开拓者")
        EndIf
EndFunc
;动作编号2：TB登录
Func TBLogin()
        If WinExists("暂停自动登录交易帐户") = 0 Then 	;动作前提条件
                WinActivate("","暂停自动登录交易帐户")
                ControlFocus("","暂停自动登录交易帐户","ComboBox1")
                ControlSetText("","暂停自动登录交易帐户","ComboBox1", $TBloginName)
                ControlFocus("","暂停自动登录交易帐户","Edit2")
                ControlSetText("","暂停自动登录交易帐户","Edit2", $TBloginPassword)
                ControlClick("","暂停自动登录交易帐户", 1000)
                Filewriteline($LogName, "2:" & @TAB & $LogTime & "登录开拓者")
                Sleep(90000);登录完毕等待90秒，模拟柜台登录最少要70秒
        EndIf
        If WinExists("确认") = 0 Then
                WinActivate("","确认")
                ControlFocus("","确认","Button")
                ControlClick("","确认", 1000)
                Sleep(9000)
        EndIf
        if WinExists("确认", "本次连接的期货行情服务器") Then
                WinClose("确认", "本次连接的期货行情服务器")
        EndIf
        Sleep(10000);暂停10秒
EndFunc
;动作编号3：启动交易
Func TradeStar()
		 WinSetOnTop("交易开拓者平台(旗舰版) 64位 -","", 1)
	  ;WinWaitActive("交易开拓者平台(旗舰版) 64位 -","")
		 WinActivate("交易开拓者平台(旗舰版) 64位 -")
        If ControlListView ( "交易开拓者平台(旗舰版)", "", "SysListView321", "GetItemCount") >= 1	Then
                WinMenuSelectItem("交易开拓者平台(旗舰版)", "","文件(&F)", "启动所有自动交易")
                Filewriteline($LogName, "3:" & @TAB & $LogTime & "启动交易")
			 EndIf
			 Sleep(3000)
EndFunc
;动作编号4：启动监控
Func MonitorStar()
		 WinSetOnTop("交易开拓者平台(旗舰版) 64位 -","", 1)
		 ;WinWaitActive("交易开拓者平台(旗舰版) 64位 -","")
		 WinActivate("交易开拓者平台(旗舰版) 64位 -","")
        If ControlListView ( "交易开拓者平台(旗舰版)" ,"", "SysListView321", "GetItemCount") >= 1	Then
                WinMenuSelectItem("交易开拓者平台(旗舰版)","","交易(&T)", "监控器")
			    Sleep(100)
				;WinWaitActive("自动交易头寸监控器","", 5);暂停脚本的执行（5秒），直至窗口被激活
                WinActivate("交易开拓者平台(旗舰版) 64位 -")
				;ControlClick("自动交易头寸监控器","",2316)
			    ;Sleep(500)
				ControlClick("自动交易头寸监控器","",2316)
			    Sleep(500)
                Filewriteline($LogName, "4:" & @TAB & $LogTime & "启动监控")
			 EndIf
		 WinSetState("自动交易头寸监控器", "", @SW_SHOW)
		 ;WinSetOnTop ( "自动交易头寸监控器", "窗口文本", 1 )
		 WinSetOnTop("自动交易头寸监控器", "", 1)

EndFunc
;动作编号5：保存工作区
Func SaveWorkSpace()
        if WinExists("交易开拓者平台(旗舰版) 64位 -") Then
                WinMenuSelectItem("交易开拓者平台(旗舰版)", "","文件(&F)", "保存所有工作区");
                Filewriteline($LogName, "5:" & @TAB & $LogTime & "保存工作区")
        EndIf
EndFunc
;动作编号6：关闭监控
Func MonitorClose()
        if WinExists("自动交易头寸监控器", "") Then
                ControlFocus("自动交易头寸监控器", "","Button25")
                ControlClick("自动交易头寸监控器", "","Button25")
                Sleep(3000)
                If WinExists("确认") Then
                        ControlFocus("确认", "是(&Y)", "Button1")
                        ControlClick("确认", "是(&Y)", "Button1")
                        Filewriteline($LogName, "6:" & @TAB & $LogTime & "关闭监控")
                        Sleep(3000)
                EndIf
        EndIf
EndFunc
;动作编号7：停止所有自动交易
Func TradeStop()
        if WinExists("交易开拓者平台(旗舰版) 64位 -") Then
                WinMenuSelectItem("交易开拓者平台(旗舰版)","","文件(&F)","停止所有自动交易");
                Filewriteline($LogName, "7:" & @TAB & $LogTime & "停止交易")
                Sleep(3000)
        EndIf
EndFunc
;动作编号8：关闭TB
Func TBClose()
		 if WinExists("交易开拓者平台(旗舰版) 64位 -") Then
                WinClose("交易开拓者平台(旗舰版) 64位 -")
                Sleep(3000)
                If WinExists("确认", "") Then
                        ControlClick("确认", "","Button1")
                        Filewriteline($LogName, "8:" & @TAB & $LogTime & "关闭开拓者")
                        Filewriteline($LogName, "");另起一行
                        Sleep(3000)
                EndIf
        EndIf
EndFunc
;动作编号9：程序过期
Func Expired()
        If (_NowCalcDate() >= $ExpirationDate  ) Then					;动作前提条件
                Filewriteline($LogName, "9:" & @TAB & $LogTime & "程序过期日：" & $ExpirationDate )
                MsgBox(4096, "程序已过期", "联系电话：13299962008牛")
                TBClose()
                Sleep(600000);休眠10分钟
	    ElseIf(_NowCalcDate()<$ExpirationDate And _NowCalcDate()>_DateAdd( 'w',-12, $ExpirationDate)) Then
			    MsgBox( 0, "提示", "自启程序即将过期，过期日: " & $ExpirationDate,50 );2460秒后（9点半）会自动关闭
				WinActivate("交易开拓者平台(旗舰版)","")
			 EndIf
EndFunc
;动作编号10：账户登录
Func AccountLogin()
        if ControlListView ( "交易开拓者平台(旗舰版)", "", "SysListView321", "GetItemCount") < 1 Then
                WinMenuSelectItem("交易开拓者平台(旗舰版) 64位 - ","","交易(&T)","交易帐户登录")
                WinWaitActive("帐户登录", "", 20)
                WinActivate("帐户登录")
                ControlFocus("帐户登录", "","Button1")
                Sleep(1000)
                ControlClick("帐户登录", "","Button1")
                Filewriteline($LogName, "10:" & @TAB & $LogTime & "再次登录")
        EndIf
EndFunc
;动作编号11：登录失败
Func LoginFail()
        If ControlListView ( "交易开拓者平台(旗舰版)", "", "SysListView321", "GetItemCount") < 1 Then
                Filewriteline($LogName, "11:" & @TAB & $LogTime & "柜台关闭")
                TBClose()
        EndIf
EndFunc
;动作编号20：重启系统
Func ShutdownR()
	    If @OSVersion == "WIN_7" Then
			   Filewriteline($LogName, "20:" & @TAB & $LogTime & "周末重启系统")
			   Run("shutdown -r")
			Else
			   Filewriteline($LogName, "20:" & @TAB & $LogTime & "非WIN7系统周末不重启")
		EndIf
EndFunc
;动作编号30：读取交易记录
Func TradeLog()
		 ;拼出文件名字串
		 $TradeName			=	$TBInstallPath &"\AutoTrade\" & @YEAR & @MON & @MDAY & ".log"
		 ;若文件存在
		 if FileExists ($TradeName) Then
			;打开文件句柄
			$TradeLog			=	FileOpen($TradeName)
			;文件打开失败
			If $TradeLog = -1 Then
			   ;写入日志
			   Filewriteline($LogName, "30:" & @TAB & $LogTime & "错误,无法打开文件." & $TradeName)
			EndIf
			;获得新文件大小
			$size=FileGetSize($TradeName)
			;文件大小发生变化
			If $size<>$s Then
			   ;设置文件游标
			   If FileSetPos($TradeLog, $s, $FILE_BEGIN) Then
				  ;读取游标后续文件内容
				  Filewriteline($LogName, "30:" & @TAB & $LogTime & FileRead($TradeLog))
				  ;设置旧文件大小(全局变量)
				  $s=$size
			   EndIf
			EndIf
			;关闭文件句柄
			FileClose($TradeLog)
		 EndIf
EndFunc

