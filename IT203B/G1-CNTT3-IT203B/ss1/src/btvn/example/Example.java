package btvn.example;

import java.util.Scanner;

public class Example {
    static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        try{
            String name = inputName(sc);
            String age = inputAge(sc);
            String email = inputEmail(sc);
            registerUser(name, age, email);
        }catch()

//        public static void registerUser(String name, String age, String email){
//            User user = new User();
//            user.setName(name);
//            user.setAge(age);
//            user.setEmail(email);
//            System.out.println("User registered successfully!");
//        }



    }

    public static String inputName(Scanner sc) {
    }
}
