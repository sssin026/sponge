set -e

cp ./env/.$1.env ./.env
source ./.env

# 기존 컨테이너 중지 및 제거
docker compose down

if [ "$2" == "prune" ]; then
  # Docker 정리 (디스크 공간 확보)
  echo "Docker 정리 중..."
  docker system prune -f --volumes || true
  docker builder prune -af || true
fi

# 컨테이너 빌드 및 실행
docker compose up -d --build

# 컨테이너 상태 확인
docker compose ps

# 로그 확인
# docker compose logs -f app