typedef struct packed{
    logic ACLK;
    logic ARESETn;
    logic AWAKEUP;
} AXI5_Lite_Global_t;

typedef struct packed{
    logic AWVALID;
    logic AWREADY;
    logic AWADDR;
    logic AWPROTa;
    logic AWID;
    logic AWIDUNQ;
    logic AWSIZE;
    logic AWUSER;
    logic AWTRACE;
} AXI5_Lite_Write_Address_t;

typedef struct packed {
    logic WVALID;
    logic WREADY;
    logic WDATA;
    logic WSTRB;
    logic WUSER;
    logic WTRACE;
    logic WPOISON;
} AXI5_Lite_Write_Data_t;

interface AXI5_Lite();

	// AXI5_Lite_Global_t global;
    // AXI5_Lite_Write_Address_t wa;
    // AXI5_Lite_Write_Data_t wd;

    //GLOBAL
    logic ACLK;
    logic ARESETn;
    logic AWAKEUP;

    //WRITE ADDRESS
    logic AWVALID;
    logic AWREADY;
    logic AWADDR;
    logic AWPROTa;
    logic AWID;
    logic AWIDUNQ;
    logic AWSIZE;
    logic AWUSER;
    logic AWTRACE;

    //WRITE DATA
    logic WVALID;
    logic WREADY;
    logic WDATA;
    logic WSTRB;
    logic WUSER;
    logic WTRACE;
    logic WPOISON;

	modport Device(
		input global;
	);

	modport Controller(
		input global;
	);

    modport RCC(
        output global;
    )
    
endinterface //AXI5_Lite
