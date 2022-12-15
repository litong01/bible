#!/bin/bash
urlPrefix="https://www.rccc.org/readbible/Book/"

# chapterurl="https://www.rccc.org/readbible/Book/01/Chapter.htm"
# verseurl="https://www.rccc.org/readbible/Book/01/001.htm"

# convert big5 to utf-8
# iconv -f BIG-5 -t UTF-8//TRANSLIT BookTitle.htm -o new.htm

SKIP=true
if [[ $1 == 'false' ]]; then
   SKIP=false
fi

function getVerse() {
   bookNo=$1
   verseNo=$(printf "%03d" $2)
   echo "Processing book ${bookNo} chapter ${verseNo}..."
   if [[ "${SKIP}" == "false" ]]; then
     wget -q "${urlPrefix}${bookNo}/${verseNo}.htm" -O "BookOri/${bookNo}/${verseNo}.htm"
   fi
   iconv -f BIG-5 -t UTF-8//TRANSLIT "BookOri/${bookNo}/${verseNo}.htm" -o "Book/${bookNo}/${verseNo}.htm" 
}

function getBook() {
   bookNo=$(printf "%02d" $1)
   if [[ "${SKIP}" == "false" ]]; then
     mkdir -p "Book/${bookNo}"
     mkdir -p "BookOri/${bookNo}"
     thePath="${urlPrefix}${bookNo}/Chapter.htm"
     echo "The path ${thePath}"
     wget -q "${thePath}" -O "BookOri/${bookNo}/Chapter.htm"
   fi
   # Convert the chapter doc to utf-8
   iconv -f BIG-5 -t UTF-8//TRANSLIT "BookOri/${bookNo}/Chapter.htm" -o "Book/${bookNo}/Chapter.htm"
   # now try to get how many chapters there are in a book
   chapters=$(cat "BookOri/${bookNo}/Chapter.htm" | grep "target=Verse" | tail -1 | cut -d '>' -f 2 | cut -d '<' -f 1)
   echo "There are ${chapters} in the book"
   theRange=$((chapters))
   for (( j=1; j<=$theRange; j++ ))
   do
      getVerse $bookNo $j
   done
}

if [[ "${SKIP}" == "false" ]]; then
   mkdir -p "BookOri"
   wget -q "${urlPrefix}BookTitle.htm" -O "BookOri/BookTitle.htm"
fi
# Convert BookTitle to utf8
iconv -f BIG-5 -t UTF-8//TRANSLIT "BookOri/BookTitle.htm" -o "Book/BookTitle.htm"

for i in {1..66}
do
  getBook "${i}"
done