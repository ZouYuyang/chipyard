package addtwice

import chisel3._
import chisel3.util._
import chisel3.experimental.IntParam

import org.chipsalliance.cde.config._
import org.chipsalliance.diplomacy.lazymodule._

import freechips.rocketchip.tile._
import freechips.rocketchip.diplomacy._

//  with HasBlackBoxInline 
class add_box extends BlackBox with HasBlackBoxPath {
    val io = IO(new Bundle {
        val a = Input(UInt(64.W))
        val b = Input(UInt(64.W))
        val c = Output(UInt(64.W))
    })

    val chipyardDir = System.getProperty("user.dir")
    addPath(s"$chipyardDir/generators/addtwice/src/main/resources/vsrc/add_blackbox.sv")
}


// older version
// class addtwice(opcodes: OpcodeSet, val w: Int)
//     (implicit p: Parameters) extends LazyRoCC(opcodes) {
//     override lazy val module = new LazyRoCCModuleImp(this) {
        // val busy = RegInit(false.B)
        
        // val rd = RegInit(0.U(5.W))
        // val result = RegInit(0.U(w.W))

        // io.cmd.ready := !busy
        // io.busy := busy
        // val canDecode = io.cmd.fire && (io.cmd.bits.inst.funct === 0.U )
        // when(canDecode) {
        //     busy := true.B
        //     rd := io.cmd.bits.inst.rd
        //     result := io.cmd.bits.rs1 + io.cmd.bits.rs2 + io.cmd.bits.rs2
        // }

        // io.resp.valid := busy
        // io.resp.bits.rd := rd
        // io.resp.bits.data := result
        // when (io.resp.fire) {
        //     busy := false.B
        // }
//     }
// }]

class SVAccelerator(val w: Int) extends BlackBox(Map("WIDTH" -> IntParam(w))) with HasBlackBoxPath {
    val io = IO(new Bundle {
        // Command channel
        val clock                   = Input(Clock())
        val reset                   = Input(Bool())
        val i_cmd_bits_inst_opcode  = Input(UInt(7.W))     // opcode
        val i_cmd_bits_inst_funct   = Input(UInt(7.W))     // funct7
        val i_cmd_bits_rs1          = Input(UInt(w.W))     // source register rs1 data
        val i_cmd_bits_inst_xs1     = Input(UInt(1.W))     // source register rs1 enable
        val i_cmd_bits_rs2          = Input(UInt(w.W))     // source register rs2 data
        val i_cmd_bits_inst_xs2     = Input(UInt(1.W))     // source register rs2 enable
        val i_cmd_bits_inst_rd      = Input(UInt(5.W))     // destination register
        val i_cmd_bits_inst_xd      = Input(UInt(1.W))     // destination register enable
        val o_cmd_ready             = Output(UInt(1.W))    // rocc ready for new data
        val i_cmd_fire              = Input(UInt(1.W))     // command handshaked

        // Busy
        val o_busy                  = Output(UInt(1.W))
        
        // Responce channel
        val o_resp_valid            = Output(UInt(1.W))    // response valid
        val o_resp_bits_rd          = Output(UInt(5.W))    // response destination register
        val o_resp_bits_data        = Output(UInt(w.W))    // responce data
        val i_resp_fire             = Input(UInt(1.W))     // responce fired
    })

    val chipyardDir = System.getProperty("user.dir")
    addPath(s"$chipyardDir/generators/addtwice/src/main/resources/vsrc/SVAccelerator.sv")
}

// blackbox version
// class addtwice(opcodes: OpcodeSet, val w: Int)
//     (implicit p: Parameters) extends LazyRoCC(opcodes) {
//     override lazy val module = new LazyRoCCModuleImp(this) {
//         val busy = RegInit(false.B)
        
//         val rd = RegInit(0.U(5.W))
//         val blackbox_result = WireDefault(0.U(w.W))
//         val result = RegInit(0.U(w.W))

