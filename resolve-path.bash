source ./variables.bash

for file in `find build -name *.html`; do
  echo $file
  content="$(cat ${file})"
  dir="$(basename ${file})"
  content="${content//__fpath__/${host}${dir}}"
  echo "${content//__host__/${host}}" > "${file}"
done

