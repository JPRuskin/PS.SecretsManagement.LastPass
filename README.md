# Secrets Management LastPass Extension

This is an attempt at a LastPass Secrets Management extension, inspired by @JustinWGrote's SecretsManagement.KeePass.

It's entirely possible that, due to the bizarre way SecretsManagement currently handles script modules, you will be prompted to login _every time_ you access a vault. This is due to SecretsManagement creating a new PS session every time _anything_ is done with a script module, which is clearly an interesting design decision from a script-based perspective.

# Using the Module

```PowerShell
# Register LastPass by running the SecretsManagement registration command
Register-SecretsVault -Name LastPass -ModuleName SecretsManagement.LastPass

# Get a list of available secrets, showing only names and (roughly) type of content
Get-SecretInfo

# Get a list of available secrets like Azure*
# Get-SecretInfo -Filter "Azure*"
```

## Requirements
| Module                                 | Version |
| -------------------------------------- | ------- |
| Microsoft.PowerShell.SecretsManagement |     1.0 |

## Building the Module

## Testing the Module

# Thanks / Acknowledgements

Though I started trying to play with this on my own, it turns out (as ever) that someone (in this case @ScottEvtuch) had done everything I was trying to already in [PSLastPass](https://github.com/ScottEvtuch/PSLastPass/). Consequently, there are currently several bits that have been wholeheartedly borrowed.