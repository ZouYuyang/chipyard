package ntt

import chisel3._
import chisel3.util._
import chisel3.experimental.IntParam

import org.chipsalliance.cde.config._
import org.chipsalliance.diplomacy.lazymodule._

import freechips.rocketchip.tile._
import freechips.rocketchip.diplomacy._

import freechips.rocketchip.rocket.{M_XRD}
class NTT(opcodes: OpcodeSet) (implicit p: Parameters) extends LazyRoCC(opcodes) {
    override lazy val module = new LazyRoCCModuleImp(this) {

        val busy = RegInit(false.B)
        val valid = RegInit(false.B)
        io.cmd.ready := !busy

        val rs1 = RegInit(0.U(64.W))
        val rs2 = RegInit(0.U(64.W))
        val rd  = RegInit(0.U(5.W))
        val ret = RegInit(0.U(64.W))
        val funct = RegInit(0.U(5.W))
        val mod = RegInit(0.U(64.W))
        val mem_fsm = RegInit(0.U(3.W))

        when (io.cmd.fire) {
            rs1 := io.cmd.bits.rs1
            rs2 := io.cmd.bits.rs2
            rd  := io.cmd.bits.inst.rd
            funct := io.cmd.bits.inst.funct
            busy := true.B
            valid := false.B
        } .elsewhen (busy) {
            when (funct === 0.U) {
                // save
                mod := rs1
                busy := false.B
            } .elsewhen (funct === 1.U) {
                // fadd
                ret := (rs1 + rs2) % mod
                valid := true.B
            } .elsewhen (funct === 2.U ){
                // fsub
                ret := (rs1 - rs2) % mod
                valid := true.B
            } .elsewhen (funct === 3.U ) {
                // fmul
                ret := (rs1 * rs2) % mod
                valid := true.B
            } .elsewhen (funct === 4.U ) {
                // bitrev.load
                when (io.mem.resp.valid) {
                    ret := Reverse(io.mem.resp.bits.data(31, 0))
                    valid := true.B
                }
            }
        }

        io.resp.valid := valid
        io.resp.bits.rd := rd
        io.resp.bits.data := ret
        when (io.resp.fire) {
            busy := false.B
            valid := false.B
        }

        // MEMORY REQUEST INTERFACE
        io.mem.req.valid := busy && (funct === 4.U)
        io.mem.req.bits.addr := rs1 + (rs2 << 2)
        io.mem.req.bits.tag := rs1 + (rs2 << 2)
        io.mem.req.bits.cmd := M_XRD // perform a load (M_XWR for stores)
        io.mem.req.bits.size := log2Ceil(32).U
        io.mem.req.bits.signed := false.B
        io.mem.req.bits.data := 0.U // we're not performing any stores...
        io.mem.req.bits.phys := false.B
        io.mem.req.bits.dprv := io.cmd.bits.status.dprv
        io.mem.req.bits.dv := io.cmd.bits.status.dv
        io.mem.req.bits.no_resp := false.B

    }
}