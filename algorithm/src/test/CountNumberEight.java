package test;

/*
 * 1부터 10,000까지 8이라는 숫자가 총 몇번 나오는가?
 * 8이 포함되어 있는 숫자의 갯수를 카운팅 하는 것이 아니라 8이라는 숫자를 모두 카운팅 해야 한다.
 * (※ 예를들어 8808은 3, 8888은 4로 카운팅 해야 함)
*/

public class CountNumberEight {
	public static void main(String[] args) {
		int cnt = 0;
		System.out.println("8088".charAt(1));
		for(int i = 1; i <= 10000; i++) {
			String num = String.valueOf(i);
			//System.out.println("-------");
			for(int j = 0; j < num.length(); j++) {
				//System.out.println();
				if(num.charAt(j) == '8') {
					System.out.println(num);
					cnt++;
				}
			}
		}
		System.out.println("cnt : " + cnt);
	}
}
