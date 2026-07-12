package util;

import javax.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.Locale;
import java.util.Set;
import java.util.UUID;

public class FileUploadUtil {

    private static final Set<String> ALLOWED_EXTENSIONS = Set.of(".jpg", ".jpeg", ".png", ".gif", ".webp");
    private static final Set<String> ALLOWED_CONTENT_TYPES = Set.of(
            "image/jpeg",
            "image/png",
            "image/gif",
            "image/webp"
    );
    private static final long MAX_FILE_SIZE = 5L * 1024 * 1024;

    public static String saveFile(Part filePart, String uploadDir) throws IOException {
        if (filePart == null || filePart.getSize() == 0) {
            return null;
        }

        String originalName = getFileName(filePart);
        if (originalName == null || originalName.isEmpty()) {
            return null;
        }

        if (filePart.getSize() > MAX_FILE_SIZE) {
            throw new IllegalArgumentException("Image size must not exceed 5 MB.");
        }

        String extension = "";
        int dotIndex = originalName.lastIndexOf('.');
        if (dotIndex > 0) {
            extension = originalName.substring(dotIndex).toLowerCase(Locale.ROOT);
        }

        String contentType = filePart.getContentType();
        if (contentType != null) {
            contentType = contentType.toLowerCase(Locale.ROOT);
        }

        if (!ALLOWED_EXTENSIONS.contains(extension) || contentType == null || !ALLOWED_CONTENT_TYPES.contains(contentType)) {
            throw new IllegalArgumentException("Only JPG, JPEG, PNG, GIF, and WEBP images are allowed.");
        }

        String newFileName = UUID.randomUUID().toString() + extension;

        File dir = new File(uploadDir);
        if (!dir.exists()) {
            dir.mkdirs();
        }

        filePart.write(uploadDir + File.separator + newFileName);
        return newFileName;
    }

    private static String getFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        if (contentDisp == null) return null;
        for (String token : contentDisp.split(";")) {
            if (token.trim().startsWith("filename")) {
                String name = token.substring(token.indexOf('=') + 1).trim().replace("\"", "");
                return Paths.get(name).getFileName().toString();
            }
        }
        return null;
    }

    public static void deleteFile(String fileName, String uploadDir) {
        if (fileName == null || fileName.isEmpty()) return;
        File file = new File(uploadDir + File.separator + fileName);
        if (file.exists()) {
            file.delete();
        }
    }
}
