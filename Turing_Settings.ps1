#Windows 10 Decrapifier 18XX/19XX/20XX with extra bits for Turing Trust
#By CSAND
#July 6 2021
#
#
#PURPOSE: Eliminate much of the bloat that comes with Windows 10. Change many privacy settings to be off by default. Remove built-in advertising, Cortana, OneDrive, Cortana stuff (all optional). Disable some data collection.
#		  Clean up the start menu for new user accounts. Remove a bunch of pre-installed apps, or all of them (including the store). Create a more professional looking W10 experience. Changes some settings no longer
#         available via GPO for Professional edition.  All of this without breaking Windows.
#
#DISCLAIMER: Most of the changes are easily undone, but some like removing the store are difficult to undo.  You should use local/group policy to remove the store if you want.
#			 The -allapps switch is there but I do not recommend most people use it.
#			 I encourage you to research these changes beforehand, and read through the script.
#         	 Each section is described with comments, to make it easier to see what's going on.
#
#		  
#INSTRUCTIONS: For best results use the following how-tos. Running from an existing profile on an "in-use" machine won't affect any already-existing user profiles and won't give the best results.
#			   Read through the script to see what is disabled, and comment out anything you want to keep. By default a transcript is saved at SYSTEMDRIVE\WindowsDCtranscript.txt.
#
#Single machine how-to:
#https://community.spiceworks.com/how_to/148624-how-to-clean-up-a-single-windows-10-machine-image-using-decrapifier
#
#Basic MDT how-to:
#https://community.spiceworks.com/how_to/150455-shoehorn-decrapifier-into-your-mdt-task
#
#
#Join the Spiceworks Decrapifier community group on Spiceworks! 
#https://community.spiceworks.com/user-groups/windows-decrapifier-group
#
#Common questions/issues:
#https://community.spiceworks.com/topic/2149611-common-questions-and-problems?page=1#entry-7850320
#
#
#OFFICIAL DOWNLOAD:
#https://community.spiceworks.com/scripts/show/4378-windows-10-decrapifier-1803
#This is the only place I post any updates to this script.
#
#Changelog:
#https://community.spiceworks.com/topic/2162951-changelog
#
#Previous versions:
#https://community.spiceworks.com/scripts/show/3977-windows-10-decrapifier-1709
#https://community.spiceworks.com/scripts/show/3298-windows-10-decrapifier-version-1
#
#
#
#***Switches***
# 
#Switch         Function
#---------------------------
#No switches 	Disables unnecessary services and scheduled tasks. Removes all UWP apps except for some useful ones. Disables Cortana, OneDrive, restricts default privacy settings and cleans up the default start menu.
#-AllApps       Removes ALL apps including the store. Make sure this is what you want before you do it. It can be tough to get the store back. Seriously, don't do this unless you are 100% certain.
#-LeaveTasks    Leaves scheduled tasks alone.
#-LeaveServices Leaves services alone.
#-AppAccess		By default this script will restrict almost all the permissions in Settings -> Privacy. This will prevent that from happening.
#-ClearStart    Empties the start menu completely leaving you with just the apps list.
#-OneDrive		Leaves OneDrive and Onedrive for Business fully functional.
#-Tablet		Use this for tablets or 2-in-1s to leave location and sensors enabled.
#-Cortana		Leave Cortana and web enabled search intact... if that's what you really want.
#-Xbox			Leave xBox apps and related items.
#-NoLog			Don't copy transcript to systemdrive\WindowsDCtranscript.txt.
#-AppsOnly      Only removes apps, doesn't touch privacy settings, services, and scheduled tasks. Cannot be used with -SettingsOnly switch. Can be used with all the others.
#-SettingsOnly  Only adjusts privacy settings, services, and scheduled tasks. Leaves apps. Cannot be used with -AppsOnly switch.  Can be used with all others (-AllApps won't do anything in that case, obviously).



[cmdletbinding(DefaultParameterSetName="Decrapifier")]
param (
	[switch]$AllApps, 
    [switch]$LeaveTasks,
    [switch]$LeaveServices,
	[switch]$AppAccess,
	[switch]$OneDrive,
	[switch]$Xbox,
	[switch]$Tablet,
	[switch]$Cortana,
    [switch]$ClearStart,
	[switch]$NoLog,
    [Parameter(ParameterSetName="AppsOnly")]
    [switch]$AppsOnly,
    [Parameter(ParameterSetName="SettingsOnly")]
    [switch]$SettingsOnly
	)

