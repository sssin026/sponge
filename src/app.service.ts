import { Injectable } from '@nestjs/common';
import dayjs from 'dayjs';

@Injectable()
export class AppService {
  getHealthCheck() {
    return {
      message: 'API가 정상적으로 작동합니다!',
      timestamp: dayjs().toISOString(),
      status: 'success',
    };
  }
}
