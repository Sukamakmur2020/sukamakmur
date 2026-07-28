import { NextRequest, NextResponse } from 'next/server';
import { prisma } from '@/lib/prisma';
import bcrypt from 'bcryptjs';

export async function POST(req: NextRequest) {
  try {
    const body = await req.json();
    const { email, password } = body;

    const user = await prisma.user.findUnique({
      where: { email },
    });

    if (user && bcrypt.compareSync(password, user.password)) {
      const response = NextResponse.json(
        { success: true, message: 'Login berhasil' },
        { status: 200 }
      );

      // Set authentication cookie (valid for 24 hours)
      response.cookies.set({
        name: 'adminAuth',
        value: 'true',
        httpOnly: true,
        secure: process.env.NODE_ENV === 'production',
        sameSite: 'lax',
        maxAge: 60 * 60 * 24, // 24 hours
      });

      return response;
    } else {
      return NextResponse.json(
        { success: false, message: 'Email atau password salah' },
        { status: 401 }
      );
    }
  } catch (error) {
    console.error('Login error:', error);
    return NextResponse.json(
      { success: false, message: 'Terjadi kesalahan saat login' },
      { status: 500 }
    );
  }
}

export async function GET(req: NextRequest) {
  // Logout action
  const response = NextResponse.json(
    { success: true, message: 'Logout berhasil' },
    { status: 200 }
  );

  response.cookies.set({
    name: 'adminAuth',
    value: '',
    httpOnly: true,
    secure: process.env.NODE_ENV === 'production',
    sameSite: 'lax',
    maxAge: 0, // Delete the cookie
  });

  return response;
}
