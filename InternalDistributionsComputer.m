classdef InternalDistributionsComputer < handle
    properties (Access=private)
        nElements
        u
        Td
        coordinates
        globNodalNum
        Kel
        nNodesBeam
        nDOFsNode
    end
    
    properties (Access=public)
        pu
        pt
        Fy
        Mz
    end
    
    methods (Access=public)
        function obj=InternalDistributionsComputer(cParams)
            obj.init(cParams);
        end
        
        function compute(obj)
            obj.computeIntDis();
        end
    end
    
    methods (Access=private)
        function init (obj,cParams)
            obj.nElements    = cParams.nElements;
            obj.u            = cParams.u;
            obj.Td           = cParams.Td;
            obj.coordinates  = cParams.coordinates;
            obj.globNodalNum = cParams.globNodalNum;
            obj.Kel          = cParams.Kel;
            obj.nNodesBeam   = cParams.nNodesBeam;
            obj.nDOFsNode    = cParams.nDOFsNode;  
        end
        
        function l=computeLength(obj,e)
            x1 = obj.coordinates(obj.globNodalNum(e,1),1);
            x2 = obj.coordinates(obj.globNodalNum(e,2),1);
            l = abs(x2-x1);
        end
        
        function computeIntDis(obj)
            for e = 1 : obj.nElements
                l=obj.computeLength(e);
                for i = 1 : (obj.nNodesBeam*obj.nDOFsNode)
                    I = obj.Td(e,i);
                    u_e(i,1) = obj.u(I);
                end
                Fint = obj.Kel(:,:,e)*u_e;
                
                obj.Fy(e,1) = -Fint(1);     %Shear Force
                obj.Fy(e,2) = Fint(3);      %Shear Force
                obj.Mz(e,1) = -Fint(2);     %Bending moment
                obj.Mz(e,2) = Fint(4);      %Bending moment

                a = (1/l^3)*[2 l -2 l]*u_e;
                b = (1/l^3)*[-3*l -2*l^2 3*l -(l)^2]*u_e;
                c = (1/l^3)*[0 l^3 0 0]*u_e;
                d = (1/l^3)*[l^3 0 0 0]*u_e;
   
                obj.pu(e,[1,2,3,4]) = [a,b,c,d];
                obj.pt(e,[1,2,3]) = [3*a,2*b,c];

                if e==obj.nElements
                    uy=a*l^3+b*l^2+c*l+d;
                end 

            end
        end
    end
end