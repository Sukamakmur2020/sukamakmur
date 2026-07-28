const { PrismaClient } = require('@prisma/client');
const bcrypt = require('bcryptjs');
const prisma = new PrismaClient();

async function main() {
  const email = 'admin@sukamakmur.desa.id';
  let user = await prisma.user.findUnique({ where: { email } });
  
  if (!user) {
    const hashedPassword = await bcrypt.hash('password123', 10);
    user = await prisma.user.create({
      data: {
        nama: 'Admin',
        email,
        password: hashedPassword,
        role: 'ADMIN'
      }
    });
    console.log('Admin user created');
  } else {
    console.log('Admin user already exists');
  }
}
main().finally(() => prisma.$disconnect());
