classdef GlobalMatrixAssembler < handle 
    properties (Access=private)
        nNodesBeam
        totalNumDOFs
        nElements
        nDOFsNode
        Td
        Kel
        Fel
        elementFlex
        gravity
    end
    
    properties(Access=public)
        KG
        Fext
    end
    
    methods (Access=public)
        function obj=GlobalMatrixAssembler(cParams)
            obj.init(cParams);
        end
        
        function compute(obj)
            obj.assemblyKG();
        end    
    end
    
    methods (Access=private)
        function init(obj,cParams)
            obj.nNodesBeam   = cParams.nNodesBeam;
            obj.totalNumDOFs = cParams.totalNumDOFs;
            obj.nElements    = cParams.nElements;
            obj.nDOFsNode    = cParams.nDOFsNode;
            obj.Td           = cParams.Td;
            obj.Kel          = cParams.Kel;
            obj.Fel          = cParams.Fel;
            obj.elementFlex  = cParams.elementFlex;
            obj.gravity      = cParams.gravity; 
        end
        
        function assemblyKG(obj)
            obj.Fext=zeros(obj.totalNumDOFs,1);
            obj.Fext((obj.nElements)*(2/3)+2,1)=-obj.elementFlex*obj.gravity;
            obj.KG=zeros(obj.totalNumDOFs,obj.totalNumDOFs);
            for e =1:obj.nElements
                for i=1:(obj.nNodesBeam*obj.nDOFsNode)
                    I=obj.Td(e,i);
                    obj.Fext(I)=obj.Fext(I)+obj.Fel(i,e);
                    for j=1:(obj.nNodesBeam*obj.nDOFsNode)
                        J=obj.Td(e,j);
                        obj.KG(I,J)=obj.KG(I,J)+obj.Kel(i,j,e);
                    end
                end
            end
        end
    end
end