package test;

public class collectNumber {
	public static void main(String[] args) {
		int target = 1000;
		int[] arr = new int[target];
		int[] number = new int[10];
		
		for(int i = 0; i < target; i++) {
			arr[i] = i+1;
		}
		
		for(int j = 0; j < number.length; j++) {
			number[j] = 0;
		}
		
		for(int z = 1; z <= arr.length+1; z++) {
			char[] c = (""+z).toCharArray();
			for(char j:c) {
				number[Character.getNumericValue(j)] += 1;
			}
		}
		
		for(int i : number) System.out.println(i);
	}
}
