package listener;

import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

@WebListener
public class StorageBootstrapListener implements ServletContextListener {

    public static final String CTX_ATTR_AVATAR_DIR = "AVATAR_UPLOAD_DIR";

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        ServletContext ctx = sce.getServletContext();
        String dir = resolveAvatarDir(ctx);
        try {
            Path path = Paths.get(dir);
            Files.createDirectories(path);
            ctx.setAttribute(CTX_ATTR_AVATAR_DIR, dir);
            System.out.println("[StorageBootstrapListener] Avatar directory ready: " + dir);
        } catch (Exception e) {
            System.err.println("[StorageBootstrapListener] Failed to prepare avatar directory: " + dir);
            e.printStackTrace();
        }
    }

    private String resolveAvatarDir(ServletContext ctx) {
        String configured = ctx.getInitParameter("avatarUploadDir"); // may be relative like "TopCV_Avatars"
        Path swpg4 = findAncestorNamed(ctx, "SWPG4");

        if (configured != null && !configured.trim().isEmpty()) {
            Path cfg = Paths.get(configured.trim());
            if (cfg.isAbsolute()) {
                return cfg.toString();
            }
            if (swpg4 != null) {
                return swpg4.resolve(cfg).toString();
            }
            return Paths.get(System.getProperty("user.home"), "SWPG4", configured.trim()).toString();
        }

        if (swpg4 != null) {
            return swpg4.resolve("TopCV_Avatars").toString();
        }
        return Paths.get(System.getProperty("user.home"), "SWPG4", "TopCV_Avatars").toString();
    }

    private Path findAncestorNamed(ServletContext ctx, String name) {
        try {
            String real = ctx.getRealPath("/");
            if (real != null) {
                Path cur = Paths.get(real).toAbsolutePath();
                // climb up at most 10 levels to avoid infinite loop
                for (int i = 0; i < 10 && cur != null; i++) {
                    if (cur.getFileName() != null && name.equalsIgnoreCase(cur.getFileName().toString())) {
                        return cur;
                    }
                    cur = cur.getParent();
                }
            }
        } catch (Exception ignore) { }
        return null;
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        // no-op
    }
}
