module audio_interface(
clk,
rst,
phase_out);

input clk;
input rst;
output [15:0] phase_out;

reg [15:0] phase_out;

// For now just generate a saw wave.
always @ (posedge clk)
begin : wave
    if(rst == 1'b1) begin
        phase_out <= 0;
    end 
    else begin
        phase_out <= phase_out + 1;
    end
end

endmodule