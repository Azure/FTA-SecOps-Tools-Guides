<#  
  .SYNOPSIS  
    This script will create the required resources and configurations to stream alerts from Microsoft Defender for Cloud to 3rd party SIEM.
      
  .DESCRIPTION  
    This script will....
    
  .PARAMETER TenantId
    [mandatory] 
    The tenant Id used to connect to Azure.

  .PARAMETER ServerPlan
    [mandatory] 
    Server plan to apply when enabling Defender for Servers Choices are P1 or P2.

  .PARAMETER SubscriptionFilePath
    [mandatory]
    The file path for the file that contains the list of subscriptions to apply the settings.

  .PARAMETER enableDefenderServers
    Switch to enable or disable Defender for Servers. True by default
    
  .PARAMETER disableMDEAutoprovisiong
    Switch to enable or disable MDE Autoprovisioning. False by default

  .PARAMETER disableAMAAutoprovisioning
    Switch to enable or disable AMA Autoprovisioning. False by default

  .PARAMETER disableAgentlessScanning
    Switch to enable or disable Agentless scanning for Machine. False by default

  .PARAMETER enableMdeWindows20122016
    Switch to enable or disable the Unified WDATP agent. False by default

  .PARAMETER installMonitorAgent
    Switch to install the Azure Monitor Agent or not. False by default

  .PARAMETER installMde
    Switch to install the Microsoft Defender for Endpoint or not. False by default

  .EXAMPLE
  .\EnableDfSMultiSubscriptions.ps1 -TenantId "79xxxxxx-xxxx-xxxx-xxxx-0a6ec6xxxxxx" -ServerPlan "P2" -SubscriptionFilePath "SubscriptionList.csv"

  .EXAMPLE
  .\EnableDfSMultiSubscriptions.ps1 -TenantId "79xxxxxx-xxxx-xxxx-xxxx-0a6ec6xxxxxx" -ServerPlan "P2" -SubscriptionFilePath "SubscriptionList.csv" -enableDefenderServers $true -disableMDEAutoprovisiong $true -disableAMAAutoprovisioning $true -enableMdeWindows20122016 $false -installMonitorAgent $false -installMde $false

  .NOTES
    AUTHOR: Patrice Lacroix
    LASTEDIT: June 6th, 2024
      - 0.1 change log: Initial commit

  .LINK
      This script posted to and discussed at the following locations:
      https://github.com.../
#>

[CmdletBinding()]
param (
    [Parameter(Mandatory=$true)]
    [string]$TenantId,
    [Parameter(Mandatory=$true)]
    [string]$ServerPlan,
    [Parameter(Mandatory=$true)]
    [string]$SubscriptionFilePath,
    [Parameter(Mandatory=$false)]
    [bool]$enableDefenderServers = $true,
    [Parameter(Mandatory=$false)]
    [bool]$disableMDEAutoprovisiong = $false,
    [Parameter(Mandatory=$false)]
    [bool]$disableAMAAutoprovisioning = $false,
    [Parameter(Mandatory=$false)]
    [bool]$disableAgentlessScanning = $false,
    [Parameter(Mandatory=$false)]
    [bool]$enableMdeWindows20122016 = $false,
    [Parameter(Mandatory=$false)]
    [bool]$installMonitorAgent = $false,
    [Parameter(Mandatory=$false)]
    [bool]$installMde = $false
)

#--------------------------------------------------------------------------------------------------------------------
# Enable/ Defender for Servers on Subscription
#--------------------------------------------------------------------------------------------------------------------
function EnableDefenderForServers {
    param (
        [Parameter(Mandatory=$true)]
        [bool]$enableDefenderServers
    )

    if ($enableDefenderServers) {
        Write-Output "Enabling Defender for Servers $($ServerPlan) on the subscription..."
        Set-AzSecurityPricing -Name "VirtualMachines" -PricingTier "Standard" -SubPlan $ServerPlan 
    }
}

#--------------------------------------------------------------------------------------------------------------------
# Enable/ Disable Agentless Scanning for Servers
#--------------------------------------------------------------------------------------------------------------------
function SetAgentlessScanning {
    param (
        [Parameter(Mandatory=$true)]
        [bool]$disableAgentlessScanning
    )

    if ($disableAgentlessScanning)
    {
        Write-Output "Disabling Agentless Scanning for Machines..."
        Set-AzSecurityPricing -Name "VirtualMachines" -PricingTier "Standard" -Extension '[{"name":"AgentlessVmScanning","isEnabled":"False"}]'  
    }
    else
    {
        Set-AzSecurityPricing -Name "VirtualMachines" -PricingTier "Standard" -Extension '[{"name":"AgentlessVmScanning","isEnabled":"True"}]' 
    }
}

