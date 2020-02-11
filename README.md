# Secrets Management LastPass Extension

This is an attempt at a LastPass Secrets Management extension, inspired by @JustinWGrote's SecretsManagement.KeePass.

The inner module (ImplementingModule) may need to be renamed to SecretsManagementExtension in the future
It is currently based on the [blog post here](https://devblogs.microsoft.com/powershell/secrets-management-module-vault-extensions/) which references [this example module](https://github.com/PowerShell/Modules/tree/master/Samples/VaultExtension/Modules/ScriptLocalVault).

# Using the Module

```PowerShell
# Register LastPass by running the SecretsManagement registration command
Register-SecretsVault -Name LastPass -ModuleName SecretsManagement.LastPass
```

## Requirements
| Module                                 | Version |
| -------------------------------------- | ------- |
| Microsoft.PowerShell.SecretsManagement |     1.0 |

## Building the Module

## Testing the Module