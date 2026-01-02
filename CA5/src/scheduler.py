from abc import ABC, abstractmethod
from .dfg_creator import BaseNode, OperatorNode, OP_TYPES , IdentifierNode
from typing import List , Set

class ScheduledNodeInfo:
    def __init__(self, node : OperatorNode, scheduled_time : int, resource_num : int):
        self.node = node
        self.scheduled_time = scheduled_time
        self.resource_num = resource_num


class ListScheduler(ABC):
    def __init__(self, dfg_root : BaseNode, numof_reources : dict):
        self.root = dfg_root
        if numof_reources is None:
            self.numof_resources = {op: 1 for op in OP_TYPES}
        else:
            self.numof_resources = numof_reources

        self.scheduled_nodes_info : List[ScheduledNodeInfo] = []


    '''
        For a node, records its execution cycle and index of the resource to be executed on.
    '''
    def record_scheduled_node(self, node : OperatorNode, scheduled_time : int, resource_num : int):
        recorded_info = ScheduledNodeInfo(node=node, scheduled_time=scheduled_time, resource_num=resource_num)
        self.scheduled_nodes_info.append(recorded_info)


    '''
        Returns the list of all ScheduledNodeInfos sorted by their node id.
    '''
    def get_scheduling_info(self) -> List[ScheduledNodeInfo]:
        return sorted(self.scheduled_nodes_info, key = lambda node_info: node_info.node.id)


    '''
        Returns a list of nodes that are ready to execute at the time.
        Operands of these nodes are either an IdentifierNode or the result of an already executed OperatorNode.
    '''
    @abstractmethod
    def find_candidate_nodes(self) -> List[OperatorNode]:
        pass


    '''
        Based on the algorithm, it selects nodes from frontier to be executed on the currently available resources.
        Frontier is the output of find_candidate_nodes.
    '''
    @abstractmethod
    def select_from_frontier(self, frontier : dict) -> List[OperatorNode]:
        pass


    '''
        Performes the process of scheduling.
        It repeatedly selects some nodes from frontier to be executed at the time and records their scheduling information until there are no more nodes. 
    '''
    @abstractmethod
    def schedule(self) -> None:
        pass
    
    def _is_scheduled(self, node: OperatorNode) -> bool:
        for info in self.scheduled_nodes_info:
            if info.node.id == node.id:
                return True
        return False
    
    def _get_all_operators(self, node: BaseNode, ops: Set[OperatorNode]):
        if isinstance(node, OperatorNode):
            ops.add(node)
            for child in node.operands:
                self._get_all_operators(child, ops)





class MinLatencyScheduler(ListScheduler):
    def __init__(self, dfg_root : BaseNode, numof_resources : dict):
        super().__init__(dfg_root=dfg_root, numof_reources=numof_resources)

    # TODO
    def find_candidate_nodes(self) -> List[OperatorNode]:
        candidates = []
        all_ops = set()
        self._get_all_operators(self.root, all_ops)
        
        for op in all_ops:
            if self._is_scheduled(op):
                continue
            
            is_ready = True
            for child in op.operands:
                if isinstance(child, OperatorNode):
                    if not self._is_scheduled(child):
                        is_ready = False
                        break
            
            if is_ready:
                candidates.append(op)
        return candidates

    # TODO
    def select_from_frontier(self, frontier : List[OperatorNode]) -> List[OperatorNode]:

        frontier.sort(key=lambda x: x.depth, reverse=True) 
        
        selected = []
        resources_avail = self.numof_resources.copy()
        for node in frontier:
            res_type = node.op_type
            if resources_avail.get(res_type, 0) > 0:
                selected.append(node)
                resources_avail[res_type] -= 1
                
        return selected

    # TODO
    def schedule(self) -> None:
        current_time = 1
        all_ops = set()
        self._get_all_operators(self.root, all_ops)
        
        while len(self.scheduled_nodes_info) < len(all_ops):
            frontier = self.find_candidate_nodes()
            if not frontier:
                break
                
            selected_nodes = self.select_from_frontier(frontier)
            type_counters = {k: 1 for k in self.numof_resources.keys()}
            
            for node in selected_nodes:
                res_type = node.op_type
                res_num = type_counters.get(res_type, 1)
                type_counters[res_type] = res_num + 1
                
                self.record_scheduled_node(node, current_time, res_num)
                
            current_time += 1





    
class MinResourceScheduler(ListScheduler):
    def __init__(self, dfg_root : BaseNode, numof_resources : dict, max_time : int):
        super().__init__(dfg_root=dfg_root, numof_reources=numof_resources)
        self.max_time = max_time
        self.latest_time = self.find_latest_times()


    '''
        Assigns the latest possible time for each node to be executed.
        It's used on Minimum-Resource, Latency-Constrained algorithm.
    '''
    # TODO
    def find_latest_times(self) -> dict:
        latest_time = dict()

        def compute_alap(node: BaseNode, deadline: int):
            if isinstance(node, IdentifierNode):
                return
                
            if isinstance(node, OperatorNode):
                if node.id in latest_time:
                    latest_time[node.id] = min(latest_time[node.id], deadline)
                else:
                    latest_time[node.id] = deadline
                
                for child in node.operands:
                    compute_alap(child, deadline - 1)

        compute_alap(self.root, self.max_time)
        return latest_time
   
    # TODO
    def find_candidate_nodes(self) -> List[OperatorNode]:
        candidates = []
        all_ops = set()
        self._get_all_operators(self.root, all_ops)
        
        for op in all_ops:
            if self._is_scheduled(op):
                continue
            
            is_ready = True
            for child in op.operands:
                if isinstance(child, OperatorNode):
                    if not self._is_scheduled(child):
                        is_ready = False
                        break
            if is_ready:
                candidates.append(op)
        return candidates

    # TODO
    def select_from_frontier(self, frontier : List[OperatorNode], current_time : int) -> List[OperatorNode]:

        frontier.sort(key=lambda x: self.latest_time.get(x.id, self.max_time) - current_time)
        selected = []
        usage_this_cycle = {op_type: 0 for op_type in OP_TYPES}
        
        for node in frontier:
            slack = self.latest_time.get(node.id, self.max_time) - current_time
            res_type = node.op_type

            if usage_this_cycle[res_type] < self.numof_resources.get(res_type, 0):
                selected.append(node)
                usage_this_cycle[res_type] += 1

            elif slack <= 0:
                print(f"Adding 1 {res_type} because node {node.id} has 0 slack.")
                self.numof_resources[res_type] = self.numof_resources.get(res_type, 0) + 1
                selected.append(node)
                usage_this_cycle[res_type] += 1
                
        return selected

    # TODO
    def schedule(self) -> None:
        current_time = 1
        all_ops = set()
        self._get_all_operators(self.root, all_ops)
        
        while len(self.scheduled_nodes_info) < len(all_ops):
            frontier = self.find_candidate_nodes()
            if not frontier:
                break

            selected_nodes = self.select_from_frontier(frontier, current_time)
            
            type_counters = {k: 1 for k in self.numof_resources.keys()}
            
            for node in selected_nodes:
                res_type = node.op_type
                res_num = type_counters.get(res_type, 1)
                type_counters[res_type] = res_num + 1
                
                self.record_scheduled_node(node, current_time, res_num)
                
            current_time += 1