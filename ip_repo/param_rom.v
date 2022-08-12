// *********************************************************************************
// Project Name : OSXXXX
// Author       : dengkanwen
// Email        : dengkanwen@163.com
// Website      : http://www.opensoc.cn/
// Create Time  : 2021-08-09 20:44:14
// File Name    : .v
// Module Name  : 
// Called By    :
// Abstract     :
//
// CopyRight(c) 2018, OpenSoc Studio.. 
// All Rights Reserved
//
// *********************************************************************************
// Modification History:
// Date         By              Version                 Change Description
// -----------------------------------------------------------------------
// 2021-08-09    Kevin           1.0                     Original
//  
// *********************************************************************************
`timescale      1ns/1ns

module  param_rom(
        // system signals
        input                   sclk                    ,       
        input                   s_rst_n                 ,       
        // 
        input           [ 7:0]  param_rd_addr           ,
        input           [ 4:0]  conv_cnt                ,
        output  wire    [15:0]  param_w_h0              ,
        output  wire    [15:0]  param_w_h1              ,
        output  wire    [15:0]  param_w_h2              ,
        output  wire    [15:0]  param_w_h3              ,
        output  wire    [15:0]  param_w_h4              ,
        output  wire    [15:0]  param_bias              
);

//========================================================================\
// =========== Define Parameter and Internal signals =========== 
//========================================================================/



//=============================================================================
//**************    Main Code   **************
//=============================================================================
rom_b_ip        rom_b_ip_inst (
        .clka                   (sclk                   ),    // input wire clka
        .addra                  (conv_cnt               ),  // input wire [4 : 0] addra
        .douta                  (param_bias             )// output wire [15 : 0] douta
);

rom_w0_ip       rom_w0_ip_inst (
        .clka                   (sclk                   ),    // input wire clka
        .addra                  (param_rd_addr          ),  // input wire [7 : 0] addra
        .douta                  (param_w_h0             )// output wire [15 : 0] douta
);

rom_w1_ip       rom_w1_ip_inst (
        .clka                   (sclk                   ),    // input wire clka
        .addra                  (param_rd_addr          ),  // input wire [7 : 0] addra
        .douta                  (param_w_h1             )// output wire [15 : 0] douta
);

rom_w2_ip       rom_w2_ip_inst (
        .clka                   (sclk                   ),    // input wire clka
        .addra                  (param_rd_addr          ),  // input wire [7 : 0] addra
        .douta                  (param_w_h2             )// output wire [15 : 0] douta
);

rom_w3_ip       rom_w3_ip_inst (
        .clka                   (sclk                   ),    // input wire clka
        .addra                  (param_rd_addr          ),  // input wire [7 : 0] addra
        .douta                  (param_w_h3             )// output wire [15 : 0] douta
);

rom_w4_ip       rom_w4_ip_inst (
        .clka                   (sclk                   ),    // input wire clka
        .addra                  (param_rd_addr          ),  // input wire [7 : 0] addra
        .douta                  (param_w_h4             )// output wire [15 : 0] douta
);


endmodule
