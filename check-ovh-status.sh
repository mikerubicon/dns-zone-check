#!/bin/bash

##
# Sprawdza czy dana domena z listy posiada serwer DNS w strefie OVH

# Ustawienia
DEBUG=1
DOMAIN_LIST_FILE=domain-list.txt
DOMAIN_STATUS_LIST_FILE="domain-status-list.csv"

# Funkcje
print() {
        ## Wypisuje komunikaty gdy skrytp w trybie DEBUG=1
        if [ "$DEBUG" = "1" ];
                then
                        echo -ne "$1";
        fi
}

check_ovh_dns() {
        ## Sprawdza czy podana domena posiada strefę w OVH
        if [ $1 = "" ];
                then
                        print "[!| Brak nazwy domeny do sprawdzenia!]\n";
                        exit 500;
        fi
        DOMAIN=$1

        # Status
        DOMAIN_NS_STRING=$(dig ${DOMAIN} ns |grep 'NS' |tail -1);
        DOMAIN_STATUS=0;

        if [[ "${DOMAIN_NS_STRING}" =~ "ovh" ]];
                then
                        DOMAIN_STATUS=1;
        fi

        ## wypisanie rezultatu
        echo -ne "${DOMAIN_STATUS}";
}

# Akcja
print "[ -START- ]\n";

if [ ! -f $DOMAIN_LIST_FILE ];
        then
                print "[!| Plik z listą domen nie istnieje! ${DOMAIN_LIST_FILE} ]\n";
                exit 500;
fi

## Czyszczenie zawartosci listy
echo "">${DOMAIN_STATUS_LIST_FILE};

# Petla
for i in `cat ${DOMAIN_LIST_FILE}`;
        do
                print "[Sprawdzam domenę: $i ]\n";
                STATUS=$(check_ovh_dns ${i});
                print "[ ${STATUS} ]\n";
                ## dopisanie statusu
                echo "${i};${STATUS}" >>${DOMAIN_STATUS_LIST_FILE};
                sleep 0;
done

# Koniec
print "[ -STOP- ]\n";
