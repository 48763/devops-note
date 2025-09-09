az() {
    docker run --rm -v ${HOME}/.azure:/root/.azure mcr.microsoft.com/azure-cli az $@
}

get_repo_tag() {
    az acr repository show-tags --name ${1} --orderby time_desc --repository ${2} | jq -r ".[]"
}

delte_repo_tag() {
    echo "az acr repository delete --name ${1} --yes -t ${2}:${3}"
}

if [ ${#} -ne 1 ]; then
    echo Need registry name.
    exit 1
fi

registry="${1}"

:> output

result=$(az acr repository list --name ${registry} 2>/dev/null)
if [ ${?} -ne 0 ]; then
    echo Registry name error.
    exit 1
fi

repo_list=$(echo ${result} | jq -r ".[]" )

for repo in ${repo_list}
do 
    repo_tags=$(get_repo_tag ${registry} ${repo} | tail -n +101)

    if [ "${repo_tags}" = "" ]; then 
        continue
    fi

    echo "${repo_tags}" | tail -n 1 | grep 20250811 > /dev/null
    if [ ${?} -eq 0 ]; then
        continue
    fi

    for tag in ${repo_tags}
    do
        delte_repo_tag ${registry} ${repo} ${tag} >> output
    done

done