$file_location = "\\192.168.0.220\deploy\turing"

$ProgressPreference = "SilentlyContinue"



#------USER EDITABLE VARIABLES - change these to your tastes!------

#Apps to keep. Wildcard is implied so try to be specific enough to not overlap with apps you do want removed. 
#Make sure not begin or end with a "|". ex: "app|app2" - good. "|app|app2|" - bad.

$GoodApps =	"calculator|camera|sticky|store|windows.photos|soundrecorder|mspaint|screensketch"

#---Functions---

#Appx removal
#Removes all apps or some apps depending on switches used.

Function RemoveApps {
	#SafeApps contains apps that shouldn't be removed, or just can't and cause errors
	$SafeApps = "AAD.brokerplugin|accountscontrol|apprep.chxapp|assignedaccess|asynctext|bioenrollment|capturepicker|cloudexperience|contentdelivery|desktopappinstaller|ecapp|edge|extension|getstarted|immersivecontrolpanel|lockapp|net.native|oobenet|parentalcontrols|PPIProjection|search|sechealth|secureas|shellexperience|startmenuexperience|vclibs|xaml|XGpuEject"
	If ($Xbox) {
		$SafeApps = "$SafeApps|Xbox" 
}
	If ($Allapps) {
		$RemoveApps = Get-AppxPackage -allusers | where-object {$_.name -notmatch $SafeApps}
		$RemovePrApps = Get-AppxProvisionedPackage -online | where-object {$_.displayname -notmatch $SafeApps}
			ForEach ($RemovedApp in $RemoveApps) {
              #  Write-Host "Turing Message: " -ForegroundColor Cyan -NoNewline
			#	Write-Host Removing app package: $RemovedApp.name
				$REM1 = Remove-AppxPackage -package $RemovedApp -erroraction silentlycontinue
}			ForEach ($RemovedPrApp in $RemovePrApps) {
				# Write-Host Removing provisioned app $RemovedPrApp.displayname
				$REM1 = Remove-AppxProvisionedPackage -online -packagename $RemovedPrApp.packagename -erroraction silentlycontinue | Out-Null
}
}	Else {
		$SafeApps = "$SafeApps|$GoodApps"
		$RemoveApps = Get-AppxPackage -allusers | where-object {$_.name -notmatch $SafeApps}
		$RemovePrApps = Get-AppxProvisionedPackage -online | where-object {$_.displayname -notmatch $SafeApps}
			ForEach ($RemovedApp in $RemoveApps) {
				# Write-Host Removing app package: $RemovedApp.name
				$REM1 =  Remove-AppxPackage -package $RemovedApp -erroraction silentlycontinue

}			ForEach ($RemovedPrApp in $RemovePrApps) {
				# Write-Host Removing provisioned app $RemovedPrApp.displayname
				$REM1 = Remove-AppxProvisionedPackage -online -packagename $RemovedPrApp.packagename -erroraction silentlycontinue | Out-Null
}
}
} 
#End Function RemoveApps
#Disable scheduled tasks
#Tasks: Various CEIP and information gathering/sending tasks.
Function DisableTasks {
    If ($LeaveTasks) {
     #   Write-Host "***Leavetasks switch set - leaving scheduled tasks alone...***" 
}    Else {
    #    Write-Host "***Disabling some unecessary scheduled tasks...***"
        Get-Scheduledtask "Microsoft Compatibility Appraiser","ProgramDataUpdater","Consolidator","KernelCeipTask","UsbCeip","Microsoft-Windows-DiskDiagnosticDataCollector","GatherNetworkInfo","QueueReporting" -erroraction silentlycontinue | Disable-scheduledtask | Out-Null
}
}


