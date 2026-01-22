import { NestFactory } from '@nestjs/core';
import { FastifyAdapter, NestFastifyApplication } from '@nestjs/platform-fastify';
import { AppModule } from './app.module';
import dayjs from 'dayjs';
import utc from 'dayjs/plugin/utc';
import ParseFormat from 'dayjs/plugin/customParseFormat';
import timezone from 'dayjs/plugin/timezone';
import isBetween from 'dayjs/plugin/isBetween';
import 'dayjs/locale/ko';
import { Logger, ValidationPipe } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';

dayjs.locale('ko');
dayjs.extend(ParseFormat);
dayjs.extend(utc);
dayjs.extend(timezone);
dayjs.extend(isBetween);

async function bootstrap() {
  const app = await NestFactory.create<NestFastifyApplication>(AppModule, new FastifyAdapter());
  const configService = app.get<ConfigService<unknown, false>>(ConfigService);
  app.useGlobalPipes(
    new ValidationPipe({
      whitelist: true,
      forbidNonWhitelisted: true,
      transform: true,
    }),
  );

  await app.listen(process.env.PORT ?? 3000, '0.0.0.0');

  Logger.log('========================================================');
  Logger.log('✅ NestJS Server Start');
  Logger.log(`NODE_ENV: ${configService.get<string>('NODE_ENV')}`);
  Logger.log(`PORT: ${configService.get<number>('PORT')}`);
  Logger.log('========================================================');
}
void bootstrap();
