/////////////////////////////////////////////////////////////////////////
//                                                                     //
//   Modulename :  sys_defs.vh                                         //
//                                                                     //
//  Description :  This file has the macro-defines for macros used in  //
//                 the pipeline design.                                //
//                                                                     //
/////////////////////////////////////////////////////////////////////////


`ifndef __SYS_DEFS_VH__
`define __SYS_DEFS_VH__

`define SD #1
`define Next_cycle @(negedge clk)
`define CLK_Period #10
`define CLK_Half_Period CLK_Period/2

`define XLEN 32

`endif // __SYS_DEFS_VH__