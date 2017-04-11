package test;

import java.util.Scanner;

/*
 * 자기 자신을 제외한 모든 양의 약수들의 합이 자기 자신이 되는 자연수를 완전수라고 한다. 
 * 예를 들면, 6과 28은 완전수이다. 6=1+2+3 // 1,2,3은 각각 6의 약수 28=1+2+4+7+14 // 1,2,4,7,14는 각각 28의 약수 
 * 입력으로 자연수 N을 받고, 출력으로 N 이하의 모든 완전수를 출력하는 코드를 작성하라.
 * */
public class perfectNumber {
	
	public int[] isPerfectNumber(int insertNumber) {
		int[] num = new int[insertNumber/2];
		int j = 0;
		for(int i = 1; i <= insertNumber; i++) {
			if(insertNumber%i == 0)
			{
				num[j] = i;
				j++;
			}
		}
		if(num.length > 0) return num;
		else return null;
	}

	public static void main(String[] args) {
		int insertNumber = 0;
		int[] perfectNumbers = {};
		Scanner sc = new Scanner(System.in);
		System.out.print("자연수 입력 : "); 
		insertNumber = sc.nextInt();
		
		perfectNumber perfect = new perfectNumber();
		/* static 멤버가 먼저 컴파일 되기 때문에 isPerfectNumber메소드를 직접 사용할 수 없고, static을 붙이거나 객체생성을 통해 접근해야 함 */
		perfectNumbers = perfect.isPerfectNumber(insertNumber);
		
		for(int i = 0; i < perfectNumbers.length; i++)
		{
			if(perfectNumbers[i] != 0 && perfectNumbers[i] < insertNumber)
			{
				System.out.println(perfectNumbers[i]);
			}
		}
	}

}
