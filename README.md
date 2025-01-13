# Powershell scripts for running action queries

## Requirements

[powershell 7.4.0 or greater](https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell)

[dotnet sdk 6.0](https://dotnet.microsoft.com/download/dotnet/6.0)

**Libplanet.Tools 5.1.2** can be installed after installing dotnet sdk 6.0:
```bash
dotnet tool install --global Libplanet.Tools --version 5.1.0
```


## Usage

```powershell
./.scripts/run.ps1 -KeyId <key-id> -Name <query-name> -Url <graphql-url>
```

| The above script must be run in a pwsh environment. If the `ACTION_QUERY_URL` environment variable is set, the -Url parameter can be omitted. 

| ex: `$Env:ACTION_QUERY_URL = <graphql-url>`

If a specific query requires arguments, the script can be executed as shown below.

```powershell
./.scripts/run.ps1 -KeyId <key-id> -Name <query-name> -Arguments @{ arg1 = value1 }
```

To execute the script in a Bash environment, it can be run as shown below.

```bash
pwsh -c './.scripts/run.ps1 -Url <graph-ql> -KeyId <key-id> -Name <query-name> -Arguments @{ "arg1" = "value1" }'
```

## Key ID

The Key ID is a GUID used to sign an unsigned transaction with the Planet tool.

### How to Get a Key ID

The key ID can only be obtained by creating or importing a private key.

```powershell
./key/new.ps1 | Select-Object -ExpandProperty PrivateKey | ./key/import.ps1 
```


Result

```plane

Name                           Value
----                           -----
Address                        0x194bc57685edE1Fcda51D103caC5A8ebfbc1Db59
KeyId                          641f1388-8086-43ad-af47-3d538e03733b

```

### Examples

```powershell
./node/tip.ps1
```

```powershell
./action/stake.ps1 <signer> <amount>
```