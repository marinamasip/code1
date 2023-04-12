classdef ElementForceVectorComputer < handle
    properties (Access=private)
        q
        nNodesBeam
        nElements
        nDOFsNode
        coordinates
        globNodalNum
    end
    
    properties (Access=public)
        Fel
    end
    
    methods (Access=public)
        function obj=ElementForceVectorComputer(cParams)
            obj.init(cParams);
        end
        
        function compute(obj)
            obj.computeElForVec();
        end
    end
    
    methods (Access=private)
        function init(obj,cParams)
            obj.q            = cParams.q;
            obj.nNodesBeam   = cParams.nNodesBeam;
            obj.nElements    = cParams.nElements;
            obj.nDOFsNode    = cParams.nDOFsNode;
            obj.coordinates  = cParams.coordinates;
            obj.globNodalNum = cParams.globNodalNum; 
        end
        
        function l=computeLength(obj,e)
            x1 = obj.coordinates(obj.globNodalNum(e,1),1);
            x2 = obj.coordinates(obj.globNodalNum(e,2),1);
            l = abs(x2-x1);
        end
        
        function computeElForVec(obj)
            for e=1:obj.nElements
                l=obj.computeLength(e);
                F=(obj.q(e)*l/2)*[1;(l/6);1;-(l/6)];

                for r=1:(obj.nNodesBeam*obj.nDOFsNode)
                    obj.Fel(r,e)=F(r);
                end
            end
        end
    end
end
