param(
  [Parameter(Mandatory = $true)]
  [ValidateSet('Start','Stop')]
  [string]$Action
)

# 加载 Windows Runtime 所需的程序集
Add-Type -AssemblyName System.Runtime.WindowsRuntime

# 获取当前的网络连接配置（用于创建热点管理器）
$connectionProfile = [Windows.Networking.Connectivity.NetworkInformation,Windows.Networking.Connectivity,ContentType=WindowsRuntime]::GetInternetConnectionProfile()
if (-not $connectionProfile) {
  Write-Error "No internet connection profile found. Connect to a network before running this script."
  exit 1
}

# 仅在以太网连接时允许开启热点（IANA 类型 6 = Ethernet）
$isEthernet = $connectionProfile.NetworkAdapter -and $connectionProfile.NetworkAdapter.IanaInterfaceType -eq 6
if (-not $isEthernet -and $Action -eq 'Start') {
  Write-Error "Hotspot can only be started when connected via Ethernet."
  exit 1
}

# 通过连接配置创建热点管理器
$tetheringManager = [Windows.Networking.NetworkOperators.NetworkOperatorTetheringManager,Windows.Networking.NetworkOperators,ContentType=WindowsRuntime]::CreateFromConnectionProfile($connectionProfile)

switch ($Action) {
  'Start' {
    # 开启移动热点
    $task = [System.WindowsRuntimeSystemExtensions]::AsTask($tetheringManager.StartTetheringAsync())
    $task.Wait()
  }
  'Stop' {
    # 关闭移动热点
    $task = [System.WindowsRuntimeSystemExtensions]::AsTask($tetheringManager.StopTetheringAsync())
    $task.Wait()
  }
}
