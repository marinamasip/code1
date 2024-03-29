classdef Solver < handle
    
    properties (Access = protected)
       LHS     
       RHS 
       type
    end
    
    properties (Access = public)
        x
    end
    
    methods (Access = public,Static)
        function obj = create(cParam)
            switch cParam.type
                case 'Direct'
                    obj = DirectSolver(cParam);
                case 'Iterative'
                    obj = IterativeSolver(cParam);
            end
        end
    end
    methods (Access = protected)
        function init(obj,cParam)
            obj.LHS = cParam.LHS;
            obj.RHS = cParam.RHS; 
        end
   
    end
    
end


    
    