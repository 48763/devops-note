#!/bin/bash
DOCPATH=""
DOCFILE=""

doc_set() {
    DOCPATH=$1
    DOCFILE=$2
    printf "" > $DOCPATH/$DOCFILE
}

doc_printf() {
    printf -- "$1" >> $DOCPATH/$DOCFILE
}