import { IsString, IsEmail, IsOptional, IsEnum, IsDateString, IsBoolean, IsNotEmpty } from 'class-validator';

export enum UserType {
  NORMAL = 'NORMAL', // 일반 회원
  CERTIFIED = 'CERTIFIED', // 자격증 보유자
  INSTRUCTOR = 'INSTRUCTOR', // 강사
}

export enum Gender {
  MALE = 'MALE', // 남성
  FEMALE = 'FEMALE', // 여성
}

export class CreateUserDto {
  @IsOptional()
  @IsEnum(UserType)
  type?: UserType; // 사용자 종류 (기본값: NORMAL)

  @IsNotEmpty()
  @IsEmail()
  email!: string; // 이메일 (로그인 ID)

  @IsNotEmpty()
  @IsString()
  password!: string; // 비밀번호

  @IsNotEmpty()
  @IsString()
  name!: string; // 한글 이름

  @IsOptional()
  @IsString()
  profileImg?: string; // 프로필 이미지

  @IsOptional()
  @IsString()
  phone?: string; // 전화번호

  @IsOptional()
  @IsDateString()
  birth?: string; // 생년월일

  @IsOptional()
  @IsString()
  address?: string; // 주소

  @IsOptional()
  @IsEnum(Gender)
  gender?: Gender; // 성별

  @IsOptional()
  @IsBoolean()
  isActive?: boolean; // 활성 사용자 여부 (기본값: true)
}
