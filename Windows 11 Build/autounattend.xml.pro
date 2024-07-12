<?xml version="1.0" encoding="utf-8"?>
<unattend xmlns="urn:schemas-microsoft-com:unattend" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State">
	<!--https://schneegans.de/windows/unattend-generator/?LanguageMode=Unattended&UILanguage=en-GB&UserLocale=en-GB&KeyboardLayout=0809%3A00000809&GeoLocation=242&ProcessorArchitecture=amd64&BypassRequirementsCheck=true&BypassNetworkCheck=true&ComputerNameMode=Random&TimeZoneMode=Implicit&PartitionMode=Unattended&PartitionLayout=GPT&EspSize=300&RecoveryMode=Partition&RecoverySize=1000&WindowsEditionMode=Unattended&WindowsEdition=pro&UserAccountMode=Unattended&AccountName0=User1&AccountPassword0=password&AccountGroup0=Administrators&AccountName1=User&AccountPassword1=password&AccountGroup1=Users&AutoLogonMode=Own&PasswordExpirationMode=Unlimited&LockoutMode=Disabled&DisableSystemRestore=true&EnableLongPaths=true&AllowPowerShellScripts=true&DisableAppSuggestions=true&DisableWidgets=true&PreventDeviceEncryption=true&WifiMode=Skip&ExpressSettings=DisableAll&Remove3DViewer=true&RemoveBingSearch=true&RemoveCamera=true&RemoveClipchamp=true&RemoveCopilot=true&RemoveCortana=true&RemoveDevHome=true&RemoveFamily=true&RemoveFeedbackHub=true&RemoveInternetExplorer=true&RemoveMailCalendar=true&RemoveMaps=true&RemoveMathInputPanel=true&RemoveZuneVideo=true&RemoveNews=true&RemoveNotepadClassic=true&RemoveOffice365=true&RemoveOneDrive=true&RemoveOneNote=true&RemoveOutlook=true&RemovePaint3D=true&RemovePeople=true&RemovePowerAutomate=true&RemoveQuickAssist=true&RemoveSkype=true&RemoveSolitaire=true&RemoveStepsRecorder=true&RemoveTeams=true&RemoveVoiceRecorder=true&RemoveWeather=true&RemoveWindowsMediaPlayer=true&RemoveWordPad=true&RemoveXboxApps=true&RemoveYourPhone=true&WdacMode=Skip-->
	<settings pass="offlineServicing"></settings>
	<settings pass="windowsPE">
		<component name="Microsoft-Windows-International-Core-WinPE" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS">
			<SetupUILanguage>
				<UILanguage>en-GB</UILanguage>
			</SetupUILanguage>
			<InputLocale>0809:00000809</InputLocale>
			<SystemLocale>en-GB</SystemLocale>
			<UILanguage>en-GB</UILanguage>
			<UserLocale>en-GB</UserLocale>
		</component>
		<component name="Microsoft-Windows-Setup" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS">
			<ImageInstall>
				<OSImage>
					<InstallTo>
						<DiskID>0</DiskID>
						<PartitionID>3</PartitionID>
					</InstallTo>
				</OSImage>
			</ImageInstall>
			<UserData>
				<ProductKey>
					<Key>VK7JG-NPHTM-C97JM-9MPGT-3V66T</Key>
				</ProductKey>
				<AcceptEula>true</AcceptEula>
			</UserData>
			<RunSynchronous>
				<RunSynchronousCommand wcm:action="add">
					<Order>1</Order>
					<Path>cmd.exe /c "&gt;&gt;"X:\diskpart.txt" echo SELECT DISK=0"</Path>
				</RunSynchronousCommand>
				<RunSynchronousCommand wcm:action="add">
					<Order>2</Order>
					<Path>cmd.exe /c "&gt;&gt;"X:\diskpart.txt" echo CLEAN"</Path>
				</RunSynchronousCommand>
				<RunSynchronousCommand wcm:action="add">
					<Order>3</Order>
					<Path>cmd.exe /c "&gt;&gt;"X:\diskpart.txt" echo CONVERT GPT"</Path>
				</RunSynchronousCommand>
				<RunSynchronousCommand wcm:action="add">
					<Order>4</Order>
					<Path>cmd.exe /c "&gt;&gt;"X:\diskpart.txt" echo CREATE PARTITION EFI SIZE=300"</Path>
				</RunSynchronousCommand>
				<RunSynchronousCommand wcm:action="add">
					<Order>5</Order>
					<Path>cmd.exe /c "&gt;&gt;"X:\diskpart.txt" echo FORMAT QUICK FS=FAT32 LABEL="System""</Path>
				</RunSynchronousCommand>
				<RunSynchronousCommand wcm:action="add">
					<Order>6</Order>
					<Path>cmd.exe /c "&gt;&gt;"X:\diskpart.txt" echo CREATE PARTITION MSR SIZE=16"</Path>
				</RunSynchronousCommand>
				<RunSynchronousCommand wcm:action="add">
					<Order>7</Order>
					<Path>cmd.exe /c "&gt;&gt;"X:\diskpart.txt" echo CREATE PARTITION PRIMARY"</Path>
				</RunSynchronousCommand>
				<RunSynchronousCommand wcm:action="add">
					<Order>8</Order>
					<Path>cmd.exe /c "&gt;&gt;"X:\diskpart.txt" echo SHRINK MINIMUM=1000"</Path>
				</RunSynchronousCommand>
				<RunSynchronousCommand wcm:action="add">
					<Order>9</Order>
					<Path>cmd.exe /c "&gt;&gt;"X:\diskpart.txt" echo FORMAT QUICK FS=NTFS LABEL="Windows""</Path>
				</RunSynchronousCommand>
				<RunSynchronousCommand wcm:action="add">
					<Order>10</Order>
					<Path>cmd.exe /c "&gt;&gt;"X:\diskpart.txt" echo CREATE PARTITION PRIMARY"</Path>
				</RunSynchronousCommand>
				<RunSynchronousCommand wcm:action="add">
					<Order>11</Order>
					<Path>cmd.exe /c "&gt;&gt;"X:\diskpart.txt" echo FORMAT QUICK FS=NTFS LABEL="Recovery""</Path>
				</RunSynchronousCommand>
				<RunSynchronousCommand wcm:action="add">
					<Order>12</Order>
					<Path>cmd.exe /c "&gt;&gt;"X:\diskpart.txt" echo SET ID="de94bba4-06d1-4d40-a16a-bfd50179d6ac""</Path>
				</RunSynchronousCommand>
				<RunSynchronousCommand wcm:action="add">
					<Order>13</Order>
					<Path>cmd.exe /c "&gt;&gt;"X:\diskpart.txt" echo GPT ATTRIBUTES=0x8000000000000001"</Path>
				</RunSynchronousCommand>
				<RunSynchronousCommand wcm:action="add">
					<Order>14</Order>
					<Path>cmd.exe /c "&gt;&gt;"X:\diskpart.log" diskpart.exe /s "X:\diskpart.txt""</Path>
				</RunSynchronousCommand>
				<RunSynchronousCommand wcm:action="add">
					<Order>15</Order>
					<Path>reg.exe add "HKLM\SYSTEM\Setup\LabConfig" /v BypassTPMCheck /t REG_DWORD /d 1 /f</Path>
				</RunSynchronousCommand>
				<RunSynchronousCommand wcm:action="add">
					<Order>16</Order>
					<Path>reg.exe add "HKLM\SYSTEM\Setup\LabConfig" /v BypassSecureBootCheck /t REG_DWORD /d 1 /f</Path>
				</RunSynchronousCommand>
				<RunSynchronousCommand wcm:action="add">
					<Order>17</Order>
					<Path>reg.exe add "HKLM\SYSTEM\Setup\LabConfig" /v BypassStorageCheck /t REG_DWORD /d 1 /f</Path>
				</RunSynchronousCommand>
				<RunSynchronousCommand wcm:action="add">
					<Order>18</Order>
					<Path>reg.exe add "HKLM\SYSTEM\Setup\LabConfig" /v BypassCPUCheck /t REG_DWORD /d 1 /f</Path>
				</RunSynchronousCommand>
				<RunSynchronousCommand wcm:action="add">
					<Order>19</Order>
					<Path>reg.exe add "HKLM\SYSTEM\Setup\LabConfig" /v BypassRAMCheck /t REG_DWORD /d 1 /f</Path>
				</RunSynchronousCommand>
				<RunSynchronousCommand wcm:action="add">
					<Order>20</Order>
					<Path>reg.exe add "HKLM\SYSTEM\Setup\LabConfig" /v BypassDiskCheck /t REG_DWORD /d 1 /f</Path>
				</RunSynchronousCommand>
			</RunSynchronous>
		</component>
	</settings>
	<settings pass="generalize"></settings>
	<settings pass="specialize">
		<component name="Microsoft-Windows-Deployment" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS">
			<RunSynchronous>
				<RunSynchronousCommand wcm:action="add">
					<Order>1</Order>
					<Path>reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\OOBE" /v BypassNRO /t REG_DWORD /d 1 /f</Path>
				</RunSynchronousCommand>
				<RunSynchronousCommand wcm:action="add">
					<Order>2</Order>
					<Path>reg.exe load "HKU\DefaultUser" "C:\Users\Default\NTUSER.DAT"</Path>
				</RunSynchronousCommand>
				<RunSynchronousCommand wcm:action="add">
					<Order>3</Order>
					<Path>reg.exe add "HKU\DefaultUser\Software\Microsoft\Windows\CurrentVersion\Runonce" /v "UninstallCopilot" /t REG_SZ /d "powershell.exe -NoProfile -Command \"Get-AppxPackage -Name 'Microsoft.Windows.Ai.Copilot.Provider' | Remove-AppxPackage;\"" /f</Path>
				</RunSynchronousCommand>
				<RunSynchronousCommand wcm:action="add">
					<Order>4</Order>
					<Path>reg.exe add "HKU\DefaultUser\Software\Policies\Microsoft\Windows\WindowsCopilot" /v TurnOffWindowsCopilot /t REG_DWORD /d 1 /f</Path>
				</RunSynchronousCommand>
				<RunSynchronousCommand wcm:action="add">
					<Order>5</Order>
					<Path>reg.exe unload "HKU\DefaultUser"</Path>
				</RunSynchronousCommand>
				<RunSynchronousCommand wcm:action="add">
					<Order>6</Order>
					<Path>reg.exe delete "HKLM\SOFTWARE\Microsoft\WindowsUpdate\Orchestrator\UScheduler_Oobe\DevHomeUpdate" /f</Path>
				</RunSynchronousCommand>
				<RunSynchronousCommand wcm:action="add">
					<Order>7</Order>
					<Path>cmd.exe /c "del "C:\Users\Default\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\OneDrive.lnk""</Path>
				</RunSynchronousCommand>
				<RunSynchronousCommand wcm:action="add">
					<Order>8</Order>
					<Path>cmd.exe /c "del "C:\Windows\System32\OneDriveSetup.exe""</Path>
				</RunSynchronousCommand>
				<RunSynchronousCommand wcm:action="add">
					<Order>9</Order>
					<Path>cmd.exe /c "del "C:\Windows\SysWOW64\OneDriveSetup.exe""</Path>
				</RunSynchronousCommand>
				<RunSynchronousCommand wcm:action="add">
					<Order>10</Order>
					<Path>reg.exe load "HKU\DefaultUser" "C:\Users\Default\NTUSER.DAT"</Path>
				</RunSynchronousCommand>
				<RunSynchronousCommand wcm:action="add">
					<Order>11</Order>
					<Path>reg.exe delete "HKU\DefaultUser\Software\Microsoft\Windows\CurrentVersion\Run" /v OneDriveSetup /f</Path>
				</RunSynchronousCommand>
				<RunSynchronousCommand wcm:action="add">
					<Order>12</Order>
					<Path>reg.exe unload "HKU\DefaultUser"</Path>
				</RunSynchronousCommand>
				<RunSynchronousCommand wcm:action="add">
					<Order>13</Order>
					<Path>reg.exe delete "HKLM\SOFTWARE\Microsoft\WindowsUpdate\Orchestrator\UScheduler_Oobe\OutlookUpdate" /f</Path>
				</RunSynchronousCommand>
				<RunSynchronousCommand wcm:action="add">
					<Order>14</Order>
					<Path>reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Communications" /v ConfigureChatAutoInstall /t REG_DWORD /d 0 /f</Path>
				</RunSynchronousCommand>
				<RunSynchronousCommand wcm:action="add">
					<Order>15</Order>
					<Path>powershell.exe -NoProfile -Command "$xml = [xml]::new(); $xml.Load('C:\Windows\Panther\unattend.xml'); $sb = [scriptblock]::Create( $xml.unattend.Extensions.ExtractScript ); Invoke-Command -ScriptBlock $sb -ArgumentList $xml;"</Path>
				</RunSynchronousCommand>
				<RunSynchronousCommand wcm:action="add">
					<Order>16</Order>
					<Path>powershell.exe -NoProfile -Command "Get-Content -LiteralPath 'C:\Windows\Temp\remove-packages.ps1' -Raw | Invoke-Expression;"</Path>
				</RunSynchronousCommand>
				<RunSynchronousCommand wcm:action="add">
					<Order>17</Order>
					<Path>powershell.exe -NoProfile -Command "Get-Content -LiteralPath 'C:\Windows\Temp\remove-caps.ps1' -Raw | Invoke-Expression;"</Path>
				</RunSynchronousCommand>
				<RunSynchronousCommand wcm:action="add">
					<Order>18</Order>
					<Path>reg.exe add "HKLM\SOFTWARE\Microsoft\PolicyManager\current\device\Start" /v ConfigureStartPins /t REG_SZ /d "{ \"pinnedList\": [] }" /f</Path>
				</RunSynchronousCommand>
				<RunSynchronousCommand wcm:action="add">
					<Order>19</Order>
					<Path>reg.exe add "HKLM\SOFTWARE\Microsoft\PolicyManager\current\device\Start" /v ConfigureStartPins_ProviderSet /t REG_DWORD /d 1 /f</Path>
				</RunSynchronousCommand>
				<RunSynchronousCommand wcm:action="add">
					<Order>20</Order>
					<Path>reg.exe add "HKLM\SOFTWARE\Microsoft\PolicyManager\current\device\Start" /v ConfigureStartPins_WinningProvider /t REG_SZ /d B5292708-1619-419B-9923-E5D9F3925E71 /f</Path>
				</RunSynchronousCommand>
				<RunSynchronousCommand wcm:action="add">
					<Order>21</Order>
					<Path>reg.exe add "HKLM\SOFTWARE\Microsoft\PolicyManager\providers\B5292708-1619-419B-9923-E5D9F3925E71\default\Device\Start" /v ConfigureStartPins /t REG_SZ /d "{ \"pinnedList\": [] }" /f</Path>
				</RunSynchronousCommand>
				<RunSynchronousCommand wcm:action="add">
					<Order>22</Order>
					<Path>reg.exe add "HKLM\SOFTWARE\Microsoft\PolicyManager\providers\B5292708-1619-419B-9923-E5D9F3925E71\default\Device\Start" /v ConfigureStartPins_LastWrite /t REG_DWORD /d 1 /f</Path>
				</RunSynchronousCommand>
				<RunSynchronousCommand wcm:action="add">
					<Order>23</Order>
					<Path>net.exe accounts /lockoutthreshold:0</Path>
				</RunSynchronousCommand>
				<RunSynchronousCommand wcm:action="add">
					<Order>24</Order>
					<Path>net.exe accounts /maxpwage:UNLIMITED</Path>
				</RunSynchronousCommand>
				<RunSynchronousCommand wcm:action="add">
					<Order>25</Order>
					<Path>reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\FileSystem" /v LongPathsEnabled /t REG_DWORD /d 1 /f</Path>
				</RunSynchronousCommand>
				<RunSynchronousCommand wcm:action="add">
					<Order>26</Order>
					<Path>powershell.exe -NoProfile -Command "Set-ExecutionPolicy -Scope 'LocalMachine' -ExecutionPolicy 'RemoteSigned' -Force;"</Path>
				</RunSynchronousCommand>
				<RunSynchronousCommand wcm:action="add">
					<Order>27</Order>
					<Path>reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Dsh" /v AllowNewsAndInterests /t REG_DWORD /d 0 /f</Path>
				</RunSynchronousCommand>
				<RunSynchronousCommand wcm:action="add">
					<Order>28</Order>
					<Path>reg.exe load "HKU\DefaultUser" "C:\Users\Default\NTUSER.DAT"</Path>
				</RunSynchronousCommand>
				<RunSynchronousCommand wcm:action="add">
					<Order>29</Order>
					<Path>reg.exe add "HKU\DefaultUser\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "ContentDeliveryAllowed" /t REG_DWORD /d 0 /f</Path>
				</RunSynchronousCommand>
				<RunSynchronousCommand wcm:action="add">
					<Order>30</Order>
					<Path>reg.exe add "HKU\DefaultUser\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "FeatureManagementEnabled" /t REG_DWORD /d 0 /f</Path>
				</RunSynchronousCommand>
				<RunSynchronousCommand wcm:action="add">
					<Order>31</Order>
					<Path>reg.exe add "HKU\DefaultUser\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "OEMPreInstalledAppsEnabled" /t REG_DWORD /d 0 /f</Path>
				</RunSynchronousCommand>
				<RunSynchronousCommand wcm:action="add">
					<Order>32</Order>
					<Path>reg.exe add "HKU\DefaultUser\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "PreInstalledAppsEnabled" /t REG_DWORD /d 0 /f</Path>
				</RunSynchronousCommand>
				<RunSynchronousCommand wcm:action="add">
					<Order>33</Order>
					<Path>reg.exe add "HKU\DefaultUser\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "PreInstalledAppsEverEnabled" /t REG_DWORD /d 0 /f</Path>
				</RunSynchronousCommand>
				<RunSynchronousCommand wcm:action="add">
					<Order>34</Order>
					<Path>reg.exe add "HKU\DefaultUser\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SilentInstalledAppsEnabled" /t REG_DWORD /d 0 /f</Path>
				</RunSynchronousCommand>
				<RunSynchronousCommand wcm:action="add">
					<Order>35</Order>
					<Path>reg.exe add "HKU\DefaultUser\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SoftLandingEnabled" /t REG_DWORD /d 0 /f</Path>
				</RunSynchronousCommand>
				<RunSynchronousCommand wcm:action="add">
					<Order>36</Order>
					<Path>reg.exe add "HKU\DefaultUser\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContentEnabled" /t REG_DWORD /d 0 /f</Path>
				</RunSynchronousCommand>
				<RunSynchronousCommand wcm:action="add">
					<Order>37</Order>
					<Path>reg.exe add "HKU\DefaultUser\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-310093Enabled" /t REG_DWORD /d 0 /f</Path>
				</RunSynchronousCommand>
				<RunSynchronousCommand wcm:action="add">
					<Order>38</Order>
					<Path>reg.exe add "HKU\DefaultUser\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-338387Enabled" /t REG_DWORD /d 0 /f</Path>
				</RunSynchronousCommand>
				<RunSynchronousCommand wcm:action="add">
					<Order>39</Order>
					<Path>reg.exe add "HKU\DefaultUser\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-338388Enabled" /t REG_DWORD /d 0 /f</Path>
				</RunSynchronousCommand>
				<RunSynchronousCommand wcm:action="add">
					<Order>40</Order>
					<Path>reg.exe add "HKU\DefaultUser\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-338389Enabled" /t REG_DWORD /d 0 /f</Path>
				</RunSynchronousCommand>
				<RunSynchronousCommand wcm:action="add">
					<Order>41</Order>
					<Path>reg.exe add "HKU\DefaultUser\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-338393Enabled" /t REG_DWORD /d 0 /f</Path>
				</RunSynchronousCommand>
				<RunSynchronousCommand wcm:action="add">
					<Order>42</Order>
					<Path>reg.exe add "HKU\DefaultUser\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-353698Enabled" /t REG_DWORD /d 0 /f</Path>
				</RunSynchronousCommand>
				<RunSynchronousCommand wcm:action="add">
					<Order>43</Order>
					<Path>reg.exe add "HKU\DefaultUser\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SystemPaneSuggestionsEnabled" /t REG_DWORD /d 0 /f</Path>
				</RunSynchronousCommand>
				<RunSynchronousCommand wcm:action="add">
					<Order>44</Order>
					<Path>reg.exe unload "HKU\DefaultUser"</Path>
				</RunSynchronousCommand>
				<RunSynchronousCommand wcm:action="add">
					<Order>45</Order>
					<Path>reg.exe add "HKLM\Software\Policies\Microsoft\Windows\CloudContent" /v "DisableWindowsConsumerFeatures" /t REG_DWORD /d 0 /f</Path>
				</RunSynchronousCommand>
				<RunSynchronousCommand wcm:action="add">
					<Order>46</Order>
					<Path>reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\BitLocker" /v "PreventDeviceEncryption" /t REG_DWORD /d 1 /f</Path>
				</RunSynchronousCommand>
				<RunSynchronousCommand wcm:action="add">
					<Order>47</Order>
					<Path>xcopy d:\software\turingfiles\*.* c:\TURING\*.* /S /E</Path>
				</RunSynchronousCommand>
			</RunSynchronous>
		    <RunAsynchronous>
                <RunAsynchronousCommand wcm:action="add">
                    <Description>Edge first run</Description>
                    <Order>1</Order>
                    <Path>cmd /c reg add HKLM\software\policies\microsoft\Edge /v HideFirstRunExperience /t REG_DWORD /d 1 /f</Path>
                </RunAsynchronousCommand>
                <RunAsynchronousCommand wcm:action="add">
                    <Description>Edge Setting</Description>
                    <Order>2</Order>
                    <Path>cmd /c reg add HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\EdgeUpdate /v UpdateDefault /t REG_DWORD /d 3 /f</Path>
                </RunAsynchronousCommand>
                <RunAsynchronousCommand wcm:action="add">
                    <Description>Edge Settings</Description>
                    <Order>3</Order>
                    <Path>cmd /c reg add HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\EdgeUpdate /v InstallDefault /t REG_DWORD /d 1 /f</Path>
                </RunAsynchronousCommand>
                <RunAsynchronousCommand wcm:action="add">
                    <Description>Edge Settings</Description>
                    <Order>4</Order>
                    <Path>cmd /c reg add HKLM\software\microsoft\windows\currentversion\policies\system /v EnableFirstLogonAnimation /t REG_DWORD /d 0 /f</Path>
                </RunAsynchronousCommand>
                <RunAsynchronousCommand wcm:action="add">
                    <Description>Network Discovery</Description>
                    <Order>5</Order>
                    <Path>cmd /c reg add HKLM\software\microsoft\windows\currentversion\CONTROL\NETWORK\NewNetworkWindowsOff /F</Path>
                </RunAsynchronousCommand>
                <RunAsynchronousCommand wcm:action="add">
                    <Description>Network Discovery</Description>
                    <Order>6</Order>
                    <Path>cmd /c reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\PersonalizationCSP /v LockScreenImagePath /d C:\turing\Background.jpg /F</Path>
                </RunAsynchronousCommand>
            </RunAsynchronous>
		</component>
	</settings>
	<settings pass="auditSystem"></settings>
	<settings pass="auditUser"></settings>
	<settings pass="oobeSystem">
		<component name="Microsoft-Windows-International-Core" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS">
			<InputLocale>0809:00000809</InputLocale>
			<SystemLocale>en-GB</SystemLocale>
			<UILanguage>en-GB</UILanguage>
			<UserLocale>en-GB</UserLocale>
		</component>
		<component name="Microsoft-Windows-Shell-Setup" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS">
			<UserAccounts>
				<LocalAccounts>
					<LocalAccount wcm:action="add">
						<Name>User1</Name>
						<Group>Administrators</Group>
						<Password>
							<Value></Value>
							<PlainText>true</PlainText>
						</Password>
						<DisplayName>Admin/Power User Account</DisplayName>
					</LocalAccount>
				</LocalAccounts>
			</UserAccounts>
			<AutoLogon>
				<Username>User1</Username>
				<Enabled>true</Enabled>
				<LogonCount>1</LogonCount>
				<Password>
					<Value></Value>
					<PlainText>true</PlainText>
				</Password>
			</AutoLogon>
			<OOBE>
				<ProtectYourPC>3</ProtectYourPC>
				<HideEULAPage>true</HideEULAPage>
				<HideWirelessSetupInOOBE>true</HideWirelessSetupInOOBE>
			</OOBE>
			<FirstLogonCommands>
				<SynchronousCommand wcm:action="add">
					<Order>1</Order>
					<CommandLine>cmd.exe /c reg.exe add HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon /v AutoLogonCount /t REG_DWORD /d 0 /f</CommandLine>
				</SynchronousCommand>
				<SynchronousCommand wcm:action="add">
					<Order>2</Order>
					<CommandLine>powershell.exe -NoProfile -Command "Disable-ComputerRestore -Drive 'C:\';"</CommandLine>
				</SynchronousCommand>
	       		<SynchronousCommand wcm:action="add">
					<Order>3</Order>
					<CommandLine>cmd.exe /c reg.exe add HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search /v SearchboxTaskbarMode /t REG_DWORD /d 1 /f;</CommandLine>
				</SynchronousCommand>
				<SynchronousCommand wcm:action="add">
					<Order>4</Order>
					<CommandLine>cmd.exe /c reg.exe add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v HideFileExt /d 0 /f;</CommandLine>
				</SynchronousCommand>
 				<SynchronousCommand wcm:action="add">
					<Order>5</Order>
					<CommandLine>c:\Turing\software\Scratch 3.29.1 Setup.exe /S /allusers</CommandLine>
				</SynchronousCommand>
				<SynchronousCommand wcm:action="add">
					<Order>6</Order>
					<CommandLine>c:\Turing\software\RapidTyping_Setup_5.4.exe /S</CommandLine>
				</SynchronousCommand>
				<SynchronousCommand wcm:action="add">
					<Order>7</Order>
					<CommandLine>msiexec.exe /qn /i c:\Turing\software\LibreOffice_24.2.4_Win_x86-64.msi /norestart ALLUSERS=1 ISCHECKFORPRODUCTUPDATES=0 QUICKSTART=1</CommandLine>
				</SynchronousCommand>
				<SynchronousCommand wcm:action="add">
					<Order>8</Order>
					<CommandLine>c:\Turing\software\python-3.10.8-amd64.exe /quiet PrependPath=1</CommandLine>
				</SynchronousCommand>
				<SynchronousCommand wcm:action="add">
					<Order>9</Order>
					<CommandLine>msiexec /qb /i c:\turing\software\python-2.7.18.amd64.msi</CommandLine>
				</SynchronousCommand>
				<SynchronousCommand wcm:action="add">
					<Order>10</Order>
					<CommandLine>msiexec /qb /i c:\turing\software\GoogleChromeStandaloneEnterprise64.msi</CommandLine>
				</SynchronousCommand>
				<SynchronousCommand wcm:action="add">
					<Order>11</Order>
					<CommandLine>c:\Turing\software\vlc-3.0.21-win64.exe /L=1033 /S</CommandLine>
				</SynchronousCommand>
				<SynchronousCommand wcm:action="add">
					<Order>12</Order>
					<CommandLine>cmd.exe /c echo C:\Turing\software\Bginfo64.exe c:\turing\software\turing.bgi /timer:0 /nolicprompt /silent > "C:\Users\User1\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\background.cmd"</CommandLine>
				</SynchronousCommand>
				<SynchronousCommand wcm:action="add">
					<Order>13</Order>
					<CommandLine>cmd.exe /c copy c:\turing\shortcuts\*.* c:\users\user1\desktop\*.* /y</CommandLine>
				</SynchronousCommand>
				<SynchronousCommand wcm:action="add">
					<Order>14</Order>
					<CommandLine>c:\turing\settings.cmd</CommandLine>
				</SynchronousCommand>
			</FirstLogonCommands>
		</component>
	</settings>
	<Extensions xmlns="https://schneegans.de/windows/unattend-generator/">
		<ExtractScript>
