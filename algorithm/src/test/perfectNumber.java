package test;

import java.util.Scanner;

/*
 * �ڱ� �ڽ��� ������ ��� ���� ������� ���� �ڱ� �ڽ��� �Ǵ� �ڿ����� ��������� �Ѵ�. 
 * ���� ���, 6�� 28�� �������̴�. 6=1+2+3 // 1,2,3�� ���� 6�� ��� 28=1+2+4+7+14 // 1,2,4,7,14�� ���� 28�� ��� 
 * �Է����� �ڿ��� N�� �ް�, ������� N ������ ��� �������� ����ϴ� �ڵ带 �ۼ��϶�.
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
		System.out.print("�ڿ��� �Է� : "); 
		insertNumber = sc.nextInt();
		
		perfectNumber perfect = new perfectNumber();
		/* static ����� ���� ������ �Ǳ� ������ isPerfectNumber�޼ҵ带 ���� ����� �� ����, static�� ���̰ų� ��ü������ ���� �����ؾ� �� */
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
