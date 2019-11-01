class env extends uvm_env;
    `uvm_component_utils(env)

    agent_in    mst;
    agent_out   slv;
    scoreboard  sb;
    coverage    cov;

    extern function new(string name, uvm_component parent = null);
    extern virtual function void build_phase(uvm_phase phase);
    extern virtual function void connect_phase(uvm_phase phase);

endclass

///////////////FUNCTIONS BODIES///////////////////////////

extern function new(string name, uvm_component parent = null);
    super.new(name, parent); 
endfunction

extern virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    mst = agent_in::type_id::create("mst", this);
    slv = agent_out::type_id::create("slv", this);
    sb  = scoreboard::type_id::create("sb", this);
    cov = coverage::type_id::create("cov",this);
endfunction

extern virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    mst.xxx_port.connect(scoreboard.ap_rfm);
    slv.agt_resp_port.connect(scoreboard.ap_comp);
    mst.xxx_port.connect(cov.req_port);
    slv.agt_resp_port.connect(cov.resp_port);
endfunction