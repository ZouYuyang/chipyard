package cordic


import chisel3._
import chisel3.util._
import chisel3.experimental.IntParam

import org.chipsalliance.cde.config._
import org.chipsalliance.diplomacy.lazymodule._

import freechips.rocketchip.tile._
import freechips.rocketchip.diplomacy._

import freechips.rocketchip.rocket.{M_XRD}
class CORDIC(opcodes: OpcodeSet) (implicit p: Parameters) extends LazyRoCC(opcodes) {
    override lazy val module = new LazyRoCCModuleImp(this) {
        val busy = RegInit(false.B)
        val valid = RegInit(false.B)
        io.cmd.ready := !busy

        val x = RegInit(0.S(32.W))
        val y = RegInit(0.S(32.W))
        val z = RegInit(0.S(32.W))
        val fsm = RegInit(0.U(5.W))
        val rd = RegInit(0.U(5.W))
        val funct = RegInit(0.U(5.W))

        val x_mul = RegInit(0.U(47.W))
        val y_mul = RegInit(0.U(47.W))
        val z_mul = RegInit(0.U(47.W))

        val thetas = VecInit(Seq(  
            1474560.S(32.W),  
            870484.S(32.W),  
            459940.S(32.W),  
            233473.S(32.W),  
            117189.S(32.W),  
            58652.S(32.W),  
            29333.S(32.W),  
            14667.S(32.W),  
            7334.S(32.W),  
            3667.S(32.W),  
            1833.S(32.W),  
            917.S(32.W),  
            458.S(32.W),  
            229.S(32.W),  
            115.S(32.W),  
            57.S(32.W)  
        ))  
        
        when (fsm === 0.U && io.cmd.fire && io.cmd.bits.inst.funct < 3.U) {
            when (io.cmd.bits.rs1 === 0.U.asUInt) {
                x := 1.S << 15
                y := 0.S
                z := 0.S
                rd := io.cmd.bits.inst.rd
                fsm := 17.U
                busy := true.B
                valid := false.B
                funct := io.cmd.bits.inst.funct
                
                // printf("[[[CORDIC: LOAD1]]]")
            } .otherwise {
                x := 19898.S // scale
                y := 0.S
                z := io.cmd.bits.rs1.asSInt    // input angle      
                rd := io.cmd.bits.inst.rd
                fsm := 1.U
                busy := true.B
                valid := false.B
                funct := io.cmd.bits.inst.funct
                // printf("[[[CORDIC: LOAD2]]]")
            }
        } .elsewhen (fsm === 0.U && io.cmd.fire && io.cmd.bits.inst.funct === 3.U){
            // load fmul parameter
            x_mul := io.cmd.bits.rs1
            y_mul := io.cmd.bits.rs2
            rd := io.cmd.bits.inst.rd
            fsm := 18.U
            busy := true.B
            valid := false.B
            funct := io.cmd.bits.inst.funct
            // printf("[[[CORDIC: LOAD3]]]")
        } .elsewhen (fsm >= 1.U && fsm <= 16.U) {
            fsm := fsm + 1.U
            when (z < 0.S) {
                x := x + (y >> (fsm - 1.U))
                y := y - (x >> (fsm - 1.U))
                z := z + thetas(fsm - 1.U)
            } .otherwise {
                x := x - (y >> (fsm - 1.U))
                y := y + (x >> (fsm - 1.U))
                z := z - thetas(fsm - 1.U)
            }
        } .elsewhen (fsm === 18.U) {
            // do multiply and shift
            z_mul := x_mul * y_mul
            fsm := 17.U
        }

        val ret = WireDefault(0.S(32.W))
        when (funct === 0.U) {
            // sine
            ret := y
        } .elsewhen(funct === 1.U) {
            // cosine
            ret := x
        } .elsewhen(funct === 2.U) {
            // haver
            ret := ((1.S << 15) - x) >> 1
        } .elsewhen(funct === 3.U) {
            // fmul
            ret := (z_mul >> 15).asSInt
        }

        io.resp.valid := (fsm === 17.U)
        io.resp.bits.rd := rd
        io.resp.bits.data := ret.asUInt
        when (io.resp.fire) {
            busy := false.B
            valid := true.B
            fsm := 0.U
        }
    }
}