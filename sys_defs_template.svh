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


typedef enum logic [2:0] {
	INVALID 	= 	3'h0,	//Invalid operation
	VALID		= 	3'h1, 	//Valid operation
	CNN_FIN		= 	3'h2,	//Finish of an CNN computation
	POOL_FIN	= 	3'h3,	//Finish of an pooling computation
	COMPL 		= 	3'h4	//Completion of an operation
} PE_STATE;

typedef struct packed {
	logic signed	[`ICP_NUM-1:0]	[`CNN_XLEN-1:0]		A;
	PE_STATE											PE_state;
	logic signed					[`CNN_XLEN-1:0]		wrb_data;
	logic							[`ADDR_B-1:0]		wrb_addr;
	logic							[`ICP_NUM-1:0]		wrb;
	logic							[`ADDR_B-1:0]		rdb_addr;
} PE_IN_PACKET;

`endif // __SYS_DEFS_VH__