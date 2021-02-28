#!/bin/sh

## Get the path to the book
BOOK_PATH=$1

## Get the current path
CURRENT_PATH=$(pwd)

## Get to the right path
cd ${BOOK_PATH}

## Compile the book
R -e 'rmarkdown::render_site(output_format = 'bookdown::pdf_book', encoding = 'UTF-8')'

## Get back to the previous path
cd ${CURRENT_PATH}
