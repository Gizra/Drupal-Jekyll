#!/bin/bash

chmod 777 www/sites/default/
bash scripts/build

# Get composer
curl -sS https://getcomposer.org/installer | php
php composer.phar install --working-dir="./dekyll/libraries"

cd www

mkdir sites/default/files
chmod -R 777 sites/default/files

# Install profile, as "Github pages"
drush si -y dekyll --account-pass=admin --db-url=mysql://root:root@localhost/dekyll dekyl_installation_type_form.dekyll_installation_type=github_pages

# Set the SSH key
drush vset dekyll_ssh_key "$(cat ~/.ssh/id_rsa.pub)"

# Set Github Application, the following setting is Using a development app
# that assumes your site is located on http://localhost/dekyll/www
# If you would like to deploy the site on another address, you should create
# a new app in https://github.com/settings/applications, and replace the client
# ID and client secret values.
drush vset github_connect_client_id "6b8801a904e18533efaa"
drush vset github_connect_client_secret "e667b19b21e4e6a60a8d1f656d41a5b81da5d4de"


# Execute Dekyll queue workers.
. ../dekyll.sh