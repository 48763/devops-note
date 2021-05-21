# Registry

## Image named 

### Artifact registry

```
<LOCATION>-docker.pkg.dev/<PROJECT-ID>/<REPOSITORY>/<IMAGE>
```

### Container registry

```
<LOCATION>-gcr.io/<PROJECT-ID>/<IMAGE>
```

## Login 

```
cat service_account.json |\
    docker login -u _json_key -p password-stdin asia-east1-docker.pkg.dev/PROJECT-ID
```

- LOCATION
- PROJECT
- REPOSITORY
- IMAGE

```
asia-east1-docker.pkg.dev/my-project-id/repo/image:latest
```

<!--

[]: ""

-->

