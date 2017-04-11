package test;

public class star {
	public static void main(String[] args) {
		
		int max = 5;
		
		for(int i = 0; i < max; i++) {
			for(int j = 0; j < max; j++) {
				if(i < j)
					System.out.print("*");
				else
					System.out.print(" ");
			}
			for(int j = max; j > 0; j--) {
				if(i < j)
					System.out.print("*");
				else
					System.out.print(" ");
			}
			System.out.println();
		}
	}
}
