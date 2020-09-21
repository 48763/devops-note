

```bash
$ gcloud config configurations create odin
```

```bash
$ gcloud auth activate-service-account --key-file=./odin.json
```

```bash
$ gcloud config set project odin
```

```bash
$ gcloud config configurations list
NAME                IS_ACTIVE  ACCOUNT                                                 PROJECT              COMPUTE_DEFAULT_ZONE  COMPUTE_DEFAULT_REGION
odin                True       monitor@odin.iam.gserviceaccount.com                    odin
thor                False      monitor@thor.iam.gserviceaccount.com                    thor
```

```bash
$ gcloud config configurations activate thor
```