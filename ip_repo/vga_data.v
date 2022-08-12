module  vga_data(
        // system signals
        input                   sclk                    ,       
        input                   s_rst_n                 ,       
        // VGA 
        input                   vga_vsync               ,       
        input                   vga_hsync               ,       
        input                   active_video            ,       
        // ROM
        input           [ 3:0]  rom_sel                 ,
        output  reg     [13:0]  rd_addr                 ,       
        input                   rom0_data               ,       // Zero
        input                   rom1_data               ,       // Zero
        input                   rom2_data               ,       // Zero
        input                   rom3_data               ,       // Zero
        input                   rom4_data               ,       // Zero
        input                   rom5_data               ,       // Zero
        input                   rom6_data               ,       // Zero
        input                   rom7_data               ,       // Zero
        input                   rom8_data               ,       // Zero
        input                   rom9_data               ,       // Zero
        // 
        input           [ 7:0]  rgb_data_i              ,    // VDMA   
        output  reg     [15:0]  rgb_data_o                      
);

//========================================================================\
// =========== Define Parameter and Internal signals =========== 
//========================================================================/
reg     [ 9:0]                  row_cnt                         ;
reg     [ 9:0]                  col_cnt                         ;       

reg     [ 3:0]                  rom_sel_r1                      ;
reg     [ 3:0]                  rom_sel_r2                      ;

//=============================================================================
//**************    Main Code   **************
//=============================================================================
always  @(posedge sclk) begin
        rom_sel_r1      <=      rom_sel;
        rom_sel_r2      <=      rom_sel_r1;
end

always  @(posedge sclk or negedge s_rst_n) begin
        if(s_rst_n == 1'b0)
                col_cnt <=      'd0;
        else if(vga_hsync == 1'b1)
                col_cnt <=      'd0;
        else if(active_video == 1'b1)
                col_cnt <=      col_cnt + 1'b1;
end

always  @(posedge sclk or negedge s_rst_n) begin
        if(s_rst_n == 1'b0)
                row_cnt <=      'd0;
        else if(vga_vsync == 1'b1)
                row_cnt <=      'd0;
        else if(col_cnt == 'd751 && active_video == 1'b1)
                row_cnt <=      row_cnt + 1'b1;
end


// TOP： ROW[184,296 ]， COL :[320, 432]
always  @(posedge sclk or negedge s_rst_n) begin
        if(s_rst_n == 1'b0)
                rgb_data_o      <=      16'h0;
        else if(row_cnt == 'd184 && col_cnt < 'd432 && col_cnt >= 'd320)   // TOP 
                rgb_data_o      <=      16'h0;
        else if(row_cnt >= 'd184 && row_cnt < 'd296 && col_cnt == 'd320)   // LEFT
                rgb_data_o      <=      16'h0;
        else if(row_cnt == 'd295 && col_cnt < 'd432 && col_cnt >= 'd320)   // BOTTOM 
                rgb_data_o      <=      16'h0;
        else if(row_cnt >= 'd184 && row_cnt < 'd296 && col_cnt == 'd431)   // LEFT
                rgb_data_o      <=      16'h0;
        else if(col_cnt >= 'd651 && col_cnt <= 'd750 && row_cnt <= 'd99)
                case(rom_sel_r2)
                        0:      rgb_data_o      <=      {16{rom0_data}};        // {n{data}}
                        1:      rgb_data_o      <=      {16{rom1_data}};        // {n{data}}
                        2:      rgb_data_o      <=      {16{rom2_data}};        // {n{data}}
                        3:      rgb_data_o      <=      {16{rom3_data}};        // {n{data}}
                        4:      rgb_data_o      <=      {16{rom4_data}};        // {n{data}}
                        5:      rgb_data_o      <=      {16{rom5_data}};        // {n{data}}
                        6:      rgb_data_o      <=      {16{rom6_data}};        // {n{data}}
                        7:      rgb_data_o      <=      {16{rom7_data}};        // {n{data}}
                        8:      rgb_data_o      <=      {16{rom8_data}};        // {n{data}}
                        9:      rgb_data_o      <=      {16{rom9_data}};        // {n{data}}
                        default:rgb_data_o      <=      16'hffff;
                endcase
        else if(active_video == 1'b1)
                rgb_data_o      <=      {rgb_data_i[7:3], rgb_data_i[7:2], rgb_data_i[7:3]};
        else
                rgb_data_o      <=      16'h0;
end

always  @(posedge sclk or negedge s_rst_n) begin
        if(s_rst_n == 1'b0)
                rd_addr <=      'd0;
        else if(vga_vsync == 1'b1)
                rd_addr <=      'd0;
        else if(col_cnt >= 'd650 && col_cnt <= 'd749 && row_cnt <= 'd99)
                rd_addr <=      rd_addr + 1'b1;
end



// assign  rgb_data_o      =       (active_video == 1'b1) ? {rgb_data_i[7:3], rgb_data_i[7:2], rgb_data_i[7:3]} : 16'h0;

endmodule
