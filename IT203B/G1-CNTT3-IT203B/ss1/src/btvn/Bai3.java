import java.io.IOException;

public class Bai3 {

    public static void saveToFile() throws IOException {
        throw new IOException("Lỗi khi lưu file!");
    }

    public static void processUserData() throws IOException {
        saveToFile();
    }

    // Method A
    public static void main(String[] args) {
        try {
            processUserData();
        } catch (IOException e) {
            System.out.println("Lưu file thát bại: " + e.getMessage());
        }

    }
}