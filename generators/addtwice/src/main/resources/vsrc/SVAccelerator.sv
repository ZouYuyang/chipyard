module SVAccelerator 
  #(parameter WIDTH) (
        input           clock,
        input           reset,
        input   [6:0]   i_cmd_bits_inst_opcode,     // opcode
        input   [6:0]   i_cmd_bits_inst_funct,      // funct7
        input   [63:0]  i_cmd_bits_rs1,             // source register rs1 data
        input           i_cmd_bits_inst_xs1,        // source register rs1 enable
        input   [63:0]  i_cmd_bits_rs2,             // source register rs2 data
        input           i_cmd_bits_inst_xs2,        // source register rs2 enable
        input   [4:0]   i_cmd_bits_inst_rd,         // destination register
        input           i_cmd_bits_inst_xd,         // destination register enable
        output          o_cmd_ready,                // rocc ready for new data
        input           i_cmd_fire,                 // command handshaked

        // Busy
        output          o_busy,
        
        // Responce channel
        output          o_resp_valid,               // response valid
        output  [4:0]   o_resp_bits_rd,             // response destination register
        output  [63:0]  o_resp_bits_data,           // responce data
        input           i_resp_fire                 // responce fired
);


endmodule