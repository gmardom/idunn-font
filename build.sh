#!/bin/bash -e

declare -r  idunn_name="Idunn"
declare -ar idunn_vars=("Mono" "Sans" "Serif")
declare -r  idunn_dir="idunn"

declare -r  iosevka_sha="f2cab61c0de33c8c7158ede37c6241e04b5cc22b"
declare -r  iosevka_url="https://github.com/be5invis/Iosevka/archive/${iosevka_sha}.zip"
declare -r  iosevka_dir="iosevka"
declare -r  iosevka_pbp="${iosevka_dir}/private-build-plans.toml"


# Prepare necessary files

if [[ ! -e "${iosevka_dir}.zip" ]]
then
    curl -L "${iosevka_url}" -o "${iosevka_dir}.zip"
    [[ -e "${iosevka_dir}.zip" ]] || exit 1
fi

if [[ ! -d "${iosevka_dir}" ]]
then
    temp="$(mktemp -d)"

    unzip "${iosevka_dir}.zip" -d "${temp}"
    mv "${temp}/Iosevka-${iosevka_sha}" "${iosevka_dir}"
    rm -rf "${temp}"

    pushd "${iosevka_dir}"; npm install; popd
fi


# Build the fonts

if [[ -d "${idunn_dir}" ]]
then
    rm -rf "${idunn_dir}"
    mkdir -p "${idunn_dir}"
fi

for var in "${idunn_vars[@]}"; do
    cat "${idunn_name}${var}.toml" > "${iosevka_pbp}"
    pushd "${iosevka_dir}"
        npm run build -- "contents::${idunn_name}${var}"
    popd
done

mv -f "${iosevka_dir}/dist"/* "${idunn_dir}/"
