import { Injectable, OnModuleDestroy, OnModuleInit } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { PrismaClient } from './generated/client';
import { PrismaPg } from '@prisma/adapter-pg';
import { Pool } from 'pg';
import * as fs from 'fs';

@Injectable()
export class PrismaService extends PrismaClient implements OnModuleInit, OnModuleDestroy {
  constructor(private readonly configService: ConfigService) {
    super({
      adapter: new PrismaPg(
        new Pool({
          user: configService.getOrThrow<string>('DB_USERNAME'),
          password: configService.getOrThrow<string>('DB_PASSWORD'),
          host: configService.getOrThrow<string>('DB_HOST'),
          port: parseInt(configService.get<string>('DB_PORT') ?? '5432', 10),
          database: configService.getOrThrow<string>('DB_NAME'),
          ...(() => {
            if (
              configService.get<string>('NODE_ENV', 'local') !== 'local' ||
              configService.get<string>('DB_HOST') !== 'localhost'
            ) {
              return {
                ssl: {
                  rejectUnauthorized: true,
                  ca: fs.readFileSync('./prisma/global-bundle.pem').toString(),
                },
              };
            }
          })(),
        }),
      ),
    });
  }

  async onModuleInit() {
    await this.$connect();
  }

  async onModuleDestroy() {
    await this.$disconnect();
  }
}
