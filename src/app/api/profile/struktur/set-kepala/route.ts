import { NextRequest, NextResponse } from "next/server";
import { prisma } from "@/lib/prisma";

export async function POST(req: NextRequest) {
  try {
    const { id } = await req.json();

    if (!id) {
      return NextResponse.json({ success: false, message: "ID is required" }, { status: 400 });
    }

    // Wrap in a transaction to ensure atomicity
    await prisma.$transaction(async (tx) => {
      // 1. Get the current head (urutan === 1) and shift them down if they exist and are different
      const currentHead = await tx.strukturOrganisasi.findFirst({
        where: { urutan: 1 },
      });

      if (currentHead && currentHead.id !== id) {
        // Just set to 2 so they are no longer Kepala Desa
        await tx.strukturOrganisasi.update({
          where: { id: currentHead.id },
          data: { urutan: 2 },
        });
      }

      // 2. Set the requested ID to urutan 1
      await tx.strukturOrganisasi.update({
        where: { id },
        data: { urutan: 1 },
      });
    });

    return NextResponse.json({ success: true, message: "Berhasil mengatur sebagai Kepala Desa" });
  } catch (error) {
    console.error("API /profile/struktur/set-kepala error:", error);
    return NextResponse.json(
      { success: false, message: "Internal server error" },
      { status: 500 }
    );
  }
}
