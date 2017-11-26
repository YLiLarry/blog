source ./variables.bash

nav=$(cat templates/nav.html)

for file in `find build -name *.html`; do
  content="$(cat ${file})"
  echo "${nav}" "${content}" > "${file}"
done
