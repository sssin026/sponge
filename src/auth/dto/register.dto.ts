import { IsEmail, IsEnum, IsNotEmpty, IsOptional, IsString, MinLength } from 'class-validator';
import { UserType } from 'src/prisma/generated/enums';

export class RegisterDto {
  @IsEmail()
  @IsNotEmpty()
  @MinLength(5)
  email!: string;

  @IsEnum(UserType)
  @IsOptional()
  type?: UserType;

  @IsString()
  @IsNotEmpty()
  @MinLength(8)
  password!: string;

  @IsString()
  @IsNotEmpty()
  @MinLength(2)
  name!: string;
}