//         val blackbox = Module(new add_box)
//         blackbox.io.a := io.cmd.bits.rs1
//         blackbox.io.b := io.cmd.bits.rs2
//         blackbox_result := blackbox.io.c

//         io.cmd.ready := !busy
//         io.busy := busy
//         val canDecode = io.cmd.fire && (io.cmd.bits.inst.funct === 0.U )
//         when(canDecode) {
//             busy := true.B
//             rd := io.cmd.bits.inst.rd
//             // result := io.cmd.bits.rs1 + io.cmd.bits.rs2 + io.cmd.bits.rs2)
//             result := blackbox_result
//         }

//         io.resp.valid := busy
//         io.resp.bits.rd := rd
//         io.resp.bits.data := result
//         when (io.resp.fire) {
//             busy := false.B
//         }
//     }
// }

// blackbox v2 version
class addtwice(opcodes: OpcodeSet, val w: Int)
    (implicit p: Parameters) extends LazyRoCC(opcodes) {
    override lazy val module = new LazyRoCCModuleImp(this) {
        // Command channel
        // val i_cmd_bits_inst_opcode  = WireDefault(0.U(7.W))     // opcode
        // val i_cmd_bits_inst_funct   = WireDefault(0.U(7.W))     // funct7
        // val i_cmd_bits_rs1          = WireDefault(0.U(w.W))     // source register rs1 data
        // val i_cmd_bits_inst_xs1     = WireDefault(0.U(1.W))     // source register rs1 enable
        // val i_cmd_bits_rs2          = WireDefault(0.U(w.W))     // source register rs2 data
        // val i_cmd_bits_inst_xs2     = WireDefault(0.U(1.W))     // source register rs2 enable
        // val i_cmd_bits_inst_rd      = WireDefault(0.U(5.W))     // destination register
        // val i_cmd_bits_inst_xd      = WireDefault(0.U(1.W))     // destination register enable
        // val o_cmd_ready             = WireDefault(0.U(1.W))     // rocc ready for new data
        // val i_cmd_fire              = WireDefault(0.U(1.W))     // command handshaked

        // // Busy
        // val o_busy                  = WireDefault(0.U(1.W))
        
        // // Responce channel
        // val i_resp_valid            = WireDefault(0.U(1.W))     // response valid
        // val o_resp_bits_rd          = WireDefault(0.U(5.W))     // response destination register
        // val o_resp_bits_data        = WireDefault(0.U(w.W))     // responce data
        // val i_resp_fire             = WireDefault(0.U(1.W))     // responce fired

        withClockAndReset(clock, reset) {
            val acc = Module(new SVAccelerator(w))

            acc.io.clock                        := clock
            acc.io.reset                        := reset
            acc.io.i_cmd_bits_inst_opcode       := io.cmd.bits.inst.opcode
            acc.io.i_cmd_bits_inst_funct        := io.cmd.bits.inst.funct
            acc.io.i_cmd_bits_rs1               := io.cmd.bits.rs1
            acc.io.i_cmd_bits_inst_xs1          := io.cmd.bits.inst.xs1
            acc.io.i_cmd_bits_rs2               := io.cmd.bits.rs2
            acc.io.i_cmd_bits_inst_xs2          := io.cmd.bits.inst.xs2
            acc.io.i_cmd_bits_inst_rd           := io.cmd.bits.inst.rd
            acc.io.i_cmd_bits_inst_xd           := io.cmd.bits.inst.xd
            io.cmd.ready                        := acc.io.o_cmd_ready
            acc.io.i_cmd_fire                   := io.cmd.fire
             
            io.busy                             := acc.io.o_busy
 
            io.resp.valid                       := acc.io.o_resp_valid 
            io.resp.bits.rd                     := acc.io.o_resp_bits_rd
            io.resp.bits.data                   := acc.io.o_resp_bits_data
            acc.io.i_resp_fire                  := io.resp.fire
        }
    }
}