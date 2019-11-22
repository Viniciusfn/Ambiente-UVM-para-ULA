class env extends uvm_env;
    `uvm_component_utils(env)

    agent_in    mst;
    agent_out   slv;
    scoreboard  sb;
    coverage    cov;
    datapath_coverage_in dpc_i;
    datapath_coverage_out dpc_o;

    extern function new(string name, uvm_component parent = null);
    extern  function void build_phase(uvm_phase phase);
    extern  function void connect_phase(uvm_phase phase);

endclass

///////////////FUNCTIONS BODIES///////////////////////////

function env::new(string name, uvm_component parent = null);
    super.new(name, parent); 
endfunction

function void env::build_phase(uvm_phase phase);
    super.build_phase(phase);
    mst = agent_in::type_id::create("mst", this);
    slv = agent_out::type_id::create("slv", this);
    sb  = scoreboard::type_id::create("sb", this);
    cov = coverage::type_id::create("cov",this);
    dpc_i = datapath_coverage_in::type_id::create("dpc_i", this);
    dpc_o = datapath_coverage_out::type_id::create("dpc_o", this);
endfunction

 function void env::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    mst.item_collected_port.connect(sb.ap_rfm);
    mst.item_collected_port.connect(dpc_i.covi);
    slv.agt_resp_port.connect(sb.ap_comp);
    slv.agt_resp_port.connect(dpc_o.covo);
    mst.item_collected_port.connect(cov.req_port);
    slv.agt_resp_port.connect(cov.resp_port);


endfunction
