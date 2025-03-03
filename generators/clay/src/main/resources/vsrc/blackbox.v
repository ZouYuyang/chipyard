// See LICENSE.SiFive for license details.

module blackbox (
    input clock,
    input                                reset,

    //////////// ROCC COMMAND /////////////
    output                               rocc_cmd_ready,
    input                                rocc_cmd_valid,
    input [6:0]                          rocc_cmd_bits_inst_funct,
    input [4:0]                          rocc_cmd_bits_inst_rs2,
    input [4:0]                          rocc_cmd_bits_inst_rs1,
    input                                rocc_cmd_bits_inst_xd,
    input                                rocc_cmd_bits_inst_xs1,
    input                                rocc_cmd_bits_inst_xs2,
    input [4:0]                          rocc_cmd_bits_inst_rd,
    input [6:0]                          rocc_cmd_bits_inst_opcode,
    input [64-1:0]                       rocc_cmd_bits_rs1,
    input [64-1:0]                       rocc_cmd_bits_rs2,
    input                                rocc_cmd_bits_status_debug,
    input                                rocc_cmd_bits_status_cease,
    input                                rocc_cmd_bits_status_wfi,
    input [31:0]                         rocc_cmd_bits_status_isa,
    input [2-1:0]                        rocc_cmd_bits_status_dprv,
    input                                rocc_cmd_bits_status_dv,
    input [2-1:0]                        rocc_cmd_bits_status_prv,
    input                                rocc_cmd_bits_status_v,
    input                                rocc_cmd_bits_status_sd,
    input [22:0]                         rocc_cmd_bits_status_zero2,
    input                                rocc_cmd_bits_status_mpv,
    input                                rocc_cmd_bits_status_gva,
    input                                rocc_cmd_bits_status_mbe,
    input                                rocc_cmd_bits_status_sbe,
    input [1:0]                          rocc_cmd_bits_status_sxl,
    input [1:0]                          rocc_cmd_bits_status_uxl,
    input                                rocc_cmd_bits_status_sd_rv32,
    input [7:0]                          rocc_cmd_bits_status_zero1,
    input                                rocc_cmd_bits_status_tsr,
    input                                rocc_cmd_bits_status_tw,
    input                                rocc_cmd_bits_status_tvm,
    input                                rocc_cmd_bits_status_mxr,
    input                                rocc_cmd_bits_status_sum,
    input                                rocc_cmd_bits_status_mprv,
    input [1:0]                          rocc_cmd_bits_status_xs,
    input [1:0]                          rocc_cmd_bits_status_fs,
    input [1:0]                          rocc_cmd_bits_status_vs,
    input [1:0]                          rocc_cmd_bits_status_mpp,
    input [0:0]                          rocc_cmd_bits_status_spp,
    input                                rocc_cmd_bits_status_mpie,
    input                                rocc_cmd_bits_status_ube,
    input                                rocc_cmd_bits_status_spie,
    input                                rocc_cmd_bits_status_upie,
    input                                rocc_cmd_bits_status_mie,
    input                                rocc_cmd_bits_status_hie,
    input                                rocc_cmd_bits_status_sie,
    input                                rocc_cmd_bits_status_uie,
    /////////////////// ROCC RESPONSE ///////////////
    input                                rocc_resp_ready,
    output                               rocc_resp_valid,
    output [4:0]                         rocc_resp_bits_rd,
    output [64-1:0]                      rocc_resp_bits_data,
    /////////////////// ROCC MEM REQ ////////////////
    input                                rocc_mem_req_ready,
    output                               rocc_mem_req_valid,
    output [40-1:0]                      rocc_mem_req_bits_addr,
    output [9-1:0]                       rocc_mem_req_bits_tag,
    output [5-1:0]                       rocc_mem_req_bits_cmd,
    output [2-1:0]                       rocc_mem_req_bits_size,
    output                               rocc_mem_req_bits_signed,
    output                               rocc_mem_req_bits_phys,
    output                               rocc_mem_req_bits_no_alloc,
    output                               rocc_mem_req_bits_no_xcpt,
    output                               rocc_mem_req_bits_no_resp,
    output [1:0]                         rocc_mem_req_bits_dprv,
    output                               rocc_mem_req_bits_dv,
    output [64-1:0]                      rocc_mem_req_bits_data,
    output [8-1:0]                       rocc_mem_req_bits_mask,
    output                               rocc_mem_s1_kill,
    output [64-1:0]                      rocc_mem_s1_data_data,
    output [8-1:0]                       rocc_mem_s1_data_mask,
    input                                rocc_mem_s2_nack,
    input                                rocc_mem_s2_nack_cause_raw,
    output                               rocc_mem_s2_kill,
    input                                rocc_mem_s2_uncached,
    input [32-1:0]                       rocc_mem_s2_paddr,
    input [40-1:0]                       rocc_mem_s2_gpa,
    input                                rocc_mem_s2_gpa_is_pte,
    input                                rocc_mem_resp_valid,
    input [40-1:0]                       rocc_mem_resp_bits_addr,
    input [9-1:0]                        rocc_mem_resp_bits_tag,
    input [5-1:0]                        rocc_mem_resp_bits_cmd,
    input [2-1:0]                        rocc_mem_resp_bits_size,
    input                                rocc_mem_resp_bits_signed,
    input [64-1:0]                       rocc_mem_resp_bits_data,
    input [8-1:0]                        rocc_mem_resp_bits_mask,
    input                                rocc_mem_resp_bits_replay,
    input                                rocc_mem_resp_bits_has_data,
    input [64-1:0]                       rocc_mem_resp_bits_data_word_bypass,
    input [64-1:0]                       rocc_mem_resp_bits_data_raw,
    input [64-1:0]                       rocc_mem_resp_bits_store_data,
    input [1:0]                          rocc_mem_resp_bits_dprv,
    input                                rocc_mem_resp_bits_dv,
    input                                rocc_mem_replay_next,
    input                                rocc_mem_s2_xcpt_ma_ld,
    input                                rocc_mem_s2_xcpt_ma_st,
    input                                rocc_mem_s2_xcpt_pf_ld,
    input                                rocc_mem_s2_xcpt_pf_st,
    input                                rocc_mem_s2_xcpt_gf_ld,
    input                                rocc_mem_s2_xcpt_gf_st,
    input                                rocc_mem_s2_xcpt_ae_ld,
    input                                rocc_mem_s2_xcpt_ae_st,
    input                                rocc_mem_ordered,
    input                                rocc_mem_store_pending,
    input                                rocc_mem_perf_acquire,
    input                                rocc_mem_perf_release,
    input                                rocc_mem_perf_grant,
    input                                rocc_mem_perf_tlbMiss,
    input                                rocc_mem_perf_blocked,
    input                                rocc_mem_perf_canAcceptStoreThenLoad,
    input                                rocc_mem_perf_canAcceptStoreThenRMW,
    input                                rocc_mem_perf_canAcceptLoadThenLoad,
    input                                rocc_mem_perf_storeBufferEmptyAfterLoad,
    input                                rocc_mem_perf_storeBufferEmptyAfterStore,
    output                               rocc_mem_keep_clock_enabled,
    input                                rocc_mem_clock_enabled,
    //////////////////// ROCC AUX ////////////////////////////
    output                               rocc_busy,
    //////////////////// ROCC CSR ////////////////////////////
    input rocc_csrs_0_ren,
    input rocc_csrs_0_wen,
    input [63:0] rocc_csrs_0_wdata,
    input [63:0] rocc_csrs_0_value,
    output rocc_csrs_0_stall,
    output rocc_csrs_0_set,
    output [63:0] rocc_csrs_0_sdata
  );

  assign rocc_csrs_0_stall = 0;

  clay_module ClayModule(
    .clock(clock),
    .reset(reset),
    .rocc_cmd_ready(rocc_cmd_ready),
    .rocc_cmd_valid(rocc_cmd_valid),
    .rocc_cmd_bits_inst_funct(rocc_cmd_bits_inst_funct),
    .rocc_cmd_bits_inst_rs2(rocc_cmd_bits_inst_rs2),
    .rocc_cmd_bits_inst_rs1(rocc_cmd_bits_inst_rs1),
    .rocc_cmd_bits_inst_xd(rocc_cmd_bits_inst_xd),
    .rocc_cmd_bits_inst_xs1(rocc_cmd_bits_inst_xs1),
    .rocc_cmd_bits_inst_xs2(rocc_cmd_bits_inst_xs2),
    .rocc_cmd_bits_inst_rd(rocc_cmd_bits_inst_rd),
    .rocc_cmd_bits_inst_opcode(rocc_cmd_bits_inst_opcode),
    .rocc_cmd_bits_rs1(rocc_cmd_bits_rs1),
    .rocc_cmd_bits_rs2(rocc_cmd_bits_rs2),
    .rocc_resp_ready(rocc_resp_ready),
    .rocc_resp_valid(rocc_resp_valid),
    .rocc_resp_bits_rd(rocc_resp_bits_rd),
    .rocc_resp_bits_data(rocc_resp_bits_data),
    .rocc_mem_req_ready(rocc_mem_req_ready),
    .rocc_mem_req_valid(rocc_mem_req_valid),
    .rocc_mem_req_bits_addr(rocc_mem_req_bits_addr),
    .rocc_mem_req_bits_tag(rocc_mem_req_bits_tag),
    .rocc_mem_req_bits_cmd(rocc_mem_req_bits_cmd),
    .rocc_mem_req_bits_size(rocc_mem_req_bits_size),
    .rocc_mem_req_bits_signed(rocc_mem_req_bits_signed),
    .rocc_mem_req_bits_phys(rocc_mem_req_bits_phys),
    .rocc_mem_req_bits_data(rocc_mem_req_bits_data),
    .rocc_mem_req_bits_mask(rocc_mem_req_bits_mask),
    .rocc_mem_resp_valid(rocc_mem_resp_valid),
    .rocc_mem_resp_bits_addr(rocc_mem_resp_bits_addr),
    .rocc_mem_resp_bits_tag(rocc_mem_resp_bits_tag),
    .rocc_mem_resp_bits_cmd(rocc_mem_resp_bits_cmd),
    .rocc_mem_resp_bits_size(rocc_mem_resp_bits_size),
    .rocc_mem_resp_bits_signed(rocc_mem_resp_bits_signed),
    .rocc_mem_resp_bits_data(rocc_mem_resp_bits_data),
    .rocc_mem_resp_bits_mask(rocc_mem_resp_bits_mask),
    .rocc_busy(rocc_busy),
    .rocc_csrs_0_wdata(rocc_csrs_0_wdata),
    .rocc_csrs_0_set(rocc_csrs_0_set),
    .rocc_csrs_0_sdata(rocc_csrs_0_sdata)
  );


  assign rocc_mem_req_bits_no_alloc = 'd0;
  assign rocc_mem_req_bits_no_xcpt = 'd0;
  assign rocc_mem_req_bits_no_resp = 'd0;
  assign rocc_mem_req_bits_dprv = 'd0;
  assign rocc_mem_req_bits_dv = 'd0;
  assign rocc_mem_s1_kill = 'd0;
  assign rocc_mem_s1_data_data = 'd0;
  assign rocc_mem_s1_data_mask = 'd0;
  assign rocc_mem_s2_kill = 'd0;
  assign rocc_mem_keep_clock_enabled = 'd1;

