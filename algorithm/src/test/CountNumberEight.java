package test;

/*
 * 1���� 10,000���� 8�̶�� ���ڰ� �� ��� �����°�?
 * 8�� ���ԵǾ� �ִ� ������ ������ ī���� �ϴ� ���� �ƴ϶� 8�̶�� ���ڸ� ��� ī���� �ؾ� �Ѵ�.
 * (�� ������� 8808�� 3, 8888�� 4�� ī���� �ؾ� ��)
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
