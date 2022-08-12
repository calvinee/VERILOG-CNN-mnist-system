// *********************************************************************************
// Project Name : OSXXXX
// Author       : dengkanwen
// Email        : dengkanwen@163.com
// Website      : http://www.opensoc.cn/
// Create Time  : 2021-05-09 09:54:24
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
// 2021-05-09    Kevin           1.0                     Original
//  
// *********************************************************************************
`timescale      1ns/1ns

module  cmos_data(
        //
        input                   s_rst_n                 ,       
        // IIC 
        input                   scl                     ,       
        input                   sda                     ,       
        // Camera
        input                   camera_pclk             ,       
        output  wire            camera_exp              ,
        output  wire            camera_stby             ,       
        input                   camera_led              ,       
        input           [ 7:0]  camera_data             ,
        input                   camera_vs               ,       
        input                   camera_hs               ,       
        //
        input           [ 7:0]  bin_theta               ,       
        // Video in Core
        output  wire            vid_active_video        ,       
        output  wire            vid_hs                  ,       
        output  wire            vid_vs                  ,       
        output  wire    [ 7:0]  vid_data                ,
        //
        output  wire            bin_data                ,
        output  wire            bin_data_vld            
);

//========================================================================\
// =========== Define Parameter and Internal signals =========== 
//========================================================================/
reg     [ 9:0]                  row_cnt                         ;
reg     [ 9:0]                  col_cnt                         ;




//=============================================================================
//**************    Main Code   **************
//=============================================================================
assign  camera_exp      =       1'b0;
assign  camera_stby     =       1'b0;
assign  vid_active_video=       camera_hs;
assign  vid_hs          =       ~camera_hs;
assign  vid_vs          =       ~camera_vs;
assign  vid_data        =       (col_cnt >= 'd320 && col_cnt < 'd432 && row_cnt >= 'd184 && row_cnt < 'd296) ? 
                                ((camera_data < bin_theta) ?  8'hff : 8'h0) : camera_data;

assign  bin_data        =       vid_data;
assign  bin_data_vld    =       (col_cnt >= 'd320 && col_cnt < 'd432 && row_cnt >= 'd184 && row_cnt < 'd296) ? 1'b1 : 1'b0;

always  @(posedge camera_pclk or negedge s_rst_n) begin
        if(s_rst_n == 1'b0)
                col_cnt <=      'd0;
        else if(camera_hs == 1'b1)
                col_cnt <=      col_cnt + 1'b1;
        else 
                col_cnt <=      'd0;
end

always  @(posedge camera_pclk or negedge s_rst_n) begin
        if(s_rst_n == 1'b0)
                row_cnt <=      'd0;
        else if(vid_vs == 1'b1)
                row_cnt <=      'd0;
        else if(camera_hs == 1'b1 && col_cnt == 'd751)
                row_cnt <=      row_cnt + 1'b1;
end


endmodule
