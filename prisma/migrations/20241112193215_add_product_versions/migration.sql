/*
  Warnings:

  - Added the required column `versions` to the `License` table without a default value. This is not possible if the table is not empty.
  - Added the required column `versions` to the `LicenseRequest` table without a default value. This is not possible if the table is not empty.
  - Added the required column `versions` to the `Product` table without a default value. This is not possible if the table is not empty.

*/
-- RedefineTables
PRAGMA defer_foreign_keys=ON;
PRAGMA foreign_keys=OFF;
CREATE TABLE "new_License" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "key" TEXT NOT NULL,
    "productId" TEXT NOT NULL,
    "ownerId" TEXT NOT NULL,
    "duration" INTEGER NOT NULL,
    "startDate" DATETIME NOT NULL,
    "expiryDate" DATETIME NOT NULL,
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" DATETIME NOT NULL,
    "requestId" TEXT NOT NULL,
    "versions" TEXT NOT NULL,
    CONSTRAINT "License_productId_fkey" FOREIGN KEY ("productId") REFERENCES "Product" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "License_ownerId_fkey" FOREIGN KEY ("ownerId") REFERENCES "User" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "License_requestId_fkey" FOREIGN KEY ("requestId") REFERENCES "LicenseRequest" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);
INSERT INTO "new_License" ("createdAt", "duration", "expiryDate", "id", "key", "ownerId", "productId", "requestId", "startDate", "updatedAt") SELECT "createdAt", "duration", "expiryDate", "id", "key", "ownerId", "productId", "requestId", "startDate", "updatedAt" FROM "License";
DROP TABLE "License";
ALTER TABLE "new_License" RENAME TO "License";
CREATE UNIQUE INDEX "License_key_key" ON "License"("key");
CREATE TABLE "new_LicenseRequest" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "userId" TEXT NOT NULL,
    "productId" TEXT NOT NULL,
    "quantity" INTEGER NOT NULL,
    "duration" INTEGER NOT NULL,
    "message" TEXT,
    "companyName" TEXT NOT NULL,
    "status" TEXT NOT NULL DEFAULT 'PENDING',
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" DATETIME NOT NULL,
    "versions" TEXT NOT NULL,
    CONSTRAINT "LicenseRequest_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "LicenseRequest_productId_fkey" FOREIGN KEY ("productId") REFERENCES "Product" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);
INSERT INTO "new_LicenseRequest" ("companyName", "createdAt", "duration", "id", "message", "productId", "quantity", "status", "updatedAt", "userId") SELECT "companyName", "createdAt", "duration", "id", "message", "productId", "quantity", "status", "updatedAt", "userId" FROM "LicenseRequest";
DROP TABLE "LicenseRequest";
ALTER TABLE "new_LicenseRequest" RENAME TO "LicenseRequest";
CREATE TABLE "new_Product" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "name" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "features" TEXT NOT NULL,
    "image" BLOB,
    "durations" TEXT NOT NULL,
    "versions" TEXT NOT NULL
);
INSERT INTO "new_Product" ("description", "durations", "features", "id", "image", "name") SELECT "description", "durations", "features", "id", "image", "name" FROM "Product";
DROP TABLE "Product";
ALTER TABLE "new_Product" RENAME TO "Product";
PRAGMA foreign_keys=ON;
PRAGMA defer_foreign_keys=OFF;
