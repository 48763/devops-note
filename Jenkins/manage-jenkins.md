# Manage Jenkins

## Credentials

```
withCredentials([file(credentialsId: '<credentials>', variable: 'GCP_KEY')]) {
    // Execute
    sh '''
        gcloud auth activate-service-account --key-file=${GCP_KEY}
        ./main.sh
        gcloud auth revoke
    '''
}
```

[credentials-binding](https://www.jenkins.io/doc/pipeline/steps/credentials-binding/)