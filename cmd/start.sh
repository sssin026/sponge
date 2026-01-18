set -e

cp ./env/.$1.env ./.env
source ./.env

nest start --watch