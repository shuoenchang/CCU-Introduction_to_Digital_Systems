`timescale 1ns/1ps
module lab(CLK, RST, in_a, in_b, Product, Product_Valid);
					// in_a * in_b = Product
					// in_a is Multiplicand , in_b is Multiplier
input 			CLK, RST;
input 	[7:0]	in_a;	// Multiplicand
input 	[7:0]	in_b;	// Multiplier
output 	[15:0]  Product;
output  		Product_Valid;

reg 	[15:0]	Mplicand;
reg 	[7:0]	Mplier;
reg 	[15:0]	Product;
reg 			Product_Valid;
reg 	[5:0]	Counter ;
reg				sign;	//isSigned

//Counter
always @(posedge CLK or posedge RST)
begin
	if(RST)
		Counter <=6'b0;
	else
		Counter <= Counter + 6'b1;

end

//Product
always @(posedge CLK or posedge RST)
begin
	if(RST) begin
		Product  <= 16'b0;
		Mplicand <= 16'b0;
		Mplier   <= 8'b0;
	end 
	else if(Counter == 6'd0) begin
		Product	 	<= 32'b0;
		if(in_a[7]==1'b1)
			Mplicand <= {8'b0,(~in_a)+8'b1};
		else
			Mplicand <= {8'b0,in_a};
		if(in_b[7]==1'b1)
			Mplier	 <= (~in_b)+8'b1;
		else
			Mplier	 <= in_b;
		sign <= in_a[7]^in_b[7];
		
	end 
	else if(Counter <=6'd8) 
	begin
		if(Mplier[0] == 1'b1)	
		Product <= Mplicand + Product;
		Mplicand <= Mplicand << 1'b1;
		Mplier <= Mplier >> 1'b1;
	end 
	else begin
		if(sign)
		begin
			Product <= ~Product+16'b1;
			sign <= 1'b0;
		end
		else
			Product 	<= Product;
			
		Mplicand	<= Mplicand;
		Mplier 		<= Mplier;
	end
end

//Product_Valid
always @(posedge CLK or posedge RST)
begin
	if(RST)
		Product_Valid <=1'b0;
	else if(Counter==6'd9)
		Product_Valid <=1'b1;
	else
		Product_Valid <=1'b0;
end

endmodule