param(
    [xml] $Document
);

$scriptsDir = 'C:\Windows\Setup\Scripts\';
foreach( $file in $Document.unattend.Extensions.File ) {
    $path = [System.Environment]::ExpandEnvironmentVariables(
        $file.GetAttribute( 'path' )
    );
    if( $path.StartsWith( $scriptsDir ) ) {
        mkdir -Path $scriptsDir -ErrorAction 'SilentlyContinue';
    }
    $encoding = switch( [System.IO.Path]::GetExtension( $path ) ) {
        { $_ -in '.ps1', '.xml' } { [System.Text.Encoding]::UTF8; }
        { $_ -in '.reg', '.vbs', '.js' } { [System.Text.UnicodeEncoding]::new( $false, $true ); }
        default { [System.Text.Encoding]::Default; }
    };
    [System.IO.File]::WriteAllBytes( $path, ( $encoding.GetPreamble() + $encoding.GetBytes( $file.InnerText.Trim() ) ) );
}
		</ExtractScript>
		<File path="C:\Windows\Temp\remove-packages.ps1">
$selectors = @(
	'Microsoft.Microsoft3DViewer';
	'Microsoft.BingSearch';
	'Microsoft.WindowsCamera';
	'Clipchamp.Clipchamp';
	'Microsoft.549981C3F5F10';
	'Microsoft.Windows.DevHome';
	'MicrosoftCorporationII.MicrosoftFamily';
	'Microsoft.WindowsFeedbackHub';
	'microsoft.windowscommunicationsapps';
	'Microsoft.WindowsMaps';
	'Microsoft.ZuneVideo';
	'Microsoft.BingNews';
	'Microsoft.MicrosoftOfficeHub';
	'Microsoft.Office.OneNote';
	'Microsoft.OutlookForWindows';
	'Microsoft.MSPaint';
	'Microsoft.People';
	'Microsoft.PowerAutomateDesktop';
	'MicrosoftCorporationII.QuickAssist';
	'Microsoft.SkypeApp';
	'Microsoft.MicrosoftSolitaireCollection';
	'MSTeams';
	'Microsoft.WindowsSoundRecorder';
	'Microsoft.BingWeather';
	'Microsoft.Xbox.TCUI';
	'Microsoft.XboxApp';
	'Microsoft.XboxGameOverlay';
	'Microsoft.XboxGamingOverlay';
	'Microsoft.XboxIdentityProvider';
	'Microsoft.XboxSpeechToTextOverlay';
	'Microsoft.GamingApp';
	'Microsoft.YourPhone';
);
$getCommand = { Get-AppxProvisionedPackage -Online; };
$filterCommand = { $_.DisplayName -eq $selector; };
$removeCommand = {
  [CmdletBinding()]
  param(
    [Parameter( Mandatory, ValueFromPipeline )]
    $InputObject
  );
  process {
    $InputObject | Remove-AppxProvisionedPackage -AllUsers -Online -ErrorAction 'Continue';
  }
};
$type = 'Package';
$logfile = 'C:\Windows\Temp\remove-packages.log';
&amp; {
	$installed = &amp; $getCommand;
	foreach( $selector in $selectors ) {
		$result = [ordered] @{
			Selector = $selector;
		};
		$found = $installed | Where-Object -FilterScript $filterCommand;
		if( $found ) {
			$result.Output = $found | &amp; $removeCommand;
			if( $? ) {
				$result.Message = "$type removed.";
			} else {
				$result.Message = "$type not removed.";
				$result.Error = $Error[0];
			}
		} else {
			$result.Message = "$type not installed.";
		}
		$result | ConvertTo-Json -Depth 3 -Compress;
	}
} *&gt;&amp;1 &gt;&gt; $logfile;
		</File>
		<File path="C:\Windows\Temp\remove-caps.ps1">
