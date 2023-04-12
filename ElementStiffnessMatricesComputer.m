classdef ElementStiffnessMatricesComputer< handle
    properties (Access=private)
        nNodesBeam
        nElements
        nDOFsNode
        coordinates
        globNodalNum
        matProp
        rowMat
    end
    
    properties (Access=public)
        Kel
    end
    
    methods (Access=public)
        function obj=ElementStiffnessMatricesComputer(cParams)
            obj.init(cParams);
        end
        
        function compute(obj)
            obj.computeKelBar();
        end
    end
    
    methods (Access=private)
        function init(obj,cParams)
           obj.nNodesBeam   = cParams.nNodesBeam;
           obj.nElements    = cParams.nElements;
           obj.nDOFsNode    = cParams.nDOFsNode;
           obj.coordinates  = cParams.coordinates;
           obj.globNodalNum = cParams.globNodalNum;
           obj.matProp      = cParams.matProp;
           obj.rowMat       = cParams.rowMat;
        end
        
        function l=computeLength(obj,e)
             x1 = obj.coordinates(obj.globNodalNum(e,1),1);
             x2 = obj.coordinates(obj.globNodalNum(e,2),1);
             l = abs(x2-x1);
        end
        
        function computeKelBar(obj)
            obj.Kel = zeros(4,4,obj.nElements);
            K = zeros(4,4);
            for e = 1 : obj.nElements
                l=obj.computeLength(e);
    
                K = (obj.matProp(obj.rowMat(e),1)*obj.matProp(obj.rowMat(e),3)/l^3) * [12 6*l -12 6*l;
                6*l 4*l^2 -6*l 2*l^2;
                -12 -6*l 12 -6*l;
                6*l 2*l^2 -6*l 4*l^2
                ];

            for r = 1 : (obj.nNodesBeam*obj.nDOFsNode)
                for s = 1 : (obj.nNodesBeam*obj.nDOFsNode)
                   obj.Kel(r,s,e) = K(r,s);
                end
            end
            end
        end
    end
end