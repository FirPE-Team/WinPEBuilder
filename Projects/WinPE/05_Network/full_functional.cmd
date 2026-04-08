rem ==========update filesystem==========
call AddFiles %0 :end_files
goto :end_files

\Windows\INF\netlldp.inf
\Windows\INF\ndiscap.inf
\Windows\INF\netnwifi.inf
;\Windows\INF\vwifibus.sys

@\Windows\System32\drivers\
ipfltdrv.sys,lltdio.sys,mrxsmb10.sys,rspndr.sys,tcpipreg.sys,vwififlt.sys,WdiWiFi.sys
http.sys,ipnat.sys,mslldp.sys,ndiscap.sys,ndisimplatform.sys,nwifi.sys,tunnel.sys,wfplwfs.sys

@\Windows\System32\DriverStore\FileRepository\
netlldp.inf*,netnwifi.inf*
netvwifibus.inf*,netvwififlt.inf*,netvwifimp.inf*

; add cat files for driver files
@\Windows\System32\CatRoot\{F750E6C3-38EE-11D1-85E5-00C04FC295EE}\
+ver >= 17763
Microsoft-Windows-Client-Desktop-Required-Package*.cat
+ver >= 22000
Microsoft-Windows-Client-Desktop-Required-Package04~*~*~~*.*.*.*.cat
+ver*

; Folder
\ProgramData\Microsoft\WwanSvc
\Windows\L2Schemas
\Windows\schemas
\Windows\System32\icsxml

; Firewall (inWinre.wim: bfe.dll,mpssvc.dll,sscore.dll,firewallapi.dll,fwpuclnt.dll,fwremotesvr.dll,cmifw.dll,wfapigp.dll)
@\Windows\System32\
authfwcfg.dll,authfwgp.dll,authfwwizfwk.dll,Firewall.cpl,firewallcontrolpanel.dll
fwcfg.dll,sscoreext.dll,wfhc.dll

; netsh (fwcfg.dll,HNetMon.dll,NshHttp.dll,NshIpsec.dll,P2PNetsh.dll,P2P.dll,RpcNsh.dll,WcnNetsh.dll,WhHelper.dll,PeerDistSh.dll,MDMRegistration.dll,DMCmnutils.dll)
P2P.dll,p2pnetsh.dll,mdmregistration.dll,dmcmnutils.dll

; CoreMessaging Browser (in winre.wim: mi.dll,fwbase.dll,fwpolicyiomgr.dll)
browser.dll,CoreMessaging.dll

; Share folder (in Winre: gpapi.dll,gpsvc.dll,nlaapi.dll,smbwmiv2.dll,wmiclnt.dll - additional)
comsvcs.dll,gptext.dll,shacct.dll,shpafact.dll,shrpubw.exe,SMBHelperClass.dll

; password (in winre.wim DWrite.dll,credui.dll,credprovhost.dll,credprovs.dll)
credssp.dll

; dot3svc (additional: dot3gpui.dll,dot3ui.dll,onexui.dll,Dot3Conn.dll)
dot3api.dll,dot3cfg.dll,dot3dlg.dll,dot3gpclnt.dll,dot3hc.dll,dot3mm.dll
dot3msm.dll,dot3svc.dll,l2gpstore.dll,l2nacp.dll,onex.dll

; Control
IEAdvpack.dll,ieframe.dll,shwebsvc.dll,mshtml.dll

; Misc
fdWNet.dll,inetcomm.dll,iphlpsvc.dll,msi.dll,msvfw32.dll,networkitemfactory.dll
prnfldr.dll,puiapi.dll,TSpkg.dll,Windows.UI.Cred.dll

; Map a network drive
netplwiz.dll

; Control Pannel
inetcpl.cpl,netid.dll

+ver >= 26100
; system tray icon
NetworkIcon.dll
+ver*

; Windows Firewall/Internet Connection Sharing s (ICS) ervice
ipnathlp.dll,icsigd.dll,icsunattend.exe

; Network Diagnostic
ndfapi.dll,ndfetw.dll,NdfEventView.xml,ndfhcdiscovery.dll

; File Sharing (in winre.wim rtutils.dll,mpr.dll,mprapi.dll,mprmsg.dll) - optional netplwiz.dll,Netplwiz.exe)
iprtprio.dll,iprtrmgr.dll,mprddm.dll,mprdim.dll,networkexplorer.dll,NetworkStatus.dll,rtm.dll

; smb (in winre.wim wkssvc.dll,wkscli.dll)
wkspbrokerax.dll,wksprtps.dll

; NlaSvc (in Winre.wim: nlaapi.dll,nlasvc.dll,rasapi32.dll,tapi32.dll)
nlahc.dll
; Ndis
ndishc.dll
; Security Components
Keymgr.dll,Msaudite.dll
; Service Control
sc.exe
; service logon
seclogon.dll
; TCPIP support (in winre.wim: esent.dll,scecli.dll)
ubpm.dll
; Van NetStatus
VAN.dll
WlanRadioManager.dll
; Airplane mode
RMapi.dll

