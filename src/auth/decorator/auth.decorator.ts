import { createParamDecorator, ExecutionContext } from '@nestjs/common';

export const Auth = createParamDecorator((_data: unknown, ctx: ExecutionContext) => {
  return ctx.switchToHttp().getRequest().user;
});