endmodule

module clay_module(
    input                                clock,
    input                                reset,

    //////////// ROCC COMMAND /////////////
    output                               rocc_cmd_ready,
    input                                rocc_cmd_valid,
    input [6:0]                          rocc_cmd_bits_inst_funct,
    input [4:0]                          rocc_cmd_bits_inst_rs2,
    input [4:0]                          rocc_cmd_bits_inst_rs1,
    input                                rocc_cmd_bits_inst_xd,
    input                                rocc_cmd_bits_inst_xs1,
    input                                rocc_cmd_bits_inst_xs2,
    input [4:0]                          rocc_cmd_bits_inst_rd,
    input [6:0]                          rocc_cmd_bits_inst_opcode,
    input [64-1:0]                       rocc_cmd_bits_rs1,
    input [64-1:0]                       rocc_cmd_bits_rs2,
    /////////////////// ROCC RESPONSE ///////////////
    input                                rocc_resp_ready,
    output                               rocc_resp_valid,
    output [4:0]                         rocc_resp_bits_rd,
    output [64-1:0]                      rocc_resp_bits_data,
    /////////////////// ROCC MEM REQ ////////////////
    input                                rocc_mem_req_ready,
    output                               rocc_mem_req_valid,
    output [40-1:0]                      rocc_mem_req_bits_addr,
    output [9-1:0]                       rocc_mem_req_bits_tag,
    output [5-1:0]                       rocc_mem_req_bits_cmd, //M_XRD or M_XWR
    output [2-1:0]                       rocc_mem_req_bits_size,
    output                               rocc_mem_req_bits_signed,
    output                               rocc_mem_req_bits_phys,  // physical addr? => false!
    output [64-1:0]                      rocc_mem_req_bits_data,  // if store, fill this
    output [8-1:0]                       rocc_mem_req_bits_mask,
    /////////////////// ROCC MEM RESP /////////////////////
    input                                rocc_mem_resp_valid,
    input [40-1:0]                       rocc_mem_resp_bits_addr,
    input [9-1:0]                        rocc_mem_resp_bits_tag,
    input [5-1:0]                        rocc_mem_resp_bits_cmd,
    input [2-1:0]                        rocc_mem_resp_bits_size,
    input                                rocc_mem_resp_bits_signed,
    input [64-1:0]                       rocc_mem_resp_bits_data,
    input [8-1:0]                        rocc_mem_resp_bits_mask,
    //////////////////// ROCC AUX ////////////////////////////
    output                               rocc_busy,
    //////////////////// ROCC CSR ////////////////////////////
    input [63:0] rocc_csrs_0_wdata,
    output rocc_csrs_0_set,
    output [63:0] rocc_csrs_0_sdata


);

  rocc_top u_rocc_top(
    .clk                                      	( clock                         ),
    .rst                                      	( reset                         ),
    .rocc_cmd_funct                           	( rocc_cmd_bits_inst_funct      ),
    .rocc_cmd_opcode                          	( rocc_cmd_bits_inst_opcode     ),
    .rocc_cmd_rd                              	( rocc_cmd_bits_inst_rd         ),
    .rocc_cmd_rs1                             	( rocc_cmd_bits_inst_rs1        ),
    .rocc_cmd_rs1data                         	( rocc_cmd_bits_rs1             ),
    .rocc_cmd_rs2                             	( rocc_cmd_bits_inst_rs2        ),
    .rocc_cmd_rs2data                         	( rocc_cmd_bits_rs2             ),
    .rocc_cmd_xd                              	( rocc_cmd_bits_inst_xd         ),
    .rocc_cmd_xs1                             	( rocc_cmd_bits_inst_xs1        ),
    .rocc_cmd_xs2                             	( rocc_cmd_bits_inst_xs2        ),
    .rocc_master_virtual_rocc_resp_bus_rd     	( rocc_resp_bits_rd             ),
    .rocc_master_virtual_rocc_resp_bus_rddata 	( rocc_resp_bits_data           ),
    .cmd_enable                               	( rocc_cmd_valid                ),
    .cmd_ready                                	( rocc_cmd_ready                ),
    .rocc_master_virtual_resp_to_bus_enable   	( rocc_resp_valid               ),
    .rocc_master_virtual_resp_to_bus_ready    	( rocc_resp_ready               )
  );

  // MEM not impl
  assign rocc_mem_req_valid = 0;
  // Busy not impl
  assign rocc_busy = 0;
  // CSR not impl
  assign rocc_csrs_0_set = 0;

