FROM node:24-alpine AS builder

WORKDIR /app

# Install dependencies
COPY package.json yarn.lock ./
COPY prisma ./prisma

RUN yarn cache clean
RUN yarn install --frozen-lockfile

# Generate Prisma Client
RUN npx prisma generate

# Copy source code
COPY . .

# Build the application
RUN yarn build

# Runner Stage
FROM node:24-alpine AS runner

WORKDIR /app

ENV NODE_ENV ${NODE_ENV}

COPY package.json yarn.lock ./

# Install production dependencies
RUN yarn install --production --frozen-lockfile

# Copy built application and generated files
COPY --from=builder /app/dist ./dist
# Copy custom prisma output
# COPY --from=builder /app/src/prisma/generated ./src/prisma/generated

CMD ["node", "dist/main"]
