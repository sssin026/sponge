-- CreateEnum
CREATE TYPE "Discipline" AS ENUM ('SCUBA', 'FREE_DIVING');

-- CreateEnum
CREATE TYPE "CertType" AS ENUM ('OPEN_WATER_DIVER', 'ADVANCED_OPEN_WATER_DIVER', 'RESCUE_DIVER', 'DIVE_MASTER', 'INSTRUCTOR', 'TRAINER', 'SPECIALTY');

-- CreateEnum
CREATE TYPE "ShopType" AS ENUM ('DIVE_SHOP', 'DIVE_CENTER');

-- CreateEnum
CREATE TYPE "UserType" AS ENUM ('NORMAL', 'CERTIFIED', 'INSTRUCTOR');

-- CreateEnum
CREATE TYPE "Gender" AS ENUM ('MALE', 'FEMALE');

-- CreateTable
CREATE TABLE "Organization" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Organization_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Certification" (
    "id" SERIAL NOT NULL,
    "discipline" "Discipline" NOT NULL DEFAULT 'SCUBA',
    "organizationId" INTEGER NOT NULL,
    "type" "CertType" NOT NULL,
    "isProfessional" BOOLEAN NOT NULL DEFAULT false,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Certification_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Club" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "logoImg" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Club_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Shop" (
    "id" SERIAL NOT NULL,
    "type" "ShopType" NOT NULL DEFAULT 'DIVE_SHOP',
    "shopNo" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "address" TEXT,
    "phone" TEXT,
    "website" TEXT,
    "description" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Shop_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "User" (
    "id" SERIAL NOT NULL,
    "type" "UserType" NOT NULL DEFAULT 'NORMAL',
    "email" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "isEmailVerified" BOOLEAN NOT NULL DEFAULT false,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "User_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "UserInfo" (
    "email" TEXT NOT NULL,
    "profileImg" TEXT,
    "phone" TEXT,
    "birth" TIMESTAMP(3),
    "address" TEXT,
    "gender" "Gender",

    CONSTRAINT "UserInfo_pkey" PRIMARY KEY ("email")
);

-- CreateTable
CREATE TABLE "Password" (
    "email" TEXT NOT NULL,
    "hash" TEXT NOT NULL,

    CONSTRAINT "Password_pkey" PRIMARY KEY ("email")
);

-- CreateTable
CREATE TABLE "UserCert" (
    "id" SERIAL NOT NULL,
    "certNo" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "certDate" TIMESTAMP(3) NOT NULL,
    "userId" INTEGER NOT NULL,
    "certId" INTEGER NOT NULL,
    "instructorId" INTEGER,
    "shopId" INTEGER,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "UserCert_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "_ClubToUser" (
    "A" INTEGER NOT NULL,
    "B" INTEGER NOT NULL,

    CONSTRAINT "_ClubToUser_AB_pkey" PRIMARY KEY ("A","B")
);

-- CreateIndex
CREATE UNIQUE INDEX "Shop_shopNo_key" ON "Shop"("shopNo");

-- CreateIndex
CREATE UNIQUE INDEX "User_email_key" ON "User"("email");

-- CreateIndex
CREATE UNIQUE INDEX "UserInfo_email_key" ON "UserInfo"("email");

-- CreateIndex
CREATE UNIQUE INDEX "Password_email_key" ON "Password"("email");

-- CreateIndex
CREATE INDEX "_ClubToUser_B_index" ON "_ClubToUser"("B");

-- AddForeignKey
ALTER TABLE "Certification" ADD CONSTRAINT "Certification_organizationId_fkey" FOREIGN KEY ("organizationId") REFERENCES "Organization"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UserInfo" ADD CONSTRAINT "UserInfo_email_fkey" FOREIGN KEY ("email") REFERENCES "User"("email") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Password" ADD CONSTRAINT "Password_email_fkey" FOREIGN KEY ("email") REFERENCES "User"("email") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UserCert" ADD CONSTRAINT "UserCert_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UserCert" ADD CONSTRAINT "UserCert_certId_fkey" FOREIGN KEY ("certId") REFERENCES "Certification"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UserCert" ADD CONSTRAINT "UserCert_instructorId_fkey" FOREIGN KEY ("instructorId") REFERENCES "User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UserCert" ADD CONSTRAINT "UserCert_shopId_fkey" FOREIGN KEY ("shopId") REFERENCES "Shop"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_ClubToUser" ADD CONSTRAINT "_ClubToUser_A_fkey" FOREIGN KEY ("A") REFERENCES "Club"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_ClubToUser" ADD CONSTRAINT "_ClubToUser_B_fkey" FOREIGN KEY ("B") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;
