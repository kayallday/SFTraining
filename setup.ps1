param (
	[string]$webSiteName = "Nerdlings",
	[string]$webProjectName = "sitefinitytraining",
	[string]$solutionDir = (Split-Path $MyInvocation.MyCommand.Path) 
)

. "$solutionDir\iis.ps1"

function main {
	#Enable-WindowsFeatures
	Setup-LocalSite $webSiteName "$solutionDir\$webProjectName"
	Install-FeatherNodeTools
}

function Install-FeatherNodeTools {
	pushd "$solutionDir\$webProjectName\ResourcePackages\Bootstrap"
	npm install --global --production windows-build-tools	
	npm install
	npm install -g grunt-cli
	grunt
	popd
}

Try { main } 
Catch { Write-Error $_.Exception }