; WcmSvc (in Winre.wim: nlaapi.dll)
wcmapi.dll,wcmcsp.dll,wcmsvc.dll,NetworkUXBroker.dll

; WcncSvc
WcnApi.dll,wcncsvc.dll,WcnEapAuthProxy.dll,WcnEapPeerProxy.dll,WcnNetsh.dll,wcnwiz.dll

; EapHost (in Winre.wim Eap3Host.exe,eapp3hst.dll,eappcfg.dll,eappgnui.dll,eapphost.dll,eappprxy.dll,eapprovp.dll,eapsvc.dll,keyiso.dll,ttlsauth.dll,ttlscfg.dll)
cngcredui.dll,cngprovider.dll

; Wlan (additional: wlangpui.dll,wlandlg.dll,WLanConn.dll,wlanpref.dll,wlanutil.dll,provcore.dll)
mobilenetworking.dll,wlanapi.dll,wlancfg.dll,WLanConn.dll,wlandlg.dll,wlanext.exe,WLanHC.dll,wlanhlp.dll
WlanMediaManager.dll,WlanMM.dll,wlanmsm.dll,wlanpref.dll,wlansec.dll,wlansvc.dll,wlansvcpal.dll,wlanui.dll,wlanutil.dll
; Wlan password (additional: fdProxy.dll,webcheck.dll)
fdWCN.dll,fontext.dll,fundisc.dll,Windows.Globalization.dll,winhttp.dll

; Net event
netevent.dll

wbem\nlasvc.mof
wbem\wlan.mof
\Windows\SystemResources\Windows.UI.Cred\Windows.UI.Cred.pri
\Windows\SystemResources\Windows.UI.Cred\pris\Windows.UI.Cred*

:end_files

rem ==========update registry==========
rem call RegCopy HKLM\System\ControlSet001\Services\BDESVC
rem [Network_Registry]

rem //-
rem //call RegCopy HKLM\System\ControlSet001\control\lsa\CredSSP
rem //reg add HKLM\Tmp_System\ControlSet001\Control\SecurityProviders /v SecurityProviders /fcredssp.dll
reg add HKLM\Tmp_System\ControlSet001\Control\Lsa /v LimitBlankPasswordUse /t REG_DWORD /d 0 /f
rem //RegWrite,HKLM,0x7,Tmp_System\ControlSet001\Control\Lsa\OSConfig,"Security Packages",tspkg
call RegCopy HKLM\System\ControlSet001\Services\LanmanWorkstation
reg add HKLM\Tmp_System\ControlSet001\Services\LanmanWorkstation\Parameters /v AllowInsecureGuestAuth /t REG_DWORD /d 1 /f
call RegCopy HKLM\System\ControlSet001\Control\NetTrace\Scenarios\WLAN
call RegCopy HKLM\System\ControlSet001\Services\WlanSvc

reg add HKLM\Tmp_System\ControlSet001\Services\WlanSvc /v DependOnService /t REG_MULTI_SZ /d nativewifip\0RpcSs\0Ndisuio\0wcmsvc /f

rem if %VER[3]% GTR 17000 (
  reg add HKLM\Tmp_System\ControlSet001\Services\WlanSvc /v ErrorControl /t REG_DWORD /d 1 /f
  reg add HKLM\Tmp_System\ControlSet001\Services\WlanSvc /v ImagePath /t REG_EXPAND_SZ /d "%%SystemRoot%%\System32\Svchost.exe -k LocalSystemNetworkRestricted -p" /f
  reg add HKLM\Tmp_System\ControlSet001\Services\WlanSvc /v Start /t REG_DWORD /d 2 /f
  reg add HKLM\Tmp_System\ControlSet001\Services\WlanSvc /v Type /t REG_DWORD /d 32 /f
rem )

rem // wfplwfs
call RegCopy HKLM\System\ControlSet001\Control\Network\{4d36e974-e325-11ce-bfc1-08002be10318}\{3BFD7820-D65C-4C1B-9FEA-983A019639EA}
call RegCopy HKLM\System\ControlSet001\Control\Network\{4d36e974-e325-11ce-bfc1-08002be10318}\{B70D6460-3635-4D42-B866-B8AB1A24454C}
if "%APP_PE_ARCH%"=="x64" (
  call RegCopy HKLM\System\ControlSet001\Control\Network\{4d36e974-e325-11ce-bfc1-08002be10318}\{E7C3B2F0-F3C5-48DF-AF2B-10FED6D72E7A}
)
call RegCopy HKLM\System\ControlSet001\Services\WFPLWFS
rem //
call RegCopy HKLM\System\ControlSet001\Control\Network\{4d36e974-e325-11ce-bfc1-08002be10318}\{E475CF9A-60CD-4439-A75F-0079CE0E18A1}
rem // Holger: Fix WFPLWFS and both services nativewifip, wlanscv.
reg add HKLM\Tmp_System\ControlSet001\Control\NetworkSetup2\Filters\{3BFD7820-D65C-4C1B-9FEA-983A019639EA}\Kernel /v FilterClass /d ms_medium_converter_top /f
reg add HKLM\Tmp_System\ControlSet001\Control\NetworkSetup2\Filters\{B70D6460-3635-4D42-B866-B8AB1A24454C}\Kernel /v FilterClass /d ms_medium_converter_top /f
reg add HKLM\Tmp_System\ControlSet001\Control\NetworkSetup2\Filters\{E475CF9A-60CD-4439-A75F-0079CE0E18A1}\Kernel /v FilterClass /d ms_medium_converter_top /f

