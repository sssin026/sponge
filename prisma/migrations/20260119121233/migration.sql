/*
  Warnings:

  - The values [SCUBA_DIVER,SCUBA_INSTRUCTOR,FREE_DIVER,FREE_INSTRUCTOR,DIVE_RESORT] on the enum `UserType` will be removed. If these variants are still used in the database, this will fail.
  - You are about to drop the column `userId` on the `Password` table. All the data in the column will be lost.
  - You are about to drop the `License` table. If the table is not empty, all the data it contains will be lost.
  - A unique constraint covering the columns `[email]` on the table `Password` will be added. If there are existing duplicate values, this will fail.
  - Added the required column `email` to the `Password` table without a default value. This is not possible if the table is not empty.

*/
-- CreateEnum
CREATE TYPE "Discipline" AS ENUM ('SCUBA', 'FREE_DIVING');

-- CreateEnum
CREATE TYPE "CetificationType" AS ENUM ('OPEN_WATER_DIVER', 'ADVANCED_OPEN_WATER_DIVER', 'RESCUE_DIVER', 'DIVE_MASTER', 'INSTRUCTOR', 'TRAINER', 'SPECIALTY');

-- CreateEnum
CREATE TYPE "ShopType" AS ENUM ('DIVE_SHOP', 'DIVE_CENTER');

-- CreateEnum
CREATE TYPE "Gender" AS ENUM ('MALE', 'FEMALE');

-- AlterEnum
BEGIN;
CREATE TYPE "UserType_new" AS ENUM ('NORMAL', 'CERTIFIED', 'INSTRUCTOR');
ALTER TABLE "User" ALTER COLUMN "type" TYPE "UserType_new" USING ("type"::text::"UserType_new");
ALTER TYPE "UserType" RENAME TO "UserType_old";
ALTER TYPE "UserType_new" RENAME TO "UserType";
DROP TYPE "public"."UserType_old";
COMMIT;

-- DropForeignKey
ALTER TABLE "License" DROP CONSTRAINT "License_userId_fkey";

-- DropForeignKey
ALTER TABLE "Password" DROP CONSTRAINT "Password_userId_fkey";

-- DropIndex
DROP INDEX "Password_userId_key";

-- AlterTable
ALTER TABLE "Password" DROP COLUMN "userId",
ADD COLUMN     "email" TEXT NOT NULL;

-- AlterTable
ALTER TABLE "User" ADD COLUMN     "address" TEXT,
ADD COLUMN     "birth" TIMESTAMP(3),
ADD COLUMN     "gender" "Gender",
ADD COLUMN     "phone" TEXT,
ALTER COLUMN "type" SET NOT NULL,
ALTER COLUMN "type" SET DEFAULT 'NORMAL',
ALTER COLUMN "type" SET DATA TYPE "UserType";

-- DropTable
DROP TABLE "License";

-- CreateTable
CREATE TABLE "Organization" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "address" TEXT NOT NULL,
    "phone" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Organization_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Certification" (
    "id" SERIAL NOT NULL,
    "discipline" "Discipline" NOT NULL DEFAULT 'SCUBA',
    "organizationId" INTEGER NOT NULL,
    "type" "CetificationType" NOT NULL,
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
    "address" TEXT NOT NULL,
    "phone" TEXT NOT NULL,
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
    "address" TEXT NOT NULL,
    "phone" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Shop_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "UserCertification" (
    "id" SERIAL NOT NULL,
    "certNo" TEXT NOT NULL,
    "certDate" TIMESTAMP(3) NOT NULL,
    "userId" INTEGER NOT NULL,
    "certId" INTEGER NOT NULL,
    "instructorId" INTEGER,
    "shopId" INTEGER,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "UserCertification_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "Shop_shopNo_key" ON "Shop"("shopNo");

-- CreateIndex
CREATE UNIQUE INDEX "Password_email_key" ON "Password"("email");

-- AddForeignKey
ALTER TABLE "Certification" ADD CONSTRAINT "Certification_organizationId_fkey" FOREIGN KEY ("organizationId") REFERENCES "Organization"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UserCertification" ADD CONSTRAINT "UserCertification_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UserCertification" ADD CONSTRAINT "UserCertification_certId_fkey" FOREIGN KEY ("certId") REFERENCES "Certification"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UserCertification" ADD CONSTRAINT "UserCertification_instructorId_fkey" FOREIGN KEY ("instructorId") REFERENCES "User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UserCertification" ADD CONSTRAINT "UserCertification_shopId_fkey" FOREIGN KEY ("shopId") REFERENCES "Shop"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Password" ADD CONSTRAINT "Password_email_fkey" FOREIGN KEY ("email") REFERENCES "User"("email") ON DELETE RESTRICT ON UPDATE CASCADE;
