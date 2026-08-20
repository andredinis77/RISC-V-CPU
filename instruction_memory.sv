module instruction_memory(
        input logic[31:0] pc,
        output logic[31:0] instru
);
    logic[31:0] ins [0:12];

    // .text
	// main: 
	// 	add x1, zero, zero
	// 	addi x2, zero, 2
	// LOOP:
	// 	addi x1, x1, 1
	// 	addi x2, x2, -1
	// 	bne x2, x0, LOOP
	// 	sw x1, 16(x0)
	// 	lw x3, 16(x0)
	// 	add x3, x3, zero	

    initial begin
        $readmemh("machine_code.txt", ins);
    end

    always @(*) begin
        instru = ins[pc >> 2];
    end

endmodule
