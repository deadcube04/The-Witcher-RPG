import { request } from "@/shared/api/client";
import { imageUploadSchema, type ImagePurpose } from "@/shared/contracts/media";

export async function uploadImage(file: Blob, purpose: ImagePurpose): Promise<string> {
 const body = new FormData();
 body.append("file", file, "portrait.png");
 body.append("purpose", purpose);
 const result = await request("/media/images", imageUploadSchema, { method: "POST", body });
 return result.imageUrl;
}
