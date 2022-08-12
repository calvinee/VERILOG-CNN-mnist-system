#include <stdio.h>
#include "xil_io.h"
#include "xparameters.h"
#include "xil_types.h"
#include "xil_cache.h"
#include "sleep.h"
#include "xil_types.h"
#include "param_init.h"


#define VDMA_BASEADDR   	XPAR_AXI_VDMA_0_BASEADDR
#define VDMA_FRAME0     	0x01000000
#define	AXI_LITE_BASEADDR	0x43C00000

#define STRIDE          752
#define HSIZE           752
#define VSIZE           480


int main()
{
    // VDMA写通道配置
    Xil_Out32(VDMA_BASEADDR+0x30,   0x1);
    Xil_Out32(VDMA_BASEADDR+0xAC,   VDMA_FRAME0);
    Xil_Out32(VDMA_BASEADDR+0xA8,   STRIDE);
    Xil_Out32(VDMA_BASEADDR+0xA4,   HSIZE);
    Xil_Out32(VDMA_BASEADDR+0xA0,   VSIZE);
	// VDMA读通道配置
    Xil_Out32(VDMA_BASEADDR,        0x1);
    Xil_Out32(VDMA_BASEADDR+0x5c,   VDMA_FRAME0);
    Xil_Out32(VDMA_BASEADDR+0x58,   STRIDE);
    Xil_Out32(VDMA_BASEADDR+0x54,   HSIZE);
    Xil_Out32(VDMA_BASEADDR+0x50,   VSIZE);

    float *cnn_param_w = 0x2000000;
	float *cnn_param_b = 0x2000C00;

	u8 img_data[784];
//	u8 img_data[784] = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,61,3,42,118,193,118,118,61,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,14,179,245,236,242,254,254,254,254,245,235,84,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,151,254,254,254,213,192,178,178,180,254,254,241,46,0,0,0,0,0,0,0,0,0,0,0,0,0,0,43,235,254,226,64,28,12,0,0,2,128,252,255,173,17,0,0,0,0,0,0,0,0,0,0,0,0,0,56,254,253,107,0,0,0,0,0,0,0,134,250,254,75,0,0,0,0,0,0,0,0,0,0,0,0,0,63,254,158,0,0,0,0,0,0,0,0,0,221,254,157,0,0,0,0,0,0,0,0,0,0,0,0,0,194,254,103,0,0,0,0,0,0,0,0,0,150,254,213,0,0,0,0,0,0,0,0,0,0,0,0,34,220,239,58,0,0,0,0,0,0,0,0,0,84,254,213,0,0,0,0,0,0,0,0,0,0,0,0,126,254,171,0,0,0,0,0,0,0,0,0,0,84,254,213,0,0,0,0,0,0,0,0,0,0,0,0,214,239,60,0,0,0,0,0,0,0,0,0,0,84,254,213,0,0,0,0,0,0,0,0,0,0,0,0,214,199,0,0,0,0,0,0,0,0,0,0,0,84,254,213,0,0,0,0,0,0,0,0,0,0,0,11,219,199,0,0,0,0,0,0,0,0,0,0,0,84,254,213,0,0,0,0,0,0,0,0,0,0,0,98,254,199,0,0,0,0,0,0,0,0,0,0,0,162,254,209,0,0,0,0,0,0,0,0,0,0,0,98,254,199,0,0,0,0,0,0,0,0,0,0,51,238,254,75,0,0,0,0,0,0,0,0,0,0,0,98,254,199,0,0,0,0,0,0,0,0,0,51,165,254,195,4,0,0,0,0,0,0,0,0,0,0,0,66,241,199,0,0,0,0,0,0,0,0,3,167,254,227,55,0,0,0,0,0,0,0,0,0,0,0,0,0,214,213,20,0,0,0,0,0,46,152,202,254,254,63,0,0,0,0,0,0,0,0,0,0,0,0,0,0,214,254,204,180,180,180,180,180,235,254,254,234,156,10,0,0,0,0,0,0,0,0,0,0,0,0,0,0,81,205,254,254,254,254,254,254,254,252,234,120,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,26,210,254,254,254,254,254,153,104,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};

	u8 *cmos_data = VDMA_FRAME0;
    
    conv_param_init();
    float *conv_rlst = 0x2000D00;
    float conv_temp;
    
    float pool_temp = 0;
    float *pool_rslt = 0x2020000;
    
    float *affine1_w = 0x2025000;
    float *affine1_b = 0x21CB000;
    affine1_param_init();
    float *affine1_rslt = 0x21CC000;
    float affine1_temp;
    // 输出层参数地址
    float *affine2_w = 0x21CC200;
    float *affine2_b = 0x21CD200;
    float affine2_temp;
    affine2_param_init();
    float affine2_rslt[10];
    
    // 比较输出层的最大值
    float temp = -100;
    int predict_num;
    int index;
    while(1)
    {
        // 获取摄像头图像
    	index = 0;
        for(int row=0; row<VSIZE; row++)
        {
            for(int col=0; col<HSIZE; col++)
            {
                if(col>=320 && col<432 && row>=184 && row<296)
                {
                	if(col%4 == 0 && row%4 == 0)
                	{
                		img_data[index] = cmos_data[row*752+col];
                		index++;
                	}
                }
            }
        }
        ///////////////////////////////////////////////
        // 卷积层计算
        ///////////////////////////////////////////////
        for(int n=0; n<30; n++)
        {
            for(int row=0; row<=23; row++)
            {
                for(int col=0; col<=23; col++)
                {
                    conv_temp = 0;
                    for(int x=0; x<5; x++)
                    {
                        for(int y=0; y<5; y++)
                        {
                            conv_temp += img_data[row*28+col+x*28+y] * cnn_param_w[x*5+y+n*25];
                        }
                    }
                    conv_temp += cnn_param_b[n];

                    // 激活函数
                    if(conv_temp > 0)
                        conv_rlst[row*24+col+n*24*24] = conv_temp;
                    else
                        conv_rlst[row*24+col+n*24*24] = 0;
                }
            }
        }
        ///////////////////////////////////////////////
        // 池化层计算
        ///////////////////////////////////////////////
    //    池化层实现
        for(int n=0; n<30; n++)
        {
            for(int row=0; row<24; row=row+2)
            {
                for(int col=0; col<24; col=col+2)
                {
                    pool_temp = 0;
                    for(int x=0; x<2; x++)
                    {
                        for(int y=0; y<2; y++)
                        {
                            if(pool_temp <= conv_rlst[row*24+col+x*24+y+n*576])
                                pool_temp = conv_rlst[row*24+col+x*24+y+n*576];
                        }
                    }
                    pool_rslt[(row/2)*12+col/2+n*144] = pool_temp;
                }
            }
        }
        ///////////////////////////////////////////////
        // 隐藏层计算
        ///////////////////////////////////////////////
        // 隐藏层参数地址
        for(int n=0; n<100; n++)
        {
            affine1_temp = 0;
            for(int i=0; i<4320; i++)
            {
                affine1_temp = affine1_temp + pool_rslt[i] * affine1_w[i+4320*n];
            }
            affine1_temp = affine1_temp + affine1_b[n];
            // 激活函数
            if(affine1_temp > 0)
                affine1_rslt[n] = affine1_temp;
            else
                affine1_rslt[n]	= 0;
        }
        ///////////////////////////////////////////////
        // 输出层计算
        ///////////////////////////////////////////////
        temp = -100;
        for(int n=0; n<10; n++)
        {
            affine2_temp = 0;
            for(int i=0; i<100;i++)
            {
                affine2_temp = affine2_temp + affine2_w[i+100*n] * affine1_rslt[i];
            }
            affine2_rslt[n] = affine2_temp;

            if(temp <= affine2_rslt[n])
            {
                temp = affine2_rslt[n];
                predict_num = n;
            }
        }
        Xil_Out32(AXI_LITE_BASEADDR, predict_num);
    }
    return 0;
}
