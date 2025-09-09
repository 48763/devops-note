az() {
    docker run --rm -v ${HOME}/.azure:/root/.azure mcr.microsoft.com/azure-cli az $@
}