#--------------------------------------------------------------------------------------------------------------------
# Control MDE deployment
#--------------------------------------------------------------------------------------------------------------------
function SetMDEAutoprovisiong {
    param (
        [Parameter(Mandatory=$false)]
        [bool]$disableMDEAutoprovisiong
    )
    
    #Get Security Settings for Sentinel, MCAS, WDATP(MDE), Unified and Linux
    #Get-AzSecuritySetting
    if ($disableMDEAutoprovisiong) {
        #MDE is turned on to auto-onboarding by default. You will need to turn it off to control the deployment
        Set-AzSecuritySetting -SettingName WDATP -SettingKind DataExportSettings -Enabled $false
    }
    else {
        Write-Output "Enabling MDE autoprovisioning. Microsoft Defender for Cloud will autoprovision MDE for all current and future systems"
        #use the same command but Enabled $true to turn it back on
        Set-AzSecuritySetting -SettingName WDATP -SettingKind DataExportSettings -Enabled $true
    }
    # Enable MDE for Windows 2012 and 2016 servers using Unified Solution capability
    if ($enableMdeWindows20122016) {
        Write-Output "Enabling MDE for Windows 2012 and 2016 servers..."
        Set-AzSecuritySetting -SettingName WDATP_UNIFIED_SOLUTION -SettingKind DataExportSettings -Enabled $true
    }
    else {
        Write-Output "No requirement for Unified agent. Continuing to next step......"
    }
}

#-------------------------------------------------------------------------------------------------------------------
#Enable/Disable Azure Monitoring Agent Autoprovisiong
#-------------------------------------------------------------------------------------------------------------------
function SetAMAAutoprovisiong {
    param (
        [Parameter(Mandatory=$false)]
        [bool]$disableAMAAutoprovisioning
    )

    #Turn autoprovisioning off
    if ($disableAMAAutoprovisioning) {
        #This default setting should now be turned off. 
        Write-Output "Azure Monitoring Agent will not be autoprovisioned"
        Set-AzSecurityAutoProvisioningSetting -Name "default"
    }
    else { 
        #Turn autoprovisioning on
        Write-Output "Azure Monitoring Agent will now be autoprovisioned across your Subscription for any current and future systems"
        Set-AzSecurityAutoProvisioningSetting -Name "default" -EnableAutoProvision
    }
}
#-------------------------------------------------------------------------------------------------------------------
# Install Extensions for enablement
#-------------------------------------------------------------------------------------------------------------------
function InstallExtensions {
    param (
        [Parameter(Mandatory = $true)]
        [bool]$installMonitorAgent,
        [Parameter(Mandatory = $true)]
        [bool]$installMde
    )
    try
	{
		# Get all virtual machines and ARC machines
        Write-Output "Get all virtual machines and ARC machines"
        $VMs = Get-AzResource -ResourceType "Microsoft.Compute/virtualMachines"
        $VMSSs = Get-AzResource -ResourceType "Microsoft.Compute/virtualMachineScaleSets"
        $arcMachines = Get-AzResource -ResourceType "Microsoft.HybridCompute/machines"

        Write-Output "Getting all VMs"
        if ($null -ne $VMs) {
            foreach ($vm in $VMs) {
                $vm = Get-AzVM -ResourceGroupName $vm.ResourceGroupName -Name $vm.Name

                Write-Output "Installing extensions for VM: $($vm.Name) in Resource Group: $($vm.ResourceGroupName)"
                InstallExtensionsForVM -installMonitorAgent $installMonitorAgent -installMde $installMde -vm $vm
            }
        } else {
            Write-Output "No VMs found"
        }

        Write-Output "Getting all Arc Machines"
        if ($null -ne $arcMachines) {
            foreach ($vm in $arcMachines) {
                $vm = Get-AzVM -ResourceGroupName $vm.ResourceGroupName -Name $vm.Name
                Write-Output "Installing extensions for Arc VM: $($vm.Name) in Resource Group: $($vm.ResourceGroupName)"
                InstallExtensionsForVM -installMonitorAgent $installMonitorAgent -installMde $installMde -rgName $vm.ResourceGroupName -vmName $vm.Name
            }
        } else {
            Write-Output "No Arc Machines found"
        }

        Write-Output "Get all VMSSs"
        if ($null -ne $VMSSs) {
            foreach ($vmSS in $VMSSs) {
                Write-Output "Installing extensions for VMSS: $($vmSS.Name) in Resource Group: $($vmSS.ResourceGroupName)"
                InstallExtensionsForVMSS -installMonitorAgent $installMonitorAgent -installMde $installMde -rgName $vmSS.ResourceGroupName -vmSSName $vmSS.Name
            }
        } else {
            Write-Output "No VMSSs found"
        }
    }
	catch 
	{
		Write-Host "Failed to Get resources! " -ForegroundColor Red
	}
}

