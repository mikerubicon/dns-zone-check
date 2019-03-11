#!/usr/bin/env bash

## Pobiera i zapisuje wszystkie rekordy strefy DNS dla podanej listy domen

DATE=`date +"%Y-%m-%d"`
DOMAIN_LIST_FILE="configuration-domains-2018-10-17_08_52_47.csv"
DATA_DIR="data/${DATE}"
SLEEP_TIME=1
#IFS=

create_current_dir() {
if [ ! -d "${DATA_DIR}" ];
        then
                echo -ne "[! | Tworzę katalog docelowy: ${DATA_DIR}]\n";
                mkdir ${DATA_DIR};
        else
                echo -ne "[ Katalog docelowy: ${DATA_DIR} -- OK -- ]\n";
fi
}

get_domain_zone() {
if [ -z "$1" ];
        then
                echo -ne "[! | Brak nazwy domeny! ]\n";
                exit 1;
fi

DOMAIN_NAME="$1"
DOMAIN_ZONE=`dig ${DOMAIN_NAME} any`

        echo "${DOMAIN_ZONE}"
}

## Prepare directories
create_current_dir

## Get domain data and save to file
for domain in `awk -F';' '{ if (NR!=1) print $1}' ${DOMAIN_LIST_FILE}`;
        do
                FILE_NAME="${domain}_${DATE}.txt"
                FILE="${DATA_DIR}/${FILE_NAME}"

                echo -ne "-- Sprawdzam domenę: ${domain}\n";
                echo -ne "Zapisuję do: ${FILE}\n";

                get_domain_zone "${domain}" >${FILE}
                sleep ${SLEEP_TIME};
done

echo -ne "[ -- KONIEC -- ]\n"