$selectors = @(
	'Browser.InternetExplorer';
	'MathRecognizer';
	'Microsoft.Windows.Notepad';
	'App.Support.QuickAssist';
	'App.StepsRecorder';
	'Media.WindowsMediaPlayer';
	'Microsoft.Windows.WordPad';
);
$getCommand = { Get-WindowsCapability -Online; };
$filterCommand = { ($_.Name -split '~')[0] -eq $selector; };
$removeCommand = {
  [CmdletBinding()]
  param(
    [Parameter( Mandatory, ValueFromPipeline )]
    $InputObject
  );
  process {
    $InputObject | Remove-WindowsCapability -Online -ErrorAction 'Continue';
  }
};
$type = 'Capability';
$logfile = 'C:\Windows\Temp\remove-caps.log';
&amp; {
	$installed = &amp; $getCommand;
	foreach( $selector in $selectors ) {
		$result = [ordered] @{
			Selector = $selector;
		};
		$found = $installed | Where-Object -FilterScript $filterCommand;
		if( $found ) {
			$result.Output = $found | &amp; $removeCommand;
			if( $? ) {
				$result.Message = "$type removed.";
			} else {
				$result.Message = "$type not removed.";
				$result.Error = $Error[0];
			}
		} else {
			$result.Message = "$type not installed.";
		}
		$result | ConvertTo-Json -Depth 3 -Compress;
	}
} *&gt;&amp;1 &gt;&gt; $logfile;
		</File>
		<File path="C:\Users\Default\AppData\Local\Microsoft\Windows\Shell\LayoutModification.xml"><![CDATA[
<LayoutModificationTemplate Version="1" xmlns="http://schemas.microsoft.com/Start/2014/LayoutModification">
	<LayoutOptions StartTileGroupCellWidth="6" />
	<DefaultLayoutOverride>
		<StartLayoutCollection>
			<StartLayout GroupCellWidth="6" xmlns="http://schemas.microsoft.com/Start/2014/FullDefaultLayout" />
		</StartLayoutCollection>
	</DefaultLayoutOverride>
</LayoutModificationTemplate>
		]]></File>
	</Extensions>
</unattend>