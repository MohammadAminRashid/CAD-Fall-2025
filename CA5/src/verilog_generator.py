import re

class VerilogGenerator:
    def __init__(self, folder_path, schedule_info, config):
        self.folder_path=folder_path
        self.schedule_info=schedule_info
        self.res_count=config['Resources'].items()
        self.inputs=set()
        self.max_time=0
        self._calculate_max_time()
        self.mux_connections ={} 
        self._analyze_graph()
        
    def _calculate_max_time(self):
        for info in self.schedule_info:

            if(info.scheduled_time > self.max_time):
                self.max_time = info.scheduled_time
            

    def _get_op_code(self, node):
        op = node.op_symbol

        if (op=='+'):
             return "1'b0"
        if (op=='-'):
             return "1'b1"
        if (op=='*'):
             return "1'b0"
        if (op=='/'):
             return "1'b1"
        if (op=='&'):
             return "1'b0"
        if (op=='|'):
             return "1'b1"
         
        return "0"
    
    def _get_source_name(self, operand):
        if hasattr(operand, 'name'):
            name = str(operand.name)
            if name.startswith('i'):
                self.inputs.add(name)
                return name
            return name
        
        if isinstance(operand, str):
            if operand.startswith('i'):
                self.inputs.add(operand)
                return operand
            return operand

        if hasattr(operand, 'id'):
            return f"reg_{operand.id}"

        s = str(operand)
        if 'i' in s and any(char.isdigit() for char in s):
            match = re.search(r'i\d+', s)
            if match:
                clean_name = match.group()
                self.inputs.add(clean_name)
                return clean_name
        
        return f"reg_{s}"

    def _analyze_graph(self):
 
        for node_info in self.schedule_info:
            
            res_type = node_info.node.op_type.lower()
            res_num = node_info.resource_num 
            operands = node_info.node.operands   
                      
            src1 = self._get_source_name(operands[0])
            src2 = self._get_source_name(operands[1])
            key1 = (res_type, res_num, 1)
            key2 = (res_type, res_num, 2)
            
            
            if (key1 not in self.mux_connections): 
                self.mux_connections[key1] = []
                
            if (src1 not in self.mux_connections[key1]):
                self.mux_connections[key1].append(src1)
                
            if (key2 not in self.mux_connections):
                self.mux_connections[key2] = []
                
            if (src2 not in self.mux_connections[key2]):
                self.mux_connections[key2].append(src2)
            
            print(node_info.node)
            print(node_info.node.id)
            print(src1)
            print(src2)
            
            
        print(f"Analysis Complete. Inputs found: {self.inputs}")


    def generate_controller(self):
        lines=[]
        lines.append("module controller(")
        lines.append("  input clk, rst, start,")
        lines.append("  output reg op_ready,")
        
        for res,count in self.res_count:
            res_lower = res.lower()
            for i in range(1, count+1):
                lines.append(f"  output reg [3:0] {res_lower}{i}_sel1, {res_lower}{i}_sel2,")
                lines.append(f"  output reg {res_lower}{i}_op,")
        
        lines.append("  output reg done, result_en,")
        
        sorted_nodes = sorted(self.schedule_info, key=lambda x: str(x.node.id))
        reg_ens = [f"reg_{info.node.id}_en" for info in sorted_nodes]
        lines.append(f"  output reg {', '.join(reg_ens)} );")
       
        
        lines.append(f"\nreg [3:0] state, next_state;")
        lines.append(f"localparam S_IDLE = 0, S_DONE = {self.max_time+1};")
        for t in range(1,self.max_time+1):
            lines.append(f"localparam S_CYCLE_{t} = {t};")
            
        lines.append("\nalways @(posedge clk or posedge rst) begin")
        lines.append("  if (rst) state <= S_IDLE;")
        lines.append("  else state <= next_state;")
        lines.append("end")
        
        
        
        lines.append("\nalways @(*) begin")
        lines.append("  op_ready = 0; next_state = state; result_en = 0; done = 0;")
        
        for res, count in self.res_count:
            res_lower = res.lower()
            for i in range(1, count+1):
                lines.append(f"  {res_lower}{i}_sel1 = 0; {res_lower}{i}_sel2 = 0; {res_lower}{i}_op = 0;")
        for info in self.schedule_info:
            lines.append(f"  reg_{info.node.id}_en = 0;")
            
        lines.append("\n  case (state)")
        lines.append("    S_IDLE: begin")
        lines.append("      op_ready = 1'b1;")
        lines.append("      if (start) next_state = S_CYCLE_1;")
        lines.append("    end")
        
        last_node_id = self.schedule_info[-1].node.id 

        for t in range(1, self.max_time+1):
            lines.append(f"    S_CYCLE_{t}: begin")
            
            nodes_at_t=[]
            for n in self.schedule_info:
                if (n.scheduled_time==t):
                    nodes_at_t.append(n)
                   
            for info in nodes_at_t:
                res_type = info.node.op_type.lower()
                res_num = info.resource_num
                
                lines.append(f"      {res_type}{res_num}_op = {self._get_op_code(info.node)};")
                
                x, y =info.node.operands
                
                src1 =self._get_source_name(x)
                src2 =self._get_source_name(y)
                
                sel1_idx = self.mux_connections[(res_type, res_num, 1)].index(src1)
                sel2_idx = self.mux_connections[(res_type, res_num, 2)].index(src2)
             
                
                lines.append(f"      {res_type}{res_num}_sel1 = {sel1_idx};")
                lines.append(f"      {res_type}{res_num}_sel2 = {sel2_idx};")
                lines.append(f"      reg_{info.node.id}_en = 1'b1;")
                
                if (info.node.id==last_node_id):
                     lines.append(f"      result_en = 1'b1;")

            if (t<self.max_time):
                lines.append(f"      next_state = S_CYCLE_{t+1};")
            else:
                lines.append(f"      next_state = S_DONE;")
                
            lines.append("    end")

        lines.append("    S_DONE: begin")
        lines.append("      done = 1'b1;")
        lines.append("      next_state = S_IDLE;")
        lines.append("    end")
        lines.append("  endcase")
        lines.append("end")
        lines.append("endmodule")
        return "\n".join(lines)

    def generate_datapath(self):
        lines = []
        lines.append("module datapath(")
        lines.append("  input clk, rst,")
        sorted_nodes = sorted(self.schedule_info, key=lambda x: str(x.node.id))
        for inp in self.inputs:
            lines.append(f"  input [31:0] {inp},")
            
        for res,count in self.res_count:
            res_lower = res.lower()
            for i in range(1,count+1):
                
                lines.append(f"  input [3:0] {res_lower}{i}_sel1, {res_lower}{i}_sel2,")
                lines.append(f"  input {res_lower}{i}_op,")
        
        lines.append("  input result_en,")
 
        for info in sorted_nodes:
            lines.append(f"  input reg_{info.node.id}_en,")
            
            
        lines.append("  output reg [31:0] result);")

        
        for info in sorted_nodes:
            lines.append(f"reg [31:0] reg_{info.node.id};")
            
        lines.append("\n")
        for res, count in self.res_count:
            res_lower = res.lower()
            for i in range(1,count+1):
                lines.append(f"wire [31:0] {res_lower}{i}_out;")
                lines.append(f"reg [31:0] {res_lower}{i}_in1, {res_lower}{i}_in2;")

        sorted_mux_keys = sorted(self.mux_connections.keys())
        for key in sorted_mux_keys:
            res_type,res_num, input_num=key
            sources = self.mux_connections[key]
            
            lines.append("always @(*) begin")
            lines.append(f"  case ({res_type}{res_num}_sel{input_num})")
            
            
            for index,src in enumerate(sources):
                lines.append(f"    4'd{index}: {res_type}{res_num}_in{input_num} = {src};")
                
                
            lines.append(f"    default: {res_type}{res_num}_in{input_num} = 0;")
            lines.append("  endcase")
            lines.append("end")
            
        lines.append("\n")
        for res, count in self.res_count:
            res_lower = res.lower()
            for i in range(1, count+1):
                lines.append(f"// {res} Unit {i}")
                if res_lower == "alu":
                    lines.append(f"assign {res_lower}{i}_out = ({res_lower}{i}_op == 1'b0) ? ({res_lower}{i}_in1 + {res_lower}{i}_in2) : ({res_lower}{i}_in1 - {res_lower}{i}_in2);")
                elif res_lower == "mul":
                    lines.append(f"assign {res_lower}{i}_out = ({res_lower}{i}_op == 1'b0) ? ({res_lower}{i}_in1 * {res_lower}{i}_in2) : ({res_lower}{i}_in1 / {res_lower}{i}_in2);")
                elif res_lower == "log":
                    lines.append(f"assign {res_lower}{i}_out = ({res_lower}{i}_op == 1'b0) ? ({res_lower}{i}_in1 & {res_lower}{i}_in2) : ({res_lower}{i}_in1 | {res_lower}{i}_in2);")

        lines.append("\n")
        lines.append("always @(posedge clk or posedge rst) begin")
        lines.append("  if (rst) begin")
        lines.append("        result <= 0;")
        
        for info in sorted_nodes:
            lines.append(f"    reg_{info.node.id} <= 0;")
            
        lines.append("  end else begin")
        
        for info in sorted_nodes:
            res_type = info.node.op_type.lower()
            res_num = info.resource_num
            lines.append(f"    if (reg_{info.node.id}_en) reg_{info.node.id} <= {res_type}{res_num}_out;")
            
        last_info = self.schedule_info[-1]
        last_res_type =last_info.node.op_type.lower()
        last_res_num = last_info.resource_num
        lines.append(f"    if (result_en) result <= {last_res_type}{last_res_num}_out;")
        
        lines.append("  end")
        lines.append("end")
        
        lines.append("endmodule")
        return "\n".join(lines)


    def generate_top(self):
        lines = []
        lines.append(f"module Top(")
        lines.append("  input clk,")
        lines.append("  input rst,")
        lines.append("  input start,")

        for inp in sorted(self.inputs):
            lines.append(f"  input [31:0] {inp},")
        
        lines.append("  output [31:0] result,")
        lines.append("  output done")
        lines.append(");")
        lines.append("")



        lines.append("  wire op_ready;")
        for res,count in self.res_count:
            res_lower = res.lower()
            for i in range(1, count+1):
                lines.append(f"  wire [3:0] {res_lower}{i}_sel1, {res_lower}{i}_sel2;")
                lines.append(f"  wire {res_lower}{i}_op;")
        
        sorted_nodes = sorted(self.schedule_info, key=lambda x: str(x.node.id))
        for info in sorted_nodes:
            lines.append(f"  wire reg_{info.node.id}_en;")
        
        lines.append("  wire result_en;")
        lines.append("")


        lines.append("  controller ctrl_inst(")
        lines.append("    .clk(clk),")
        lines.append("    .rst(rst),")
        lines.append("    .start(start),")
        lines.append("    .op_ready(op_ready),")
        for res, count in self.res_count:
            res_lower = res.lower()
            for i in range(1, count+1):
                lines.append(f"    .{res_lower}{i}_sel1({res_lower}{i}_sel1), .{res_lower}{i}_sel2({res_lower}{i}_sel2), .{res_lower}{i}_op({res_lower}{i}_op),")
        
        lines.append("    .done(done),")
        lines.append("    .result_en(result_en),")
        for info in sorted_nodes:
            lines.append(f"    .reg_{info.node.id}_en(reg_{info.node.id}_en),")
        
        lines[-1] = lines[-1].rstrip(',')
        lines.append("  );\n")

        lines.append("  datapath dp_inst(")
        lines.append("    .clk(clk),")
        lines.append("    .rst(rst),")
        for inp in sorted(self.inputs):
            lines.append(f"    .{inp}({inp}),")
        
        for res, count in self.res_count:
            res_lower = res.lower()
            for i in range(1, count+1):
                lines.append(f"    .{res_lower}{i}_sel1({res_lower}{i}_sel1), .{res_lower}{i}_sel2({res_lower}{i}_sel2), .{res_lower}{i}_op({res_lower}{i}_op),")
        
        lines.append("    .result_en(result_en),")
        for info in sorted_nodes:
            lines.append(f"    .reg_{info.node.id}_en(reg_{info.node.id}_en),")
        lines.append("    .result(result)")
        lines.append("  );\n")
        
        lines.append("endmodule")
        return "\n".join(lines)
