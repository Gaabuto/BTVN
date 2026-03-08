import java.io.IOException;

public class Bai4 {


    public static void saveToFile() throws IOException {
        throw new IOException("Lỗi khi lưu file!");
    }


    public static void processUserData() throws IOException {
        saveToFile();
    }

    public static void main(String[] args) {
        try {
            processUserData();
        } catch (IOException e) {
            System.out.println("Lưu thư mục thất bại\n  " + e.getMessage());
        }

    }
}