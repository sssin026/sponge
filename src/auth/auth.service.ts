import { HttpException, Injectable } from '@nestjs/common';
import { PrismaService } from 'src/prisma/prisma.service';
import * as bcrypt from 'bcrypt';
import { JwtService } from '@nestjs/jwt';
import { RegisterDto } from './dto/register.dto';
import { AuthEntity } from './entities/auth.entity';

@Injectable()
export class AuthService {
  constructor(
    private readonly prismaService: PrismaService,
    private readonly jwtService: JwtService,
  ) {}

  async isEmailTaken(email: string) {
    // 블룸필터 추가
    const user = await this.prismaService.user.findUnique({
      where: { email },
      select: { email: true },
    });
    return !!user;
  }

  async register(registerDto: RegisterDto) {
    const { email, password, name } = registerDto;
    if (await this.isEmailTaken(email)) throw new HttpException('이미 존재하는 이메일입니다.', 400);

    return this.prismaService.user.create({
      data: {
        email,
        name,
        password: {
          create: {
            hash: await bcrypt.hash(password, 12),
          },
        },
      },
      select: {
        id: true,
        email: true,
        name: true,
        isEmailVerified: true,
      },
    });
  }

  async validateUser(email: string, password: string) {
    const authPassword = await this.prismaService.password.findUnique({
      where: {
        email,
      },
      select: {
        hash: true,
      },
    });

    if (!authPassword || !(await bcrypt.compare(password, authPassword.hash)))
      throw new HttpException('존재하지 않는 이메일이거나 비밀번호가 일치하지 않습니다.', 400);

    return await this.prismaService.user.findUnique({
      where: {
        email,
      },
      select: {
        id: true,
        email: true,
        type: true,
        name: true,
      },
    });
  }

  login(payload: AuthEntity) {
    return { accessToken: this.jwtService.sign(payload) };
  }
}
