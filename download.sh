#!/bin/bash
urlPrefix="https://www.rccc.org/readbible/Book/"

# chapterurl="https://www.rccc.org/readbible/Book/01/Chapter.htm"
# verseurl="https://www.rccc.org/readbible/Book/01/001.htm"

# convert big5 to utf-8
# iconv -f BIG-5 -t UTF-8//TRANSLIT BookTitle.htm -o new.htm

function getVerse() {
   bookNo=$1
   verseNo=$(printf "%03d" $2)
   wget -q "${urlPrefix}${bookNo}/${verseNo}.htm" -O "Book/${bookNo}/${verseNo}.htm"
   # iconv -f BIG-5 -t UTF-8//TRANSLIT "${bookNo}/${verseNo}.htm.ori" -o "${bookNo}/${verseNo}.htm" 
}

function getBook() {
   bookNo=$(printf "%02d" $1)
   mkdir -p "Book/${bookNo}"
   thePath="${urlPrefix}${bookNo}/Chapter.htm"
   echo "The path ${thePath}"
   wget -q "${thePath}" -O "Book/${bookNo}/Chapter.htm"
   # now try to get how many chapters there are in a book
   chapters=$(cat "Book/${bookNo}/Chapter.htm" | grep "target=Verse" | tail -1 | cut -d '>' -f 2 | cut -d '<' -f 1)
   echo "There are ${chapters} in the book"
   theRange=$((chapters))
   for (( j=1; j<=$theRange; j++ ))
   do
      getVerse $bookNo $j
   done
}

for i in {4..66}
do
  getBook "${i}"
done