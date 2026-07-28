const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

async function main() {
  const profile = await prisma.villageProfile.findFirst();
  if (profile) {
    await prisma.villageProfile.update({
      where: { id: profile.id },
      data: { luas_wilayah: '161 Hektar' }
    });
    console.log('Updated to 161 Hektar');
  } else {
    console.log('Profile not found in db');
  }
}
main().finally(() => prisma.$disconnect());
