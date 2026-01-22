import { UserType } from 'src/prisma/generated/enums';

export class AuthEntity {
  id!: number;
  email!: string;
  type!: UserType;
  name!: string;
  iat?: number;
  exp?: number;
}
