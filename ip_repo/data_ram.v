module  data_ram(
        // system singals
        input                   sclk                    ,       
        input                   s_rst_n                 ,       
        // downsample
        input                   down_data               ,       
        input                   down_data_vld           ,       
        input           [ 6:0]  down_col_cnt            ,
        input           [ 6:0]  down_row_cnt            ,
        // Conv Cal
        input           [ 4:0]  data_rd_addr            ,
        input           [ 4:0]  conv_row_cnt            ,
        output  reg     [ 4:0]  col_data                ,
        output  reg             cal_start                      
);

//========================================================================\
// =========== Define Parameter and Internal signals =========== 
//========================================================================/

wire    [ 4:0]                  wr_addr                         ;       

reg     [27:0]                  wr_en                           ;       
wire    [27:0]                  rd_data                         ;

//=============================================================================
//**************    Main Code   **************
//=============================================================================
assign  wr_addr =       down_col_cnt[6:2];


integer i;
always  @(*) begin
        for(i=0; i<=27; i=i+1) begin
                if(down_row_cnt == i)
                        wr_en[i]        =       down_data_vld;
                else
                        wr_en[i]        =       1'b0;
        end
end

always  @(*) begin
        case(conv_row_cnt)
                0:      col_data        =       rd_data[4:0];
                1:      col_data        =       rd_data[5:1];
                2:      col_data        =       rd_data[6:2];
                3:      col_data        =       rd_data[7:3];
                4:      col_data        =       rd_data[8:4];
                5:      col_data        =       rd_data[9:5];
                6:      col_data        =       rd_data[10:6];
                7:      col_data        =       rd_data[11:7];
                8:      col_data        =       rd_data[12:8];
                9:      col_data        =       rd_data[13:9];
                10:     col_data        =       rd_data[14:10];
                11:     col_data        =       rd_data[15:11];
                12:     col_data        =       rd_data[16:12];
                13:     col_data        =       rd_data[17:13];
                14:     col_data        =       rd_data[18:14];
                15:     col_data        =       rd_data[19:15];
                16:     col_data        =       rd_data[20:16];
                17:     col_data        =       rd_data[21:17];
                18:     col_data        =       rd_data[22:18];
                19:     col_data        =       rd_data[23:19];
                20:     col_data        =       rd_data[24:20];
                21:     col_data        =       rd_data[25:21];
                22:     col_data        =       rd_data[26:22];
                23:     col_data        =       rd_data[27:23];
                default:col_data        =       'd0;
        endcase
end

always  @(posedge sclk or negedge s_rst_n) begin
        if(s_rst_n == 1'b0)
                cal_start       <=      1'b0;
        else if(down_data_vld == 1'b1 && down_col_cnt[6:2] == 'd27 && down_row_cnt[6:2] == 'd27)
                cal_start       <=      1'b1;
        else
                cal_start       <=      1'b0;
end


data_ram_ip     data_ram_ip_inst[27:0] (
        .clka                   (sclk                   ),    // input wire clka
        .wea                    (wr_en[27:0]            ),      // input wire [0 : 0] wea
        .addra                  (wr_addr                ),  // input wire [4 : 0] addra
        .dina                   (down_data              ),    // input wire [0 : 0] dina
        .clkb                   (sclk                   ),    // input wire clkb
        .enb                    (1'b1                   ),      // input wire enb
        .addrb                  (data_rd_addr           ),  // input wire [4 : 0] addrb
        .doutb                  (rd_data[27:0]          )// output wire [0 : 0] doutb
);


endmodule
