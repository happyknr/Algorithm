package test;

import java.util.Scanner;

/*
 * 6 6
 * 
 * 0   1   2   3   4   5
 * 19  20  21  22  23  6
 * 18  31  32  33  24  7
 * 17  30  35  34  25  8
 * 16  29  28  27  26  9
 * 15  14  13  12  11  10
 * 위처럼 6 6이라는 입력을 주면 6 X 6 매트릭스에 나선형 회전을 한 값을 출력해야 한다.
 * */

public class SpiralArray {

	public static void main(String[] args) {
		int x = 0, y = 0, z = 1;
		int turn = 1; /* 1:→ 2:↓ 3:← 4:↑ */ 
		
		Scanner sc = new Scanner(System.in);
		System.out.println("숫자 2개 입력");
		x = sc.nextInt();
		y = sc.nextInt();
		
		int arr[][] = new int[x][y];
		
		//1
		arr[0][0] = 1;
		arr[0][1] = 2;
		arr[0][2] = 3;
		arr[0][3] = 4;
		arr[0][4] = 5;
		
		//2
		arr[1][4] = 6;
		arr[2][4] = 7;
		arr[3][4] = 8;
		arr[4][4] = 9;
		
		//3
		arr[4][3] = 10;
		arr[4][2] = 11;
		arr[4][1] = 12;
		arr[4][0] = 13;
		
		//4
		arr[3][0] = 14;
		arr[2][0] = 15;
		arr[1][0] = 16;
		
		//1
		arr[1][1] = 17;
		arr[1][2] = 18;
		arr[1][3] = 19;
		
		//2
		arr[2][3] = 20;
		arr[3][3] = 21;
		
		//3
		arr[3][2] = 22;
		arr[3][1] = 23;
		
		//4
		arr[2][1] = 24;
		
		//1
		arr[2][2] = 25;
		
		
		for(int i = 0; i < x; i++) {
			for(int j = 0; j < y; j++) {
				if( turn == 1 ) {
					
					turn = 2;
				}
				if( turn == 2 ) {
					
					turn = 3;
				}
				if( turn == 3 ) {
					
					turn = 4;
				}
				if( turn == 4 ) {
					
					turn = 1;
				}
				System.out.print(arr[i][j]+"\t");
			}
			System.out.println();
		}
	}
}
