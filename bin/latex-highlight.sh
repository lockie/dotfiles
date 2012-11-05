#!/usr/bin/env sh

SH="source-highlight --out-format=latexcolor --line-number -t 4"
DIR=latex-colorized

if [ ! -z "$1" ]; then
	cd $1
fi

if [ ! -d "$DIR" ]; then
    mkdir $DIR &> /dev/null
fi

for SOURCEFILE in *; do
    EXTENSION=`echo $SOURCEFILE | sed -r 's/.+\.(.*)/\1/g'`
    case $EXTENSION in
        "c")
        echo "$SOURCEFILE : C source file"
        $SH --src-lang=c --input=$SOURCEFILE --output=$DIR/$SOURCEFILE.tex
        ;;

        "h")
        echo "$SOURCEFILE : C++ header file"
        $SH --src-lang=cc --input=$SOURCEFILE --output=$DIR/$SOURCEFILE.tex
		;;

         "cpp")
        echo "$SOURCEFILE : C++ source file"
        $SH --src-lang=cc --input=$SOURCEFILE --output=$DIR/$SOURCEFILE.tex
        ;;

        "hpp")
        echo "$SOURCEFILE : C++ header file"
        $SH --src-lang=cc --input=$SOURCEFILE --output=$DIR/$SOURCEFILE.tex
        ;;

         "cxx")
        echo "$SOURCEFILE : C++ source file"
        $SH --src-lang=cc --input=$SOURCEFILE --output=$DIR/$SOURCEFILE.tex
        ;;

         "hxx")
        echo "$SOURCEFILE : C++ header file"
        $SH --src-lang=cc --input=$SOURCEFILE --output=$DIR/$SOURCEFILE.tex
        ;;

		"py")
        echo "$SOURCEFILE : Python script"
        $SH --src-lang=py --input=$SOURCEFILE --output=$DIR/$SOURCEFILE.tex
        ;;

		"sh")
        echo "$SOURCEFILE : Bash script file"
        $SH --src-lang=bash --input=$SOURCEFILE --output=$DIR/$SOURCEFILE.tex 
        ;;
    esac
done

echo
echo "=============================================================="
echo
echo "Insert this commands to your LaTeX document:"
echo
cd $DIR
for FILE in *; do
    echo '% Listing for '"`echo $FILE | sed -r 's/(.*)\.tex/\1/g'`"
    echo '\begin{tabular}{p{130mm}}'
    echo '\rowcolor[gray]{0.7} \textbf{Листинг:} '"`echo $FILE | sed -r 's/(.*)\.tex/\1/g'`"' \'
    echo '\end{tabular}'
    echo '\input{'`pwd`'/'$FILE'}'
    echo
done

echo
echo "=============================================================="
echo
echo "insert this string to LaTeX preamble:"
echo '\usepackage[usenames,dvipsnames]{color}'
echo '\usepackage{colortbl}'
echo

