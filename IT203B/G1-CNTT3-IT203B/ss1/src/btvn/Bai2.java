package btvn;

import java.util.Scanner;

public class Bai2 {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);

        System.out.print("Nhập tổng số người: ");
        int tongSoNguoi = sc.nextInt();

        System.out.print("Nhập số nhóm: ");
        int soNhom = sc.nextInt();

        try {
            int ketQua = tongSoNguoi / soNhom;
            System.out.println("Mỗi nhóm có: " + ketQua + " người");
        } catch (ArithmeticException e) {
            System.out.println("Không thể chia cho 0!");
        }
    }
}