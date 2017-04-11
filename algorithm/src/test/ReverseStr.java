package test;

import java.util.Arrays;

public class ReverseStr {
	public String reverseStr(String str) {
		String arr[] = str.split("");
		String ret = "";
		String tmp = null;
		for(int j = 0; j < arr.length; j++)
		{
			for(int i = 0 ; i < arr.length; i++)
			{
				if((i+1) <arr.length )
				{
					if(arr[i].compareTo(arr[i+1]) < 0)
					{
						tmp = arr[i];
						arr[i] = arr[i+1];
						arr[i+1] = tmp;
					}
				}
				System.out.println("i : " + arr[i]);
				
			}
		}
		for(int i = 0 ; i < arr.length; i++)
			ret += arr[i];
		return ret;
	}

	// 아래는 테스트로 출력해 보기 위한 코드입니다.
	public static void main(String[] args) {
		ReverseStr rs = new ReverseStr();
		System.out.println( rs.reverseStr("zsoeecaa") );
	}
}
