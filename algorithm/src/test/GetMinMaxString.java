package test;

public class GetMinMaxString {
	public String getMinMaxString(String str) {
		String arr[] = str.split(" ");
		int min, max, n;
		min = max = Integer.parseInt(arr[0]);
		for(int i = 0 ; i < arr.length; i++)
		{
			n = Integer.parseInt(arr[i]);
			if(min > n) min = n;
			if(max < n) max = n;
		}
		return min+" "+max;
	}
	
	public static void main(String[] args) {
	    String str = "1 2 3 4";
		GetMinMaxString minMax = new GetMinMaxString();
		//아래는 테스트로 출력해 보기 위한 코드입니다.
		System.out.println("최대값과 최소값은?" + minMax.getMinMaxString(str));
	}
}
