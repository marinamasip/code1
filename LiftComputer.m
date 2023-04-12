classdef LiftComputer < handle
    properties (Access=private)
        length1
        length2
        totalFlex
        elementFlex
        gravity
    end
    
    properties (Access=public)
        l
    end
    
    methods (Access=public)
        function obj=LiftComputer(cParams)
            obj.init(cParams);
        end
        
        function compute (obj)
            obj.computeLift();
        end
    end
    
    methods (Access=private)
        function init(obj,cParams)
            obj.length1     = cParams.length1;
            obj.length2     = cParams.length2;
            obj.totalFlex   = cParams.totalFlex;
            obj.elementFlex = cParams.elementFlex;
            obj.gravity     = cParams.gravity;
        end
        
        function computeLift(obj)
            syms L

            w1 = @(x) (obj.totalFlex/(4*(obj.length1+obj.length2)))+(3*obj.totalFlex/(2*obj.length2^2)).*(obj.length1-x);
            w1 =integral(w1,0,obj.length1);
            w2 =(obj.totalFlex/(4*(obj.length1+obj.length2)))*(obj.length2);
            weight =(w1+w2+obj.elementFlex)*obj.gravity;

            l1 = @(x) (0.8-0.2*cos((pi.*x)/obj.length1));
            l1 = integral(l1,0,obj.length1);
            l2 = @(x) (1-((x-obj.length1)/obj.length2)).*(1+((x-obj.length1)/obj.length2));
            l2 = integral(l2,obj.length1,(obj.length1+obj.length2));

            lift = (l1 + l2);
            eqn = L*lift - weight == 0;
            obj.l = solve(eqn,L);
            obj.l = double(obj.l);
        end
    end
end