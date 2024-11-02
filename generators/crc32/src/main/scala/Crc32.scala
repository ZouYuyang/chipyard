package Crc32

import chisel3._
import chisel3.util._
import chisel3.experimental.IntParam

import org.chipsalliance.cde.config._
import org.chipsalliance.diplomacy.lazymodule._

import freechips.rocketchip.tile._
import freechips.rocketchip.diplomacy._

class Crc32(opcodes: OpcodeSet) (implicit p: Parameters) extends LazyRoCC(opcodes) {
    override lazy val module = new LazyRoCCModuleImp(this) {

        val busy = RegInit(false.B)
        val valid = RegInit(false.B)
        val canDecode = io.cmd.fire && (io.cmd.bits.inst.funct === 0.U)
        io.cmd.ready := !busy

        val x = RegInit(0.U(32.W))
        val fsm = RegInit(0.U(4.W))
        val rd = RegInit(0.U(5.W))

        when (fsm === 0.U && canDecode) {
            x := io.cmd.bits.rs1
            rd := io.cmd.bits.inst.rd
            fsm := 1.U
            busy := true.B
            valid := false.B
        } .elsewhen (fsm >= 1.U && fsm <= 8.U) {
            fsm := fsm + 1.U(4.W)
            x := (x >> 1.U(32.W)) ^ ("hEDB88320".U(32.W) & ~((x & 1.U(32.W)) - 1.U(32.W)))
        }

        io.resp.valid := fsm === 9.U
        io.resp.bits.rd := rd
        io.resp.bits.data := x
        when (io.resp.fire) {
            busy := false.B
            valid := true.B
            fsm := 0.U
        }
    }
}