package addtwice

import chisel3._
import chisel3.util._
import chisel3.experimental.IntParam

import org.chipsalliance.cde.config._
import org.chipsalliance.diplomacy.lazymodule._

import freechips.rocketchip.tile._
import freechips.rocketchip.diplomacy._

class addtwice(opcodes: OpcodeSet, val w: Int)
    (implicit p: Parameters) extends LazyRoCC(opcodes) {
    override lazy val module = new LazyRoCCModuleImp(this) {
        val busy = RegInit(false.B)
        
        val rd = RegInit(0.U(5.W))
        val result = RegInit(0.U(w.W))

        io.cmd.ready := !busy
        io.busy := busy
        val canDecode = io.cmd.fire && (io.cmd.bits.inst.funct === 0.U )
        when(canDecode) {
            busy := true.B
            rd := io.cmd.bits.inst.rd
            result := io.cmd.bits.rs1 + io.cmd.bits.rs2 + io.cmd.bits.rs2
        }

        io.resp.valid := busy
        io.resp.bits.rd := rd
        io.resp.bits.data := result
        when (io.resp.fire) {
            busy := false.B
        }
    }
}