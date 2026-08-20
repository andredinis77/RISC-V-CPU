module data_memory (
    input logic [31:0] address,
    input logic memRead, memWrite, clk,
    input logic [31:0] writeData,
    output logic [31:0] data
);

    logic [31:0] ram [0:64];

    
    initial begin
        
        for (int i = 0; i <= 64; i++) begin
            ram[i] = 32'h00000000;
        end
        
        ram[0] = 32'hFFFAAA11;
        ram[1] = 32'hFFFAAA22;
    end

    always_ff @(posedge clk) begin
        if(memWrite) begin
            ram[address >> 2] <= writeData;  
        end
    end

    assign data = (memRead) ? ram[address >> 2] : 32'b0;
    
endmodule