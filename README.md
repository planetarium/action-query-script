# Powershell scripts for running action queries

## Usage

```powershell
./run.ps1 -Url <graphql-url> -KeyId <key-id> -ActionQueryName <query-name>
```

| The above script must be run in a pwsh environment.

If a specific query requires arguments, the script can be executed as shown below.

```powershell
./run.ps1 -Url <graphql-url> -KeyId <key-id> -ActionQueryName <query-name> -Arguments @{ arg1 = value1 }
```

To execute the script in a Bash environment, it can be run as shown below.

```bash
pwsh -c './run.ps1 -Url <graph-ql> -KeyId <key-id> -ActionQueryName <query-name> -ActionQueryArguments @{ "arg1" = "value1" }'
```

## Key ID

The Key ID is a GUID used to sign an unsigned transaction with the Planet tool.

### Installing the Planet

```bash
dotnet tool install --global Libplanet.Tools --version 5.4.0
```

### How to Get a Key ID

The key ID can only be obtained by creating or importing a private key.

```bash
planet key create
```

```bash
planet key import <private-key>
```

Result

```plane
Key ID                               Address                                   
------------------------------------ ------------------------------------------
9a21552d-cbb1-437f-97d0-e20eeb95a974 0x029A2Ec0Ca37884437Af86054BC4E9f2718Df576
```