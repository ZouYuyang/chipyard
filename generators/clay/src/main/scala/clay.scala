package clay

import chisel3._
import chisel3.util._
import chisel3.experimental.IntParam

import org.chipsalliance.cde.config.{Field, Parameters, Config}
import freechips.rocketchip.tile._
import freechips.rocketchip.diplomacy._

class WithClayAccel extends Config((site, here, up) => {
  case BuildRoCC => up(BuildRoCC) ++ Seq(
    (p:Parameters) => {
      val regWidth = 64
      val clayCSRs = Seq(CustomCSR(0x800, (BigInt(1) << 32) - 1, Some(0)))
      // val clayCSRs = Nil
      val rocc = LazyModule(new ClayBlackboxExample(OpcodeSet.all, "blackbox", clayCSRs)(p))
      rocc
    }
  )
})

import org.chipsalliance.diplomacy.lazymodule._

class ClayBlackboxExample(opcodes: OpcodeSet, blackBoxFile: String, csrList: Seq[CustomCSR])(implicit p: Parameters)
    extends LazyRoCC(opcodes, 0, false, csrList) {
  override lazy val module = new ClayBlackboxExampleModuleImp(this, blackBoxFile)
}

class ClayBlackboxExampleModuleImp(outer: ClayBlackboxExample, blackBoxFile: String)(implicit p: Parameters)
    extends LazyRoCCModuleImp(outer)
    with RequireSyncReset
    with HasCoreParameters {


  println("!!!!!!!!!!!!Clay RoCC has ", outer.roccCSRs.size, " CSRs!!!!!!!!!")
  val blackbox = {
    val roccIo = io
    Module(
      new BlackBox() with HasBlackBoxPath {
        val io = IO( new Bundle {
                      val clock = Input(Clock())
                      val reset = Input(Reset())
                      // val rocc = chiselTypeOf(roccIo)
                      val rocc = new RoCCCoreIOForClay(outer.roccCSRs.size)
                    })
        override def desiredName: String = blackBoxFile
        val chipyardDir = System.getProperty("user.dir")
        addPath(s"$chipyardDir/generators/clay/src/main/resources/vsrc/blackbox.v")
        addPath(s"$chipyardDir/generators/clay/src/main/resources/vsrc/rocc_top.sv")
      }
    )
  }

  blackbox.io.clock := clock
  blackbox.io.reset := reset

  blackbox.io.rocc.cmd <> io.cmd
  io.resp <> blackbox.io.rocc.resp
  io.mem <> blackbox.io.rocc.mem
  io.busy := blackbox.io.rocc.busy
  // io.interrupt := blackbox.io.rocc.interrupt
  // blackbox.io.rocc.exception := io.exception
  // io.ptw <> blackbox.io.rocc.ptw
  // io.fpu_req <> blackbox.io.rocc.fpu_req
  // blackbox.io.rocc.fpu_resp <> io.fpu_resp
  println("!!!!!!!!!!!!Clay RoCC io.csr.size =  ", io.csrs.size)
  io.csrs <> blackbox.io.rocc.csrs
}