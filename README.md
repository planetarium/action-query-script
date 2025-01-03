# Powershell scripts for running action queries (POC)

Provides a PowerShell environment for executing action queries and checking the state.

## Requirements

[docker](https://www.docker.com/)

## Usage in docker

Build the image by running the following command.

```
docker build -t action-query .
```

Run the following command to start the container and output the `container-id`.

```
docker run -d action-query:latest
```

Use the `container-id` to run pwsh.

```
docker exec -it <container-id> /usr/bin/pwsh
```

## Key Registration

Register the `private-key` for running action queries using the `./key/import.ps1` script.
A password is required when registering the `private-key`.
The password will be used when running `action-query`.

```
./key/import.ps1 -SetAsSigner
```

If the registration is successful, you can verify it with the following command.

```
./key/list.ps1
```

If you do not have a `private-key`, you can generate a new one with the following command.

```
./key/new.ps1
```

### Setting Signer and Url

To use the registered `private-key` as the default, run the following command to set it as
the `signer`.

```
./signer.ps1 <address>
```

Then, set the target `graph-ql-url` for running action-query.

```
./url.ps1 <graph-ql-url>
```

### Display available scripts

To see the help and available scripts, run the following command.

```
./help.ps1
```

### Examples

Retrieves the tip of the node.

```
./node/tip.ps1
```

Checks the balance of `ncg` and `mead`.

```
./state/ncg.ps1
./state/mead.ps1
```

Creates an avatar.

```
./action/avatar-create.ps1 <avatar-name>
```

| Scripts in the `action` path require the `signer` to be set using `./signer.ps1`.
