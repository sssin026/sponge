set -e

cp ./env/.$1.env ./.env
source ./.env

if [ "$2" = "reset" ] && [ "$1" != "production" ]; then
  echo "Resetting database for local environment..."
  yarn prisma migrate reset
fi

if [ "$1" = "local" ]; then
  echo "Running prisma migrate dev (local environment)..."
  yarn prisma migrate dev
else
  echo "Running prisma migrate deploy ($1 environment)..."
  yarn prisma migrate deploy
fi

yarn prisma generate