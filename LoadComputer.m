classdef LoadComputer < handle
    properties (Access=private)
        length1
        length2
        totalFlex
        globNodalNum
        coordinates
        gravity
        lift
        nElements
    end
    
    properties (Access=public)
        q
    end
    
    methods (Access = public)
        function obj=LoadComputer(cParams)
            obj.init(cParams);
        end
        
        function compute (obj)
            obj.computeq();
        end
    end
    
    methods (Access=private)
        function init(obj,cParams)
        obj.length1      = cParams.length1;
        obj.length2      = cParams.length2;
        obj.totalFlex    = cParams.totalFlex;
        obj.globNodalNum = cParams.globNodalNum;
        obj.coordinates  = cParams.coordinates;
        obj.gravity      = cParams.gravity;
        obj.nElements    = cParams.nElements; 
        obj.lift         = cParams.lift;
        end
        
        function computeq(obj)
            for e = 1 : obj.nElements
                if obj.coordinates(obj.globNodalNum(e,2),1) <= obj.length1
                    lim1 = obj.coordinates(obj.globNodalNum(e,1),1);
                    lim2 = obj.coordinates(obj.globNodalNum(e,2),1);
                    f = @(x)obj.lift*(0.8-0.2*cos((pi.*x)/obj.length1))-obj.gravity*((obj.totalFlex/(4*(obj.length1+obj.length2)))+(3*obj.totalFlex/(2*obj.length2^2)).*(obj.length1-x));
                    f = integral(f,lim1,lim2);
                    f = f / (lim2-lim1);
                else
                    lim1 = obj.coordinates(obj.globNodalNum(e,1),1);
                    lim2 = obj.coordinates(obj.globNodalNum(e,2),1);
                    f = @(x)obj.lift*(1-((x-obj.length1 )/obj.length2)).*(1+((x-obj.length1)/obj.length2))-obj.gravity*(obj.totalFlex/(4*(obj.length1+obj.length2)));
                    f = integral(f,lim1,lim2);
                    f = f / (lim2-lim1);
                end
                obj.q(e) = f;
            end   
        end
    end
end