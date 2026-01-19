# Sponge

**Sponge**는 [NestJS](https://nestjs.com/) 프레임워크를 기반으로 구축된 백엔드 애플리케이션 보일러플레이트입니다.
Fastify 어댑터를 사용하여 성능을 최적화했으며, Prisma ORM과 PostgreSQL을 사용하여 데이터베이스를 관리합니다.
또한, 환경별 설정 관리와 Docker 기반의 배포 스크립트를 포함하고 있어 개발부터 배포까지의 과정을 효율적으로 지원합니다.

## 🛠 Tech Stack

- **Framework**: [NestJS](https://nestjs.com/) (Fastify Adapter)
- **Database**: [PostgreSQL](https://www.postgresql.org/)
- **ORM**: [Prisma](https://www.prisma.io/)
- **Language**: TypeScript
- **Package Manager**: Yarn
- **Containerization**: Docker & Docker Compose

## 🚀 Getting Started

### Prerequisites

이 프로젝트를 실행하기 위해 다음 도구들이 설치되어 있어야 합니다.

- Node.js (v20 이상 권장)
- Yarn
- Docker & Docker Compose (로컬 DB 및 배포 실행 시)

### Installation

패키지 의존성을 설치합니다.

```bash
$ yarn install
```

## ⚙️ Environment Configuration

환경 변수 파일은 `env/` 디렉토리에서 관리됩니다. 각 환경에 맞는 설정 파일이 존재합니다.

- `.local.env`: 로컬 개발용
- `.dev.env`: 개발 서버용
- `.stage.env`: 스테이징 서버용
- `.prod.env`: 프로덕션 서버용

각 스크립트 실행 시 환경 이름(예: `local`, `dev`, `prod`)을 인자로 전달하여 해당 환경 설정을 로드합니다.

## 🏃 Running the App

애플리케이션을 개발 모드(Watch 모드)로 실행합니다. `[env]` 부분에 원하는 환경을 입력하세요.

```bash
# 사용법: yarn start -- [env]
$ yarn start -- local
```

이 명령어는 `cmd/start.sh` 스크립트를 실행하며, 지정된 환경 파일을 `.env`로 복사한 후 `nest start --watch`를 실행합니다.

## 🗄 Database Migration

Prisma를 사용한 데이터베이스 마이그레이션을 수행합니다.

```bash
# 마이그레이션 실행 (로컬에서는 dev, 그 외에는 deploy 모드 실행)
# 사용법: yarn migrate -- [env]
$ yarn migrate -- local

# 데이터베이스 리셋 (로컬 환경에서만 가능)
# 사용법: yarn migrate -- [env] reset
$ yarn migrate -- local reset
```

## 🚢 Deployment

Docker Compose를 사용하여 애플리케이션을 배포합니다.

```bash
# 애플리케이션 배포
# 사용법: yarn deploy -- [env]
$ yarn deploy -- prod

# 배포 시 Docker 시스템 정리 (Unused images/volumes 제거)
# 사용법: yarn deploy -- [env] prune
$ yarn deploy -- prod prune
```

## 📂 Project Structure

```
sponge/
├── cmd/              # 실행, 배포, 마이그레이션 등을 위한 쉘 스크립트 모음
│   ├── deploy.sh
│   ├── migrate.sh
│   └── start.sh
├── env/              # 환경별 환경 변수 파일 (.local.env, .dev.env 등)
├── prisma/           # Prisma 스키마 및 마이그레이션 파일
├── src/              # 소스 코드
│   ├── app.module.ts
│   └── ...
├── docker-compose.yml # Docker Compose 설정 파일
├── package.json
└── ...
```

## 📝 License

This project is [UNLICENSED](LICENSE).
