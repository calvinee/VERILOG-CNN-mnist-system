module  downsample(
        // system signals
        input                   sclk                    ,       
        input                   s_rst_n                 ,       
        //
        input                   bin_data                ,       
        input                   bin_data_vld            ,       
        //
        output  reg             down_data               ,       
        output  reg             down_data_vld                  
);

//========================================================================\
// =========== Define Parameter and Internal signals =========== 
//========================================================================/
localparam      CNT_END         =       'd112                   ; 


reg     [ 6:0]                  col_cnt                         ;       
reg     [ 6:0]                  row_cnt                         ;       


//=============================================================================
//**************    Main Code   **************
//=============================================================================

always  @(posedge sclk or negedge s_rst_n) begin
        if(s_rst_n == 1'b0)
                col_cnt <=      'd0;
        else if(col_cnt == (CNT_END-1) && bin_data_vld == 1'b1)
                col_cnt <=      'd0;
        else if(bin_data_vld == 1'b1)
                col_cnt <=      col_cnt + 1'b1;
end

always  @(posedge sclk or negedge s_rst_n) begin
        if(s_rst_n == 1'b0)
                row_cnt <=      'd0;
        else if(row_cnt == (CNT_END-1) && col_cnt == (CNT_END-1) && bin_data_vld == 1'b1)
                row_cnt <=      'd0;
        else if(col_cnt == (CNT_END-1) && bin_data_vld == 1'b1)
                row_cnt <=      row_cnt + 1'b1;
end

always  @(posedge sclk or negedge s_rst_n) begin
        if(s_rst_n == 1'b0)
                down_data       <=      1'b0;
        else if(row_cnt[1:0] == 'd0 && col_cnt[1:0] == 'd0 && bin_data_vld == 1'b1)
                down_data       <=      bin_data;
        else
                down_data       <=      1'b0;
end

always  @(posedge sclk or negedge s_rst_n) begin
        if(s_rst_n == 1'b0)
                down_data_vld   <=      1'b0;
        else if(row_cnt[1:0] == 'd0 && col_cnt[1:0] == 'd0 && bin_data_vld == 1'b1)
                down_data_vld   <=      1'b1;
        else
                down_data_vld   <=      1'b0;
end


endmodule
