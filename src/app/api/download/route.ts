import { NextRequest, NextResponse } from "next/server";

export async function GET(req: NextRequest) {
  const url = req.nextUrl.searchParams.get("url");
  let name = req.nextUrl.searchParams.get("name") || "document";

  if (!url) {
    return new NextResponse("Missing url parameter", { status: 400 });
  }

  try {
    const response = await fetch(url);
    if (!response.ok) {
      throw new Error("Failed to fetch file");
    }

    // Get the extension from the URL if possible
    const extension = url.split(".").pop()?.split("?")[0];
    
    // Add extension to name if it doesn't have one and we found one
    if (extension && !name.toLowerCase().endsWith(`.${extension.toLowerCase()}`)) {
      name = `${name}.${extension}`;
    }

    // Force download headers
    const headers = new Headers(response.headers);
    headers.set("Content-Disposition", `attachment; filename="${name}"`);
    headers.set("Content-Type", "application/octet-stream");

    return new NextResponse(response.body, {
      status: 200,
      headers,
    });
  } catch (error) {
    console.error("Download error:", error);
    return new NextResponse("Error downloading file", { status: 500 });
  }
}