function InstallExtensionsForVM {
    param (
        [Parameter(Mandatory = $true)]
        [bool]$installMonitorAgent,
        [Parameter(Mandatory = $true)]
        [bool]$installMde,
        [Parameter(Mandatory = $true)]
        [Object]$vm
    )
   
    # Find out if VM is Windows or Linux
    $osType = $vm.StorageProfile.OsDisk.OsType
    if($osType -eq "Windows") {
        Write-Output "VM is Windows..."
    }
    else {
        Write-Output "VM is Linux..."
    }
        
    # Install Azure Monitor Windows Agent extension
    if ($installMonitorAgent) {
        Write-Output "Installing Azure Monitor Windows Agent extension..."
        if($osType -eq "Windows") {
            Set-AzVMExtension -ResourceGroupName $rgName -VMName $vmName -Name "AzureMonitorWindowsAgent" -ExtensionType "AzureMonitorWindowsAgent" -Publisher "Microsoft.Azure.Monitor" -TypeHandlerVersion "1.0"
        }
        else {
            Set-AzVMExtension -ResourceGroupName $rgName -VMName $vmName -Name "AzureMonitorLinuxAgent" -ExtensionType "AzureMonitorLinuxAgent" -Publisher "Microsoft.Azure.Monitor" -TypeHandlerVersion "1.0"
        }
    }
    else {
        Write-Output "Not installing Azure Monitoring Agent. Continuing to next step......"
    }

    # Install Microsoft Defender for Endpoint
    if ($installMde) {
        Write-Output "Installing Microsoft Defender for Endpoint..."
        
        $mdePackage = Invoke-AzRestMethod -Uri https://management.azure.com/subscriptions/$($vm.id.split('/')[2])/providers/Microsoft.Security/mdeOnboardings/?api-version=2021-10-01-preview

        #You can add forceReOnboarding = $true below if you want to force onboarding again
        $Setting = @{
            "azureResourceId" = $vm.Id
            "vNextEnabled"    = $true
        }
        $protectedSetting = @{
            "defenderForEndpointOnboardingScript" = ($mdePackage.content | ConvertFrom-Json).value.properties.onboardingPackageWindows
        }
        
        if($osType -eq "Windows") {
            $protectedSetting = @{
                "defenderForEndpointOnboardingScript" = ($mdePackage.content | ConvertFrom-Json).value.properties.onboardingPackageWindows
            }
            Set-AzVMExtension -Name 'MDE.Windows' -ExtensionType 'MDE.Windows' -ResourceGroupName $vm.ResourceGroupName -VMName $vm.Name -Location $vm.Location -Publisher 'Microsoft.Azure.AzureDefenderForServers' -Settings $Setting -ProtectedSettings $protectedSetting -TypeHandlerVersion '1.0'
        }
        else {
            $protectedSetting = @{
                "defenderForEndpointOnboardingScript" = ($mdePackage.content | ConvertFrom-Json).value.properties.onboardingPackageLinux
            }
            Set-AzVMExtension -Name 'MDE.Linux' -ExtensionType 'MDE.Linux' -ResourceGroupName $vm.ResourceGroupName -VMName $vm.Name -Location $vm.Location -Publisher 'Microsoft.Azure.AzureDefenderForServers' -Settings $Setting -ProtectedSettings $protectedSetting -TypeHandlerVersion '1.0'
        }      
    }
    else {
        Write-Output "Not Installing Microsoft Defender for Endpoint. Script Complete"
    }
}

