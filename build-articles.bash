source ./variables.bash

mkdir -p build/tmp
cp -r articles build/

function replaceContent() {
  target="$(<$1)"
  replacement="$(cat)"
  echo "${target/__content__/$replacement}"
}

function readTimeEst() {
  nwords=$(wc -w < "$1")
  echo "${nwords} words / $((${nwords}/200)) minutes read"
}

function readTitle() {
  title=$(head -n 1 "$1")
  echo "${title#\#}"
}

# create articles.md
rm -f build/tmp/articles.md
touch build/tmp/articles.md

for file in `ls build/articles/*/*.md`; do
  dir=`dirname $file`
  est=`readTimeEst $file`
  content="<div class='read-est'>${est}</div><h1>$(readTitle "${file}")</h1>$(tail -n +2 "$file")"
  articleHTML=$(pandoc -s --highlight-style=zenburn <<< "${content}")
  replaceContent 'templates/article.html' <<< "${articleHTML}" \
    | replaceContent 'templates/global.html' > "${dir}/index.html" 
  # take the first line of every .md as the artile title
  echo "* <a href='${host}${dir#build}/index.html'> \
          `readTitle "${file}"`<span class='read-est'>(${est})<span> \
        </a>" \
    >> build/tmp/articles.md
done

# compile articles.md
articlesHTML="$(pandoc build/tmp/articles.md)"
replaceContent 'templates/articles.html'  <<< "${articlesHTML}" \
  | replaceContent 'templates/global.html' > "build/articles/index.html" 