rem //-
call RegCopy HKLM\System\ControlSet001\Control\RadioManagement
call RegCopy HKLM\System\ControlSet001\Control\VAN
rem //In Winre.wim call RegCopy HKLM\System\ControlSet001\Control\wcncsvc
call RegCopy HKLM\System\ControlSet001\Control\Winlogon\Notifications\Components\Dot3svc
call RegCopy HKLM\System\ControlSet001\Control\Winlogon\Notifications\Components\Wlansvc
rem //-
call RegCopy HKLM\System\ControlSet001\Services\bowser
call RegCopy HKLM\System\ControlSet001\Services\Browser
call RegCopy HKLM\System\ControlSet001\Services\dot3svc
rem //reg add HKLM\Tmp_System\ControlSet001\Services\dot3svc /v Start /t REG_DWORD /d 2 /f
call RegCopy HKLM\System\ControlSet001\Services\EapHost
call RegCopy HKLM\System\ControlSet001\Services\EventLog\System\Browser
call RegCopy HKLM\System\ControlSet001\Services\EventLog\System\Microsoft-Windows-WLAN-AutoConfig
call RegCopy HKLM\System\ControlSet001\Services\IPNAT
call RegCopy HKLM\System\ControlSet001\Services\IpFilterDriver
rem //Partial in Winre.wim call RegCopy HKLM\System\ControlSet001\Services\HTTP
call RegCopy HKLM\System\ControlSet001\Services\HTTP\Parameters\UrlAclInfo
rem //In Winre.wim call RegCopy HKLM\System\ControlSet001\Services\NativeWifiP
rem //-
call RegCopy HKLM\System\ControlSet001\Services\NdisCap
rem //In Winre.wim call RegCopy HKLM\System\ControlSet001\Services\NlaSvc
call RegCopy HKLM\System\ControlSet001\Services\SharedAccess
call RegCopy HKLM\System\ControlSet001\Services\tcpipreg
reg add HKLM\Tmp_System\ControlSet001\Services\TCPIPTUNNEL /v NdisMajorVersion /t REG_DWORD /d 6 /f
reg add HKLM\Tmp_System\ControlSet001\Services\TCPIPTUNNEL /v NdisMinorVersion /t REG_DWORD /d 40 /f
reg add HKLM\Tmp_System\ControlSet001\Services\TCPIPTUNNEL /v DriverMajorVersion /t REG_DWORD /d 0 /f
reg add HKLM\Tmp_System\ControlSet001\Services\TCPIPTUNNEL /v DriverMinorVersion /t REG_DWORD /d 0 /f
rem // Telephony service
call RegCopy HKLM\System\ControlSet001\Services\TapiSrv
rem //In Winre.wim call RegCopy HKLM\System\ControlSet001\Services\tdx
rem //In Winre.wim call RegCopy HKLM\System\ControlSet001\Services\vwifibus
reg add HKLM\Tmp_System\ControlSet001\Services\vwifibus /v Owners /t REG_MULTI_SZ /d netvwifibus.inf /f
rem //In Winre.wim call RegCopy HKLM\System\ControlSet001\Services\vwififlt
call RegCopy HKLM\System\ControlSet001\Services\Wcmsvc
rem //In Winre.wim call RegCopy HKLM\System\ControlSet001\Services\wcncsvc
rem //In Winre.wim call RegCopy HKLM\System\ControlSet001\Services\wdiwifi
rem //Partial in Winre.wim call RegCopy HKLM\System\ControlSet001\Services\WinSock
rem //Partial in Winre.wim call RegCopy HKLM\System\ControlSet001\Services\WinSock2

rem // SMB v1.0 service.
call mrxsmb10.cmd

reg add HKLM\Tmp_System\Setup\AllowStart\dnscache /f
reg add HKLM\Tmp_System\Setup\AllowStart\nlasvc /f
reg add HKLM\Tmp_System\Setup\AllowStart\wcmsvc /f
reg add HKLM\Tmp_Default\Software\Microsoft\Windows\CurrentVersion\Explorer\StuckRects3 /v Settings /t REG_BINARY /d 30000000feffffff02000000030000003e0000002800000000000000f2030000900600001a0400006000000001000000 /f

rem // netprofm service is required for wlansvc and wcmsvc service in 1903! even disabled and not started.
call RegCopyEx Services netprofm
reg add HKLM\Tmp_System\ControlSet001\Services\netprofm /v Start /t REG_DWORD /d 4 /f

call networklist.cmd
call discovery.cmd
call netcenter.cmd
call wificx.cmd