endmodule

module clay_module_demo(
    input                                clock,
    input                                reset,

    //////////// ROCC COMMAND /////////////
    output                               rocc_cmd_ready,
    input                                rocc_cmd_valid,
    input [6:0]                          rocc_cmd_bits_inst_funct,
    input [4:0]                          rocc_cmd_bits_inst_rs2,
    input [4:0]                          rocc_cmd_bits_inst_rs1,
    input                                rocc_cmd_bits_inst_xd,
    input                                rocc_cmd_bits_inst_xs1,
    input                                rocc_cmd_bits_inst_xs2,
    input [4:0]                          rocc_cmd_bits_inst_rd,
    input [6:0]                          rocc_cmd_bits_inst_opcode,
    input [64-1:0]                       rocc_cmd_bits_rs1,
    input [64-1:0]                       rocc_cmd_bits_rs2,
    /////////////////// ROCC RESPONSE ///////////////
    input                                rocc_resp_ready,
    output                               rocc_resp_valid,
    output [4:0]                         rocc_resp_bits_rd,
    output [64-1:0]                      rocc_resp_bits_data,
    /////////////////// ROCC MEM REQ ////////////////
    input                                rocc_mem_req_ready,
    output                               rocc_mem_req_valid,
    output [40-1:0]                      rocc_mem_req_bits_addr,
    output [9-1:0]                       rocc_mem_req_bits_tag,
    output [5-1:0]                       rocc_mem_req_bits_cmd, //M_XRD or M_XWR
    output [2-1:0]                       rocc_mem_req_bits_size,
    output                               rocc_mem_req_bits_signed,
    output                               rocc_mem_req_bits_phys,  // physical addr? => false!
    output [64-1:0]                      rocc_mem_req_bits_data,  // if store, fill this
    output [8-1:0]                       rocc_mem_req_bits_mask,
    /////////////////// ROCC MEM RESP /////////////////////
    input                                rocc_mem_resp_valid,
    input [40-1:0]                       rocc_mem_resp_bits_addr,
    input [9-1:0]                        rocc_mem_resp_bits_tag,
    input [5-1:0]                        rocc_mem_resp_bits_cmd,
    input [2-1:0]                        rocc_mem_resp_bits_size,
    input                                rocc_mem_resp_bits_signed,
    input [64-1:0]                       rocc_mem_resp_bits_data,
    input [8-1:0]                        rocc_mem_resp_bits_mask,
    //////////////////// ROCC AUX ////////////////////////////
    output                               rocc_busy,
    //////////////////// ROCC CSR ////////////////////////////
    input [63:0] rocc_csrs_0_wdata,
    output rocc_csrs_0_set,
    output [63:0] rocc_csrs_0_sdata
);

  assign rocc_cmd_ready = 1'b1;
  assign rocc_mem_req_valid = 1'b0;
  assign rocc_busy = 1'b0;

  /* Accumulate rs1 and rs2 into an accumulator */
  reg [64-1:0] acc;
  reg doResp;
  reg [4:0] rocc_cmd_bits_inst_rd_d;
  always @ (posedge clock) begin
    if (reset) begin
      acc <= {64{1'b0}};
      doResp <= 1'b0;
      rocc_cmd_bits_inst_rd_d <= 5'b0;
    end
    else if (rocc_cmd_valid && rocc_cmd_ready) begin
      doResp                  <= rocc_cmd_bits_inst_xd;
      rocc_cmd_bits_inst_rd_d <= rocc_cmd_bits_inst_rd;
      acc                     <= acc + rocc_cmd_bits_rs1 + rocc_cmd_bits_rs2;
    end
    else begin
      doResp <= 1'b0;
    end
  end

  assign rocc_resp_valid = doResp;
  assign rocc_resp_bits_rd = rocc_cmd_bits_inst_rd_d;
  assign rocc_resp_bits_data = acc;
  assign rocc_csrs_0_sdata = acc;
  assign rocc_csrs_0_set = doResp;

endmodule
