const { PrismaClient } = require('@prisma/client');
const bcrypt = require('bcryptjs');
const prisma = new PrismaClient();

async function main() {
  const email = 'admin@sukamakmur.desa.id';
  const hashedPassword = await bcrypt.hash('password123', 10);
  
  await prisma.user.upsert({
    where: { email },
    update: { password: hashedPassword },
    create: {
      nama: 'Admin',
      email,
      password: hashedPassword,
      role: 'ADMIN'
    }
  });
  console.log('Admin password updated to password123');
}
main().finally(() => prisma.$disconnect());
