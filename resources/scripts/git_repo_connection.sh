#!/bin/bash -e

CONF_FILE=/resources/configuration/sites-enabled/tools-context.conf
PLUGINS_FILE=/resources/release_note/plugins.json

if [ $GIT_REPO == "gitlab" ]; then
  export GIT_URL="gitlab/gitlab"
  GIT_CONF="proxy_pass http:\/\/gitlab\/gitlab; \
\\n\\tproxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for; \
\\n\\tproxy_set_header Client-IP \$remote_addr;"
  sed -i "s/###GIT_REPO###/$GIT_REPO/g" $CONF_FILE
  sed -i "s/###GIT_CONF###/$GIT_CONF/g" $CONF_FILE
  jq ".core[].components[1] |= .+ {id: \"gitlab\", title: \"gitlab\", img: \"img\/gitlab.svg\", link: \"/gitlab\"}" $PLUGINS_FILE > tmp.json
   mv tmp.json $PLUGINS_FILE

elif [ $GIT_REPO == "gerrit" ]; then
  export GIT_URL="gerrit:8080/gerrit"
  GIT_CONF="client_max_body_size 512m; \
\\n\\tproxy_pass http:\/\/gerrit:8080;"
  sed -i "s/###GIT_REPO###/$GIT_REPO/g" $CONF_FILE
  sed -i "s/###GIT_CONF###/$GIT_CONF/g" $CONF_FILE
  jq ".core[].components[1] |= .+ {id: \"gerrit\", title: \"gerrit\", img: \"img\/gerrit.jpg\", link: \"/gerrit/\"}" $PLUGINS_FILE > tmp.json
  mv tmp.json $PLUGINS_FILE
fi
