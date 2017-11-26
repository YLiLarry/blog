source ./variables.bash

mkdir -p build/tmp
cp -r articles build/

function replaceTemplate() {
  target="$(<$1)"
  replacement="$(cat)"
  echo "${target/__content__/$replacement}"
}

# create articles.md
rm -f build/tmp/articles.md
touch build/tmp/articles.md

for file in `ls build/articles/*/*.md`; do
  dir=`dirname $file`
  articleHTML=$(pandoc "$file")
  replaceTemplate 'templates/article.html' <<< ${articleHTML} \
    | replaceTemplate 'templates/global.html' > "${dir}/index.html" 
  # take the first line of every .md as the artile title
  title=$(head -n 1 "$file")
  title=${title#\#}
  echo "* <a href='${host}${dir#build}/index.html'>${title}</a>" >> build/tmp/articles.md
done

# compile articles.md
articlesHTML="$(pandoc build/tmp/articles.md)"
replaceTemplate 'templates/articles.html'  <<< "${articlesHTML}" \
  | replaceTemplate 'templates/global.html' > "build/articles/index.html" 
