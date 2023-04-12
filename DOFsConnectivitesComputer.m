classdef DOFsConnectivitesComputer < handle 
    properties (Access=private)
        nElements
        nNodes
    end
    
    properties (Access=public)
        Td
    end
    
    methods (Access=public)
        function obj=DOFsConnectivitesComputer(cParams)
            obj.init(cParams);
        end
        
        function compute(obj)
            obj.connectDOFs();
        end
    end
    
    methods (Access=private)
        function init(obj,cParams)
            obj.nElements = cParams.nElements;
            obj.nNodes    = cParams.nNodes;
        end
        
        function connectDOFs(obj)
            obj.Td = size(obj.nElements,obj.nNodes);
            obj.Td(1,1) = 1;
            obj.Td(1,2) = 2;
            obj.Td(1,3) = 3;
            obj.Td(1,4) = 4; 
            
           for i = 2 : obj.nElements
            obj.Td(i,1) = obj.Td(i-1,3);
            obj.Td(i,2) = obj.Td(i-1,3)+1;
            obj.Td(i,3) = obj.Td(i,2)+1;
            obj.Td(i,4) = obj.Td(i,3)+1;
           end 
       
        end
    end
end