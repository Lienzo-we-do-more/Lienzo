// app/api/auth/[kindeAuth]/route.ts
import { handleAuth, getKindeServerSession } from "@kinde-oss/kinde-auth-nextjs/server";
import { NextRequest, NextResponse } from "next/server";
import { PrismaClient } from '@prisma/client'

const prisma = new PrismaClient()

async function syncUser(user: any) {
  const existingUser = await prisma.user.findUnique({
    where: { email: user.email },
  })

  if (!existingUser) {
    await prisma.user.create({
      data: {
        email: user.email,
        firstName: user.given_name || 'Unknown',
        lastName: user.family_name || 'User',
        role: 'USER', // Default role
      },
    })
  } else {
    await prisma.user.update({
      where: { email: user.email },
      data: {
        firstName: user.given_name || existingUser.firstName,
        lastName: user.family_name || existingUser.lastName,
      },
    })
  }
}

export async function GET(request: NextRequest, { params }: { params: { kindeAuth: string } }) {
  const authResult = await handleAuth(request, params.kindeAuth);
  
  if (authResult instanceof NextResponse && authResult.status === 302) {
    // Successful authentication
    const { getUser } = getKindeServerSession();
    const user = await getUser();
    if (user) {
      await syncUser(user);
    }
  }
  
  return authResult;
}