#Disable services
Function DisableServices {
    If ($LeaveServices) {
   #     Write-Host "***Leaveservices switch set - leaving services alone...***"
}    Else {
  #      Write-Host "***Stopping and disabling some services...***"
        
        Get-Service FoxitReaderUpdateService,SCardSvr,ScDeviceEnum,SCPolicySvc -erroraction silentlycontinue | stop-service -passthru | set-service -startuptype disabled

        #Diagnostics tracking WMP Network Sharing
		Get-Service Diagtrack,WMPNetworkSvc -erroraction silentlycontinue | stop-service -passthru | set-service -startuptype disabled
		If ($Xbox){
}		 Else {
			#Disable xBox services - "xBox Game Monitoring Service" - XBGM - Can't be disabled (access denied)
			$disabled_service =Get-Service XblAuthManager,XblGameSave,XboxNetApiSvc -erroraction silentlycontinue | stop-service -passthru | set-service -startuptype disabled
}		
}
}

        
#Registry change functions
#Load default user hive
Function loaddefaulthive {
	$matjazp72 = (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList' Default).Default
    reg load "$reglocation" $matjazp72\ntuser.dat > null
}


#Unload default user hive
Function unloaddefaulthive {
    [gc]::collect()
    reg unload "$reglocation" > null
}


#Cycle registry locations - 1st pass HKCU, 2nd pass default NTUSER.dat
Function RegChange {
 #   Write-Host "***Applying registry items to HKCU...***"
    $reglocation = "HKCU"
    regsetuser
    $reglocation = "HKLM\AllProfile"
#	Write-Host "***Applying registry items to default NTUSER.DAT...***"
    loaddefaulthive; regsetuser; unloaddefaulthive
    $reglocation = $null
#	Write-Host "***Applying registry items to HKLM...***"
    regsetmachine
#    Write-Host "***Registry set current user and default user, and policies set for local machine!***"
}


#Set current and default user registry settings
Function RegSetUser {
    #Start menu suggestions
    Reg Add "$reglocation\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /T REG_DWORD /V "SystemPaneSuggestionsEnabled" /D 0 /F > null
	#Show suggested content in settings
	Reg Add "$reglocation\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /T REG_DWORD /V "SubscribedContent-338393Enabled" /D 0 /F > null
	Reg Add "$reglocation\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /T REG_DWORD /V "SubscribedContent-353694Enabled" /D 0 /F > null
	#Show suggestions occasionally
	Reg Add "$reglocation\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /T REG_DWORD /V "SubscribedContent-338388Enabled" /D 0 /F > null
	#Multitasking - Show suggestions in timeline
	Reg Add "$reglocation\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /T REG_DWORD /V "SubscribedContent-353698Enabled" /D 0 /F > null
    #Lockscreen suggestions, rotating pictures
    Reg Add "$reglocation\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /T REG_DWORD /V "SoftLandingEnabled" /D 0 /F > null
    Reg Add "$reglocation\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /T REG_DWORD /V "RotatingLockScreenEnabled" /D 0 /F > null
	Reg Add "$reglocation\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /T REG_DWORD /V "RotatingLockScreenOverlayEnabled" /D 0 /F > null
    #Preinstalled apps, Minecraft Twitter etc all that - still need a clean default start menu to fully eliminate
    Reg Add "$reglocation\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /T REG_DWORD /V "PreInstalledAppsEnabled" /D 0 /F > null
    Reg Add "$reglocation\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /T REG_DWORD /V "PreInstalledAppsEverEnabled" /D 0 /F > null
    Reg Add "$reglocation\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /T REG_DWORD /V "OEMPreInstalledAppsEnabled" /D 0 /F > null
    #MS shoehorning apps quietly into your profile
    Reg Add "$reglocation\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /T REG_DWORD /V "SilentInstalledAppsEnabled" /D 0 /F > null
    Reg Add "$reglocation\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /T REG_DWORD /V "ContentDeliveryAllowed" /D 0 /F > null
    Reg Add "$reglocation\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /T REG_DWORD /V "SubscribedContentEnabled" /D 0 /F > null
    #Ads in File Explorer
    Reg Add "$reglocation\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /T REG_DWORD /V "ShowSyncProviderNotifications" /D 0 /F > null
	#Show me the Windows welcome experience after updates and occasionally
	Reg Add "$reglocation\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /T REG_DWORD /V "SubscribedContent-310093Enabled" /D 0 /F > null
	#Get tips, tricks, suggestions as you use Windows 
	Reg Add "$reglocation\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /T REG_DWORD /V "SubscribedContent-338389Enabled" /D 0 /F > null

	#Privacy Settings
	#Ask for feedback
    Reg Add "$reglocation\SOFTWARE\Microsoft\Siuf\Rules" /T REG_DWORD /V "NumberOfSIUFInPeriod" /D 0 /F > null
    Reg Add "$reglocation\SOFTWARE\Microsoft\Siuf\Rules" /T REG_DWORD /V "PeriodInNanoSeconds" /D 0 /F > null
	#Let apps use advertising ID
	Reg Add "$reglocation\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /T REG_DWORD /V "Enabled" /D 0 /F > null
	#Tailored experiences - Diagnostics & Feedback settings
	Reg Add "$reglocation\SOFTWARE\Microsoft\Windows\CurrentVersion\Privacy" /T REG_DWORD /V "TailoredExperiencesWithDiagnosticDataEnabled" /D 0 /F > null
	#Let apps on other devices open messages and apps on this device - Shared Experiences settings
	Reg Add "$reglocation\SOFTWARE\Microsoft\Windows\CurrentVersion\CDP" /T REG_DWORD /V "RomeSdkChannelUserAuthzPolicy" /D 0 /F > null
	Reg Add "$reglocation\SOFTWARE\Microsoft\Windows\CurrentVersion\CDP" /T REG_DWORD /V "CdpSessionUserAuthzPolicy" /D 0 /F > null
	#Speech Inking & Typing - comment out if you use the pen\stylus a lot
    Reg Add "$reglocation\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Language" /T REG_DWORD /V "Enabled" /D 0 /F > null
    Reg Add "$reglocation\SOFTWARE\Microsoft\InputPersonalization" /T REG_DWORD /V "RestrictImplicitTextCollection" /D 1 /F > null
    Reg Add "$reglocation\SOFTWARE\Microsoft\InputPersonalization" /T REG_DWORD /V "RestrictImplicitInkCollection" /D 1 /F > null
    Reg Add "$reglocation\SOFTWARE\Microsoft\InputPersonalization\TrainedDataStore" /T REG_DWORD /V "HarvestContacts" /D 0 /F > null
	Reg Add "$reglocation\SOFTWARE\Microsoft\Personalization\Settings" /T REG_DWORD /V "AcceptedPrivacyPolicy" /D 0 /F > null
	#Improve inking & typing recognition
	Reg Add "$reglocation\SOFTWARE\Microsoft\Input\TIPC" /T REG_DWORD /V "Enabled" /D 0 /F > null
	#Pen & Windows Ink - Show recommended app suggestions
	Reg Add "$reglocation\SOFTWARE\Microsoft\Windows\CurrentVersion\PenWorkspace" /T REG_DWORD /V "PenWorkspaceAppSuggestionsEnabled" /D 0 /F > null
	#People + Feeds
	#Show My People notifications
	Reg Add "$reglocation\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People\ShoulderTap" /T REG_DWORD /V "ShoulderTap" /D 0 /F > null
	#Show My People app suggestions
	Reg Add "$reglocation\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /T REG_DWORD /V "SubscribedContent-314563Enabled" /D 0 /F > null
	#People on Taskbar
	Reg Add "$reglocation\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People" /T REG_DWORD /V "PeopleBand" /D 0 /F > null
	#News/Feeds taskbar item
	Reg Add "$reglocation\SOFTWARE\Microsoft\Windows\CurrentVersion\Feeds" /T REG_DWORD /V "ShellFeedsTaskbarViewMode" /D 2 /F > null
	#Other Settings
	#Use Autoplay for all media and devices
	Reg Add "$reglocation\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers" /T REG_DWORD /V "DisableAutoplay" /D 1 /F > null
	#Taskbar search, personal preference. 0 = no search, 1 = search icon, 2 = search bar
    Reg Add "$reglocation\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /T REG_DWORD /V "SearchboxTaskbarMode" /D 0 /F > null
	#Allow search to use location if it's enabled
	Reg Add "$reglocation\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /T REG_DWORD /V "AllowSearchToUseLocation" /D 0 /F > null
	#Do not track - Edge
	Reg Add "$reglocation\SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\Main" /T REG_DWORD /V "DoNotTrack" /D 1 /F > null
	#Do not track - IE
	Reg Add "$reglocation\SOFTWARE\Microsoft\Internet Explorer\Main" /T REG_DWORD /V "DoNotTrack" /D 1 /F > null
	#--Optional User Settings--
    #App permissions user settings, these are all available from the settings menu
	reg add HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer /v EnableAutoTray /t REG_DWORD /d 0 /f > null
	reg add HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Feeds /v ShellFeedsTaskbarViewMode  /t REG_DWORD /d 2 /f > null
	reg add HKEY_CURRENT_USER\Software\Microsoft\Windows\Shell\Bags\1\Desktop /v FFLAGS /t REG_DWORD /d 1075839525 /f > null
	reg add HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer /v HideSCAMeetNow /t REG_DWORD /d 1 /f > null
	reg add HKLM\SOFTWARE\Software\Policies\Microsoft\MicrosoftEdge\Main /v PreventFirstRunPage /t REG_DWORD /d 1 /f > null
	reg add HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v LaunchTo /t REG_DWORD /d 1 /f > null




    If ($AppAccess) {
}	 Else{ 	
		#App permissions
		#Location - see tablet settings
		#Camera
		Reg Add "$reglocation\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\webcam" /T REG_SZ /V "Value" /D Deny /F > null
		#Microphone
		Reg Add "$reglocation\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\microphone" /T REG_SZ /V "Value" /D Deny /F > null
		#Account Info
		Reg Add "$reglocation\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userAccountInformation" /T REG_SZ /V "Value" /D Deny /F > null
		#Contacts
		Reg Add "$reglocation\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\contacts" /T REG_SZ /V "Value" /D Deny /F	> null
		#Calendar
		Reg Add "$reglocation\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\appointments" /T REG_SZ /V "Value" /D Deny /F > null
		#Call history
		Reg Add "$reglocation\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\phoneCallHistory" /T REG_SZ /V "Value" /D Deny /F > null
		#Email
		Reg Add "$reglocation\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\email" /T REG_SZ /V "Value" /D Deny /F > null
		#Tasks
		Reg Add "$reglocation\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userDataTasks" /T REG_SZ /V "Value" /D Deny /F > null
		#TXT/MMS
		Reg Add "$reglocation\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\chat" /T REG_SZ /V "Value" /D Deny /F > null
		#Cellular Data
		Reg Add "$reglocation\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\cellularData" /T REG_SZ /V "Value" /D Deny /F > null
		#Allow apps to run in background global setting - seems to reset during OOBE
		Reg Add "$reglocation\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /T REG_DWORD /V "GlobalUserDisabled" /D 1 /F > null
		Reg Add "$reglocation\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /T REG_DWORD /V "BackgroundAppGlobalToggle" /D 0 /F	 > null
		#My Documents
		Reg Add "$reglocation\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\documentsLibrary" /T REG_SZ /V "Value" /D Deny /F > null
		#My Pictures
		Reg Add "$reglocation\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\picturesLibrary" /T REG_SZ /V "Value" /D Deny /F > null
		#My Videos
		Reg Add "$reglocation\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\videosLibrary" /T REG_SZ /V "Value" /D Deny /F > null
		#File System
		Reg Add "$reglocation\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\broadFileSystemAccess" /T REG_SZ /V "Value" /D Deny /F > null
		#Tablet Settings - use -Tablet switch to leave these on
		If ($Tablet) {
}
		 Else {
			#Deny access to location and sensors
			Reg Add "$reglocation\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Sensor\Permissions\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}" /T REG_DWORD /V "SensorPermissionState" /D 0 /F > null
			Reg Add "$reglocation\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}" /T REG_SZ /V "Value" /D Deny /F > null
			Reg Add "$reglocation\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{E6AD100E-5F4E-44CD-BE0F-2265D88D14F5}" /T REG_SZ /V "Value" /D Deny /F > null
			Reg Add "$reglocation\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" /T REG_SZ /V "Value" /D Deny /F > null
}
}
	#Disable Cortana - use -Cortana to leave it on
	If ($Cortana){
}	 Else{
		#Disable Cortana and Bing search user settings
		Reg Add "$reglocation\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /T REG_DWORD /V "CortanaEnabled" /D 0 /F > null
		Reg Add "$reglocation\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /T REG_DWORD /V "CanCortanaBeEnabled" /D 0 /F > null
		Reg Add "$reglocation\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /T REG_DWORD /V "DeviceHistoryEnabled" /D 0 /F > null
		Reg Add "$reglocation\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /T REG_DWORD /V "CortanaConsent" /D 0 /F > null
		Reg Add "$reglocation\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /T REG_DWORD /V "CortanaInAmbientMode" /D 0 /F > null
		#Disable Bing search from start menu/search bar
		Reg Add "$reglocation\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /T REG_DWORD /V "BingSearchEnabled" /D 0 /F > null
		#Disable Cortana on lock screen
		Reg Add "$reglocation\SOFTWARE\Microsoft\Speech_OneCore\Preferences" /T REG_DWORD /V "VoiceActivationEnableAboveLockscreen" /D 0 /F > null
		#Disable Cortana search history
		Reg Add "$reglocation\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /T REG_DWORD /V "HistoryViewEnabled" /D 0 /F > null
}
	#Game settings - use -Xbox to leave these on
	If ($Xbox) {
}	 Else {
		#Disable Game DVR
		Reg Add "$reglocation\System\GameConfigStore" /T REG_DWORD /V "GameDVR_Enabled" /D 0 /F > null
}
	#OneDrive settings - use -OneDrive switch to leave these on
	If ($OneDrive) {
}	 Else {
		#Disable OneDrive startup run user settings
		Reg Add "$reglocation\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run" /T REG_BINARY /V "OneDrive" /D 0300000021B9DEB396D7D001 /F > null
		#Disable automatic OneDrive desktop setup for new accounts
		If ($reglocation -ne "HKCU") {
			Reg Delete "$reglocation\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /V "OneDriveSetup" /F > null
}
}

#End user registry settings
}


#Set local machine settings and local group policies    
Function RegSetMachine {
    #--Local GP settings--   CONVERT THESE TO HKCU / DEFAULT / HKLM WHERE POSSIBLE
    #Can be adjusted in GPedit.msc in Pro+ editions.
    #Local Policy\Computer Config\Admin Templates\Windows Components			
    #/Application Compatibility
    #Turn off Application Telemetry			
    Reg Add	"HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /T REG_DWORD /V "AITEnable" /D 0 /F > null		
    #Turn off inventory collector			
    Reg Add	"HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /T REG_DWORD /V "DisableInventory" /D 1 /F > null

    #/Cloud Content			
    #Turn off Consumer Experiences	- Enterprise only (for Pro, HKCU settings and start menu cleanup achieve same result)		
    Reg Add	"HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /T REG_DWORD /V "DisableWindowsConsumerFeatures" /D 1 /F > null

    #/Data Collection and Preview Builds			
    #Set Telemetry to off (switches to 1:basic for W10Pro and lower)			
    Reg Add	"HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /T REG_DWORD /V "AllowTelemetry" /D 0 /F > null
    #Do not show feedback notifications			
    Reg Add	"HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /T REG_DWORD /V "DoNotShowFeedbackNotifications" /D 1 /F > null

    #/Sync your settings - commented out by default to keep functionality of sync service		
   #Add "Run as different user" to context menu
	Reg Add	"HKLM\SOFTWARE\Policies\Microsoft\Windows\Explorer" /T REG_DWORD /V "ShowRunasDifferentuserinStart" /D 1 /F > null
	#Disable "Meet Now" taskbar button
	Reg Add	"HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /T REG_DWORD /V "HideSCAMeetNow" /D 1 /F > null
	
    #/Windows Update			
    #Turn off featured SOFTWARE notifications through Windows Update
    Reg Add	"HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /T REG_DWORD /V "EnableFeaturedSoftware" /D 0 /F > null

    #--Non Local GP Settings--		
    #Delivery Optimization settings - sets to 1 for LAN only, change to 0 for off
    Reg Add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config" /T REG_DWORD /V "DownloadMode" /D 1 /F > null
    Reg Add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config" /T REG_DWORD /V "DODownloadMode" /D 1 /F > null
	Reg Add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Settings" /T REG_DWORD /V "DownloadMode" /D 1 /F > null
    #Disabling advertising info and device metadata collection for this machine
    Reg Add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /T REG_DWORD /V "Enabled" /D 0 /F > null
    Reg Add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Device Metadata" /V "PreventDeviceMetadataFromNetwork" /T REG_DWORD /D 1 /F > null

	#Disable CEIP. GP setting at: Computer Config\Admin Templates\System\Internet Communication Managemen\Internet Communication settings
    Reg Add "HKLM\SOFTWARE\Microsoft\SQMClient\Windows" /T REG_DWORD /V "CEIPEnable" /D 0 /F > null
	#Prevent using sign-in info to automatically finish setting up after an update
    Reg Add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /T REG_DWORD /V "ARSOUserConsent" /D 0 /F > null
    
    #Enable diagnostic data viewer
    Reg Add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Diagnostics\DiagTrack\EventTranscriptKey" /T REG_DWORD /V "EnableEventTranscript" /D 1 /F > null
	#Disable Edge desktop shortcut
	Reg Add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /T REG_DWORD /V "DisableEdgeDesktopShortcutCreation" /D 1 /F > null
	
	#--Optional Machine Settings--
	#Disable Cortana - use -Cortana to leave it on
	If ($Cortana){
}	 Else{
    #Cortana local GP - Computer Config\Admin Templates\Windows Components\Search			
    #Disallow Cortana			
    Reg Add	"HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /T REG_DWORD /V "AllowCortana" /D 0 /F > null
    
}

	#Tablet Settings - use -Tablet switch to leave these on
	If ($Tablet) {
}	 Else {
		#Turn off location - global
		Reg Add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" /T REG_SZ /V "Value" /D Deny /F > null
}
	#Game settings - use -Xbox to leave these on
	If ($Xbox) {
}	 Else {
		#Disable Game Monitoring Service
		Reg Add "HKLM\SYSTEM\CurrentControlSet\Services\xbgm" /T REG_DWORD /V "Start" /D 4 /F > null
		#GameDVR local GP - Computer Config\Admin Templates\Windows Components\Windows Game Recording and Broadcasting
		Reg Add "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /T REG_DWORD /V "AllowGameDVR" /D 0 /F > null
}

	#OneDrive settings - use -OneDrive switch to leave these on
	If ($OneDrive) {
}	 Else {
		#Prevent usage of OneDrive local GP - Computer Config\Admin Templates\Windows Components\OneDrive	
		Reg Add	"HKLM\SOFTWARE\Policies\Microsoft\Windows\OneDrive" /T REG_DWORD /V "DisableFileSyncNGSC" /D 1 /F > null
		Reg Add "HKLM\SOFTWARE\Policies\Microsoft\Windows\OneDrive" /T REG_DWORD /V "DisableFileSync" /D 1 /F > null
		#Remove OneDrive from File Explorer
		Reg Add "HKCR\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /T REG_DWORD /V "System.IsPinnedToNameSpaceTree" /D 0 /F > null
		Reg Add "HKCR\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /T REG_DWORD /V "System.IsPinnedToNameSpaceTree" /D 0 /F > null
}
#End machine registry settings
}           



# Remove pinned apps from start menu
function Unpin-App([string]$appname) { 
    ((New-Object -Com Shell.Application).NameSpace('shell:::{4234d49b-0245-4df3-b780-3893943456e1}').Items() | 
        ?{$_.Name -eq $appname}).Verbs() | ?{$_.Name.replace('&','') -match 'Unpin from taskbar'} | %{$_.DoIt()} 
} 

function final_checker ()
{
  
      if (test-path c:\rachel ){ 
      
        Start-Process "C:\Users\user1\Desktop\Computer Studies Resources"
        Show-MessageBox "Check that Computer Studies has opened...."
        start-process "C:\Users\user1\Desktop\Computer studies syllabus and past papers"
        Show-MessageBox "Check Computer Studies studies has opened..."
        Start-Process "C:\Program Files (x86)\Foxit Software\Foxit PDF Reader\FoxitPDFReader.exe"
        Show-MessageBox "Check that Foxit has started...."
        start-process "C:\Program Files\LibreOffice\program\soffice.exe"
        Show-MessageBox "Check Libre Office has started..."
        start-process "C:/RACHEL/RACHEL/modules/khan_academy/math/algebra/introduction-to-algebra/overview_hist_alg/origins-of-algebra.html"
        Show-MessageBox "Check the audio in Rachel Web..."
        start-process "C:\RapidTyping\RapidTyping.exe"
        Show-MessageBox "Check that Rapid Typing has started"
        Show-MessageBox "All done....."
     }

}

function MSPatch
{
    Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force | Out-Null
    Install-Module -Name PSWindowsUpdate -Force | Out-Null
    Get-WindowsUpdate | ft
    Get-WindowsUpdate -Install -AcceptAll -IgnoreReboot | select KB,status, Title| ft -AutoSize
}

#Goodbye Message Function
Function Goodbye {
    Write-Host "*******Decrapification complete.*******"
	Write-Host "*******Remember to set your execution policy back!  Set-Executionpolicy restricted is the Windows 10 default.*******"
    Write-Host "*******Reboot your computer now!*******"     
}

function Turing-Cleanup  {
    
    #Write-Host "Cleaning up Windows setting"
	
    Reg Add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer" /T REG_DWORD /V "EnableAutoTray" /D 0 /F > null
	Reg Add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Feeds" /T REG_DWORD /V "ShellFeedsTaskbarViewMode" /D 2 /F > null
    sleep -Seconds 3

	sc delete DiagTrack
	sc delete dmwappushservice

	echo "" > C:\\ProgramData\\Microsoft\\Diagnosis\\ETLLogs\\AutoLogger\\AutoLogger-Diagtrack-Listener.etl
	reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f > null

	sleep -Seconds 3
	taskkill /f /IM explorer.exe > null
	start explorer

}


function Branding
{
 

    md c:\turing -Force | Out-Null
    Copy-Item $file_location\icons\*.* 'C:\ProgramData\Microsoft\User Account Pictures' -Force
    Copy-Item $file_location\bginfo\*.exe C:\Windows\System32 -Force
    Copy-Item $file_location\bginfo\desktop.bgi C:\turing\desktop.bgi -Force
    Copy-Item $file_location\background.lnk 'C:\Users\All Users\Microsoft\Windows\Start Menu\Programs\StartUp' -Force

}

Function Show-MessageBox ($msg)
{
[System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") | Out-Null
$responseA=[System.Windows.Forms.MessageBox]::Show($msg, "Checker Message", 4)
Set-Variable -Name _ResponseA ($responseA) -Scope "Global"
}

function Show-Process($Process, [Switch]$Maximize)
{
  $sig = '
    [DllImport("user32.dll")] public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);
    [DllImport("user32.dll")] public static extern int SetForegroundWindow(IntPtr hwnd);
  '
  
  if ($Maximize) { $Mode = 3 } else { $Mode = 4 }
  $type = Add-Type -MemberDefinition $sig -Name WindowAPI -PassThru
  $hwnd = $process.MainWindowHandle
  $null = $type::ShowWindowAsync($hwnd, $Mode)
  $null = $type::SetForegroundWindow($hwnd) 
}


#---End of functions---


#Decrapify
If ($NoLog) {
}Else  {
	Start-Transcript $ENV:SYSTEMDRIVE\WindowsDCtranscript.txt
}
Write-Host "******Turing Final cleanup script...******" -ForegroundColor cyan
If ($AppsOnly) {
    $ian = RemoveApps
    ClearStartMenu
    Unpin-App("Microsoft Edge") 
    Unpin-App("Microsoft Store")
    Final_Checker
    Goodbye
}Elseif ($SettingsOnly) {
    DisableTasks
    DisableServices
    RegChange
    ClearStartMenu
    Unpin-App("Microsoft Edge") 
    Unpin-App("Microsoft Store")
    Goodbye
}Else {

    Write-Host "Turing Message: " -ForegroundColor Cyan -NoNewline
    Write-host "Removing Apps"  -ForegroundColor Yellow
	    RemoveApps
    Write-Host "Turing Message: " -ForegroundColor Cyan -NoNewline
    Write-Host "Disabling Tasks"  -ForegroundColor Yellow
        DisableTasks
    Write-Host "Turing Message: " -ForegroundColor Cyan -NoNewline
    Write-Host "Disable Services"  -ForegroundColor Yellow
        DisableServices
    Write-Host "Turing Message: " -ForegroundColor Cyan -NoNewline
    Write-Host "Reg Tuning"  -ForegroundColor Yellow
        RegChange
    Write-Host "Turing Message: " -ForegroundColor Cyan -NoNewline
    Write-Host "Turing Settings"  -ForegroundColor Yellow
        Turing-Cleanup
    Write-Host "Turing Message: " -ForegroundColor Cyan -NoNewline
	Write-Host "Check apps"  -ForegroundColor Yellow
        Final_Checker
    Write-Host "Turing Message: " -ForegroundColor Cyan -NoNewline
	Write-Host "Apply patches" -ForegroundColor Yellow
        mspatch
    Write-Host "Turing Message: " -ForegroundColor Cyan -NoNewline
    Write-Host "Branding"  -ForegroundColor Yellow
        Branding
    Write-Host "Unpin Apps"  -ForegroundColor Yellow
	    Unpin-App("Microsoft Edge") 
        Unpin-App("Microsoft Store")
    Write-Host "Turing Message: " -ForegroundColor Cyan -NoNewline
	Write-Host "End"
        Goodbye
        pause
	
}

If ($NoLog) {
}Else  {
	Stop-Transcript
}

