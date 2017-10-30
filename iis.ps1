param (
	[string]$hostsFile = "C:\Windows\System32\drivers\etc\hosts",
	[string]$ip = "127.0.0.1"
)

function Enable-WindowsFeatures {
	Enable-WindowsOptionalFeature -Online -All -FeatureName IIS-NetFxExtensibility45
	Enable-WindowsOptionalFeature -Online -All -FeatureName IIS-ApplicationInit
	Enable-WindowsOptionalFeature -Online -All -FeatureName IIS-ASPNET45
	Enable-WindowsOptionalFeature -Online -All -FeatureName IIS-ISAPIExtensions
	Enable-WindowsOptionalFeature -Online -All -FeatureName IIS-ISAPIFilter
	Enable-WindowsOptionalFeature -Online -All -FeatureName IIS-ServerSideIncludes
	Enable-WindowsOptionalFeature -Online -All -FeatureName IIS-WebSockets
}

function Ensure-HandlerMappings([string]$appNamePath) {
	$exists = Get-WebHandler -name "*.svc" -PSPath $appNamePath -ErrorAction SilentlyContinue
	if( !$exists ) {
		New-WebHandler -Name "*.svc" -Path *.svc -Verb '*' -PSPath $appNamePath -Type "System.ServiceModel.Activation.ServiceHttpHandlerFactory, System.ServiceModel.Activation, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
	}

	$exists = Get-WebHandler -name "*.svc (script)" -PSPath $appNamePath -ErrorAction SilentlyContinue
	if( !$exists ) {
		New-WebHandler -Name "*.svc (script)" -Path *.svc -Verb '*' -Modules IsapiModule -PSPath $appNamePath -ScriptProcessor "C:\Windows\Microsoft.NET\Framework\v4.0.30319\aspnet_isapi.dll" -ResourceType "unspecified" -preCondition "classicMode,runtimeVersionv4.0,bitness32"
	}

	$exists = Get-WebHandler -name "*.xamlx" -PSPath $appNamePath -ErrorAction SilentlyContinue
	if( !$exists ) {
		New-WebHandler -Name "*.xamlx" -Path *.xamlx -Verb '*' -PSPath $appNamePath -Type "System.Xaml.Hosting.XamlHttpHandlerFactory, System.Xaml.Hosting, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
	}

	$exists = Get-WebHandler -name "*.xamlx (script)" -PSPath $appNamePath -ErrorAction SilentlyContinue
	if( !$exists ) {
		New-WebHandler -Name "*.xamlx (script)" -Path *.xamlx -Verb '*' -Modules IsapiModule -PSPath $appNamePath -ScriptProcessor "C:\Windows\Microsoft.NET\Framework\v4.0.30319\aspnet_isapi.dll" -ResourceType "unspecified" -preCondition "classicMode,runtimeVersionv4.0,bitness32"
	}
}

function Get-AppPoolUserName([string]$appPoolName) {
	return "IIS AppPool\$appPoolName" 
}

function Create-WebApplication ([string]$name, [string]$path) {
	$hostHeader = "$name.local"

	Create-IISAppAndSite $name $path $hostHeader
	Set-DirectoryPermissions $path (Get-AppPoolUserName $name) "Modify"
	Add-LocalHostHeader $hostHeader
}

function Create-IISAppAndSite ([string] $name, [string] $path, [string] $hostHeader) {
	New-WebAppPool -Name $name
	New-WebSite -Name $name -ApplicationPool $name -Port 80 -HostHeader $hostHeader -PhysicalPath $path
}

function Set-DirectoryPermissions ([string] $path, [string] $userID, [string] $rights) {
	$list = Get-Acl $path
	$rule = New-Object system.security.accesscontrol.filesystemaccessrule($userID,$rights,"Allow")
	$list.SetAccessRule($rule)
	Set-Acl $path $list
}

function Add-LocalHostHeader ([string] $hostHeader) {
	Add-Host $hostsFile $ip $hostHeader
	ipconfig /flushdns
}

function Add-Host([string]$filename, [string]$ip, [string]$hostname) {
	remove-host $filename $hostname
	$ip + "`t`t" + $hostname | Out-File -encoding ASCII -append $filename
}

function Remove-Host([string]$filename, [string]$hostname) {
	$c = Get-Content $filename
	$newLines = @()
	
	foreach ($line in $c) {
		$bits = [regex]::Split($line, "\t+")
		if ($bits.count -eq 2) {
			if ($bits[1] -ne $hostname) {
				$newLines += $line
			}
		} else {
			$newLines += $line
		}
	}
	
	# Write file
	Clear-Content $filename
	foreach ($line in $newLines) {
		$line | Out-File -encoding ASCII -append $filename
	}
}

function Setup-LocalSite ([string]$name, [string]$path) {
	Create-WebApplication $name $path
}