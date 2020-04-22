`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/13/2018 01:12:02 AM
// Design Name: 
// Module Name: pb_ve
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module pb_ve
(
	input	SYS_CLK,
	input	SYS_RST,
	input	MS_F,
	input	KEYIN,
	output	KEYOUT
); 
reg	KEYIN_r;
reg	keyout_r;
//push_button vibrating elemination
reg	[1:0]	ve_key_st;
reg	[3:0]	ve_key_count;

always @ (posedge SYS_CLK)
	KEYIN_r <= KEYIN;

always @ (posedge SYS_CLK)
	if (SYS_RST)
	begin
		keyout_r <= 1'b0;
        ve_key_count <= 0;
		ve_key_st <= 0;
    end
	else
	case (ve_key_st)
		0:
		begin
			keyout_r <= 1'b0;
			ve_key_count <= 0;
			if (!KEYIN_r)
				ve_key_st <= 1;
		end
		1:
		begin
			if (KEYIN_r)
				ve_key_st <= 0;
			else
			begin
				if (ve_key_count == 10)
					ve_key_st <= 2;
				else if (MS_F)
					ve_key_count <= ve_key_count + 1;
			end    
        end  
    	2:
		begin
			ve_key_count <= 0;
			if (KEYIN_r)
				ve_key_st <= 3;
		end  
		3:
		begin
			if (!KEYIN_r)
				ve_key_st <= 2;
			else
			begin
				if (ve_key_count == 10)
				begin
					ve_key_st <= 0;
					keyout_r <= 1'b1;
				end
				else if (MS_F)
					ve_key_count <= ve_key_count + 1;                 
			end    
		end      
		default:
			ve_key_st <= 0;
	endcase
	
assign KEYOUT = keyout_r;

endmodule