function InstallExtensionsForVMSS {
    param (
        [Parameter(Mandatory = $true)]
        [bool]$installMonitorAgent,
        [Parameter(Mandatory = $true)]
        [bool]$installMde,
        [Parameter(Mandatory = $true)]
        [string]$rgName,
        [Parameter(Mandatory = $true)]
        [string]$vmSSName        
    )

    $vmSS = Get-AzVmss -ResourceGroupName $rgName -Name $vmSSName
    $osType = $vmSS.VirtualMachineProfile.StorageProfile.OsDisk.OsType
    
    # Find out if VMSS is Windows or Linux
    if($osType -eq "Windows") {
        Write-Output "VMSS is Windows..."
    }
    else {
        Write-Output "VMSS is Linux..."
    }

    # Install Azure Monitor Windows Agent extension
    if ($installMonitorAgent) {
        Write-Output "Installing Azure Monitor Windows Agent extension for VMSS..."
        if($osType -eq "Windows") {
            Add-AzVmssExtension -VirtualMachineScaleSet $vmSS -Name "AzureMonitorWindowsAgent" -ExtensionType "AzureMonitorWindowsAgent" -Publisher "Microsoft.Azure.Monitor" -TypeHandlerVersion "1.0"
        }
        else {
            Add-AzVmssExtension -VirtualMachineScaleSet $vmSS -Name "AzureMonitorLinuxAgent" -ExtensionType "AzureMonitorLinuxAgent" -Publisher "Microsoft.Azure.Monitor" -TypeHandlerVersion "1.0"
        }
        # Update the VMSS
        Update-AzVmss -ResourceGroupName $vmSS.ResourceGroupName -Name $vmSS.Name -VirtualMachineScaleSet $vmss
    }
    else {
        Write-Output "Not installing Azure Monitoring Agent. Continuing to next step......"
    }

    # Install Microsoft Defender for Endpoint
    if ($installMde) {
        Write-Output "Installing Microsoft Defender for Endpoint on VMSS..."
        
        $mdePackage = Invoke-AzRestMethod -Uri https://management.azure.com/subscriptions/$($vmSS.Id.split('/')[2])/providers/Microsoft.Security/mdeOnboardings/?api-version=2021-10-01-preview

        #You can add forceReOnboarding = $true below if you want to force onboarding again
        $Setting = @{
            "azureResourceId" = $vmSS.Id
            "vNextEnabled"    = $true
        }
        
        if($osType -eq "Windows") {
            write-output "Installing MDE.Windows extension"
            $protectedSetting = @{
                "defenderForEndpointOnboardingScript" = ($mdePackage.content | ConvertFrom-Json).value.properties.onboardingPackageWindows
            }
            Add-AzVmssExtension -VirtualMachineScaleSet $vmSS -Name 'MDE.Windows' -Type 'MDE.Windows' -Publisher 'Microsoft.Azure.AzureDefenderForServers' -Setting $Setting -ProtectedSetting $protectedSetting -TypeHandlerVersion '1.0'
        }
        else {
            write-output "Installing MDE.Linux extension"
            $protectedSetting = @{
                "defenderForEndpointOnboardingScript" = ($mdePackage.content | ConvertFrom-Json).value.properties.onboardingPackageLinux
            }
            Add-AzVmssExtension -VirtualMachineScaleSet $vmSS -Name 'MDE.Linux' -Type 'MDE.Linux' -Publisher 'Microsoft.Azure.AzureDefenderForServers' -Setting $Setting -ProtectedSetting $protectedSetting -TypeHandlerVersion '1.0'
        }      
        # Update the VMSS
        Update-AzVmss -ResourceGroupName $vmSS.ResourceGroupName -Name $vmSS.Name -VirtualMachineScaleSet $vmss
    }
    else {
        Write-Output "Not Installing Microsoft Defender for Endpoint. Script Complete"
    }
}

#-------------------------------------------------------------------------------------------------------------
#Start Script
#-------------------------------------------------------------------------------------------------------------

Write-Output "Connecting to Azure"
Connect-AzAccount -Tenant $TenantId

# Read subscriptions from the file
$Subscriptions = Get-Content -Path $SubscriptionFilePath

try {
    if ($null -ne $Subscriptions) {
        foreach ($sub in $Subscriptions) {
            Write-Output "Setting the subscription context to $sub..."
            $subscription = Get-AzSubscription -SubscriptionId $sub
            Set-AzContext -Subscription $subscription
            Write-Output "Subscription $($subscription.Name) is selected"

            Write-Output "Calling EnableDefenderForServers..."
            EnableDefenderForServers -enableDefenderServers $enableDefenderServers

            Write-Output "Calling SetAgentlessScanning..."
            SetAgentlessScanning -disableAgentlessScanning $disableAgentlessScanning

            Write-Output "Calling SetMDEAutoprovisiong..."
            SetMDEAutoprovisiong -disableMDEAutoprovisiong $disableMDEAutoprovisiong

            Write-Output "Calling SetAMAAutoprovisiong..."
            SetAMAAutoprovisiong -disableAMAAutoprovisioning $disableAMAAutoprovisioning
            
            if ($installMonitorAgent -or $installMde)
            {
                Write-Output "Calling InstallExtensions..."
                InstallExtensions -installMonitorAgent $installMonitorAgent -installMde $installMde
            }
        }
    }
}
catch {
    Write-Error "The script encountered an error"
}

Write-Output "Script execution completed"

