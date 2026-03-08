import java.util.Scanner;

public class Bai1 {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);

        try {
            System.out.print("Mời bạn nhập một số: ");
            String input = sc.nextLine();

            int number = Integer.parseInt(input);
            System.out.println("Số bạn nhập là: " + number);

        } catch (NumberFormatException e) {
            System.out.println("Lỗi: Bạn phải nhập số, không được nhập chữ!");

        } finally {
            sc.close();
            System.out.println("Thực hiện dọn dẹp tài nguyên trong finally...");
        }
    }
}